local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")
local playerctl = require("signals.playerctl")

local media_controls = require("ui.widgets.media.media-controls")
local media_image = require("ui.widgets.media.media-image")
local player_icon = require("ui.widgets.media.player_icon")

local media_info = require("ui.control-center.media-controls-popup.media-info")

local media_buttons = wibox.widget {
    media_controls.prev(15),
    media_controls.play(20),
    media_controls.next(15),
    media_controls.loop(15),
    spacing = dpi(1),
    layout = wibox.layout.fixed.horizontal
}

local cover = wibox.widget {
    {
        media_image(4),
        widget = wibox.container.place
    },
    {
        player_icon(20, "popup"),
        valign = "bottom",
        halign = "right",
        widget = wibox.container.place
    },
    horizontal_offset = dpi(4),
    layout = wibox.layout.stack
}

local media_controls_box = wibox.widget {
    {
        {
            {
                {
                    media_info,
                    media_buttons,

                    spacing = dpi(6),
                    forced_width = dpi(156),
                    layout = wibox.layout.fixed.vertical
                },
                margins = dpi(6),
                widget = wibox.container.margin
            },
            {
                cover,
                widget = wibox.container.place
            },
            spacing = dpi(8),
            layout = wibox.layout.fixed.horizontal
        },
        margins = dpi(4),
        widget = wibox.container.margin
    },
    visible = false,
    bg = beautiful.xbackground,
    forced_width = dpi(256),
    forced_height = dpi(96),
    border_width = dpi(2),
    border_color = beautiful.focus,
    shape = helpers.rrect(beautiful.border_radius),
    widget = wibox.container.background
}

playerctl:connect_signal(
    "metadata", function(_, title)
        media_controls_box.visible = title ~= ""
    end
)

playerctl:connect_signal(
    "no_players", function(_)
        media_controls_box.visible = false
    end
)

awesome.connect_signal(
    "media::dominantcolors", function(colors)
        local bg_color, fg_color, _ = table.unpack(colors)

        -- darkening the bg color to match the dark theming
        media_controls_box.bg = bg_color .. "D0"
        media_controls_box.border_color = bg_color
        media_controls_box.fg = fg_color
    end
)

return media_controls_box
