local beautiful = require("beautiful")
local wibox = require("wibox")

return wibox.widget {
    {
        text = "No notifications",
        ellipsize = "none",
        halign = "center",
        font = beautiful.font_name .. "Medium 11",
        widget = wibox.widget.textbox
    },
    top = dpi(8),
    bottom = dpi(24),
    widget = wibox.container.margin
}
