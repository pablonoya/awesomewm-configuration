local awful = require("awful")
local beautiful = require("beautiful")
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

        -- Float
        ruled.client.append_rule {
            id = "floating",
            rule_any = {
                class = {
                    "Lxappearance", "Nm-connection-editor", "slack", "Slack", "discord",
                    "ulauncher", "Ulauncher", "blueman-manager", "Blueman-manager", "pavucontrol",
                    "Pavucontrol", "anytype", "Thunar", "teams", "Teams"
                },
                name = {"Event Tester", "zoom", "Picture in picture", "YouTube Music", ""},
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
            id = "no border",
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
                role = {"GtkFileChooserDialog", "conversation"}
            },
            properties = {
                placement = awful.placement.centered
            }
        }
        -- Top right
        ruled.client.append_rule {
            id = "top right",
            rule_any = {
                class = {"blueman-manager", "Blueman-manager", "Nm-connection-editor"}
            },
            properties = {
                placement = function(c)
                    awful.placement.top_right(
                        c, {
                            honor_workarea = true,
                            margins = beautiful.useless_gap
                        }
                    )
                end
            }
        }
    end
)

ruled.notification.connect_signal(
    "request::rules", function()
        ruled.notification.append_rule {
            rule = {
                urgency = "critical"
            },
            properties = {
                timeout = 0
            }
        }

        -- decrease the urgency of blueman notifications
        ruled.notification.append_rule {
            rule = {
                app_name = "blueman"
            },
            properties = {
                urgency = "low"
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
