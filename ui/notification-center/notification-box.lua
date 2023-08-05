local awful_button = require("awful.button")
local beautiful = require("beautiful")
local gtable = require("gears.table")
local gtimer = require("gears.timer")
local naughty_icon = require("naughty.widget.icon")

local wibox_container = require("wibox.container")
local wibox_layout = require("wibox.layout")
local wibox_widget = require("wibox.widget")

local helpers = require("helpers")

local icon = require("ui.widgets.notification.icon")
local title = require("ui.widgets.notification.title")
local dismiss = require("ui.widgets.notification.dismiss")
local message = require("ui.widgets.notification.message")
local actions = require("ui.widgets.notification.actions")

local time_in_seconds = function(time)
    local hours = tonumber(string.sub(time, 1, 2)) * 3600
    local mins = tonumber(string.sub(time, 4, 5)) * 60
    local secs = tonumber(string.sub(time, 7, 8))

    return (hours + mins + secs)
end

return function(notification)
    local time_of_pop = os.date("%H:%M:%S")
    local exact_time = os.date("%I:%M %p")
    local exact_date = os.date("%d.%m.%y")

    local timepop = wibox_widget {
        markup = "now",
        font = beautiful.font_name .. "10",
        halign = "right",
        widget = wibox_widget.textbox
    }

    local time_of_popup = gtimer {
        timeout = 60,
        call_now = true,
        autostart = true,
        callback = function()
            local time_difference = (
                time_in_seconds(os.date("%H:%M:%S")) - time_in_seconds(time_of_pop)
            )
            if time_difference >= 60 and time_difference < 3600 then
                local time_in_minutes = math.floor(time_difference / 60)
                timepop:set_markup(time_in_minutes .. "m ago")

            elseif time_difference >= 3600 and time_difference < 86400 then
                timepop:set_markup(exact_time)

            elseif time_difference >= 86400 then
                timepop:set_markup(exact_date)
                return false
            end
        end
    }

    local dismiss_btn = dismiss()

    local notifbox = wibox_widget {
        {
            {
                icon {
                    icon = notification.icon
                },
                bg = beautiful.black,
                widget = wibox_container.background
            },
            {
                {
                    {
                        title {
                            title = notification.title,
                            app_name = notification.app_name,
                            forced_width = dpi(170)
                        },
                        {
                            timepop,
                            dismiss_btn,
                            forced_width = dpi(64),
                            layout = wibox_layout.stack
                        },
                        spacing = dpi(8),
                        layout = wibox_layout.fixed.horizontal
                    },
                    message(notification),
                    actions(notification),
                    spacing = dpi(8),
                    layout = wibox_layout.fixed.vertical
                },
                top = dpi(4),
                bottom = dpi(4),
                left = dpi(8),
                right = dpi(8),
                widget = wibox_container.margin
            },
            layout = wibox_layout.fixed.horizontal
        },
        bg = beautiful.xbackground,
        shape = helpers.rrect(beautiful.border_radius / 2),
        border_width = dpi(1),
        border_color = beautiful.focus,
        widget = wibox_container.background
    }

    -- Show dismiss on hover
    notifbox:connect_signal(
        "mouse::enter", function()
            timepop.visible = false
            dismiss_btn.visible = true
        end
    )

    notifbox:connect_signal(
        "mouse::leave", function()
            timepop.visible = true
            dismiss_btn.visible = false
        end
    )

    -- Delete notification
    helpers.add_action(
        dismiss_btn, function()
            clear_notification(notifbox)
        end
    )

    collectgarbage("collect")

    notifbox.creation_time = os.time()
    return notifbox
end
