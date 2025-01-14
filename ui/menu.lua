local awful = require("awful")
local beautiful = require("beautiful")
local gsurface = require("gears.surface")

local variables = require("configuration.variables")
local color_helpers = require("helpers.color-helpers")
local hotkeys_popup = require("ui.hotkeys_popup")
local text_icon = require("ui.widgets.text-icon")

local function icon_from_text(text, color)
    return gsurface.widget_to_surface(
        text_icon {
            markup = color_helpers.colorize_text(text, beautiful.xforeground .. "E0"),
            size = 14
        }, 32, 32
    )
end

-- Create a main menu.
return {
    main = awful.menu {
        items = {
            {
                "Hotkeys                             Super+F1",
                function()
                    hotkeys_popup.show_help(client.focus, awful.screen.focused())
                end,
                icon_from_text("\u{eae7}")
            },
            {
                "Terminal                   Super+Enter",
                variables.terminal,
                icon_from_text("\u{eb8e}")
            },
            {
                "Edit config",
                variables.editor .. " " .. awesome.conffile,
                icon_from_text("\u{e745}")
            },
            {
                "Restart                   Ctrl+Super+R",
                awesome.restart,
                icon_from_text("\u{f053}")
            },
            {
                "Quit",
                awesome.quit,
                icon_from_text("\u{e9ba}")
            }
        }
    }
}
