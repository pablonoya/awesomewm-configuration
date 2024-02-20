local beautiful = require("beautiful")
local gtimer = require("gears.timer")

local wibox_widget = require("wibox.widget")

local time_in_seconds = function(time)
    local hours = tonumber(string.sub(time, 1, 2)) * 3600
    local mins = tonumber(string.sub(time, 4, 5)) * 60
    local secs = tonumber(string.sub(time, 7, 8))

    return (hours + mins + secs)
end

return function(time_of_notification, exact_time, exact_date)
    local time_elapsed = wibox_widget {
        markup = "now",
        font = beautiful.font_name .. "10",
        halign = "right",
        widget = wibox_widget.textbox
    }

    local time_of_popup = gtimer {
        timeout = 60,
        call_now = true,
        autostart = true,
        callback = function()
            local time_difference = (time_in_seconds(os.date("%H:%M:%S")) -
                                        time_in_seconds(time_of_notification))

            if time_difference >= 60 and time_difference < 3600 then
                local time_in_minutes = math.floor(time_difference / 60)
                time_elapsed:set_markup(time_in_minutes .. "m ago")

            elseif time_difference >= 3600 and time_difference < 86400 then
                time_elapsed:set_markup(exact_time)

            elseif time_difference >= 86400 then
                time_elapsed:set_markup(exact_date)
                return false
            end
        end
    }

    return time_elapsed
end
