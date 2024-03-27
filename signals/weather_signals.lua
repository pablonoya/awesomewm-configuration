local spawn = require("awful.spawn")
local gtimer = require("gears.timer")

local json = require("away.third_party.dkjson")
local variables = require("configuration.variables")

local endpoint = "https://api.openweathermap.org/data/2.5/weather"

local query_params = {
    appid = variables.weather_api_key,
    lat = variables.latitude,
    lon = variables.longitude,
    units = "metric",
    lang = "en"
}

local function table_to_query_string(query_params)
    local query_string = {}

    for key, value in pairs(query_params) do
        table.insert(query_string, string.format("%s=%s", key, value))
    end

    return table.concat(query_string, "&")
end

local function emit_weather_signal(stdout, stderr)
    awesome.emit_signal("weather::update", json.decode(stdout))
end

local function check_internet_connection()
    spawn.easy_async_with_shell(
        "ping -c 1 8.8.8.8", function(stdout, stderr)
            if stderr == "" then
                -- Internet connection is available
                local command = string.format(
                    "curl -s -m 7 '%s?%s'", endpoint, table_to_query_string(query_params)
                )
                spawn.easy_async_with_shell(command, emit_weather_signal)
            else
                -- Retry after 5 seconds
                gtimer {
                    timeout = 5,
                    autostart = true,
                    single_shot = true,
                    callback = check_internet_connection
                }
            end
        end
    )
end

local timer = gtimer {
    timeout = 60 * 30,
    call_now = true,
    autostart = true,
    callback = check_internet_connection
}
