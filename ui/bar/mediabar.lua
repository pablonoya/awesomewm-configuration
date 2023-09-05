local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")
local playerctl = require("signals.playerctl")

local media_controls = require("ui.widgets.media.media-controls")
local media_image = require("ui.widgets.media.media-image")
local player_icon = require("ui.widgets.media.player-icon")

local scrolling_text = require("ui.widgets.scrolling-text")

local text_separator = helpers.colorize_text(" • ", beautiful.xforeground .. "B0")

local media_controls = wibox.widget {
    {
        media_controls.prev(),
        media_controls.play(19),
        media_controls.next(),
        layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.background
}

return function(screen_width, is_vertical)
    local media_info = scrolling_text {
        font = "Roboto 11",
        fps = 4,
        extra_space = 16,
        max_size = screen_width / (is_vertical and 24 or 10)
    }

    local player_interface
    if is_vertical then
        player_interface = wibox.widget {
            media_info,
            media_controls,
            spacing = dpi(2),
            layout = wibox.layout.fixed.vertical
        }
    else
        player_interface = wibox.widget {
            media_controls,
            media_info,
            spacing = dpi(4),
            layout = wibox.layout.fixed.horizontal
        }
    end

    local media = wibox.widget {
        player_interface,
        {
            media_image(4),
            player_icon(is_vertical and 20 or 16, "bar"),
            spacing = dpi(-2),
            layout = wibox.layout.fixed.horizontal
        },
        spacing = dpi(8),
        layout = wibox.layout.fixed.horizontal,
        widget = wibox.container.background
    }

    local progress_container = wibox.widget {
        {
            media,
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin
        },
        visible = false,
        value = 0.1,
        border_width = dpi(1.6),
        color = beautiful.accent,
        border_color = beautiful.focus,
        widget = wibox.container.radialprogressbar
    }

    playerctl:connect_signal(
        "position", function(_, interval_sec, length_sec)
            progress_container.value = interval_sec / length_sec
        end
    )

    playerctl:connect_signal(
        "metadata", function(_, title, artist, album_path)
            progress_container.visible = (title ~= "")

            media_info.text:set_markup_silently(
                title .. (artist ~= "" and text_separator .. artist or "")
            )
        end
    )

    playerctl:connect_signal(
        "no_players", function(_)
            progress_container.visible = false
        end
    )

    awesome.connect_signal(
        "media::dominantcolors", function(colors)
            local fg_bar_color = colors[3]

            progress_container.color = fg_bar_color
            media_controls.fg = fg_bar_color
        end
    )

    local mediabar = {
        progress_container,
        left = dpi(4),
        right = dpi(4),
        widget = wibox.container.margin
    }

    return mediabar
end
