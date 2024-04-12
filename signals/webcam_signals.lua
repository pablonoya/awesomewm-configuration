local spawn = require("awful.spawn")
local gtimer = require("gears.timer")

local last_value = false
local function emit_signal()
    spawn.easy_async_with_shell(
        "fuser /dev/video0 2> /dev/null | awk '{print NF}'", function(stdout)
            local active = stdout ~= "" and tonumber(stdout) > 1

            if last_value ~= active then
                awesome.emit_signal("webcam::active", active)
                last_value = active
            end
        end
    )
end

local timer = gtimer {
    timeout = 5,
    call_now = true,
    autostart = true,
    callback = emit_signal
}
