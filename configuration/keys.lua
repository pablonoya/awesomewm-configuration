local awful = require("awful")
local awful_key = require("awful.key")
local awful_keyboard = require("awful.keyboard")

local spawn = require("awful.spawn")
local naughty = require("naughty")

local helpers = require("helpers")
local system_controls = require("helpers.system-controls")

local playerctl = require("signals.playerctl")
local ytm_scratchpad = require("ui.scratchpad")
local hotkeys_popup = require("ui.hotkeys_popup")

local revelation = require("away.third_party.revelation")

-- Default modkey.
local modkey = "Mod4"
local alt = "Mod1"
local ctrl = "Control"
local shift = "Shift"

-- Awesome stuff
awful_keyboard.append_global_keybindings {
    awful_key(
        {modkey}, "F1", hotkeys_popup.show_help, {
            description = "show help",
            group = "awesome"
        }
    ), awful_key(
        {modkey, ctrl}, "r", awesome.restart, {
            description = "reload awesome",
            group = "awesome"
        }
    ), awful_key(
        {modkey, ctrl}, "q", awesome.quit, {
            description = "quit awesome",
            group = "awesome"
        }
    ), awful_key(
        {modkey, alt}, "l", function()
            lock_screen_show()
        end, {
            description = "lock screen",
            group = "awesome"
        }
    ), awful_key(
        {}, "XF86PowerOff", function()
            awesome.emit_signal("exit_screen::show")
        end, {
            description = "exit screen",
            group = "awesome"
        }
    ), awful_key({}, "XF86Sleep", lock_screen_show), awful_key(
        {modkey}, "n", function()
            awesome.emit_signal("notification_center::toggle")
        end, {
            description = "toggle notif center",
            group = "awesome"
        }
    ), awful_key(
        {modkey}, "x", function()
            if not naughty.suspended then
                naughty.destroy_all_notifications()
            end
            naughty.suspended = not naughty.suspended
            naughty.emit_signal("property::suspended", naughty, naughty.suspended)
        end, {
            description = "Toggle don't disturb",
            group = "awesome"
        }
    )
}

-- Launcher
awful_keyboard.append_global_keybindings {
    awful_key(
        {modkey}, "Return", function()
            spawn("kitty")
        end, {
            description = "open terminal",
            group = "launcher"
        }
    ), awful_key(
        {modkey}, "s", function()
            ytm_scratchpad:reapply_geometry()
            ytm_scratchpad:toggle()
        end, {
            description = "Toggle scratchpad",
            group = "launcher"
        }
    ), awful_key(
        {modkey}, "a", function()
            awesome.emit_signal("control_center::toggle")
        end, {
            description = "toggle control center",
            group = "launcher"
        }
    ), awful_key(
        {modkey}, "e", function()
            spawn("dolphin")
        end, {
            description = "open file manager",
            group = "launcher"
        }
    ), awful_key(
        {modkey}, "w", function()
            if client.focus then
                client.focus:kill()
            end
        end, {
            description = "close window",
            group = "launcher"
        }
    ), awful_key(
        {modkey}, "p", function()
            spawn.easy_async_with_shell(
                "autorandr --cycle", function(stdout)
                    naughty.notification {
                        text = stdout
                    }
                end
            )
        end, {
            description = "cycle autorandr",
            group = "launcher"
        }
    ), awful_key(
        {modkey}, "Tab", revelation, {
            description = "Use revelation",
            group = "launcher"
        }
    ), awful_key(
        {alt}, "F4", function()
            if client.focus then
                client.focus:kill()
            end
        end, {
            description = "close window",
            group = "launcher"
        }
    ), awful_key(
        {modkey}, "v", function()
            spawn.with_shell("diodon")
        end, {
            description = "open diodon",
            group = "launcher"
        }
    ), awful_key(
        {modkey, shift}, "c", function(c)
            naughty.notification {
                text = "Garbage collected"
            }
            collectgarbage("collect")
        end
    )
}

-- Client Bindings
awful_keyboard.append_global_keybindings {
    awful_key {
        modifiers = {modkey},
        keygroup = "arrows",
        description = "focus client by direction",
        group = "client",
        on_press = function(key)
            awful.client.focus.bydirection(key:lower())
        end
    }, awful_key(
        {modkey}, "h", function()
            awful.client.focus.bydirection("left")
        end, {
            description = "focus left client",
            group = "client"
        }
    ), awful_key(
        {modkey}, "j", function()
            awful.client.focus.bydirection("down")
        end, {
            description = "focus down client",
            group = "client"
        }
    ), awful_key(
        {modkey}, "k", function()
            awful.client.focus.bydirection("up")
        end, {
            description = "focus up client",
            group = "client"
        }
    ), awful_key(
        {modkey}, "l", function()
            awful.client.focus.bydirection("right")
        end, {
            description = "focus right client",
            group = "client"
        }
    ), awful_key(
        {modkey, "Shift"}, "j", function()
            awful.client.swap.byidx(1)
        end, {
            description = "swap with next client",
            group = "client"
        }
    ), awful_key(
        {modkey, "Shift"}, "k", function()
            awful.client.swap.byidx(-1)
        end, {
            description = "swap with previous client",
            group = "client"
        }
    ), awful_key(
        {modkey}, "u", awful.client.urgent.jumpto, {
            description = "jump to urgent client",
            group = "client"
        }
    ), awful_key(
        {alt}, "Tab", function()
            awesome.emit_signal("bling::window_switcher::turn_on")
        end, {
            description = "window switcher",
            group = "client"
        }
    )
}

-- Hotkeys
awful_keyboard.append_global_keybindings {
    -- Brightness Control
    awful_key(
        {}, "XF86MonBrightnessUp", function()
            system_controls.brightness_control("increase")
        end, {
            description = "increase brightness",
            group = "hotkeys"
        }
    ), awful_key(
        {}, "XF86MonBrightnessDown", function()
            system_controls.brightness_control("decrease")
        end, {
            description = "decrease brightness",
            group = "hotkeys"
        }
    ), -- Volume control
    awful_key(
        {}, "XF86AudioRaiseVolume", function()
            system_controls.volume_control("increase", 5)
        end, {
            description = "increase volume",
            group = "hotkeys"
        }
    ), awful_key(
        {}, "XF86AudioLowerVolume", function()
            system_controls.volume_control("decrease", 5)
        end, {
            description = "decrease volume",
            group = "hotkeys"
        }
    ), awful_key(
        {}, "XF86AudioMute", function()
            system_controls.volume_control("mute")
        end, {
            description = "mute volume",
            group = "hotkeys"
        }
    ), awful_key(
        {}, "XF86AudioMicMute", function()
            system_controls.mic_toggle()
        end, {
            description = "mute microphone",
            group = "hotkeys"
        }
    ), -- Music
    awful_key(
        {}, "XF86AudioPlay", function()
            playerctl:play_pause()
        end, {
            description = "toggle music",
            group = "hotkeys"
        }
    ), awful_key(
        {}, "Insert", function()
            playerctl:play_pause()
        end, {
            description = "toggle music",
            group = "hotkeys"
        }
    ), awful_key(
        {}, "XF86AudioPrev", function()
            playerctl:previous()
        end, {
            description = "previous music",
            group = "hotkeys"
        }
    ), awful_key(
        {}, "XF86AudioNext", function()
            playerctl:next()
        end, {
            description = "next music",
            group = "hotkeys"
        }
    )
}

-- Screenshots
awful_keyboard.append_global_keybindings {
    awful_key(
        {}, "Print", function()
            spawn.with_shell("flameshot gui")
        end, {
            description = "take an area screenshot",
            group = "screenshots"
        }
    ), awful_key(
        {modkey, shift}, "s", function()
            spawn.with_shell("flameshot gui")
        end, {
            description = "take an area screenshot",
            group = "screenshots"
        }
    ), awful_key(
        {alt}, "Print", function()
            spawn.with_shell("flameshot full")
        end, {
            description = "take a full screenshot",
            group = "screenshots"
        }
    )
}

-- Asusctl
awful_keyboard.append_global_keybindings {
    awful_key(
        {}, "XF86KbdBrightnessUp", function()
            spawn("asusctl -n")
        end, {
            description = "increase keyboard brightness",
            group = "hotkeys (asusctl)"
        }
    ), awful_key(
        {}, "XF86KbdBrightnessDown", function()
            spawn("asusctl -p")
        end, {
            description = "decrease keyboard brightness",
            group = "hotkeys (asusctl)"
        }
    ), awful_key(
        {}, "XF86Launch4", function()
            spawn("asusctl profile -n")
        end, {
            description = "asusctl next fan profile",
            group = "hotkeys (asusctl)"
        }
    )
}

local function get_next_screen(direction)
    local previous_direction = direction == "right" and "left" or "right"
    local screen = awful.screen.focused()
    if (screen.get_next_in_direction(screen, direction)) then
        return screen.get_next_in_direction(screen, direction)
    end

    while screen.get_next_in_direction(screen, previous_direction) ~= nil do
        screen = screen.get_next_in_direction(screen, previous_direction)
    end

    return screen
end
-- Screen
awful_keyboard.append_global_keybindings {
    awful_key(
        {modkey}, "]", function()
            awful.screen.focus(get_next_screen("right"))
        end, {
            description = "focus the next screen",
            group = "screen"
        }
    ), awful_key(
        {modkey}, "[", function()
            local screen = awful.screen.focused()
            awful.screen.focus(get_next_screen("left"))
        end, {
            description = "focus the previous screen",
            group = "screen"
        }
    )
}

-- Layout
awful_keyboard.append_global_keybindings {
    awful_key(
        {modkey, ctrl}, "k", function()
            awful.tag.incmwfact(0.05)
        end, {
            description = "increase master width factor",
            group = "layout"
        }
    ), awful_key(
        {modkey, ctrl}, "j", function()
            awful.tag.incmwfact(-0.05)
        end, {
            description = "decrease master width factor",
            group = "layout"
        }
    ), awful_key(
        {modkey, "Shift"}, "h", function()
            awful.tag.incnmaster(1, nil, true)
        end, {
            description = "increase #master clients",
            group = "layout"
        }
    ), awful_key(
        {modkey, "Shift"}, "l", function()
            awful.tag.incnmaster(-1, nil, true)
        end, {
            description = "decrease #master clients",
            group = "layout"
        }
    ), awful_key(
        {modkey, "Control"}, "l", function()
            awful.tag.incncol(1, nil, true)
        end, {
            description = "increase #columns",
            group = "layout"
        }
    ), awful_key(
        {modkey, "Control"}, "h", function()
            awful.tag.incncol(-1, nil, true)
        end, {
            description = "decrease #columns",
            group = "layout"
        }
    ), awful_key(
        {modkey}, "space", function()
        end, {
            description = "select next layout",
            group = "layout"
        }
    ), awful_key(
        {modkey, "Shift"}, "space", function()
        end, {
            description = "select previous layout",
            group = "layout"
        }
    ), --
    awful_key(
        {modkey, shift}, "m", function()
            awful.layout.set(awful.layout.suit.max)
        end, {
            description = "set max layout",
            group = "layout"
        }
    ), awful_key(
        {modkey, shift}, "t", function()
            awful.layout.set(awful.layout.suit.tile)
        end, {
            description = "set tile layout",
            group = "layout"
        }
    ), awful_key(
        {modkey, shift}, "f", function()
            awful.layout.set(awful.layout.suit.floating)
        end, {
            description = "set floating layout",
            group = "layout"
        }
    )
}

-- Client management keybinds
client.connect_signal(
    "request::default_keybindings", function()
        awful_keyboard.append_client_keybindings {
            awful_key(
                {modkey, ctrl}, "Up", function(c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                end, {
                    description = "toggle fullscreen",
                    group = "client"
                }
            ), awful_key(
                {modkey}, "f", awful.client.floating.toggle, {
                    description = "toggle floating",
                    group = "client"
                }
            ), awful_key(
                {modkey, ctrl}, "Down", function(c)
                    -- The client currently has the input focus, so it cannot be
                    -- minimized, since minimized clients can"t have the focus.
                    c.minimized = true
                end, {
                    description = "minimize",
                    group = "client"
                }
            ), awful_key(
                {modkey}, "m", function(c)
                    c.maximized = not c.maximized
                    c:raise()
                end, {
                    description = "toggle maximize",
                    group = "client"
                }
            ), awful_key(
                -- Single tap: Center client. Double tap: Center client + Floating + Resize
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
                                c, focused_screen_geometry.width * 0.45,
                                focused_screen_geometry.height * 0.48
                            )
                        end
                    )
                end, {
                    description = "center client",
                    group = "client"
                }
            ), awful_key(
                {modkey, shift}, "Return", function(c)
                    c:swap(awful.client.getmaster())
                end, {
                    description = "move to master",
                    group = "client"
                }
            ), awful_key(
                {ctrl, shift, modkey}, "[", function(_)
                    local screen = awful.screen.focused()
                    local next_screen = get_next_screen("left")

                    if next_screen == nil or next_screen == screen then
                        naughty.notification {
                            title = "No screen",
                            text = "There's no other screen available!",
                            urgency = "low"
                        }
                        return
                    end

                    local focused_clients = screen.clients
                    local next_clients = next_screen.clients

                    for _, c in ipairs(focused_clients) do
                        c:move_to_screen(next_screen)
                    end

                    for _, c in ipairs(next_clients) do
                        c:move_to_screen(screen)
                    end
                end, {
                    description = "move all clients to previous screen",
                    group = "client"
                }
            ), awful_key(
                {ctrl, shift, modkey}, "]", function(_)
                    local screen = awful.screen.focused()
                    local next_screen = get_next_screen("right")

                    if next_screen == nil or next_screen == screen then
                        naughty.notification {
                            title = "No screen",
                            text = "There's no other screen available!",
                            urgency = "low"
                        }
                        return
                    end

                    local focused_clients = screen.clients
                    local next_clients = next_screen.clients

                    for _, c in ipairs(focused_clients) do
                        c:move_to_screen(next_screen)
                    end

                    for _, c in ipairs(next_clients) do
                        c:move_to_screen(screen)
                    end
                end, {
                    description = "move all clients to next screen",
                    group = "client"
                }
            ), awful_key(
                {modkey, shift}, "]", function(c)
                    local screen = awful.screen.focused()
                    if (screen.get_next_in_direction(screen, "right")) then
                        screen = screen.get_next_in_direction(screen, "right")
                    else
                        while screen.get_next_in_direction(screen, "left") ~= nil do
                            screen = screen.get_next_in_direction(screen, "left")
                        end
                        awful.screen.focus(screen)
                    end
                    c:move_to_screen(screen)
                end, {
                    description = "move client to next screen",
                    group = "client"
                }
            ), awful_key(
                {modkey, shift}, "[", function(c)
                    local screen = awful.screen.focused()
                    if (screen.get_next_in_direction(screen, "left")) then
                        screen = screen.get_next_in_direction(screen, "left")
                    else
                        while screen.get_next_in_direction(screen, "right") ~= nil do
                            screen = screen.get_next_in_direction(screen, "right")
                        end
                        awful.screen.focus(screen)
                    end
                    c:move_to_screen(screen)
                end, {
                    description = "move client to previous screen",
                    group = "client"
                }
            )
        }
    end
)

-- Tags
awful_keyboard.append_global_keybindings {
    awful_key(
        {modkey}, ";", awful.tag.viewprev, {
            description = "view previous tag",
            group = "tag"
        }
    ), awful_key(
        {modkey}, "'", awful.tag.viewnext, {
            description = "view next tag",
            group = "tag"
        }
    ), awful_key(
        {modkey}, "Escape", awful.tag.history.restore, {
            description = "view last tag",
            group = "tag"
        }
    ), awful_key {
        modifiers = {modkey},
        keygroup = "numrow",
        description = "view tag #",
        group = "tag",
        on_press = function(index)
            local tag = awful.screen.focused().tags[index]
            if tag then
                tag:view_only()
            end
        end
    }, awful_key {
        modifiers = {modkey, "Control"},
        keygroup = "numrow",
        description = "toggle tag",
        group = "tag",
        on_press = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end
    }, awful_key {
        modifiers = {modkey, "Shift"},
        keygroup = "numrow",
        description = "move focused client to tag",
        group = "tag",
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end
    }, awful_key {
        modifiers = {modkey, "Control", "Shift"},
        keygroup = "numrow",
        description = "toggle focused client on tag",
        group = "tag",
        on_press = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end
    }
}

-- Mouse bindings on desktop
awful.mouse.append_global_mousebindings(
    {
        -- Left click
        -- awful.button(
        --     {}, 1, function()
        --         naughty.destroy_all_notifications()
        --         if mymainmenu then
        --             mymainmenu:hide()
        --         end
        --     end
        -- ), -- Middle click
        -- awful.button(
        --     {}, 2, function()
        --         dashboard_toggle()
        --     end
        -- ), -- Right click
        -- awful.button(
        --     {}, 3, function()
        --         mymainmenu:toggle()
        --     end
        -- ),
        -- Side key
        awful.button({}, 4, awful.tag.viewprev), awful.button({}, 5, awful.tag.viewnext)
    }
)

-- Mouse buttons on the client
client.connect_signal(
    "request::default_mousebindings", function()
        awful.mouse.append_client_mousebindings(
            {
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
        )
    end
)
