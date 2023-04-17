local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")

local layout_list = awful.widget.layoutlist {
    base_layout = wibox.widget {
        spacing = dpi(4),
        forced_num_cols = 4,
        layout = wibox.layout.grid.vertical
    },
    widget_template = {
        {
            {
                id = "icon_role",
                widget = wibox.widget.imagebox
            },
            margins = dpi(12),
            widget = wibox.container.margin
        },
        id = "background_role",
        forced_width = dpi(64),
        forced_height = dpi(64),
        widget = wibox.container.background
    }
}

local layout_popup = awful.popup {
    widget = wibox.widget {
        layout_list,
        margins = dpi(12),
        widget = wibox.container.margin
    },
    bg = beautiful.black,
    border_width = dpi(2),
    border_color = beautiful.xbackground,
    placement = awful.placement.centered,
    ontop = true,
    visible = false
}

-- Override default Mod4+Space and Mod4+Shift+Space keybindings
awful.keygrabber {
    start_callback = function()
        awful.placement.centered(
            layout_popup, {
                parent = awful.screen.focused()
            }
        )
        layout_popup.visible = true
    end,
    stop_callback = function()
        layout_popup.visible = false
    end,
    export_keybindings = true,
    stop_event = "release",
    stop_key = {"Escape", "Super_L", "Super_R"},
    keybindings = {
        {
            {"Mod4"}, " ", function()
                awful.layout.set((gears.table.cycle_value(layout_list.layouts, layout_list.current_layout, 1)))
            end
        }, {
            {"Mod4", "Shift"}, " ", function()
                awful.layout.set(gears.table.cycle_value(layout_list.layouts, layout_list.current_layout, -1), nil)
            end
        }
    }
}
