local awful_screen = require("awful.screen")
local awful_placement = require("awful.placement")

local rubato = require("module.rubato")
local calendar_popup = require("ui.calendar-box.calendar-popup")

local timed_slide = rubato.timed {
    rate = 60,
    duration = 0.2,
    intro = 0.01,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        calendar_popup.x = pos
    end
}

local show = function()
    local screen = awful_screen.focused()

    awful_placement.top_right(
        calendar_popup, {
            parent = screen.bar,
            margins = {
                top = screen.bar.height + dpi(8),
                right = -calendar_popup.width
            }
        }
    )

    timed_slide.pos = calendar_popup.x
    calendar_popup.visible = true
    timed_slide.target = calendar_popup.x - calendar_popup.width

    awesome.emit_signal("calendar::date", "today")
end

local hide = function()
    timed_slide.target = calendar_popup.x + calendar_popup.width
    calendar_popup.visible = false
end

awesome.connect_signal(
    "notification_center::toggle", function()
        if calendar_popup.visible then
            hide()
        else
            show()
        end
    end
)
