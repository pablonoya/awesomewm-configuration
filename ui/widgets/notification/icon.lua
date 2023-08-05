local wibox_container = require("wibox.container")
-- local wibox_layout = require("wibox.layout")
local wibox_widget = require("wibox.widget")

local function notif_icon(args)
    return wibox_widget {
        {
            image = args.icon,
            valign = "top",
            forced_width = args.size or dpi(28),
            forced_height = args.size or dpi(28),
            widget = wibox_widget.imagebox
        },
        top = dpi(18),
        right = dpi(8),
        left = dpi(8),
        widget = wibox_container.margin
    }
end

return notif_icon
