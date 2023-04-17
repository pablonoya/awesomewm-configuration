local awful = require("awful")
local gtable = require("gears.table")
local place = require("wibox.container.place")

local clickable_container = require("ui.widgets.clickable-container")

local layoutbox = function(screen)
    local widget = clickable_container {
        widget = {
            {
                forced_height = dpi(24),
                forced_width = dpi(24),
                widget = awful.widget.layoutbox(screen)
            },
            widget = place
        },
        margins = dpi(5)
    }

    widget:buttons(
        gtable.join(
            awful.button(
                {}, 1, function(c)
                    awful.layout.inc(1)
                end
            ), awful.button(
                {}, 3, function(c)
                    awful.layout.inc(-1)
                end
            ), awful.button(
                {}, 4, function()
                    awful.layout.inc(1)
                end
            ), awful.button(
                {}, 5, function()
                    awful.layout.inc(-1)
                end
            )
        )
    )

    return widget
end

return layoutbox
