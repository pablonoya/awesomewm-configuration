local beautiful = require("beautiful")
local gshape = require("gears.shape")

local text_icon = require("ui.widgets.text-icon")
local clickable_container = require("ui.widgets.clickable-container")

return clickable_container {
    widget = text_icon {
        text = "\u{e8ac}",
        size = 16
    },
    bg_focused = beautiful.red,
    fg = beautiful.red,
    fg_focused = beautiful.xbackground,
    margins = dpi(4),
    shape = gshape.circle,
    border_color = beautiful.red,
    border_width = dpi(1),
    action = function()
        awesome.emit_signal("exit_screen::show")
    end
}
