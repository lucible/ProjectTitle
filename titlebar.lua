local Device = require("device")
local Font = require("ui/font")
local Geom = require("ui/geometry")
local IconButton = require("ui/widget/iconbutton")
local Math = require("optmath")
local OverlapGroup = require("ui/widget/overlapgroup")
local TextWidget = require("ui/widget/textwidget")
local UIManager = require("ui/uimanager")
local LeftContainer = require("ui/widget/container/leftcontainer")
local RightContainer = require("ui/widget/container/rightcontainer")
local HorizontalGroup = require("ui/widget/horizontalgroup")
local HorizontalSpan = require("ui/widget/horizontalspan")
local VerticalGroup = require("ui/widget/verticalgroup")
local VerticalSpan = require("ui/widget/verticalspan")
local Screen = Device.screen
local logger = require("logger")
local ptutil = require("ptutil")
local ptdbg = require("ptdbg")

local DGENERIC_ICON_SIZE = G_defaults:readSetting("DGENERIC_ICON_SIZE")

local TitleBar = OverlapGroup:extend {
    left1_icon = nil,
    left1_icon_tap_callback = function() end,
    left1_icon_hold_callback = function() end,
    left1_icon_allow_flash = true,
    left2_icon = nil,
    left2_icon_tap_callback = function() end,
    left2_icon_hold_callback = function() end,
    left2_icon_allow_flash = true,
    left3_icon = nil,
    left3_icon_tap_callback = function() end,
    left3_icon_hold_callback = function() end,
    left3_icon_allow_flash = true,
    center_icon = nil,
    center_icon_tap_callback = function() end,
    center_icon_hold_callback = function() end,
    center_icon_allow_flash = true,
    right3_icon = nil,
    right3_icon_tap_callback = function() end,
    right3_icon_hold_callback = function() end,
    right3_icon_allow_flash = true,
    right2_icon = nil,
    right2_icon_tap_callback = function() end,
    right2_icon_hold_callback = function() end,
    right2_icon_allow_flash = true,
    right1_icon = nil,
    right1_icon_tap_callback = function() end,
    right1_icon_hold_callback = function() end,
    right1_icon_allow_flash = true,
    show_parent = nil,
    icon_size = Screen:scaleBySize(DGENERIC_ICON_SIZE),
    icon_padding_top = Screen:scaleBySize(6),
    icon_padding_bottom = nil,
    icon_margin_lr = Screen:scaleBySize(6),
    icon_reserved_width = nil,
    title_top_padding = nil,
    titlebar_margin_lr = Screen:scaleBySize(16),
    title = "",
    subtitle = "",
    fullscreen = "true",
    align = "center",
}

function TitleBar:init()
    self.icon_padding_bottom = self.icon_size * 0.2
    self.icon_reserved_width = (self.icon_size + self.icon_margin_lr) * 1.65
    local padding1 = self.titlebar_margin_lr
    local padding2 = self.titlebar_margin_lr + self.icon_reserved_width
    local padding3 = self.titlebar_margin_lr + (2 * self.icon_reserved_width)
    local center_icon_size = Screen:scaleBySize(DGENERIC_ICON_SIZE * self.center_icon_size_ratio)
    local total_width = center_icon_size + (padding3 * 2) + (2 * self.icon_reserved_width)

    self.title_top_padding = self.icon_size + self.icon_padding_bottom
    self.title_group = VerticalGroup:new {
        align = "center",
        overlap_align = "center",
        VerticalSpan:new { width = self.title_top_padding },
    }
    table.insert(self.title_group, self.title_widget)
    self.titlebar_height = self.title_group:getSize().h
    self.bottom_v_padding = Screen:scaleBySize(6)
    self.titlebar_height = self.titlebar_height + self.bottom_v_padding

    self.width = Screen:getWidth()
    self.dimen = Geom:new {
        x = 0,
        y = 0,
        w = self.width,
        h = self.titlebar_height, -- buttons can overflow this
    }

    self.left1_button = IconButton:new {
        icon = self.left1_icon,
        icon_rotation_angle = 0,
        width = self.icon_size,
        height = self.icon_size,
        padding = 0,
        padding_bottom = self.icon_padding_bottom,
        padding_top = self.icon_padding_top,
        callback = self.left1_icon_tap_callback,
        hold_callback = self.left1_icon_hold_callback,
        allow_flash = self.left1_icon_allow_flash,
        show_parent = self.show_parent,
    }
    self.left1_button_container = LeftContainer:new {
        dimen = self.dimen,
        HorizontalGroup:new {
            HorizontalSpan:new { width = padding1 },
            self.left1_button,
            HorizontalSpan:new { width = self.width - padding1 - self.left1_button:getSize().w },
        },
    }

    self.left2_button = IconButton:new {
        icon = self.left2_icon,
        icon_rotation_angle = 0,
        width = self.icon_size,
        height = self.icon_size,
        padding = 0,
        padding_bottom = self.icon_padding_bottom,
        padding_top = self.icon_padding_top,
        callback = self.left2_icon_tap_callback,
        hold_callback = self.left2_icon_hold_callback,
        allow_flash = self.left2_icon_allow_flash,
        show_parent = self.show_parent,
    }
    self.left2_button_container = LeftContainer:new {
        dimen = self.dimen,
        HorizontalGroup:new {
            HorizontalSpan:new { width = padding2 },
            self.left2_button,
            HorizontalSpan:new { width = self.width - padding2 - self.left2_button:getSize().w },
        },
    }

    self.left3_button = IconButton:new {
        icon = self.left3_icon,
        icon_rotation_angle = 0,
        width = self.icon_size,
        height = self.icon_size,
        padding = 0,
        padding_bottom = self.icon_padding_bottom,
        padding_top = self.icon_padding_top,
        callback = self.left3_icon_tap_callback,
        hold_callback = self.left3_icon_hold_callback,
        allow_flash = self.left3_icon_allow_flash,
        show_parent = self.show_parent,
    }
    self.left3_button_container = LeftContainer:new {
        dimen = self.dimen,
        HorizontalGroup:new {
            HorizontalSpan:new { width = padding3 },
            self.left3_button,
            HorizontalSpan:new { width = self.width - padding3 - self.left3_button:getSize().w },
        },
    }

    self.center_button = IconButton:new {
        icon = self.center_icon,
        icon_rotation_angle = 0,
        width = center_icon_size,
        height = center_icon_size,
        padding = 0,
        padding_bottom = 0,
        padding_top = Screen:scaleBySize(3),
        overlap_align = "center", -- this does all the work of centering itself, no container needed
        callback = self.center_icon_tap_callback,
        hold_callback = self.center_icon_hold_callback,
        allow_flash = self.center_icon_allow_flash,
        show_parent = self.show_parent,
    }
    self.center_button_container = self.center_button

    self.right3_button = IconButton:new {
        icon = self.right3_icon,
        icon_rotation_angle = 0,
        width = self.icon_size,
        height = self.icon_size,
        padding = 0,
        padding_bottom = self.icon_padding_bottom,
        padding_top = self.icon_padding_top,
        callback = self.right3_icon_tap_callback,
        hold_callback = self.right3_icon_hold_callback,
        allow_flash = self.right3_icon_allow_flash,
        show_parent = self.show_parent,
    }
    self.right3_button_container = RightContainer:new {
        dimen = self.dimen,
        HorizontalGroup:new {
            HorizontalSpan:new { width = self.width - padding3 - self.right3_button:getSize().w },
            self.right3_button,
            HorizontalSpan:new { width = padding3 },
        },
    }

    self.right2_button = IconButton:new {
        icon = self.right2_icon,
        icon_rotation_angle = 0,
        width = self.icon_size,
        height = self.icon_size,
        padding = 0,
        padding_bottom = self.icon_padding_bottom,
        padding_top = self.icon_padding_top,
        callback = self.right2_icon_tap_callback,
        hold_callback = self.right2_icon_hold_callback,
        allow_flash = self.right2_icon_allow_flash,
        show_parent = self.show_parent,
    }
    self.right2_button_container = RightContainer:new {
        dimen = self.dimen,
        HorizontalGroup:new {
            HorizontalSpan:new { width = self.width - padding2 - self.right2_button:getSize().w },
            self.right2_button,
            HorizontalSpan:new { width = padding2 },
        },
    }

    self.right1_button = IconButton:new {
        icon = self.right1_icon,
        icon_rotation_angle = 0,
        width = self.icon_size,
        height = self.icon_size,
        padding = 0,
        padding_bottom = self.icon_padding_bottom,
        padding_top = self.icon_padding_top,
        callback = self.right1_icon_tap_callback,
        hold_callback = self.right1_icon_hold_callback,
        allow_flash = self.right1_icon_allow_flash,
        show_parent = self.show_parent,
    }
    self.right1_button_container = RightContainer:new {
        dimen = self.dimen,
        HorizontalGroup:new {
            HorizontalSpan:new { width = self.width - padding1 - self.right1_button:getSize().w },
            self.right1_button,
            HorizontalSpan:new { width = padding1 },
        },
    }

    table.insert(self, self.left1_button_container)
    table.insert(self, self.left2_button_container)
    if total_width < self.width then
        table.insert(self, self.left3_button_container)
    else
        self.left3_button = nil -- not enough space (high dpi?) remove a button from each side
    end
    table.insert(self, self.right1_button_container)
    table.insert(self, self.right2_button_container)
    if total_width < self.width then
        table.insert(self, self.right3_button_container)
    else
        self.right3_button = nil -- not enough space (high dpi?) remove a button from each side
    end
    table.insert(self, self.center_button_container)

    -- maintain compatibility with FileManager or anything else that might expect the stock 2 buttons
    self.left_button = self.left1_button
    self.right_button = self.right1_button

    -- Call our base class's init (especially since OverlapGroup has very peculiar self.dimen semantics...)
    OverlapGroup.init(self)
end

function TitleBar:paintTo(bb, x, y)
    -- We need to update self.dimen's x and y for any ges.pos:intersectWith(title_bar)
    -- to work. (This is done by FrameContainer, but not by most other widgets... It
    -- should probably be done in all of them, but not sure of side effects...)
    self.dimen.x = x
    self.dimen.y = y
    OverlapGroup.paintTo(self, bb, x, y)
end

function TitleBar:getHeight()
    return self.titlebar_height
end

function TitleBar:setTitle(title, no_refresh)
    self.title = ""
end

function TitleBar:setSubTitle(subtitle, no_refresh)
    self.subtitle = ""
end

function TitleBar:setLeftIcon(icon)
    if self.has_left1_icon then
        self.left1_button:setIcon(icon)
        UIManager:setDirty(self.show_parent, "ui", self.dimen)
    end
end

function TitleBar:setLeft2Icon(icon)
    if self.has_left2_icon then
        self.left2_button:setIcon(icon)
        UIManager:setDirty(self.show_parent, "ui", self.dimen)
    end
end

function TitleBar:setLeft3Icon(icon)
    if self.has_left3_icon then
        self.left3_button:setIcon(icon)
        UIManager:setDirty(self.show_parent, "ui", self.dimen)
    end
end

function TitleBar:setcenterIcon(icon)
    if self.has_center_icon then
        self.center_button:setIcon(icon)
        UIManager:setDirty(self.show_parent, "ui", self.dimen)
    end
end

function TitleBar:setright3Icon(icon)
    if self.has_right3_icon then
        self.right3_button:setIcon(icon)
        UIManager:setDirty(self.show_parent, "ui", self.dimen)
    end
end

function TitleBar:setright2Icon(icon)
    if self.has_right2_icon then
        self.right2_button:setIcon(icon)
        UIManager:setDirty(self.show_parent, "ui", self.dimen)
    end
end

function TitleBar:setRightIcon(icon)
    if self.has_right1_icon then
        self.right1_button:setIcon(icon)
        UIManager:setDirty(self.show_parent, "ui", self.dimen)
    end
end

-- layout for FocusManager
function TitleBar:generateHorizontalLayout()
    local row = {}
    if self.left1_button then
        table.insert(row, self.left1_button)
    end
    if self.left2_button then
        table.insert(row, self.left2_button)
    end
    if self.left3_button then
        table.insert(row, self.left3_button)
    end
    if self.center_button then
        table.insert(row, self.center_button)
    end
    if self.right3_button then
        table.insert(row, self.right3_button)
    end
    if self.right2_button then
        table.insert(row, self.right2_button)
    end
    if self.right1_button then
        table.insert(row, self.right1_button)
    end
    local layout = {}
    if #row > 0 then
        table.insert(layout, row)
    end
    return layout
end

function TitleBar:generateVerticalLayout()
    local layout = {}
    if self.left1_button then
        table.insert(layout, { self.left1_button })
    end
    if self.left2_button then
        table.insert(layout, { self.left2_button })
    end
    if self.left3_button then
        table.insert(layout, { self.left3_button })
    end
    if self.center_button then
        table.insert(layout, { self.center_button })
    end
    if self.right3_button then
        table.insert(layout, { self.right3_button })
    end
    if self.right2_button then
        table.insert(layout, { self.right2_button })
    end
    if self.right1_button then
        table.insert(layout, { self.right1_button })
    end
    return layout
end

return TitleBar
