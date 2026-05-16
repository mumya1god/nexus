--[[
    ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗    ██╗   ██╗██╗
    ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝    ██║   ██║██║
    ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗    ██║   ██║██║
    ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║    ██║   ██║██║
    ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║    ╚██████╔╝██║
    ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═╝

    NexusUI — Dark Navy Roblox UI Library
    Version : 1.0.0
    Author  : MUMYA
    Theme   : Dark Navy / Clean UI

    USAGE EXAMPLE:

        local Nexus = loadstring(game:HttpGet("https://raw.githubusercontent.com/mumya1god/nexus/refs/heads/main/library.lua"))()

        local Window = Nexus:CreateWindow({
            Title    = "My Script",
            SubTitle = "v1.0",
            Theme    = "DarkNavy",
        })

        local Tab = Window:CreateTab("Main")

        Tab:CreateToggle({
            Name     = "Aimbot",
            Default  = false,
            Callback = function(val) print("Aimbot:", val) end,
        })

        Tab:CreateSlider({
            Name    = "FOV Radius",
            Min     = 0, Max = 360, Default = 120,
            Callback = function(val) print("FOV:", val) end,
        })
]]

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui        = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()

local NexusUI = {}
NexusUI.__index = NexusUI
local ROOT_NAME = "NexusUI_Root"

local function SendAlreadyLoadedNotice()
    if shared and type(shared.NexusUINotify) == "function" then
        shared.NexusUINotify({ Title = "NexusUI", Message = "Already loaded.", Type = "Warning" })
        return
    end
    local success, StarterGui = pcall(function() return game:GetService("StarterGui") end)
    if success and StarterGui and StarterGui.SetCore then
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title    = "NexusUI",
                Text     = "Already loaded.",
                Duration = 3,
            })
        end)
    end
end

NexusUI.Themes = {
    DarkNavy = {
        Background       = Color3.fromRGB(3,   3,   5),
        Surface          = Color3.fromRGB(8,   9,   13),
        SurfaceAlt       = Color3.fromRGB(5,   5,   8),
        Border           = Color3.fromRGB(22,  24,  38),
        Accent           = Color3.fromRGB(80,  110, 240),
        AccentHover      = Color3.fromRGB(105, 140, 255),
        TextPrimary      = Color3.fromRGB(210, 218, 245),
        TextSecondary    = Color3.fromRGB(60,  70,  110),
        TextAccent       = Color3.fromRGB(130, 165, 255),
        Success          = Color3.fromRGB(47,  158, 68),
        Danger           = Color3.fromRGB(224, 49,  49),
        Warning          = Color3.fromRGB(245, 159, 0),
        ToggleOff        = Color3.fromRGB(18,  20,  35),
        ToggleKnob       = Color3.fromRGB(255, 255, 255),
        SliderFill       = Color3.fromRGB(80,  110, 240),
        SliderTrack      = Color3.fromRGB(18,  20,  35),
        TitleBar         = Color3.fromRGB(5,   5,   9),
        TabBar           = Color3.fromRGB(3,   3,   5),
        TabActive        = Color3.fromRGB(80,  110, 240),
        Scrollbar        = Color3.fromRGB(22,  24,  38),
    },
    Midnight = {
        Background       = Color3.fromRGB(3,   3,   5),
        Surface          = Color3.fromRGB(8,   7,   14),
        SurfaceAlt       = Color3.fromRGB(5,   4,   9),
        Border           = Color3.fromRGB(30,  25,  50),
        Accent           = Color3.fromRGB(120, 70,  240),
        AccentHover      = Color3.fromRGB(150, 100, 255),
        TextPrimary      = Color3.fromRGB(220, 210, 255),
        TextSecondary    = Color3.fromRGB(75,  65,  120),
        TextAccent       = Color3.fromRGB(170, 140, 255),
        Success          = Color3.fromRGB(47,  158, 68),
        Danger           = Color3.fromRGB(224, 49,  49),
        Warning          = Color3.fromRGB(245, 159, 0),
        ToggleOff        = Color3.fromRGB(20,  16,  38),
        ToggleKnob       = Color3.fromRGB(255, 255, 255),
        SliderFill       = Color3.fromRGB(120, 70,  240),
        SliderTrack      = Color3.fromRGB(20,  16,  38),
        TitleBar         = Color3.fromRGB(4,   3,   8),
        TabBar           = Color3.fromRGB(3,   3,   5),
        TabActive        = Color3.fromRGB(120, 70,  240),
        Scrollbar        = Color3.fromRGB(30,  25,  50),
    },
    White = {
        Background       = Color3.fromRGB(255, 255, 255),
        Surface          = Color3.fromRGB(252, 252, 255),
        SurfaceAlt       = Color3.fromRGB(242, 243, 248),
        Border           = Color3.fromRGB(18,  18,  28),
        Accent           = Color3.fromRGB(60,  100, 220),
        AccentHover      = Color3.fromRGB(40,  80,  200),
        TextPrimary      = Color3.fromRGB(12,  14,  30),
        TextSecondary    = Color3.fromRGB(75,  80,  110),
        TextAccent       = Color3.fromRGB(50,  90,  210),
        Success          = Color3.fromRGB(30,  130, 50),
        Danger           = Color3.fromRGB(200, 30,  30),
        Warning          = Color3.fromRGB(180, 110, 0),
        ToggleOff        = Color3.fromRGB(200, 203, 220),
        ToggleKnob       = Color3.fromRGB(255, 255, 255),
        SliderFill       = Color3.fromRGB(60,  100, 220),
        SliderTrack      = Color3.fromRGB(200, 203, 220),
        TitleBar         = Color3.fromRGB(245, 246, 252),
        TabBar           = Color3.fromRGB(248, 249, 254),
        TabActive        = Color3.fromRGB(60,  100, 220),
        Scrollbar        = Color3.fromRGB(160, 165, 195),
    },
}

local function Tween(obj, props, duration, style, direction)
    style     = style     or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    duration  = duration  or 0.2
    local info = TweenInfo.new(duration, style, direction)
    TweenService:Create(obj, info, props):Play()
end

local function Create(class, props, children)
    local inst = Instance.new(class)
    if class == "TextButton" then
        inst.AutoButtonColor = false
    end
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function MakeDraggable(frame, handle, onDragStart)
    local dragging, dragStart, startPos, moved = false, nil, nil, false
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            moved     = false
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not frame.Parent then dragging = false; return end
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            if not moved and (math.abs(delta.X) > 4 or math.abs(delta.Y) > 4) then
                moved = true
                if onDragStart then pcall(onDragStart) end
            end
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    return function() return moved end
end

local NotificationHolder

local function EnsureNotifHolder()
    if NotificationHolder then return end
    local sg = Create("ScreenGui", {
        Name            = "NexusUI_Notifications",
        ResetOnSpawn    = false,
        ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
        Parent          = CoreGui,
    })
    NotificationHolder = Create("Frame", {
        Name              = "Holder",
        BackgroundTransparency = 1,
        Size              = UDim2.new(0, 280, 1, 0),
        Position          = UDim2.new(1, -295, 0, 0),
        Parent            = sg,
    })
    Create("UIListLayout", {
        SortOrder   = Enum.SortOrder.LayoutOrder,
        Padding     = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Parent      = NotificationHolder,
    })
    Create("UIPadding", {
        PaddingBottom = UDim.new(0, 16),
        Parent        = NotificationHolder,
    })
end

function NexusUI:Notify(opts)
    opts = opts or {}
    local title    = opts.Title    or "Notification"
    local message  = opts.Message  or ""
    local notifType= opts.Type     or "Info"
    local duration = opts.Duration or 4

    EnsureNotifHolder()
    local T = NexusUI._activeTheme or NexusUI.Themes.DarkNavy

    local accentColor = ({
        Info    = T.Accent,
        Success = T.Success,
        Error   = T.Danger,
        Warning = T.Warning,
    })[notifType] or T.Accent

    local icon = ({
        Info    = "i",
        Success = "✓",
        Error   = "X",
        Warning = "!",
    })[notifType] or "i"

    local notif = Create("Frame", {
        Name                   = "Notif",
        BackgroundColor3       = T.Surface,
        BorderSizePixel        = 0,
        Size                   = UDim2.new(1, 0, 0, 70),
        BackgroundTransparency = 0.05,
        Parent                 = NotificationHolder,
    })
    Create("UICorner",   { CornerRadius = UDim.new(0, 7), Parent = notif })
    Create("UIStroke",   { Color = T.Border, Thickness = 1, Parent = notif })

    Create("Frame", {
        Name             = "Bar",
        BackgroundColor3 = accentColor,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 3, 1, 0),
        Position         = UDim2.new(0, 0, 0, 0),
        Parent           = notif,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = notif.Bar })

    Create("TextLabel", {
        Name             = "Icon",
        BackgroundTransparency = 1,
        Size             = UDim2.new(0, 32, 1, 0),
        Position         = UDim2.new(0, 10, 0, 0),
        Text             = icon,
        TextColor3       = accentColor,
        TextSize         = 18,
        Font             = Enum.Font.GothamBold,
        Parent           = notif,
    })

    Create("TextLabel", {
        Name             = "Title",
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, -52, 0, 22),
        Position         = UDim2.new(0, 46, 0, 10),
        Text             = title,
        TextColor3       = T.TextPrimary,
        TextSize         = 13,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = notif,
    })

    Create("TextLabel", {
        Name             = "Message",
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, -52, 0, 28),
        Position         = UDim2.new(0, 46, 0, 32),
        Text             = message,
        TextColor3       = T.TextSecondary,
        TextSize         = 11,
        Font             = Enum.Font.Gotham,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextWrapped      = true,
        Parent           = notif,
    })

    local prog = Create("Frame", {
        Name             = "Progress",
        BackgroundColor3 = accentColor,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 2),
        Position         = UDim2.new(0, 0, 1, -2),
        Parent           = notif,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 2), Parent = prog })

    Tween(prog, { Size = UDim2.new(0, 0, 0, 2) }, duration, Enum.EasingStyle.Linear)

    task.delay(duration, function()
        if not notif.Parent then return end
        local FADE = 0.35
        Tween(notif, { BackgroundTransparency = 1 }, FADE)
        for _, obj in ipairs(notif:GetDescendants()) do
            pcall(function()
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    Tween(obj, { TextTransparency = 1, BackgroundTransparency = 1 }, FADE)
                elseif obj:IsA("Frame") then
                    Tween(obj, { BackgroundTransparency = 1 }, FADE)
                elseif obj:IsA("ImageLabel") then
                    Tween(obj, { ImageTransparency = 1, BackgroundTransparency = 1 }, FADE)
                elseif obj:IsA("UIStroke") then
                    Tween(obj, { Transparency = 1 }, FADE)
                end
            end)
        end
        task.wait(FADE + 0.05)
        pcall(function() notif:Destroy() end)
    end)
end

function NexusUI:CreateWindow(opts)
    opts = opts or {}
    local title    = opts.Title    or "NexusUI"
    local subtitle = opts.SubTitle or "v1.0"
    local themeName= opts.Theme    or "DarkNavy"
    local T        = self.Themes[themeName] or self.Themes.DarkNavy
    NexusUI._activeTheme = T

    local function _alreadyLoaded()
        SendAlreadyLoadedNotice()
        local function _noopTab()
            local t = {}
            local function noop() return t end
            t.CreateToggle     = noop
            t.CreateButton     = noop
            t.CreateSlider     = noop
            t.CreateDropdown   = noop
            t.CreateColorPicker= noop
            t.CreateInput      = noop
            t.CreateSection    = noop
            t.CreateLabel      = noop
            t.CreateSeparator  = noop
            return t
        end
        local stub = {}
        function stub:CreateTab()   return _noopTab() end
        function stub:Notify(opts)  NexusUI:Notify(opts) end
        function stub:Destroy()     end
        function stub:SetTitle()    end
        local _origNoopTab = _noopTab
        _noopTab = function()
            local t = _origNoopTab()
            t.CreatePlayerSelector = function() return {} end
            return t
        end
        return stub
    end

    if shared and type(shared.NexusUIWindow) == "table" then
        return _alreadyLoaded()
    end
    if CoreGui:FindFirstChild(ROOT_NAME) then
        return _alreadyLoaded()
    end

    local Window = {}
    Window._tabs         = {}
    Window._activeTab    = nil
    Window._theme        = T
    Window._toggleResets = {}
    local _windowActive  = true

    local _activePopup = nil

    local function _RegisterPopup(closeFunc, popupFrame, triggerBtn)
        if _activePopup and _activePopup.close then
            pcall(_activePopup.close)
        end
        _activePopup = { close = closeFunc, frame = popupFrame, trigger = triggerBtn }
    end

    local function _CloseActivePopup()
        if _activePopup then
            pcall(_activePopup.close)
            _activePopup = nil
        end
    end

    UserInputService.InputBegan:Connect(function(inp)
        if not _windowActive then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        if not _activePopup or not _activePopup.frame then return end
        local mp = inp.Position
        -- If click is on the trigger button, let the button's MouseButton1Click handle it
        local tb = _activePopup.trigger
        if tb then
            local tp = tb.AbsolutePosition
            local ts = tb.AbsoluteSize
            if mp.X >= tp.X and mp.X <= tp.X + ts.X and
               mp.Y >= tp.Y and mp.Y <= tp.Y + ts.Y then
                return
            end
        end
        local f  = _activePopup.frame
        local fp = f.AbsolutePosition
        local fs = f.AbsoluteSize
        if mp.X < fp.X or mp.X > fp.X + fs.X or
           mp.Y < fp.Y or mp.Y > fp.Y + fs.Y then
            _CloseActivePopup()
        end
    end)

    local sg = Create("ScreenGui", {
        Name           = ROOT_NAME,
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent         = CoreGui,
    })
    Window._sg = sg

    local main = Create("Frame", {
        Name             = "Main",
        BackgroundColor3 = T.Background,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 480, 0, 420),
        Position         = UDim2.new(0.5, -240, 0.5, -210),
        ClipsDescendants = true,
        Parent           = sg,
    })
    Create("UICorner",  { CornerRadius = UDim.new(0, 12), Parent = main })
    Create("UIStroke",  { Color = T.Border, Thickness = 1.5, Parent = main })

    local titleBar = Create("Frame", {
        Name             = "TitleBar",
        BackgroundColor3 = T.TitleBar,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 52),
        Parent           = main,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = titleBar })
    Create("Frame", {
        BackgroundColor3 = T.TitleBar,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 12),
        Position         = UDim2.new(0, 0, 1, -12),
        Parent           = titleBar,
    })
    Create("Frame", {
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, -1),
        Parent           = titleBar,
    })

    Create("Frame", {
        Name             = "AccentBar",
        BackgroundColor3 = T.Accent,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 3, 0, 22),
        Position         = UDim2.new(0, 14, 0.5, -11),
        Parent           = titleBar,
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = titleBar.AccentBar })

    Create("TextLabel", {
        Name             = "Title",
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, -120, 0, 20),
        Position         = UDim2.new(0, 24, 0, 7),
        Text             = title,
        TextColor3       = T.TextPrimary,
        TextSize         = 13,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = titleBar,
    })
    Create("TextLabel", {
        Name             = "SubTitle",
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, -120, 0, 14),
        Position         = UDim2.new(0, 24, 0, 28),
        Text             = subtitle,
        TextColor3       = T.TextSecondary,
        TextSize         = 9,
        Font             = Enum.Font.Gotham,
        TextXAlignment   = Enum.TextXAlignment.Left,
        Parent           = titleBar,
    })

    local function MakeWinBtn(pos, bgColor, symbol)
        local btn = Create("TextButton", {
            BackgroundColor3 = bgColor,
            BorderSizePixel  = 0,
            Size             = UDim2.new(0, 11, 0, 11),
            Position         = UDim2.new(1, pos, 0.5, -5.5),
            Text             = "",
            Font             = Enum.Font.GothamBold,
            TextSize         = 7,
            TextColor3       = Color3.fromRGB(30, 30, 30),
            Parent           = titleBar,
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = btn })
        btn.MouseEnter:Connect(function()
            btn.Text = symbol
            Tween(btn, { BackgroundTransparency = 0.15 }, 0.1)
        end)
        btn.MouseLeave:Connect(function()
            btn.Text = ""
            Tween(btn, { BackgroundTransparency = 0 }, 0.1)
        end)
        return btn
    end

    local closeBtn   = MakeWinBtn(-18, Color3.fromRGB(255, 88, 80),  "✕")
    local minBtn     = MakeWinBtn(-34, Color3.fromRGB(255, 185, 40), "−")
    local toggleBtn  = MakeWinBtn(-50, Color3.fromRGB(100, 130, 255), "≡")

    local mainOpen   = true
    local minimized  = false

    local collapsedBtn = Create("TextButton", {
        Name             = "CollapsedToggle",
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
        Size             = UDim2.new(0, 92, 0, 46),
        Position         = UDim2.new(0.5, -46, 0, 30),
        Text             = "Nexus",
        TextColor3       = T.TextPrimary,
        TextSize         = 14,
        Font             = Enum.Font.GothamBold,
        Visible          = false,
        Parent           = sg,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = collapsedBtn })

    local function ShowMain()
        if mainOpen then return end
        mainOpen = true
        minimized = false
        collapsedBtn.Visible = false
        main.Visible = true
        main.Size = UDim2.new(0, 480, 0, 420)
        main.Position = UDim2.new(0.5, -240, 0, -420)
        Tween(main, { Position = UDim2.new(0.5, -240, 0.5, -210) }, 0.28, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
    end

    local function HideMain()
        if not mainOpen then return end
        _CloseActivePopup()
        mainOpen = false
        Tween(main, { Position = UDim2.new(0.5, -240, 0, -420) }, 0.22, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
        task.delay(0.22, function()
            if not mainOpen then
                main.Visible = false
                collapsedBtn.Visible = true
                collapsedBtn.Position = UDim2.new(0.5, -46, 0, -60)
                Tween(collapsedBtn, { Position = UDim2.new(0.5, -46, 0, 20) }, 0.28, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
            end
        end)
    end

    toggleBtn.MouseButton1Click:Connect(HideMain)

    local _menuToggleKey = Enum.KeyCode.RightShift
    UserInputService.InputBegan:Connect(function(inp, gpe)
        if not _windowActive then return end
        if gpe then return end
        if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if inp.KeyCode == _menuToggleKey then
            if mainOpen then
                HideMain()
            else
                ShowMain()
            end
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        _windowActive = false
        for _, resetFn in ipairs(Window._toggleResets) do
            pcall(resetFn)
        end
        _CloseActivePopup()
        if shared then
            shared.NexusUIWindow = nil
            shared.NexusUINotify = nil
            shared.NexusUIGui    = nil
        end
        pcall(function() sg.Name = ROOT_NAME .. "_Closing" end)
        Tween(main, { BackgroundTransparency = 1, Position = UDim2.new(0.5, -240, 0.5, 80) }, 0.25, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
        task.delay(0.25, function()
            pcall(function() sg:Destroy() end)
        end)
    end)

    minBtn.MouseButton1Click:Connect(function()
        if not mainOpen then
            ShowMain()
            return
        end

        _CloseActivePopup()
        minimized = not minimized
        if minimized then
            Tween(main, { Size = UDim2.new(0, 480, 0, 52) }, 0.3)
        else
            Tween(main, { Size = UDim2.new(0, 480, 0, 420) }, 0.3)
        end
    end)

    MakeDraggable(main, titleBar, function() _CloseActivePopup() end)
    local collapsedBtnWasDragged = MakeDraggable(collapsedBtn, collapsedBtn)

    collapsedBtn.MouseButton1Click:Connect(function()
        if collapsedBtnWasDragged() then return end
        ShowMain()
    end)

    local tabNavBar = Create("Frame", {
        Name             = "TabNavBar",
        BackgroundColor3 = T.TitleBar,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 40),
        Position         = UDim2.new(0, 0, 0, 52),
        Visible          = false,
        Parent           = main,
    })
    local navBottomBorder = Create("Frame", {
        Name             = "NavBorder",
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 0, 90),
        Visible          = false,
        Parent           = main,
    })
    local tabGrid = Create("UIGridLayout", {
        FillDirection         = Enum.FillDirection.Horizontal,
        FillDirectionMaxCells = 0,
        SortOrder             = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment   = Enum.HorizontalAlignment.Left,
        CellSize              = UDim2.new(0, 90, 0, 34),
        CellPadding           = UDim2.new(0, 3, 0, 3),
        Parent                = tabNavBar,
    })
    Create("UIPadding", {
        PaddingLeft   = UDim.new(0, 6),
        PaddingRight  = UDim.new(0, 6),
        PaddingTop    = UDim.new(0, 3),
        PaddingBottom = UDim.new(0, 3),
        Parent        = tabNavBar,
    })

    local TITLE_H  = 52
    local NAV_H    = 40
    local contentArea = Create("Frame", {
        Name             = "ContentArea",
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, 0, 1, -TITLE_H),
        Position         = UDim2.new(0, 0, 0, TITLE_H),
        ClipsDescendants = true,
        Parent           = main,
    })
    local function _applyTabsLayout()
        local newNavH = math.max(tabGrid.AbsoluteContentSize.Y + 6, NAV_H)
        tabNavBar.Visible        = true
        navBottomBorder.Visible  = true
        tabNavBar.Size           = UDim2.new(1, 0, 0, newNavH)
        navBottomBorder.Position = UDim2.new(0, 0, 0, TITLE_H + newNavH)
        contentArea.Position     = UDim2.new(0, 0, 0, TITLE_H + newNavH + 1)
        contentArea.Size         = UDim2.new(1, 0, 1, -(TITLE_H + newNavH + 1))
    end
    tabGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if Window._tabMode then _applyTabsLayout() end
    end)

    local ABOUTUS_H = 34
    local aboutUsHeader = Create("Frame", {
        Name             = "AboutUsHeader",
        BackgroundColor3 = T.TitleBar,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, ABOUTUS_H),
        Position         = UDim2.new(0, 0, 0, 0),
        ZIndex           = 3,
        Parent           = contentArea,
    })
    local aboutUsToggleBtn = Create("TextButton", {
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, 0, 1, 0),
        Text             = "▸  About Us",
        TextColor3       = T.TextSecondary,
        TextSize         = 11,
        Font             = Enum.Font.GothamSemibold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 4,
        Parent           = aboutUsHeader,
    })
    Create("UIPadding", { PaddingLeft = UDim.new(0, 14), Parent = aboutUsToggleBtn })
    Create("Frame", {
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, -1),
        ZIndex           = 4,
        Parent           = aboutUsHeader,
    })
    local aboutUsPanel = Create("Frame", {
        Name             = "AboutUsPanel",
        BackgroundColor3 = T.Background,
        BorderSizePixel  = 0,
        Size             = UDim2.new(1, 0, 0, 0),
        Position         = UDim2.new(0, 0, 0, ABOUTUS_H),
        ClipsDescendants = true,
        ZIndex           = 3,
        Parent           = contentArea,
    })
    local aboutUsPanelScroll = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        Size                   = UDim2.new(1, 0, 1, 0),
        CanvasSize             = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize    = Enum.AutomaticSize.Y,
        ScrollBarThickness     = 3,
        ScrollBarImageColor3   = T.Scrollbar,
        ZIndex                 = 4,
        Parent                 = aboutUsPanel,
    })
    Create("UIListLayout", {
        SortOrder     = Enum.SortOrder.LayoutOrder,
        Padding       = UDim.new(0, 6),
        Parent        = aboutUsPanelScroll,
    })
    Create("UIPadding", {
        PaddingLeft   = UDim.new(0, 12), PaddingRight  = UDim.new(0, 12),
        PaddingTop    = UDim.new(0, 8),  PaddingBottom = UDim.new(0, 8),
        Parent        = aboutUsPanelScroll,
    })
    local singleScroll = Create("ScrollingFrame", {
        Name                 = "SingleScroll",
        BackgroundTransparency = 1,
        BorderSizePixel      = 0,
        Size                 = UDim2.new(1, 0, 1, -ABOUTUS_H),
        Position             = UDim2.new(0, 0, 0, ABOUTUS_H),
        CanvasSize           = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize  = Enum.AutomaticSize.Y,
        ScrollBarThickness   = 3,
        ScrollBarImageColor3 = T.Scrollbar,
        Parent               = contentArea,
    })
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0, 6),
        Parent    = singleScroll,
    })
    Create("UIPadding", {
        PaddingLeft   = UDim.new(0, 12), PaddingRight  = UDim.new(0, 12),
        PaddingTop    = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
        Parent        = singleScroll,
    })
    singleScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        _CloseActivePopup()
    end)
    local _aboutUsPanelOpen = false
    aboutUsToggleBtn.MouseButton1Click:Connect(function()
        _aboutUsPanelOpen = not _aboutUsPanelOpen
        if _aboutUsPanelOpen then
            aboutUsToggleBtn.Text = "v  About Us"
            task.defer(function()
                local panelH = math.min(aboutUsPanelScroll.AbsoluteContentSize.Y + 16, 220)
                Tween(aboutUsPanel,  { Size = UDim2.new(1, 0, 0, panelH) }, 0.22)
                Tween(singleScroll, {
                    Position = UDim2.new(0, 0, 0, ABOUTUS_H + panelH),
                    Size     = UDim2.new(1, 0, 1, -(ABOUTUS_H + panelH)),
                }, 0.22)
            end)
        else
            aboutUsToggleBtn.Text = ">  About Us"
            Tween(aboutUsPanel,  { Size = UDim2.new(1, 0, 0, 0) }, 0.18)
            Tween(singleScroll, {
                Position = UDim2.new(0, 0, 0, ABOUTUS_H),
                Size     = UDim2.new(1, 0, 1, -ABOUTUS_H),
            }, 0.18)
        end
    end)

    function Window:CreateTab(name, _existingScroll)
        if not _existingScroll then
            for _, existing in ipairs(Window._tabs) do
                if existing._name == name then return existing end
            end
        end

        local Tab = {}
        Tab._elements = {}

        local _switchedToTabsMode = false
        if not _existingScroll and not Window._tabMode then
            Window._tabMode      = true
            _switchedToTabsMode  = true
            aboutUsHeader.Visible = false
            aboutUsPanel.Visible  = false
            singleScroll.Visible  = false
            _applyTabsLayout()
        end

        local scrollFrame
        if _existingScroll then
            scrollFrame = _existingScroll
        else
            scrollFrame = Create("ScrollingFrame", {
                Name                 = "Scroll_"..name,
                BackgroundTransparency = 1,
                BorderSizePixel      = 0,
                Size                 = UDim2.new(1, 0, 1, 0),
                CanvasSize           = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize  = Enum.AutomaticSize.Y,
                ScrollBarThickness   = 3,
                ScrollBarImageColor3 = T.Scrollbar,
                Visible              = false,
                Parent               = contentArea,
            })
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding   = UDim.new(0, 6),
                Parent    = scrollFrame,
            })
            Create("UIPadding", {
                PaddingLeft   = UDim.new(0, 12), PaddingRight  = UDim.new(0, 12),
                PaddingTop    = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
                Parent        = scrollFrame,
            })
        end
        Tab._scroll = scrollFrame

        scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            _CloseActivePopup()
        end)

        local tabBtn, tabHover, tabLabel, tabIndicator

        if not _existingScroll then
            local layoutOrder = #Window._tabs + 1

            tabBtn = Create("TextButton", {
                Name                   = "Tab_"..name,
                BackgroundColor3       = T.SurfaceAlt,
                BackgroundTransparency = 0,
                BorderSizePixel        = 0,
                LayoutOrder            = layoutOrder,
                Size                   = UDim2.new(1, 0, 1, 0),
                Text                   = name,
                TextColor3             = T.TextSecondary,
                TextScaled             = true,
                Font                   = Enum.Font.GothamSemibold,
                TextXAlignment         = Enum.TextXAlignment.Center,
                Parent                 = tabNavBar,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tabBtn })
            Create("UITextSizeConstraint", { MinTextSize = 7, MaxTextSize = 12, Parent = tabBtn })
            tabHover = Create("Frame", {
                BackgroundColor3       = T.Surface,
                BackgroundTransparency = 1,
                BorderSizePixel        = 0,
                Size                   = UDim2.new(1, 0, 1, 0),
                Parent                 = tabBtn,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tabHover })
            tabBtn.MouseEnter:Connect(function()
                if Window._activeTab ~= Tab then
                    Tween(tabBtn,   { TextColor3 = T.TextAccent }, 0.12)
                    Tween(tabHover, { BackgroundTransparency = 0 }, 0.12)
                end
            end)
            tabBtn.MouseLeave:Connect(function()
                Tween(tabHover, { BackgroundTransparency = 1 }, 0.12)
                if Window._activeTab ~= Tab then
                    Tween(tabBtn, { TextColor3 = T.TextSecondary }, 0.12)
                end
            end)
            tabLabel = tabBtn
            tabIndicator = Create("Frame", {
                BackgroundColor3       = T.Accent,
                BackgroundTransparency = 1,
                BorderSizePixel        = 0,
                Size                   = UDim2.new(0, 0, 0, 2),
                Position               = UDim2.new(0.5, 0, 1, -1),
                AnchorPoint            = Vector2.new(0.5, 1),
                Parent                 = tabBtn,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 2), Parent = tabIndicator })
        else
            tabLabel     = setmetatable({}, { __index = function() return 0 end, __newindex = function() end })
            tabIndicator = setmetatable({}, { __index = function() return UDim2.new() end, __newindex = function() end })
        end

        local function ActivateTab()
            for _, t in ipairs(Window._tabs) do
                pcall(function()
                    Tween(t._tabLabel, { TextColor3 = T.TextSecondary }, 0.15)
                    t._tabLabel.Font = Enum.Font.GothamSemibold
                    Tween(t._tabIndicator, { Size = UDim2.new(0, 0, 0, 2), BackgroundTransparency = 1 }, 0.15)
                    if t._tabHover then
                        Tween(t._tabHover, { BackgroundTransparency = 1 }, 0.15)
                    end
                    t._scroll.Visible = false
                end)
            end
            if tabBtn then
                Tween(tabBtn, { TextColor3 = T.Accent }, 0.15)
                tabBtn.Font = Enum.Font.GothamBold
                Tween(tabIndicator, { Size = UDim2.new(0.65, 0, 0, 2), BackgroundTransparency = 0 }, 0.18)
            end
            scrollFrame.Visible = true
            Window._activeTab   = Tab
        end

        Tab._name         = name
        Tab._tabLabel     = tabLabel
        Tab._tabIndicator = tabIndicator
        Tab._tabHover     = tabHover

        if not _existingScroll then
            tabBtn.MouseButton1Click:Connect(function()
                ActivateTab()
            end)
            table.insert(Window._tabs, Tab)
            if #Window._tabs == 1 then
                ActivateTab()
            end
            if _switchedToTabsMode and not Window._aboutUsTabBuilt then
                Window._aboutUsTabBuilt = true
                task.defer(function() _BuildAboutUsTab() end)
            end
        end

        function Tab:CreateSection(text)
            local f = Create("Frame", {
                BackgroundTransparency = 1,
                Size   = UDim2.new(1, 0, 0, 26),
                Parent = scrollFrame,
            })
            Create("Frame", {
                BackgroundColor3 = T.Accent,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 2, 0, 12),
                Position         = UDim2.new(0, 0, 0.5, -6),
                Parent           = f,
            })
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Size             = UDim2.new(1, -6, 1, 0),
                Position         = UDim2.new(0, 8, 0, 0),
                Text             = string.upper(text),
                TextColor3       = T.TextSecondary,
                TextSize         = 9,
                Font             = Enum.Font.GothamBold,
                TextXAlignment   = Enum.TextXAlignment.Left,
                Parent           = f,
            })
            Create("Frame", {
                BackgroundColor3 = T.Border,
                BorderSizePixel  = 0,
                Size             = UDim2.new(1, 0, 0, 1),
                Position         = UDim2.new(0, 0, 1, -1),
                Parent           = f,
            })
        end

        local function BaseElement(height)
            local el = Create("Frame", {
                BackgroundColor3 = T.Surface,
                BorderSizePixel  = 0,
                Size             = UDim2.new(1, 0, 0, height or 46),
                Parent           = scrollFrame,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = el })
            Create("UIStroke",  { Color = T.Border, Thickness = 1, Parent = el })
            return el
        end

        local function NameDesc(parent, name, desc, offsetX)
            offsetX = offsetX or 12
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Size             = UDim2.new(0.55, 0, 0, 18),
                Position         = UDim2.new(0, offsetX, 0, 8),
                Text             = name,
                TextColor3       = T.TextPrimary,
                TextSize         = 12,
                Font             = Enum.Font.GothamSemibold,
                TextXAlignment   = Enum.TextXAlignment.Left,
                Parent           = parent,
            })
            if desc and desc ~= "" then
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size             = UDim2.new(0.55, 0, 0, 14),
                    Position         = UDim2.new(0, offsetX, 0, 26),
                    Text             = desc,
                    TextColor3       = T.TextSecondary,
                    TextSize         = 10,
                    Font             = Enum.Font.Gotham,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    Parent           = parent,
                })
            end
        end

        function Tab:CreateToggle(opts)
            opts = opts or {}
            local name     = opts.Name     or "Toggle"
            local desc     = opts.Desc     or ""
            local default  = opts.Default  or false
            local callback = opts.Callback or function() end

            local el = BaseElement(46)
            NameDesc(el, name, desc)

            local toggled = default

            local track = Create("Frame", {
                Name             = "Track",
                BackgroundColor3 = toggled and T.Accent or T.ToggleOff,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 38, 0, 20),
                Position         = UDim2.new(1, -50, 0.5, -10),
                Parent           = el,
            })
            Create("UICorner",  { CornerRadius = UDim.new(1, 0), Parent = track })
            Create("UIStroke",  { Color = T.Border, Thickness = 1, Parent = track })

            local knob = Create("Frame", {
                Name             = "Knob",
                BackgroundColor3 = T.ToggleKnob,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 14, 0, 14),
                Position         = toggled and UDim2.new(0, 20, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                Parent           = track,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

            local btn = Create("TextButton", {
                BackgroundTransparency = 1,
                Size   = UDim2.new(1, 0, 1, 0),
                Text   = "",
                Parent = el,
            })

            btn.MouseButton1Click:Connect(function()
                toggled = not toggled
                if toggled then
                    Tween(track, { BackgroundColor3 = T.Accent }, 0.18)
                    Tween(knob,  { Position = UDim2.new(0, 20, 0.5, -7) }, 0.18)
                else
                    Tween(track, { BackgroundColor3 = T.ToggleOff }, 0.18)
                    Tween(knob,  { Position = UDim2.new(0, 3, 0.5, -7) }, 0.18)
                end
                callback(toggled)
            end)

            el.MouseEnter:Connect(function() Tween(el, { BackgroundColor3 = T.SurfaceAlt }, 0.1) end)
            el.MouseLeave:Connect(function() Tween(el, { BackgroundColor3 = T.Surface }, 0.1) end)

            table.insert(Window._toggleResets, function()
                if toggled then
                    toggled = false
                    track.BackgroundColor3 = T.ToggleOff
                    knob.Position = UDim2.new(0, 3, 0.5, -7)
                    pcall(function() callback(false) end)
                end
            end)

            local ctrl = {}
            function ctrl:Set(val)
                toggled = val
                if toggled then
                    track.BackgroundColor3 = T.Accent
                    knob.Position = UDim2.new(0, 20, 0.5, -7)
                else
                    track.BackgroundColor3 = T.ToggleOff
                    knob.Position = UDim2.new(0, 3, 0.5, -7)
                end
                callback(toggled)
            end
            function ctrl:Get() return toggled end
            return ctrl
        end

        function Tab:CreateSlider(opts)
            opts = opts or {}
            local name     = opts.Name     or "Slider"
            local desc     = opts.Desc     or ""
            local min      = opts.Min      or 0
            local max      = opts.Max      or 100
            local default  = opts.Default  or 50
            local suffix   = opts.Suffix   or ""
            local callback = opts.Callback or function() end

            local el = BaseElement(58)
            NameDesc(el, name, desc)

            local valLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size             = UDim2.new(0, 40, 0, 18),
                Position         = UDim2.new(1, -52, 0, 8),
                Text             = tostring(default)..suffix,
                TextColor3       = T.TextAccent,
                TextSize         = 12,
                Font             = Enum.Font.GothamBold,
                TextXAlignment   = Enum.TextXAlignment.Right,
                Parent           = el,
            })

            local track = Create("Frame", {
                BackgroundColor3 = T.SliderTrack,
                BorderSizePixel  = 0,
                Size             = UDim2.new(1, -24, 0, 4),
                Position         = UDim2.new(0, 12, 0, 42),
                Parent           = el,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })

            local fill = Create("Frame", {
                BackgroundColor3 = T.SliderFill,
                BorderSizePixel  = 0,
                Size             = UDim2.new((default - min) / (max - min), 0, 1, 0),
                Parent           = track,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })

            local thumb = Create("Frame", {
                BackgroundColor3 = T.SliderFill,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 14, 0, 14),
                AnchorPoint      = Vector2.new(0.5, 0.5),
                Position         = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
                Parent           = track,
            })
            Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = thumb })
            Create("UIStroke",  { Color = T.SurfaceAlt, Thickness = 2, Parent = thumb })

            local currentVal = default
            local dragging   = false

            local btn = Create("TextButton", {
                BackgroundTransparency = 1,
                Size   = UDim2.new(1, 0, 1, 0),
                Text   = "",
                ZIndex = 5,
                Parent = el,
            })

            local function UpdateSlider(inputX)
                local trackAbs = track.AbsolutePosition.X
                local trackW   = track.AbsoluteSize.X
                local pct      = math.clamp((inputX - trackAbs) / trackW, 0, 1)
                local val      = math.floor(min + (max - min) * pct + 0.5)
                currentVal     = val
                local vpct     = (val - min) / (max - min)
                fill.Size      = UDim2.new(vpct, 0, 1, 0)
                thumb.Position = UDim2.new(vpct, 0, 0.5, 0)
                valLabel.Text  = tostring(val)..suffix
                callback(val)
            end

            btn.MouseButton1Down:Connect(function()
                dragging = true
                UpdateSlider(Mouse.X)
            end)
            UserInputService.InputEnded:Connect(function(inp)
                if not _windowActive then dragging = false; return end
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            RunService.RenderStepped:Connect(function()
                if not _windowActive then dragging = false; return end
                if dragging then UpdateSlider(Mouse.X) end
            end)

            el.MouseEnter:Connect(function() Tween(el, { BackgroundColor3 = T.SurfaceAlt }, 0.1) end)
            el.MouseLeave:Connect(function() Tween(el, { BackgroundColor3 = T.Surface }, 0.1) end)

            local ctrl = {}
            function ctrl:Set(val)
                currentVal = math.clamp(val, min, max)
                local pct  = (currentVal - min) / (max - min)
                fill.Size      = UDim2.new(pct, 0, 1, 0)
                thumb.Position = UDim2.new(pct, 0, 0.5, 0)
                valLabel.Text  = tostring(currentVal)..suffix
                callback(currentVal)
            end
            function ctrl:Get() return currentVal end
            return ctrl
        end

        function Tab:CreateButton(opts)
            opts = opts or {}
            local name     = opts.Name     or "Button"
            local desc     = opts.Desc     or ""
            local btnText  = opts.BtnText  or "Execute"
            local callback = opts.Callback or function() end

            local el = BaseElement(46)
            NameDesc(el, name, desc)

            local BTN_DARK  = T.Surface
            local BTN_HOVER = T.SurfaceAlt
            local BTN_PRESS = T.Background

            local btn = Create("TextButton", {
                BackgroundColor3 = BTN_DARK,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 84, 0, 26),
                Position         = UDim2.new(1, -96, 0.5, -13),
                Text             = btnText,
                TextColor3       = T.TextPrimary,
                TextScaled       = true,
                Font             = Enum.Font.GothamSemibold,
                Parent           = el,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
            Create("UIStroke",  { Color = T.Border, Thickness = 1, Parent = btn })
            Create("UITextSizeConstraint", { MinTextSize = 8, MaxTextSize = 12, Parent = btn })
            Create("UIPadding", {
                PaddingLeft  = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6),
                Parent       = btn,
            })

            btn.MouseEnter:Connect(function()
                Tween(btn, { BackgroundColor3 = BTN_HOVER, TextColor3 = T.TextPrimary }, 0.12)
            end)
            btn.MouseLeave:Connect(function()
                Tween(btn, { BackgroundColor3 = BTN_DARK, TextColor3 = T.TextPrimary }, 0.12)
            end)
            btn.MouseButton1Down:Connect(function()
                Tween(btn, { BackgroundColor3 = BTN_PRESS, Size = UDim2.new(0, 76, 0, 24), Position = UDim2.new(1, -90, 0.5, -12) }, 0.07)
            end)
            btn.MouseButton1Up:Connect(function()
                Tween(btn, { BackgroundColor3 = BTN_HOVER, Size = UDim2.new(0, 80, 0, 26), Position = UDim2.new(1, -92, 0.5, -13) }, 0.07)
                callback()
            end)

            el.MouseEnter:Connect(function() Tween(el, { BackgroundColor3 = T.SurfaceAlt }, 0.1) end)
            el.MouseLeave:Connect(function() Tween(el, { BackgroundColor3 = T.Surface }, 0.1) end)
        end

        function Tab:CreateTextbox(opts)
            opts = opts or {}
            local name        = opts.Name        or "Textbox"
            local desc        = opts.Desc        or ""
            local placeholder = opts.Placeholder or "Enter text..."
            local callback    = opts.Callback    or function() end

            local el = BaseElement(46)
            NameDesc(el, name, desc)

            local box = Create("TextBox", {
                BackgroundColor3 = T.SurfaceAlt,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 140, 0, 26),
                Position         = UDim2.new(1, -152, 0.5, -13),
                PlaceholderText  = placeholder,
                PlaceholderColor3 = T.TextSecondary,
                Text             = "",
                TextColor3       = T.TextPrimary,
                TextSize         = 11,
                Font             = Enum.Font.Gotham,
                ClearTextOnFocus = false,
                Parent           = el,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = box })
            local stroke = Create("UIStroke", { Color = T.Border, Thickness = 1, Parent = box })
            Create("UIPadding",  { PaddingLeft = UDim.new(0, 8), Parent = box })

            box.Focused:Connect(function()
                Tween(stroke, { Color = T.Accent }, 0.15)
            end)
            box.FocusLost:Connect(function(enterPressed)
                Tween(stroke, { Color = T.Border }, 0.15)
                if enterPressed then callback(box.Text) end
            end)

            el.MouseEnter:Connect(function() Tween(el, { BackgroundColor3 = T.SurfaceAlt }, 0.1) end)
            el.MouseLeave:Connect(function() Tween(el, { BackgroundColor3 = T.Surface }, 0.1) end)

            local ctrl = {}
            function ctrl:Set(val) box.Text = val end
            function ctrl:Get() return box.Text end
            return ctrl
        end

        function Tab:CreateDropdown(opts)
            opts = opts or {}
            local name     = opts.Name     or "Dropdown"
            local desc     = opts.Desc     or ""
            local items    = opts.Items    or {}
            local default  = opts.Default  or items[1] or ""
            local callback = opts.Callback or function() end

            local selected  = default
            local open      = false

            local el = BaseElement(46)
            el.ClipsDescendants = false
            NameDesc(el, name, desc)

            local ddBtn = Create("TextButton", {
                BackgroundColor3 = T.SurfaceAlt,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 140, 0, 26),
                Position         = UDim2.new(1, -152, 0.5, -13),
                Text             = "",
                Parent           = el,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = ddBtn })
            Create("UIStroke",  { Color = T.Border, Thickness = 1, Parent = ddBtn })

            local ddLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size             = UDim2.new(1, -24, 1, 0),
                Position         = UDim2.new(0, 8, 0, 0),
                Text             = selected,
                TextColor3       = T.TextPrimary,
                TextSize         = 11,
                Font             = Enum.Font.Gotham,
                TextXAlignment   = Enum.TextXAlignment.Left,
                Parent           = ddBtn,
            })

            Create("TextLabel", {
                BackgroundTransparency = 1,
                Size             = UDim2.new(0, 16, 1, 0),
                Position         = UDim2.new(1, -18, 0, 0),
                Text             = "v",
                TextColor3       = T.TextSecondary,
                TextSize         = 9,
                Font             = Enum.Font.GothamBold,
                Parent           = ddBtn,
            })

            local dropdown = Create("Frame", {
                BackgroundColor3 = T.Surface,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 148, 0, 0),
                Position         = UDim2.new(0, 0, 0, 0),
                ClipsDescendants = true,
                ZIndex           = 200,
                Visible          = false,
                Parent           = sg,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = dropdown })
            Create("UIStroke",  { Color = T.Border, Thickness = 1, Parent = dropdown })
            local ddList = Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = dropdown })

            local _ddTween = nil
            local function _TweenDd(props, dur)
                if _ddTween then pcall(function() _ddTween:Cancel() end) end
                local info = TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                _ddTween = TweenService:Create(dropdown, info, props)
                _ddTween:Play()
            end

            local function CloseDropdown()
                if open then
                    open = false
                    _TweenDd({ Size = UDim2.new(0, 148, 0, 0) }, 0.12)
                    task.delay(0.13, function()
                        if not open then pcall(function() dropdown.Visible = false end) end
                    end)
                end
            end

            for _, item in ipairs(items) do
                local itemBtn = Create("TextButton", {
                    BackgroundTransparency = 1,
                    BorderSizePixel  = 0,
                    Size             = UDim2.new(1, 0, 0, 28),
                    Text             = item,
                    TextColor3       = T.TextPrimary,
                    TextSize         = 11,
                    Font             = Enum.Font.Gotham,
                    ZIndex           = 11,
                    Parent           = dropdown,
                })
                itemBtn.MouseEnter:Connect(function()
                    itemBtn.BackgroundColor3 = T.Accent
                    Tween(itemBtn, { BackgroundTransparency = 0.8 }, 0.1)
                end)
                itemBtn.MouseLeave:Connect(function()
                    itemBtn.BackgroundColor3 = T.Surface
                    Tween(itemBtn, { BackgroundTransparency = 1 }, 0.1)
                end)
                itemBtn.MouseButton1Click:Connect(function()
                    selected     = item
                    ddLabel.Text = item
                    _activePopup = nil
                    CloseDropdown()
                    callback(selected)
                end)
            end

            ddBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    if _activePopup and _activePopup.frame == dropdown then
                        _activePopup = nil
                    end
                    _RegisterPopup(CloseDropdown, dropdown, ddBtn)
                    local ap = ddBtn.AbsolutePosition
                    local as = ddBtn.AbsoluteSize
                    dropdown.Size = UDim2.new(0, 148, 0, 0)
                    dropdown.Position = UDim2.new(0, ap.X, 0, ap.Y + as.Y + 4)
                    dropdown.Visible = true
                    local h = math.min(#items * 28, 140)
                    _TweenDd({ Size = UDim2.new(0, 148, 0, h) }, 0.18)
                else
                    _activePopup = nil
                    _TweenDd({ Size = UDim2.new(0, 148, 0, 0) }, 0.12)
                    task.delay(0.13, function()
                        if not open then pcall(function() dropdown.Visible = false end) end
                    end)
                end
            end)

            el.MouseEnter:Connect(function() Tween(el, { BackgroundColor3 = T.SurfaceAlt }, 0.1) end)
            el.MouseLeave:Connect(function() Tween(el, { BackgroundColor3 = T.Surface }, 0.1) end)

            local ctrl = {}
            function ctrl:Set(val)
                selected     = val
                ddLabel.Text = val
                callback(val)
            end
            function ctrl:Get() return selected end
            return ctrl
        end

        function Tab:CreateKeybind(opts)
            opts = opts or {}
            local name     = opts.Name     or "Keybind"
            local desc     = opts.Desc     or ""
            local default  = opts.Default  or Enum.KeyCode.RightShift
            local callback = opts.Callback or function() end

            local listening = false
            local current   = default

            local el = BaseElement(46)
            NameDesc(el, name, desc)

            local kbBtn = Create("TextButton", {
                BackgroundColor3 = T.SurfaceAlt,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 90, 0, 26),
                Position         = UDim2.new(1, -102, 0.5, -13),
                Text             = tostring(current.Name),
                TextColor3       = T.TextAccent,
                TextSize         = 11,
                Font             = Enum.Font.GothamBold,
                Parent           = el,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = kbBtn })
            Create("UIStroke",  { Color = T.Border, Thickness = 1, Parent = kbBtn })

            kbBtn.MouseButton1Click:Connect(function()
                if listening then return end
                listening    = true
                kbBtn.Text   = "[ . . . ]"
                kbBtn.TextColor3 = T.TextSecondary
            end)

            UserInputService.InputBegan:Connect(function(inp, gpe)
                if not _windowActive then listening = false; return end
                if not listening then return end
                if gpe then return end
                if inp.UserInputType == Enum.UserInputType.Keyboard then
                    current          = inp.KeyCode
                    kbBtn.Text       = tostring(current.Name)
                    kbBtn.TextColor3 = T.TextAccent
                    listening        = false
                    callback(current)
                end
            end)

            el.MouseEnter:Connect(function() Tween(el, { BackgroundColor3 = T.SurfaceAlt }, 0.1) end)
            el.MouseLeave:Connect(function() Tween(el, { BackgroundColor3 = T.Surface }, 0.1) end)

            local ctrl = {}
            function ctrl:Get() return current end
            return ctrl
        end

        function Tab:CreateColorPicker(opts)
            opts = opts or {}
            local name     = opts.Name     or "Color"
            local desc     = opts.Desc     or ""
            local default  = opts.Default  or Color3.fromRGB(80, 110, 240)
            local callback = opts.Callback or function() end

            local function HSVtoColor3(h, s, v)
                h = h % 360
                local c = v * s
                local x = c * (1 - math.abs((h / 60) % 2 - 1))
                local m = v - c
                local r1, g1, b1
                if     h < 60  then r1,g1,b1 = c,x,0
                elseif h < 120 then r1,g1,b1 = x,c,0
                elseif h < 180 then r1,g1,b1 = 0,c,x
                elseif h < 240 then r1,g1,b1 = 0,x,c
                elseif h < 300 then r1,g1,b1 = x,0,c
                else            r1,g1,b1 = c,0,x
                end
                return Color3.new(r1+m, g1+m, b1+m)
            end

            local function Color3toHSV(col)
                local r,g,b = col.R, col.G, col.B
                local maxC  = math.max(r,g,b)
                local minC  = math.min(r,g,b)
                local delta = maxC - minC
                local h,s,v = 0, 0, maxC
                if maxC > 0 then s = delta / maxC end
                if delta > 0 then
                    if maxC == r then h = 60 * (((g-b)/delta) % 6)
                    elseif maxC == g then h = 60 * ((b-r)/delta + 2)
                    else h = 60 * ((r-g)/delta + 4)
                    end
                end
                if h < 0 then h = h + 360 end
                return h, s, v
            end

            local curH, curS, curV = Color3toHSV(default)
            local selected = default
            local open = false

            local el = BaseElement(46)
            el.ClipsDescendants = false
            NameDesc(el, name, desc)

            local swatch = Create("TextButton", {
                BackgroundColor3 = selected,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 32, 0, 24),
                Position         = UDim2.new(1, -44, 0.5, -12),
                Text             = "",
                Parent           = el,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = swatch })
            Create("UIStroke",  { Color = T.Border, Thickness = 1.5, Parent = swatch })

            local PICKER_W = 224
            local PICKER_H = 196

            local picker = Create("Frame", {
                BackgroundColor3 = T.Surface,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, PICKER_W, 0, 0),
                Position         = UDim2.new(0, 0, 0, 0),
                ClipsDescendants = true,
                ZIndex           = 200,
                Visible          = false,
                Parent           = sg,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 9), Parent = picker })
            Create("UIStroke",  { Color = T.Border, Thickness = 1, Parent = picker })

            local preview = Create("Frame", {
                BackgroundColor3 = selected,
                BorderSizePixel  = 0,
                Size             = UDim2.new(1, -16, 0, 44),
                Position         = UDim2.new(0, 8, 0, 10),
                ZIndex           = 201,
                Parent           = picker,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = preview })

            local hexLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size             = UDim2.new(1, 0, 1, 0),
                Text             = "",
                TextColor3       = Color3.fromRGB(255,255,255),
                TextSize         = 10,
                Font             = Enum.Font.GothamBold,
                TextXAlignment   = Enum.TextXAlignment.Center,
                TextYAlignment   = Enum.TextYAlignment.Center,
                ZIndex           = 202,
                Parent           = preview,
            })

            local function UpdateDisplay(col)
                selected = col
                swatch.BackgroundColor3  = col
                preview.BackgroundColor3 = col
                local r = math.floor(col.R * 255 + 0.5)
                local g = math.floor(col.G * 255 + 0.5)
                local b = math.floor(col.B * 255 + 0.5)
                hexLabel.Text = r..", "..g..", "..b
                local lum = 0.299*col.R + 0.587*col.G + 0.114*col.B
                hexLabel.TextColor3 = lum > 0.5 and Color3.fromRGB(20,20,20) or Color3.fromRGB(240,240,240)
                callback(col)
            end

            local function SectionLabel(text, yPos)
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size             = UDim2.new(1, -16, 0, 14),
                    Position         = UDim2.new(0, 8, 0, yPos),
                    Text             = text,
                    TextColor3       = T.TextSecondary,
                    TextSize         = 9,
                    Font             = Enum.Font.GothamBold,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    ZIndex           = 201,
                    Parent           = picker,
                })
            end

            SectionLabel("HUE", 62)

            local hueStrip = Create("Frame", {
                BackgroundColor3       = Color3.fromRGB(0,0,0),
                BackgroundTransparency = 1,
                BorderSizePixel        = 0,
                Size                   = UDim2.new(1, -16, 0, 18),
                Position               = UDim2.new(0, 8, 0, 76),
                ZIndex                 = 201,
                ClipsDescendants       = true,
                Parent                 = picker,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = hueStrip })

            local HUE_SLICES = 72
            for i = 0, HUE_SLICES - 1 do
                local hue = (i / HUE_SLICES) * 360
                Create("Frame", {
                    BackgroundColor3 = HSVtoColor3(hue, 1, 1),
                    BorderSizePixel  = 0,
                    Size             = UDim2.new(1/HUE_SLICES, 1, 1, 0),
                    Position         = UDim2.new(i/HUE_SLICES, 0, 0, 0),
                    ZIndex           = 202,
                    Parent           = hueStrip,
                })
            end

            local hueCursor = Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 3, 1, 4),
                AnchorPoint      = Vector2.new(0.5, 0.5),
                Position         = UDim2.new(curH/360, 0, 0.5, 0),
                ZIndex           = 204,
                Parent           = hueStrip,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 2), Parent = hueCursor })

            local hueBtn = Create("TextButton", {
                BackgroundTransparency = 1,
                BorderSizePixel        = 0,
                Size                   = UDim2.new(1, 0, 1, 0),
                Text                   = "",
                ZIndex                 = 205,
                Parent                 = hueStrip,
            })

            SectionLabel("SATURATION", 102)

            local satStrip = Create("Frame", {
                BackgroundTransparency = 1,
                BorderSizePixel        = 0,
                Size                   = UDim2.new(1, -16, 0, 18),
                Position               = UDim2.new(0, 8, 0, 116),
                ZIndex                 = 201,
                ClipsDescendants       = true,
                Parent                 = picker,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = satStrip })

            local SAT_SLICES = 36
            local satSliceFrames = {}
            for i = 0, SAT_SLICES - 1 do
                local s = i / (SAT_SLICES - 1)
                local f = Create("Frame", {
                    BackgroundColor3 = HSVtoColor3(curH, s, curV),
                    BorderSizePixel  = 0,
                    Size             = UDim2.new(1/SAT_SLICES, 1, 1, 0),
                    Position         = UDim2.new(i/SAT_SLICES, 0, 0, 0),
                    ZIndex           = 202,
                    Parent           = satStrip,
                })
                table.insert(satSliceFrames, f)
            end

            local satCursor = Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 3, 1, 4),
                AnchorPoint      = Vector2.new(0.5, 0.5),
                Position         = UDim2.new(curS, 0, 0.5, 0),
                ZIndex           = 204,
                Parent           = satStrip,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 2), Parent = satCursor })

            local satBtn = Create("TextButton", {
                BackgroundTransparency = 1,
                BorderSizePixel        = 0,
                Size                   = UDim2.new(1, 0, 1, 0),
                Text                   = "",
                ZIndex                 = 205,
                Parent                 = satStrip,
            })

            SectionLabel("BRIGHTNESS", 142)

            local briStrip = Create("Frame", {
                BackgroundTransparency = 1,
                BorderSizePixel        = 0,
                Size                   = UDim2.new(1, -16, 0, 18),
                Position               = UDim2.new(0, 8, 0, 156),
                ZIndex                 = 201,
                ClipsDescendants       = true,
                Parent                 = picker,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = briStrip })

            local BRI_SLICES = 36
            local briSliceFrames = {}
            for i = 0, BRI_SLICES - 1 do
                local v = i / (BRI_SLICES - 1)
                local f = Create("Frame", {
                    BackgroundColor3 = HSVtoColor3(curH, curS, v),
                    BorderSizePixel  = 0,
                    Size             = UDim2.new(1/BRI_SLICES, 1, 1, 0),
                    Position         = UDim2.new(i/BRI_SLICES, 0, 0, 0),
                    ZIndex           = 202,
                    Parent           = briStrip,
                })
                table.insert(briSliceFrames, f)
            end

            local briCursor = Create("Frame", {
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 3, 1, 4),
                AnchorPoint      = Vector2.new(0.5, 0.5),
                Position         = UDim2.new(curV, 0, 0.5, 0),
                ZIndex           = 204,
                Parent           = briStrip,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 2), Parent = briCursor })

            local briBtn = Create("TextButton", {
                BackgroundTransparency = 1,
                BorderSizePixel        = 0,
                Size                   = UDim2.new(1, 0, 1, 0),
                Text                   = "",
                ZIndex                 = 205,
                Parent                 = briStrip,
            })

            local function RefreshSatStrip()
                for i, f in ipairs(satSliceFrames) do
                    local s = (i-1) / (SAT_SLICES - 1)
                    f.BackgroundColor3 = HSVtoColor3(curH, s, curV)
                end
            end
            local function RefreshBriStrip()
                for i, f in ipairs(briSliceFrames) do
                    local v = (i-1) / (BRI_SLICES - 1)
                    f.BackgroundColor3 = HSVtoColor3(curH, curS, v)
                end
            end

            local function MakeStripDraggable(btn, strip, cursor, onUpdate)
                local dragging = false
                local function Eval(inputX)
                    local sx  = strip.AbsolutePosition.X
                    local sw  = strip.AbsoluteSize.X
                    local pct = math.clamp((inputX - sx) / sw, 0, 1)
                    cursor.Position = UDim2.new(pct, 0, 0.5, 0)
                    onUpdate(pct)
                end
                btn.MouseButton1Down:Connect(function()
                    dragging = true
                    Eval(Mouse.X)
                end)
                RunService.RenderStepped:Connect(function()
                    if not _windowActive then dragging = false; return end
                    if dragging then Eval(Mouse.X) end
                end)
                btn.MouseMoved:Connect(function(x, _)
                    if dragging then Eval(x) end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if not _windowActive then dragging = false; return end
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
            end

            MakeStripDraggable(hueBtn, hueStrip, hueCursor, function(pct)
                curH = pct * 360
                RefreshSatStrip()
                RefreshBriStrip()
                UpdateDisplay(HSVtoColor3(curH, curS, curV))
            end)

            MakeStripDraggable(satBtn, satStrip, satCursor, function(pct)
                curS = pct
                RefreshBriStrip()
                UpdateDisplay(HSVtoColor3(curH, curS, curV))
            end)

            MakeStripDraggable(briBtn, briStrip, briCursor, function(pct)
                curV = pct
                UpdateDisplay(HSVtoColor3(curH, curS, curV))
            end)

            local _lastToggleTime  = 0
            local _TOGGLE_COOLDOWN = 0.28
            local _inputJustClosed = false

            local function ClosePicker()
                if not open then return end
                open = false
                _inputJustClosed  = true
                _lastToggleTime   = os.clock()
                task.defer(function() _inputJustClosed = false end)
                Tween(picker, { Size = UDim2.new(0, PICKER_W, 0, 0) }, 0.14)
                task.delay(0.15, function()
                    if not open then pcall(function() picker.Visible = false end) end
                end)
            end

            local function OpenPicker()
                if open then return end
                open = true
                _lastToggleTime = os.clock()
                _RegisterPopup(ClosePicker, picker)
                local ap = swatch.AbsolutePosition
                local as = swatch.AbsoluteSize
                picker.Size     = UDim2.new(0, PICKER_W, 0, 0)
                picker.Position = UDim2.new(0, ap.X - PICKER_W + as.X, 0, ap.Y + as.Y + 6)
                picker.Visible  = true
                UpdateDisplay(selected)
                Tween(picker, { Size = UDim2.new(0, PICKER_W, 0, PICKER_H) }, 0.2)
            end

            swatch.MouseButton1Click:Connect(function()
                if _inputJustClosed then
                    _inputJustClosed = false
                    return
                end
                if os.clock() - _lastToggleTime < _TOGGLE_COOLDOWN then return end
                if open then
                    _activePopup = nil
                    ClosePicker()
                else
                    OpenPicker()
                end
            end)

            el.MouseEnter:Connect(function() Tween(el, { BackgroundColor3 = T.SurfaceAlt }, 0.1) end)
            el.MouseLeave:Connect(function() Tween(el, { BackgroundColor3 = T.Surface }, 0.1) end)

            UpdateDisplay(selected)

            local ctrl = {}
            function ctrl:Set(col)
                selected = col
                curH, curS, curV = Color3toHSV(col)
                hueCursor.Position = UDim2.new(curH/360, 0, 0.5, 0)
                satCursor.Position = UDim2.new(curS, 0, 0.5, 0)
                briCursor.Position = UDim2.new(curV, 0, 0.5, 0)
                RefreshSatStrip()
                RefreshBriStrip()
                UpdateDisplay(col)
            end
            function ctrl:Get() return selected end
            return ctrl
        end

        function Tab:CreateLabel(text)
            local el = Create("Frame", {
                BackgroundTransparency = 1,
                Size   = UDim2.new(1, 0, 0, 24),
                Parent = scrollFrame,
            })
            local lbl = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size             = UDim2.new(1, 0, 1, 0),
                Text             = text,
                TextColor3       = T.TextSecondary,
                TextSize         = 11,
                Font             = Enum.Font.Gotham,
                TextXAlignment   = Enum.TextXAlignment.Left,
                TextWrapped      = true,
                Parent           = el,
            })
            local ctrl = {}
            function ctrl:Set(t) lbl.Text = t end
            return ctrl
        end

        function Tab:CreateSeparator()
            Create("Frame", {
                BackgroundColor3 = T.Border,
                BorderSizePixel  = 0,
                Size             = UDim2.new(1, 0, 0, 1),
                Parent           = scrollFrame,
            })
        end

        function Tab:CreatePlayerSelector(opts)
            opts = opts or {}
            local name     = opts.Name     or "Player"
            local desc     = opts.Desc     or ""
            local callback = opts.Callback or function() end

            local selected = nil

            local el = BaseElement(46)
            NameDesc(el, name, desc)

            local psBtn = Create("TextButton", {
                BackgroundColor3 = T.SurfaceAlt,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 148, 0, 26),
                Position         = UDim2.new(1, -160, 0.5, -13),
                Text             = "",
                Parent           = el,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = psBtn })
            Create("UIStroke",  { Color = T.Border, Thickness = 1, Parent = psBtn })

            local btnAvatar = Create("ImageLabel", {
                BackgroundTransparency = 1,
                Size              = UDim2.new(0, 20, 0, 20),
                Position          = UDim2.new(0, 4, 0.5, -10),
                Image             = "",
                ImageTransparency = 1,
                Visible           = false,
                Parent            = psBtn,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = btnAvatar })

            local btnLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Size             = UDim2.new(1, -10, 1, 0),
                Position         = UDim2.new(0, 8, 0, 0),
                Text             = "Select player...",
                TextColor3       = T.TextSecondary,
                TextSize         = 10,
                Font             = Enum.Font.Gotham,
                TextXAlignment   = Enum.TextXAlignment.Left,
                TextTruncate     = Enum.TextTruncate.AtEnd,
                Parent           = psBtn,
            })

            local popup = Create("Frame", {
                BackgroundColor3 = T.Surface,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 148, 0, 0),
                Position         = UDim2.new(0, 0, 0, 0),
                ClipsDescendants = true,
                ZIndex           = 200,
                Visible          = false,
                Parent           = sg,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = popup })
            Create("UIStroke",  { Color = T.Border, Thickness = 1, Parent = popup })

            local popupScroll = Create("ScrollingFrame", {
                BackgroundTransparency = 1,
                BorderSizePixel        = 0,
                Size                   = UDim2.new(1, 0, 1, 0),
                CanvasSize             = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness     = 3,
                ScrollBarImageColor3   = T.Scrollbar,
                AutomaticCanvasSize    = Enum.AutomaticSize.Y,
                ZIndex                 = 201,
                Parent                 = popup,
            })
            Create("UIListLayout", {
                SortOrder     = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Vertical,
                Padding       = UDim.new(0, 2),
                Parent        = popupScroll,
            })
            Create("UIPadding", {
                PaddingTop    = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft   = UDim.new(0, 4),
                PaddingRight  = UDim.new(0, 4),
                Parent        = popupScroll,
            })

            local open = false

            local _psTween = nil
            local function _TweenPs(props, dur)
                if _psTween then pcall(function() _psTween:Cancel() end) end
                local info = TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                _psTween = TweenService:Create(popup, info, props)
                _psTween:Play()
            end

            local function ClosePlayerSelector()
                if open then
                    open = false
                    _TweenPs({ Size = UDim2.new(0, 148, 0, 0) }, 0.12)
                    task.delay(0.13, function()
                        if not open then pcall(function() popup.Visible = false end) end
                    end)
                end
            end

            local function LoadAvatar(userId, imgLabel)
                task.spawn(function()
                    local ok, url = pcall(function()
                        return Players:GetUserThumbnailAsync(
                            userId,
                            Enum.ThumbnailType.HeadShot,
                            Enum.ThumbnailSize.Size48x48
                        )
                    end)
                    if ok and url and imgLabel.Parent then
                        imgLabel.Image = url
                    end
                end)
            end

            local function RefreshList()
                for _, child in ipairs(popupScroll:GetChildren()) do
                    if child:IsA("Frame") or child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                local allPlayers = Players:GetPlayers()
                for _, plr in ipairs(allPlayers) do
                    local row = Create("TextButton", {
                        BackgroundColor3       = T.SurfaceAlt,
                        BackgroundTransparency = 0.4,
                        BorderSizePixel        = 0,
                        Size                   = UDim2.new(1, 0, 0, 42),
                        Text                   = "",
                        ZIndex                 = 202,
                        Parent                 = popupScroll,
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = row })

                    local avatarImg = Create("ImageLabel", {
                        BackgroundColor3 = T.Border,
                        BorderSizePixel  = 0,
                        Size             = UDim2.new(0, 32, 0, 32),
                        Position         = UDim2.new(0, 5, 0.5, -16),
                        Image            = "rbxassetid://1",
                        ZIndex           = 203,
                        Parent           = row,
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = avatarImg })
                    LoadAvatar(plr.UserId, avatarImg)

                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Size             = UDim2.new(1, -46, 0, 20),
                        Position         = UDim2.new(0, 42, 0, 4),
                        Text             = plr.DisplayName,
                        TextColor3       = T.TextPrimary,
                        TextSize         = 11,
                        Font             = Enum.Font.GothamBold,
                        TextXAlignment   = Enum.TextXAlignment.Left,
                        TextTruncate     = Enum.TextTruncate.AtEnd,
                        ZIndex           = 203,
                        Parent           = row,
                    })
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Size             = UDim2.new(1, -46, 0, 14),
                        Position         = UDim2.new(0, 42, 0, 22),
                        Text             = "@" .. plr.Name,
                        TextColor3       = T.TextSecondary,
                        TextSize         = 9,
                        Font             = Enum.Font.Gotham,
                        TextXAlignment   = Enum.TextXAlignment.Left,
                        TextTruncate     = Enum.TextTruncate.AtEnd,
                        ZIndex           = 203,
                        Parent           = row,
                    })

                    row.MouseEnter:Connect(function()
                        Tween(row, { BackgroundTransparency = 0.1 }, 0.1)
                    end)
                    row.MouseLeave:Connect(function()
                        Tween(row, { BackgroundTransparency = 0.4 }, 0.1)
                    end)

                    row.MouseButton1Click:Connect(function()
                        selected                  = plr
                        btnLabel.Text             = plr.DisplayName
                        btnLabel.TextColor3       = T.TextPrimary
                        btnLabel.Size             = UDim2.new(1, -32, 1, 0)
                        btnLabel.Position         = UDim2.new(0, 28, 0, 0)
                        btnAvatar.Visible         = true
                        btnAvatar.ImageTransparency = 0
                        LoadAvatar(plr.UserId, btnAvatar)
                        _activePopup = nil
                        ClosePlayerSelector()
                        callback(plr)
                    end)
                end
            end

            psBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    if _activePopup and _activePopup.frame == popup then
                        _activePopup = nil
                    end
                    RefreshList()
                    _RegisterPopup(ClosePlayerSelector, popup, psBtn)
                    local ap  = psBtn.AbsolutePosition
                    local as  = psBtn.AbsoluteSize
                    local pw  = 148
                    local mp  = main.AbsolutePosition
                    local ms  = main.AbsoluteSize
                    local px  = math.clamp(ap.X, mp.X, mp.X + ms.X - pw)
                    popup.Size     = UDim2.new(0, pw, 0, 0)
                    popup.Position = UDim2.new(0, px, 0, ap.Y + as.Y + 4)
                    popup.Visible  = true
                    local count = math.max(1, #Players:GetPlayers())
                    local h = math.min(count * 44, 200)
                    _TweenPs({ Size = UDim2.new(0, pw, 0, h) }, 0.18)
                else
                    _activePopup = nil
                    _TweenPs({ Size = UDim2.new(0, 148, 0, 0) }, 0.12)
                    task.delay(0.13, function()
                        if not open then pcall(function() popup.Visible = false end) end
                    end)
                end
            end)

            el.MouseEnter:Connect(function() Tween(el, { BackgroundColor3 = T.SurfaceAlt }, 0.1) end)
            el.MouseLeave:Connect(function() Tween(el, { BackgroundColor3 = T.Surface }, 0.1) end)

            Players.PlayerRemoving:Connect(function(plr)
                if open then
                    RefreshList()
                end
                if selected == plr then
                    selected                  = nil
                    btnLabel.Text             = "Select player..."
                    btnLabel.TextColor3       = T.TextSecondary
                    btnLabel.Size             = UDim2.new(1, -10, 1, 0)
                    btnLabel.Position         = UDim2.new(0, 8, 0, 0)
                    btnAvatar.Visible         = false
                    btnAvatar.Image           = ""
                    pcall(function() callback(nil) end)
                end
            end)

            local ctrl = {}
            function ctrl:Get() return selected end
            function ctrl:Set(plr)
                selected = plr
                if plr then
                    btnLabel.Text             = plr.DisplayName
                    btnLabel.TextColor3       = T.TextPrimary
                    btnLabel.Size             = UDim2.new(1, -32, 1, 0)
                    btnLabel.Position         = UDim2.new(0, 28, 0, 0)
                    btnAvatar.Visible         = true
                    btnAvatar.ImageTransparency = 0
                    LoadAvatar(plr.UserId, btnAvatar)
                else
                    btnLabel.Text             = "Select player..."
                    btnLabel.TextColor3       = T.TextSecondary
                    btnLabel.Size             = UDim2.new(1, -10, 1, 0)
                    btnLabel.Position         = UDim2.new(0, 8, 0, 0)
                    btnAvatar.Visible         = false
                    btnAvatar.Image           = ""
                end
                callback(plr)
            end
            return ctrl
        end

        function Tab:CreateTextDisplay(opts)
            opts = opts or {}
            local name    = opts.Name    or "Text Display"
            local desc    = opts.Desc    or ""
            local text    = opts.Text    or ""
            local copying = opts.Copying ~= nil and opts.Copying or false

            local LINE_H  = 20
            local HEADER_H = 32
            local MAX_DISPLAY_H = 180
            local NUM_W = 34

            local container = Create("Frame", {
                BackgroundColor3 = T.Surface,
                BorderSizePixel  = 0,
                Size             = UDim2.new(1, 0, 0, HEADER_H + MAX_DISPLAY_H),
                ClipsDescendants = false,
                Parent           = scrollFrame,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = container })
            Create("UIStroke",  { Color = T.Border, Thickness = 1, Parent = container })

            local header = Create("Frame", {
                BackgroundColor3 = T.SurfaceAlt,
                BorderSizePixel  = 0,
                Size             = UDim2.new(1, 0, 0, HEADER_H),
                ClipsDescendants = true,
                Parent           = container,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = header })
            Create("Frame", {
                BackgroundColor3 = T.SurfaceAlt,
                BorderSizePixel  = 0,
                Size             = UDim2.new(1, 0, 0, 8),
                Position         = UDim2.new(0, 0, 1, -8),
                Parent           = header,
            })

            Create("TextLabel", {
                BackgroundTransparency = 1,
                Size             = UDim2.new(1, -90, 1, 0),
                Position         = UDim2.new(0, 12, 0, 0),
                Text             = name,
                TextColor3       = T.TextPrimary,
                TextSize         = 12,
                Font             = Enum.Font.GothamSemibold,
                TextXAlignment   = Enum.TextXAlignment.Left,
                Parent           = header,
            })

            local copyBtn = Create("TextButton", {
                BackgroundColor3 = T.Accent,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 66, 0, 22),
                Position         = UDim2.new(1, -74, 0.5, -11),
                Text             = "Copy",
                TextColor3       = Color3.fromRGB(255, 255, 255),
                TextSize         = 11,
                Font             = Enum.Font.GothamBold,
                Visible          = copying,
                Parent           = header,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = copyBtn })

            copyBtn.MouseEnter:Connect(function()
                Tween(copyBtn, { BackgroundColor3 = T.AccentHover }, 0.1)
            end)
            copyBtn.MouseLeave:Connect(function()
                Tween(copyBtn, { BackgroundColor3 = T.Accent }, 0.1)
            end)

            Create("Frame", {
                BackgroundColor3 = T.Border,
                BorderSizePixel  = 0,
                Size             = UDim2.new(1, 0, 0, 1),
                Position         = UDim2.new(0, 0, 1, -1),
                Parent           = header,
            })

            local lineNumCol = Create("Frame", {
                BackgroundColor3 = T.SurfaceAlt,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, NUM_W, 1, -HEADER_H),
                Position         = UDim2.new(0, 0, 0, HEADER_H),
                ClipsDescendants = true,
                Parent           = container,
            })
            Create("Frame", {
                BackgroundColor3 = T.Border,
                BorderSizePixel  = 0,
                Size             = UDim2.new(0, 1, 1, 0),
                Position         = UDim2.new(1, -1, 0, 0),
                Parent           = lineNumCol,
            })

            local lineNumScroll = Create("ScrollingFrame", {
                BackgroundTransparency = 1,
                BorderSizePixel        = 0,
                Size                   = UDim2.new(1, 0, 1, 0),
                CanvasSize             = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize    = Enum.AutomaticSize.Y,
                ScrollBarThickness     = 0,
                ScrollingEnabled       = false,
                Parent                 = lineNumCol,
            })
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent    = lineNumScroll,
            })

            local textScroll = Create("ScrollingFrame", {
                BackgroundTransparency = 1,
                BorderSizePixel        = 0,
                Size                   = UDim2.new(1, -NUM_W, 1, -HEADER_H),
                Position               = UDim2.new(0, NUM_W, 0, HEADER_H),
                CanvasSize             = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize    = Enum.AutomaticSize.Y,
                ScrollBarThickness     = 3,
                ScrollBarImageColor3   = T.Scrollbar,
                Parent                 = container,
            })
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding   = UDim.new(0, 0),
                Parent    = textScroll,
            })
            Create("UIPadding", {
                PaddingLeft   = UDim.new(0, 8),
                PaddingRight  = UDim.new(0, 8),
                PaddingTop    = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4),
                Parent        = textScroll,
            })

            textScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                lineNumScroll.CanvasPosition = Vector2.new(0, textScroll.CanvasPosition.Y)
            end)

            local currentLineLabels = {}
            local currentNumLabels  = {}

            local function RenderLines(t)
                for _, v in ipairs(currentLineLabels) do pcall(function() v:Destroy() end) end
                for _, v in ipairs(currentNumLabels)  do pcall(function() v:Destroy() end) end
                currentLineLabels = {}
                currentNumLabels  = {}

                local lines = t ~= "" and t:split("\n") or {""}
                for i, line in ipairs(lines) do
                    local numLbl = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Size             = UDim2.new(1, 0, 0, LINE_H),
                        Text             = tostring(i),
                        TextColor3       = T.TextSecondary,
                        TextSize         = 10,
                        Font             = Enum.Font.GothamBold,
                        TextXAlignment   = Enum.TextXAlignment.Center,
                        TextYAlignment   = Enum.TextYAlignment.Center,
                        LayoutOrder      = i,
                        Parent           = lineNumScroll,
                    })
                    table.insert(currentNumLabels, numLbl)

                    local textLbl = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Size             = UDim2.new(1, 0, 0, LINE_H),
                        Text             = line,
                        TextColor3       = T.TextPrimary,
                        TextSize         = 11,
                        Font             = Enum.Font.Code,
                        TextXAlignment   = Enum.TextXAlignment.Left,
                        TextYAlignment   = Enum.TextYAlignment.Center,
                        TextWrapped      = false,
                        TextTruncate     = Enum.TextTruncate.AtEnd,
                        LayoutOrder      = i,
                        Parent           = textScroll,
                    })
                    table.insert(currentLineLabels, textLbl)
                end
            end

            RenderLines(text)

            copyBtn.MouseButton1Click:Connect(function()
                if setclipboard then
                    pcall(function() setclipboard(text) end)
                end
                NexusUI:Notify({ Title = "Copied!", Message = "Text copied to clipboard.", Type = "Success" })
            end)

            local ctrl = {}
            function ctrl:SetText(t)
                text = t or ""
                RenderLines(text)
            end
            function ctrl:GetText() return text end
            function ctrl:SetCopying(val)
                copying = val
                copyBtn.Visible = val
            end
            function ctrl:GetCopying() return copying end
            return ctrl
        end

        return Tab
    end

    local function _PopulateAboutUs(tab)
        tab:CreateSection("Library")
        tab:CreateLabel("Nexus — UI Library  —  v1.0.0")
        tab:CreateLabel("A lightweight Roblox UI library designed for clean, modern menus with smooth responsive controls.")
        tab:CreateSeparator()

        tab:CreateSection("Source Code")
        tab:CreateButton({
            Name     = "Copy Raw Library URL",
            Desc     = "github.com/mumya1god/nexus",
            BtnText  = "Copy",
            Callback = function()
                local link = "https://raw.githubusercontent.com/mumya1god/nexus/refs/heads/main/library.lua"
                if setclipboard then setclipboard(link) end
                NexusUI:Notify({ Title = "Copied!", Message = "Library URL copied to clipboard.", Type = "Success" })
            end,
        })
        tab:CreateSeparator()

        tab:CreateSection("Contact & Socials")
        tab:CreateButton({
            Name     = "Discord",
            Desc     = "@Sucluluk",
            BtnText  = "Info",
            Callback = function()
                NexusUI:Notify({ Title = "Discord", Message = "@Sucluluk", Type = "Info" })
            end,
        })
        tab:CreateButton({
            Name     = "YouTube",
            Desc     = "@MumiaBet",
            BtnText  = "Info",
            Callback = function()
                NexusUI:Notify({ Title = "YouTube", Message = "@MumiaBet", Type = "Info" })
            end,
        })
        tab:CreateSeparator()

        tab:CreateSection("Menu Keybind")
        tab:CreateKeybind({
            Name     = "Toggle Menu",
            Desc     = "Press to show / hide the menu",
            Default  = Enum.KeyCode.RightShift,
            Callback = function(key)
                _menuToggleKey = key
            end,
        })
        tab:CreateSeparator()

        tab:CreateLabel("Thanks for using NexusUI Made with care by MUMYA")
    end

    function _BuildAboutUsTab()
        local aboutTab = Window:CreateTab("About Us")
        if aboutTab._tabLabel and pcall(function() local _ = aboutTab._tabLabel.LayoutOrder end) then
            aboutTab._tabLabel.LayoutOrder = 9999
        end
        _PopulateAboutUs(aboutTab)
    end

    do
        local panelTab = Window:CreateTab("__aboutus_panel__", aboutUsPanelScroll)
        _PopulateAboutUs(panelTab)
    end

    local _defaultTab = Window:CreateTab("__default__", singleScroll)
    Window._defaultTab = _defaultTab

    function Window:CreateSection(t)       return self._defaultTab:CreateSection(t) end
    function Window:CreateLabel(t)         return self._defaultTab:CreateLabel(t) end
    function Window:CreateSeparator()      return self._defaultTab:CreateSeparator() end
    function Window:CreateToggle(o)        return self._defaultTab:CreateToggle(o) end
    function Window:CreateButton(o)        return self._defaultTab:CreateButton(o) end
    function Window:CreateSlider(o)        return self._defaultTab:CreateSlider(o) end
    function Window:CreateDropdown(o)      return self._defaultTab:CreateDropdown(o) end
    function Window:CreateColorPicker(o)   return self._defaultTab:CreateColorPicker(o) end
    function Window:CreateInput(o)         return self._defaultTab:CreateInput(o) end
    function Window:CreateKeybind(o)       return self._defaultTab:CreateKeybind(o) end
    function Window:CreatePlayerSelector(o)       return self._defaultTab:CreatePlayerSelector(o) end
    function Window:CreateTextDisplay(o)          return self._defaultTab:CreateTextDisplay(o) end

    function Window:Notify(opts)
        NexusUI:Notify(opts)
    end

    function Window:Destroy()
        _windowActive = false
        sg:Destroy()
        if shared then
            shared.NexusUIWindow = nil
            shared.NexusUINotify = nil
            shared.NexusUIGui = nil
        end
    end

    if shared then
        shared.NexusUIWindow = Window
        shared.NexusUINotify = function(opts) NexusUI:Notify(opts) end
        shared.NexusUIGui = sg
    end

    return Window
end

return NexusUI
