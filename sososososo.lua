local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Centrix = {}
Centrix.__index = Centrix

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

local function tween(obj, time, style, direction, props)
    local info = TweenInfo.new(time, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function getGuiParent()
    local ok, coreGui = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok and coreGui then
        return coreGui
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function createBaseGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "CentrixHub"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.IgnoreGuiInset = true
    gui.Parent = getGuiParent()
    return gui
end

local function createMainWindow(gui, titleText)
    local root = Instance.new("Frame")
    root.Name = "CentrixRoot"
    root.Parent = gui
    root.AnchorPoint = Vector2.new(0.5, 0.5)
    root.Position = UDim2.fromScale(0.5, 0.5)
    root.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    root.BackgroundTransparency = 0.05
    root.ClipsDescendants = true
    root.Size = UDim2.fromScale(0.02, 0.02)

    local rootCorner = Instance.new("UICorner")
    rootCorner.CornerRadius = UDim.new(0, 10)
    rootCorner.Parent = root

    local rootStroke = Instance.new("UIStroke")
    rootStroke.Thickness = 1.5
    rootStroke.Color = Color3.fromRGB(0, 255, 128)
    rootStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rootStroke.Parent = root

    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 20, 10)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    }
    g.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(0.5, 0.1),
        NumberSequenceKeypoint.new(1, 0.2)
    }
    g.Rotation = 90
    g.Parent = root

    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Parent = root
    topbar.BackgroundColor3 = Color3.fromRGB(5, 10, 5)
    topbar.BackgroundTransparency = 0.15
    topbar.Size = UDim2.new(1, 0, 0, 32)

    local topbarCorner = Instance.new("UICorner")
    topbarCorner.CornerRadius = UDim.new(0, 10)
    topbarCorner.Parent = topbar

    local topbarStroke = Instance.new("UIStroke")
    topbarStroke.Thickness = 1
    topbarStroke.Color = Color3.fromRGB(0, 255, 128)
    topbarStroke.Transparency = 0.5
    topbarStroke.Parent = topbar

    local title = Instance.new("TextLabel")
    title.Parent = topbar
    title.BackgroundTransparency = 1
    title.AnchorPoint = Vector2.new(0, 0.5)
    title.Position = UDim2.new(0, 10, 0.5, 0)
    title.Size = UDim2.new(0.4, 0, 0.7, 0)
    title.Font = Enum.Font.GothamSemibold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextScaled = true
    title.Text = titleText or "Centrix Hub"
    title.TextColor3 = Color3.fromRGB(220, 255, 240)

    local accent = Instance.new("Frame")
    accent.Parent = topbar
    accent.AnchorPoint = Vector2.new(0, 1)
    accent.Position = UDim2.new(0, 0, 1, 0)
    accent.Size = UDim2.new(1, 0, 0, 2)
    accent.BackgroundColor3 = Color3.fromRGB(0, 255, 128)

    local accentGradient = Instance.new("UIGradient")
    accentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 128)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 128)),
    }
    accentGradient.Rotation = 0
    accentGradient.Parent = accent

    task.spawn(function()
        while accent.Parent do
            tween(accentGradient, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, {Rotation = accentGradient.Rotation + 180})
            task.wait(2)
        end
    end)

    local close = Instance.new("TextButton")
    close.Name = "Close"
    close.Parent = topbar
    close.AnchorPoint = Vector2.new(1, 0.5)
    close.Position = UDim2.new(1, -8, 0.5, 0)
    close.Size = UDim2.new(0, 26, 0, 20)
    close.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    close.BackgroundTransparency = 0.1
    close.Text = "X"
    close.Font = Enum.Font.GothamBold
    close.TextScaled = true
    close.TextColor3 = Color3.fromRGB(255, 80, 80)

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = close

    local closeStroke = Instance.new("UIStroke")
    closeStroke.Thickness = 1
    closeStroke.Color = Color3.fromRGB(255, 80, 80)
    closeStroke.Parent = close

    close.MouseEnter:Connect(function()
        tween(close, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(40, 10, 10),
        })
    end)

    close.MouseLeave:Connect(function()
        tween(close, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        })
    end)

    close.MouseButton1Click:Connect(function()
        local guiRoot = root.Parent
        tween(root, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {Size = UDim2.fromScale(0, 0), BackgroundTransparency = 1})
        task.wait(0.3)
        guiRoot:Destroy()
    end)

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Parent = root
    sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    sidebar.BackgroundTransparency = 0.3
    sidebar.Position = UDim2.new(0, 0, 0, 32)
    sidebar.Size = UDim2.new(0, 160, 1, -32)

    local sidebarGrad = Instance.new("UIGradient")
    sidebarGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 50, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 10, 5))
    }
    sidebarGrad.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 0.4),
    }
    sidebarGrad.Rotation = 90
    sidebarGrad.Parent = sidebar

    local sidebarStroke = Instance.new("UIStroke")
    sidebarStroke.Thickness = 1
    sidebarStroke.Color = Color3.fromRGB(0, 255, 128)
    sidebarStroke.Transparency = 0.75
    sidebarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    sidebarStroke.Parent = sidebar

    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "TabList"
    tabList.Parent = sidebar
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.Position = UDim2.new(0, 0, 0, 4)
    tabList.Size = UDim2.new(1, 0, 1, -8)
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.ScrollBarThickness = 2
    tabList.ScrollingDirection = Enum.ScrollingDirection.Y

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabList
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 4)

    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabList.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 8)
    end)

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Parent = root
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 160, 0, 32)
    content.Size = UDim2.new(1, -160, 1, -32)

    local dragging = false
    local dragStart
    local startPos

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = root.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            root.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    return {
        Root = root,
        Content = content,
        Sidebar = sidebar,
        TabList = tabList
    }
end

local function createWindowLoadingOverlay(root, titleText)
    local overlay = Instance.new("Frame")
    overlay.Name = "WindowLoading"
    overlay.Parent = root
    overlay.AnchorPoint = Vector2.new(0.5, 0.5)
    overlay.Position = UDim2.fromScale(0.5, 0.5)
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundColor3 = Color3.fromRGB(3, 3, 3)
    overlay.BackgroundTransparency = 0.1
    overlay.ZIndex = 50
    overlay.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = overlay

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(0, 255, 128)
    stroke.Transparency = 0.3
    stroke.Parent = overlay

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 128)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 170, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 128)),
    })
    gradient.Rotation = 45
    gradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.5, 0.7),
        NumberSequenceKeypoint.new(1, 0.9),
    }
    gradient.Parent = overlay

    task.spawn(function()
        while overlay.Parent do
            tween(gradient, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, {Rotation = gradient.Rotation + 180})
            task.wait(2)
        end
    end)

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = overlay
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.Position = UDim2.fromScale(0.5, 0.38)
    title.Size = UDim2.fromScale(0.7, 0.2)
    title.BackgroundTransparency = 1
    title.Text = titleText or "Centrix Hub"
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.TextColor3 = Color3.fromRGB(0, 0, 0)
    title.TextTransparency = 1
    title.ZIndex = 51

    local titleStroke = Instance.new("UIStroke")
    titleStroke.Thickness = 1.5
    titleStroke.Color = Color3.fromRGB(0, 255, 128)
    titleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    titleStroke.Parent = title

    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Parent = overlay
    subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    subtitle.Position = UDim2.fromScale(0.5, 0.55)
    subtitle.Size = UDim2.fromScale(0.6, 0.08)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Loading interface..."
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextScaled = true
    subtitle.TextColor3 = Color3.fromRGB(200, 255, 230)
    subtitle.TextTransparency = 1
    subtitle.ZIndex = 51

    local barHolder = Instance.new("Frame")
    barHolder.Name = "BarHolder"
    barHolder.Parent = overlay
    barHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    barHolder.Position = UDim2.fromScale(0.5, 0.68)
    barHolder.Size = UDim2.fromScale(0.4, 0.04)
    barHolder.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    barHolder.BackgroundTransparency = 0.25
    barHolder.ZIndex = 51

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = barHolder

    local barFill = Instance.new("Frame")
    barFill.Name = "BarFill"
    barFill.Parent = barHolder
    barFill.Size = UDim2.fromScale(0, 1)
    barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
    barFill.ZIndex = 52

    local barFillCorner = Instance.new("UICorner")
    barFillCorner.CornerRadius = UDim.new(1, 0)
    barFillCorner.Parent = barFill

    tween(title, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {TextTransparency = 0})
    tween(subtitle, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {TextTransparency = 0})
    tween(barFill, 1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {Size = UDim2.fromScale(1, 1)})

    return overlay
end

local function finishWindowLoading(overlay)
    local children = overlay:GetDescendants()
    for _, obj in ipairs(children) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            tween(obj, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
                TextTransparency = 1;
                BackgroundTransparency = 1;
            })
        elseif obj:IsA("Frame") then
            tween(obj, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
                BackgroundTransparency = 1;
            })
        end
    end
    tween(overlay, 0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {
        BackgroundTransparency = 1;
    })
    task.wait(0.42)
    overlay:Destroy()
end

function Tab:SetActive(active)
    if active then
        self.ContentFrame.Visible = true
        tween(self.ContentFrame, 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundTransparency = 0})
        tween(self.Button, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(0, 40, 25),
            BackgroundTransparency = 0.05,
        })
    else
        self.ContentFrame.Visible = false
        tween(self.Button, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(5, 5, 5),
            BackgroundTransparency = 0.2,
        })
    end
end

local function createElementBase(parent, height)
    local item = Instance.new("Frame")
    item.Parent = parent
    item.Size = UDim2.new(1, -10, 0, height or 38)
    item.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    item.BackgroundTransparency = 0.25

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = item

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(0, 255, 128)
    stroke.Transparency = 0.8
    stroke.Parent = item

    tween(item, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundTransparency = 0.1})
    tween(stroke, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Transparency = 0.75})

    return item
end

local function createLeftLabel(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = parent
    lbl.BackgroundTransparency = 1
    lbl.AnchorPoint = Vector2.new(0, 0.5)
    lbl.Position = UDim2.new(0, 10, 0.5, 0)
    lbl.Size = UDim2.new(0.55, 0, 0.9, 0)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextScaled = true
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(210, 255, 230)
    return lbl
end

local function addLabel(parent, text)
    local item = createElementBase(parent, 30)

    local lbl = Instance.new("TextLabel")
    lbl.Parent = item
    lbl.BackgroundTransparency = 1
    lbl.AnchorPoint = Vector2.new(0, 0.5)
    lbl.Position = UDim2.new(0, 10, 0.5, 0)
    lbl.Size = UDim2.new(1, -20, 0.9, 0)
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextScaled = true
    lbl.TextWrapped = true
    lbl.TextColor3 = Color3.fromRGB(200, 255, 230)
    lbl.Text = text or "Label"

    return {
        Instance = item,
        SetText = function(_, t) lbl.Text = t end,
    }
end

local function addButton(parent, text, callback)
    local item = createElementBase(parent, 36)
    local label = createLeftLabel(item, text or "Button")

    local btn = Instance.new("TextButton")
    btn.Parent = item
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.Position = UDim2.new(1, -8, 0.5, 0)
    btn.Size = UDim2.new(0, 90, 0, 26)
    btn.BackgroundColor3 = Color3.fromRGB(0, 40, 25)
    btn.Text = "Execute"
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(0, 255, 128)
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(0, 255, 128)
    stroke.Parent = btn

    btn.MouseEnter:Connect(function()
        tween(btn, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(0, 70, 45),
        })
    end)

    btn.MouseLeave:Connect(function()
        tween(btn, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(0, 40, 25),
        })
    end)

    btn.MouseButton1Click:Connect(function()
        tween(btn, 0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            Size = UDim2.new(0, 84, 0, 23)
        })
        tween(btn, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
            Size = UDim2.new(0, 90, 0, 26)
        })
        if callback then
            task.spawn(callback)
        end
    end)

    return {
        Instance = item,
        SetText = function(_, t) label.Text = t end
    }
end

local function addToggle(parent, text, default, callback)
    local state = default or false

    local item = createElementBase(parent, 36)
    local label = createLeftLabel(item, text or "Toggle")

    local toggleFrame = Instance.new("Frame")
    toggleFrame.Parent = item
    toggleFrame.AnchorPoint = Vector2.new(1, 0.5)
    toggleFrame.Position = UDim2.new(1, -12, 0.5, 0)
    toggleFrame.Size = UDim2.new(0, 42, 0, 20)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    toggleFrame.BackgroundTransparency = 0.2

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(1, 0)
    tCorner.Parent = toggleFrame

    local tStroke = Instance.new("UIStroke")
    tStroke.Thickness = 1
    tStroke.Color = Color3.fromRGB(120, 120, 120)
    tStroke.Parent = toggleFrame

    local knob = Instance.new("Frame")
    knob.Parent = toggleFrame
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Position = UDim2.new(0, 2, 0.5, 0)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.BackgroundColor3 = Color3.fromRGB(160, 160, 160)

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(1, 0)
    kCorner.Parent = knob

    local kStroke = Instance.new("UIStroke")
    kStroke.Thickness = 1
    kStroke.Color = Color3.fromRGB(0, 0, 0)
    kStroke.Parent = knob

    local function applyState(animated)
        local goalPos
        local colorFrame
        local colorKnob

        if state then
            goalPos = UDim2.new(1, -18, 0.5, 0)
            colorFrame = Color3.fromRGB(0, 255, 128)
            colorKnob = Color3.fromRGB(0, 35, 18)
        else
            goalPos = UDim2.new(0, 2, 0.5, 0)
            colorFrame = Color3.fromRGB(20, 20, 20)
            colorKnob = Color3.fromRGB(160, 160, 160)
        end

        if animated then
            tween(knob, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Position = goalPos, BackgroundColor3 = colorKnob})
            tween(toggleFrame, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundColor3 = colorFrame})
            tween(tStroke, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                Color = state and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(120, 120, 120)
            })
        else
            knob.Position = goalPos
            knob.BackgroundColor3 = colorKnob
            toggleFrame.BackgroundColor3 = colorFrame
            tStroke.Color = state and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(120, 120, 120)
        end
    end

    applyState(false)

    local function setState(s, silent)
        state = s
        applyState(true)
        if callback and not silent then
            task.spawn(callback, state)
        end
    end

    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            setState(not state)
        end
    end)

    return {
        Instance = item,
        Get = function() return state end,
        Set = function(_, v) setState(v, true) end,
        SetText = function(_, t) label.Text = t end,
    }
end

local function addSlider(parent, text, min, max, default, callback)
    min = min or 0
    max = max or 100
    local value = default or min

    local item = createElementBase(parent, 40)
    local label = createLeftLabel(item, text or "Slider")

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = item
    valueLabel.AnchorPoint = Vector2.new(1, 0.5)
    valueLabel.Position = UDim2.new(1, -8, 0.25, 0)
    valueLabel.Size = UDim2.new(0, 80, 0, 16)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextScaled = true
    valueLabel.TextColor3 = Color3.fromRGB(180, 255, 210)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local bar = Instance.new("Frame")
    bar.Parent = item
    bar.AnchorPoint = Vector2.new(0.5, 1)
    bar.Position = UDim2.new(0.5, 0, 1, -6)
    bar.Size = UDim2.new(0.92, 0, 0, 6)
    bar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    bar.BackgroundTransparency = 0.1

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Parent = bar
    fill.Size = UDim2.fromScale(0, 1)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 128)

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local handle = Instance.new("Frame")
    handle.Parent = bar
    handle.AnchorPoint = Vector2.new(0.5, 0.5)
    handle.Position = UDim2.fromScale(0, 0.5)
    handle.Size = UDim2.new(0, 12, 0, 12)
    handle.BackgroundColor3 = Color3.fromRGB(0, 255, 128)

    local hCorner = Instance.new("UICorner")
    hCorner.CornerRadius = UDim.new(1, 0)
    hCorner.Parent = handle

    local hStroke = Instance.new("UIStroke")
    hStroke.Thickness = 1
    hStroke.Color = Color3.fromRGB(0, 0, 0)
    hStroke.Parent = handle

    local dragging = false

    local function setVisualFromValue(animated)
        local alpha = (value - min) / (max - min)
        local goalFill = UDim2.fromScale(alpha, 1)
        local goalPos = UDim2.fromScale(alpha, 0.5)

        if animated then
            tween(fill, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Size = goalFill})
            tween(handle, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Position = goalPos})
        else
            fill.Size = goalFill
            handle.Position = goalPos
        end

        valueLabel.Text = tostring(math.floor(value + 0.5))
    end

    local function setValue(v, silent)
        v = math.clamp(v, min, max)
        value = v
        setVisualFromValue(true)
        if callback and not silent then
            task.spawn(callback, value)
        end
    end

    setValue(value, true)

    local function updateFromInput(input)
        local rel = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
        rel = math.clamp(rel, 0, 1)
        local v = min + (max - min) * rel
        setValue(v)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInput(input)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end)

    return {
        Instance = item,
        Get = function() return value end,
        Set = function(_, v) setValue(v, true) end,
        SetText = function(_, t) label.Text = t end,
    }
end

local function addDropdown(parent, text, options, default, callback)
    options = options or {}
    local current = default or (options[1] or "")

    local item = createElementBase(parent, 38)
    local label = createLeftLabel(item, text or "Dropdown")

    local main = Instance.new("TextButton")
    main.Parent = item
    main.AnchorPoint = Vector2.new(1, 0.5)
    main.Position = UDim2.new(1, -8, 0.5, 0)
    main.Size = UDim2.new(0, 140, 0, 26)
    main.BackgroundColor3 = Color3.fromRGB(10, 20, 15)
    main.Text = ""
    main.AutoButtonColor = false

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 6)
    mainCorner.Parent = main

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = main
    valueLabel.BackgroundTransparency = 1
    valueLabel.AnchorPoint = Vector2.new(0, 0.5)
    valueLabel.Position = UDim2.new(0, 6, 0.5, 0)
    valueLabel.Size = UDim2.new(1, -22, 0.9, 0)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.TextScaled = true
    valueLabel.TextColor3 = Color3.fromRGB(180, 255, 210)
    valueLabel.Text = tostring(current)

    local arrow = Instance.new("TextLabel")
    arrow.Parent = main
    arrow.BackgroundTransparency = 1
    arrow.AnchorPoint = Vector2.new(1, 0.5)
    arrow.Position = UDim2.new(1, -6, 0.5, 0)
    arrow.Size = UDim2.new(0, 16, 0, 16)
    arrow.Font = Enum.Font.GothamBold
    arrow.TextScaled = true
    arrow.TextColor3 = Color3.fromRGB(0, 255, 128)
    arrow.Text = "▼"

    local holder = Instance.new("Frame")
    holder.Parent = item
    holder.Position = UDim2.new(0, 4, 1, 4)
    holder.Size = UDim2.new(1, -8, 0, 0)
    holder.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    holder.BackgroundTransparency = 0.15
    holder.ClipsDescendants = true
    holder.Visible = false
    holder.ZIndex = 2

    local holderCorner = Instance.new("UICorner")
    holderCorner.CornerRadius = UDim.new(0, 6)
    holderCorner.Parent = holder

    local holderStroke = Instance.new("UIStroke")
    holderStroke.Thickness = 1
    holderStroke.Color = Color3.fromRGB(0, 255, 128)
    holderStroke.Transparency = 0.7
    holderStroke.Parent = holder

    local list = Instance.new("UIListLayout")
    list.Parent = holder
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 2)

    local buttons = {}

    local function rebuildOptions()
        for _, b in ipairs(buttons) do
            b:Destroy()
        end
        table.clear(buttons)

        for _, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Parent = holder
            optBtn.Size = UDim2.new(1, -4, 0, 22)
            optBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            optBtn.Text = opt
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextScaled = true
            optBtn.TextColor3 = Color3.fromRGB(190, 255, 220)
            optBtn.BorderSizePixel = 0
            optBtn.AutoButtonColor = false

            local oc = Instance.new("UICorner")
            oc.CornerRadius = UDim.new(0, 4)
            oc.Parent = optBtn

            optBtn.MouseEnter:Connect(function()
                tween(optBtn, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                    BackgroundColor3 = Color3.fromRGB(0, 60, 35),
                })
            end)
            optBtn.MouseLeave:Connect(function()
                tween(optBtn, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
                })
            end)

            optBtn.MouseButton1Click:Connect(function()
                current = opt
                valueLabel.Text = current
                if callback then
                    task.spawn(callback, current)
                end
                tween(holder, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {Size = UDim2.new(1, -8, 0, 0)})
                tween(arrow, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Rotation = 0})
                task.delay(0.2, function()
                    holder.Visible = false
                end)
            end)

            table.insert(buttons, optBtn)
        end

        holder.Size = UDim2.new(1, -8, 0, list.AbsoluteContentSize.Y + 6)
    end

    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if holder.Visible then
            holder.Size = UDim2.new(1, -8, 0, list.AbsoluteContentSize.Y + 6)
        end
    end)

    rebuildOptions()

    local open = false
    main.MouseButton1Click:Connect(function()
        open = not open
        if open then
            holder.Visible = true
            holder.Size = UDim2.new(1, -8, 0, 0)
            tween(holder, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                Size = UDim2.new(1, -8, 0, list.AbsoluteContentSize.Y + 6)
            })
            tween(arrow, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Rotation = 180})
        else
            tween(holder, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {
                Size = UDim2.new(1, -8, 0, 0)
            })
            tween(arrow, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Rotation = 0})
            task.delay(0.2, function()
                if not open then
                    holder.Visible = false
                end
            end)
        end
    end)

    return {
        Instance = item,
        Get = function() return current end,
        Set = function(_, v)
            current = v
            valueLabel.Text = tostring(v)
        end,
        SetOptions = function(_, newOptions)
            options = newOptions or {}
            rebuildOptions()
        end,
        SetText = function(_, t) label.Text = t end,
    }
end

local function addMultiDropdown(parent, text, options, defaultList, callback)
    options = options or {}
    local selected = {}
    if defaultList then
        for _, v in ipairs(defaultList) do
            selected[v] = true
        end
    end

    local item = createElementBase(parent, 40)
    local label = createLeftLabel(item, text or "Multi Dropdown")

    local main = Instance.new("TextButton")
    main.Parent = item
    main.AnchorPoint = Vector2.new(1, 0.5)
    main.Position = UDim2.new(1, -8, 0.5, 0)
    main.Size = UDim2.new(0, 150, 0, 28)
    main.BackgroundColor3 = Color3.fromRGB(10, 20, 15)
    main.Text = ""
    main.AutoButtonColor = false

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 6)
    mainCorner.Parent = main

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = main
    valueLabel.BackgroundTransparency = 1
    valueLabel.AnchorPoint = Vector2.new(0, 0.5)
    valueLabel.Position = UDim2.new(0, 6, 0.5, 0)
    valueLabel.Size = UDim2.new(1, -22, 0.9, 0)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.TextScaled = true
    valueLabel.TextColor3 = Color3.fromRGB(180, 255, 210)

    local arrow = Instance.new("TextLabel")
    arrow.Parent = main
    arrow.BackgroundTransparency = 1
    arrow.AnchorPoint = Vector2.new(1, 0.5)
    arrow.Position = UDim2.new(1, -6, 0.5, 0)
    arrow.Size = UDim2.new(0, 16, 0, 16)
    arrow.Font = Enum.Font.GothamBold
    arrow.TextScaled = true
    arrow.TextColor3 = Color3.fromRGB(0, 255, 128)
    arrow.Text = "▼"

    local holder = Instance.new("Frame")
    holder.Parent = item
    holder.Position = UDim2.new(0, 4, 1, 4)
    holder.Size = UDim2.new(1, -8, 0, 0)
    holder.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    holder.BackgroundTransparency = 0.15
    holder.Visible = false
    holder.ClipsDescendants = true
    holder.ZIndex = 2

    local hCorner = Instance.new("UICorner")
    hCorner.CornerRadius = UDim.new(0, 6)
    hCorner.Parent = holder

    local hStroke = Instance.new("UIStroke")
    hStroke.Thickness = 1
    hStroke.Color = Color3.fromRGB(0, 255, 128)
    hStroke.Transparency = 0.7
    hStroke.Parent = holder

    local list = Instance.new("UIListLayout")
    list.Parent = holder
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 2)

    local buttons = {}

    local function getSelectedList()
        local res = {}
        for _, opt in ipairs(options) do
            if selected[opt] then
                table.insert(res, opt)
            end
        end
        return res
    end

    local function updateLabel()
        local res = getSelectedList()
        if #res == 0 then
            valueLabel.Text = "None"
        elseif #res <= 2 then
            valueLabel.Text = table.concat(res, ", ")
        else
            valueLabel.Text = tostring(#res) .. " selected"
        end
    end

    local function rebuildOptions()
        for _, b in ipairs(buttons) do
            b:Destroy()
        end
        table.clear(buttons)

        for _, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Parent = holder
            optBtn.Size = UDim2.new(1, -4, 0, 22)
            optBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            optBtn.Text = opt
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextScaled = true
            optBtn.TextColor3 = selected[opt] and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(190, 255, 220)
            optBtn.BorderSizePixel = 0
            optBtn.AutoButtonColor = false

            local oc = Instance.new("UICorner")
            oc.CornerRadius = UDim.new(0, 4)
            oc.Parent = optBtn

            optBtn.MouseEnter:Connect(function()
                tween(optBtn, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                    BackgroundColor3 = Color3.fromRGB(0, 60, 35),
                })
            end)
            optBtn.MouseLeave:Connect(function()
                tween(optBtn, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
                })
            end)

            optBtn.MouseButton1Click:Connect(function()
                selected[opt] = not selected[opt]
                optBtn.TextColor3 = selected[opt] and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(190, 255, 220)
                updateLabel()
                if callback then
                    task.spawn(callback, getSelectedList())
                end
            end)

            table.insert(buttons, optBtn)
        end

        holder.Size = UDim2.new(1, -8, 0, list.AbsoluteContentSize.Y + 6)
    end

    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if holder.Visible then
            holder.Size = UDim2.new(1, -8, 0, list.AbsoluteContentSize.Y + 6)
        end
    end)

    rebuildOptions()
    updateLabel()

    local open = false
    main.MouseButton1Click:Connect(function()
        open = not open
        if open then
            holder.Visible = true
            holder.Size = UDim2.new(1, -8, 0, 0)
            tween(holder, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                Size = UDim2.new(1, -8, 0, list.AbsoluteContentSize.Y + 6)
            })
            tween(arrow, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Rotation = 180})
        else
            tween(holder, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {
                Size = UDim2.new(1, -8, 0, 0)
            })
            tween(arrow, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Rotation = 0})
            task.delay(0.2, function()
                if not open then
                    holder.Visible = false
                end
            end)
        end
    end)

    return {
        Instance = item,
        Get = getSelectedList,
        SetOptions = function(_, newOptions)
            options = newOptions or {}
            rebuildOptions()
            updateLabel()
        end,
        Clear = function()
            selected = {}
            updateLabel()
        end,
        SetText = function(_, t) label.Text = t end,
    }
end

local function addTextBox(parent, text, placeholder, defaultText, callback)
    local item = createElementBase(parent, 38)
    local label = createLeftLabel(item, text or "TextBox")

    local box = Instance.new("TextBox")
    box.Parent = item
    box.AnchorPoint = Vector2.new(1, 0.5)
    box.Position = UDim2.new(1, -8, 0.5, 0)
    box.Size = UDim2.new(0, 160, 0, 26)
    box.BackgroundColor3 = Color3.fromRGB(10, 20, 15)
    box.Font = Enum.Font.Gotham
    box.TextScaled = true
    box.TextColor3 = Color3.fromRGB(180, 255, 210)
    box.PlaceholderText = placeholder or ""
    box.PlaceholderColor3 = Color3.fromRGB(80, 120, 100)
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.Text = defaultText or ""
    box.ClearTextOnFocus = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = box

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(0, 255, 128)
    stroke.Transparency = 0.75
    stroke.Parent = box

    box.Focused:Connect(function()
        tween(box, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(0, 50, 30),
        })
    end)

    box.FocusLost:Connect(function(enterPressed)
        tween(box, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            BackgroundColor3 = Color3.fromRGB(10, 20, 15),
        })
        if callback and enterPressed then
            task.spawn(callback, box.Text)
        end
    end)

    return {
        Instance = item,
        Get = function() return box.Text end,
        Set = function(_, v) box.Text = tostring(v) end,
        SetText = function(_, t) label.Text = t end,
        SetPlaceholder = function(_, t) box.PlaceholderText = t end,
    }
end

local function addKeybind(parent, text, defaultKeyCode, callback)
    local currentKey = defaultKeyCode or Enum.KeyCode.RightControl
    local listening = false

    local item = createElementBase(parent, 36)
    local label = createLeftLabel(item, text or "Keybind")

    local btn = Instance.new("TextButton")
    btn.Parent = item
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.Position = UDim2.new(1, -8, 0.5, 0)
    btn.Size = UDim2.new(0, 110, 0, 26)
    btn.BackgroundColor3 = Color3.fromRGB(10, 20, 15)
    btn.Text = currentKey and currentKey.Name or "None"
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.TextColor3 = Color3.fromRGB(0, 255, 128)
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(0, 255, 128)
    stroke.Transparency = 0.75
    stroke.Parent = btn

    local function setDisplayListening(on)
        if on then
            btn.Text = "Press key..."
            tween(btn, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                BackgroundColor3 = Color3.fromRGB(0, 60, 35),
            })
        else
            btn.Text = currentKey and currentKey.Name or "None"
            tween(btn, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                BackgroundColor3 = Color3.fromRGB(10, 20, 15),
            })
        end
    end

    btn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        setDisplayListening(true)
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end

        if listening and input.KeyCode ~= Enum.KeyCode.Unknown then
            currentKey = input.KeyCode
            listening = false
            setDisplayListening(false)
        else
            if currentKey and input.KeyCode == currentKey then
                if callback then
                    task.spawn(callback)
                end
            end
        end
    end)

    return {
        Instance = item,
        GetKey = function() return currentKey end,
        SetKey = function(_, keyCode)
            currentKey = keyCode
            setDisplayListening(false)
        end,
        SetText = function(_, t) label.Text = t end,
    }
end

local function addColorPicker(parent, text, defaultColor, callback)
    local def = defaultColor or Color3.fromRGB(0, 255, 128)
    local h, s, v = Color3.toHSV(def)
    local hue = h

    local item = createElementBase(parent, 44)
    local label = createLeftLabel(item, text or "Color Picker")

    local preview = Instance.new("Frame")
    preview.Parent = item
    preview.AnchorPoint = Vector2.new(1, 0.5)
    preview.Position = UDim2.new(1, -8, 0.35, 0)
    preview.Size = UDim2.new(0, 40, 0, 22)
    preview.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)

    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(0, 6)
    pCorner.Parent = preview

    local pStroke = Instance.new("UIStroke")
    pStroke.Thickness = 1.5
    pStroke.Color = Color3.fromRGB(0, 255, 128)
    pStroke.Parent = preview

    task.spawn(function()
        local growing = true
        while preview.Parent do
            local target = growing and 2.5 or 1.2
            tween(pStroke, 0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, {Thickness = target})
            growing = not growing
            task.wait(0.4)
        end
    end)

    local bar = Instance.new("Frame")
    bar.Parent = item
    bar.AnchorPoint = Vector2.new(0.5, 1)
    bar.Position = UDim2.new(0.5, 0, 1, -6)
    bar.Size = UDim2.new(0.92, 0, 0, 8)
    bar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    bar.BackgroundTransparency = 0.1

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar

    local hueGrad = Instance.new("UIGradient")
    hueGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
        ColorSequenceKeypoint.new(0.16, Color3.fromHSV(0.16, 1, 1)),
        ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
        ColorSequenceKeypoint.new(0.66, Color3.fromHSV(0.66, 1, 1)),
        ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
    }
    hueGrad.Parent = bar

    local handle = Instance.new("Frame")
    handle.Parent = bar
    handle.AnchorPoint = Vector2.new(0.5, 0.5)
    handle.Position = UDim2.fromScale(hue, 0.5)
    handle.Size = UDim2.new(0, 10, 0, 14)
    handle.BackgroundColor3 = Color3.fromRGB(240, 240, 240)

    local hCorner = Instance.new("UICorner")
    hCorner.CornerRadius = UDim.new(1, 0)
    hCorner.Parent = handle

    local hStroke = Instance.new("UIStroke")
    hStroke.Thickness = 1
    hStroke.Color = Color3.fromRGB(0, 0, 0)
    hStroke.Parent = handle

    local dragging = false

    local function updateVisual(animated)
        local color = Color3.fromHSV(hue, 1, 1)
        if animated then
            tween(handle, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {Position = UDim2.fromScale(hue, 0.5)})
            tween(preview, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {BackgroundColor3 = color})
        else
            handle.Position = UDim2.fromScale(hue, 0.5)
            preview.BackgroundColor3 = color
        end
    end

    local function fireCallback()
        if callback then
            task.spawn(callback, Color3.fromHSV(hue, 1, 1))
        end
    end

    updateVisual(false)

    local function updateFromInput(input)
        local rel = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
        rel = math.clamp(rel, 0, 1)
        hue = rel
        updateVisual(true)
        fireCallback()
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInput(input)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end)

    return {
        Instance = item,
        Get = function() return Color3.fromHSV(hue, 1, 1) end,
        Set = function(_, col)
            local hh, ss, vv = Color3.toHSV(col)
            hue = hh
            updateVisual(false)
        end,
        SetText = function(_, t) label.Text = t end,
    }
end

function Tab:Label(text)
    return addLabel(self.ContentFrame, text)
end

function Tab:Button(text, callback)
    return addButton(self.ContentFrame, text, callback)
end

function Tab:Toggle(text, default, callback)
    return addToggle(self.ContentFrame, text, default, callback)
end

function Tab:Slider(text, min, max, default, callback)
    return addSlider(self.ContentFrame, text, min, max, default, callback)
end

function Tab:Dropdown(text, options, default, callback)
    return addDropdown(self.ContentFrame, text, options, default, callback)
end

function Tab:MultiDropdown(text, options, defaultList, callback)
    return addMultiDropdown(self.ContentFrame, text, options, defaultList, callback)
end

function Tab:TextBox(text, placeholder, defaultText, callback)
    return addTextBox(self.ContentFrame, text, placeholder, defaultText, callback)
end

function Tab:Keybind(text, defaultKeyCode, callback)
    return addKeybind(self.ContentFrame, text, defaultKeyCode, callback)
end

function Tab:ColorPicker(text, defaultColor, callback)
    return addColorPicker(self.ContentFrame, text, defaultColor, callback)
end

function Section:Label(text)
    return addLabel(self.Container, text)
end

function Section:Button(text, callback)
    return addButton(self.Container, text, callback)
end

function Section:Toggle(text, default, callback)
    return addToggle(self.Container, text, default, callback)
end

function Section:Slider(text, min, max, default, callback)
    return addSlider(self.Container, text, min, max, default, callback)
end

function Section:Dropdown(text, options, default, callback)
    return addDropdown(self.Container, text, options, default, callback)
end

function Section:MultiDropdown(text, options, defaultList, callback)
    return addMultiDropdown(self.Container, text, options, defaultList, callback)
end

function Section:TextBox(text, placeholder, defaultText, callback)
    return addTextBox(self.Container, text, placeholder, defaultText, callback)
end

function Section:Keybind(text, defaultKeyCode, callback)
    return addKeybind(self.Container, text, defaultKeyCode, callback)
end

function Section:ColorPicker(text, defaultColor, callback)
    return addColorPicker(self.Container, text, defaultColor, callback)
end

function Tab:Section(title, collapsedByDefault)
    local headerHeight = 30
    local outer = createElementBase(self.ContentFrame, headerHeight)
    outer.ClipsDescendants = true

    local header = Instance.new("TextButton")
    header.Parent = outer
    header.BackgroundTransparency = 1
    header.Text = ""
    header.AutoButtonColor = false
    header.Size = UDim2.new(1, -4, 0, headerHeight)
    header.Position = UDim2.new(0, 2, 0, 0)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = header
    nameLabel.BackgroundTransparency = 1
    nameLabel.AnchorPoint = Vector2.new(0, 0.5)
    nameLabel.Position = UDim2.new(0, 10, 0.5, 0)
    nameLabel.Size = UDim2.new(0.7, 0, 0.9, 0)
    nameLabel.Font = Enum.Font.GothamSemibold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextScaled = true
    nameLabel.TextColor3 = Color3.fromRGB(210, 255, 230)
    nameLabel.Text = title or "Section"

    local arrow = Instance.new("TextLabel")
    arrow.Parent = header
    arrow.BackgroundTransparency = 1
    arrow.AnchorPoint = Vector2.new(1, 0.5)
    arrow.Position = UDim2.new(1, -8, 0.5, 0)
    arrow.Size = UDim2.new(0, 18, 0, 18)
    arrow.Font = Enum.Font.GothamBold
    arrow.TextScaled = true
    arrow.TextColor3 = Color3.fromRGB(0, 255, 128)
    arrow.Text = ">"

    local content = Instance.new("Frame")
    content.Parent = outer
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 6, 0, headerHeight)
    content.Size = UDim2.new(1, -12, 0, 0)

    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)

    local collapsed = collapsedByDefault and true or false

    local function updateSize(animated)
        local contentHeight = layout.AbsoluteContentSize.Y
        local targetHeight = collapsed and headerHeight or (headerHeight + contentHeight + 8)
        local contentTargetHeight = collapsed and 0 or (contentHeight + 8)
        if animated then
            tween(outer, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                Size = UDim2.new(1, -10, 0, targetHeight)
            })
            tween(content, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
                Size = UDim2.new(1, -12, 0, contentTargetHeight)
            })
        else
            outer.Size = UDim2.new(1, -10, 0, targetHeight)
            content.Size = UDim2.new(1, -12, 0, contentTargetHeight)
        end
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        updateSize(false)
    end)

    if collapsed then
        arrow.Rotation = 0
    else
        arrow.Rotation = 90
    end

    header.MouseButton1Click:Connect(function()
        collapsed = not collapsed
        tween(arrow, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, {
            Rotation = collapsed and 0 or 90
        })
        updateSize(true)
    end)

    updateSize(false)

    local sec = setmetatable({
        Container = content,
        Outer = outer,
        Header = header,
        TitleLabel = nameLabel,
        Collapsed = collapsed,
    }, Section)

    return sec
end

function Window:CreateTab(name, iconId)
    local tabButton = Instance.new("TextButton")
    tabButton.Parent = self._ui.TabList
    tabButton.Size = UDim2.new(1, -8, 0, 34)
    tabButton.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    tabButton.BackgroundTransparency = 0.2
    tabButton.Text = ""
    tabButton.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = tabButton

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(0, 255, 128)
    stroke.Transparency = 0.7
    stroke.Parent = tabButton

    local icon
    if iconId and iconId ~= "" then
        icon = Instance.new("ImageLabel")
        icon.Parent = tabButton
        icon.BackgroundTransparency = 1
        icon.AnchorPoint = Vector2.new(0, 0.5)
        icon.Position = UDim2.new(0, 6, 0.5, 0)
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Image = iconId
        icon.ImageColor3 = Color3.fromRGB(0, 255, 128)
    end

    local label = Instance.new("TextLabel")
    label.Parent = tabButton
    label.BackgroundTransparency = 1
    label.AnchorPoint = Vector2.new(0, 0.5)
    label.Position = icon and UDim2.new(0, 30, 0.5, 0) or UDim2.new(0, 8, 0.5, 0)
    label.Size = UDim2.new(1, -36, 0.8, 0)
    label.Font = Enum.Font.GothamSemibold
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = Color3.fromRGB(210, 255, 230)
    label.Text = name or "Tab"

    local content = Instance.new("ScrollingFrame")
    content.Parent = self._ui.Content
    content.Name = name .. "_Content"
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Position = UDim2.new(0, 6, 0, 6)
    content.Size = UDim2.new(1, -12, 1, -12)
    content.Visible = false
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 3

    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
    end)

    local tab = setmetatable({
        Name = name,
        Button = tabButton,
        ContentFrame = content,
        _window = self,
    }, Tab)

    table.insert(self._tabs, tab)

    tabButton.MouseButton1Click:Connect(function()
        for _, t in ipairs(self._tabs) do
            t:SetActive(t == tab)
        end
    end)

    if #self._tabs == 1 then
        tab:SetActive(true)
    end

    return tab
end

function Centrix.new(options)
    options = options or {}
    local gui = createBaseGui()

    local self = setmetatable({
        _gui = gui,
        _tabs = {},
    }, Window)

    self._ui = createMainWindow(gui, options.Title or "Centrix Hub")

    local targetSize
    if isMobile() then
        targetSize = UDim2.fromScale(0.93, 0.65)
    else
        targetSize = UDim2.fromScale(0.5, 0.6)
    end

    local overlay = createWindowLoadingOverlay(self._ui.Root, options.Title or "Centrix Hub")

    tween(self._ui.Root, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
        Size = targetSize
    })

    task.spawn(function()
        task.wait(1.35)
        finishWindowLoading(overlay)
    end)

    return self
end

return Centrix
