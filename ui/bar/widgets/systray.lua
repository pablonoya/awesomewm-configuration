local awful_screen = require("awful.screen")
local only_on_screen = require("awful.widget.only_on_screen")
local beautiful = require("beautiful")
local wibox_container = require("wibox.container")
local wibox_widget = require("wibox.widget")

local helpers = require("helpers")

local focused_screen = awful_screen.focused()

local tray = wibox_widget {
    base_size = 24,
    screen = focused_screen,
    widget = wibox_widget.systray
}

local systray = wibox_widget {
    {
        {
            {
                tray,
                margins = dpi(4),
                widget = wibox_container.margin
            },
            widget = wibox_container.place
        },
        id = "background",
        shape = helpers.rrect(beautiful.border_radius),
        widget = wibox_container.background
    },
    screen = focused_screen,
    widget = only_on_screen
}

systray:connect_signal(
    "mouse::enter", function()
        systray.background.bg = beautiful.focus
        beautiful.bg_systray = beautiful.focus
    end
)

systray:connect_signal(
    "mouse::leave", function()
        systray.background.bg = beautiful.transparent
        beautiful.bg_systray = beautiful.wibar_bg
    end
)

client.connect_signal(
    "focus", function()
        local focused_screen = awful_screen.focused()

        if focused_screen.geometry.height > focused_screen.geometry.width then
            beautiful.systray_max_rows = 2
            tray.base_size = 21
        else
            beautiful.systray_max_rows = 1
            tray.base_size = 24
        end

        tray.screen = focused_screen
        systray.screen = focused_screen
    end
)

return {
    systray,
    left = dpi(4),
    right = dpi(4),
    widget = wibox_container.margin
}
