local awful_screen = require("awful.screen")

local top_bar = require("ui.bar.top-bar")

local function create_top_bar(s)
    s.bar = top_bar(s)
end

screen.connect_signal("request::desktop_decoration", create_top_bar)
