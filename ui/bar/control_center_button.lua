local beautiful = require("beautiful")
local wibox_container = require("wibox.container")

local helpers = require("helpers")
local ui_helpers = require("helpers.ui_helpers")

local text_icon = require("ui.widgets.text-icon")
local clickable_container = require("ui.widgets.clickable-container")

local icon = text_icon {
    markup = "\u{f614}",
    size = 20,
    fill = 0
}
local control_center_button = clickable_container {
    widget = icon,
    margins = dpi(4)
}

helpers.add_action(
    control_center_button, function()
        awesome.emit_signal("control_center::toggle")
    end
)

awesome.connect_signal(
    "control_center::visible", function(visible)
        ui_helpers.toggle_filled_icon(icon, 20, visible)

        control_center_button.bg = visible and beautiful.focus or beautiful.transparent
        control_center_button.focused = visible
    end
)

return {
    control_center_button,
    left = dpi(4),
    right = dpi(4),
    widget = wibox_container.margin
}
