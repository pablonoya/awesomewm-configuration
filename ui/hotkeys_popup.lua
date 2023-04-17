local hotkeys_popup = require("awful.hotkeys_popup")

local new_labels = {
    XF86PowerOff = "PowerOff",
    XF86KbdBrightnessDown = "⌨🔆-",
    XF86KbdBrightnessUp = "⌨🔆+",
    XF86Launch4 = "Fan",
    XF86AudioMicMute = "🎙️🚫"
}

for k, v in pairs(new_labels) do
    hotkeys_popup.widget.labels[k] = v
end

return hotkeys_popup
