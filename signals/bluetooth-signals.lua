local spawn = require("awful.spawn")
local gtimer = require("gears.timer")

spawn.easy_async_with_shell(
    "bluetoothctl show | grep -o 'Powered: yes'", function(stdout)
        awesome.emit_signal("bluetooth::state", stdout ~= "")
    end
)

local current_stdout
local function emit_devices_signal()
    spawn.easy_async_with_shell(
        [[bash -c 'bluetoothctl devices Connected | cut -d" " -f3-']], function(stdout)
            if stdout == "" or stdout == current_stdout then
                return
            end

            local devices = {}
            for line in stdout:gmatch("[^\n]+") do
                table.insert(devices, line)
            end

            awesome.emit_signal("bluetooth::devices", table.concat(devices, ", "))
            current_stdout = stdout
        end
    )
end

local timer = gtimer {
    timeout = 4,
    autostart = true,
    callback = emit_devices_signal
}

awesome.connect_signal(
    "bluetooth::state", function(state)
        if state then
            timer:start()
        else
            current_stdout = nil
            timer:stop()
        end
    end
)
