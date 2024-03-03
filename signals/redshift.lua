local spawn = require("awful.spawn")

spawn.easy_async_with_shell(
    "pgrep redshift", function(stdout)
        awesome.emit_signal("nightlight::state", stdout ~= "")
    end
)
