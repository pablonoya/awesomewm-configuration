local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local ruled = require("ruled")

local helpers = require("helpers")

-- Get screen geometry
local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

ruled.client.connect_signal(
    "request::rules", function()
        -- Global
        ruled.client.append_rule {
            id = "global",
            rule = {},
            properties = {
                focus = awful.client.focus.filter,
                raise = true,
                size_hints_honor = false,
                screen = awful.screen.preferred,
                titlebars_enabled = beautiful.titlebar_enabled,
                border_width = dpi(2),
                placement = awful.placement.no_overlap + awful.placement.no_offscreen,
                shape = helpers.rrect(beautiful.client_border_radius)

            }
        }

        -- Tasklist order
        ruled.client.append_rule {
            id = "tasklist_order",
            rule = {},
            properties = {},
            callback = awful.client.setslave
        }

        -- Titlebar rules
        ruled.client.append_rule {
            id = "titlebars",
            rule_any = {
                class = {"discord", "Spotify", "Org.gnome.Nautilus"},
                type = {"splash"},
                name = {
                    "^discord.com is sharing your screen.$" -- Discord (running in browser) screen sharing popup
                }
            },
            properties = {
                titlebars_enabled = false
            }
        }

        -- Float
        ruled.client.append_rule {
            id = "floating",
            rule_any = {
                class = {
                    "Lxappearance", "Nm-connection-editor", "slack", "Slack", "discord", "ulauncher", "Ulauncher",
                    "telegram-desktop", "TelegramDesktop", "blueman-manager", "Blueman-manager", "pavucontrol",
                    "Pavucontrol"
                },
                name = {
                    -- xev
                    "Event Tester", "zoom", ""
                },
                role = {"AlarmWindow", "pop-up", "GtkFileChooserDialog"},
                type = {"dialog"}
            },
            properties = {
                floating = true,
                placement = awful.placement.centered
            }
        }

        -- No border
        ruled.client.append_rule {
            id = "border",
            rule_any = {
                class = {"ulauncher", "Ulauncher"}
            },
            properties = {
                border_width = 0
            }
        }

        -- Centered
        ruled.client.append_rule {
            id = "centered",
            rule_any = {
                type = {"dialog"},
                class = {
                    -- "discord",
                },
                role = {"GtkFileChooserDialog", "conversation"}
            },
            properties = {
                placement = awful.placement.centered
            }
        }

        -- Below
        ruled.client.append_rule {
            rule = {
                class = 'xwinwrap'
            },
            properties = {
                below = true
            }
        }

    end
)

ruled.notification.connect_signal(
    "request::rules", function()
        -- Add a red border for urgent notifications.
        ruled.notification.append_rule {
            rule = {
                urgency = "critical"
            },
            properties = {
                timeout = 0
            }
        }

        ruled.notification.append_rule {
            rule = {},
            properties = {
                implicit_timeout = 6
            }
        }
    end
)
