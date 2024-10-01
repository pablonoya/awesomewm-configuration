local awful = require("awful")
local notification = require("naughty.notification")

local helpers = require("helpers")
local modkeys = require("bindings.modkeys")
local modkey, alt, ctrl, shift = table.unpack(modkeys)

local function move_client_to_screen(client, direction)
    local next_screen = helpers.get_next_screen(direction)

    client:move_to_screen(next_screen)
    client:raise()
end

-- Client management keybinds
client.connect_signal(
    "request::default_keybindings", function()
        awful.keyboard.append_client_keybindings {
            awful.key(
                {modkey, ctrl}, "Up", function(c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                end, {
                    description = "Toggle fullscreen",
                    group = "client::toggle"
                }
            ), awful.key(
                {modkey, ctrl}, "a", function(c)
                    c.ontop = not c.ontop
                end, {
                    description = "Toggle ontop",
                    group = "client::toggle"
                }
            ), awful.key(
                {modkey, shift}, "a", function(c)
                    c.sticky = not c.sticky
                end, {
                    description = "Toggle sticky",
                    group = "client::toggle"
                }
            ), awful.key(
                {modkey}, "f", awful.client.floating.toggle, {
                    description = "Toggle floating",
                    group = "client::toggle"
                }
            ), awful.key(
                {modkey, ctrl}, "Down", function(c)
                    -- The client currently has the input focus, so it cannot be
                    -- minimized, since minimized clients can"t have the focus.
                    c.minimized = true
                end, {
                    description = "Minimize",
                    group = "client"
                }
            ), awful.key(
                {modkey}, "m", function(c)
                    c.maximized = not c.maximized
                    c:raise()
                end, {
                    description = "Toggle maximized",
                    group = "client::toggle"
                }
            ), awful.key(
                {modkey}, "w", function(c)
                    c:kill()
                end, {
                    description = "Close window",
                    group = "client"
                }
            ), awful.key(
                {alt}, "F4", function(c)
                    c:kill()
                end, {
                    description = "Close window",
                    group = "client"
                }
            ), -- Single tap: Center client. Double tap: Center client + Floating + Resize
            awful.key(
                {modkey}, "c", function(c)
                    awful.placement.centered(
                        c, {
                            honor_workarea = true,
                            honor_padding = true
                        }
                    )
                    helpers.single_double_tap(
                        nil, function()
                            local focused_screen_geometry = awful.screen.focused().geometry
                            helpers.float_and_resize(
                                c, focused_screen_geometry.width * 0.5,
                                focused_screen_geometry.height * 0.5
                            )
                        end
                    )
                end, {
                    description = "Center client",
                    group = "client"
                }
            ), awful.key(
                {modkey, shift}, "Return", function(c)
                    c:swap(awful.client.getmaster())
                end, {
                    description = "Move to master",
                    group = "client"
                }
            ), awful.key(
                {modkey, shift}, "]", function(c)
                    move_client_to_screen(c, "right")
                end, {
                    description = "Move client to next screen",
                    group = "screen"
                }
            ), awful.key(
                {modkey, shift}, "[", function(c)
                    move_client_to_screen(c, "left")
                end, {
                    description = "Move client to previous screen",
                    group = "screen"
                }
            )
        }
    end
)

-- Mouse buttons on the client
client.connect_signal(
    "request::default_mousebindings", function()
        awful.mouse.append_client_mousebindings {
            awful.button(
                {}, 1, function(c)
                    c:activate{
                        context = "mouse_click"
                    }
                end
            ), awful.button(
                {modkey}, 1, function(c)
                    c:activate{
                        context = "mouse_click",
                        action = "mouse_move"
                    }
                end
            ), awful.button(
                {modkey}, 3, function(c)
                    c:activate{
                        context = "mouse_click",
                        action = "mouse_resize"
                    }
                end
            )
        }
    end
)
