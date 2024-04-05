local beautiful = require("beautiful")
local wibox = require("wibox")

local border_popup = require("ui.widgets.border-popup")

local notification_list = require("ui.info-docks.notification_center.notification_list")
local clear_all = require("ui.info-docks.notification_center.clear_all")

local header = wibox.widget {
    {
        text = "Notifications",
        font = beautiful.font_name .. "Bold 12",
        align = "left",
        valign = "center",
        widget = wibox.widget.textbox
    },
    nil,
    clear_all,
    layout = wibox.layout.align.horizontal
}

local notification_center = border_popup {
    widget = wibox.widget {
        {
            header,
            notification_list,
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(4)
        },
        top = dpi(4),
        left = dpi(12),
        right = dpi(12),
        widget = wibox.container.margin
    },
    minimum_width = beautiful.notif_center_width,
    maximum_width = beautiful.notif_center_width
}

notification_center:connect_signal(
    "property::visible", function(self)
        awesome.emit_signal("notification_center::visible", self.visible)
    end
)

return notification_center
