local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")

local modkeys = require("bindings.modkeys")
local rubato = require("module.rubato")

local border_container = require("ui.widgets.border-container")

local modkey, alt, ctrl, shift = table.unpack(modkeys)

local function change_width(widget, init, target)
    local timed = rubato.timed {
        duration = 0.1,
        pos = init,
        subscribed = function(pos)
            widget.forced_height = pos
            widget.forced_width = pos
        end
    }
    timed.target = target
end

local client_filter = function(t)
    return function(c)
        for _, v in ipairs(c:tags()) do
            if v == t then
                return true
            end
        end
        return false
    end
end

local tasklist = function(t)
    local s = awful.screen.focused()
    return awful.widget.tasklist {
        screen = t.screen,
        filter = client_filter(t),
        buttons = {
            awful.button(
                {}, awful.button.names.LEFT, function(c)
                    if c == client.focus then
                        c.minimized = true
                    else
                        c.minimized = false
                        c:emit_signal('request::activate')
                        c:raise()
                    end
                end
            ), awful.button(
                {}, awful.button.names.MIDDLE, function(c)
                    c:kill()
                end
            )
        },
        layout = {
            spacing_widget = nil,
            spacing = 8,
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            nil,
            {
                {
                    id = "clienticon",
                    forced_width = dpi(22),
                    widget = awful.widget.clienticon
                },
                buttons = {
                    awful.button(
                        {}, awful.button.names.LEFT, function(self)
                            change_width(self.widget.children[1], dpi(22), dpi(16))
                        end, function(self)
                            change_width(self.widget.children[1], dpi(16), dpi(22))
                        end
                    )
                },
                fill_vertical = true,
                forced_width = dpi(22),
                widget = wibox.container.place
            },
            {
                id = "background_role",
                forced_height = dpi(2),
                widget = wibox.container.background
            },
            layout = wibox.layout.align.vertical,
            create_callback = function(self, c)
                -- BLING: Toggle the popup on hover and disable it off hover
                self:connect_signal(
                    'mouse::enter', function()
                        awesome.emit_signal("bling::task_preview::visibility", s, true, c)
                        awesome.emit_signal("bling::tag_preview::visibility", s, false)
                    end
                )
                self:connect_signal(
                    'mouse::leave', function()
                        awesome.emit_signal("bling::task_preview::visibility", s, false, c)
                    end
                )
            end
        }
    }
end

local taglist_buttons = {
    awful.button(
        {}, awful.button.names.LEFT, function(t)
            t:view_only()
        end
    ), awful.button(
        {shift}, awful.button.names.LEFT, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ), awful.button(
        {ctrl}, awful.button.names.LEFT, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ), awful.button(
        {}, awful.button.names.SCROLL_UP, function(t)
            awful.tag.viewnext(t.screen)
        end
    ), awful.button(
        {}, awful.button.names.SCROLL_DOWN, function(t)
            awful.tag.viewprev(t.screen)
        end
    )
}

local grid_layout = wibox.layout {
    forced_num_cols = 2,
    forced_num_rows = 1,
    orientation = "vertical",
    expand = true,
    homogeneous = false,
    layout = wibox.layout.grid
}

local function adjust_grid_layout(s)
    local screen = s or awful.screen.focused()
    local is_horizontal = screen.geometry.height < screen.geometry.width
    if is_horizontal then
        return
    end

    local num_tags = 0
    for _, t in ipairs(screen.tags) do
        if t.selected or #t:clients() > 0 then
            num_tags = num_tags + 1
        end
    end

    if num_tags >= 4 then
        grid_layout.forced_num_cols = 4
        grid_layout.forced_num_rows = 2
    else
        grid_layout.forced_num_cols = math.max(num_tags, 1)
        grid_layout.forced_num_rows = 1
    end
end

local function create_taglist_callback(self, t, index, _)
    self:get_children_by_id("tasklist_placeholder")[1]:add(tasklist(t))
    self:get_children_by_id("index_role")[1].text = t.index
    self:connect_signal(
        "mouse::enter", function()
            if #t:clients() > 0 then
                awesome.emit_signal("bling::tag_preview::update", t)
                awesome.emit_signal("bling::tag_preview::visibility", t.screen, true)
            end
        end
    )
    self:connect_signal(
        "mouse::leave", function()
            awesome.emit_signal("bling::tag_preview::visibility", t.screen, false)
        end
    )
    helpers.add_hover_cursor(self)
    adjust_grid_layout(t.screen)
end

return function(s)
    local is_horizontal = s.geometry.height < s.geometry.width

    local custom_taglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.noempty,
        layout = is_horizontal and wibox.layout.fixed.horizontal or grid_layout,
        buttons = taglist_buttons,
        widget_template = {
            {
                {
                    -- tag
                    {
                        id = "index_role",
                        font = beautiful.font_name .. " Bold 14",
                        widget = wibox.widget.textbox
                    },
                    -- tasklist
                    {
                        id = "tasklist_placeholder",
                        layout = wibox.layout.fixed.horizontal,
                        widget = wibox.container.margin
                    },
                    spacing = dpi(4),
                    layout = wibox.layout.fixed.horizontal
                },
                left = dpi(8),
                right = dpi(8),
                widget = wibox.container.margin
            },
            id = "background_role",
            widget = wibox.container.background,
            create_callback = create_taglist_callback
        }
    }

    -- Update column and row number if vertical screen
    if not is_horizontal then
        tag.connect_signal(
            "property::selected", function()
                adjust_grid_layout()
            end
        )
    end

    return border_container {
        widget = custom_taglist
    }
end
