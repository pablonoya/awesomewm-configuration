local playerctl = require("signals.playerctl")
local notification = require("naughty.notification")

-- local play_pause = naughty.action {
--   name = "play"
-- }

-- play_pause:connect_signal(
--     "invoked", function(action)
--         instance:play_pause()
--     end
-- )

playerctl:connect_signal(
    "metadata", function(_, title, artist, album_path, album, new, player_name)
        if new == true then
            notification {
                urgency = "low",
                app_name = player_name,
                title = artist,
                message = '🎵 ' .. title .. (album ~= "" and "\n💿 " .. album or ""),
                image = album_path
                -- actions = {
                --     naughty.action {
                --         name = "prev"
                --     }, play_pause, naughty.action {
                --         name = "next"
                --     }

                -- }
            }
        end
    end
)
