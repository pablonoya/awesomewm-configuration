local beautiful = require("beautiful")

local helpers = require("helpers")

local wibox_container = require("wibox.container")
local wibox_widget = require("wibox.widget")

return function(args)
    return wibox_widget {
        {
            args.widget,
            margins = args.margins or dpi(12),
            widget = wibox_container.margin
        },
        bg = args.bg or beautiful.black,
        shape = helpers.rrect(beautiful.border_radius),
        widget = wibox_container.background
    }
end
