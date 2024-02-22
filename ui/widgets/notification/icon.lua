local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")

return function(args)
    return wibox.widget {
        {
            image = args.icon,
            forced_width = args.size or dpi(28),
            forced_height = args.size or dpi(28),
            widget = naughty.widget.icon
        },
        top = dpi(16),
        right = dpi(8),
        left = dpi(8),
        widget = wibox.container.margin
    }
end
