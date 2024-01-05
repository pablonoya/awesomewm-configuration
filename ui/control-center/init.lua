local awful_screen = require("awful.screen")
local awful_placement = require("awful.placement")

local rubato = require("module.rubato")
local playerctl = require("signals.playerctl")

local control_center = require("ui.control-center.control-center")
local media_controls_popup = require("ui.control-center.media-controls-popup")

local timed_slide = rubato.timed {
    duration = 0.2,
    intro = 0.01,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        control_center.x = pos
    end
}

local timed_slide_media_popup = rubato.timed {
    duration = 0.3,
    intro = 0.01,
    easing = rubato.easing.quadratic,
    subscribed = function(pos)
        media_controls_popup.x = pos
    end
}

local function show()
    local screen = awful_screen.focused()

    awful_placement.top_right(
        control_center, {
            parent = screen.bar,
            margins = {
                top = screen.bar.height + dpi(12),
                right = -control_center.width
            }
        }
    )

    awful_placement.top_right(
        media_controls_popup, {
            parent = screen.bar,
            margins = {
                top = screen.bar.height + control_center.height + dpi(24),
                right = -media_controls_popup.width
            }
        }
    )

    timed_slide.pos = control_center.x
    timed_slide.target = control_center.x - control_center.width

    timed_slide_media_popup.pos = media_controls_popup.x
    timed_slide_media_popup.target = media_controls_popup.x - media_controls_popup.width

    control_center.visible = true
    media_controls_popup.visible = playerctl:get_active_player() ~= nil
end

local function hide()
    timed_slide.target = control_center.x + control_center.width
    control_center.visible = false

    timed_slide_media_popup.target = media_controls_popup.x + media_controls_popup.width
    media_controls_popup.visible = false
end

playerctl:connect_signal(
    "metadata", function(_, title)
        media_controls_popup.visible = (title ~= "") and control_center.visible
    end
)

awesome.connect_signal(
    "control_center::toggle", function()
        if control_center.visible then
            hide()
        else
            show()
        end
    end
)
