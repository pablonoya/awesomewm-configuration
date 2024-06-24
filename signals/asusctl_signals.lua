local spawn = require("awful.spawn")

local _signals = {}

function _signals.emit_profile()
    spawn.easy_async_with_shell(
        "asusctl profile -p | tail -n +2 | awk '{print $NF}'", function(stdout)
            awesome.emit_signal("asusctl::profile", stdout:gsub("\n", ""))
        end
    )
end

-- Check initial states
_signals.emit_profile()

return _signals
