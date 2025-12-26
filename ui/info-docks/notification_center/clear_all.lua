local beautiful = require("beautiful")
local gshape = require("gears.shape")

local text_icon = require("ui.widgets.text-icon")
local clickable_container = require("ui.widgets.clickable-container")

return clickable_container {
    widget = text_icon {
        text = "\u{e0b8}",
        size = 16,
        fill = 0
    },
    shape = gshape.circle,
    margins = dpi(4),
    bg_focused = beautiful.red .. "40",
    fg_focused = beautiful.red,
    action = clear_all_notifications
}
