local spawn = require("awful.spawn")
local beautiful = require("beautiful")

local _signals = {}

local profile_styles = {
    Quiet = {
        color = beautiful.green,
        roundness = 12
    },
    Balanced = {
        color = beautiful.cyan,
        roundness = 20
    },
    Performance = {
        color = beautiful.accent,
        roundness = 24
    }
}

function _signals.emit_profile()
    spawn.easy_async_with_shell(
        "asusctl profile -p | tail -n +2 | awk '{print $NF}'", function(stdout)
            local profile = stdout:gsub("\n", "")
            local style = profile_styles[profile]
            awesome.emit_signal("asusctl::profile", profile, style.color, style.roundness)
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
