local awful = require("awful")

local rubato = require("module.rubato")
local helpers = require("helpers")

local border_popup = require('ui.widgets.border-popup')
local calendar_popup = require('ui.calendar-box.calendar-popup')
local weather = require("ui.calendar-box.widgets.weather")

local weather_popup = border_popup {
    widget = weather
}

local timed_slide = rubato.timed {
    rate = 60,
    duration = 0.25,
    intro = 0.01,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        weather_popup.x = pos
    end
}

-- Make toogle button
local show = function()
    local screen = awful.screen.focused()
    local reserved_height = screen.bar.height + calendar_popup.height

    awful.placement.top_right(
        weather_popup, {
            parent = screen.bar,
            margins = {
                top = reserved_height + 24,
                right = -weather_popup.width
            }
        }
    )

    timed_slide.pos = weather_popup.x
    weather_popup.visible = true
    timed_slide.target = weather_popup.x - weather_popup.width
end

local hide = function()
    timed_slide.target = weather_popup.x + weather_popup.width
    weather_popup.visible = false
end

awesome.connect_signal(
    "notification_center::toggle", function()
        if weather_popup.visible then
            hide()
        else
            show()
        end
    end
)

return weather_popup
