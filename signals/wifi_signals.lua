local spawn = require("awful.spawn")
local gtimer = require("gears.timer")

local last_ssid
local function emit_ssid_signal()
    spawn.easy_async_with_shell(
        "iwgetid -r", function(stdout)
            if stdout == "" then
                return
            end
            awesome.emit_signal("wifi::ssid", stdout:gsub("\n", ""))
        end
    )
end

local timer = gtimer {
    timeout = 3,
    call_now = true,
    callback = emit_ssid_signal
}

awesome.connect_signal(
    "control_center::visible", function(visible)
        if visible then
            emit_ssid_signal()
            timer:start()
        else
            timer:stop()
        end
    end
)
