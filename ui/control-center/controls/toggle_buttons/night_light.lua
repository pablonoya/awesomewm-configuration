local spawn = require("awful.spawn")
local beautiful = require("beautiful")

local toggle_button = require("ui.widgets.toggle_button")

local signal_label = "blue_light:state"

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
            fi ]], beautiful.latitude, beautiful.longitude
        ), function(stdout)
            awesome.emit_signal(signal_label, stdout:match("ON"))
        end
    )
end

return toggle_button {
    icon = "\u{ef44}",
    name = "Night light",
    active_color = beautiful.moon,
    signal_label = signal_label,
    onclick = onclick
}
