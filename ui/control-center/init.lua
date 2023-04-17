local awful_screen = require("awful.screen")
local awful_placement = require("awful.placement")

local rubato = require("module.rubato")

local control_center = require("ui.control-center.control-center")

local timed_slide = rubato.timed {
    duration = 0.2,
    intro = 0.01,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        control_center.x = pos
    end
}

local function show()
    local focused_screen = awful_screen.focused()

    awful_placement.top_right(
        control_center, {
            parent = focused_screen,
            margins = {
                top = focused_screen.bar.height + dpi(12),
                right = -control_center.width + dpi(14)
            }
        }
    )
    timed_slide.pos = control_center.x
    control_center.visible = true
    timed_slide.target = control_center.x - control_center.width
end

local function hide()
    timed_slide.target = control_center.x + control_center.width
    control_center.visible = false
end

awesome.connect_signal(
    "control_center::toggle", function()
        if control_center.visible then
            hide()
        else
            show()
        end
        awesome.emit_signal("control_center::visible", control_center.visible)
    end
)
