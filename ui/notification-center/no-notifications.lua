local beautiful = require("beautiful")
local gcolor = require("gears.color")
local wibox = require("wibox")

local no_notifications = wibox.widget {
    {
        {
            {
                image = gcolor.recolor_image(beautiful.notification_bell_icon, beautiful.moon),
                forced_width = dpi(72),
                forced_height = dpi(72),
                widget = wibox.widget.imagebox
            },
            widget = wibox.container.place
        },
        {
            text = "No notifications",
            ellipsize = "none",
            halign = "center",
            font = beautiful.font_name .. "Medium 13",
            widget = wibox.widget.textbox
        },
        spacing = dpi(16),
        layout = wibox.layout.fixed.vertical
    },
    margins = dpi(12),
    widget = wibox.container.margin
}

return no_notifications
