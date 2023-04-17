local spawn = require("awful.spawn")
local beautiful = require("beautiful")

local toggle_button = require("ui.widgets.toggle-button")

local function onclick()
    spawn.easy_async_with_shell(
        [[
            if [ -z $(bluetoothctl show | grep -o "Powered: no") ]; then
                bluetoothctl power off > /dev/null
            else
                bluetoothctl power on
            fi
        ]], function(stdout)
            awesome.emit_signal("bluetooth::state", stdout ~= "")
        end
    )
end

local signal = function(callback)
    awesome.connect_signal("bluetooth::state", callback)
end

return toggle_button("\u{e1a7}", "Bluetooth", beautiful.accent, onclick, signal)
