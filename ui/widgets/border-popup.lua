local awful_popup = require("awful.popup")
local beautiful = require("beautiful")

local helpers = require("helpers")

return function(args)
    return awful_popup {
        widget = args.widget,
        type = "dock",
        ontop = true,
        visible = false,
        bg = args.bg or beautiful.black,
        border_width = dpi(2),
        border_color = beautiful.focus,
        shape = helpers.rrect(beautiful.notif_center_radius)
    }
end
