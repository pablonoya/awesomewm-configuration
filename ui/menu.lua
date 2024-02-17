local awful = require("awful")
local beautiful = require("beautiful")

local menu = {}
local apps = require("configuration.apps")

local hotkeys_popup = require("ui.hotkeys_popup")
local text_icon = require("ui.widgets.text-icon")
local gsurface = require("gears.surface")

local function icon_from_text(text, size)
    return gsurface.widget_to_surface(
        text_icon {
            markup = text
        }, 34, 34
    )
end

-- Create a main menu.
menu.main = awful.menu {
    items = {
        {
            "Hotkeys               Super+F1", function()
                hotkeys_popup.show_help(client.focus, awful.screen.focused())
            end, icon_from_text("\u{eae7}")
        }, 
        
        {"Terminal       Super+Enter", apps.terminal, icon_from_text("\u{eb8e}")},

        {"Edit config", apps.editor .. " " .. awesome.conffile, icon_from_text("\u{e745}")},

        {"Restart       Ctrl+Super+R", awesome.restart, icon_from_text("\u{f053}")},

        {"Quit", awesome.quit, icon_from_text("\u{e9ba}")}
    }
}

return menu
