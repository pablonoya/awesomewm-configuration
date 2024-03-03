local helpers = require("helpers")
local toggle_button = require("ui.widgets.toggle_button")

return toggle_button {
    icon = "\u{e7f6}",
    name = "Silent mode",
    signal_label = "notifications::suspended",
    onclick = helpers.toggle_silent_mode
}
