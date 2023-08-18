local beautiful = require("beautiful")
local gshape = require("gears.shape")
local gsurface = require("gears.surface")
local wibox = require("wibox")

local helpers = require("helpers")
local playerctl = require("signals.playerctl")

local media_controls = require("ui.widgets.media.media-controls")
local scrolling_text = require("ui.widgets.scrolling-text")
local text_icon = require("ui.widgets.text-icon")

local media_prev = media_controls.prev()
local media_play = media_controls.play(19)
local media_next = media_controls.next()

local media_controls = wibox.widget {
    {
        media_prev,
        media_play,
        media_next,
        layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.background
}

local cover = wibox.widget {
    {
        id = "img",
        resize = true,
        widget = wibox.widget.imagebox
    },
    shape = helpers.rrect(4),
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
        cover,
        spacing = dpi(8),
        layout = wibox.layout.fixed.horizontal,
        widget = wibox.container.background
    }

    local progress_container = wibox.widget {
        {
            media,
            left = dpi(4),
            right = dpi(12),
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

            cover.img:set_image(gsurface.load_uncached(album_path))
            media_info.text:set_markup_silently(
                title .. helpers.colorize_text(" • ", beautiful.xforeground .. 'B0') .. artist
            )
        end
    )

    playerctl:connect_signal(
        "no_players", function(_)
            progress_container.visible = false
        end
    )

    awesome.connect_signal(
        "media::dominantcolors", function(stdout)
            local colors = {}
            for color in stdout:gmatch("[^\n]+") do
                table.insert(colors, color)
            end
            progress_container.color = colors[3]
            media_controls.fg = colors[3]
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
