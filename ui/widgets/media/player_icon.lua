local beautiful = require("beautiful")
local gcolor = require("gears.color")
local gshape = require("gears.shape")
local wibox = require("wibox")

local media_icons = require("ui.icons.media")
local playerctl = require("signals.playerctl")

local last_player_name

return function(size)
    local icon = wibox.widget {
        image = media_icons.music_note,
        valign = "center",
        scaling_quality = "best",
        widget = wibox.widget.imagebox
    }

    playerctl:connect_signal(
        "metadata", function(_, title, artist, album_path, album, new, player_name)
            if new and last_player_name == player_name then
                return
            end

            icon.image = gcolor.recolor_image(
                media_icons[player_name] or media_icons.music_note, beautiful.xforeground
            )
            last_player_name = player_name
        end
    )

    local player_icon = wibox.widget {
        icon,
        forced_width = dpi(size),
        forced_height = dpi(size),
        shape = gshape.circle,
        bg = beautiful.xbackground,
        widget = wibox.container.background
    }

    awesome.connect_signal(
        "media::dominantcolors", function(colors)
            player_icon.bg = colors[1]
            icon.image = gcolor.recolor_image(
                media_icons[last_player_name] or media_icons.music_note,
                colors[2]
            )
        end
    )

    return player_icon
end
