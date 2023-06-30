local beautiful = require("beautiful")

local wibox_container = require("wibox.container")
local wibox_widget = require("wibox.widget")

local helpers = require("helpers")

return function(args)
    return wibox_widget {
        {
            args.widget,
            margins = args.margins or dpi(4),
            widget = wibox_container.margin
        },
        shape = args.shape or helpers.rrect(beautiful.border_radius),
        border_width = dpi(1.6),
        border_color = beautiful.focus,
        widget = wibox_container.background
    }
end
