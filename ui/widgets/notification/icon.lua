local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")

local helpers = require("helpers")

return function(args)
    local icon = wibox.widget {
        {
            id = "icon",
            image = args.notification.icon,
            valign = "top",
            forced_width = args.size or dpi(28),
            forced_height = args.size or dpi(28),
            scaling_quality = "best",
            clip_shape = helpers.rrect(4),
            widget = wibox.widget.imagebox
        },
        top = dpi(16),
        right = dpi(8),
        left = dpi(8),
        widget = wibox.container.margin
    }

    args.notification:connect_signal(
        "property::icon", function()
            icon.icon.image = args.notification.icon
        end
    )

    return icon
end
