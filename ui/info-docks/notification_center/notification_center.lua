local beautiful = require("beautiful")
local wibox = require("wibox")

local border_popup = require("ui.widgets.border-popup")

local no_notifications = require("ui.info-docks.notification_center.no_notifications")
local notification_list = require("ui.info-docks.notification_center.notification_list")
local clear_all = require("ui.info-docks.notification_center.clear_all")
local suspend = require("ui.info-docks.notification_center.suspend")

local header = wibox.widget {
    {
        id = "label",
        text = "Notifications",
        font = beautiful.font_name .. "Bold 11",
        align = "left",
        valign = "center",
        widget = wibox.widget.textbox
    },
    nil,
    {
        suspend,
        clear_all,
        spacing = dpi(2),
        layout = wibox.layout.fixed.horizontal
    },
    layout = wibox.layout.align.horizontal
}

awesome.connect_signal(
    "notifications::count", function(count)
        no_notifications.visible = count == 0

        header.label:set_markup_silently(
            "Notifications" .. (count > 0 and string.format(" (%d)", count) or "")
        )
    end
)

local notification_center = border_popup {
    widget = wibox.widget {
        {
            header,
            no_notifications,
            notification_list,
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(2)
        },
        top = dpi(2),
        left = dpi(8),
        right = dpi(8),
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
