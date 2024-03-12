local awful_screen = require("awful.screen")
local beautiful = require("beautiful")

local animation = require("helpers.animation")

local notification_center = require("ui.info-docks.notification_center.notification_center")
local weather_popup = require("ui.info-docks.weather-popup")
local calendar_popup = require("ui.info-docks.calendar-box.calendar-popup")

local slide_calendar = animation.create_timed_slide(0.2, calendar_popup)
local slide_weather = animation.create_timed_slide(0.25, weather_popup)
local slide_notif_center = animation.create_timed_slide(0.3, notification_center)

local function show()
    local screen = awful_screen.focused()
    local reserved_height = screen.bar.height + 12

    animation.slide_in(reserved_height, slide_calendar, calendar_popup)
    reserved_height = reserved_height + calendar_popup.height + 12

    if beautiful.weather_api_key then
        animation.slide_in(reserved_height, slide_weather, weather_popup)
        reserved_height = reserved_height + weather_popup.height + 12
    end

    notification_center.maximum_height = screen.geometry.height - reserved_height - 24
    animation.slide_in(reserved_height, slide_notif_center, notification_center)
end

local function hide()
    animation.slide_out(slide_calendar, calendar_popup)
    animation.slide_out(slide_notif_center, notification_center)

    if beautiful.weather_api_key then
        animation.slide_out(slide_weather, weather_popup)
    end
end

awesome.connect_signal(
    "notification_center::toggle", function()
        if notification_center.visible then
            hide()
        else
            show()
        end
    end
)
