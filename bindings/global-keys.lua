local awful = require("awful")
local naughty = require("naughty")

local revelation = require("away.third_party.revelation")

local helpers = require("helpers")
local system_controls = require("helpers.system-controls")

local playerctl = require("signals.playerctl")
local ytm_scratchpad = require("ui.scratchpad")
local hotkeys_popup = require("ui.hotkeys_popup")

local modkeys = require("bindings.modkeys")
local modkey, alt, ctrl, shift = table.unpack(modkeys)

local function move_all_clients_to_screen(clients, screen)
    for _, c in ipairs(clients) do
        c:move_to_screen(screen)
    end
end

local function swap_all_clients_between_screens(new_direction)
    local next_screen = helpers.get_next_screen(new_direction)
    local screen = awful.screen.focused()

    if next_screen == nil or next_screen == screen then
        notification {
            title = "No screen",
            text = "There's no other screen available!",
            urgency = "low"
        }
        return
    end

    -- Save the clients in a variable to avoid modifying the table while iterating
    local screen_clients = screen.clients
    local next_screen_clients = next_screen.clients

    move_all_clients_to_screen(screen_clients, next_screen)
    move_all_clients_to_screen(next_screen_clients, screen)
end

-- Awesome stuff
awful.keyboard.append_global_keybindings {
    awful.key(
        {modkey}, "F1", hotkeys_popup.show_help, {
            description = "show help",
            group = "awesome"
        }
    ), awful.key(
        {modkey, ctrl}, "r", awesome.restart, {
            description = "reload awesome",
            group = "awesome"
        }
    ), awful.key(
        {modkey, ctrl}, "q", awesome.quit, {
            description = "quit awesome",
            group = "awesome"
        }
    ), awful.key(
        {modkey}, "l", function()
            lock_screen_show()
        end, {
            description = "lock screen",
            group = "awesome"
        }
    ), awful.key(
        {}, "XF86PowerOff", function()
            awesome.emit_signal("exit_screen::show")
        end, {
            description = "show exit screen",
            group = "awesome"
        }
    ), awful.key(
        {modkey}, "n", function()
            awesome.emit_signal("notification_center::toggle")
        end, {
            description = "toggle notifcation center",
            group = "awesome"
        }
    ), awful.key(
        {modkey}, "x", function()
            if not naughty.suspended then
                naughty.destroy_all_notifications()
            end
            naughty.suspended = not naughty.suspended
            naughty.emit_signal("property::suspended", naughty, naughty.suspended)
        end, {
            description = "toggle don't disturb",
            group = "awesome"
        }
    ), awful.key(
        {modkey}, "a", function()
            awesome.emit_signal("control_center::toggle")
        end, {
            description = "toggle control center",
            group = "awesome"
        }
    ), awful.key(
        {modkey}, "Tab", revelation, {
            description = "use revelation",
            group = "awesome"
        }
    ), awful.key(
        {alt}, "Tab", function()
            awesome.emit_signal("bling::window_switcher::turn_on")
        end, {
            description = "window switcher",
            group = "awesome"
        }
    )
}

-- Client Bindings
awful.keyboard.append_global_keybindings {
    awful.key {
        modifiers = {modkey},
        keygroup = "arrows",
        description = "focus client by direction",
        group = "client",
        on_press = function(key)
            awful.client.focus.bydirection(key:lower())
        end
    }, awful.key(
        {modkey, alt}, "h", function()
            awful.client.focus.bydirection("left")
        end, {
            description = "focus left client",
            group = "client"
        }
    ), awful.key(
        {modkey, alt}, "j", function()
            awful.client.focus.bydirection("down")
        end, {
            description = "focus down client",
            group = "client"
        }
    ), awful.key(
        {modkey, alt}, "k", function()
            awful.client.focus.bydirection("up")
        end, {
            description = "focus up client",
            group = "client"
        }
    ), awful.key(
        {modkey, alt}, "l", function()
            awful.client.focus.bydirection("right")
        end, {
            description = "focus right client",
            group = "client"
        }
    ), awful.key(
        {modkey, shift}, "j", function()
            awful.client.swap.byidx(1)
        end, {
            description = "swap with next client",
            group = "client"
        }
    ), awful.key(
        {modkey, shift}, "k", function()
            awful.client.swap.byidx(-1)
        end, {
            description = "swap with previous client",
            group = "client"
        }
    ), awful.key(
        {modkey}, "u", awful.client.urgent.jumpto, {
            description = "jump to urgent client",
            group = "client"
        }
    ), awful.key(
        {ctrl, shift, modkey}, "[", function()
            swap_all_clients_between_screens("left")
        end, {
            description = "move all clients to previous screen",
            group = "client"
        }
    ), awful.key(
        {ctrl, shift, modkey}, "]", function()
            swap_all_clients_between_screens("right")
        end, {
            description = "move all clients to next screen",
            group = "client"
        }
    )
}

-- Launcher
awful.keyboard.append_global_keybindings {
    awful.key(
        {modkey}, "Return", function()
            awful.spawn("wezterm-gui")
        end, {
            description = "open terminal",
            group = "launcher"
        }
    ), awful.key(
        {modkey}, "s", function()
            ytm_scratchpad:reapply_geometry()
            ytm_scratchpad:toggle()
        end, {
            description = "toggle scratchpad",
            group = "launcher"
        }
    ), awful.key(
        {modkey}, "e", function()
            awful.spawn("thunar")
        end, {
            description = "open file manager",
            group = "launcher"
        }
    ), awful.key(
        {modkey}, "p", function()
            awful.spawn.easy_async_with_shell(
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
    ), awful.key(
        {modkey}, "v", function()
            awful.spawn("diodon")
        end, {
            description = "open diodon",
            group = "launcher"
        }
    ), -- Screenshots
    awful.key(
        {}, "Print", function()
            awful.spawn("flameshot gui")
        end, {
            description = "take an area screenshot",
            group = "screenshots"
        }
    ), awful.key(
        {modkey, shift}, "s", function()
            awful.spawn("flameshot gui")
        end, {
            description = "take an area screenshot",
            group = "screenshots"
        }
    ), awful.key(
        {alt}, "Print", function()
            awful.spawn("flameshot full")
        end, {
            description = "take a full screenshot",
            group = "screenshots"
        }
    )
}

-- Hotkeys
awful.keyboard.append_global_keybindings {
    -- Brightness Control
    awful.key(
        {}, "XF86MonBrightnessUp", function()
            system_controls.brightness_control("increase")
        end, {
            description = "increase brightness",
            group = "hotkeys"
        }
    ), awful.key(
        {}, "XF86MonBrightnessDown", function()
            system_controls.brightness_control("decrease")
        end, {
            description = "decrease brightness",
            group = "hotkeys"
        }
    ), -- Volume control
    awful.key(
        {}, "XF86AudioRaiseVolume", function()
            system_controls.volume_control("increase", 5)
        end, {
            description = "increase volume",
            group = "hotkeys"
        }
    ), awful.key(
        {}, "XF86AudioLowerVolume", function()
            system_controls.volume_control("decrease", 5)
        end, {
            description = "decrease volume",
            group = "hotkeys"
        }
    ), awful.key(
        {}, "XF86AudioMute", function()
            system_controls.volume_control("mute")
        end, {
            description = "mute volume",
            group = "hotkeys"
        }
    ), awful.key(
        {}, "XF86AudioMicMute", function()
            system_controls.mic_toggle()
        end, {
            description = "mute microphone",
            group = "hotkeys"
        }
    ), -- Music
    awful.key(
        {}, "XF86AudioPlay", function()
            playerctl:play_pause()
        end, {
            description = "toggle music",
            group = "hotkeys"
        }
    ), awful.key(
        {}, "Insert", function()
            playerctl:play_pause()
        end, {
            description = "toggle music",
            group = "hotkeys"
        }
    ), awful.key(
        {}, "XF86AudioPrev", function()
            playerctl:previous()
        end, {
            description = "previous music",
            group = "hotkeys"
        }
    ), awful.key(
        {}, "XF86AudioNext", function()
            playerctl:next()
        end, {
            description = "next music",
            group = "hotkeys"
        }
    )
}

-- Asusctl
awful.keyboard.append_global_keybindings {
    awful.key(
        {}, "XF86KbdBrightnessUp", function()
            awful.spawn("asusctl -n")
            system_controls.keyboard_brightness()
        end, {
            description = "increase keyboard brightness",
            group = "hotkeys (asusctl)"
        }
    ), awful.key(
        {}, "XF86KbdBrightnessDown", function()
            awful.spawn("asusctl -p")
            system_controls.keyboard_brightness()
        end, {
            description = "decrease keyboard brightness",
            group = "hotkeys (asusctl)"
        }
    ), awful.key(
        {}, "XF86Launch4", function()
            awful.spawn("asusctl profile -n")
        end, {
            description = "asusctl next fan profile",
            group = "hotkeys (asusctl)"
        }
    )
}

-- Screen
awful.keyboard.append_global_keybindings {
    awful.key(
        {modkey}, "]", function()
            awful.screen.focus(helpers.get_next_screen("right"))
        end, {
            description = "focus the next screen",
            group = "screen"
        }
    ), awful.key(
        {modkey}, "[", function()
            awful.screen.focus(helpers.get_next_screen("left"))
        end, {
            description = "focus the previous screen",
            group = "screen"
        }
    )
}

-- Layout
awful.keyboard.append_global_keybindings {
    awful.key(
        {modkey, ctrl}, "k", function()
            awful.tag.incmwfact(0.05)
        end, {
            description = "increase master width factor",
            group = "layout"
        }
    ), awful.key(
        {modkey, ctrl}, "j", function()
            awful.tag.incmwfact(-0.05)
        end, {
            description = "decrease master width factor",
            group = "layout"
        }
    ), awful.key(
        {modkey}, "space", nil, {
            description = "select next layout",
            group = "layout"
        }
    ), awful.key(
        {modkey, shift}, "space", nil, {
            description = "select previous layout",
            group = "layout"
        }
    ), -- Specific layouts
    awful.key(
        {modkey, ctrl}, "m", function()
            awful.layout.set(awful.layout.suit.max)
        end, {
            description = "set max layout",
            group = "layout"
        }
    ), awful.key(
        {modkey, ctrl}, "t", function()
            awful.layout.set(awful.layout.suit.tile)
        end, {
            description = "set tile layout",
            group = "layout"
        }
    ), awful.key(
        {modkey, ctrl}, "f", function()
            awful.layout.set(awful.layout.suit.floating)
        end, {
            description = "set floating layout",
            group = "layout"
        }
    )
}

-- Tags
awful.keyboard.append_global_keybindings {
    awful.key(
        {modkey}, ";", awful.tag.viewprev, {
            description = "view previous tag",
            group = "tag"
        }
    ), awful.key(
        {modkey}, "'", awful.tag.viewnext, {
            description = "view next tag",
            group = "tag"
        }
    ), awful.key(
        {modkey}, "Escape", awful.tag.history.restore, {
            description = "view last tag",
            group = "tag"
        }
    ), awful.key {
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
    }, awful.key {
        modifiers = {modkey, ctrl},
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
    }, awful.key {
        modifiers = {modkey, shift},
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
    }, awful.key {
        modifiers = {modkey, ctrl, shift},
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
awful.mouse.append_global_mousebindings {
    -- Scroll wheel
    awful.button({modkey}, 4, awful.tag.viewprev), awful.button({modkey}, 5, awful.tag.viewnext)
}
