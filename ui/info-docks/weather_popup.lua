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

local function format_description(description)
    local mapping = {
        ["overcast clouds"] = "Cloudy",
        ["broken clouds"] = "Mostly cloudy",
        ["scattered clouds"] = "Partly cloudy"
    }

    return mapping[description] or capitalize(description)
end

local function color_by_temp(temp)
    if temp < 12 then
        return beautiful.blue
    elseif temp > 22 then
        return beautiful.yellow
    elseif temp > 26 then
        return beautiful.red
    end

    return beautiful.moon
end

local location_icon = wibox.widget {
    markup = "\u{e0c8}",
    font = beautiful.icon_font_name .. 11,
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
    valign = "center",
    widget = wibox.widget.textbox
}
local current_temp = wibox.widget {
    markup = "-°",
    font = beautiful.font_name .. "Medium 26",
    widget = wibox.widget.textbox
}

local icon = wibox.widget {
    markup = "\u{e2c1}",
    font = beautiful.icon_font_name .. 30,
    widget = wibox.widget.textbox
}

local weather_popup = border_popup {
    widget = {
        {
            {
                {
                    current_temp,
                    {
                        description,
                        {
                            location_icon,
                            station,
                            spacing = dpi(4),
                            layout = wibox.layout.fixed.horizontal
                        },
                        spacing = dpi(2),
                        layout = wibox.layout.fixed.vertical
                    },
                    spacing = dpi(16),
                    layout = wibox.layout.fixed.horizontal,
                    widget = wibox.container.background
                },
                nil,
                icon,
                layout = wibox.layout.align.horizontal
            },
            top = dpi(8),
            bottom = dpi(8),
            left = dpi(16),
            right = dpi(24),
            widget = wibox.container.margin
        },
        forced_width = beautiful.notif_center_width,
        widget = wibox.container.background
    }
}

awesome.connect_signal(
    "weather::update", function(data)
        local degree_symbol = color_helpers.colorize_text("°", color_by_temp(data.main.temp))

        current_temp.markup = string.format("%.0f", data.main.temp) .. degree_symbol

        icon.markup = color_helpers.colorize_text(
            icon_map[data.weather[1].icon], color_by_temp(data.main.temp)
        )
        feels_like.markup = string.format("Feels like %.0f", data.main.feels_like) .. degree_symbol

        description.markup = format_description(data.weather[1].description)
        station.markup = string.format("%s, %s", data.name, data.sys.country)
    end
)

return weather_popup
