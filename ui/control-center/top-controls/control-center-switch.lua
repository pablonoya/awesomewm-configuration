local gshape = require("gears.shape")
local wibox_container_rotate = require("wibox.container.rotate")

local text_icon = require("ui.widgets.text-icon")
local clickable_container = require("ui.widgets.clickable-container")
local border_container = require("ui.widgets.border-container")

local monitor_mode = false

local icon = text_icon {
    text = "\u{f20c}",
    size = 16
}

local control_center_switch_mode = function()
    icon.text = monitor_mode and "\u{f20c}" or "\u{e8b8}"
    monitor_mode = not monitor_mode
    awesome.emit_signal("control_center::monitor_mode", monitor_mode)
end

return clickable_container {
    widget = {
        icon,
        direction = "west",
        widget = wibox_container_rotate
    },
    margins = dpi(4),
    shape = gshape.circle,
    action = control_center_switch_mode
}
