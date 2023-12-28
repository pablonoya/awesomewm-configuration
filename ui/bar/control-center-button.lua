local beautiful = require("beautiful")
local wibox_container = require("wibox.container")

local helpers = require("helpers")

local text_icon = require("ui.widgets.text-icon")
local clickable_container = require("ui.widgets.clickable-container")

local control_center_button = clickable_container {
    widget = text_icon {
        text = "\u{f614}",
        size = 20
    },
    margins = dpi(4)
}

helpers.add_action(
    control_center_button, function()
        awesome.emit_signal("control_center::toggle")
    end
)

awesome.connect_signal(
    "control_center::visible", function(visible)
        control_center_button.bg = visible and beautiful.focus or beautiful.transparent
        control_center_button.focused = visible
    end
)

return {
    control_center_button,
    left = dpi(4),
    widget = wibox_container.margin
}
