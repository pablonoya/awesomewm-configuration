local awful_placement = require("awful.placement")
local beautiful = require("beautiful")
local gsurface = require("gears.surface")
local menubar_utils = require("menubar.utils")

local function get_icon(client)
    local class, _ = client.instance:gsub(" ", "-")
    local icon_path = menubar_utils.lookup_icon(class)
    return icon_path
end

client.connect_signal(
    "request::manage", function(c)
        -- Add missing icon to client
        if not c.icon then
            local icon = gsurface(get_icon(c))
            c.icon = icon._native
        end

        -- Set the windows at the slave,
        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful_placement.no_offscreen(c)
        end
    end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
    "mouse::enter", function(c)
        c:emit_signal(
            "request::activate", "mouse_enter", {
                raise = false
            }
        )
    end
)

client.connect_signal(
    "focus", function(c)
        c.border_color = beautiful.border_focus
    end
)

client.connect_signal(
    "unfocus", function(c)
        c.border_color = beautiful.xbackground
    end
)
