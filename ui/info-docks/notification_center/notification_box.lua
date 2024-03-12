local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")

local actions = require("ui.widgets.notification.actions")
local dismiss = require("ui.widgets.notification.dismiss")
local icon = require("ui.widgets.notification.icon")
local message = require("ui.widgets.notification.message")
local time_elapsed = require("ui.widgets.notification.time_elapsed")
local title = require("ui.widgets.notification.title")

local function notification_box(notification)
    local time_of_notification = os.date("%H:%M:%S")
    local exact_time = os.date("%I:%M %p")
    local exact_date = os.date("%d.%m.%y")

    local dismiss_btn = dismiss()
    local time_elapsed_text = time_elapsed(time_of_notification, exact_time, exact_date)

    local notifbox = wibox.widget {
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
                    {
                        title {
                            notification = notification,
                            forced_width = dpi(170)
                        },
                        {
                            time_elapsed_text,
                            dismiss_btn,
                            forced_width = dpi(64),
                            layout = wibox.layout.stack
                        },
                        spacing = dpi(8),
                        layout = wibox.layout.fixed.horizontal
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
        bg = beautiful.xbackground,
        shape = helpers.rrect(beautiful.border_radius / 2),
        border_width = dpi(1),
        border_color = beautiful.focus,
        widget = wibox.container.background
    }

    -- Show dismiss on hover
    notifbox:connect_signal(
        "mouse::enter", function()
            time_elapsed_text.visible = false
            dismiss_btn.visible = true
        end
    )

    notifbox:connect_signal(
        "mouse::leave", function()
            time_elapsed_text.visible = true
            dismiss_btn.visible = false
        end
    )

    -- Delete notification
    helpers.add_action(
        dismiss_btn, function()
            clear_notification(notifbox)
        end
    )

    notifbox.creation_time = os.time()
    return notifbox
end

return notification_box
