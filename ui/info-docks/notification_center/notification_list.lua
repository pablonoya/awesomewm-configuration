local wibox_layout = require("wibox.layout")
local wibox_widget = require("wibox.widget")
local naughty = require("naughty")

local helpers = require("helpers")

local notification_box = require("ui.info-docks.notification_center.notification_box")
local no_notifications = require("ui.info-docks.notification_center.no_notifications")

local all_notifications = {}
local is_empty = true

local list = wibox_widget {
    no_notifications,
    spacing = dpi(8),
    layout = wibox_layout.fixed.vertical
}

-- scrolling notifications list
helpers.add_list_scrolling(list)

function add_to_list(notification)
    if #list.children == 1 and is_empty then
        list:reset()
        is_empty = false
    end

    list:insert(1, notification_box(notification))
    all_notifications = list.children

    awesome.emit_signal("notifications::count", #all_notifications)
end

function clear_all_notifications()
    list:reset()
    list:insert(1, no_notifications)

    all_notifications = {}
    is_empty = true
    awesome.emit_signal("notifications::count", 0)
end

function clear_notification(notification_widget)
    if #list.children == 1 then
        clear_all_notifications()
    else
        list:remove_widgets(notification_widget)
        all_notifications = list.children
        awesome.emit_signal("notifications::count", #all_notifications)
    end
end

naughty.connect_signal(
    "request::display", function(notification)
        if notification.urgency == "low" then
            return
        end

        notification:connect_signal(
            "destroyed", function(self, reason, keep_visble)
                if reason == naughty.notification_closed_reason.expired then
                    add_to_list(notification)
                end
                self.is_expired = true
            end
        )
    end
)

awesome.connect_signal(
    "notification_center::visible", function(visible)
        if visible and #all_notifications > 1 then
            table.sort(
                all_notifications, function(n1, n2)
                    return n1.creation_time > n2.creation_time
                end
            )

            list.children = all_notifications
        end
    end
)

return list
