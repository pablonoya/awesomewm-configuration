-- Standard awesome library
local autofocus = require("awful.autofocus")
local awful_placement = require("awful.placement")
local awful_screen = require("awful.screen")

local task_preview = require("module.bling.widget.task_preview")
local tag_preview = require("module.bling.widget.tag_preview")
local window_switcher = require("module.bling.widget.window_switcher")

local better_resize = require("module.better-resize")

window_switcher.enable {
    type = "thumbnail"
}

tag_preview.enable {
    show_client_content = true,
    placement_fn = function(window)
        local focused_screen = awful_screen.focused()
        awful_placement.top(
            window, {
                margins = {
                    top = focused_screen.bar.height + dpi(2)
                },
                parent = focused_screen
            }
        )
    end,
    scale = 0.2
}

task_preview.enable {
    height = 200,
    width = 300,
    placement_fn = function(c)
        local focused_screen = awful_screen.focused()
        awful_placement.top(
            c, {
                margins = {
                    top = focused_screen.bar.height + dpi(2)
                },
                parent = focused_screen
            }
        )
    end
}
