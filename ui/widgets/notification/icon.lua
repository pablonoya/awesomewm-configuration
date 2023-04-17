local wibox_container = require("wibox.container")
-- local wibox_layout = require("wibox.layout")
local wibox_widget = require("wibox.widget")

local function notif_icon(args)
    return wibox_widget {
        {
            image = args.icon,
            valign = "center",
            forced_width = args.size or dpi(28),
            forced_height = args.size or dpi(28),
            widget = wibox_widget.imagebox
        },
        margins = dpi(8),
        widget = wibox_container.margin
    }
end

return notif_icon
