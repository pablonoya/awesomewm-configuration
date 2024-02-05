local beautiful = require("beautiful")
local gstring = require("gears.string")
local wibox = require("wibox")

local playerctl = require("signals.playerctl")

local scrolling_text = require("ui.widgets.scrolling-text")

local media_title = scrolling_text {
    title = "Title",
    font = beautiful.font_name .. 12,
    speed = 32,
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth
}

local artist_and_album = scrolling_text {
    text = "Artist",
    speed = 32,
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth
}

playerctl:connect_signal(
    "metadata", function(_, title, artist, _, album_name, new)
        media_title.text.text = gstring.xml_unescape(title)
        artist_and_album.text.text = gstring.xml_unescape(
            artist .. (album_name ~= "" and " • " .. album_name or "")
        )
        if new then
            media_title:reset_scrolling()
            artist_and_album:reset_scrolling()
        end
    end
)

return wibox.widget {
    media_title,
    artist_and_album,
    layout = wibox.layout.fixed.vertical
}
