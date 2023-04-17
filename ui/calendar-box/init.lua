local awful_screen = require("awful.screen")
local awful_placement = require("awful.placement")

local rubato = require("module.rubato")
local calendar_container = require("ui.calendar-box.calendar-container")

local timed_slide = rubato.timed {
    duration = 0.2,
    intro = 0.01,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        calendar_container.x = pos
    end
}

-- Make toogle button
local show = function()
    local screen = awful_screen.focused()

    awful_placement.top_right(
        calendar_container, {
            parent = screen,
            margins = {
                top = screen.bar.height + dpi(12),
                right = -calendar_container.width + dpi(14)
            }
        }
    )

    timed_slide.pos = calendar_container.x
    calendar_container.visible = true
    timed_slide.target = calendar_container.x - calendar_container.width
end

local hide = function()
    timed_slide.target = calendar_container.x + calendar_container.width
    calendar_container.visible = false
end

awesome.connect_signal(
    "notification_center::toggle", function()
        if calendar_container.visible then
            hide()
        else
            show()
        end

        awesome.emit_signal("notification_center::visible", calendar_container.visible)
    end
)
