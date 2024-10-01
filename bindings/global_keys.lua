local awful = require("awful")
local naughty = require("naughty")

local revelation = require("away.third_party.revelation")

local helpers = require("helpers")
local system_controls = require("helpers.system_controls")

local variables = require("configuration.variables")
local asusctl_signals = require("signals.asusctl_signals")
local playerctl = require("signals.playerctl")

local hotkeys_popup = require("ui.hotkeys_popup")
local menu = require("ui.menu")
local ytm_scratchpad = require("ui.scratchpad")

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
        naughty.notification {
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
            description = "Show keybindings",
            group = "awesome"
        }
    ), awful.key(
        {modkey, ctrl}, "r", awesome.restart, {
            description = "Reload awesome",
            group = "awesome"
        }
    ), awful.key(
        {modkey, ctrl}, "q", awesome.quit, {
            description = "Quit awesome",
            group = "awesome"
        }
    ), awful.key(
        {modkey}, "l", function()
            awesome.emit_signal("lockscreen::visible", true)
        end, {
            description = "Lock screen",
            group = "awesome"
        }
    ), awful.key(
        {}, "XF86PowerOff", function()
            awesome.emit_signal("exit_screen::show")
        end, {
            description = "Show exit screen",
            group = "awesome"
        }
    ), awful.key(
        {modkey}, "n", function()
            awesome.emit_signal("notification_center::toggle")
        end, {
            description = "Toggle notifcation center",
            group = "awesome"
        }
    ), awful.key(
        {modkey}, "x", helpers.toggle_silent_mode, {
            description = "Toggle silent mode",
            group = "awesome"
        }
    ), awful.key(
        {modkey}, "a", function()
            awesome.emit_signal("control_center::toggle")
        end, {
            description = "Toggle control center",
            group = "awesome"
        }
    ), awful.key(
        {modkey}, "Tab", revelation, {
            description = "Use Revelation",
            group = "awesome"
        }
    ), awful.key(
        {alt}, "Tab", function()
            awesome.emit_signal("bling::window_switcher::turn_on")
        end, {
            description = "Window switcher",
            group = "awesome"
        }
    )
}

-- Client Bindings
awful.keyboard.append_global_keybindings {
    awful.key {
        modifiers = {modkey},
        keygroup = "arrows",
        description = "Focus client by direction",
        group = "client::focus",
        on_press = function(key)
            awful.client.focus.bydirection(key:lower())
        end
    }, awful.key(
        {modkey, alt}, "h", function()
            awful.client.focus.bydirection("left")
        end, {
            description = "Focus left client",
            group = "client::focus"
        }
    ), awful.key(
        {modkey, alt}, "j", function()
            awful.client.focus.bydirection("down")
        end, {
            description = "Focus down client",
            group = "client::focus"
        }
    ), awful.key(
        {modkey, alt}, "k", function()
            awful.client.focus.bydirection("up")
        end, {
            description = "Focus up client",
            group = "client::focus"
        }
    ), awful.key(
        {modkey, alt}, "l", function()
            awful.client.focus.bydirection("right")
        end, {
            description = "Focus right client",
            group = "client::focus"
        }
    ), awful.key(
        {modkey}, "u", awful.client.urgent.jumpto, {
            description = "Jump to urgent client",
            group = "client::focus"
        }
    ), awful.key(
        {modkey, shift}, "j", function()
            awful.client.swap.byidx(1)
        end, {
            description = "Swap with next client",
            group = "client"
        }
    ), awful.key(
        {modkey, shift}, "k", function()
            awful.client.swap.byidx(-1)
        end, {
            description = "Swap with previous client",
            group = "client"
        }
    )
}

-- Launcher
awful.keyboard.append_global_keybindings {
    awful.key(
        {modkey}, "Return", function()
            awful.spawn(variables.terminal)
        end, {
            description = "Open terminal",
            group = "launcher"
        }
    ), awful.key(
        {modkey}, "s", function()
            ytm_scratchpad:reapply_geometry()
            ytm_scratchpad:toggle()
        end, {
            description = "Toggle Scratchpad",
            group = "launcher"
        }
    ), awful.key(
        {modkey}, "e", function()
            awful.spawn(variables.file_manager)
        end, {
            description = "Open file manager",
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
            description = "Cycle autorandr",
            group = "launcher"
        }
    ), awful.key(
        {modkey}, "v", function()
            awful.spawn("diodon")
        end, {
            description = "Open diodon",
            group = "launcher"
        }
    ), -- Screenshots
    awful.key(
        {}, "Print", function()
            awful.spawn("flameshot gui")
        end, {
            description = "Take an area screenshot",
            group = "screenshots"
        }
    ), awful.key(
        {modkey, shift}, "s", function()
            awful.spawn("flameshot gui")
        end, {
            description = "Take an area screenshot",
            group = "screenshots"
        }
    ), awful.key(
        {alt}, "Print", function()
            awful.spawn("flameshot full")
        end, {
            description = "Take a full screenshot",
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
            description = "Increase brightness",
            group = "special keys"
        }
    ), awful.key(
        {}, "XF86MonBrightnessDown", function()
            system_controls.brightness_control("decrease")
        end, {
            description = "Decrease brightness",
            group = "special keys"
        }
    ), -- Volume control
    awful.key(
        {}, "XF86AudioRaiseVolume", function()
            system_controls.volume_control("increase", 5)
        end, {
            description = "Increase volume",
            group = "special keys"
        }
    ), awful.key(
        {}, "XF86AudioLowerVolume", function()
            system_controls.volume_control("decrease", 5)
        end, {
            description = "Decrease volume",
            group = "special keys"
        }
    ), awful.key(
        {}, "XF86AudioMute", function()
            system_controls.volume_control("mute")
        end, {
            description = "Mute volume",
            group = "special keys"
        }
    ), awful.key(
        {}, "XF86AudioMicMute", function()
            system_controls.mic_toggle()
        end, {
            description = "Mute microphone",
            group = "special keys"
        }
    ), -- Media
    awful.key(
        {}, "XF86AudioPlay", function()
            playerctl:play_pause()
        end, {
            description = "Play/pause media",
            group = "special keys"
        }
    ), awful.key(
        {}, "Insert", function()
            playerctl:play_pause()
        end, {
            description = "Play/pause media",
            group = "special keys"
        }
    ), awful.key(
        {}, "XF86AudioPrev", function()
            playerctl:previous()
        end, {
            description = "Previous media",
            group = "special keys"
        }
    ), awful.key(
        {}, "XF86AudioNext", function()
            playerctl:next()
        end, {
            description = "Next media",
            group = "special keys"
        }
    ), -- Asusctl
    awful.key(
        {}, "XF86KbdBrightnessUp", function()
            awful.spawn.easy_async("asusctl -n", asusctl_signals.keyboard_brightness)

        end, {
            description = "Increase keyboard brightness",
            group = "special keys"
        }
    ), awful.key(
        {}, "XF86KbdBrightnessDown", function()
            awful.spawn.easy_async("asusctl -p", asusctl_signals.keyboard_brightness)

        end, {
            description = "Decrease keyboard brightness",
            group = "special keys"
        }
    ), awful.key(
        {}, "XF86Launch4", system_controls.next_asusctl_profile, {
            description = "Next asusctl profile",
            group = "special keys"
        }
    )
}

-- Screen
awful.keyboard.append_global_keybindings {
    awful.key(
        {modkey}, "]", function()
            awful.screen.focus(helpers.get_next_screen("right"))
        end, {
            description = "Focus the next screen",
            group = "screen"
        }
    ), awful.key(
        {modkey}, "[", function()
            awful.screen.focus(helpers.get_next_screen("left"))
        end, {
            description = "Focus the previous screen",
            group = "screen"
        }
    ), awful.key(
        {ctrl, shift, modkey}, "[", function()
            swap_all_clients_between_screens("left")
        end, {
            description = "Swap all clients with previous screen",
            group = "screen"
        }
    ), awful.key(
        {ctrl, shift, modkey}, "]", function()
            swap_all_clients_between_screens("right")
        end, {
            description = "Swap all clients with next screen",
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
            description = "Increase master width factor",
            group = "layout"
        }
    ), awful.key(
        {modkey, ctrl}, "j", function()
            awful.tag.incmwfact(-0.05)
        end, {
            description = "Decrease master width factor",
            group = "layout"
        }
    ), awful.key(
        {modkey}, "space", nil, {
            description = "Select next layout",
            group = "layout"
        }
    ), awful.key(
        {modkey, shift}, "space", nil, {
            description = "Select previous layout",
            group = "layout"
        }
    ), -- Specific layouts
    awful.key(
        {modkey, ctrl}, "m", function()
            awful.layout.set(awful.layout.suit.max)
        end, {
            description = "Set Max layout",
            group = "layout"
        }
    ), awful.key(
        {modkey, ctrl}, "t", function()
            awful.layout.set(awful.layout.suit.spiral)
        end, {
            description = "Set Spiral layout",
            group = "layout"
        }
    ), awful.key(
        {modkey, ctrl}, "f", function()
            awful.layout.set(awful.layout.suit.floating)
        end, {
            description = "Set Floating layout",
            group = "layout"
        }
    )
}

-- Tags
awful.keyboard.append_global_keybindings {
    awful.key(
        {modkey}, ";", awful.tag.viewprev, {
            description = "View previous tag",
            group = "tag"
        }
    ), awful.key(
        {modkey}, "'", awful.tag.viewnext, {
            description = "View next tag",
            group = "tag"
        }
    ), awful.key(
        {modkey}, "Escape", awful.tag.history.restore, {
            description = "View last tag",
            group = "tag"
        }
    ), awful.key {
        modifiers = {modkey},
        keygroup = "numrow",
        description = "View tag",
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
        description = "Toggle tag",
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
        description = "Move client to tag",
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
        description = "Toggle client on tag",
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
    awful.button(
        {}, 1, function()
            menu.main:hide()
        end
    ), -- Right click
    awful.button(
        {}, 3, function()
            menu.main:toggle()
        end
    ), -- Scroll wheel
    awful.button({modkey}, 4, awful.tag.viewprev), awful.button({modkey}, 5, awful.tag.viewnext)
}
