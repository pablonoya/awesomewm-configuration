local beautiful = require("beautiful")
local wibox = require("wibox")

local notification_list = require("ui.notification-center.notification-list")
local clear_all = require("ui.notification-center.clear-all")

local header = wibox.widget {
    {
        text = 'Notification center',
        font = beautiful.font_name .. 'Bold 14',
        align = 'left',
        valign = 'center',
        widget = wibox.widget.textbox
    },
    nil,
    clear_all,
    layout = wibox.layout.align.horizontal
}

return wibox.widget {
    {
        header,
        notification_list,
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(8)
    },
    margins = dpi(12),
    widget = wibox.container.margin
}
