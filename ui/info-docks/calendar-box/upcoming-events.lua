local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local gshape = require("gears.shape")
local wibox = require("wibox")

local json = require("away.third_party.dkjson")

local helpers = require("helpers")
local text_icon = require("ui.widgets.text-icon")
local clickable_container = require("ui.widgets.clickable-container")

local calendar_event = require("ui.info-docks.calendar-box.calendar-event")

local placeholder = wibox.widget {
    {
        id = "message",
        text = "Loading events...",
        font = beautiful.font_name .. "12",
        widget = wibox.widget.textbox
    },
    top = dpi(4),
    left = dpi(8),
    right = dpi(8),
    bottom = dpi(8),
    widget = wibox.container.margin
}

local icon = clickable_container {
    widget = text_icon {
        markup = "\u{e5d5}",
        size = 16
    },
    shape = gshape.circle,
    margins = dpi(1)
}

local header = wibox.widget {
    icon,
    {
        text = "Upcoming events",
        font = beautiful.font_name .. "Bold 12",
        widget = wibox.widget.textbox
    },
    spacing = dpi(4),
    layout = wibox.layout.fixed.horizontal
}

local events = wibox.widget {
    placeholder,
    spacing = dpi(4),
    widget = wibox.layout.fixed.vertical
}

local function get_events()
    events:reset()
    events:add(placeholder)
    placeholder.message.text = "Loading events..."

    spawn.easy_async(
        beautiful.gcalendar_command, function(stdout)
            local decoded, _, err = json.decode(stdout)

            if #decoded > 0 then
                events:reset()
                for i, event in ipairs(decoded) do
                    events:add(calendar_event(event))
                end
            else
                placeholder.message.text = "No events."
            end

        end
    )
end

helpers.add_action(icon, get_events)
helpers.add_list_scrolling(events)

get_events()

return wibox.widget {
    {
        {
            {
                header,
                events,
                spacing = dpi(4),
                layout = wibox.layout.fixed.vertical
            },
            top = dpi(2),
            left = dpi(8),
            right = dpi(8),
            widget = wibox.container.margin
        },
        border_width = dpi(1),
        border_color = beautiful.focus,
        shape = helpers.rrect(beautiful.border_radius - dpi(8)),
        widget = wibox.container.background
    },
    left = dpi(8),
    right = dpi(8),
    widget = wibox.container.margin
}
