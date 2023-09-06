local awful_popup = require("awful.popup")
local beautiful = require("beautiful")

local helpers = require("helpers")
local playerctl = require("signals.playerctl")

local popup_body = require("ui.control-center.media-controls-popup.media-popup-body")

local media_controls_popup = awful_popup {
    type = "dock",
    bg = beautiful.black,
    maximum_width = dpi(beautiful.control_center_width),
    border_width = dpi(2),
    border_color = beautiful.focus,
    ontop = true,
    visible = false,
    shape = helpers.rrect(beautiful.border_radius),
    widget = popup_body
}

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
