local beautiful = require("beautiful")
local naughty_widget = require("naughty.widget")
local wibox_widget = require("wibox.widget")

return function(notification)
    return wibox_widget {
        notification = notification,
        font = beautiful.font_name .. 12,
        widget = naughty_widget.message
    }
end
