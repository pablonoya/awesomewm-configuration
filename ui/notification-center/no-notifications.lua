local beautiful = require("beautiful")
local gcolor = require("gears.color")
local wibox_container = require("wibox.container")
local wibox_widget = require("wibox.widget")
local wibox_layout = require("wibox.layout")

local empty_notifbox = wibox_widget {
    {
        {
            image = gcolor.recolor_image(beautiful.notification_bell_icon, beautiful.moon),
            forced_width = dpi(100),
            forced_height = dpi(100),
            widget = wibox_widget.imagebox
        },
        widget = wibox_container.place
    },
    {
        text = "No notifications",
        ellipsize = "none",
        halign = "center",
        font = beautiful.font_name .. "Medium 13",
        widget = wibox_widget.textbox
    },
    spacing = dpi(20),
    layout = wibox_layout.fixed.vertical
}

local invisible_separator = wibox_widget.separator {
    orientation = "vertical",
    opacity = 0
}

-- Make empty_notifbox center
local centered_empty_notifbox = wibox_widget {
    invisible_separator,
    empty_notifbox,
    invisible_separator,
    layout = wibox_layout.flex.vertical
}

return centered_empty_notifbox
