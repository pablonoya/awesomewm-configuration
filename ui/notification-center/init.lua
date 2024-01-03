local awful = require("awful")

local rubato = require("module.rubato")

local notification_center = require('ui.notification-center.notification-center')
local calendar_popup = require('ui.calendar-box.calendar-popup')

local timed_slide = rubato.timed {
    rate = 60,
    duration = 0.3,
    intro = 0.01,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        notification_center.x = pos
    end
}

local show = function()
    local screen = awful.screen.focused()
    local reserved_height = screen.bar.height + calendar_popup.height

    notification_center.maximum_height = screen.geometry.height - reserved_height - dpi(24)

    awful.placement.top_right(
        notification_center, {
            parent = screen.bar,
            margins = {
                top = reserved_height + dpi(16),
                right = -notification_center.width
            }
        }
    )

    timed_slide.pos = notification_center.x
    notification_center.visible = true
    timed_slide.target = notification_center.x - notification_center.width
end

local hide = function()
    timed_slide.target = notification_center.x + notification_center.width
    notification_center.visible = false
end

notification_center:connect_signal(
    "property::visible", function(self)
        awesome.emit_signal("notification_center::visible", self.visible)
    end
)

awesome.connect_signal(
    "notification_center::toggle", function()
        if notification_center.visible then
            hide()
        else
            show()
        end
    end
)

return notification_center
