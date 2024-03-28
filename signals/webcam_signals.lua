local spawn = require("awful.spawn")
local gtimer = require("gears.timer")

local last_value = false
local function emit_signal()
    spawn.easy_async_with_shell(
        "fuser /dev/video0 > /dev/null 2>&1", function(stdout, stderr, exitreason, exitcode)
            local active = exitcode == 0

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
