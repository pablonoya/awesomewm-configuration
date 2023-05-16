local gstring = require("gears.string")
local notification = require("naughty.notification")

local playerctl = require("signals.playerctl")

playerctl:connect_signal(
    "metadata", function(_, title, artist, album_path, album, new, player_name)
        if new == true then
            notification {
                urgency = "low",
                app_name = player_name,
                title = gstring.xml_unescape(artist),
                text = gstring.xml_unescape(
                    '🎵 ' .. title .. (album ~= "" and "\n💿 " .. album or "")
                ),
                image = album_path
            }
        end
    end
)
