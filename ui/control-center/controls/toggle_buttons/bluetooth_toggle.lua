local beautiful = require("beautiful")
local spawn = require("awful.spawn")

local toggle_button = require("ui.widgets.toggle_button")

local signal_label = "bluetooth::devices"

local function onclick()
    spawn.easy_async_with_shell(
        [[
            if [ -z $(bluetoothctl show | grep -o "Powered: no") ]; then
                bluetoothctl power off > /dev/null
            else
                bluetoothctl power on
            fi
        ]], function(stdout)
            awesome.emit_signal(signal_label, stdout ~= "")
        end
    )
end

return toggle_button {
    icon = "\u{e1a7}",
    name = "Bluetooth",
    active_color = beautiful.cyan,
    signal_label = signal_label,
    onclick = onclick
}
