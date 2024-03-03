local spawn = require("awful.spawn")

spawn.easy_async_with_shell(
    "asusctl profile -p | awk '{print $NF}'", function(stdout)
        awesome.emit_signal("asusctl::profile", stdout:gsub("\n", ""))
    end
)
