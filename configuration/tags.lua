local awful_layout = require("awful.layout")
local awful_tag = require("awful.tag")

local bling_layout = require("module.bling.layout")

-- Set the layouts
tag.connect_signal(
    "request::default_layouts", function()
        awful_layout.append_default_layouts {
            awful_layout.suit.tile,
            awful_layout.suit.max,
            awful_layout.suit.magnifier,
            bling_layout.horizontal,
            awful_layout.suit.spiral,
            bling_layout.mstab,
            bling_layout.deck,
            awful_layout.suit.floating
        }
    end
)

-- Screen Padding and Tags
screen.connect_signal(
    "request::desktop_decoration", function(s)
        awful_tag({"1", "2", "3", "4", "5", "6", "7"}, s, awful_layout.layouts[1])

        local is_vertical = s.geometry.height > s.geometry.width
        if is_vertical then
            for _, tag in ipairs(s.tags) do
                tag.layout = awful_layout.suit.tile.bottom

                tag.layouts = {
                    awful_layout.suit.tile.bottom,
                    awful_layout.suit.max,
                    awful_layout.suit.magnifier,
                    bling_layout.horizontal,
                    awful_layout.suit.spiral,
                    bling_layout.deck,
                    awful_layout.suit.floating
                }
            end
        end
    end
)
