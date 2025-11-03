local beautiful = require("beautiful")
local spawn = require("awful.spawn")
local gtimer = require("gears.timer")

local function emit_devices_signal()
    spawn.easy_async_with_shell(
        [[bash -c 'bluetoothctl devices Connected | grep 'Device' | cut -d" " -f3-']],
        function(stdout)
            local devices = {}
            for line in stdout:gmatch("[^\n]+") do
                table.insert(devices, line)
            end
            if #devices > 0 then
                awesome.emit_signal(
                    "bluetooth::devices", table.concat(devices, ", "), beautiful.blue
                )
            else
                awesome.emit_signal("bluetooth::devices", "Bluetooth")
            end
        end
    )
end

local timer = gtimer {
    timeout = 3,
    call_now = true,
    callback = emit_devices_signal
}

awesome.connect_signal(
    "control_center::visible", function(state)
        if state then
            emit_devices_signal()
            timer:start()
        else
            timer:stop()
        end
    end
)
