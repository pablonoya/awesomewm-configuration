local gtimer = require("gears.timer")
local naughty = require("naughty")
local wibox = require("wibox")

local helpers = require("helpers")

local notification_box = require("ui.info-docks.notification_center.notification_box")

local all_notifications = {}

local list = wibox.widget {
    spacing = dpi(8),
    layout = wibox.layout.fixed.vertical
}

-- scrolling notifications list
helpers.add_list_scrolling(list)

local function add_to_list(notification)
    list:insert(1, notification_box(notification))
    all_notifications = list.children
    awesome.emit_signal("notifications::count", #all_notifications)
end

function clear_all_notifications()
    list:reset()
    all_notifications = {}
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

local function update_notification_titles()
    for _, widget in pairs(all_notifications) do
        widget.notification:emit_signal("property::title")
    end
end

local elapsed_timer = gtimer {
    timeout = 30,
    callback = update_notification_titles
}

awesome.connect_signal(
    "notification_center::visible", function(visible)
        if visible then
            update_notification_titles()
            elapsed_timer:start()
        else
            elapsed_timer:stop()
        end

        if visible and #all_notifications > 1 then
            table.sort(
                all_notifications, function(n1, n2)
                    return n1.notification.creation_time > n2.notification.creation_time
                end
            )

            list.children = all_notifications
        end
    end
)

return list
