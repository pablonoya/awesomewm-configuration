local beautiful = require("beautiful")
local wibox = require("wibox")

local color_helpers = require("helpers.color-helpers")
local border_popup = require("ui.widgets.border-popup")

-- Mapping from https://openweathermap.org/weather-conditions
local icon_map = {
    -- Clear
    ["01d"] = "\u{e81a}",
    ["01n"] = "\u{f159}",

    -- Few clouds
    ["02d"] = "\u{f172}",
    ["02n"] = "\u{f174}",

    -- Partly cloudy
    ["03d"] = "\u{f172}",
    ["03n"] = "\u{f174}",

    ["04d"] = "\u{f172}",
    ["04n"] = "\u{f174}",

    -- Rain
    ["09d"] = "\u{f176}",
    ["09n"] = "\u{f176}",

    ["10d"] = "\u{f176}",
    ["10n"] = "\u{f176}",

    -- Thunderstorm
    ["11d"] = "\u{f61e}",
    ["11n"] = "\u{f61e}",

    -- Snow
    ["13d"] = "\u{e810}",
    ["13n"] = "\u{e810}",

    -- Mist
    ["50d"] = "\u{e818}",
    ["50n"] = "\u{e818}"
}

local function capitalize(s)
    return s:sub(1, 1):upper() .. s:sub(2)
end

local function get_description(description)
    local mapping = {
        ["overcast clouds"] = "Cloudy",
        ["broken clouds"] = "Mostly cloudy",
        ["scattered clouds"] = "Partly cloudy"
    }

    return mapping[description] or capitalize(description)
end

local function colorize_by_temp(icon, temp)
    local color = beautiful.moon

    if temp < 12 then
        color = beautiful.blue
    elseif temp > 22 then
        color = beautiful.yellow
    elseif temp > 26 then
        color = beautiful.red
    end

    return color_helpers.colorize_text(icon, color)
end

local location_icon = wibox.widget {
    markup = "\u{e0c8}",
    font = beautiful.icon_font_name .. 12,
    widget = wibox.widget.textbox
}

local station = wibox.widget {
    markup = "Station",
    font = beautiful.font_name .. 11,
    widget = wibox.widget.textbox
}

local feels_like = wibox.widget {
    markup = "Feels like -°",
    font = beautiful.font_name .. 12,
    widget = wibox.widget.textbox
}

local description = wibox.widget {
    markup = "Clear sky",
    font = beautiful.font_name .. "Medium 12",
    halign = "right",
    widget = wibox.widget.textbox
}
local current_temp = wibox.widget {
    markup = "-°",
    font = beautiful.font_name .. "Medium 28",
    widget = wibox.widget.textbox
}

local icon = wibox.widget {
    markup = "\u{e2c1}",
    font = beautiful.icon_font_name .. 26,
    widget = wibox.widget.textbox
}

awesome.connect_signal(
    "weather::update", function(data)
        local degree_symbol = colorize_by_temp("°", data.main.temp)

        current_temp.markup = string.format("%.0f", data.main.temp) .. degree_symbol
        icon.markup = colorize_by_temp(icon_map[data.weather[1].icon], data.main.temp)
        feels_like.markup = string.format("Feels like %.0f", data.main.feels_like) .. degree_symbol

        description.markup = get_description(data.weather[1].description)
        station.markup = string.format("%s, %s", data.name, data.sys.country)
    end
)

local weather_popup = border_popup {
    widget = {
        {
            {
                {
                    {

                        {
                            current_temp,
                            icon,
                            spacing = dpi(8),
                            layout = wibox.layout.fixed.horizontal
                        },
                        feels_like,

                        spacing = dpi(-2),
                        layout = wibox.layout.fixed.vertical
                    },
                    widget = wibox.container.background
                },
                nil,
                {
                    {
                        description,
                        {
                            location_icon,
                            station,
                            spacing = dpi(4),
                            layout = wibox.layout.fixed.horizontal
                        },
                        layout = wibox.layout.fixed.vertical
                    },
                    top = dpi(4),
                    widget = wibox.container.margin
                },
                layout = wibox.layout.align.horizontal
            },
            top = dpi(4),
            bottom = dpi(8),
            left = dpi(16),
            right = dpi(16),
            widget = wibox.container.margin
        },
        forced_width = beautiful.notif_center_width,
        widget = wibox.container.background
    }
}

return weather_popup
