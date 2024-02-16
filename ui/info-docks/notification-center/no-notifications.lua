local beautiful = require("beautiful")
local gcolor = require("gears.color")
local wibox = require("wibox")

local no_notifications = wibox.widget {
    {
        text = "No notifications",
        ellipsize = "none",
        halign = "center",
        font = beautiful.font_name .. "Medium 12",
        widget = wibox.widget.textbox
    },
    margins = dpi(20),
    widget = wibox.container.margin
}

return no_notifications
