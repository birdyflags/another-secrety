--[[
    ██████╗███████╗███╗   ██╗████████╗██████╗ ██╗██╗  ██╗
   ██╔════╝██╔════╝████╗  ██║╚══██╔══╝██╔══██╗██║╚██╗██╔╝
   ██║     █████╗  ██╔██╗ ██║   ██║   ██████╔╝██║ ╚███╔╝ 
   ██║     ██╔══╝  ██║╚██╗██║   ██║   ██╔══██╗██║ ██╔██╗ 
   ╚██████╗███████╗██║ ╚████║   ██║   ██║  ██║██║██╔╝ ██╗
    ╚═════╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝
    
    Centrix Hub UI Library
    Version: 1.0.0
    Neon Green Theme with Acrylic Design
]]

local Centrix = {}
Centrix.__index = Centrix

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Theme Configuration
local Theme = {
    Primary = Color3.fromRGB(0, 255, 128),        -- Neon Green
    PrimaryDark = Color3.fromRGB(0, 200, 100),    -- Darker Green
    PrimaryGlow = Color3.fromRGB(0, 255, 150),    -- Glow Green
    Background = Color3.fromRGB(15, 15, 20),       -- Dark Background
    BackgroundSecondary = Color3.fromRGB(20, 20, 28), -- Secondary BG
    Sidebar = Color3.fromRGB(18, 18, 25),          -- Sidebar BG
    Card = Color3.fromRGB(25, 25, 35),             -- Card BG
    Text = Color3.fromRGB(255, 255, 255),          -- White Text
    TextDark = Color3.fromRGB(180, 180, 180),      -- Gray Text
    Accent = Color3.fromRGB(0, 255, 128),          -- Accent (same as Primary)
    Shadow = Color3.fromRGB(0, 0, 0),              -- Shadow
    Divider = Color3.fromRGB(40, 40, 50),          -- Divider lines
}

-- Utility Functions
local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function CreateTween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quint,
        easingDirection or Enum.EasingDirection.Out
    )
    return TweenService:Create(object, tweenInfo, properties)
end

local function Ripple(button, x, y)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.Parent = button
    ripple.BackgroundColor3 = Theme.Primary
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local absolutePos = button.AbsolutePosition
    local relativeX = x - absolutePos.X
    local relativeY = y - absolutePos.Y
    
    ripple.Position = UDim2.new(0, relativeX, 0, relativeY)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    
    local expandTween = CreateTween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    
    expandTween:Play()
    expandTween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

local function AddAcrylic(frame, transparency)
    -- Acrylic effect simulation with gradient and blur appearance
    local acrylic = Instance.new("Frame")
    acrylic.Name = "AcrylicEffect"
    acrylic.Parent = frame
    acrylic.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    acrylic.BackgroundTransparency = 0.97
    acrylic.BorderSizePixel = 0
    acrylic.Size = UDim2.new(1, 0, 1, 0)
    acrylic.ZIndex = frame.ZIndex
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = acrylic
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 255, 150)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 200, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 150, 100))
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.95),
        NumberSequenceKeypoint.new(0.5, 0.98),
        NumberSequenceKeypoint.new(1, 0.95)
    })
    gradient.Rotation = 45
    gradient.Parent = acrylic
    
    -- Animate gradient
    spawn(function()
        while acrylic and acrylic.Parent do
            for i = 0, 360, 2 do
                if not acrylic or not acrylic.Parent then break end
                gradient.Rotation = i
                RunService.RenderStepped:Wait()
            end
        end
    end)
    
    return acrylic
end

local function MakeDraggable(frame, handle)
    local dragging = false
    local dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
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
            local targetPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            CreateTween(frame, {Position = targetPos}, 0.1):Play()
        end
    end)
end

-- Main Library
function Centrix:CreateWindow(title)
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    -- Determine size based on device
    local isMobile = IsMobile()
    local windowSize = isMobile and UDim2.new(0.95, 0, 0.85, 0) or UDim2.new(0, 650, 0, 450)
    local windowPosition = UDim2.new(0.5, 0, 0.5, 0)
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CentrixHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    
    -- Loading Screen
    local LoadingScreen = Instance.new("Frame")
    LoadingScreen.Name = "LoadingScreen"
    LoadingScreen.Parent = ScreenGui
    LoadingScreen.BackgroundColor3 = Theme.Background
    LoadingScreen.BorderSizePixel = 0
    LoadingScreen.Size = UDim2.new(1, 0, 1, 0)
    LoadingScreen.ZIndex = 100
    
    local LoadingContainer = Instance.new("Frame")
    LoadingContainer.Name = "LoadingContainer"
    LoadingContainer.Parent = LoadingScreen
    LoadingContainer.BackgroundTransparency = 1
    LoadingContainer.Size = UDim2.new(0, 300, 0, 200)
    LoadingContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadingContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingContainer.ZIndex = 101
    
    -- Logo Text
    local LogoText = Instance.new("TextLabel")
    LogoText.Name = "Logo"
    LogoText.Parent = LoadingContainer
    LogoText.BackgroundTransparency = 1
    LogoText.Size = UDim2.new(1, 0, 0, 50)
    LogoText.Position = UDim2.new(0, 0, 0.2, 0)
    LogoText.Font = Enum.Font.GothamBold
    LogoText.Text = "CENTRIX"
    LogoText.TextColor3 = Theme.Primary
    LogoText.TextSize = 42
    LogoText.TextTransparency = 1
    LogoText.ZIndex = 102
    
    local SubText = Instance.new("TextLabel")
    SubText.Name = "SubText"
    SubText.Parent = LoadingContainer
    SubText.BackgroundTransparency = 1
    SubText.Size = UDim2.new(1, 0, 0, 25)
    SubText.Position = UDim2.new(0, 0, 0.45, 0)
    SubText.Font = Enum.Font.Gotham
    SubText.Text = "HUB"
    SubText.TextColor3 = Theme.TextDark
    SubText.TextSize = 18
    SubText.TextTransparency = 1
    SubText.ZIndex = 102
    
    -- Loading Bar Container
    local LoadingBarBG = Instance.new("Frame")
    LoadingBarBG.Name = "LoadingBarBG"
    LoadingBarBG.Parent = LoadingContainer
    LoadingBarBG.BackgroundColor3 = Theme.Card
    LoadingBarBG.BorderSizePixel = 0
    LoadingBarBG.Size = UDim2.new(0.8, 0, 0, 6)
    LoadingBarBG.Position = UDim2.new(0.1, 0, 0.7, 0)
    LoadingBarBG.ZIndex = 102
    
    local LoadingBarCorner = Instance.new("UICorner")
    LoadingBarCorner.CornerRadius = UDim.new(1, 0)
    LoadingBarCorner.Parent = LoadingBarBG
    
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Name = "LoadingBar"
    LoadingBar.Parent = LoadingBarBG
    LoadingBar.BackgroundColor3 = Theme.Primary
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Size = UDim2.new(0, 0, 1, 0)
    LoadingBar.ZIndex = 103
    
    local LoadingBarFillCorner = Instance.new("UICorner")
    LoadingBarFillCorner.CornerRadius = UDim.new(1, 0)
    LoadingBarFillCorner.Parent = LoadingBar
    
    -- Glow effect on loading bar
    local LoadingGlow = Instance.new("ImageLabel")
    LoadingGlow.Name = "Glow"
    LoadingGlow.Parent = LoadingBar
    LoadingGlow.BackgroundTransparency = 1
    LoadingGlow.Size = UDim2.new(1, 20, 1, 20)
    LoadingGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadingGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingGlow.Image = "rbxassetid://5028857084"
    LoadingGlow.ImageColor3 = Theme.Primary
    LoadingGlow.ImageTransparency = 0.5
    LoadingGlow.ZIndex = 102
    
    -- Loading Status Text
    local LoadingStatus = Instance.new("TextLabel")
    LoadingStatus.Name = "Status"
    LoadingStatus.Parent = LoadingContainer
    LoadingStatus.BackgroundTransparency = 1
    LoadingStatus.Size = UDim2.new(1, 0, 0, 20)
    LoadingStatus.Position = UDim2.new(0, 0, 0.8, 0)
    LoadingStatus.Font = Enum.Font.Gotham
    LoadingStatus.Text = "Initializing..."
    LoadingStatus.TextColor3 = Theme.TextDark
    LoadingStatus.TextSize = 12
    LoadingStatus.TextTransparency = 1
    LoadingStatus.ZIndex = 102
    
    -- Main Window (hidden initially)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = windowPosition
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = false
    MainFrame.ZIndex = 1
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    -- Drop Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Parent = MainFrame
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Size = UDim2.new(1, 50, 1, 50)
    Shadow.Image = "rbxassetid://5028857084"
    Shadow.ImageColor3 = Theme.Primary
    Shadow.ImageTransparency = 0.85
    Shadow.ZIndex = 0
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Theme.BackgroundSecondary
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.ZIndex = 5
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar
    
    -- Fix bottom corners of top bar
    local TopBarFix = Instance.new("Frame")
    TopBarFix.Name = "CornerFix"
    TopBarFix.Parent = TopBar
    TopBarFix.BackgroundColor3 = Theme.BackgroundSecondary
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Size = UDim2.new(1, 0, 0, 15)
    TopBarFix.Position = UDim2.new(0, 0, 1, -15)
    TopBarFix.ZIndex = 5
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title or "Centrix Hub"
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 6
    
    -- Neon accent on title
    local TitleAccent = Instance.new("TextLabel")
    TitleAccent.Name = "TitleAccent"
    TitleAccent.Parent = TopBar
    TitleAccent.BackgroundTransparency = 1
    TitleAccent.Size = UDim2.new(0, 8, 0, 8)
    TitleAccent.Position = UDim2.new(0, 5, 0.5, 0)
    TitleAccent.AnchorPoint = Vector2.new(0, 0.5)
    TitleAccent.BackgroundColor3 = Theme.Primary
    TitleAccent.ZIndex = 6
    TitleAccent.Text = ""
    
    local AccentFrame = Instance.new("Frame")
    AccentFrame.Name = "Accent"
    AccentFrame.Parent = TopBar
    AccentFrame.BackgroundColor3 = Theme.Primary
    AccentFrame.BorderSizePixel = 0
    AccentFrame.Size = UDim2.new(0, 4, 0, 20)
    AccentFrame.Position = UDim2.new(0, 8, 0.5, 0)
    AccentFrame.AnchorPoint = Vector2.new(0, 0.5)
    AccentFrame.ZIndex = 6
    
    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(1, 0)
    AccentCorner.Parent = AccentFrame
    
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    CloseButton.BackgroundTransparency = 0.8
    CloseButton.BorderSizePixel = 0
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0.5, 0)
    CloseButton.AnchorPoint = Vector2.new(0, 0.5)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseButton.TextSize = 20
    CloseButton.ZIndex = 6
    CloseButton.AutoButtonColor = false
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseEnter:Connect(function()
        CreateTween(CloseButton, {BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(255, 50, 50)}, 0.2):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        CreateTween(CloseButton, {BackgroundTransparency = 0.8, BackgroundColor3 = Color3.fromRGB(255, 70, 70)}, 0.2):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        -- Close animation
        CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
        wait(0.4)
        ScreenGui:Destroy()
    end)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TopBar
    MinimizeButton.BackgroundColor3 = Theme.Primary
    MinimizeButton.BackgroundTransparency = 0.8
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -70, 0.5, 0)
    MinimizeButton.AnchorPoint = Vector2.new(0, 0.5)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Theme.Primary
    MinimizeButton.TextSize = 20
    MinimizeButton.ZIndex = 6
    MinimizeButton.AutoButtonColor = false
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 8)
    MinimizeCorner.Parent = MinimizeButton
    
    local isMinimized = false
    local originalSize = windowSize
    
    MinimizeButton.MouseEnter:Connect(function()
        CreateTween(MinimizeButton, {BackgroundTransparency = 0.5}, 0.2):Play()
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        CreateTween(MinimizeButton, {BackgroundTransparency = 0.8}, 0.2):Play()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            CreateTween(MainFrame, {Size = UDim2.new(0, isMobile and 280 or 300, 0, 40)}, 0.3, Enum.EasingStyle.Quint):Play()
        else
            CreateTween(MainFrame, {Size = originalSize}, 0.3, Enum.EasingStyle.Quint):Play()
        end
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Size = UDim2.new(0, isMobile and 60 or 160, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.ZIndex = 3
    
    -- Add acrylic effect to sidebar
    AddAcrylic(Sidebar)
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 12)
    SidebarCorner.Parent = Sidebar
    
    -- Fix top corners of sidebar
    local SidebarFix = Instance.new("Frame")
    SidebarFix.Name = "CornerFix"
    SidebarFix.Parent = Sidebar
    SidebarFix.BackgroundColor3 = Theme.Sidebar
    SidebarFix.BorderSizePixel = 0
    SidebarFix.Size = UDim2.new(1, 0, 0, 15)
    SidebarFix.Position = UDim2.new(0, 0, 0, 0)
    SidebarFix.ZIndex = 3
    
    -- Fix right corners of sidebar
    local SidebarFixRight = Instance.new("Frame")
    SidebarFixRight.Name = "CornerFixRight"
    SidebarFixRight.Parent = Sidebar
    SidebarFixRight.BackgroundColor3 = Theme.Sidebar
    SidebarFixRight.BorderSizePixel = 0
    SidebarFixRight.Size = UDim2.new(0, 15, 1, 0)
    SidebarFixRight.Position = UDim2.new(1, -15, 0, 0)
    SidebarFixRight.ZIndex = 3
    
    -- Tab Container in Sidebar
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Size = UDim2.new(1, -10, 1, -20)
    TabContainer.Position = UDim2.new(0, 5, 0, 10)
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = Theme.Primary
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ZIndex = 4
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    
    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundColor3 = Theme.Background
    ContentArea.BorderSizePixel = 0
    ContentArea.Size = UDim2.new(1, isMobile and -70 or -170, 1, -50)
    ContentArea.Position = UDim2.new(0, isMobile and 65 or 165, 0, 45)
    ContentArea.ZIndex = 2
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentArea
    
    -- Make window draggable
    MakeDraggable(MainFrame, TopBar)
    
    -- Loading Animation
    spawn(function()
        -- Fade in logo
        CreateTween(LogoText, {TextTransparency = 0}, 0.5):Play()
        wait(0.3)
        CreateTween(SubText, {TextTransparency = 0}, 0.4):Play()
        CreateTween(LoadingStatus, {TextTransparency = 0}, 0.4):Play()
        wait(0.2)
        
        -- Loading progress
        local loadingSteps = {
            {progress = 0.2, status = "Loading modules..."},
            {progress = 0.4, status = "Initializing UI..."},
            {progress = 0.6, status = "Setting up components..."},
            {progress = 0.8, status = "Almost ready..."},
            {progress = 1, status = "Complete!"}
        }
        
        for _, step in ipairs(loadingSteps) do
            CreateTween(LoadingBar, {Size = UDim2.new(step.progress, 0, 1, 0)}, 0.4):Play()
            LoadingStatus.Text = step.status
            wait(0.3)
        end
        
        wait(0.3)
        
        -- Fade out loading screen
        CreateTween(LoadingContainer, {Position = UDim2.new(0.5, 0, 0.4, 0)}, 0.4):Play()
        CreateTween(LogoText, {TextTransparency = 1}, 0.3):Play()
        CreateTween(SubText, {TextTransparency = 1}, 0.3):Play()
        CreateTween(LoadingStatus, {TextTransparency = 1}, 0.3):Play()
        CreateTween(LoadingBarBG, {BackgroundTransparency = 1}, 0.3):Play()
        CreateTween(LoadingBar, {BackgroundTransparency = 1}, 0.3):Play()
        
        wait(0.3)
        
        -- Show main window
        MainFrame.Visible = true
        CreateTween(LoadingScreen, {BackgroundTransparency = 1}, 0.5):Play()
        
        -- Smooth scale animation for main window
        CreateTween(MainFrame, {Size = windowSize}, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
        
        wait(0.6)
        LoadingScreen:Destroy()
    end)
    
    -- Tab System
    function Window:CreateTab(name, icon)
        local Tab = {}
        Tab.Elements = {}
        
        local tabIndex = #Window.Tabs + 1
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Theme.Card
        TabButton.BackgroundTransparency = 1
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, -10, 0, isMobile and 45 or 40)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = ""
        TabButton.TextColor3 = Theme.TextDark
        TabButton.TextSize = 14
        TabButton.ZIndex = 5
        TabButton.AutoButtonColor = false
        TabButton.LayoutOrder = tabIndex
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton
        
        -- Tab Icon
        if icon then
            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Name = "Icon"
            TabIcon.Parent = TabButton
            TabIcon.BackgroundTransparency = 1
            TabIcon.Size = UDim2.new(0, 20, 0, 20)
            TabIcon.Position = UDim2.new(0, isMobile and 12 or 12, 0.5, 0)
            TabIcon.AnchorPoint = Vector2.new(0, 0.5)
            TabIcon.Image = icon
            TabIcon.ImageColor3 = Theme.TextDark
            TabIcon.ZIndex = 6
            Tab.Icon = TabIcon
        end
        
        -- Tab Label
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.Parent = TabButton
        TabLabel.BackgroundTransparency = 1
        TabLabel.Size = UDim2.new(1, icon and -45 or -20, 1, 0)
        TabLabel.Position = UDim2.new(0, icon and 40 or 12, 0, 0)
        TabLabel.Font = Enum.Font.GothamSemibold
        TabLabel.Text = isMobile and "" or name
        TabLabel.TextColor3 = Theme.TextDark
        TabLabel.TextSize = 13
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.ZIndex = 6
        Tab.Label = TabLabel
        
        -- Selection indicator
        local SelectIndicator = Instance.new("Frame")
        SelectIndicator.Name = "SelectIndicator"
        SelectIndicator.Parent = TabButton
        SelectIndicator.BackgroundColor3 = Theme.Primary
        SelectIndicator.BorderSizePixel = 0
        SelectIndicator.Size = UDim2.new(0, 3, 0, 0)
        SelectIndicator.Position = UDim2.new(0, 0, 0.5, 0)
        SelectIndicator.AnchorPoint = Vector2.new(0, 0.5)
        SelectIndicator.ZIndex = 6
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = SelectIndicator
        
        -- Tab Content Page
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = name .. "Page"
        TabPage.Parent = ContentArea
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.Size = UDim2.new(1, -20, 1, -20)
        TabPage.Position = UDim2.new(0, 10, 0, 10)
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = Theme.Primary
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.Visible = false
        TabPage.ZIndex = 3
        
        local PageListLayout = Instance.new("UIListLayout")
        PageListLayout.Parent = TabPage
        PageListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageListLayout.Padding = UDim.new(0, 8)
        
        PageListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageListLayout.AbsoluteContentSize.Y + 20)
        end)
        
        Tab.Page = TabPage
        Tab.Button = TabButton
        
        -- Tab selection function
        local function SelectTab()
            -- Deselect all tabs
            for _, t in pairs(Window.Tabs) do
                CreateTween(t.Button, {BackgroundTransparency = 1}, 0.2):Play()
                CreateTween(t.Label, {TextColor3 = Theme.TextDark}, 0.2):Play()
                if t.Icon then
                    CreateTween(t.Icon, {ImageColor3 = Theme.TextDark}, 0.2):Play()
                end
                CreateTween(t.Button:FindFirstChild("SelectIndicator"), {Size = UDim2.new(0, 3, 0, 0)}, 0.2):Play()
                t.Page.Visible = false
            end
            
            -- Select this tab
            CreateTween(TabButton, {BackgroundTransparency = 0.8}, 0.2):Play()
            CreateTween(TabLabel, {TextColor3 = Theme.Primary}, 0.2):Play()
            if Tab.Icon then
                CreateTween(Tab.Icon, {ImageColor3 = Theme.Primary}, 0.2):Play()
            end
            CreateTween(SelectIndicator, {Size = UDim2.new(0, 3, 0.6, 0)}, 0.3, Enum.EasingStyle.Back):Play()
            TabPage.Visible = true
            Window.CurrentTab = Tab
        end
        
        TabButton.MouseButton1Click:Connect(function()
            SelectTab()
            Ripple(TabButton, Mouse.X, Mouse.Y)
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                CreateTween(TabButton, {BackgroundTransparency = 0.9}, 0.2):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                CreateTween(TabButton, {BackgroundTransparency = 1}, 0.2):Play()
            end
        end)
        
        -- Auto-select first tab
        if tabIndex == 1 then
            SelectTab()
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- Element creation functions
        function Tab:CreateButton(options)
            local Button = {}
            local name = options.Name or "Button"
            local callback = options.Callback or function() end
            
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Name = name
            ButtonFrame.Parent = TabPage
            ButtonFrame.BackgroundColor3 = Theme.Card
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.Font = Enum.Font.GothamSemibold
            ButtonFrame.Text = ""
            ButtonFrame.ZIndex = 4
            ButtonFrame.AutoButtonColor = false
            ButtonFrame.ClipsDescendants = true
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = ButtonFrame
            
            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Name = "Label"
            ButtonLabel.Parent = ButtonFrame
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Size = UDim2.new(1, -20, 1, 0)
            ButtonLabel.Position = UDim2.new(0, 15, 0, 0)
            ButtonLabel.Font = Enum.Font.GothamSemibold
            ButtonLabel.Text = name
            ButtonLabel.TextColor3 = Theme.Text
            ButtonLabel.TextSize = 14
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
            ButtonLabel.ZIndex = 5
            
            local ButtonIcon = Instance.new("TextLabel")
            ButtonIcon.Name = "Icon"
            ButtonIcon.Parent = ButtonFrame
            ButtonIcon.BackgroundTransparency = 1
            ButtonIcon.Size = UDim2.new(0, 20, 0, 20)
            ButtonIcon.Position = UDim2.new(1, -30, 0.5, 0)
            ButtonIcon.AnchorPoint = Vector2.new(0, 0.5)
            ButtonIcon.Font = Enum.Font.GothamBold
            ButtonIcon.Text = "→"
            ButtonIcon.TextColor3 = Theme.Primary
            ButtonIcon.TextSize = 16
            ButtonIcon.ZIndex = 5
            
            ButtonFrame.MouseEnter:Connect(function()
                CreateTween(ButtonFrame, {BackgroundColor3 = Theme.BackgroundSecondary}, 0.2):Play()
                CreateTween(ButtonIcon, {Position = UDim2.new(1, -25, 0.5, 0)}, 0.2):Play()
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                CreateTween(ButtonFrame, {BackgroundColor3 = Theme.Card}, 0.2):Play()
                CreateTween(ButtonIcon, {Position = UDim2.new(1, -30, 0.5, 0)}, 0.2):Play()
            end)
            
            ButtonFrame.MouseButton1Click:Connect(function()
                Ripple(ButtonFrame, Mouse.X, Mouse.Y)
                callback()
            end)
            
            Button.Frame = ButtonFrame
            table.insert(Tab.Elements, Button)
            return Button
        end
        
        function Tab:CreateToggle(options)
            local Toggle = {}
            local name = options.Name or "Toggle"
            local default = options.Default or false
            local callback = options.Callback or function() end
            
            Toggle.Value = default
            
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Name = name
            ToggleFrame.Parent = TabPage
            ToggleFrame.BackgroundColor3 = Theme.Card
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.Text = ""
            ToggleFrame.ZIndex = 4
            ToggleFrame.AutoButtonColor = false
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "Label"
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.Text = name
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.ZIndex = 5
            
            local ToggleSwitch = Instance.new("Frame")
            ToggleSwitch.Name = "Switch"
            ToggleSwitch.Parent = ToggleFrame
            ToggleSwitch.BackgroundColor3 = default and Theme.Primary or Theme.Divider
            ToggleSwitch.BorderSizePixel = 0
            ToggleSwitch.Size = UDim2.new(0, 44, 0, 24)
            ToggleSwitch.Position = UDim2.new(1, -55, 0.5, 0)
            ToggleSwitch.AnchorPoint = Vector2.new(0, 0.5)
            ToggleSwitch.ZIndex = 5
            
            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = ToggleSwitch
            
            local ToggleKnob = Instance.new("Frame")
            ToggleKnob.Name = "Knob"
            ToggleKnob.Parent = ToggleSwitch
            ToggleKnob.BackgroundColor3 = Theme.Text
            ToggleKnob.BorderSizePixel = 0
            ToggleKnob.Size = UDim2.new(0, 18, 0, 18)
            ToggleKnob.Position = default and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            ToggleKnob.AnchorPoint = Vector2.new(0, 0.5)
            ToggleKnob.ZIndex = 6
            
            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(1, 0)
            KnobCorner.Parent = ToggleKnob
            
            local function UpdateToggle()
                if Toggle.Value then
                    CreateTween(ToggleSwitch, {BackgroundColor3 = Theme.Primary}, 0.3):Play()
                    CreateTween(ToggleKnob, {Position = UDim2.new(1, -21, 0.5, 0)}, 0.3, Enum.EasingStyle.Back):Play()
                else
                    CreateTween(ToggleSwitch, {BackgroundColor3 = Theme.Divider}, 0.3):Play()
                    CreateTween(ToggleKnob, {Position = UDim2.new(0, 3, 0.5, 0)}, 0.3, Enum.EasingStyle.Back):Play()
                end
            end
            
            ToggleFrame.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                UpdateToggle()
                callback(Toggle.Value)
            end)
            
            ToggleFrame.MouseEnter:Connect(function()
                CreateTween(ToggleFrame, {BackgroundColor3 = Theme.BackgroundSecondary}, 0.2):Play()
            end)
            
            ToggleFrame.MouseLeave:Connect(function()
                CreateTween(ToggleFrame, {BackgroundColor3 = Theme.Card}, 0.2):Play()
            end)
            
            function Toggle:Set(value)
                Toggle.Value = value
                UpdateToggle()
                callback(value)
            end
            
            Toggle.Frame = ToggleFrame
            table.insert(Tab.Elements, Toggle)
            return Toggle
        end
        
        function Tab:CreateSlider(options)
            local Slider = {}
            local name = options.Name or "Slider"
            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local callback = options.Callback or function() end
            
            Slider.Value = default
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = name
            SliderFrame.Parent = TabPage
            SliderFrame.BackgroundColor3 = Theme.Card
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Size = UDim2.new(1, 0, 0, 55)
            SliderFrame.ZIndex = 4
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "Label"
            SliderLabel.Parent = SliderFrame
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Size = UDim2.new(1, -70, 0, 25)
            SliderLabel.Position = UDim2.new(0, 15, 0, 5)
            SliderLabel.Font = Enum.Font.GothamSemibold
            SliderLabel.Text = name
            SliderLabel.TextColor3 = Theme.Text
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.ZIndex = 5
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Name = "Value"
            SliderValue.Parent = SliderFrame
            SliderValue.BackgroundTransparency = 1
            SliderValue.Size = UDim2.new(0, 50, 0, 25)
            SliderValue.Position = UDim2.new(1, -60, 0, 5)
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = Theme.Primary
            SliderValue.TextSize = 14
            SliderValue.ZIndex = 5
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Name = "Bar"
            SliderBar.Parent = SliderFrame
            SliderBar.BackgroundColor3 = Theme.Divider
            SliderBar.BorderSizePixel = 0
            SliderBar.Size = UDim2.new(1, -30, 0, 6)
            SliderBar.Position = UDim2.new(0, 15, 0, 38)
            SliderBar.ZIndex = 5
            
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "Fill"
            SliderFill.Parent = SliderBar
            SliderFill.BackgroundColor3 = Theme.Primary
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.ZIndex = 6
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SliderFill
            
            local SliderKnob = Instance.new("Frame")
            SliderKnob.Name = "Knob"
            SliderKnob.Parent = SliderBar
            SliderKnob.BackgroundColor3 = Theme.Text
            SliderKnob.BorderSizePixel = 0
            SliderKnob.Size = UDim2.new(0, 16, 0, 16)
            SliderKnob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
            SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
            SliderKnob.ZIndex = 7
            
            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(1, 0)
            KnobCorner.Parent = SliderKnob
            
            -- Glow on knob
            local KnobGlow = Instance.new("ImageLabel")
            KnobGlow.Name = "Glow"
            KnobGlow.Parent = SliderKnob
            KnobGlow.BackgroundTransparency = 1
            KnobGlow.Size = UDim2.new(1, 20, 1, 20)
            KnobGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
            KnobGlow.AnchorPoint = Vector2.new(0.5, 0.5)
            KnobGlow.Image = "rbxassetid://5028857084"
            KnobGlow.ImageColor3 = Theme.Primary
            KnobGlow.ImageTransparency = 0.7
            KnobGlow.ZIndex = 6
            
            local dragging = false
            
            local function UpdateSlider(input)
                local barAbsPos = SliderBar.AbsolutePosition.X
                local barAbsSize = SliderBar.AbsoluteSize.X
                local mouseX = input.Position.X
                
                local relativeX = math.clamp((mouseX - barAbsPos) / barAbsSize, 0, 1)
                local value = math.floor(min + (max - min) * relativeX)
                
                Slider.Value = value
                SliderValue.Text = tostring(value)
                
                CreateTween(SliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.1):Play()
                CreateTween(SliderKnob, {Position = UDim2.new(relativeX, 0, 0.5, 0)}, 0.1):Play()
                
                callback(value)
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    UpdateSlider(input)
                end
            end)
            
            SliderKnob.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            function Slider:Set(value)
                Slider.Value = value
                SliderValue.Text = tostring(value)
                local relativeX = (value - min) / (max - min)
                CreateTween(SliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.2):Play()
                CreateTween(SliderKnob, {Position = UDim2.new(relativeX, 0, 0.5, 0)}, 0.2):Play()
                callback(value)
            end
            
            Slider.Frame = SliderFrame
            table.insert(Tab.Elements, Slider)
            return Slider
        end
        
        function Tab:CreateDropdown(options)
            local Dropdown = {}
            local name = options.Name or "Dropdown"
            local items = options.Items or {}
            local default = options.Default or nil
            local callback = options.Callback or function() end
            
            Dropdown.Value = default
            Dropdown.Open = false
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = name
            DropdownFrame.Parent = TabPage
            DropdownFrame.BackgroundColor3 = Theme.Card
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.ZIndex = 4
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "Button"
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 0, 40)
            DropdownButton.Text = ""
            DropdownButton.ZIndex = 5
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Name = "Label"
            DropdownLabel.Parent = DropdownButton
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Size = UDim2.new(0.5, 0, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 15, 0, 0)
            DropdownLabel.Font = Enum.Font.GothamSemibold
            DropdownLabel.Text = name
            DropdownLabel.TextColor3 = Theme.Text
            DropdownLabel.TextSize = 14
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.ZIndex = 6
            
            local DropdownSelected = Instance.new("TextLabel")
            DropdownSelected.Name = "Selected"
            DropdownSelected.Parent = DropdownButton
            DropdownSelected.BackgroundTransparency = 1
            DropdownSelected.Size = UDim2.new(0.4, -30, 1, 0)
            DropdownSelected.Position = UDim2.new(0.5, 0, 0, 0)
            DropdownSelected.Font = Enum.Font.Gotham
            DropdownSelected.Text = default or "Select..."
            DropdownSelected.TextColor3 = Theme.TextDark
            DropdownSelected.TextSize = 13
            DropdownSelected.TextXAlignment = Enum.TextXAlignment.Right
            DropdownSelected.ZIndex = 6
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Name = "Arrow"
            DropdownArrow.Parent = DropdownButton
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
            DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
            DropdownArrow.Font = Enum.Font.GothamBold
            DropdownArrow.Text = "▼"
            DropdownArrow.TextColor3 = Theme.Primary
            DropdownArrow.TextSize = 10
            DropdownArrow.ZIndex = 6
            
            local DropdownList = Instance.new("Frame")
            DropdownList.Name = "List"
            DropdownList.Parent = DropdownFrame
            DropdownList.BackgroundTransparency = 1
            DropdownList.Size = UDim2.new(1, -20, 0, 0)
            DropdownList.Position = UDim2.new(0, 10, 0, 45)
            DropdownList.ZIndex = 5
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Parent = DropdownList
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 3)
            
            local function CreateItem(itemName)
                local ItemButton = Instance.new("TextButton")
                ItemButton.Name = itemName
                ItemButton.Parent = DropdownList
                ItemButton.BackgroundColor3 = Theme.BackgroundSecondary
                ItemButton.BackgroundTransparency = 0.5
                ItemButton.BorderSizePixel = 0
                ItemButton.Size = UDim2.new(1, 0, 0, 30)
                ItemButton.Font = Enum.Font.Gotham
                ItemButton.Text = itemName
                ItemButton.TextColor3 = Theme.Text
                ItemButton.TextSize = 13
                ItemButton.ZIndex = 6
                ItemButton.AutoButtonColor = false
                
                local ItemCorner = Instance.new("UICorner")
                ItemCorner.CornerRadius = UDim.new(0, 6)
                ItemCorner.Parent = ItemButton
                
                ItemButton.MouseEnter:Connect(function()
                    CreateTween(ItemButton, {BackgroundColor3 = Theme.Primary, BackgroundTransparency = 0.7}, 0.2):Play()
                end)
                
                ItemButton.MouseLeave:Connect(function()
                    CreateTween(ItemButton, {BackgroundColor3 = Theme.BackgroundSecondary, BackgroundTransparency = 0.5}, 0.2):Play()
                end)
                
                ItemButton.MouseButton1Click:Connect(function()
                    Dropdown.Value = itemName
                    DropdownSelected.Text = itemName
                    CreateTween(DropdownSelected, {TextColor3 = Theme.Primary}, 0.2):Play()
                    Dropdown:Toggle()
                    callback(itemName)
                end)
            end
            
            for _, item in ipairs(items) do
                CreateItem(item)
            end
            
            function Dropdown:Toggle()
                Dropdown.Open = not Dropdown.Open
                local itemCount = #items
                local targetHeight = Dropdown.Open and (40 + 5 + (itemCount * 33)) or 40
                
                CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.3, Enum.EasingStyle.Quint):Play()
                CreateTween(DropdownArrow, {Rotation = Dropdown.Open and 180 or 0}, 0.3):Play()
            end
            
            function Dropdown:Set(value)
                Dropdown.Value = value
                DropdownSelected.Text = value
                callback(value)
            end
            
            function Dropdown:Refresh(newItems)
                items = newItems
                for _, child in ipairs(DropdownList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                for _, item in ipairs(items) do
                    CreateItem(item)
                end
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                Dropdown:Toggle()
            end)
            
            DropdownButton.MouseEnter:Connect(function()
                CreateTween(DropdownFrame, {BackgroundColor3 = Theme.BackgroundSecondary}, 0.2):Play()
            end)
            
            DropdownButton.MouseLeave:Connect(function()
                if not Dropdown.Open then
                    CreateTween(DropdownFrame, {BackgroundColor3 = Theme.Card}, 0.2):Play()
                end
            end)
            
            Dropdown.Frame = DropdownFrame
            table.insert(Tab.Elements, Dropdown)
            return Dropdown
        end
        
        function Tab:CreateMultiDropdown(options)
            local MultiDropdown = {}
            local name = options.Name or "Multi Dropdown"
            local items = options.Items or {}
            local defaults = options.Default or {}
            local callback = options.Callback or function() end
            
            MultiDropdown.Values = {}
            for _, v in ipairs(defaults) do
                MultiDropdown.Values[v] = true
            end
            MultiDropdown.Open = false
            
            local function GetSelectedText()
                local selected = {}
                for item, isSelected in pairs(MultiDropdown.Values) do
                    if isSelected then
                        table.insert(selected, item)
                    end
                end
                if #selected == 0 then
                    return "None selected"
                elseif #selected <= 2 then
                    return table.concat(selected, ", ")
                else
                    return #selected .. " selected"
                end
            end
            
            local MultiFrame = Instance.new("Frame")
            MultiFrame.Name = name
            MultiFrame.Parent = TabPage
            MultiFrame.BackgroundColor3 = Theme.Card
            MultiFrame.BorderSizePixel = 0
            MultiFrame.Size = UDim2.new(1, 0, 0, 40)
            MultiFrame.ClipsDescendants = true
            MultiFrame.ZIndex = 4
            
            local MultiCorner = Instance.new("UICorner")
            MultiCorner.CornerRadius = UDim.new(0, 8)
            MultiCorner.Parent = MultiFrame
            
            local MultiButton = Instance.new("TextButton")
            MultiButton.Name = "Button"
            MultiButton.Parent = MultiFrame
            MultiButton.BackgroundTransparency = 1
            MultiButton.Size = UDim2.new(1, 0, 0, 40)
            MultiButton.Text = ""
            MultiButton.ZIndex = 5
            
            local MultiLabel = Instance.new("TextLabel")
            MultiLabel.Name = "Label"
            MultiLabel.Parent = MultiButton
            MultiLabel.BackgroundTransparency = 1
            MultiLabel.Size = UDim2.new(0.4, 0, 1, 0)
            MultiLabel.Position = UDim2.new(0, 15, 0, 0)
            MultiLabel.Font = Enum.Font.GothamSemibold
            MultiLabel.Text = name
            MultiLabel.TextColor3 = Theme.Text
            MultiLabel.TextSize = 14
            MultiLabel.TextXAlignment = Enum.TextXAlignment.Left
            MultiLabel.ZIndex = 6
            
            local MultiSelected = Instance.new("TextLabel")
            MultiSelected.Name = "Selected"
            MultiSelected.Parent = MultiButton
            MultiSelected.BackgroundTransparency = 1
            MultiSelected.Size = UDim2.new(0.5, -30, 1, 0)
            MultiSelected.Position = UDim2.new(0.4, 0, 0, 0)
            MultiSelected.Font = Enum.Font.Gotham
            MultiSelected.Text = GetSelectedText()
            MultiSelected.TextColor3 = Theme.TextDark
            MultiSelected.TextSize = 12
            MultiSelected.TextXAlignment = Enum.TextXAlignment.Right
            MultiSelected.TextTruncate = Enum.TextTruncate.AtEnd
            MultiSelected.ZIndex = 6
            
            local MultiArrow = Instance.new("TextLabel")
            MultiArrow.Name = "Arrow"
            MultiArrow.Parent = MultiButton
            MultiArrow.BackgroundTransparency = 1
            MultiArrow.Size = UDim2.new(0, 20, 1, 0)
            MultiArrow.Position = UDim2.new(1, -25, 0, 0)
            MultiArrow.Font = Enum.Font.GothamBold
            MultiArrow.Text = "▼"
            MultiArrow.TextColor3 = Theme.Primary
            MultiArrow.TextSize = 10
            MultiArrow.ZIndex = 6
            
            local MultiList = Instance.new("Frame")
            MultiList.Name = "List"
            MultiList.Parent = MultiFrame
            MultiList.BackgroundTransparency = 1
            MultiList.Size = UDim2.new(1, -20, 0, 0)
            MultiList.Position = UDim2.new(0, 10, 0, 45)
            MultiList.ZIndex = 5
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Parent = MultiList
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 3)
            
            local function CreateItem(itemName)
                local ItemButton = Instance.new("TextButton")
                ItemButton.Name = itemName
                ItemButton.Parent = MultiList
                ItemButton.BackgroundColor3 = MultiDropdown.Values[itemName] and Theme.Primary or Theme.BackgroundSecondary
                ItemButton.BackgroundTransparency = MultiDropdown.Values[itemName] and 0.7 or 0.5
                ItemButton.BorderSizePixel = 0
                ItemButton.Size = UDim2.new(1, 0, 0, 30)
                ItemButton.Font = Enum.Font.Gotham
                ItemButton.Text = itemName
                ItemButton.TextColor3 = Theme.Text
                ItemButton.TextSize = 13
                ItemButton.ZIndex = 6
                ItemButton.AutoButtonColor = false
                
                local ItemCorner = Instance.new("UICorner")
                ItemCorner.CornerRadius = UDim.new(0, 6)
                ItemCorner.Parent = ItemButton
                
                local Checkmark = Instance.new("TextLabel")
                Checkmark.Name = "Check"
                Checkmark.Parent = ItemButton
                Checkmark.BackgroundTransparency = 1
                Checkmark.Size = UDim2.new(0, 20, 1, 0)
                Checkmark.Position = UDim2.new(1, -25, 0, 0)
                Checkmark.Font = Enum.Font.GothamBold
                Checkmark.Text = MultiDropdown.Values[itemName] and "✓" or ""
                Checkmark.TextColor3 = Theme.Primary
                Checkmark.TextSize = 14
                Checkmark.ZIndex = 7
                
                local function UpdateItem()
                    local isSelected = MultiDropdown.Values[itemName]
                    CreateTween(ItemButton, {
                        BackgroundColor3 = isSelected and Theme.Primary or Theme.BackgroundSecondary,
                        BackgroundTransparency = isSelected and 0.7 or 0.5
                    }, 0.2):Play()
                    Checkmark.Text = isSelected and "✓" or ""
                end
                
                ItemButton.MouseButton1Click:Connect(function()
                    MultiDropdown.Values[itemName] = not MultiDropdown.Values[itemName]
                    UpdateItem()
                    MultiSelected.Text = GetSelectedText()
                    
                    local selectedItems = {}
                    for item, isSelected in pairs(MultiDropdown.Values) do
                        if isSelected then
                            table.insert(selectedItems, item)
                        end
                    end
                    callback(selectedItems)
                end)
                
                ItemButton.MouseEnter:Connect(function()
                    if not MultiDropdown.Values[itemName] then
                        CreateTween(ItemButton, {BackgroundTransparency = 0.3}, 0.2):Play()
                    end
                end)
                
                ItemButton.MouseLeave:Connect(function()
                    if not MultiDropdown.Values[itemName] then
                        CreateTween(ItemButton, {BackgroundTransparency = 0.5}, 0.2):Play()
                    end
                end)
            end
            
            for _, item in ipairs(items) do
                CreateItem(item)
            end
            
            function MultiDropdown:Toggle()
                MultiDropdown.Open = not MultiDropdown.Open
                local itemCount = #items
                local targetHeight = MultiDropdown.Open and (40 + 5 + (itemCount * 33)) or 40
                
                CreateTween(MultiFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.3, Enum.EasingStyle.Quint):Play()
                CreateTween(MultiArrow, {Rotation = MultiDropdown.Open and 180 or 0}, 0.3):Play()
            end
            
            function MultiDropdown:Set(values)
                MultiDropdown.Values = {}
                for _, v in ipairs(values) do
                    MultiDropdown.Values[v] = true
                end
                MultiSelected.Text = GetSelectedText()
                -- Update all item buttons
                for _, child in ipairs(MultiList:GetChildren()) do
                    if child:IsA("TextButton") then
                        local isSelected = MultiDropdown.Values[child.Name]
                        child.BackgroundColor3 = isSelected and Theme.Primary or Theme.BackgroundSecondary
                        child.BackgroundTransparency = isSelected and 0.7 or 0.5
                        child:FindFirstChild("Check").Text = isSelected and "✓" or ""
                    end
                end
                callback(values)
            end
            
            MultiButton.MouseButton1Click:Connect(function()
                MultiDropdown:Toggle()
            end)
            
            MultiButton.MouseEnter:Connect(function()
                CreateTween(MultiFrame, {BackgroundColor3 = Theme.BackgroundSecondary}, 0.2):Play()
            end)
            
            MultiButton.MouseLeave:Connect(function()
                if not MultiDropdown.Open then
                    CreateTween(MultiFrame, {BackgroundColor3 = Theme.Card}, 0.2):Play()
                end
            end)
            
            MultiDropdown.Frame = MultiFrame
            table.insert(Tab.Elements, MultiDropdown)
            return MultiDropdown
        end
        
        function Tab:CreateLabel(text)
            local Label = {}
            
            local LabelFrame = Instance.new("TextLabel")
            LabelFrame.Name = "Label"
            LabelFrame.Parent = TabPage
            LabelFrame.BackgroundTransparency = 1
            LabelFrame.Size = UDim2.new(1, 0, 0, 25)
            LabelFrame.Font = Enum.Font.GothamSemibold
            LabelFrame.Text = text
            LabelFrame.TextColor3 = Theme.TextDark
            LabelFrame.TextSize = 12
            LabelFrame.TextXAlignment = Enum.TextXAlignment.Left
            LabelFrame.ZIndex = 4
            
            function Label:Set(newText)
                LabelFrame.Text = newText
            end
            
            Label.Frame = LabelFrame
            table.insert(Tab.Elements, Label)
            return Label
        end
        
        function Tab:CreateDivider()
            local Divider = Instance.new("Frame")
            Divider.Name = "Divider"
            Divider.Parent = TabPage
            Divider.BackgroundColor3 = Theme.Divider
            Divider.BorderSizePixel = 0
            Divider.Size = UDim2.new(1, 0, 0, 1)
            Divider.ZIndex = 4
            
            return Divider
        end
        
        return Tab
    end
    
    function Window:Destroy()
        CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
        wait(0.4)
        ScreenGui:Destroy()
    end
    
    function Window:Minimize()
        MinimizeButton.MouseButton1Click:Fire()
    end
    
    return Window
end

return Centrix
