local beautiful = require("beautiful")
local gshape = require("gears.shape")
local wibox = require("wibox")

local helpers = require("helpers")

local border_container = require("ui.widgets.border-container")
local clickable_container = require("ui.widgets.clickable-container")
local text_icon = require("ui.widgets.text-icon")

local function capitalize(s)
    return s:sub(1, 1):upper() .. s:sub(2)
end

local function icon_button(markup)
    return clickable_container {
        widget = text_icon {
            markup = markup,
            size = 19
        },
        shape = gshape.circle
    }
end

local previous = icon_button("\u{e5cb}")
local next = icon_button("\u{e5cc}")
local today = border_container {
    widget = clickable_container {
        widget = wibox.widget {
            markup = "today",
            font = beautiful.font_name .. 11,
            widget = wibox.widget.textbox
        },
        margins = {
            left = dpi(4),
            right = dpi(4)
        },
        shape = helpers.rrect(beautiful.border_radius / 2)
    },
    shape = helpers.rrect(beautiful.border_radius / 2)
}

helpers.add_action(
    previous, function()
        awesome.emit_signal("calendar::date", "previous_month")
    end
)
helpers.add_action(
    next, function()
        awesome.emit_signal("calendar::date", "next_month")
    end
)
helpers.add_action(
    today, function()
        awesome.emit_signal("calendar::date", "today")
    end
)

return function(widget)
    widget.markup = "<b>" .. capitalize(widget.text) .. "</b>"

    return {
        {
            previous,
            next,
            layout = wibox.layout.fixed.horizontal
        },
        widget,
        today,
        layout = wibox.layout.align.horizontal
    }
end
