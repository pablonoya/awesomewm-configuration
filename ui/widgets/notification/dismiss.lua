local beautiful = require("beautiful")
local gshape = require("gears.shape")
local wibox = require("wibox")

local text_icon = require("ui.widgets.text-icon")

return function()
    local dismiss = wibox.widget {
        text_icon {
            text = "\u{e5cd}",
            size = 16
        },
        shape = gshape.circle,
        bg = beautiful.black,
        fg = beautiful.red,

        widget = wibox.container.background
    }

    dismiss:connect_signal(
        "mouse::enter", function()
            dismiss.bg = beautiful.red
            dismiss.fg = beautiful.black
        end
    )

    dismiss:connect_signal(
        "mouse::leave", function()
            dismiss.bg = beautiful.black
            dismiss.fg = beautiful.red
        end
    )

    return wibox.widget {
        dismiss,
        visible = false,
        margins = dpi(3),
        widget = wibox.container.margin
    }
end
