local naughty = require("naughty")

local toggle_button = require("ui.widgets.toggle_button")

local signal_label = "notifications::suspended"

local function onclick()
    if not naughty.suspended then
        naughty.destroy_all_notifications()
    end
    naughty.suspended = not naughty.suspended
    awesome.emit_signal(signal_label, naughty.suspended)
end

return toggle_button {
    icon = "\u{e7f6}",
    name = "Silent mode",
    signal_label = signal_label,
    onclick = onclick
}
