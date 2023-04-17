local awful = require("awful")
local gshape = require("gears.shape")
local wibox_container = require("wibox.container")
local wibox_widget = require("wibox.widget")

local text_icon = require("ui.widgets.text-icon")
local clickable_container = require("ui.widgets.clickable-container")

return function()
    local dismiss = wibox_widget {
        clickable_container {
            widget = {
                text_icon {
                    text = "\u{e5cd}"
                },
                margins = dpi(1),
                widget = wibox_container.margin
            },
            shape = gshape.circle
        },
        halign = "right",
        widget = wibox_container.place
    }

    dismiss.visible = false

    return dismiss
end
