local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")

local function format_date(date_str, short)
    local year, month, day = date_str:match("(%d+)-(%d+)-(%d+)")
    local weekday = os.date(
        "%a", os.time {
            year = year,
            month = month,
            day = day
        }
    )

    if not short then
        return weekday .. "\n" .. day
    end
    return weekday:sub(1, 1) .. "." .. day
end

local format_time = function(time_str)
    local hour, minute = time_str:match("(%d+):(%d+)")
    hour = tonumber(hour)

    local hour_12h = hour > 12 and (hour % 12) or hour
    local minute = minute ~= "00" and (":" .. minute) or ""
    local period = hour >= 12 and " PM" or " AM"

    return hour_12h .. minute .. period
end

local event_date = {
    font = beautiful.font_name .. "Bold 10",
    valign = "top",
    halign = "center",
    line_spacing_factor = 0.9,
    widget = wibox.widget.textbox
}

local description = {
    font = beautiful.font_name .. 11,
    widget = wibox.widget.textbox
}

local function calendar_event(event)
    local many_days = event.start_date ~= event.end_date

    if many_days then
        event_date.text = format_date(event.start_date, many_days)
        event_date.text = event_date.text .. "\n" .. format_date(event.end_date, many_days)
    else
        event_date.text = format_date(event.start_date)
    end

    local time_range = format_time(event.start_time) .. " - " .. format_time(event.end_time)
    description.markup = "<b>" .. event.summary .. "</b>\n" .. time_range

    return wibox.widget {
        {
            {
                {
                    event_date,
                    top = dpi(6),
                    widget = wibox.container.margin
                },
                forced_width = dpi(40),
                fg = beautiful.black,
                bg = event.calendar_color,
                widget = wibox.container.background
            },
            {
                description,
                top = dpi(4),
                bottom = dpi(4),
                left = dpi(8),
                widget = wibox.container.margin
            },
            layout = wibox.layout.align.horizontal
        },
        bg = beautiful.xbackground,
        shape = helpers.rrect(beautiful.border_radius / 2),
        widget = wibox.container.background
    }
end

return calendar_event
