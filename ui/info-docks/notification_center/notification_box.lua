local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")

local actions = require("ui.widgets.notification.actions")
local dismiss = require("ui.widgets.notification.dismiss")
local icon = require("ui.widgets.notification.icon")
local message = require("ui.widgets.notification.message")
local title = require("ui.widgets.notification.title")

return function(notification)
    local dismiss_btn = dismiss()
    local notifbox = wibox.widget {
        {
            {
                {
                    icon {
                        notification = notification
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
                    top = dpi(4),
                    bottom = dpi(6),
                    left = dpi(8),
                    right = dpi(8),
                    widget = wibox.container.margin
                },
                layout = wibox.layout.fixed.horizontal
            },
            {
                dismiss_btn,
                halign = "right",
                valign = "top",
                widget = wibox.container.place
            },
            layout = wibox.layout.stack
        },
        bg = beautiful.xbackground,
        shape = helpers.rrect(beautiful.border_radius / 2),
        border_width = dpi(1),
        border_color = beautiful.focus,
        widget = wibox.container.background
    }

    -- Show dismiss on hover
    notifbox:connect_signal(
        "mouse::enter", function()
            dismiss_btn.visible = true
        end
    )

    notifbox:connect_signal(
        "mouse::leave", function()
            dismiss_btn.visible = false
        end
    )

    -- Delete notification
    helpers.add_action(
        dismiss_btn, function()
            clear_notification(notifbox)
        end
    )

    notifbox.notification = notification
    return notifbox
end
