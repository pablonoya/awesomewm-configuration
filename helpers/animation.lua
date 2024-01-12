local awful = require("awful")
local rubato = require("module.rubato")

local _animation = {}

function _animation.create_timed_slide(duration, widget)
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

function _animation.slide_in(reserved_height, timed_slide, widget)
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

function _animation.slide_out(timed_slide, widget)
    timed_slide.target = widget.x + widget.width
    widget.visible = false
end

return _animation
