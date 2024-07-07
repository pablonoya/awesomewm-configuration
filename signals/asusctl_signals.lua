local spawn = require("awful.spawn")

local _signals = {}

function _signals.emit_profile()
    spawn.easy_async_with_shell(
        "asusctl profile -p | tail -n +2 | awk '{print $NF}'", function(stdout)
            awesome.emit_signal("asusctl::profile", stdout:gsub("\n", ""))
        end
    )
end

function _signals.keyboard_brightness()
    spawn.easy_async_with_shell(
        "asusctl -k | awk '/Current keyboard led brightness/ {print $NF}'", function(stdout)
            local value = 0
            if stdout:match("Low") then
                value = 33
            elseif stdout:match("Med") then
                value = 66
            elseif stdout:match("High") then
                value = 100
            end

            awesome.emit_signal("brightness::keyboard", value)
        end
    )
end

-- Check initial states
_signals.emit_profile()

return _signals
