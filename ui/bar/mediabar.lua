local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")
local color_helpers = require("helpers.color-helpers")
local playerctl = require("signals.playerctl")

local media_controls = require("ui.widgets.media.media-controls")
local media_image = require("ui.widgets.media.media-image")
local player_icon = require("ui.widgets.media.player_icon")

local scrolling_text = require("ui.widgets.scrolling-text")

local media_controls = wibox.widget {
    {
        media_controls.prev(),
        media_controls.play(20),
        media_controls.next(),
        layout = wibox.layout.fixed.horizontal
    },
    shape = helpers.rrect(24),
    widget = wibox.container.background
}

return function(screen_width, is_vertical)
    local media_info = scrolling_text {
        font = beautiful.font_name .. "Medium 11",
        fps = 8,
        extra_space = 16,
        step_function = wibox.container.scroll.step_functions.linear_increase,
        max_size = screen_width / (is_vertical and 24 or 10)
    }

    local cover = wibox.widget {
        media_image(4),
        player_icon(is_vertical and 20 or 16),
        spacing = dpi(-2),
        layout = wibox.layout.fixed.horizontal
    }

    local media_container = wibox.widget {
        {
            {
                media_controls,
                media_info,
                cover,
                spacing = dpi(4),
                layout = wibox.layout.fixed.horizontal
            },
            left = dpi(4),
            right = dpi(4),
            widget = wibox.container.margin
        },
        widget = wibox.container.background
    }
    if is_vertical then
        media_container = wibox.widget {
            {
                media_info,
                {
                    media_controls,
                    cover,
                    spacing = dpi(4),
                    layout = wibox.layout.fixed.horizontal
                },
                layout = wibox.layout.fixed.vertical
            },
            left = dpi(2),
            right = dpi(4),
            widget = wibox.container.margin
        }
    end

    local progress_container = wibox.widget {
        media_container,

        visible = false,
        value = 0.01,
        border_width = dpi(1.6),
        color = beautiful.accent,
        border_color = beautiful.focus,
        widget = wibox.container.radialprogressbar
    }

    playerctl:connect_signal(
        "position", function(_, interval_sec, length_sec)
            if length_sec > 0 then
                progress_container.value = interval_sec / length_sec
            end
        end
    )

    playerctl:connect_signal(
        "metadata", function(_, title, artist, album_path, _, new)
            progress_container.visible = (title ~= "")
            media_info.text:set_markup_silently(title .. (artist and " • " .. artist or ""))
            if new then
                media_info:reset_scrolling()
            end
        end
    )

    playerctl:connect_signal(
        "no_players", function(_)
            progress_container.visible = false
        end
    )

    awesome.connect_signal(
        "media::dominantcolors", function(colors)
            media_container.fg = colors[2]
            media_container.bg = colors[1]

            media_controls.fg = colors[2]

            progress_container.border_color = colors[2] .. "50"
            progress_container.color = colors[2]
        end
    )

    return {
        progress_container,
        left = dpi(4),
        right = dpi(4),
        widget = wibox.container.margin
    }
end
