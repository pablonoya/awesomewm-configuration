local gshape = require("gears.shape")
local wibox = require("wibox")

local clickable_container = require("ui.widgets.clickable-container")
local text_icon = require("ui.widgets.text-icon")

local function capitalize(s)
    return s:sub(1, 1):upper() .. s:sub(2)
end

local function icon_button(markup, signal_action)
    return clickable_container {
        widget = text_icon {
            markup = markup,
            size = 16
        },
        shape = gshape.circle,
        margins = dpi(2),
        action = function()
            awesome.emit_signal("calendar::date", signal_action)
        end
    }
end

local previous = icon_button("\u{e5cb}", "previous_month")
local next = icon_button("\u{e5cc}", "next_month")
local cal = icon_button("\u{e8df}", "today")

return function(widget)
    widget.markup = "<b>" .. capitalize(widget.text) .. "</b>"

    return {
        {
            widget,
            left = dpi(6),
            widget = wibox.container.margin
        },
        nil,
        {
            previous,
            cal,
            next,
            layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal,
        forced_height = dpi(28)
    }
end
