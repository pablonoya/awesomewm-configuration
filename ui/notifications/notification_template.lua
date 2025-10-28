local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")

local actions = require("ui.widgets.notification.actions")
local icon = require("ui.widgets.notification.icon")
local message = require("ui.widgets.notification.message")
local title = require("ui.widgets.notification.title")

local helpers = require("helpers")

local urgency_color = {
    low = beautiful.xbackground,
    normal = beautiful.focus,
    critical = beautiful.red
}

local function notification_layout(notification)
    notification.creation_time = os.time()

    local template = {
        {
            icon {
                notification = notification,
                size = dpi(32)
            },
            bg = beautiful.black,
            widget = wibox.container.background
        },
        {
            {
                title {
                    notification = notification
                },
                message(notification),
                actions(notification),
                spacing = dpi(8),
                layout = wibox.layout.fixed.vertical
            },
            left = dpi(12),
            right = dpi(12),
            top = dpi(8),
            bottom = dpi(8),
            widget = wibox.container.margin
        },
        layout = wibox.layout.fixed.horizontal,
        widget = wibox.container.background
    }

    naughty.layout.box {
        notification = notification,
        type = "notification",
        border_color = urgency_color[notification.urgency],
        border_width = dpi(2),
        maximum_width = beautiful.notif_center_width,
        maximum_height = dpi(330),
        widget_template = template,
        shape = helpers.rrect(beautiful.border_radius)
    }
end

naughty.connect_signal("request::display", notification_layout)
