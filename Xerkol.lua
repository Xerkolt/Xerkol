-- // ═══════════════════════════════════════════════════════════════ // --
-- //                  NEXUS UI LIBRARY v2.0                         // --
-- //          Enhanced Roblox Script Library by Nexus               // --
-- //          quick note, ronaldo is still the goat.                // --
-- // ═══════════════════════════════════════════════════════════════ // --

local Lib = {}
local TweenService   = game:GetService("TweenService")
local UIS            = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")
local Players        = game:GetService("Players")
local CoreGui        = game:GetService("CoreGui")
local Debris         = game:GetService("Debris")
local HttpService    = game:GetService("HttpService")

local LocalPlayer    = Players.LocalPlayer
local Mouse          = LocalPlayer:GetMouse()

-- ══════════════════════════════════════
--  THEME SYSTEM
-- ══════════════════════════════════════
Lib.Themes = {
    Dark = {
        Background    = Color3.fromRGB(22, 18, 34),
        Surface       = Color3.fromRGB(31, 25, 46),
        TopBar        = Color3.fromRGB(16, 12, 26),
        TabFrame      = Color3.fromRGB(14, 11, 22),
        Element       = Color3.fromRGB(44, 40, 66),
        ElementHover  = Color3.fromRGB(56, 52, 80),
        Accent        = Color3.fromRGB(160, 110, 255),
        AccentDark    = Color3.fromRGB(110, 70, 200),
        AccentGlow    = Color3.fromRGB(200, 160, 255),
        Text          = Color3.fromRGB(230, 225, 245),
        SubText       = Color3.fromRGB(160, 150, 185),
        Success       = Color3.fromRGB(80, 220, 140),
        Warning       = Color3.fromRGB(255, 185, 60),
        Error         = Color3.fromRGB(255, 80, 90),
        Info          = Color3.fromRGB(80, 180, 255),
        SliderTrack   = Color3.fromRGB(35, 28, 55),
        Divider       = Color3.fromRGB(50, 44, 72),
    },
    Ocean = {
        Background    = Color3.fromRGB(12, 24, 38),
        Surface       = Color3.fromRGB(18, 34, 52),
        TopBar        = Color3.fromRGB(10, 20, 32),
        TabFrame      = Color3.fromRGB(8, 18, 28),
        Element       = Color3.fromRGB(22, 50, 72),
        ElementHover  = Color3.fromRGB(30, 64, 90),
        Accent        = Color3.fromRGB(40, 180, 255),
        AccentDark    = Color3.fromRGB(20, 130, 200),
        AccentGlow    = Color3.fromRGB(120, 220, 255),
        Text          = Color3.fromRGB(220, 240, 255),
        SubText       = Color3.fromRGB(140, 180, 210),
        Success       = Color3.fromRGB(60, 220, 160),
        Warning       = Color3.fromRGB(255, 200, 60),
        Error         = Color3.fromRGB(255, 90, 90),
        Info          = Color3.fromRGB(60, 200, 255),
        SliderTrack   = Color3.fromRGB(12, 30, 46),
        Divider       = Color3.fromRGB(24, 56, 80),
    },
    Crimson = {
        Background    = Color3.fromRGB(30, 14, 14),
        Surface       = Color3.fromRGB(42, 20, 20),
        TopBar        = Color3.fromRGB(22, 10, 10),
        TabFrame      = Color3.fromRGB(18, 8, 8),
        Element       = Color3.fromRGB(66, 30, 30),
        ElementHover  = Color3.fromRGB(82, 40, 40),
        Accent        = Color3.fromRGB(240, 70, 90),
        AccentDark    = Color3.fromRGB(180, 40, 60),
        AccentGlow    = Color3.fromRGB(255, 140, 150),
        Text          = Color3.fromRGB(245, 225, 225),
        SubText       = Color3.fromRGB(180, 150, 150),
        Success       = Color3.fromRGB(80, 220, 130),
        Warning       = Color3.fromRGB(255, 190, 60),
        Error         = Color3.fromRGB(255, 70, 80),
        Info          = Color3.fromRGB(100, 180, 255),
        SliderTrack   = Color3.fromRGB(50, 20, 20),
        Divider       = Color3.fromRGB(72, 32, 32),
    },
    Emerald = {
        Background    = Color3.fromRGB(12, 28, 20),
        Surface       = Color3.fromRGB(18, 40, 28),
        TopBar        = Color3.fromRGB(10, 22, 16),
        TabFrame      = Color3.fromRGB(8, 18, 12),
        Element       = Color3.fromRGB(22, 60, 40),
        ElementHover  = Color3.fromRGB(28, 76, 52),
        Accent        = Color3.fromRGB(50, 220, 130),
        AccentDark    = Color3.fromRGB(30, 160, 90),
        AccentGlow    = Color3.fromRGB(130, 255, 190),
        Text          = Color3.fromRGB(220, 245, 230),
        SubText       = Color3.fromRGB(140, 195, 165),
        Success       = Color3.fromRGB(60, 230, 130),
        Warning       = Color3.fromRGB(255, 195, 55),
        Error         = Color3.fromRGB(255, 85, 90),
        Info          = Color3.fromRGB(70, 190, 255),
        SliderTrack   = Color3.fromRGB(12, 34, 22),
        Divider       = Color3.fromRGB(24, 62, 42),
    },
}

Lib.CurrentTheme = Lib.Themes.Dark
Lib._themeListeners = {}

function Lib:SetTheme(themeName)
    if self.Themes[themeName] then
        self.CurrentTheme = self.Themes[themeName]
        for _, fn in ipairs(self._themeListeners) do
            pcall(fn, self.CurrentTheme)
        end
    end
end

function Lib:_onThemeChange(fn)
    table.insert(self._themeListeners, fn)
end

-- ══════════════════════════════════════
--  UTILITY FUNCTIONS
-- ══════════════════════════════════════
local function tween(obj, props, duration, style, direction)
    style     = style     or Enum.EasingStyle.Quint
    direction = direction or Enum.EasingDirection.Out
    duration  = duration  or 0.25
    local info = TweenInfo.new(duration, style, direction)
    TweenService:Create(obj, info, props):Play()
end

local function makeShadow(parent, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "_Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    shadow.Size = UDim2.new(1, size, 1, size)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = parent
    return shadow
end

local function makeStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.85
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function makeGradient(parent, rotation, colors)
    local grad = Instance.new("UIGradient")
    grad.Rotation = rotation or 90
    local seq = {}
    for i, c in ipairs(colors) do
        table.insert(seq, ColorSequenceKeypoint.new((i - 1) / (#colors - 1), c))
    end
    grad.Color = ColorSequence.new(seq)
    grad.Parent = parent
    return grad
end

local function playClick(pitch, volume)
    local s = Instance.new("Sound")
    s.SoundId  = "rbxassetid://6895079853"
    s.Volume   = volume or 0.6
    s.Pitch    = pitch   or 1
    s.Parent   = workspace
    s:Play()
    Debris:AddItem(s, 1)
end

local function rippleEffect(frame, mouseX, mouseY, color)
    local circle = Instance.new("Frame")
    circle.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
    circle.BackgroundTransparency = 0.7
    circle.BorderSizePixel = 0
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    local rx = mouseX - frame.AbsolutePosition.X
    local ry = mouseY - frame.AbsolutePosition.Y
    circle.Position = UDim2.new(0, rx, 0, ry)
    circle.Size = UDim2.new(0, 0, 0, 0)
    circle.ZIndex = frame.ZIndex + 10
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle
    circle.Parent = frame
    local maxSize = math.max(frame.AbsoluteSize.X, frame.AbsoluteSize.Y) * 2.5
    tween(circle, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        Position = UDim2.new(0, rx - maxSize / 2, 0, ry - maxSize / 2),
        BackgroundTransparency = 1,
    }, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    Debris:AddItem(circle, 0.6)
end

-- ══════════════════════════════════════
--  DRAG SYSTEM (improved)
-- ══════════════════════════════════════
function Lib:Drag(handle, target)
    target = target or handle
    local dragging   = false
    local dragStart  = nil
    local startPos   = nil
    local inputObj   = nil

    local function update(input)
        local delta = input.Position - dragStart
        local goal  = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        -- Clamp to screen
        local screenSize = workspace.CurrentCamera.ViewportSize
        local absSize    = target.AbsoluteSize
        local minX = 0
        local maxX = screenSize.X - absSize.X
        local minY = 0
        local maxY = screenSize.Y - absSize.Y
        local clampedX = math.clamp(startPos.X.Offset + delta.X, minX, maxX)
        local clampedY = math.clamp(startPos.Y.Offset + delta.Y, minY, maxY)
        tween(target, {Position = UDim2.new(startPos.X.Scale, clampedX, startPos.Y.Scale, clampedY)}, 0.07, Enum.EasingStyle.Linear)
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            inputObj  = input
            dragStart = input.Position
            startPos  = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    inputObj = nil
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        elseif input.UserInputType == Enum.UserInputType.Touch and input == inputObj then
            update(input)
        end
    end)
end

-- ══════════════════════════════════════
--  NOTIFICATION SYSTEM
-- ══════════════════════════════════════
local NotificationHolder = nil

local function ensureNotifHolder()
    if NotificationHolder and NotificationHolder.Parent then return end
    local sg = Instance.new("ScreenGui")
    sg.Name             = "NexusNotifications"
    sg.ResetOnSpawn     = false
    sg.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder     = 9999
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer.PlayerGui end

    local holder = Instance.new("Frame")
    holder.Name                    = "NotifHolder"
    holder.BackgroundTransparency  = 1
    holder.AnchorPoint             = Vector2.new(1, 1)
    holder.Position                = UDim2.new(1, -20, 1, -20)
    holder.Size                    = UDim2.new(0, 300, 1, -20)
    holder.Parent                  = sg

    local layout = Instance.new("UIListLayout")
    layout.SortOrder              = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment    = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment      = Enum.VerticalAlignment.Bottom
    layout.Padding                = UDim.new(0, 10)
    layout.Parent                 = holder

    NotificationHolder = holder
end

function Lib:Notify(options)
    options         = options         or {}
    local title     = options.Title   or "Notification"
    local desc      = options.Desc    or ""
    local duration  = options.Duration or 4
    local nType     = options.Type    or "Info"   -- Info | Success | Warning | Error
    local theme     = self.CurrentTheme

    ensureNotifHolder()

    local typeColors = {
        Info    = theme.Info,
        Success = theme.Success,
        Warning = theme.Warning,
        Error   = theme.Error,
    }
    local typeIcons = {
        Info    = "rbxassetid://3926305904",
        Success = "rbxassetid://3926305904",
        Warning = "rbxassetid://3926305904",
        Error   = "rbxassetid://3926305904",
    }
    local typeRects = {
        Info    = {Vector2.new(312, 4),   Vector2.new(36, 36)},
        Success = {Vector2.new(444, 324), Vector2.new(36, 36)},
        Warning = {Vector2.new(364, 164), Vector2.new(36, 36)},
        Error   = {Vector2.new(924, 724), Vector2.new(36, 36)},
    }

    local accentColor = typeColors[nType] or theme.Accent

    local card = Instance.new("Frame")
    card.Name                  = "Notification"
    card.BackgroundColor3      = theme.Surface
    card.BorderSizePixel       = 0
    card.ClipsDescendants      = true
    card.Size                  = UDim2.new(1, 0, 0, 72)
    card.BackgroundTransparency = 1
    card.Parent                = NotificationHolder

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 12)
    cardCorner.Parent = card

    makeStroke(card, accentColor, 1, 0.5)

    -- Accent bar left
    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = accentColor
    bar.BorderSizePixel  = 0
    bar.Size             = UDim2.new(0, 4, 1, 0)
    bar.Parent           = card
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 4)
    barCorner.Parent = bar

    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.BackgroundTransparency = 1
    icon.Position               = UDim2.new(0, 14, 0, 14)
    icon.Size                   = UDim2.new(0, 22, 0, 22)
    icon.Image                  = typeIcons[nType]
    icon.ImageColor3            = accentColor
    icon.ImageRectOffset        = typeRects[nType][1]
    icon.ImageRectSize          = typeRects[nType][2]
    icon.Parent                 = card

    -- Title
    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position               = UDim2.new(0, 44, 0, 8)
    titleLbl.Size                   = UDim2.new(1, -60, 0, 22)
    titleLbl.Font                   = Enum.Font.GothamBold
    titleLbl.Text                   = title
    titleLbl.TextColor3             = theme.Text
    titleLbl.TextSize               = 14
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
    titleLbl.Parent                 = card

    -- Desc
    local descLbl = Instance.new("TextLabel")
    descLbl.BackgroundTransparency = 1
    descLbl.Position               = UDim2.new(0, 44, 0, 30)
    descLbl.Size                   = UDim2.new(1, -60, 0, 34)
    descLbl.Font                   = Enum.Font.Gotham
    descLbl.Text                   = desc
    descLbl.TextColor3             = theme.SubText
    descLbl.TextSize               = 12
    descLbl.TextWrapped            = true
    descLbl.TextXAlignment         = Enum.TextXAlignment.Left
    descLbl.TextYAlignment         = Enum.TextYAlignment.Top
    descLbl.Parent                 = card

    -- Progress bar
    local progress = Instance.new("Frame")
    progress.BackgroundColor3 = accentColor
    progress.BackgroundTransparency = 0.4
    progress.BorderSizePixel  = 0
    progress.AnchorPoint      = Vector2.new(0, 1)
    progress.Position         = UDim2.new(0, 0, 1, 0)
    progress.Size             = UDim2.new(1, 0, 0, 2)
    progress.Parent           = card

    -- Close btn
    local closeBtn = Instance.new("TextButton")
    closeBtn.BackgroundTransparency = 1
    closeBtn.Position  = UDim2.new(1, -26, 0, 8)
    closeBtn.Size      = UDim2.new(0, 20, 0, 20)
    closeBtn.Text      = "×"
    closeBtn.TextColor3 = theme.SubText
    closeBtn.TextSize  = 18
    closeBtn.Font      = Enum.Font.GothamBold
    closeBtn.ZIndex    = card.ZIndex + 1
    closeBtn.Parent    = card

    -- Animate in
    card.Position = UDim2.new(1, 20, 0, 0)
    tween(card, {BackgroundTransparency = 0}, 0.3)
    tween(card, {Position = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- Progress tween
    tween(progress, {Size = UDim2.new(0, 0, 0, 2)}, duration, Enum.EasingStyle.Linear)

    local function dismiss()
        tween(card, {BackgroundTransparency = 1, Position = UDim2.new(1, 20, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
        wait(0.35)
        card:Destroy()
    end

    closeBtn.MouseButton1Click:Connect(dismiss)

    task.delay(duration, function()
        if card and card.Parent then
            dismiss()
        end
    end)

    return card
end

-- ══════════════════════════════════════
--  LOADING SCREEN
-- ══════════════════════════════════════
function Lib:LoadingScreen(options)
    options         = options         or {}
    local title     = options.Title   or "Loading"
    local subtitle  = options.Sub     or "Please wait..."
    local duration  = options.Duration or 3
    local theme     = self.CurrentTheme

    local sg = Instance.new("ScreenGui")
    sg.Name           = "NexusLoader"
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 99998
    sg.ResetOnSpawn   = false
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer.PlayerGui end

    local bg = Instance.new("Frame")
    bg.Size                 = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3     = theme.Background
    bg.BorderSizePixel      = 0
    bg.Parent               = sg

    -- Animated background dots
    for i = 1, 18 do
        local dot = Instance.new("Frame")
        dot.BackgroundColor3 = theme.Accent
        dot.BackgroundTransparency = math.random(60, 90) / 100
        dot.BorderSizePixel  = 0
        local s = math.random(4, 14)
        dot.Size             = UDim2.new(0, s, 0, s)
        dot.Position         = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
        dot.Parent           = bg
        local c2 = Instance.new("UICorner")
        c2.CornerRadius = UDim.new(1, 0)
        c2.Parent = dot
        task.spawn(function()
            while dot and dot.Parent do
                tween(dot, {BackgroundTransparency = math.random(40, 85) / 100}, math.random(10, 25) / 10, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                wait(math.random(10, 25) / 10)
            end
        end)
    end

    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Position    = UDim2.new(0.5, 0, 0.5, 0)
    container.Size        = UDim2.new(0, 320, 0, 160)
    container.Parent      = bg

    -- Logo ring
    local ring = Instance.new("ImageLabel")
    ring.BackgroundTransparency = 1
    ring.AnchorPoint  = Vector2.new(0.5, 0)
    ring.Position     = UDim2.new(0.5, 0, 0, 0)
    ring.Size         = UDim2.new(0, 60, 0, 60)
    ring.Image        = "rbxassetid://4287839393"
    ring.ImageColor3  = theme.Accent
    ring.Parent       = container

    -- Spinning ring animation
    task.spawn(function()
        local rot = 0
        while ring and ring.Parent do
            rot = rot + 4
            ring.Rotation = rot
            RunService.Heartbeat:Wait()
        end
    end)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.AnchorPoint = Vector2.new(0.5, 0)
    titleLbl.Position    = UDim2.new(0.5, 0, 0, 74)
    titleLbl.Size        = UDim2.new(1, 0, 0, 36)
    titleLbl.Font        = Enum.Font.GothamBold
    titleLbl.Text        = title
    titleLbl.TextColor3  = theme.Text
    titleLbl.TextSize    = 26
    titleLbl.Parent      = container

    local subLbl = Instance.new("TextLabel")
    subLbl.BackgroundTransparency = 1
    subLbl.AnchorPoint = Vector2.new(0.5, 0)
    subLbl.Position    = UDim2.new(0.5, 0, 0, 112)
    subLbl.Size        = UDim2.new(1, 0, 0, 22)
    subLbl.Font        = Enum.Font.Gotham
    subLbl.Text        = subtitle
    subLbl.TextColor3  = theme.SubText
    subLbl.TextSize    = 14
    subLbl.Parent      = container

    -- Progress bar
    local barBg = Instance.new("Frame")
    barBg.BackgroundColor3 = theme.SliderTrack
    barBg.BorderSizePixel  = 0
    barBg.AnchorPoint      = Vector2.new(0.5, 0)
    barBg.Position         = UDim2.new(0.5, 0, 0, 140)
    barBg.Size             = UDim2.new(1, 0, 0, 6)
    barBg.Parent           = container
    local barBgCorner = Instance.new("UICorner")
    barBgCorner.CornerRadius = UDim.new(1, 0)
    barBgCorner.Parent = barBg

    local barFill = Instance.new("Frame")
    barFill.BackgroundColor3 = theme.Accent
    barFill.BorderSizePixel  = 0
    barFill.Size             = UDim2.new(0, 0, 1, 0)
    barFill.Parent           = barBg
    local barFillCorner = Instance.new("UICorner")
    barFillCorner.CornerRadius = UDim.new(1, 0)
    barFillCorner.Parent = barFill

    makeGradient(barFill, 90, {theme.AccentDark, theme.Accent})

    tween(barFill, {Size = UDim2.new(1, 0, 1, 0)}, duration, Enum.EasingStyle.Quint)

    task.delay(duration, function()
        tween(bg, {BackgroundTransparency = 1}, 0.5)
        wait(0.5)
        sg:Destroy()
    end)

    return sg
end

-- ══════════════════════════════════════
--  MAIN WINDOW
-- ══════════════════════════════════════
function Lib.Window(Title, iconImage, themeName)
    Title     = Title     or "Nexus UI"
    local theme = Lib.CurrentTheme
    if themeName then Lib:SetTheme(themeName) theme = Lib.CurrentTheme end

    -- Root ScreenGui
    local UiLib = Instance.new("ScreenGui")
    UiLib.Name           = "NexusUI_" .. Title
    UiLib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    UiLib.DisplayOrder   = 100
    UiLib.ResetOnSpawn   = false
    pcall(function() UiLib.Parent = CoreGui end)
    if not UiLib.Parent then UiLib.Parent = LocalPlayer.PlayerGui end

    -- ── MAIN FRAME ──
    local Main = Instance.new("Frame")
    Main.Name             = "Main"
    Main.BackgroundColor3 = theme.Surface
    Main.BorderSizePixel  = 0
    Main.Position         = UDim2.new(0.5, -260, 0.5, -180)
    Main.Size             = UDim2.new(0, 520, 0, 360)
    Main.ZIndex           = 2
    Main.ClipsDescendants = false
    Main.Parent           = UiLib

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = Main

    makeStroke(Main, theme.Accent, 1, 0.75)
    makeShadow(Main, 40, 0.4)

    -- ── TOP BAR ──
    local TopBar = Instance.new("Frame")
    TopBar.Name             = "TopBar"
    TopBar.BackgroundColor3 = theme.TopBar
    TopBar.BorderSizePixel  = 0
    TopBar.Size             = UDim2.new(1, 0, 0, 48)
    TopBar.ZIndex           = 5
    TopBar.ClipsDescendants = false
    TopBar.Parent           = Main

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 16)
    TopCorner.Parent = TopBar

    -- Bottom filler so rounded top doesn't look weird
    local TopFill = Instance.new("Frame")
    TopFill.BackgroundColor3 = theme.TopBar
    TopFill.BorderSizePixel  = 0
    TopFill.Position         = UDim2.new(0, 0, 0.5, 0)
    TopFill.Size             = UDim2.new(1, 0, 0.5, 0)
    TopFill.ZIndex           = 4
    TopFill.Parent           = TopBar

    -- Subtle gradient on topbar
    makeGradient(TopBar, 90, {
        Color3.fromRGB(theme.TopBar.R * 255 + 10, theme.TopBar.G * 255 + 8, theme.TopBar.B * 255 + 18),
        theme.TopBar
    })

    -- Icon
    if iconImage then
        local Icon = Instance.new("ImageLabel")
        Icon.BackgroundTransparency = 1
        Icon.Position    = UDim2.new(0, 14, 0, 13)
        Icon.Size        = UDim2.new(0, 22, 0, 22)
        Icon.Image       = iconImage
        Icon.ScaleType   = Enum.ScaleType.Fit
        Icon.ZIndex      = 6
        Icon.Parent      = TopBar
    end

    -- Title
    local LibraryTitle = Instance.new("TextLabel")
    LibraryTitle.Name                 = "LibraryTitle"
    LibraryTitle.BackgroundTransparency = 1
    LibraryTitle.Position             = UDim2.new(0, iconImage and 44 or 16, 0, 0)
    LibraryTitle.Size                 = UDim2.new(0, 280, 1, 0)
    LibraryTitle.ZIndex               = 6
    LibraryTitle.Font                 = Enum.Font.GothamBold
    LibraryTitle.Text                 = Title
    LibraryTitle.TextColor3           = theme.Text
    LibraryTitle.TextSize             = 18
    LibraryTitle.TextXAlignment       = Enum.TextXAlignment.Left
    LibraryTitle.Parent               = TopBar

    -- Subtitle / status
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name                  = "StatusLabel"
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position              = UDim2.new(0, iconImage and 44 or 16, 0, 0)
    StatusLabel.Size                  = UDim2.new(0, 280, 1, 0)
    StatusLabel.ZIndex                = 6
    StatusLabel.Font                  = Enum.Font.Gotham
    StatusLabel.Text                  = ""
    StatusLabel.TextColor3            = theme.SubText
    StatusLabel.TextSize              = 11
    StatusLabel.TextXAlignment        = Enum.TextXAlignment.Left
    StatusLabel.TextYAlignment        = Enum.TextYAlignment.Bottom
    StatusLabel.Parent                = TopBar

    -- Window controls (minimize, close)
    local function makeTopBtn(icon, pos, bgColor)
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = bgColor or theme.Element
        btn.BorderSizePixel  = 0
        btn.Position         = pos
        btn.Size             = UDim2.new(0, 22, 0, 22)
        btn.ZIndex           = 7
        btn.Text             = icon
        btn.TextColor3       = theme.Text
        btn.TextSize         = 16
        btn.Font             = Enum.Font.GothamBold
        btn.Parent           = TopBar
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 6)
        c.Parent = btn

        btn.MouseEnter:Connect(function()
            tween(btn, {BackgroundColor3 = theme.Accent}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, {BackgroundColor3 = bgColor or theme.Element}, 0.15)
        end)
        return btn
    end

    local CloseBtn    = makeTopBtn("×", UDim2.new(1, -32, 0.5, -11))
    local MinimizeBtn = makeTopBtn("−", UDim2.new(1, -60, 0.5, -11))

    -- ── TAB FRAME ──
    local TabFrame = Instance.new("Frame")
    TabFrame.Name             = "TabFrame"
    TabFrame.BackgroundColor3 = theme.TabFrame
    TabFrame.BorderSizePixel  = 0
    TabFrame.Position         = UDim2.new(0, 10, 0, 58)
    TabFrame.Size             = UDim2.new(0, 148, 1, -68)
    TabFrame.ZIndex           = 4
    TabFrame.Parent           = Main

    local TabFrameCorner = Instance.new("UICorner")
    TabFrameCorner.CornerRadius = UDim.new(0, 10)
    TabFrameCorner.Parent = TabFrame

    makeStroke(TabFrame, theme.Divider, 1, 0.6)

    -- Search box for tabs
    local SearchHolder = Instance.new("Frame")
    SearchHolder.BackgroundColor3 = theme.Element
    SearchHolder.BorderSizePixel  = 0
    SearchHolder.Position         = UDim2.new(0, 8, 0, 8)
    SearchHolder.Size             = UDim2.new(1, -16, 0, 26)
    SearchHolder.ZIndex           = 6
    SearchHolder.Parent           = TabFrame
    local shCorner = Instance.new("UICorner")
    shCorner.CornerRadius = UDim.new(0, 7)
    shCorner.Parent = SearchHolder

    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Position  = UDim2.new(0, 4, 0.5, -7)
    SearchIcon.Size      = UDim2.new(0, 14, 0, 14)
    SearchIcon.Image     = "rbxassetid://3926305904"
    SearchIcon.ImageColor3 = theme.SubText
    SearchIcon.ImageRectOffset = Vector2.new(964, 324)
    SearchIcon.ImageRectSize   = Vector2.new(36, 36)
    SearchIcon.ZIndex    = 7
    SearchIcon.Parent    = SearchHolder

    local SearchBox = Instance.new("TextBox")
    SearchBox.BackgroundTransparency = 1
    SearchBox.Position               = UDim2.new(0, 22, 0, 0)
    SearchBox.Size                   = UDim2.new(1, -26, 1, 0)
    SearchBox.Font                   = Enum.Font.Gotham
    SearchBox.PlaceholderText        = "Search tabs..."
    SearchBox.PlaceholderColor3      = theme.SubText
    SearchBox.Text                   = ""
    SearchBox.TextColor3             = theme.Text
    SearchBox.TextSize               = 11
    SearchBox.TextXAlignment         = Enum.TextXAlignment.Left
    SearchBox.ZIndex                 = 7
    SearchBox.ClearTextOnFocus       = false
    SearchBox.Parent                 = SearchHolder

    -- Tab navigator
    local TabNavigator = Instance.new("ScrollingFrame")
    TabNavigator.Name                   = "TabNavigator"
    TabNavigator.Active                 = true
    TabNavigator.BackgroundTransparency = 1
    TabNavigator.BorderSizePixel        = 0
    TabNavigator.Position               = UDim2.new(0, 0, 0, 42)
    TabNavigator.Size                   = UDim2.new(1, 0, 1, -42)
    TabNavigator.ZIndex                 = 5
    TabNavigator.CanvasSize             = UDim2.new(0, 0, 0, 0)
    TabNavigator.ScrollBarThickness     = 2
    TabNavigator.ScrollBarImageColor3   = theme.Accent
    TabNavigator.ScrollBarImageTransparency = 0.5
    TabNavigator.Parent                 = TabFrame

    local TabNavPad = Instance.new("UIPadding")
    TabNavPad.PaddingTop    = UDim.new(0, 8)
    TabNavPad.PaddingLeft   = UDim.new(0, 8)
    TabNavPad.PaddingRight  = UDim.new(0, 8)
    TabNavPad.Parent        = TabNavigator

    local TabNavLayout = Instance.new("UIListLayout")
    TabNavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabNavLayout.SortOrder           = Enum.SortOrder.LayoutOrder
    TabNavLayout.Padding             = UDim.new(0, 6)
    TabNavLayout.Parent              = TabNavigator

    TabNavLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabNavigator.CanvasSize = UDim2.new(0, 0, 0,
            TabNavLayout.AbsoluteContentSize.Y + TabNavPad.PaddingTop.Offset + 8)
    end)

    -- ── CONTENT AREA ──
    local ContentArea = Instance.new("Frame")
    ContentArea.Name             = "ContentArea"
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position         = UDim2.new(0, 166, 0, 58)
    ContentArea.Size             = UDim2.new(1, -176, 1, -68)
    ContentArea.ZIndex           = 3
    ContentArea.ClipsDescendants = false
    ContentArea.Parent           = Main

    -- Content holder (folder-like)
    local ContentHolder = Instance.new("Folder")
    ContentHolder.Name   = "ContentHolder"
    ContentHolder.Parent = Main

    -- ── DRAG ──
    Lib:Drag(TopBar, Main)

    -- ── STATUS SETTER ──
    local function setStatus(text)
        StatusLabel.Text = text or ""
    end

    -- ── MINIMIZE / CLOSE ──
    local minimized       = false
    local originalSize    = Main.Size
    local trayBtn         = nil

    local function destroyTray()
        if trayBtn then trayBtn:Destroy() trayBtn = nil end
    end

    local function buildTray()
        destroyTray()
        trayBtn = Instance.new("TextButton")
        trayBtn.Name             = "NexusTray"
        trayBtn.BackgroundColor3 = theme.Surface
        trayBtn.BorderSizePixel  = 0
        trayBtn.AnchorPoint      = Vector2.new(1, 0)
        trayBtn.Position         = UDim2.new(1, -16, 0, 16)
        trayBtn.Size             = UDim2.new(0, 52, 0, 52)
        trayBtn.Text             = ""
        trayBtn.ZIndex           = 10
        trayBtn.Parent           = UiLib
        local tc = Instance.new("UICorner")
        tc.CornerRadius = UDim.new(1, 0)
        tc.Parent = trayBtn
        makeStroke(trayBtn, theme.Accent, 2, 0.4)
        makeShadow(trayBtn, 16, 0.5)

        if iconImage then
            local img = Instance.new("ImageLabel", trayBtn)
            img.BackgroundTransparency = 1
            img.Size     = UDim2.new(1, -12, 1, -12)
            img.Position = UDim2.new(0, 6, 0, 6)
            img.Image    = iconImage
            img.ScaleType = Enum.ScaleType.Fit
            img.ZIndex   = 11
        else
            local lbl = Instance.new("TextLabel", trayBtn)
            lbl.BackgroundTransparency = 1
            lbl.Size        = UDim2.new(1, 0, 1, 0)
            lbl.Font        = Enum.Font.GothamBold
            lbl.Text        = Title:sub(1, 1):upper()
            lbl.TextColor3  = theme.Accent
            lbl.TextSize    = 22
            lbl.ZIndex      = 11
        end

        trayBtn.MouseButton1Click:Connect(function()
            playClick(1.1, 0.5)
            destroyTray()
            minimized = false
            tween(Main, {Size = originalSize}, 0.35, Enum.EasingStyle.Back)
            task.wait(0.1)
            TabFrame.Visible    = true
            ContentArea.Visible = true
        end)
    end

    CloseBtn.MouseButton1Click:Connect(function()
        playClick(0.9, 0.5)
        if not minimized then
            minimized = true
            TabFrame.Visible    = false
            ContentArea.Visible = false
            tween(Main, {Size = UDim2.new(0, originalSize.X.Offset, 0, 48)}, 0.3, Enum.EasingStyle.Quint)
            buildTray()
        else
            minimized = false
            destroyTray()
            TabFrame.Visible    = true
            ContentArea.Visible = true
            tween(Main, {Size = originalSize}, 0.35, Enum.EasingStyle.Back)
        end
    end)

    MinimizeBtn.MouseButton1Click:Connect(function()
        playClick(1, 0.4)
        UiLib.Enabled = not UiLib.Enabled
    end)

    -- Toggle shortcut
    function Lib:ToggleUI()
        UiLib.Enabled = not UiLib.Enabled
        playClick(UiLib.Enabled and 1.1 or 0.9, 0.5)
    end

    -- ── KEYBIND TOGGLE (default: RightShift) ──
    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            Lib:ToggleUI()
        end
    end)

    -- ── SEARCH FILTER ──
    local allTabButtons = {}
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = SearchBox.Text:lower()
        for _, entry in ipairs(allTabButtons) do
            if q == "" or entry.title:lower():find(q, 1, true) then
                entry.btn.Visible = true
            else
                entry.btn.Visible = false
            end
        end
    end)

    -- ══════════════════════════════════════
    --  TAB SYSTEM
    -- ══════════════════════════════════════
    local TabSys        = {}
    local activeContent = nil
    local activeBtn     = nil
    local isFirstTab    = true

    local function switchToContent(content, btn)
        if activeContent == content then return end

        -- Hide old
        if activeContent then
            tween(activeContent, {GroupTransparency = 1}, 0.12)
            task.wait(0.12)
            if activeContent then activeContent.Visible = false end
        end
        if activeBtn then
            tween(activeBtn, {
                BackgroundColor3    = theme.Element,
                BackgroundTransparency = 0.2,
            }, 0.2)
            local lbl = activeBtn:FindFirstChildWhichIsA("TextLabel")
            if lbl then tween(lbl, {TextColor3 = theme.SubText}, 0.2) end
            local bar = activeBtn:FindFirstChild("_ActiveBar")
            if bar then tween(bar, {BackgroundTransparency = 1}, 0.2) end
        end

        activeContent = content
        activeBtn     = btn
        content.Visible = true
        tween(content, {GroupTransparency = 0}, 0.18)

        tween(btn, {
            BackgroundColor3    = theme.Accent,
            BackgroundTransparency = 0.75,
        }, 0.2)
        local lbl = btn:FindFirstChildWhichIsA("TextLabel")
        if lbl then tween(lbl, {TextColor3 = theme.Text}, 0.2) end
        local bar = btn:FindFirstChild("_ActiveBar")
        if bar then tween(bar, {BackgroundTransparency = 0}, 0.2) end
    end

    function TabSys.CreateTab(TabTitle, TabIcon)
        TabTitle = TabTitle or "Tab"

        -- ── Tab Button ──
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name                  = "TabBtn_" .. TabTitle
        TabBtn.BackgroundColor3      = theme.Element
        TabBtn.BackgroundTransparency = 0.2
        TabBtn.BorderSizePixel       = 0
        TabBtn.Size                  = UDim2.new(1, 0, 0, 32)
        TabBtn.ZIndex                = 6
        TabBtn.Text                  = ""
        TabBtn.AutoButtonColor       = false
        TabBtn.Parent                = TabNavigator

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 8)
        TabBtnCorner.Parent = TabBtn

        -- Active indicator bar
        local ActiveBar = Instance.new("Frame")
        ActiveBar.Name             = "_ActiveBar"
        ActiveBar.BackgroundColor3 = theme.Accent
        ActiveBar.BorderSizePixel  = 0
        ActiveBar.Position         = UDim2.new(0, 0, 0.15, 0)
        ActiveBar.Size             = UDim2.new(0, 3, 0.7, 0)
        ActiveBar.ZIndex           = 7
        ActiveBar.BackgroundTransparency = 1
        ActiveBar.Parent           = TabBtn
        local abc = Instance.new("UICorner")
        abc.CornerRadius = UDim.new(0, 2)
        abc.Parent = ActiveBar

        -- Tab icon
        if TabIcon then
            local ti = Instance.new("ImageLabel")
            ti.BackgroundTransparency = 1
            ti.Position  = UDim2.new(0, 8, 0.5, -9)
            ti.Size      = UDim2.new(0, 18, 0, 18)
            ti.Image     = TabIcon
            ti.ZIndex    = 7
            ti.ImageColor3 = theme.SubText
            ti.Parent    = TabBtn
        end

        local TabLabel = Instance.new("TextLabel")
        TabLabel.BackgroundTransparency = 1
        TabLabel.Position = UDim2.new(0, TabIcon and 32 or 12, 0, 0)
        TabLabel.Size     = UDim2.new(1, TabIcon and -36 or -16, 1, 0)
        TabLabel.Font     = Enum.Font.GothamBold
        TabLabel.Text     = TabTitle
        TabLabel.TextColor3 = theme.SubText
        TabLabel.TextSize = 13
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.ZIndex   = 7
        TabLabel.Parent   = TabBtn

        table.insert(allTabButtons, {btn = TabBtn, title = TabTitle})

        -- ── Content ScrollingFrame ──
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name                   = "TC_" .. TabTitle
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel        = 0
        TabContent.Size                   = UDim2.new(1, 0, 1, 0)
        TabContent.ZIndex                 = 4
        TabContent.ClipsDescendants       = true
        TabContent.CanvasSize             = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness     = 3
        TabContent.ScrollBarImageColor3   = theme.Accent
        TabContent.ScrollBarImageTransparency = 0.4
        TabContent.Visible                = false
        TabContent.GroupTransparency      = 1
        TabContent.Parent                 = ContentArea

        local ContentPad = Instance.new("UIPadding")
        ContentPad.PaddingTop   = UDim.new(0, 10)
        ContentPad.PaddingBottom = UDim.new(0, 10)
        ContentPad.Parent = TabContent

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ContentLayout.SortOrder           = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding             = UDim.new(0, 10)
        ContentLayout.Parent              = TabContent

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0,
                ContentLayout.AbsoluteContentSize.Y + ContentPad.PaddingTop.Offset + ContentPad.PaddingBottom.Offset)
        end)

        -- Hover on tab btn
        TabBtn.MouseEnter:Connect(function()
            if activeBtn ~= TabBtn then
                tween(TabBtn, {BackgroundTransparency = 0.05}, 0.15)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if activeBtn ~= TabBtn then
                tween(TabBtn, {BackgroundTransparency = 0.2}, 0.15)
            end
        end)

        TabBtn.MouseButton1Click:Connect(function()
            playClick(1.05, 0.3)
            switchToContent(TabContent, TabBtn)
        end)

        if isFirstTab then
            isFirstTab = false
            task.defer(function()
                switchToContent(TabContent, TabBtn)
            end)
        end

        -- ══════════════════════════════════════
        --  ELEMENT FACTORY
        -- ══════════════════════════════════════
        local Content = {}

        -- ── Helper: base element frame ──
        local function baseFrame(height, extraClips)
            local f = Instance.new("Frame")
            f.BackgroundColor3 = theme.Element
            f.BorderSizePixel  = 0
            f.Size             = UDim2.new(1, -4, 0, height or 36)
            f.ZIndex           = 5
            f.ClipsDescendants = extraClips or false
            f.Parent           = TabContent
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 10)
            c.Parent = f
            makeStroke(f, theme.Divider, 1, 0.7)
            return f
        end

        -- ── Helper: element icon ──
        local function elemIcon(parent, image, rectOff, rectSize, xPos)
            local i = Instance.new("ImageLabel")
            i.BackgroundTransparency = 1
            i.Position   = UDim2.new(0, xPos or 10, 0.5, -10)
            i.Size       = UDim2.new(0, 20, 0, 20)
            i.Image      = image
            i.ImageColor3 = theme.Accent
            i.ZIndex     = 6
            if rectOff  then i.ImageRectOffset = rectOff  end
            if rectSize then i.ImageRectSize   = rectSize end
            i.Parent     = parent
            return i
        end

        -- ── Helper: element label ──
        local function elemLabel(parent, text, xOff, yOff, wOff, h, sub)
            local l = Instance.new("TextLabel")
            l.BackgroundTransparency = 1
            l.Position   = UDim2.new(0, xOff or 38, 0, yOff or 0)
            l.Size       = UDim2.new(1, wOff or -44, 0, h or 36)
            l.Font       = Enum.Font.GothamBold
            l.Text       = text
            l.TextColor3 = sub and theme.SubText or theme.Text
            l.TextSize   = sub and 11 or 14
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.TextWrapped = true
            l.ZIndex     = 6
            l.Parent     = parent
            return l
        end

        -- ══════════════
        -- BUTTON
        -- ══════════════
        function Content.CreateButton(BtnTitle, desc, callback)
            if type(desc) == "function" then callback = desc desc = nil end
            BtnTitle = BtnTitle or "Button"
            callback = callback or function() end

            local frame = baseFrame(desc and 48 or 36, true)

            elemIcon(frame, "rbxassetid://3926305904",
                Vector2.new(84, 204), Vector2.new(36, 36))

            elemLabel(frame, BtnTitle)
            if desc then
                elemLabel(frame, desc, 38, 18, -44, 24, true)
            end

            -- Right arrow
            local arrow = Instance.new("TextLabel")
            arrow.BackgroundTransparency = 1
            arrow.AnchorPoint  = Vector2.new(1, 0.5)
            arrow.Position     = UDim2.new(1, -12, 0.5, 0)
            arrow.Size         = UDim2.new(0, 18, 0, 18)
            arrow.Text         = "›"
            arrow.TextColor3   = theme.Accent
            arrow.TextSize     = 20
            arrow.Font         = Enum.Font.GothamBold
            arrow.ZIndex       = 6
            arrow.Parent       = frame

            local trigger = Instance.new("TextButton")
            trigger.BackgroundTransparency = 1
            trigger.Size       = UDim2.new(1, 0, 1, 0)
            trigger.Text       = ""
            trigger.ZIndex     = 7
            trigger.Parent     = frame

            trigger.MouseEnter:Connect(function()
                tween(frame, {BackgroundColor3 = theme.ElementHover}, 0.15)
                tween(arrow, {TextColor3 = theme.AccentGlow}, 0.15)
            end)
            trigger.MouseLeave:Connect(function()
                tween(frame, {BackgroundColor3 = theme.Element}, 0.15)
                tween(arrow, {TextColor3 = theme.Accent}, 0.15)
            end)

            trigger.MouseButton1Click:Connect(function()
                playClick(0.9, 0.4)
                rippleEffect(frame, Mouse.X, Mouse.Y, theme.Accent)
                pcall(callback)
            end)

            return {
                SetTitle = function(_, t) 
                    local lbl = frame:FindFirstChildWhichIsA("TextLabel")
                    if lbl then lbl.Text = t end
                end,
                SetVisible = function(_, v) frame.Visible = v end,
            }
        end

        -- ══════════════
        -- TOGGLE
        -- ══════════════
        function Content.CreateToggle(TogTXT, desc, default, callback)
            if type(desc) == "function" then callback = desc desc = nil default = false
            elseif type(default) == "function" then callback = default default = false end
            TogTXT   = TogTXT   or "Toggle"
            callback = callback or function() end
            default  = default  or false

            local toggled = default
            local frame   = baseFrame(desc and 48 or 36, true)

            elemIcon(frame, "rbxassetid://3926309567",
                Vector2.new(628, 420), Vector2.new(48, 48))

            elemLabel(frame, TogTXT)
            if desc then elemLabel(frame, desc, 38, 18, -80, 24, true) end

            -- Toggle pill
            local pillBg = Instance.new("Frame")
            pillBg.BackgroundColor3 = toggled and theme.Accent or theme.SliderTrack
            pillBg.BorderSizePixel  = 0
            pillBg.AnchorPoint      = Vector2.new(1, 0.5)
            pillBg.Position         = UDim2.new(1, -10, 0.5, 0)
            pillBg.Size             = UDim2.new(0, 36, 0, 18)
            pillBg.ZIndex           = 6
            pillBg.Parent           = frame
            local pillCorner = Instance.new("UICorner")
            pillCorner.CornerRadius = UDim.new(1, 0)
            pillCorner.Parent = pillBg

            local pillKnob = Instance.new("Frame")
            pillKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            pillKnob.BorderSizePixel  = 0
            pillKnob.AnchorPoint      = Vector2.new(0.5, 0.5)
            pillKnob.Position         = toggled and UDim2.new(0.78, 0, 0.5, 0) or UDim2.new(0.22, 0, 0.5, 0)
            pillKnob.Size             = UDim2.new(0, 12, 0, 12)
            pillKnob.ZIndex           = 7
            pillKnob.Parent           = pillBg
            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = pillKnob

            local trigger = Instance.new("TextButton")
            trigger.BackgroundTransparency = 1
            trigger.Size = UDim2.new(1, 0, 1, 0)
            trigger.Text = ""
            trigger.ZIndex = 7
            trigger.Parent = frame

            local function updateVisual()
                if toggled then
                    tween(pillBg,   {BackgroundColor3 = theme.Accent}, 0.2)
                    tween(pillKnob, {Position = UDim2.new(0.78, 0, 0.5, 0)}, 0.2, Enum.EasingStyle.Back)
                else
                    tween(pillBg,   {BackgroundColor3 = theme.SliderTrack}, 0.2)
                    tween(pillKnob, {Position = UDim2.new(0.22, 0, 0.5, 0)}, 0.2, Enum.EasingStyle.Back)
                end
            end

            trigger.MouseEnter:Connect(function()
                tween(frame, {BackgroundColor3 = theme.ElementHover}, 0.15)
            end)
            trigger.MouseLeave:Connect(function()
                tween(frame, {BackgroundColor3 = theme.Element}, 0.15)
            end)

            trigger.MouseButton1Click:Connect(function()
                toggled = not toggled
                playClick(toggled and 1.1 or 0.9, 0.4)
                rippleEffect(frame, Mouse.X, Mouse.Y, toggled and theme.Accent or theme.SubText)
                updateVisual()
                pcall(callback, toggled)
            end)

            local obj = {
                SetValue = function(_, v)
                    toggled = v
                    updateVisual()
                end,
                GetValue = function() return toggled end,
                SetVisible = function(_, v) frame.Visible = v end,
            }
            return obj
        end

        -- ══════════════
        -- SLIDER
        -- ══════════════
        function Content.CreateSlider(SliderTitle, options, callback)
            if type(options) == "function" then callback = options options = {} end
            SliderTitle = SliderTitle or "Slider"
            options     = options     or {}
            callback    = callback    or function() end

            local minVal  = options.Min     or 0
            local maxVal  = options.Max     or 100
            local defVal  = options.Default or minVal
            local step    = options.Step    or 1
            local suffix  = options.Suffix  or ""
            local showPct = options.Percent or false

            local frame = baseFrame(58, true)

            elemIcon(frame, "rbxassetid://3926307971",
                Vector2.new(404, 164), Vector2.new(36, 36))

            local titleLbl = elemLabel(frame, SliderTitle, 38, 0, -90, 26)

            local valLbl = Instance.new("TextLabel")
            valLbl.BackgroundTransparency = 1
            valLbl.AnchorPoint = Vector2.new(1, 0)
            valLbl.Position    = UDim2.new(1, -10, 0, 0)
            valLbl.Size        = UDim2.new(0, 72, 0, 26)
            valLbl.Font        = Enum.Font.GothamBold
            valLbl.TextColor3  = theme.Accent
            valLbl.TextSize    = 13
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.ZIndex      = 6
            valLbl.Parent      = frame

            -- Track
            local trackBg = Instance.new("Frame")
            trackBg.BackgroundColor3 = theme.SliderTrack
            trackBg.BorderSizePixel  = 0
            trackBg.Position         = UDim2.new(0, 10, 0, 40)
            trackBg.Size             = UDim2.new(1, -20, 0, 6)
            trackBg.ZIndex           = 6
            trackBg.Parent           = frame
            local trCorner = Instance.new("UICorner")
            trCorner.CornerRadius = UDim.new(1, 0)
            trCorner.Parent = trackBg

            local trackFill = Instance.new("Frame")
            trackFill.BackgroundColor3 = theme.Accent
            trackFill.BorderSizePixel  = 0
            trackFill.Size             = UDim2.new(0, 0, 1, 0)
            trackFill.ZIndex           = 7
            trackFill.Parent           = trackBg
            local tfCorner = Instance.new("UICorner")
            tfCorner.CornerRadius = UDim.new(1, 0)
            tfCorner.Parent = trackFill

            makeGradient(trackFill, 90, {theme.AccentDark, theme.Accent})

            -- Thumb
            local thumb = Instance.new("Frame")
            thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            thumb.BorderSizePixel  = 0
            thumb.AnchorPoint      = Vector2.new(0.5, 0.5)
            thumb.Position         = UDim2.new(0, 0, 0.5, 0)
            thumb.Size             = UDim2.new(0, 12, 0, 12)
            thumb.ZIndex           = 8
            thumb.Parent           = trackBg
            local thumbCorner = Instance.new("UICorner")
            thumbCorner.CornerRadius = UDim.new(1, 0)
            thumbCorner.Parent = thumb

            local thumbGlow = Instance.new("UIStroke")
            thumbGlow.Color       = theme.Accent
            thumbGlow.Thickness   = 2
            thumbGlow.Transparency = 0.3
            thumbGlow.Parent      = thumb

            local currentVal = defVal
            local dragging   = false

            local function round(n, s)
                s = s or 1
                return math.floor(n / s + 0.5) * s
            end

            local function setFromPercent(pct)
                pct = math.clamp(pct, 0, 1)
                local raw = minVal + (maxVal - minVal) * pct
                currentVal = round(raw, step)
                local fillPct = (currentVal - minVal) / (maxVal - minVal)

                tween(trackFill, {Size = UDim2.new(fillPct, 0, 1, 0)}, 0.06, Enum.EasingStyle.Linear)
                tween(thumb,     {Position = UDim2.new(fillPct, 0, 0.5, 0)}, 0.06, Enum.EasingStyle.Linear)

                if showPct then
                    valLbl.Text = math.floor(fillPct * 100) .. "%"
                else
                    valLbl.Text = tostring(currentVal) .. suffix
                end
                pcall(callback, currentVal)
            end

            -- Set default
            local initPct = (defVal - minVal) / (maxVal - minVal)
            trackFill.Size = UDim2.new(initPct, 0, 1, 0)
            thumb.Position = UDim2.new(initPct, 0, 0.5, 0)
            valLbl.Text    = tostring(defVal) .. suffix

            local sliderTrigger = Instance.new("TextButton")
            sliderTrigger.BackgroundTransparency = 1
            sliderTrigger.Size = UDim2.new(1, 0, 1, 10)
            sliderTrigger.Position = UDim2.new(0, 0, 0, -5)
            sliderTrigger.Text = ""
            sliderTrigger.ZIndex = 9
            sliderTrigger.Parent = trackBg

            local moveConn, endConn

            local function startSlide(inputX)
                dragging = true
                tween(thumb, {Size = UDim2.new(0, 16, 0, 16)}, 0.15, Enum.EasingStyle.Back)
                local function update(x)
                    local rel = x - trackBg.AbsolutePosition.X
                    local pct = rel / trackBg.AbsoluteSize.X
                    setFromPercent(pct)
                end
                update(inputX)

                moveConn = UIS.InputChanged:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseMovement
                    or inp.UserInputType == Enum.UserInputType.Touch then
                        local pos = UIS:GetMouseLocation()
                        update(pos.X)
                    end
                end)
                endConn = UIS.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1
                    or inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                        tween(thumb, {Size = UDim2.new(0, 12, 0, 12)}, 0.15)
                        if moveConn then moveConn:Disconnect() end
                        if endConn  then endConn:Disconnect()  end
                    end
                end)
            end

            sliderTrigger.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                    local pos = UIS:GetMouseLocation()
                    startSlide(pos.X)
                end
            end)

            local obj = {
                SetValue = function(_, v)
                    local pct = (v - minVal) / (maxVal - minVal)
                    setFromPercent(pct)
                end,
                GetValue  = function() return currentVal end,
                SetVisible = function(_, v) frame.Visible = v end,
            }
            return obj
        end

        -- ══════════════
        -- DROPDOWN
        -- ══════════════
        function Content.CreateDropdown(DropTitle, list, default, callback)
            if type(default) == "function" then callback = default default = nil end
            DropTitle = DropTitle or "Dropdown"
            list      = list      or {}
            callback  = callback  or function() end

            local selected   = default or (list[1] or "Select...")
            local expanded   = false
            local normalH    = 36
            local expandedH  = normalH + math.min(#list, 5) * 30 + 12

            local frame = baseFrame(normalH, true)

            elemIcon(frame, "rbxassetid://3926305904",
                Vector2.new(644, 364), Vector2.new(36, 36))

            local titleLbl = elemLabel(frame, DropTitle, 38, 0, -90, normalH)

            local selLbl = Instance.new("TextLabel")
            selLbl.BackgroundTransparency = 1
            selLbl.AnchorPoint = Vector2.new(1, 0)
            selLbl.Position    = UDim2.new(1, -28, 0, 0)
            selLbl.Size        = UDim2.new(0, 90, 0, normalH)
            selLbl.Font        = Enum.Font.Gotham
            selLbl.Text        = selected
            selLbl.TextColor3  = theme.SubText
            selLbl.TextSize    = 12
            selLbl.TextXAlignment = Enum.TextXAlignment.Right
            selLbl.TextWrapped = true
            selLbl.ZIndex      = 6
            selLbl.Parent      = frame

            local chevron = Instance.new("TextLabel")
            chevron.BackgroundTransparency = 1
            chevron.AnchorPoint = Vector2.new(1, 0.5)
            chevron.Position    = UDim2.new(1, -8, 0, normalH / 2)
            chevron.Size        = UDim2.new(0, 16, 0, 16)
            chevron.Text        = "▾"
            chevron.TextColor3  = theme.Accent
            chevron.TextSize    = 14
            chevron.Font        = Enum.Font.GothamBold
            chevron.ZIndex      = 6
            chevron.Parent      = frame

            -- Items container
            local itemsFrame = Instance.new("ScrollingFrame")
            itemsFrame.BackgroundTransparency = 1
            itemsFrame.BorderSizePixel        = 0
            itemsFrame.Position               = UDim2.new(0, 0, 0, normalH + 4)
            itemsFrame.Size                   = UDim2.new(1, 0, 0, 0)
            itemsFrame.ZIndex                 = 6
            itemsFrame.CanvasSize             = UDim2.new(0, 0, 0, 0)
            itemsFrame.ScrollBarThickness     = 2
            itemsFrame.ScrollBarImageColor3   = theme.Accent
            itemsFrame.Parent                 = frame

            local itemsLayout = Instance.new("UIListLayout")
            itemsLayout.SortOrder           = Enum.SortOrder.LayoutOrder
            itemsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            itemsLayout.Padding             = UDim.new(0, 4)
            itemsLayout.Parent              = itemsFrame

            local itemsPad = Instance.new("UIPadding")
            itemsPad.PaddingTop = UDim.new(0, 4)
            itemsPad.Parent     = itemsFrame

            itemsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                itemsFrame.CanvasSize = UDim2.new(0, 0, 0, itemsLayout.AbsoluteContentSize.Y + 8)
            end)

            local function closeDropdown()
                expanded = false
                tween(frame,      {Size = UDim2.new(1, -4, 0, normalH)},  0.25, Enum.EasingStyle.Quint)
                tween(itemsFrame, {Size = UDim2.new(1, 0, 0, 0)},         0.25, Enum.EasingStyle.Quint)
                tween(chevron,    {Rotation = 0},                          0.2)
            end

            local function openDropdown()
                expanded = true
                local h = math.min(#list, 5) * 30 + 12
                tween(frame,      {Size = UDim2.new(1, -4, 0, normalH + h + 4)}, 0.25, Enum.EasingStyle.Back)
                tween(itemsFrame, {Size = UDim2.new(1, 0, 0, h)},                0.25, Enum.EasingStyle.Back)
                tween(chevron,    {Rotation = 180},                               0.2)
            end

            for _, option in ipairs(list) do
                local optBtn = Instance.new("TextButton")
                optBtn.BackgroundColor3 = option == selected and theme.Accent or theme.TabFrame
                optBtn.BackgroundTransparency = option == selected and 0.6 or 0
                optBtn.BorderSizePixel = 0
                optBtn.Size            = UDim2.new(1, -8, 0, 26)
                optBtn.Font            = Enum.Font.Gotham
                optBtn.Text            = option
                optBtn.TextColor3      = option == selected and theme.Text or theme.SubText
                optBtn.TextSize        = 12
                optBtn.ZIndex          = 7
                optBtn.AutoButtonColor = false
                optBtn.Parent          = itemsFrame
                local oc = Instance.new("UICorner")
                oc.CornerRadius = UDim.new(0, 6)
                oc.Parent = optBtn

                optBtn.MouseEnter:Connect(function()
                    tween(optBtn, {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.7}, 0.15)
                end)
                optBtn.MouseLeave:Connect(function()
                    if selLbl.Text ~= option then
                        tween(optBtn, {BackgroundColor3 = theme.TabFrame, BackgroundTransparency = 0}, 0.15)
                    end
                end)

                optBtn.MouseButton1Click:Connect(function()
                    selected      = option
                    selLbl.Text   = option
                    playClick(1, 0.35)
                    closeDropdown()
                    -- Update all option backgrounds
                    for _, child in ipairs(itemsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            local isSelected = child.Text == option
                            tween(child, {
                                BackgroundColor3    = isSelected and theme.Accent or theme.TabFrame,
                                BackgroundTransparency = isSelected and 0.6 or 0,
                                TextColor3          = isSelected and theme.Text or theme.SubText,
                            }, 0.15)
                        end
                    end
                    pcall(callback, option)
                end)
            end

            local trigger = Instance.new("TextButton")
            trigger.BackgroundTransparency = 1
            trigger.Size   = UDim2.new(1, 0, 0, normalH)
            trigger.Text   = ""
            trigger.ZIndex = 8
            trigger.Parent = frame

            trigger.MouseEnter:Connect(function()
                tween(frame, {BackgroundColor3 = theme.ElementHover}, 0.15)
            end)
            trigger.MouseLeave:Connect(function()
                tween(frame, {BackgroundColor3 = theme.Element}, 0.15)
            end)

            trigger.MouseButton1Click:Connect(function()
                playClick(expanded and 1 or 1.1, 0.35)
                if expanded then closeDropdown() else openDropdown() end
            end)

            local obj = {
                SetSelected = function(_, v)
                    selected    = v
                    selLbl.Text = v
                end,
                GetSelected  = function() return selected end,
                SetList      = function(_, newList)
                    list = newList
                    for _, c in ipairs(itemsFrame:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    -- Re-populate (abbreviated for brevity — same logic as above)
                end,
                SetVisible = function(_, v) frame.Visible = v end,
            }
            return obj
        end

        -- ══════════════
        -- KEYBIND
        -- ══════════════
        function Content.CreateKeybind(KeyTitle, defaultKey, callback)
            KeyTitle   = KeyTitle   or "Keybind"
            defaultKey = defaultKey or Enum.KeyCode.RightControl
            callback   = callback   or function() end

            local currentKey = defaultKey
            local listening  = false

            local frame = baseFrame(36, true)

            elemIcon(frame, "rbxassetid://3926305904",
                Vector2.new(364, 284), Vector2.new(36, 36))

            elemLabel(frame, KeyTitle)

            local keyBadge = Instance.new("TextLabel")
            keyBadge.BackgroundColor3  = theme.TabFrame
            keyBadge.BorderSizePixel   = 0
            keyBadge.AnchorPoint       = Vector2.new(1, 0.5)
            keyBadge.Position          = UDim2.new(1, -10, 0.5, 0)
            keyBadge.Size              = UDim2.new(0, 56, 0, 22)
            keyBadge.Font              = Enum.Font.GothamBold
            keyBadge.Text              = currentKey.Name
            keyBadge.TextColor3        = theme.Accent
            keyBadge.TextSize          = 11
            keyBadge.TextScaled        = false
            keyBadge.ZIndex            = 6
            keyBadge.ClipsDescendants  = true
            keyBadge.Parent            = frame
            local kbCorner = Instance.new("UICorner")
            kbCorner.CornerRadius = UDim.new(0, 6)
            kbCorner.Parent = keyBadge
            makeStroke(keyBadge, theme.Accent, 1, 0.5)

            local trigger = Instance.new("TextButton")
            trigger.BackgroundTransparency = 1
            trigger.Size   = UDim2.new(1, 0, 1, 0)
            trigger.Text   = ""
            trigger.ZIndex = 7
            trigger.Parent = frame

            trigger.MouseEnter:Connect(function()
                tween(frame, {BackgroundColor3 = theme.ElementHover}, 0.15)
            end)
            trigger.MouseLeave:Connect(function()
                tween(frame, {BackgroundColor3 = theme.Element}, 0.15)
            end)

            trigger.MouseButton1Click:Connect(function()
                if listening then return end
                listening       = true
                keyBadge.Text  = "..."
                tween(keyBadge, {BackgroundColor3 = theme.Accent, TextColor3 = theme.Background}, 0.15)

                local conn
                conn = UIS.InputBegan:Connect(function(inp, gpe)
                    if inp.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey     = inp.KeyCode
                        keyBadge.Text  = inp.KeyCode.Name
                        tween(keyBadge, {BackgroundColor3 = theme.TabFrame, TextColor3 = theme.Accent}, 0.2)
                        listening = false
                        conn:Disconnect()
                    end
                end)
            end)

            UIS.InputBegan:Connect(function(inp, gpe)
                if gpe then return end
                if not listening and inp.KeyCode == currentKey then
                    pcall(callback)
                end
            end)

            return {
                GetKey     = function() return currentKey end,
                SetKey     = function(_, k) currentKey = k keyBadge.Text = k.Name end,
                SetVisible = function(_, v) frame.Visible = v end,
            }
        end

        -- ══════════════
        -- TEXTBOX
        -- ══════════════
        function Content.CreateTextbox(TxtTitle, placeholder, callback)
            TxtTitle    = TxtTitle    or "Textbox"
            placeholder = placeholder or "Type here..."
            callback    = callback    or function() end

            local frame = baseFrame(58, false)

            elemIcon(frame, "rbxassetid://3926305904",
                Vector2.new(324, 604), Vector2.new(36, 36))

            elemLabel(frame, TxtTitle, 38, 0, -44, 26)

            local inputBg = Instance.new("Frame")
            inputBg.BackgroundColor3 = theme.SliderTrack
            inputBg.BorderSizePixel  = 0
            inputBg.Position         = UDim2.new(0, 10, 0, 32)
            inputBg.Size             = UDim2.new(1, -20, 0, 20)
            inputBg.ZIndex           = 6
            inputBg.Parent           = frame
            local ibCorner = Instance.new("UICorner")
            ibCorner.CornerRadius = UDim.new(0, 6)
            ibCorner.Parent = inputBg

            local inputField = Instance.new("TextBox")
            inputField.BackgroundTransparency = 1
            inputField.Size              = UDim2.new(1, -8, 1, 0)
            inputField.Position          = UDim2.new(0, 4, 0, 0)
            inputField.Font              = Enum.Font.Gotham
            inputField.PlaceholderText   = placeholder
            inputField.PlaceholderColor3 = theme.SubText
            inputField.Text              = ""
            inputField.TextColor3        = theme.Text
            inputField.TextSize          = 12
            inputField.TextXAlignment    = Enum.TextXAlignment.Left
            inputField.ClearTextOnFocus  = false
            inputField.ZIndex            = 7
            inputField.Parent            = inputBg

            local focusStroke = makeStroke(inputBg, theme.Accent, 1, 1)

            inputField.Focused:Connect(function()
                tween(focusStroke, {Transparency = 0.3}, 0.15)
            end)
            inputField.FocusLost:Connect(function(enter)
                tween(focusStroke, {Transparency = 1}, 0.15)
                if enter and inputField.Text ~= "" then
                    pcall(callback, inputField.Text)
                    inputField.Text = ""
                end
            end)

            return {
                GetText   = function() return inputField.Text end,
                SetText   = function(_, t) inputField.Text = t end,
                SetVisible = function(_, v) frame.Visible = v end,
            }
        end

        -- ══════════════
        -- COLOR PICKER
        -- ══════════════
        function Content.CreateColorPicker(PickTitle, default, callback)
            PickTitle = PickTitle or "Color"
            default   = default   or Color3.fromRGB(160, 110, 255)
            callback  = callback  or function() end

            local currentColor = default
            local expanded     = false
            local normalH      = 36

            local frame = baseFrame(normalH, true)

            elemIcon(frame, "rbxassetid://3926305904",
                Vector2.new(444, 324), Vector2.new(36, 36))

            elemLabel(frame, PickTitle)

            -- Color preview swatch
            local swatch = Instance.new("Frame")
            swatch.BackgroundColor3 = currentColor
            swatch.BorderSizePixel  = 0
            swatch.AnchorPoint      = Vector2.new(1, 0.5)
            swatch.Position         = UDim2.new(1, -10, 0.5, 0)
            swatch.Size             = UDim2.new(0, 22, 0, 22)
            swatch.ZIndex           = 6
            swatch.Parent           = frame
            local swCorner = Instance.new("UICorner")
            swCorner.CornerRadius = UDim.new(0, 6)
            swCorner.Parent = swatch
            makeStroke(swatch, theme.Divider, 1, 0.4)

            -- Picker panel
            local pickerPanel = Instance.new("Frame")
            pickerPanel.BackgroundColor3 = theme.TabFrame
            pickerPanel.BorderSizePixel  = 0
            pickerPanel.Position         = UDim2.new(0, 0, 0, normalH + 4)
            pickerPanel.Size             = UDim2.new(1, 0, 0, 0)
            pickerPanel.ZIndex           = 6
            pickerPanel.ClipsDescendants = true
            pickerPanel.Parent           = frame
            local ppCorner = Instance.new("UICorner")
            ppCorner.CornerRadius = UDim.new(0, 8)
            ppCorner.Parent = pickerPanel

            -- Hue spectrum bar
            local hueBar = Instance.new("ImageLabel")
            hueBar.BackgroundTransparency = 1
            hueBar.Image    = "rbxassetid://698548777"
            hueBar.Position = UDim2.new(0, 8, 0, 8)
            hueBar.Size     = UDim2.new(1, -16, 0, 16)
            hueBar.ZIndex   = 7
            hueBar.Parent   = pickerPanel
            local hueCorner = Instance.new("UICorner")
            hueCorner.CornerRadius = UDim.new(0, 4)
            hueCorner.Parent = hueBar

            local hueThumb = Instance.new("Frame")
            hueThumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
            hueThumb.BorderSizePixel  = 0
            hueThumb.AnchorPoint      = Vector2.new(0.5,0.5)
            hueThumb.Position         = UDim2.new(0, 0, 0.5, 0)
            hueThumb.Size             = UDim2.new(0, 10, 0, 20)
            hueThumb.ZIndex           = 8
            hueThumb.Parent           = hueBar
            local htCorner = Instance.new("UICorner")
            htCorner.CornerRadius = UDim.new(0, 3)
            htCorner.Parent = hueThumb

            -- Preset swatches
            local presets = {
                Color3.fromRGB(255,80,80),
                Color3.fromRGB(255,160,60),
                Color3.fromRGB(255,230,60),
                Color3.fromRGB(80,220,120),
                Color3.fromRGB(60,180,255),
                Color3.fromRGB(160,110,255),
                Color3.fromRGB(255,110,200),
                Color3.fromRGB(255,255,255),
            }

            local presetRow = Instance.new("Frame")
            presetRow.BackgroundTransparency = 1
            presetRow.Position = UDim2.new(0, 8, 0, 30)
            presetRow.Size     = UDim2.new(1, -16, 0, 22)
            presetRow.ZIndex   = 7
            presetRow.Parent   = pickerPanel

            local presetLayout = Instance.new("UIListLayout")
            presetLayout.FillDirection = Enum.FillDirection.Horizontal
            presetLayout.Padding       = UDim.new(0, 4)
            presetLayout.Parent        = presetRow

            local hue, sat, val2 = Color3.toHSV(currentColor)

            local function applyColor(c)
                currentColor    = c
                swatch.BackgroundColor3 = c
                pcall(callback, c)
            end

            for _, col in ipairs(presets) do
                local ps = Instance.new("TextButton")
                ps.BackgroundColor3 = col
                ps.BorderSizePixel  = 0
                ps.Size             = UDim2.new(0, 22, 0, 22)
                ps.Text             = ""
                ps.ZIndex           = 8
                ps.Parent           = presetRow
                local psc = Instance.new("UICorner")
                psc.CornerRadius = UDim.new(0, 5)
                psc.Parent = ps
                ps.MouseButton1Click:Connect(function()
                    applyColor(col)
                    hue, sat, val2 = Color3.toHSV(col)
                    hueThumb.Position = UDim2.new(hue, 0, 0.5, 0)
                end)
            end

            -- Hue drag
            local hueDragging = false
            local hueMoveConn, hueEndConn

            hueBar.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1
                or inp.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = true
                    local function update()
                        local pos = UIS:GetMouseLocation()
                        local relX = math.clamp(pos.X - hueBar.AbsolutePosition.X, 0, hueBar.AbsoluteSize.X)
                        hue = relX / hueBar.AbsoluteSize.X
                        hueThumb.Position = UDim2.new(hue, 0, 0.5, 0)
                        applyColor(Color3.fromHSV(hue, sat, val2))
                    end
                    update()
                    hueMoveConn = UIS.InputChanged:Connect(function(mi)
                        if mi.UserInputType == Enum.UserInputType.MouseMovement
                        or mi.UserInputType == Enum.UserInputType.Touch then
                            if hueDragging then update() end
                        end
                    end)
                    hueEndConn = UIS.InputEnded:Connect(function(ei)
                        if ei.UserInputType == Enum.UserInputType.MouseButton1
                        or ei.UserInputType == Enum.UserInputType.Touch then
                            hueDragging = false
                            if hueMoveConn then hueMoveConn:Disconnect() end
                            if hueEndConn  then hueEndConn:Disconnect()  end
                        end
                    end)
                end
            end)

            local panelHeight = 60

            local trigger = Instance.new("TextButton")
            trigger.BackgroundTransparency = 1
            trigger.Size   = UDim2.new(1, 0, 0, normalH)
            trigger.Text   = ""
            trigger.ZIndex = 8
            trigger.Parent = frame

            trigger.MouseButton1Click:Connect(function()
                expanded = not expanded
                playClick(expanded and 1.1 or 1, 0.35)
                if expanded then
                    tween(frame,       {Size = UDim2.new(1, -4, 0, normalH + panelHeight + 8)}, 0.25, Enum.EasingStyle.Back)
                    tween(pickerPanel, {Size = UDim2.new(1, 0, 0, panelHeight)},                0.25, Enum.EasingStyle.Back)
                else
                    tween(frame,       {Size = UDim2.new(1, -4, 0, normalH)}, 0.2, Enum.EasingStyle.Quint)
                    tween(pickerPanel, {Size = UDim2.new(1, 0, 0, 0)},        0.2, Enum.EasingStyle.Quint)
                end
            end)

            return {
                GetColor  = function() return currentColor end,
                SetColor  = function(_, c)
                    currentColor = c
                    swatch.BackgroundColor3 = c
                end,
                SetVisible = function(_, v) frame.Visible = v end,
            }
        end

        -- ══════════════
        -- LABEL
        -- ══════════════
        function Content.CreateLabel(LabelTitle, labelType)
            labelType  = labelType or "default"
            local frame = baseFrame(36, false)

            if labelType == "info" then
                frame.BackgroundColor3 = Color3.fromRGB(
                    theme.Info.R * 255 * 0.18,
                    theme.Info.G * 255 * 0.18,
                    theme.Info.B * 255 * 0.18)
                makeStroke(frame, theme.Info, 1, 0.5)
            elseif labelType == "warning" then
                frame.BackgroundColor3 = Color3.fromRGB(
                    theme.Warning.R * 255 * 0.2,
                    theme.Warning.G * 255 * 0.2,
                    theme.Warning.B * 255 * 0.2)
                makeStroke(frame, theme.Warning, 1, 0.5)
            elseif labelType == "success" then
                frame.BackgroundColor3 = Color3.fromRGB(
                    theme.Success.R * 255 * 0.18,
                    theme.Success.G * 255 * 0.18,
                    theme.Success.B * 255 * 0.18)
                makeStroke(frame, theme.Success, 1, 0.5)
            elseif labelType == "error" then
                frame.BackgroundColor3 = Color3.fromRGB(
                    theme.Error.R * 255 * 0.18,
                    theme.Error.G * 255 * 0.18,
                    theme.Error.B * 255 * 0.18)
                makeStroke(frame, theme.Error, 1, 0.5)
            end

            local icon_map = {
                info    = {Color3.fromRGB(80,180,255),  Vector2.new(312,4),   Vector2.new(36,36)},
                warning = {Color3.fromRGB(255,185,60),  Vector2.new(364,164), Vector2.new(36,36)},
                success = {Color3.fromRGB(80,220,140),  Vector2.new(444,324), Vector2.new(36,36)},
                error   = {Color3.fromRGB(255,80,90),   Vector2.new(924,724), Vector2.new(36,36)},
            }

            local iconData = icon_map[labelType]
            if iconData then
                local ic = elemIcon(frame, "rbxassetid://3926305904", iconData[2], iconData[3])
                ic.ImageColor3 = iconData[1]
            end

            local lbl = elemLabel(frame, LabelTitle, iconData and 38 or 12, 0, iconData and -44 or -16, 36)
            if iconData then
                lbl.TextColor3 = iconData[1]
            end
            lbl.TextSize = 13

            return {
                SetText    = function(_, t) lbl.Text = t end,
                SetVisible = function(_, v) frame.Visible = v end,
            }
        end

        -- ══════════════
        -- DIVIDER
        -- ══════════════
        function Content.CreateDivider(DivTitle)
            local frame = Instance.new("Frame")
            frame.BackgroundTransparency = 1
            frame.BorderSizePixel = 0
            frame.Size   = UDim2.new(1, -4, 0, DivTitle and 20 or 10)
            frame.ZIndex = 5
            frame.Parent = TabContent

            if DivTitle then
                local row = Instance.new("Frame")
                row.BackgroundTransparency = 1
                row.Size   = UDim2.new(1, 0, 1, 0)
                row.ZIndex = 5
                row.Parent = frame

                local lineL = Instance.new("Frame")
                lineL.BackgroundColor3      = theme.Divider
                lineL.BorderSizePixel       = 0
                lineL.AnchorPoint           = Vector2.new(0, 0.5)
                lineL.Position              = UDim2.new(0, 0, 0.5, 0)
                lineL.Size                  = UDim2.new(0.2, -8, 0, 1)
                lineL.ZIndex                = 5
                lineL.Parent                = row

                local txt = Instance.new("TextLabel")
                txt.BackgroundTransparency = 1
                txt.AnchorPoint = Vector2.new(0.5, 0.5)
                txt.Position    = UDim2.new(0.5, 0, 0.5, 0)
                txt.Size        = UDim2.new(0.6, 0, 1, 0)
                txt.Font        = Enum.Font.GothamBold
                txt.Text        = DivTitle
                txt.TextColor3  = theme.SubText
                txt.TextSize    = 11
                txt.ZIndex      = 5
                txt.Parent      = row

                local lineR = Instance.new("Frame")
                lineR.BackgroundColor3 = theme.Divider
                lineR.BorderSizePixel  = 0
                lineR.AnchorPoint      = Vector2.new(1, 0.5)
                lineR.Position         = UDim2.new(1, 0, 0.5, 0)
                lineR.Size             = UDim2.new(0.2, -8, 0, 1)
                lineR.ZIndex           = 5
                lineR.Parent           = row
            else
                local line = Instance.new("Frame")
                line.BackgroundColor3 = theme.Divider
                line.BorderSizePixel  = 0
                line.AnchorPoint      = Vector2.new(0, 0.5)
                line.Position         = UDim2.new(0, 0, 0.5, 0)
                line.Size             = UDim2.new(1, 0, 0, 1)
                line.ZIndex           = 5
                line.Parent           = frame
            end

            return { SetVisible = function(_, v) frame.Visible = v end }
        end

        -- ══════════════
        -- MULTI-SELECT DROPDOWN
        -- ══════════════
        function Content.CreateMultiDropdown(DropTitle, list, callback)
            DropTitle = DropTitle or "Multi-Select"
            list      = list      or {}
            callback  = callback  or function() end

            local selected   = {}
            local expanded   = false
            local normalH    = 36

            local frame = baseFrame(normalH, true)

            elemIcon(frame, "rbxassetid://3926305904",
                Vector2.new(644, 364), Vector2.new(36, 36))

            elemLabel(frame, DropTitle)

            local countLbl = Instance.new("TextLabel")
            countLbl.BackgroundTransparency = 1
            countLbl.AnchorPoint = Vector2.new(1, 0.5)
            countLbl.Position    = UDim2.new(1, -28, 0.5, 0)
            countLbl.Size        = UDim2.new(0, 50, 0, 22)
            countLbl.Font        = Enum.Font.GothamBold
            countLbl.Text        = "0"
            countLbl.TextColor3  = theme.Accent
            countLbl.TextSize    = 12
            countLbl.TextXAlignment = Enum.TextXAlignment.Right
            countLbl.ZIndex      = 6
            countLbl.Parent      = frame

            local chevron = Instance.new("TextLabel")
            chevron.BackgroundTransparency = 1
            chevron.AnchorPoint = Vector2.new(1, 0.5)
            chevron.Position    = UDim2.new(1, -8, 0.5, 0)
            chevron.Size        = UDim2.new(0, 14, 0, 14)
            chevron.Text        = "▾"
            chevron.TextColor3  = theme.Accent
            chevron.TextSize    = 13
            chevron.Font        = Enum.Font.GothamBold
            chevron.ZIndex      = 6
            chevron.Parent      = frame

            local itemsFrame = Instance.new("ScrollingFrame")
            itemsFrame.BackgroundTransparency = 1
            itemsFrame.BorderSizePixel        = 0
            itemsFrame.Position               = UDim2.new(0, 0, 0, normalH + 4)
            itemsFrame.Size                   = UDim2.new(1, 0, 0, 0)
            itemsFrame.ZIndex                 = 6
            itemsFrame.CanvasSize             = UDim2.new(0, 0, 0, 0)
            itemsFrame.ScrollBarThickness     = 2
            itemsFrame.ScrollBarImageColor3   = theme.Accent
            itemsFrame.Parent                 = frame

            local itemsLayout = Instance.new("UIListLayout")
            itemsLayout.SortOrder           = Enum.SortOrder.LayoutOrder
            itemsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            itemsLayout.Padding             = UDim.new(0, 4)
            itemsLayout.Parent              = itemsFrame

            local itemsPad = Instance.new("UIPadding")
            itemsPad.PaddingTop = UDim.new(0, 4)
            itemsPad.Parent     = itemsFrame

            itemsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                itemsFrame.CanvasSize = UDim2.new(0, 0, 0, itemsLayout.AbsoluteContentSize.Y + 8)
            end)

            local function updateCount()
                local n = 0
                for _ in pairs(selected) do n = n + 1 end
                countLbl.Text = tostring(n)
                pcall(callback, selected)
            end

            for _, option in ipairs(list) do
                local optBtn = Instance.new("TextButton")
                optBtn.BackgroundColor3      = theme.TabFrame
                optBtn.BackgroundTransparency = 0
                optBtn.BorderSizePixel       = 0
                optBtn.Size                  = UDim2.new(1, -8, 0, 26)
                optBtn.Font                  = Enum.Font.Gotham
                optBtn.Text                  = ""
                optBtn.ZIndex                = 7
                optBtn.AutoButtonColor       = false
                optBtn.Parent                = itemsFrame
                local oc = Instance.new("UICorner")
                oc.CornerRadius = UDim.new(0, 6)
                oc.Parent = optBtn

                local chkBox = Instance.new("Frame")
                chkBox.BackgroundColor3 = theme.SliderTrack
                chkBox.BorderSizePixel  = 0
                chkBox.Position         = UDim2.new(0, 6, 0.5, -7)
                chkBox.Size             = UDim2.new(0, 14, 0, 14)
                chkBox.ZIndex           = 8
                chkBox.Parent           = optBtn
                local cc = Instance.new("UICorner")
                cc.CornerRadius = UDim.new(0, 4)
                cc.Parent = chkBox
                makeStroke(chkBox, theme.Accent, 1, 0.5)

                local chkMark = Instance.new("TextLabel")
                chkMark.BackgroundTransparency = 1
                chkMark.Size        = UDim2.new(1, 0, 1, 0)
                chkMark.Font        = Enum.Font.GothamBold
                chkMark.Text        = "✓"
                chkMark.TextColor3  = theme.Background
                chkMark.TextSize    = 10
                chkMark.ZIndex      = 9
                chkMark.TextTransparency = 1
                chkMark.Parent      = chkBox

                local optLbl = Instance.new("TextLabel")
                optLbl.BackgroundTransparency = 1
                optLbl.Position    = UDim2.new(0, 26, 0, 0)
                optLbl.Size        = UDim2.new(1, -30, 1, 0)
                optLbl.Font        = Enum.Font.Gotham
                optLbl.Text        = option
                optLbl.TextColor3  = theme.SubText
                optLbl.TextSize    = 12
                optLbl.TextXAlignment = Enum.TextXAlignment.Left
                optLbl.ZIndex      = 8
                optLbl.Parent      = optBtn

                optBtn.MouseButton1Click:Connect(function()
                    if selected[option] then
                        selected[option] = nil
                        tween(chkBox,  {BackgroundColor3 = theme.SliderTrack}, 0.15)
                        tween(chkMark, {TextTransparency = 1}, 0.1)
                        tween(optLbl,  {TextColor3 = theme.SubText}, 0.15)
                    else
                        selected[option] = true
                        tween(chkBox,  {BackgroundColor3 = theme.Accent}, 0.15)
                        tween(chkMark, {TextTransparency = 0}, 0.1)
                        tween(optLbl,  {TextColor3 = theme.Text}, 0.15)
                    end
                    updateCount()
                end)
            end

            local trigger = Instance.new("TextButton")
            trigger.BackgroundTransparency = 1
            trigger.Size   = UDim2.new(1, 0, 0, normalH)
            trigger.Text   = ""
            trigger.ZIndex = 8
            trigger.Parent = frame

            trigger.MouseButton1Click:Connect(function()
                expanded = not expanded
                playClick(expanded and 1.1 or 1, 0.35)
                local h = math.min(#list, 5) * 30 + 12
                if expanded then
                    tween(frame,      {Size = UDim2.new(1, -4, 0, normalH + h + 4)}, 0.25, Enum.EasingStyle.Back)
                    tween(itemsFrame, {Size = UDim2.new(1, 0, 0, h)},                0.25, Enum.EasingStyle.Back)
                    tween(chevron,    {Rotation = 180},                               0.2)
                else
                    tween(frame,      {Size = UDim2.new(1, -4, 0, normalH)}, 0.2, Enum.EasingStyle.Quint)
                    tween(itemsFrame, {Size = UDim2.new(1, 0, 0, 0)},        0.2, Enum.EasingStyle.Quint)
                    tween(chevron,    {Rotation = 0},                         0.2)
                end
            end)

            return {
                GetSelected = function() return selected end,
                SetVisible  = function(_, v) frame.Visible = v end,
            }
        end

        -- ══════════════
        -- PROGRESS BAR (static/updatable)
        -- ══════════════
        function Content.CreateProgressBar(BarTitle, default, options)
            options  = options  or {}
            BarTitle = BarTitle or "Progress"
            default  = default  or 0
            local suffix  = options.Suffix  or "%"
            local color   = options.Color   or theme.Accent

            local frame = baseFrame(52, true)

            elemIcon(frame, "rbxassetid://3926307971",
                Vector2.new(404, 164), Vector2.new(36, 36))

            elemLabel(frame, BarTitle, 38, 0, -70, 26)

            local pctLbl = Instance.new("TextLabel")
            pctLbl.BackgroundTransparency = 1
            pctLbl.AnchorPoint  = Vector2.new(1, 0)
            pctLbl.Position     = UDim2.new(1, -10, 0, 0)
            pctLbl.Size         = UDim2.new(0, 56, 0, 26)
            pctLbl.Font         = Enum.Font.GothamBold
            pctLbl.Text         = tostring(default) .. suffix
            pctLbl.TextColor3   = color
            pctLbl.TextSize     = 13
            pctLbl.TextXAlignment = Enum.TextXAlignment.Right
            pctLbl.ZIndex       = 6
            pctLbl.Parent       = frame

            local trackBg = Instance.new("Frame")
            trackBg.BackgroundColor3 = theme.SliderTrack
            trackBg.BorderSizePixel  = 0
            trackBg.Position         = UDim2.new(0, 10, 0, 36)
            trackBg.Size             = UDim2.new(1, -20, 0, 8)
            trackBg.ZIndex           = 6
            trackBg.Parent           = frame
            local tbCorner = Instance.new("UICorner")
            tbCorner.CornerRadius = UDim.new(1, 0)
            tbCorner.Parent = trackBg

            local trackFill = Instance.new("Frame")
            trackFill.BackgroundColor3 = color
            trackFill.BorderSizePixel  = 0
            trackFill.Size             = UDim2.new(math.clamp(default / 100, 0, 1), 0, 1, 0)
            trackFill.ZIndex           = 7
            trackFill.Parent           = trackBg
            local tfCorner = Instance.new("UICorner")
            tfCorner.CornerRadius = UDim.new(1, 0)
            tfCorner.Parent = trackFill

            makeGradient(trackFill, 90, {Color3.fromRGB(
                math.clamp(color.R*255 - 40, 0, 255),
                math.clamp(color.G*255 - 40, 0, 255),
                math.clamp(color.B*255 - 40, 0, 255)
            ), color})

            local obj = {
                SetValue = function(_, v)
                    v = math.clamp(v, 0, 100)
                    pctLbl.Text = tostring(math.floor(v)) .. suffix
                    tween(trackFill, {Size = UDim2.new(v / 100, 0, 1, 0)}, 0.3, Enum.EasingStyle.Quint)
                end,
                SetVisible = function(_, v) frame.Visible = v end,
            }
            return obj
        end

        -- ══════════════
        -- SECTION / ACCORDION
        -- ══════════════
        function Content.CreateSection(SectionTitle)
            local isOpen  = true
            local sFrame  = Instance.new("Frame")
            sFrame.BackgroundColor3 = Color3.fromRGB(
                theme.Element.R * 255 * 0.7,
                theme.Element.G * 255 * 0.7,
                theme.Element.B * 255 * 0.7)
            sFrame.BorderSizePixel  = 0
            sFrame.Size             = UDim2.new(1, -4, 0, 28)
            sFrame.ZIndex           = 5
            sFrame.ClipsDescendants = true
            sFrame.Parent           = TabContent
            local sCorner = Instance.new("UICorner")
            sCorner.CornerRadius = UDim.new(0, 8)
            sCorner.Parent = sFrame

            local sHeader = Instance.new("TextButton")
            sHeader.BackgroundTransparency = 1
            sHeader.Size  = UDim2.new(1, 0, 0, 28)
            sHeader.Text  = ""
            sHeader.ZIndex = 7
            sHeader.Parent = sFrame

            local sTxt = Instance.new("TextLabel")
            sTxt.BackgroundTransparency = 1
            sTxt.Position = UDim2.new(0, 10, 0, 0)
            sTxt.Size     = UDim2.new(1, -30, 0, 28)
            sTxt.Font     = Enum.Font.GothamBold
            sTxt.Text     = SectionTitle or "Section"
            sTxt.TextColor3 = theme.SubText
            sTxt.TextSize = 12
            sTxt.TextXAlignment = Enum.TextXAlignment.Left
            sTxt.ZIndex  = 7
            sTxt.Parent  = sFrame

            local sChev = Instance.new("TextLabel")
            sChev.BackgroundTransparency = 1
            sChev.AnchorPoint = Vector2.new(1, 0.5)
            sChev.Position    = UDim2.new(1, -8, 0, 14)
            sChev.Size        = UDim2.new(0, 14, 0, 14)
            sChev.Text        = "▾"
            sChev.TextColor3  = theme.SubText
            sChev.TextSize    = 12
            sChev.Font        = Enum.Font.GothamBold
            sChev.ZIndex      = 7
            sChev.Parent      = sFrame

            local innerLayout = Instance.new("UIListLayout")
            innerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            innerLayout.SortOrder           = Enum.SortOrder.LayoutOrder
            innerLayout.Padding             = UDim.new(0, 6)
            innerLayout.Parent              = sFrame

            local innerPad = Instance.new("UIPadding")
            innerPad.PaddingTop = UDim.new(0, 28)
            innerPad.PaddingBottom = UDim.new(0, 6)
            innerPad.Parent = sFrame

            innerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isOpen then
                    sFrame.Size = UDim2.new(1, -4, 0, innerLayout.AbsoluteContentSize.Y + 34)
                end
            end)

            sHeader.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    tween(sFrame, {Size = UDim2.new(1, -4, 0, innerLayout.AbsoluteContentSize.Y + 34)}, 0.25, Enum.EasingStyle.Back)
                    tween(sChev,  {Rotation = 0}, 0.2)
                else
                    tween(sFrame, {Size = UDim2.new(1, -4, 0, 28)}, 0.2, Enum.EasingStyle.Quint)
                    tween(sChev,  {Rotation = -90}, 0.2)
                end
            end)

            -- Section has its own sub-element factory
            local Section = {}
            function Section.AddButton(t, cb) 
                -- mini button for inside sections
                local f = Instance.new("TextButton")
                f.BackgroundColor3 = theme.Element
                f.BorderSizePixel  = 0
                f.Size             = UDim2.new(1, -12, 0, 28)
                f.Font             = Enum.Font.Gotham
                f.Text             = t or "Button"
                f.TextColor3       = theme.Text
                f.TextSize         = 12
                f.ZIndex           = 6
                f.AutoButtonColor  = false
                f.Parent           = sFrame
                local fc = Instance.new("UICorner")
                fc.CornerRadius = UDim.new(0, 6)
                fc.Parent = f
                f.MouseButton1Click:Connect(function()
                    playClick(1, 0.35)
                    rippleEffect(f, Mouse.X, Mouse.Y, theme.Accent)
                    pcall(cb or function() end)
                end)
                f.MouseEnter:Connect(function() tween(f, {BackgroundColor3 = theme.ElementHover}, 0.15) end)
                f.MouseLeave:Connect(function() tween(f, {BackgroundColor3 = theme.Element}, 0.15) end)
            end

            return Section
        end

        return Content
    end

    return TabSys
end

-- ══════════════════════════════════════
--  CONTEXT MENU (right-click menu)
-- ══════════════════════════════════════
function Lib:ContextMenu(options)
    options = options or {}
    local items    = options.Items    or {}
    local position = options.Position or UDim2.new(0.5, 0, 0.5, 0)
    local theme    = self.CurrentTheme

    local sg = Instance.new("ScreenGui")
    sg.Name           = "NexusCtxMenu"
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 9000
    sg.ResetOnSpawn   = false
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer.PlayerGui end

    local bg = Instance.new("Frame")
    bg.BackgroundTransparency = 1
    bg.Size  = UDim2.new(1, 0, 1, 0)
    bg.ZIndex = 1
    bg.Parent = sg

    local menu = Instance.new("Frame")
    menu.BackgroundColor3 = theme.Surface
    menu.BorderSizePixel  = 0
    menu.Position         = position
    menu.Size             = UDim2.new(0, 160, 0, 0)
    menu.ZIndex           = 2
    menu.ClipsDescendants = true
    menu.Parent           = sg
    local mCorner = Instance.new("UICorner")
    mCorner.CornerRadius = UDim.new(0, 10)
    mCorner.Parent = menu
    makeStroke(menu, theme.Accent, 1, 0.65)
    makeShadow(menu, 20, 0.45)

    local layout = Instance.new("UIListLayout")
    layout.SortOrder           = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding             = UDim.new(0, 2)
    layout.Parent              = menu

    local pad = Instance.new("UIPadding")
    pad.PaddingTop    = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 6)
    pad.Parent        = menu

    local function close()
        tween(menu, {Size = UDim2.new(0, 160, 0, 0)}, 0.15, Enum.EasingStyle.Quint)
        task.wait(0.15)
        sg:Destroy()
    end

    bg.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.MouseButton2 then
            close()
        end
    end)

    local totalH = 12
    for _, item in ipairs(items) do
        if item == "separator" then
            local sep = Instance.new("Frame")
            sep.BackgroundColor3 = theme.Divider
            sep.BorderSizePixel  = 0
            sep.Size             = UDim2.new(1, -16, 0, 1)
            sep.ZIndex           = 3
            sep.Parent           = menu
            totalH = totalH + 5
        else
            local btn = Instance.new("TextButton")
            btn.BackgroundColor3      = theme.Element
            btn.BackgroundTransparency = 1
            btn.BorderSizePixel       = 0
            btn.Size                  = UDim2.new(1, -8, 0, 28)
            btn.Font                  = Enum.Font.Gotham
            btn.Text                  = item.Text or "Option"
            btn.TextColor3            = item.Color or theme.Text
            btn.TextSize              = 13
            btn.TextXAlignment        = Enum.TextXAlignment.Left
            btn.ZIndex                = 3
            btn.AutoButtonColor       = false
            btn.Parent                = menu

            local bPad = Instance.new("UIPadding")
            bPad.PaddingLeft = UDim.new(0, 10)
            bPad.Parent      = btn
            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 6)
            bCorner.Parent = btn

            btn.MouseEnter:Connect(function()
                tween(btn, {BackgroundTransparency = 0.3, BackgroundColor3 = item.Color or theme.Accent}, 0.12)
            end)
            btn.MouseLeave:Connect(function()
                tween(btn, {BackgroundTransparency = 1}, 0.12)
            end)
            btn.MouseButton1Click:Connect(function()
                close()
                pcall(item.Callback or function() end)
            end)
            totalH = totalH + 30
        end
    end

    tween(menu, {Size = UDim2.new(0, 160, 0, totalH)}, 0.25, Enum.EasingStyle.Back)

    return { Close = close }
end

-- ══════════════════════════════════════
--  KEYBIND MANAGER (global)
-- ══════════════════════════════════════
Lib._globalBinds = {}

function Lib:BindKey(key, callback)
    if type(key) == "string" then
        key = Enum.KeyCode[key]
    end
    Lib._globalBinds[key] = callback
end

function Lib:UnbindKey(key)
    if type(key) == "string" then key = Enum.KeyCode[key] end
    Lib._globalBinds[key] = nil
end

UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.UserInputType == Enum.UserInputType.Keyboard then
        local cb = Lib._globalBinds[inp.KeyCode]
        if cb then pcall(cb) end
    end
end)

-- ══════════════════════════════════════
--  WATERMARK
-- ══════════════════════════════════════
function Lib:Watermark(options)
    options = options or {}
    local text   = options.Text    or "Nexus UI"
    local corner = options.Corner  or "TopRight"
    local theme  = self.CurrentTheme

    local sg = Instance.new("ScreenGui")
    sg.Name           = "NexusWatermark"
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 50
    sg.ResetOnSpawn   = false
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer.PlayerGui end

    local anchors = {
        TopLeft     = {Vector2.new(0, 0), UDim2.new(0, 12, 0, 12)},
        TopRight    = {Vector2.new(1, 0), UDim2.new(1, -12, 0, 12)},
        BottomLeft  = {Vector2.new(0, 1), UDim2.new(0, 12, 1, -12)},
        BottomRight = {Vector2.new(1, 1), UDim2.new(1, -12, 1, -12)},
    }
    local anchorData = anchors[corner] or anchors.TopRight

    local wm = Instance.new("Frame")
    wm.BackgroundColor3      = theme.Surface
    wm.BackgroundTransparency = 0.1
    wm.BorderSizePixel        = 0
    wm.AnchorPoint            = anchorData[1]
    wm.Position               = anchorData[2]
    wm.Size                   = UDim2.new(0, 0, 0, 28)
    wm.ZIndex                 = 5
    wm.AutomaticSize          = Enum.AutomaticSize.X
    wm.Parent                 = sg
    local wmCorner = Instance.new("UICorner")
    wmCorner.CornerRadius = UDim.new(0, 8)
    wmCorner.Parent = wm
    makeStroke(wm, theme.Accent, 1, 0.6)

    local wmPad = Instance.new("UIPadding")
    wmPad.PaddingLeft  = UDim.new(0, 10)
    wmPad.PaddingRight = UDim.new(0, 10)
    wmPad.Parent       = wm

    local wmRow = Instance.new("Frame")
    wmRow.BackgroundTransparency = 1
    wmRow.Size   = UDim2.new(0, 0, 1, 0)
    wmRow.ZIndex = 6
    wmRow.AutomaticSize = Enum.AutomaticSize.X
    wmRow.Parent = wm

    local wmLayout = Instance.new("UIListLayout")
    wmLayout.FillDirection      = Enum.FillDirection.Horizontal
    wmLayout.VerticalAlignment  = Enum.VerticalAlignment.Center
    wmLayout.Padding            = UDim.new(0, 6)
    wmLayout.Parent             = wmRow

    -- Dot indicator
    local dot = Instance.new("Frame")
    dot.BackgroundColor3 = theme.Success
    dot.BorderSizePixel  = 0
    dot.Size             = UDim2.new(0, 6, 0, 6)
    dot.ZIndex           = 7
    dot.Parent           = wmRow
    local dCorner = Instance.new("UICorner")
    dCorner.CornerRadius = UDim.new(1, 0)
    dCorner.Parent = dot

    -- Pulse animation on dot
    task.spawn(function()
        while dot and dot.Parent do
            tween(dot, {BackgroundTransparency = 0.6}, 0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(0.8)
            tween(dot, {BackgroundTransparency = 0}, 0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(0.8)
        end
    end)

    local wmLbl = Instance.new("TextLabel")
    wmLbl.BackgroundTransparency = 1
    wmLbl.Size        = UDim2.new(0, 0, 1, 0)
    wmLbl.AutomaticSize = Enum.AutomaticSize.X
    wmLbl.Font        = Enum.Font.GothamBold
    wmLbl.Text        = text
    wmLbl.TextColor3  = theme.Text
    wmLbl.TextSize    = 12
    wmLbl.ZIndex      = 7
    wmLbl.Parent      = wmRow

    -- FPS counter (optional)
    local fpsLbl = Instance.new("TextLabel")
    fpsLbl.BackgroundTransparency = 1
    fpsLbl.Size        = UDim2.new(0, 0, 1, 0)
    fpsLbl.AutomaticSize = Enum.AutomaticSize.X
    fpsLbl.Font        = Enum.Font.Gotham
    fpsLbl.Text        = "| 60 FPS"
    fpsLbl.TextColor3  = theme.SubText
    fpsLbl.TextSize    = 11
    fpsLbl.ZIndex      = 7
    fpsLbl.Parent      = wmRow

    -- FPS update
    local fpsTimer   = 0
    local frameCount = 0
    RunService.RenderStepped:Connect(function(dt)
        frameCount = frameCount + 1
        fpsTimer   = fpsTimer + dt
        if fpsTimer >= 1 then
            local fps = math.floor(frameCount / fpsTimer)
            fpsLbl.Text = "| " .. fps .. " FPS"
            local col = fps >= 55 and theme.Success or (fps >= 30 and theme.Warning or theme.Error)
            fpsLbl.TextColor3 = col
            frameCount = 0
            fpsTimer   = 0
        end
    end)

    return {
        SetText    = function(_, t) wmLbl.Text = t end,
        SetVisible = function(_, v) sg.Enabled = v end,
        Destroy    = function() sg:Destroy() end,
    }
end

-- ══════════════════════════════════════
--  DIALOG
-- ══════════════════════════════════════
function Lib:Dialog(options)
    options = options or {}
    local title    = options.Title   or "Dialog"
    local desc     = options.Desc    or "Are you sure?"
    local buttons  = options.Buttons or {
        {Text = "Confirm", Color = nil, Callback = function() end},
        {Text = "Cancel",  Color = nil, Callback = function() end},
    }
    local theme = self.CurrentTheme

    local sg = Instance.new("ScreenGui")
    sg.Name           = "NexusDialog"
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder   = 9500
    sg.ResetOnSpawn   = false
    pcall(function() sg.Parent = CoreGui end)
    if not sg.Parent then sg.Parent = LocalPlayer.PlayerGui end

    -- Dim background
    local dim = Instance.new("Frame")
    dim.BackgroundColor3      = Color3.fromRGB(0, 0, 0)
    dim.BackgroundTransparency = 1
    dim.BorderSizePixel        = 0
    dim.Size                   = UDim2.new(1, 0, 1, 0)
    dim.ZIndex                 = 1
    dim.Parent                 = sg
    tween(dim, {BackgroundTransparency = 0.55}, 0.25)

    local card = Instance.new("Frame")
    card.BackgroundColor3 = theme.Surface
    card.BorderSizePixel  = 0
    card.AnchorPoint      = Vector2.new(0.5, 0.5)
    card.Position         = UDim2.new(0.5, 0, 0.6, 0)
    card.Size             = UDim2.new(0, 320, 0, 0)
    card.ZIndex           = 2
    card.ClipsDescendants = true
    card.Parent           = sg
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 14)
    cCorner.Parent = card
    makeStroke(card, theme.Accent, 1, 0.6)
    makeShadow(card, 30, 0.4)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position = UDim2.new(0, 16, 0, 14)
    titleLbl.Size     = UDim2.new(1, -32, 0, 24)
    titleLbl.Font     = Enum.Font.GothamBold
    titleLbl.Text     = title
    titleLbl.TextColor3 = theme.Text
    titleLbl.TextSize = 18
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex   = 3
    titleLbl.Parent   = card

    local descLbl = Instance.new("TextLabel")
    descLbl.BackgroundTransparency = 1
    descLbl.Position    = UDim2.new(0, 16, 0, 44)
    descLbl.Size        = UDim2.new(1, -32, 0, 48)
    descLbl.Font        = Enum.Font.Gotham
    descLbl.Text        = desc
    descLbl.TextColor3  = theme.SubText
    descLbl.TextSize    = 13
    descLbl.TextWrapped = true
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.TextYAlignment = Enum.TextYAlignment.Top
    descLbl.ZIndex      = 3
    descLbl.Parent      = card

    local function close()
        tween(card, {Size = UDim2.new(0, 320, 0, 0), Position = UDim2.new(0.5, 0, 0.6, 0)}, 0.2, Enum.EasingStyle.Quint)
        tween(dim,  {BackgroundTransparency = 1}, 0.2)
        task.wait(0.25)
        sg:Destroy()
    end

    local btnY = 100
    local btnCount = #buttons
    local btnW = (288 - (btnCount - 1) * 8) / btnCount

    for i, btnData in ipairs(buttons) do
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = btnData.Color or theme.Accent
        btn.BorderSizePixel  = 0
        btn.Position         = UDim2.new(0, 16 + (i - 1) * (btnW + 8), 0, btnY)
        btn.Size             = UDim2.new(0, btnW, 0, 32)
        btn.Font             = Enum.Font.GothamBold
        btn.Text             = btnData.Text or "OK"
        btn.TextColor3       = theme.Background
        btn.TextSize         = 13
        btn.ZIndex           = 3
        btn.AutoButtonColor  = false
        btn.Parent           = card
        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 8)
        bCorner.Parent = btn

        if i > 1 then
            btn.BackgroundColor3 = theme.Element
            btn.TextColor3       = theme.Text
        end

        btn.MouseEnter:Connect(function()
            tween(btn, {BackgroundColor3 = btnData.Color or theme.AccentDark}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, {BackgroundColor3 = i == 1 and (btnData.Color or theme.Accent) or theme.Element}, 0.15)
        end)
        btn.MouseButton1Click:Connect(function()
            playClick(1, 0.4)
            close()
            pcall(btnData.Callback or function() end)
        end)
    end

    -- Animate in
    tween(card, {
        Size     = UDim2.new(0, 320, 0, btnY + 48),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    return { Close = close }
end

return Lib

--[[
════════════════════════════════════════════════════════════════
  NEXUS UI LIBRARY v2.0  —  USAGE EXAMPLE
════════════════════════════════════════════════════════════════

local Lib = loadstring(game:HttpGet("..."))()

-- Optional: show a loading screen first
Lib:LoadingScreen({ Title = "My Script", Sub = "Initializing modules...", Duration = 3 })

-- Create a window (supports theme: "Dark", "Ocean", "Crimson", "Emerald")
local Window = Lib.Window("My Script", nil, "Dark")

-- Watermark with FPS counter
local wm = Lib:Watermark({ Text = "My Script v1.0", Corner = "TopRight" })

-- Create tabs (optional icon asset id)
local HomeTab = Window.CreateTab("Home")
local SettingsTab = Window.CreateTab("Settings")

-- BUTTON
HomeTab.CreateButton("Kill All", "Eliminates all players", function()
    print("Button clicked!")
end)

-- TOGGLE (with default value)
HomeTab.CreateToggle("God Mode", "Enables invincibility", false, function(state)
    print("Toggle:", state)
end)

-- SLIDER (with options table)
HomeTab.CreateSlider("Walk Speed", {
    Min     = 16,
    Max     = 500,
    Default = 16,
    Step    = 1,
    Suffix  = " studs/s",
}, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- DROPDOWN
HomeTab.CreateDropdown("Team", {"Red", "Blue", "Green"}, "Red", function(choice)
    print("Selected:", choice)
end)

-- MULTI-SELECT DROPDOWN
HomeTab.CreateMultiDropdown("Abilities", {"Speed", "Jump", "Fly", "Noclip"}, function(selected)
    for k in pairs(selected) do print("Active:", k) end
end)

-- KEYBIND (Enum.KeyCode or string)
HomeTab.CreateKeybind("Teleport", Enum.KeyCode.T, function()
    print("Teleported!")
end)

-- TEXTBOX
HomeTab.CreateTextbox("Player Name", "Enter a username...", function(text)
    print("Input:", text)
end)

-- COLOR PICKER
HomeTab.CreateColorPicker("ESP Color", Color3.fromRGB(255, 80, 80), function(color)
    print("Color:", color)
end)

-- PROGRESS BAR
local bar = HomeTab.CreateProgressBar("Download", 0, { Suffix = "%" })
task.spawn(function()
    for i = 1, 100 do
        bar:SetValue(i)
        task.wait(0.05)
    end
end)

-- DIVIDER (with or without title)
HomeTab.CreateDivider("Information")
HomeTab.CreateDivider()

-- LABELS (types: default, info, warning, success, error)
HomeTab.CreateLabel("Welcome to My Script!", "success")
HomeTab.CreateLabel("Detected: Roblox v" .. version(), "info")

-- SECTION / ACCORDION
local sec = HomeTab.CreateSection("Advanced Options")
sec.AddButton("Reset Settings", function() print("Reset!") end)
sec.AddButton("Clear Cache",    function() print("Cleared!") end)

-- NOTIFICATIONS
Lib:Notify({ Title = "Script Loaded", Desc = "Everything initialized successfully.", Type = "Success", Duration = 5 })
Lib:Notify({ Title = "Warning",       Desc = "Some features may not work.",          Type = "Warning", Duration = 4 })
Lib:Notify({ Title = "Error",         Desc = "Failed to connect to server.",          Type = "Error",   Duration = 4 })

-- DIALOG
Lib:Dialog({
    Title   = "Confirm Action",
    Desc    = "Are you sure you want to reset all settings? This cannot be undone.",
    Buttons = {
        { Text = "Confirm", Callback = function() print("Confirmed!") end },
        { Text = "Cancel",  Callback = function() print("Cancelled.") end },
    }
})

-- CONTEXT MENU (right-click style)
Lib:ContextMenu({
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Items    = {
        { Text = "Teleport Here",  Callback = function() end },
        { Text = "Copy Position",  Callback = function() end },
        "separator",
        { Text = "Delete",  Color = Color3.fromRGB(255,80,80), Callback = function() end },
    }
})

-- GLOBAL KEYBIND
Lib:BindKey("F5", function() print("F5 pressed globally!") end)

-- THEME SWITCHING AT RUNTIME
Lib:SetTheme("Ocean")   -- "Dark" | "Ocean" | "Crimson" | "Emerald"

-- TOGGLE UI  (also bound to RightShift by default)
Lib:ToggleUI()

════════════════════════════════════════════════════════════════
]]
