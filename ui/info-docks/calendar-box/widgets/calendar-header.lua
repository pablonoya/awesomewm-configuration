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
local cal = icon_button("\u{e8df}")

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
    cal, function()
        awesome.emit_signal("calendar::date", "today")
    end
)

return function(widget)
    widget.markup = "<b>" .. capitalize(widget.text) .. "</b>"

    return {
        widget,
        nil,
        {
            previous,
            cal,
            next,
            layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
    }
end
