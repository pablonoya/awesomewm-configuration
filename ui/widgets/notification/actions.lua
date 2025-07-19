local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")

local helpers = require("helpers")

return function(notification)
    local actions = wibox.widget {
        notification = notification,
        base_layout = wibox.widget {
            spacing = dpi(4),
            layout = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                id = "text_role",
                halign = "center",
                font = beautiful.font_name .. "Medium 11",
                widget = wibox.widget.textbox
            },
            id = "background_role",
            widget = wibox.container.background
        },
        style = {
            underline_normal = false,
            underline_selected = true,
            fg_normal = beautiful.accent,
            bg_selected = beautiful.focus
        },
        forced_height = dpi(24),
        widget = naughty.list.actions
    }

    return {
        actions,
        shape = helpers.rrect(beautiful.border_radius / 2),
        visible = notification.actions and #notification.actions > 0,
        widget = wibox.container.background
    }
end
