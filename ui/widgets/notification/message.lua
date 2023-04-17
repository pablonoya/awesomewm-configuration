local beautiful = require("beautiful")
local naughty_widget = require("naughty.widget")
local wibox_widget = require("wibox.widget")

return function(notification)
    local message_body = wibox_widget {
        notification = notification,
        font = beautiful.font_name .. "12",
        ellipsize = "none",
        widget = naughty_widget.message
    }

    return message_body
end
