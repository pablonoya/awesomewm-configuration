local beautiful = require("beautiful")
local gshape = require("gears.shape")
local wibox = require("wibox")

local playerctl = require("signals.playerctl")
local clickable_container = require("ui.widgets.clickable-container")

local create_media_button = function(symbol, size, command, args)
    return clickable_container {
        widget = {
            id = "icon",
            text = symbol,
            font = beautiful.icon_font_name .. (size or 14) .. " @FILL=1",
            valign = "center",
            halign = "center",
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

    return create_media_button("", size, media_prev_command)
end

function controls.play(size)
    local media_play_command = function()
        playerctl:play_pause()
    end

    local media_play = create_media_button("", size, media_play_command)

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

function controls.next(size)
    local media_next_command = function()
        playerctl:next()
    end

    return create_media_button("", size, media_next_command)
end

function controls.loop(size)
    local cycle_loop = function()
        playerctl:cycle_loop_status()
    end

    local loop = create_media_button("\u{e040}", size, cycle_loop)

    playerctl:connect_signal(
        "loop_status", function(_, loop_status)
            if loop_status == "track" then
                loop.widget.icon.text = "\u{e041}"
                loop.opacity = 1
            elseif loop_status == "playlist" then
                loop.widget.icon.text = "\u{e040}"
                loop.opacity = 1
            else
                loop.widget.icon.text = "\u{e040}"
                loop.opacity = 0.6
            end
        end
    )

    return loop
end

return controls
