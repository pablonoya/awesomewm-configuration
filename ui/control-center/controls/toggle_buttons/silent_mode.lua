local beautiful = require("beautiful")
local naughty = require("naughty")

local toggle_button = require("ui.widgets.toggle-button")

local signal_suspended = "property::suspended"

local function onclick()
    if not naughty.suspended then
        naughty.destroy_all_notifications()
    end
    naughty.suspended = not naughty.suspended
    naughty.emit_signal(signal_suspended, naughty, naughty.suspended)
end

local signal = function(callback)
    naughty.connect_signal(
        "property::suspended", function(_, suspended)
            callback(suspended)
        end
    )
end

return toggle_button("\u{e7f6}", "Silent mode", beautiful.accent, onclick, signal)
