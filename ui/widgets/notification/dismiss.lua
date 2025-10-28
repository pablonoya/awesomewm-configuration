local beautiful = require("beautiful")

local helpers = require("helpers")

local text_icon = require("ui.widgets.text-icon")
local clickable_container = require("ui.widgets.clickable-container")

return function()
    return clickable_container {
        widget = text_icon {
            text = "\u{e5cd}",
            size = 14
        },
        visible = false,
        shape = helpers.rrect(4),
        bg = beautiful.focus,
        bg_focused = beautiful.red,
        fg_focused = beautiful.black
    }
end
