local awful_screen = require("awful.screen")

local playerctl = require("signals.playerctl")
local animation = require("helpers.animation")

local control_center = require("ui.control-center.control_center")
local media_controls_popup = require("ui.control-center.media-controls-popup")

local slide_control_center = animation.create_timed_slide(0.2, control_center)
local slide_media_popup = animation.create_timed_slide(0.3, media_controls_popup)

local function show()
    local screen = awful_screen.focused()
    local reserved_height = screen.bar.height + 12

    animation.slide_in(reserved_height, slide_control_center, control_center)
    reserved_height = reserved_height + control_center.height + 12

    animation.slide_in(reserved_height, slide_media_popup, media_controls_popup)
    media_controls_popup.visible = playerctl:get_active_player() ~= nil
end

local function hide()
    animation.slide_out(slide_control_center, control_center)
    animation.slide_out(slide_media_popup, media_controls_popup)

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
