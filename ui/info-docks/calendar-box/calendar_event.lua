local beautiful = require("beautiful")
local wibox = require("wibox")
local gstring = require("gears.string")

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

    if short then
        return weekday:sub(1, 1) .. "." .. day
    end
    return string.format("<small>%s</small>\n<b>%s</b>", weekday, day)
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
    font = beautiful.font_name .. "Medium 12",
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
        event_date.font = beautiful.font_name .. "Medium 11"
        event_date.markup = format_date(event.start_date, many_days) .. "\n" ..
                                format_date(event.end_date, many_days)
    else
        event_date.font = beautiful.font_name .. "Medium 12"
        event_date.markup = format_date(event.start_date)
    end

    description.markup = "<b>" .. gstring.xml_escape(event.summary) .. "</b>\n" ..
                             format_time(event.start_time) .. " - " .. format_time(event.end_time)

    return wibox.widget {
        {
            event_date,
            forced_width = dpi(40),
            top = dpi(2),
            widget = wibox.container.margin
        },
        {
            {
                description,
                top = dpi(3),
                bottom = dpi(3),
                left = dpi(8),
                widget = wibox.container.margin
            },
            bg = event.calendar_color .. "B0",
            shape = helpers.rrect(beautiful.border_radius / 2),
            widget = wibox.container.background
        },
        spacing = dpi(8),
        fill_space = true,
        layout = wibox.layout.fixed.horizontal
    }
end

return calendar_event
