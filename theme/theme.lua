local naughty = require("naughty")
local gfs = require("gears.filesystem")
local xrdb = require("beautiful.xresources").get_current_theme()

local helpers = require("helpers")

local HOME = os.getenv("HOME")
local icons_dir = gfs.get_configuration_dir() .. "ui/icons/"

local theme = {}

-- Load ~/.Xresources colors
theme.xbackground = xrdb.background
theme.xforeground = xrdb.foreground

theme.black = xrdb.color0
theme.red = xrdb.color1
theme.green = xrdb.color2
theme.yellow = xrdb.color3
theme.blue = xrdb.color4
theme.magenta = xrdb.color5
theme.cyan = xrdb.color6
theme.white = xrdb.color7

theme.light_black = xrdb.color8
theme.light_red = xrdb.color9
theme.light_green = xrdb.color10
theme.light_yellow = xrdb.color11
theme.light_blue = xrdb.color12
theme.light_magenta = xrdb.color13
theme.light_cyan = xrdb.color14
theme.light_white = xrdb.color15

-- Extra colors and aliases
theme.transparent = "#00000000"

theme.moon = "#f5eb94"
theme.uranus = "#f5d1a3"
theme.pluto = "#fabdd4"
theme.chibimoon = "#efa3ce"

theme.mars = theme.red
theme.jupiter = theme.green
theme.venus = theme.yellow
theme.mercury = theme.blue
theme.saturn = theme.magenta
theme.neptune = theme.cyan

-- Background Colors
theme.bg_dark = theme.black
theme.bg_normal = theme.xbackground
theme.bg_focus = theme.xbackground
theme.bg_urgent = theme.yellow
theme.bg_minimize = theme.magenta
theme.bg_secondary = theme.cyan
theme.bg_accent = theme.focus

-- Foreground Colors
theme.fg_normal = theme.xforeground
theme.fg_focus = theme.accent

-- Accent colors
theme.accent = theme.blue
theme.focus = "#424f5b"

-- Time of the day colors
theme.late_night_color = theme.magenta
theme.dawn_color = theme.pluto
theme.morning_color = theme.yellow
theme.midday_color = theme.moon
theme.dusk_color = theme.chibimoon
theme.night_color = theme.blue

-- Gaps
theme.useless_gap = dpi(4)

-- Fonts
theme.font_name = "Manrope "
theme.font = theme.font_name .. "10"
theme.icon_font_name = "Material Symbols Rounded "
theme.mono_font = "JetBrains Mono Slashed 10"

-- Borders
theme.border_width = dpi(2)
theme.border_normal = theme.focus
theme.border_focus = theme.accent
theme.border_active = theme.yellow
theme.border_activate = theme.accent
theme.border_marked = theme.uranus
theme.widget_border_width = dpi(2)

-- Client borders
theme.border_color_active = theme.accent
theme.border_color_urgent = theme.uranus
theme.border_color_floating_urgent = theme.uranus

-- Border radius
theme.border_radius = dpi(16)
theme.client_border_radius = dpi(12)
theme.widget_radius = theme.border_radius

-- Titlebars
theme.titlebar_enabled = false

-- Tooltip
theme.tooltip_bg = theme.black
theme.tooltip_fg = theme.xforeground
theme.tooltip_border_color = theme.focus
theme.tooltip_border_width = dpi(1)
theme.tooltip_font = theme.font_name .. 12

-- Tasklist
theme.tasklist_bg_normal = theme.transparent
theme.tasklist_bg_focus = theme.accent
theme.tasklist_bg_minimize = theme.magenta

theme.tasklist_floating = "☁"
theme.tasklist_ontop = "⬆"
theme.tasklist_sticky = "📌"
theme.tasklist_maximized = "⬜"

-- Taglist
theme.taglist_spacing = dpi(2)
theme.taglist_shape = helpers.rrect(theme.widget_radius)

theme.taglist_squares_sel = nil
theme.taglist_squares_unsel = nil

theme.taglist_bg_focus = theme.focus
theme.taglist_fg_focus = theme.xforeground

theme.taglist_bg_urgent = theme.uranus .. "B7"
theme.taglist_fg_urgent = theme.wibar_bg

theme.taglist_bg_occupied = theme.wibar_bg
theme.taglist_fg_occupied = theme.xforeground .. "F0"

theme.taglist_bg_empty = theme.black
theme.taglist_fg_empty = theme.xbackground

theme.taglist_bg_volatile = theme.jupiter

-- Mainmenu
theme.menu_font = theme.font_name .. "Medium 10"
theme.menu_height = dpi(36)
theme.menu_width = dpi(216)
theme.menu_bg_normal = theme.xbackground
theme.menu_bg_focus = theme.focus
theme.menu_fg_normal = theme.xforeground
theme.menu_border_width = dpi(1.6)
theme.menu_border_color = theme.focus

-- Hotkeys Pop Up
theme.hotkeys_bg = theme.black .. "F0"
theme.hotkeys_fg = theme.xforeground
theme.hotkeys_border_color = theme.focus
theme.hotkeys_modifiers_fg = theme.xforeground .. "E0"
theme.hotkeys_font = theme.mono_font
theme.hotkeys_description_font = theme.font_name .. "10"
theme.hotkeys_group_margin = dpi(12)

-----------------
-- UI Elements --
-----------------
-- Wibar
theme.wibar_size = dpi(40)
theme.wibar_bg = theme.xbackground
theme.wibar_widget_bg = theme.black
theme.wibar_position = "bottom"
theme.wibar_border_color = theme.focus
theme.wibar_border_width = theme.border_width
theme.wibar_margins = {
    top = dpi(4),
    left = dpi(8),
    right = dpi(8),
    bottom = dpi(-4)
}
theme.wibar_shape = helpers.rrect(theme.client_border_radius)

-- Pop up notifications
theme.popup_size = dpi(240)
theme.popup_bg = theme.black
theme.popup_volume_color = theme.accent
theme.popup_brightness_color = theme.moon
theme.popup_mic_color = theme.green
theme.popup_border_radius = theme.border_radius

-- Layout list popup
theme.layoutlist_border_color = theme.focus
theme.layoutlist_border_width = theme.border_width
theme.layoutlist_bg_selected = theme.xbackground
theme.layoutlist_shape_border_width_selected = theme.border_width
theme.layoutlist_shape_border_color_selected = theme.focus
theme.layoutlist_shape_selected = helpers.rrect(theme.border_radius / 2)

-- Layout icons
theme.layout_tile = icons_dir .. "layouts/tile.svg"
theme.layout_tilebottom = icons_dir .. "layouts/tilebottom.svg"
theme.layout_magnifier = icons_dir .. "layouts/magnifier.svg"
theme.layout_max = icons_dir .. "layouts/max.svg"
theme.layout_horizontal = icons_dir .. "layouts/horizontal.svg"
theme.layout_spiral = icons_dir .. "layouts/spiral.svg"
theme.layout_mstab = icons_dir .. "layouts/mstab.svg"
theme.layout_deck = icons_dir .. "layouts/deck.svg"
theme.layout_floating = icons_dir .. "layouts/floating.svg"

-- Edge snap
theme.snap_bg = theme.cyan
theme.snap_shape = helpers.rrect(theme.client_border_radius)

-- Control center
theme.control_center_width = dpi(360)
theme.control_center_button_bg = theme.focus

-- Notifications
naughty.config.defaults.ontop = true
naughty.config.defaults.title = "Generic Notification"

naughty.config.icon_dirs = {
    HOME .. "/.local/share/icons/Kuyen-icons/apps/48/", HOME .. "/.local/share/icons/Kuyen-icons/",
    "/usr/share/icons/Papirus-Dark/", "/usr/share/icons/Suru++-Asprómauros/",
    "/usr/share/icons/breeze-dark/", "/usr/share/pixmaps/"
}
naughty.config.icon_formats = {"png", "svg", "jpg", "jpeg", "gif", "webp", ""}

theme.notification_spacing = 12
theme.notification_border_radius = theme.border_radius / 2
theme.notification_font = theme.font_name .. 12
theme.notification_position = "top_right"

-- Notif center
theme.notif_center_radius = theme.border_radius
theme.notif_center_width = dpi(320)

-- Notification icons
theme.notification_icon = icons_dir .. "notification.svg"

-- Systray
theme.systray_icon_spacing = dpi(4)
theme.systray_max_rows = 1
theme.bg_systray = theme.wibar_bg

-------------
--- Bling ---
-------------
-- Playerctl
theme.playerctl_ignore = {"qutebrowser", "chromium", "brave"}
theme.playerctl_player = {"youtube-music", "spotify", "mpd", "%any"}
theme.playerctl_update_on_activity = true
theme.playerctl_position_update_interval = 1

-- Tabs
theme.mstab_bar_height = dpi(42)
theme.mstab_bar_padding = dpi(2)
theme.mstab_border_radius = theme.border_radius / 2
theme.tabbar_style = "modern"
theme.tabbar_bg_focus = theme.focus
theme.tabbar_fg_focus = theme.xforeground
theme.tabbar_bg_normal = theme.black
theme.tabbar_fg_normal = theme.xforeground
theme.tabbar_position = "top"
theme.tabbar_AA_radius = dpi(2)
theme.tabbar_size = 40
theme.mstab_bar_ontop = true

-- Tag Preview
theme.tag_preview_client_border_radius = dpi(5)
theme.tag_preview_client_opacity = 1
theme.tag_preview_client_bg = theme.xbackground
theme.tag_preview_client_border_color = theme.focus
theme.tag_preview_client_border_width = dpi(1.2)
theme.tag_preview_widget_border_radius = theme.border_radius
theme.tag_preview_widget_bg = theme.black
theme.tag_preview_widget_border_color = theme.focus
theme.tag_preview_widget_border_width = theme.border_width
theme.tag_preview_widget_margin = dpi(12)

-- Task Preview
theme.task_preview_widget_border_radius = dpi(5)
theme.task_preview_widget_bg = theme.black
theme.task_preview_widget_border_color = theme.focus
theme.task_preview_widget_border_width = theme.border_width
theme.task_preview_widget_margin = dpi(8)

-- Window switcher
theme.window_switcher_widget_bg = theme.black .. "E9"
theme.window_switcher_widget_border_width = theme.border_width
theme.window_switcher_widget_border_radius = theme.border_radius
theme.window_switcher_widget_border_color = theme.focus
theme.window_switcher_client_width = dpi(256)
theme.window_switcher_name_font = theme.font_name .. "Medium 11"
theme.window_switcher_name_normal_color = theme.xforeground .. "97"
theme.window_switcher_name_focus_color = theme.accent
theme.window_switcher_icon_width = dpi(28)

return theme
