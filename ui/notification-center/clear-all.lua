local awful = require("awful")
local wibox = require("wibox")
local gshape = require("gears.shape")

local text_icon = require("ui.widgets.text-icon")
local clickable_container = require("ui.widgets.clickable-container")

local clear_all_button = clickable_container {
    widget = {
        text_icon {
            text = "\u{e0b8}",
            size = 18
        },
        margins = dpi(4),
        widget = wibox.container.margin
    },
    shape = gshape.circle,
    action = clear_notifications
}

return clear_all_button
