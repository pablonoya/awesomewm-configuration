local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")

return function(args)
    return wibox.widget {
        {
            args.widget,
            margins = args.margins or dpi(4),
            widget = wibox.container.margin
        },
        bg = args.bg or beautiful.xbackground,
        shape = args.shape or helpers.rrect(beautiful.border_radius),
        border_width = args.border_width or dpi(1.6),
        border_color = beautiful.focus,
        widget = wibox.container.background
    }
end
