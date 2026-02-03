local playerctl = require("signals.playerctl")

local media_controls_popup = require("ui.control-center.media-controls-popup.media_popup_body")

playerctl:connect_signal(
    "no_players", function(_)
        media_controls_popup.visible = false
    end
)

awesome.connect_signal(
    "media::dominantcolors", function(colors)
        media_controls_popup.widget.bg = colors[1]
        media_controls_popup.fg = colors[2]
        media_controls_popup.border_color = colors[1]
    end
)

return media_controls_popup
