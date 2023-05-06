local awful_screen = require("awful.screen")
local awful_placement = require("awful.placement")
local beautiful = require("beautiful")
local wibox = require("wibox")

local rubato = require("module.rubato")

local helpers = require("helpers")
local container = require('ui.notification-center.container')
local cal_height = require('ui.calendar-box.calendar-container').height

local screen_height = awful_screen.focused().geometry.height
local reserved_height = screen_height + dpi(280)

local notification_center = wibox {
    type = "dock",
    screen = awful_screen.focused(),
    width = dpi(320),
    ontop = true,
    visible = false,
    shape = helpers.rrect(beautiful.border_radius)
}

notification_center:setup{
    container,
    bg = beautiful.black,
    border_width = dpi(2),
    border_color = beautiful.focus,
    shape = helpers.rrect(beautiful.notif_center_radius),
    widget = wibox.container.background
}

local timed_slide = rubato.timed {
    duration = 0.3,
    intro = 0.01,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        notification_center.x = pos
    end
}

local notif_center_show = function()
    local screen = awful_screen.focused()
    local top_bar_height = screen.bar.height

    notification_center.height = screen.geometry.height - top_bar_height - dpi(304)

    awful_placement.top_right(
        notification_center, {
            parent = screen,
            margins = {
                top = top_bar_height + dpi(300),
                right = -notification_center.width + dpi(14)
            }
        }
    )

    timed_slide.pos = notification_center.x
    notification_center.visible = true
    timed_slide.target = notification_center.x - notification_center.width
end

local notif_center_hide = function()
    timed_slide.target = notification_center.x + notification_center.width
    notification_center.visible = false
end

awesome.connect_signal(
    "notification_center::toggle", function()
        if notification_center.visible then
            notif_center_hide()
        else
            notif_center_show()
        end

        awesome.emit_signal("notification_center::visible", notification_center.visible)
    end
)

return notification_center
