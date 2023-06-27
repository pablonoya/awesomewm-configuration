local button = require("awful.button")
local beautiful = require("beautiful")
local gtable = require("gears.table")
local naughty = require("naughty")
local wibox = require("wibox")

local helpers = require("helpers")
local color_helpers = require("helpers.color-helpers")

local border_container = require("ui.widgets.border-container")
local clickable_container = require("ui.widgets.clickable-container")
local text_icon = require("ui.widgets.text-icon")

local bell = text_icon {
    markup = helpers.colorize_text("\u{e7f4}", beautiful.moon),
    size = 14,
    widget = wibox.widget.textbox
}

naughty.connect_signal(
    "property::suspended", function(_, suspended)
        if suspended then
            bell.markup = helpers.colorize_text("\u{e7f6}", beautiful.accent)
        else
            bell.markup = helpers.colorize_text("\u{e7f4}", beautiful.moon)
        end
    end
)

return function(is_vertical)
    local get_datetime_format = function()
        return (
            "%a" .. color_helpers.colorize_by_time_of_day("<b>.</b>") .. "%d"
            .. (is_vertical and "\n" or " ") 
            .. "<b>%I" .. color_helpers.colorize_by_time_of_day(":") .. "%M</b>"
        )
    end

    local datetime = wibox.widget {
        font = beautiful.font_name .. (is_vertical and 12 or 13),
        format = get_datetime_format(),
        refresh = 2,
        ellipsize = "none",
        halign = "center",
        line_spacing_factor = "0.9",
        widget = wibox.widget.textclock
    }

    datetime:connect_signal(
        "widget::redraw_needed", function()
            datetime.format = get_datetime_format()
        end
    )

    local notifs_datetime = clickable_container {
        widget = {
            {
                bell,
                datetime,
                spacing = dpi(4),
                widget = wibox.layout.fixed.horizontal
            },
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin
        },
        shape = helpers.rrect(beautiful.border_radius),
        action = function()
            awesome.emit_signal("notification_center::toggle")
        end
    }

    awesome.connect_signal(
        "notification_center::visible", function(visible)
            notifs_datetime.bg = visible and beautiful.focus or beautiful.wibar_bg
            notifs_datetime.focused = visible
        end
    )

    return border_container {
        widget = notifs_datetime
    }
end
