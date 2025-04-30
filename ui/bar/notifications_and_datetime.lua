local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")

local helpers = require("helpers")
local color_helpers = require("helpers.color-helpers")
local ui_helpers = require("helpers.ui_helpers")

local border_container = require("ui.widgets.border-container")
local clickable_container = require("ui.widgets.clickable-container")
local text_icon = require("ui.widgets.text-icon")

local bell = text_icon {
    markup = color_helpers.colorize_text("\u{e7f4}", beautiful.moon),
    size = 16,
    fill = 0
}

awesome.connect_signal(
    "notifications::suspended", function(suspended)
        if suspended then
            bell.markup = color_helpers.colorize_text("\u{e7f6}", beautiful.accent)
        else
            bell.markup = color_helpers.colorize_text("\u{e7f4}", beautiful.moon)
        end
    end
)

awesome.connect_signal(
    "notification_center::visible", function(visible)
        ui_helpers.toggle_filled_icon(bell, 16, visible)
    end
)

local function get_datetime_format(is_vertical)
    local time = "<b>%I" .. color_helpers.colorize_by_time_of_day(":") .. "%M</b>"
    local date = "%a" .. color_helpers.colorize_by_time_of_day("<b>.</b>") .. "%d"

    return (date .. (is_vertical and "\n" or " ") .. time)
end

return function(is_vertical)
    local datetime = wibox.widget {
        font = beautiful.font_name .. (is_vertical and 12 or 13),
        format = get_datetime_format(is_vertical),
        refresh = 2,
        ellipsize = "none",
        halign = "center",
        line_spacing_factor = "0.9",
        widget = wibox.widget.textclock
    }

    datetime:connect_signal(
        "widget::redraw_needed", function()
            datetime.format = get_datetime_format(is_vertical)
        end
    )

    local container = clickable_container {
        widget = {
            {
                datetime,
                bell,
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
            container.bg = visible and beautiful.focus or beautiful.wibar_bg
            container.focused = visible
        end
    )

    return border_container {
        widget = container
    }
end
