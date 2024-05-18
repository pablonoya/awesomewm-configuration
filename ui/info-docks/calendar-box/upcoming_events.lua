local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local gshape = require("gears.shape")
local wibox = require("wibox")

local json = require("away.third_party.dkjson")

local variables = require("configuration.variables")
local helpers = require("helpers")

local text_icon = require("ui.widgets.text-icon")
local clickable_container = require("ui.widgets.clickable-container")

local calendar_event = require("ui.info-docks.calendar-box.calendar_event")

local placeholder = wibox.widget {
    {
        id = "message",
        text = "Loading events...",
        font = beautiful.font_name .. "12",
        widget = wibox.widget.textbox
    },
    margins = dpi(8),
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
    {
        text = "Upcoming events",
        font = beautiful.font_name .. "Semibold 12",
        widget = wibox.widget.textbox
    },
    nil,
    icon,
    layout = wibox.layout.align.horizontal
}

local events = wibox.widget {
    placeholder,
    spacing = dpi(4),
    widget = wibox.layout.fixed.vertical
}

local function on_connection()
    local added_events = {}
    spawn.easy_async(
        variables.gcalendar_command, function(stdout)
            local decoded, _, err = json.decode(stdout)

            if not (decoded and #decoded > 0) then
                placeholder.message.text = "No events."
                return
            end
            events:reset()

            for i, event in ipairs(decoded) do
                local key = event.start_date .. ":" .. event.summary

                if not added_events[key] then
                    events:add(calendar_event(event))
                    added_events[key] = true
                end
            end
        end
    )
end

local function get_events()
    events:reset()
    events:add(placeholder)
    placeholder.message.text = "Loading events..."

    helpers.check_internet_connection(on_connection)
end

helpers.add_action(icon, get_events)
helpers.add_list_scrolling(events)

-- Initial call
get_events()

return wibox.widget {
    {
        header,
        events,
        spacing = dpi(4),
        layout = wibox.layout.fixed.vertical
    },
    left = dpi(12),
    right = dpi(12),
    widget = wibox.container.margin
}
