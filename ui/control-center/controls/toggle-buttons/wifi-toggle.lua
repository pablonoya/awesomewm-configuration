local spawn = require("awful.spawn")
local beautiful = require("beautiful")

local toggle_button = require("ui.widgets.toggle-button")

local function onclick()
    spawn.easy_async_with_shell(
        [[
            if [ $(nmcli radio wifi ) = 'enabled' ]; then
                nmcli radio wifi off
            else
                nmcli radio wifi on
                echo 'ON'
            fi
        ]], function(stdout)
            awesome.emit_signal("wifi::state", stdout ~= "")
        end
    )
end

local signal = function(callback)
    awesome.connect_signal("wifi::state", callback)
end

return toggle_button("\u{e63e}", "Wi-Fi", beautiful.accent, onclick, signal, "wifi::ssid")
