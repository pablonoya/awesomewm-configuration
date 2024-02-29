local gsurface = require("gears.surface")
local wibox = require("wibox")

local helpers = require("helpers")
local playerctl = require("signals.playerctl")

return function(radius)

    local media_image = wibox.widget {
        {
            id = "img",
            scaling_quality = "best",
            widget = wibox.widget.imagebox
        },
        shape = helpers.rrect(radius),
        widget = wibox.container.background
    }

    playerctl:connect_signal(
        "metadata", function(_, _, _, album_path)
            media_image.img:set_image(gsurface.load(album_path))
        end
    )
    return media_image
end
