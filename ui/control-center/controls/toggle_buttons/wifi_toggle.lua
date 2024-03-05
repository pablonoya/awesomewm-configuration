local spawn = require("awful.spawn")

local toggle_button = require("ui.widgets.toggle_button")

local signal_label = "wifi::ssid"

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
            awesome.emit_signal(signal_label, stdout ~= "")
        end
    )
end

return toggle_button {
    icon = "\u{e63e}",
    name = "Wi-Fi",
    signal_label = signal_label,
    onclick = onclick
}
