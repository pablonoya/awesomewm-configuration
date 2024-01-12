local awful_button = require("awful.button")
local gtable = require("gears.table")
local wibox_layout = require("wibox.layout")
local wibox_widget = require("wibox.widget")
local naughty = require("naughty")

local helpers = require("helpers")

local notification_box = require("ui.info-docks.notification-center.notification-box")
local no_notifications = require("ui.info-docks.notification-center.no-notifications")

local all_notifications = {}
local is_empty = true

local list = wibox_widget {
    no_notifications,
    spacing = dpi(8),
    layout = wibox_layout.fixed.vertical
}

-- scrolling notifications list
helpers.add_list_scrolling(list)

local add_notifbox = function(notification)
    if #list.children == 1 and is_empty then
        list:reset()
        is_empty = false
    end

    local new_notification = notification_box(notification)
    table.insert(all_notifications, new_notification)
    list:insert(1, new_notification)
end

naughty.connect_signal(
    "request::display", function(notification)
        if notification.urgency == "low" then
            return
        end

        notification:connect_signal(
            "destroyed", function(self, reason, keep_visble)
                if reason == 1 then
                    add_notifbox(notification)
                end
            end
        )
    end
)

clear_all_notifications = function()
    list:reset()
    list:insert(1, no_notifications)

    all_notifications = {}
    is_empty = true
end

clear_notification = function(notification_widget)
    if #list.children == 1 then
        clear_all_notifications()
    else
        list:remove_widgets(notification_widget)

        for i, notification in ipairs(all_notifications) do
            if notification_widget == notification then
                table.remove(all_notifications, i)
                break
            end
        end
    end
end

awesome.connect_signal(
    "notification_center::visible", function(visible)
        if visible and #all_notifications > 1 then
            table.sort(
                all_notifications, function(n1, n2)
                    return n1.creation_time < n2.creation_time
                end
            )

            list:reset()
            for _, notification in ipairs(all_notifications) do
                list:insert(1, notification)
            end
        end
    end
)

return list
