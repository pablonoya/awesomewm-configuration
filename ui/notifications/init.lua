local awful_screen = require("awful.screen")
local beautiful = require("beautiful")
local gcolor = require("gears.color")
local menubar_utils = require("menubar.utils")
local naughty = require("naughty")

local notification_layout = require("ui.notifications.notification-template")

require("ui.notifications.media")

naughty.config.defaults.screen = awful_screen.focused()

-- XDG icon lookup
naughty.connect_signal(
    "request::icon", function(n, context, hints)
        local path
        -- try use application icon
        if hints.app_icon then
            path = menubar_utils.lookup_icon(hints.app_icon)
        end

        if not path and n.app_name ~= nil and n.app_name ~= "" then
            local app_name, _ = n.app_name:lower():gsub(" ", "-")
            path = menubar_utils.lookup_icon(app_name)
        end

        if path then
            n.icon = path
        else
            n.icon = gcolor.recolor_image(
                beautiful.notification_icon, n.urgency == "critical" and beautiful.red or beautiful.accent
            )
        end
    end
)

naughty.connect_signal("request::display", notification_layout)
