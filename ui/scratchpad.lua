local awful_screen = require("awful.screen")

local bling = require("module.bling")
local rubato = require("module.rubato")

-- These are example rubato tables. You can use one for just y, just x, or both.
-- The duration and easing is up to you. Please check out the rubato docs to learn more.
local anim_y = rubato.timed {
    -- pos = awful.screen.focused().geometry.height - 250,
    rate = 60,
    easing = rubato.quadratic,
    intro = 0.1,
    duration = 0.3,
    awestore_compat = true -- This option must be set to true.
}

-- local anim_x = rubato.timed {
--     pos = -970,
--     rate = 60,
--     easing = rubato.quadratic,
--     intro = 0.1,
--     duration = 0.3,
--     awestore_compat = true -- This option must be set to true.
-- }

local ytm_scratchpad = bling.module.scratchpad {
    command = "youtube-music", -- How to spawn the scratchpad
    rule = {
        instance = "youtube music"
    },
    sticky = true, -- Whether the scratchpad should be sticky
    autoclose = true, -- Whether it should hide itself when losing focus
    floating = true, -- Whether it should be floating (MUST BE TRUE FOR ANIMATIONS)
    -- The geometry in a floating state
    geometry = {
        x = 360,
        y = 90,
        height = awful_screen.focused().geometry.height - 250,
        width = awful_screen.focused().geometry.width - 700
    },
    -- reapply = true,
    dont_focus_before_close = false
    -- rubato = {
    --     -- x = anim_x,
    --     y = anim_y
    -- }
    -- Optional. This is how you can pass in the rubato tables for animations. If you don"t want animations, you can ignore this option.
}

return ytm_scratchpad
