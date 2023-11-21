local beautiful = require("beautiful")
local gcolor = require("gears.color")
local gshape = require("gears.shape")
local wibox = require("wibox")

local media_icons = require("ui.icons.media")
local playerctl = require("signals.playerctl")

return function(size, widget_type)
    local player_icon = wibox.widget {
        {
            id = "img",
            valign = "center",
            widget = wibox.widget.imagebox
        },
        forced_width = dpi(size),
        forced_height = dpi(size),
        shape = gshape.circle,
        bg = beautiful.xbackground,
        widget = wibox.container.background
    }

    awesome.connect_signal(
        "media::dominantcolors", function(colors)
            local bg_color, fg_color, fg_bar_color = table.unpack(colors)

            if widget_type == "popup" then
                player_icon.bg = bg_color
            end

            player_icon.img.image = gcolor.recolor_image(
                media_icons[playerctl:get_active_player().player_name] or media_icons.music_note,
                widget_type == "popup" and fg_color or fg_bar_color
            )
        end
    )
    return player_icon

end
