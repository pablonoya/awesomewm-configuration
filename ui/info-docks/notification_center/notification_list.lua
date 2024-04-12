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

local add_notifbox = function(notification)
    if #list.children == 1 and is_empty then
        list:reset()
        is_empty = false
    end

    local new_notification = notification_box(notification)

    list:insert(1, new_notification)
    all_notifications = list.children
    awesome.emit_signal("notifications::count", #all_notifications)
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
                self.is_expired = true
            end
        )
    end
)

clear_all_notifications = function()
    list:reset()
    list:insert(1, no_notifications)

    all_notifications = {}
    is_empty = true
    awesome.emit_signal("notifications::count", 0)
end

clear_notification = function(notification_widget)
    if #list.children == 1 then
        clear_all_notifications()
    else
        list:remove_widgets(notification_widget)
        all_notifications = list.children
        awesome.emit_signal("notifications::count", #all_notifications)
    end
end

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
