local awful = require("awful")
local beautiful = require("beautiful")

local rubato = require("module.rubato")

local notification_center = require('ui.info-docks.notification-center.notification-center')
local weather_popup = require('ui.info-docks.weather-popup')
local calendar_popup = require('ui.info-docks.calendar-box.calendar-popup')

local function create_timed_slide(duration, widget)
    return rubato.timed {
        rate = 60,
        duration = duration,
        intro = 0.01,
        easing = rubato.easing.quadratic,
        subscribed = function(pos)
            widget.x = pos
        end
    }
end

local function slide_in(reserved_height, timed_slide, widget)
    local screen = awful.screen.focused()

    awful.placement.top_right(
        widget, {
            parent = screen.bar,
            margins = {
                top = reserved_height,
                right = -widget.width
            }
        }
    )

    timed_slide.pos = widget.x
    widget.visible = true
    timed_slide.target = widget.x - widget.width
end

local function slide_out(timed_slide, widget)
    timed_slide.target = widget.x + widget.width
    widget.visible = false
end

local slide_calendar = create_timed_slide(0.2, calendar_popup)
local slide_weather = create_timed_slide(0.25, weather_popup)
local slide_notif_center = create_timed_slide(0.3, notification_center)

local function show()
    local screen = awful.screen.focused()
    local reserved_height = screen.bar.height + 12

    slide_in(reserved_height, slide_calendar, calendar_popup)
    reserved_height = reserved_height + calendar_popup.height + 12

    if beautiful.weather_api_key then
        slide_in(reserved_height, slide_weather, weather_popup)
        reserved_height = reserved_height + weather_popup.height + 12
    end

    notification_center.maximum_height = screen.geometry.height - reserved_height - 24
    slide_in(reserved_height, slide_notif_center, notification_center)
end

local function hide()
    slide_out(slide_calendar, calendar_popup)
    slide_out(slide_notif_center, notification_center)

    if beautiful.weather_api_key then
        slide_out(slide_weather, weather_popup)
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
