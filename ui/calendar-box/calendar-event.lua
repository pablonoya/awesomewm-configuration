local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")

local function format_date(date_str)
    local year, month, day = date_str:match("(%d+)-(%d+)-(%d+)")

    return os.date(
        "%a.%d", os.time {
            year = year,
            month = month,
            day = day
        }
    )
end

local format_time = function(time_str)
    local hour, minute = time_str:match("(%d+):(%d+)")

    local hour_12h = (hour % 12)
    local minute = minute ~= "00" and (":" .. minute) or ""
    local period = tonumber(hour) >= 12 and " PM" or " AM"

    return hour_12h .. minute .. period
end

local title = {
    font = beautiful.font_name .. "Bold 10",
    halign = "center",
    line_spacing_factor = 0.9,
    widget = wibox.widget.textbox
}

local description = {
    font = beautiful.font_name .. 11,
    widget = wibox.widget.textbox
}

local function calendar_event(event)
    title.text = format_date(event.start_date)
    if event.start_date ~= event.end_date then
        title.text = title.text .. "\n" .. format_date(event.end_date)
    end

    local time_range = format_time(event.start_time) .. " - " .. format_time(event.end_time)
    description.markup = "<b>" .. event.summary .. "</b>\n" .. time_range

    return wibox.widget {
        {
            {
                {
                    title,
                    margins = dpi(4),
                    widget = wibox.container.margin
                },
                forced_width = dpi(56),
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
            layout = wibox.layout.fixed.horizontal
        },
        bg = beautiful.xbackground,
        shape = helpers.rrect(beautiful.border_radius / 2),
        widget = wibox.container.background
    }
end

return calendar_event
