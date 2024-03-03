local spawn = require("awful.spawn")
local beautiful = require("beautiful")

local toggle_button = require("ui.widgets.toggle-button")

local function onclick()
    spawn.easy_async_with_shell(
        string.format(
            [[
            if [ ! -z $(pgrep redshift) ]; then
                pkill redshift &
                echo 'OFF'
            else
                redshift -l %s:%s -t 6500:4200 &>/dev/null &
                echo 'ON'
            fi
        ]], beautiful.latitude, beautiful.longitude
        ), function(stdout)
            awesome.emit_signal("blue_light:state", stdout:match("ON"))
        end
    )
end

local signal = function(callback)
    awesome.connect_signal("blue_light:state", callback)
end

return toggle_button("\u{ef44}", "Night light", beautiful.moon, onclick, signal)
