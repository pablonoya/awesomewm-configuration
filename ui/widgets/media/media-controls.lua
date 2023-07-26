local beautiful = require("beautiful")
local gshape = require("gears.shape")
local wibox = require("wibox")

local playerctl = require("signals.playerctl")
local clickable_container = require("ui.widgets.clickable-container")

local create_media_button = function(symbol, command, size, args)
    return clickable_container {
        widget = {
            id = "icon",
            text = symbol,
            font = beautiful.icon_font_name .. (size or 14),
            ellipsize = "none",
            widget = wibox.widget.textbox
        },
        shape = args and args.shape or gshape.circle,
        margins = args and args.margins or dpi(1),
        action = command
    }
end

local controls = {}

function controls.prev(size)
    local media_prev_command = function()
        playerctl:previous()
    end

    return create_media_button("", media_prev_command, size)
end

function controls.play(play_size)
    local media_play_command = function()
        playerctl:play_pause()
    end

    local media_play = create_media_button("", media_play_command, play_size)

    playerctl:connect_signal(
        "playback_status", function(_, playing, player)
            if playing then
                media_play.widget.icon.text = ""
            else
                media_play.widget.icon.text = ""
            end
        end
    )

    return media_play
end

function controls.next(size, args)
    local media_next_command = function()
        playerctl:next()
    end

    return create_media_button("", media_next_command, size)
end

return controls
