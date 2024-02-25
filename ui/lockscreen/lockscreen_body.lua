local beautiful = require("beautiful")
local wibox = require("wibox")

local helpers = require("helpers")

local wordclock = require("ui.lockscreen.wordclock")
local lock_animation = require("ui.lockscreen.lock_animation")

return wibox.widget {
    {
        {
            {
                wordclock,
                lock_animation,
                spacing = dpi(40),
                layout = wibox.layout.fixed.vertical
            },
            margins = dpi(64),
            widget = wibox.container.margin
        },
        id = "container",
        shape = helpers.rrect(beautiful.border_radius),
        bg = beautiful.xbackground,
        border_color = beautiful.focus,
        border_width = dpi(2),
        widget = wibox.container.background
    },
    widget = wibox.container.place
}
