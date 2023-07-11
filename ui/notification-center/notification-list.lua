local awful_button = require("awful.button")
local gtable = require("gears.table")
local wibox_layout = require("wibox.layout")
local wibox_widget = require("wibox.widget")
local naughty = require("naughty")

local notification_box = require("ui.notification-center.notification-box")
local empty_notifbox = require("ui.notification-center.no-notifications")

local is_empty = true

local layout = wibox_widget {
    empty_notifbox,
    spacing = dpi(8),
    layout = wibox_layout.fixed.vertical
}
local all_notifications = {}

-- scrolling notifications
layout:buttons(
    gtable.join(
        awful_button(
            {}, 4, nil, function()
                if #layout.children == 1 then
                    return
                end
                layout:insert(1, layout.children[#layout.children])
                layout:remove(#layout.children)
            end
        ), awful_button(
            {}, 5, nil, function()
                if #layout.children == 1 then
                    return
                end
                layout:insert(#layout.children + 1, layout.children[1])
                layout:remove(1)
            end
        )
    )
)

local notifbox_add = function(notification)
    if #layout.children == 1 and is_empty then
        layout:reset()
        is_empty = false
    end

    local new_notification = notification_box(notification)
    table.insert(all_notifications, new_notification)
    layout:insert(1, new_notification)
end

awesome.connect_signal(
    "notification_center::visible", function(visible)
        if visible and #all_notifications > 1 then
            table.sort(
                all_notifications, function(n1, n2)
                    return n1.creation_time < n2.creation_time
                end
            )

            layout:reset()
            for _, notification in ipairs(all_notifications) do
                layout:insert(1, notification)
            end
        end
    end
)

naughty.connect_signal(
    "request::display", function(notification)
        if notification.urgency == "low" then
            return
        end

        notification:connect_signal(
            "destroyed", function(self, reason, keep_visble)
                if reason == 1 then
                    notifbox_add(notification)
                end
            end
        )
    end
)

clear_notifications = function()
    layout:reset()
    all_notifications = {}
    layout:insert(1, empty_notifbox)
    is_empty = true
end

clear_notification = function(notification_widget)
    if #layout.children == 1 then
        clear_notifications()
    else
        layout:remove_widgets(notification_widget)
        for i, notification in ipairs(all_notifications) do
            if notification_widget == notification then
                table.remove(all_notifications, i)
                break
            end
        end
    end
end

return layout
