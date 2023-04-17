local spawn = require("awful.spawn")

spawn.easy_async_with_shell(
    "bluetoothctl show | grep -o 'Powered: yes'", function(stdout)
        awesome.emit_signal("bluetooth::state", stdout ~= "")
    end
)
