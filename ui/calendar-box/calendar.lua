local beautiful = require("beautiful")
local wibox = require("wibox")

local header = require("ui.calendar-box.widgets.calendar-header")
local weekday = require("ui.calendar-box.widgets.calendar-weekday")
local day = require("ui.calendar-box.widgets.calendar-day")

local function decorate_cell(widget, flag, date)
    if flag == "header" then
        return header(widget)

    elseif flag == "weekday" then
        return weekday(widget)

    elseif flag == "normal" or flag == "focus" then
        return day(widget, flag, date)

    elseif flag == "month" then
        return {
            widget,
            top = dpi(8),
            bottom = dpi(4),
            widget = wibox.container.margin
        }
    end
    return widget
end

local calendar = wibox.widget {
    date = os.date("*t"),
    font = "Manrope 12",
    long_weekdays = true,
    fn_embed = decorate_cell,
    spacing = dpi(2),
    widget = wibox.widget.calendar.month
}

awesome.connect_signal(
    "calendar::date", function(action)
        local date = calendar:get_date()
        local current_date = os.date("*t")

        if action == "next_month" then
            date.month = date.month + 1
        elseif action == "previous_month" then
            date.month = date.month - 1
        else -- reset date
            date = current_date
        end

        date.day = (current_date.month == date.month) and current_date.day

        calendar:set_date(nil)
        calendar:set_date(date)
    end
)

local calendar_widget = wibox.widget {
    calendar,
    halign = "center",
    valign = "top",
    widget = wibox.container.place
}

return calendar_widget
