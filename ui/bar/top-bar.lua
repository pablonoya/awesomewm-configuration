local awful_screen = require("awful.screen")
local awful_wibar = require("awful.wibar")

local beautiful = require("beautiful")
local wibox = require("wibox")

local taglist = require("ui.bar.taglist")
local notifications_and_datetime = require("ui.bar.notifications_and_datetime")
local control_center_button = require("ui.bar.control-center-button")

local client_info = require("ui.bar.widgets.client_info")
local mediabar = require("ui.bar.mediabar")
local systray = require("ui.bar.widgets.systray")
local mic_indicator = require("ui.bar.widgets.mic_indicator")
local battery = require("ui.bar.widgets.battery")
local layoutbox = require("ui.bar.widgets.layoutbox")

local function top_bar(s)
    local is_vertical = s.geometry.height > s.geometry.width

    local bar = awful_wibar {
        type = "dock",
        screen = s,
        height = is_vertical and dpi(64) or dpi(40)
    }

    bar:setup{
        {
            {
                layout = wibox.layout.align.horizontal,
                expand = "none",
                -- start
                {
                    layoutbox(s),
                    wibox.widget.separator {
                        orientation = "vertical",
                        color = beautiful.xforeground .. "70",
                        thickness = dpi(2),
                        span_ratio = 0.6,
                        forced_width = dpi(2)
                    },
                    client_info,
                    spacing = dpi(4),
                    layout = wibox.layout.fixed.horizontal
                },
                -- middle
                {
                    taglist(s),
                    left = dpi(8),
                    right = dpi(8),
                    widget = wibox.container.margin
                },
                -- end
                {
                    mediabar(s.geometry.width, is_vertical),
                    systray,
                    mic_indicator,
                    battery(is_vertical),
                    notifications_and_datetime(is_vertical),
                    control_center_button,

                    layout = wibox.layout.fixed.horizontal
                }
            },
            margins = dpi(4),
            widget = wibox.container.margin
        },
        widget = wibox.container.background
    }

    return bar
end

local function create_top_bar(s)
    s.bar = top_bar(s)
end

screen.connect_signal("request::desktop_decoration", create_top_bar)
