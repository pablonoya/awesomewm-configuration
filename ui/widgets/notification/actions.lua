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
                {
                    id = "text_role",
                    widget = wibox.widget.textbox
                },
                layout = wibox.container.place
            },
            id = "background_role",
            widget = wibox.container.background
        },
        style = {
            underline_normal = false,
            underline_selected = true,
            bg_normal = beautiful.focus .. "E0",
            bg_selected = beautiful.focus,
            shape_normal = helpers.rrect(beautiful.border_radius / 4)
        },
        forced_height = dpi(25),
        widget = naughty.list.actions
    }

    helpers.add_hover_cursor(actions, "hand2")

    return {
        actions,
        shape = helpers.rrect(beautiful.border_radius / 2),
        visible = notification.actions and #notification.actions > 0,
        widget = wibox.container.background
    }
end
