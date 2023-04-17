local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")

local icon = require("ui.widgets.notification.icon")
local title = require("ui.widgets.notification.title")
local dismiss = require("ui.widgets.notification.dismiss")
local message = require("ui.widgets.notification.message")
local actions = require("ui.widgets.notification.actions")

local helpers = require("helpers")

local urgency_color = {
    low = beautiful.xbackground,
    normal = beautiful.focus,
    critical = beautiful.red
}

return function(notification)
    local template = {
        {
            icon {
                icon = notification.icon,
                size = dpi(32)
            },
            bg = beautiful.black,
            widget = wibox.container.background
        },
        {
            {
                {
                    title {
                        title = notification.title,
                        app_name = notification.app_name,
                        size = 12,
                        forced_width = dpi(188)
                    },
                    {
                        markup = os.date("%I:%M"),
                        font = beautiful.font_name .. " 11",
                        align = "right",
                        widget = wibox.widget.textbox
                    },
                    spacing = dpi(12),
                    layout = wibox.layout.fixed.horizontal
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
        maximum_width = dpi(320),
        widget_template = template,
        shape = helpers.rrect(beautiful.border_radius)
    }
end
