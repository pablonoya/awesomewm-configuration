local awful_wibar = require("awful.wibar")
local wibox_container = require("wibox.container")
local wibox_layout = require("wibox.layout")

local taglist = require("ui.bar.taglist")
local notifications_and_datetime = require("ui.bar.notifications_and_datetime")
local control_center_button = require("ui.bar.control-center-button")

local client_info = require("ui.bar.widgets.client_info")
local mediabar = require("ui.bar.mediabar")
local systray = require("ui.bar.widgets.systray")
local mic_indicator = require("ui.bar.widgets.mic-indicator")
local battery = require("ui.bar.widgets.battery")
local layoutbox = require("ui.bar.widgets.layoutbox")

return function(s)
    local is_vertical = s.geometry.height > s.geometry.width

    local bar = awful_wibar {
        type = "dock",
        screen = s,
        height = is_vertical and dpi(64) or dpi(40)
    }

    bar:setup{
        {
            {
                layout = wibox_layout.align.horizontal,
                expand = "none",
                -- start
                {
                    client_info,
                    margins = dpi(4),
                    widget = wibox_container.margin
                },
                -- middle
                {
                    taglist(s),
                    left = dpi(8),
                    right = dpi(8),
                    widget = wibox_container.margin
                },
                -- end
                {
                    mediabar(s.geometry.width, is_vertical),
                    systray,
                    mic_indicator,
                    battery(is_vertical),
                    notifications_and_datetime(is_vertical),
                    control_center_button,
                    layoutbox(s),

                    layout = wibox_layout.fixed.horizontal
                }
            },
            margins = dpi(4),
            widget = wibox_container.margin
        },
        widget = wibox_container.background
    }

    return bar
end
