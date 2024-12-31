local beautiful = require("beautiful")
local wibox = require("wibox")

return wibox.widget {
    {
        text = "No notifications yet",
        halign = "center",
        font = beautiful.font_name .. 11,
        widget = wibox.widget.textbox
    },
    top = dpi(4),
    bottom = dpi(16),
    widget = wibox.container.margin
}
