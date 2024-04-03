local playerctl = require("signals.playerctl")

local media_controls_popup = require("ui.control-center.media-controls-popup.media_popup_body")

playerctl:connect_signal(
    "no_players", function(_)
        media_controls_popup.visible = false
    end
)

awesome.connect_signal(
    "media::dominantcolors", function(colors)
        local bg_color, fg_color, _ = table.unpack(colors)

        -- darkening the bg color to match the dark theming
        media_controls_popup.widget.bg = bg_color .. "D0"
        media_controls_popup.border_color = bg_color
        media_controls_popup.fg = fg_color
    end
)

return media_controls_popup
