local gstring = require("gears.string")
local notification = require("naughty.notification")

local playerctl = require("signals.playerctl")

local last_notification

local function notification_text(title, album)
    return gstring.xml_unescape("🎵 " .. title .. (album ~= "" and "\n💿 " .. album or ""))
end

playerctl:connect_signal(
    "metadata", function(_, title, artist, album_path, album, new, player_name)
        if last_notification and not last_notification.is_expired then
            last_notification.icon = album_path
            last_notification.title = gstring.xml_unescape(title)
            last_notification.app_name = player_name
            last_notification.message = notification_text(title, album)

        else
            last_notification = notification {
                urgency = "low",
                icon = album_path,
                title = gstring.xml_unescape(title),
                app_name = player_name,
                message = notification_text(title, album),
                auto_reset_timeout = true
            }
        end
    end
)
