local beautiful = require("beautiful")

local system_controls = require("helpers.system_controls")

local toggle_button = require("ui.widgets.toggle_button")

return toggle_button {
    icon = "\u{e9e4}",
    name = "Profile",
    active_color = beautiful.cyan,
    onclick = system_controls.next_asusctl_profile,
    signal_label = "asusctl::profile"
}
