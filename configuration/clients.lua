local awful_placement = require("awful.placement")
local beautiful = require("beautiful")
local gsurface = require("gears.surface")
local gcolor = require("gears.color")
local menubar_utils = require("menubar.utils")

local icons = require("ui.icons")

local default_client_icon = gcolor.recolor_image(icons.window, beautiful.xforeground)

local function get_icon(client)
    if not client.instance then
        return default_client_icon
    end

    local class, _ = client.instance:gsub(" ", "-")
    local icon_path = menubar_utils.lookup_icon(class)

    -- try using the client class
    if not icon_path and client.class then
        icon_path = menubar_utils.lookup_icon(client.class:gsub(" ", "-"))
    end

    return icon_path or default_client_icon
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
