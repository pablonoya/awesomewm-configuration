local beautiful = require("beautiful")
local gshape = require("gears.shape")
local gsurface = require("gears.surface")
local wibox_container = require("wibox.container")
local wibox_layout = require("wibox.layout")
local wibox_widget = require("wibox.widget")

local helpers = require("helpers")
local playerctl = require("signals.playerctl")
local clickable_container = require("ui.widgets.clickable-container")
local text_icon = require("ui.widgets.text-icon")

local create_media_button = function(symbol, command, size)
    local button = clickable_container {
        widget = {
            id = "icon",
            text = symbol,
            font = beautiful.icon_font_name .. " " .. (size or 14),
            ellipsize = "none",
            widget = wibox_widget.textbox

        },
        shape = gshape.circle,
        margins = dpi(1),
        action = command
    }

    return button
end

local media_play_command = function()
    playerctl:play_pause()
end
local media_prev_command = function()
    playerctl:previous()
end
local media_next_command = function()
    playerctl:next()
end

local media_play = create_media_button("", media_play_command, 19)
local media_prev = create_media_button("", media_prev_command)
local media_next = create_media_button("", media_next_command)

playerctl:connect_signal(
    "playback_status", function(_, playing, player)
        if playing then
            media_play.widget.icon:set_markup_silently("")
        else
            media_play.widget.icon:set_markup_silently("")
        end
    end
)

local cover = wibox_widget {
    {
        id = "img",
        resize = true,
        widget = wibox_widget.imagebox
    },
    shape = helpers.rrect(4),
    widget = wibox_container.background
}

return function(screen_width, is_vertical)
    local music_text = wibox_widget {
        {
            id = "text",
            font = "Roboto 11",
            valign = "center",
            widget = wibox_widget.textbox
        },
        fps = 4,
        speed = 16,
        extra_space = 16,
        expand = true,
        max_size = screen_width / (is_vertical and 24 or 10),
        widget = wibox_container.scroll.horizontal
    }

    local media = wibox_widget {
        cover,
        {
            music_text,
            {
                media_prev,
                media_play,
                media_next,
                {
                    forced_width = dpi(0.5),
                    widget = wibox_container.margin
                },
                layout = wibox_layout.fixed.horizontal
            },
            spacing = is_vertical and dpi(2) or dpi(8),
            layout = is_vertical and wibox_layout.fixed.vertical or wibox_layout.fixed.horizontal
        },
        spacing = dpi(8),
        layout = wibox_layout.fixed.horizontal,
        widget = wibox_widget.background
    }

    local progress_container = wibox_widget {
        {
            media,
            left = dpi(12),
            right = dpi(4),
            widget = wibox_container.margin
        },
        visible = false,
        value = 0.1,
        border_width = dpi(1.6),
        color = beautiful.accent,
        border_color = beautiful.focus,
        widget = wibox_container.radialprogressbar
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
            music_text.text:set_markup_silently(
                title .. helpers.colorize_text(" • ", beautiful.xforeground .. 'B0') .. artist
            )
        end
    )

    playerctl:connect_signal(
        "no_players", function(_)
            progress_container.visible = false
        end
    )

    local mediabar = {
        progress_container,
        left = dpi(4),
        right = dpi(6),
        widget = wibox_container.margin
    }

    return mediabar
end
