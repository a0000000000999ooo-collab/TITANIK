--[[
    Work - Premium Interface & Advanced AutoFarm
    Integrated with StealAutoFarm Full Engine
    - High-Speed Corridor Flight (Z=-360) & Warp Snipe
    - Desync Godmode & Anti-Ragdoll Bypasses
    - Guard Strike Bounce & Re-grab Handling
    - Multi-Zone & Multi-Rarity Targeting Filters (Secret+ Priority)
    - Auto Place (Every 5 Steals) & Auto Hatch Engine
    - Auto Treadmill Mount & Tier Upgrade Engine
    - Auto Speed Trail Purchase & Equip Engine
    - Ultra Potato Mode & 3D Rendering Disabler
    - Anti-AFK & Hide "Not Enough Money" UI Alerts
    - Resizable UI + Blue/Red/White palette
]]--

local e=game:GetService("Players")
local r=game:GetService("Workspace")
local y=game:GetService("RunService")
local u=game:GetService("TweenService")
local w=game:GetService("UserInputService")
local j=game:GetService("ReplicatedStorage")
local k=game:GetService("ProximityPromptService")
local a=game:GetService("HttpService")
local TeleportService=game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local o=e.LocalPlayer
local Window=nil
local currentLang="EN"
local executorCheckCaller=typeof(checkcaller)=="function" and checkcaller or function() return false end
local safeNewCClosure=typeof(newcclosure)=="function" and newcclosure or function(fn) return fn end
local V=game:GetService("ProximityPromptService")
pcall(function()
    V.PromptButtonHoldBegan:Connect(function(e,...)
        pcall(function()
            if typeof(fireproximityprompt)=="function" then
                fireproximityprompt(e)
            end
        end)
    end)
end)
local PlayerGui = o:WaitForChild("PlayerGui")
local Camera = r.CurrentCamera

local connections = {}
local parentGui = (pcall(function() return gethui() end) and gethui()) or CoreGui

if parentGui:FindFirstChild("WorkScreenGui") then
    parentGui.WorkScreenGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WorkScreenGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui

-- Notification System Container
local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "NotificationContainer"
NotificationContainer.Size = UDim2.new(0, 300, 1, -40)
NotificationContainer.Position = UDim2.new(1, -320, 0, 20)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = ScreenGui

local UIListLayout_Notif = Instance.new("UIListLayout")
UIListLayout_Notif.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayout_Notif.VerticalAlignment = Enum.VerticalAlignment.Bottom
UIListLayout_Notif.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_Notif.Padding = UDim.new(0, 10)
UIListLayout_Notif.Parent = NotificationContainer

local function Notify(title, message, duration)
    duration = duration or 3
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 300, 0, 65)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    NotifFrame.BackgroundTransparency = 1
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Position = UDim2.new(1, 40, 0, 0)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = NotifFrame
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(45, 45, 55)
    UIStroke.Transparency = 1
    UIStroke.Thickness = 1
    UIStroke.Parent = NotifFrame
    local AccentLine = Instance.new("Frame")
    AccentLine.Size = UDim2.new(0, 3, 1, -16)
    AccentLine.Position = UDim2.new(0, 8, 0, 8)
    AccentLine.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
    AccentLine.BorderSizePixel = 0
    AccentLine.BackgroundTransparency = 1
    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(1, 0)
    AccentCorner.Parent = AccentLine
    AccentLine.Parent = NotifFrame
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -30, 0, 20)
    TitleLabel.Position = UDim2.new(0, 22, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextTransparency = 1
    TitleLabel.Parent = NotifFrame
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Size = UDim2.new(1, -30, 0, 20)
    DescLabel.Position = UDim2.new(0, 22, 0, 30)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = message
    DescLabel.TextColor3 = Color3.fromRGB(160, 160, 175)
    DescLabel.TextSize = 12
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.TextTransparency = 1
    DescLabel.Parent = NotifFrame
    NotifFrame.Parent = NotificationContainer
    u:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.05, Position = UDim2.new(0, 0, 0, 0)}):Play()
    u:Create(UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0.4}):Play()
    u:Create(AccentLine, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
    u:Create(TitleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    u:Create(DescLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    task.delay(duration, function()
        if NotifFrame and NotifFrame.Parent then
            local tweenOut = u:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1, Position = UDim2.new(1, 40, 0, 0)})
            u:Create(UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Transparency = 1}):Play()
            u:Create(AccentLine, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
            u:Create(TitleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
            u:Create(DescLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
            tweenOut:Play()
            tweenOut.Completed:Connect(function()
                NotifFrame:Destroy()
            end)
        end
    end)
end

-- Hook Proximity Prompts Globally
local function HookPrompt(prompt)
    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = 50
    end
end
for _, descendant in ipairs(r:GetDescendants()) do
    HookPrompt(descendant)
end
table.insert(connections, r.DescendantAdded:Connect(function(descendant)
    HookPrompt(descendant)
end))

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 620, 0, 420)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 140, 255)
MainStroke.Transparency = 0.5
MainStroke.Thickness = 1.4
MainStroke.Parent = MainFrame

-- UIScale for resizing
local UIScale = Instance.new("UIScale")
UIScale.Scale = 1.0
UIScale.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 55)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
TopBar.BackgroundTransparency = 0
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 200, 0, 22)
TitleLabel.Position = UDim2.new(0, 20, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Work"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Name = "SubtitleLabel"
SubtitleLabel.Size = UDim2.new(0, 200, 0, 15)
SubtitleLabel.Position = UDim2.new(0, 20, 0, 32)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Font = Enum.Font.GothamMedium
SubtitleLabel.Text = "Steal An Egg - Advanced Farm"
SubtitleLabel.TextColor3 = Color3.fromRGB(150, 165, 190)
SubtitleLabel.TextSize = 11
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubtitleLabel.Parent = TopBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 12)
CloseButton.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
CloseButton.AutoButtonColor = false
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 215)
CloseButton.TextSize = 18
CloseButton.Parent = TopBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton
CloseButton.MouseEnter:Connect(function()
    u:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 60, 80), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
CloseButton.MouseLeave:Connect(function()
    u:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 42), TextColor3 = Color3.fromRGB(200, 200, 215)}):Play()
end)
CloseButton.MouseButton1Click:Connect(function()
    local twOpen = u:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 620, 0, 420), BackgroundTransparency = 1})
    twOpen:Play()
    twOpen.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end)

-- Resize buttons (− / +)
local ResizeMinus = Instance.new("TextButton")
ResizeMinus.Size = UDim2.new(0, 24, 0, 24)
ResizeMinus.Position = UDim2.new(1, -152, 0, 15)
ResizeMinus.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
ResizeMinus.AutoButtonColor = false
ResizeMinus.Font = Enum.Font.GothamBold
ResizeMinus.Text = "−"
ResizeMinus.TextColor3 = Color3.fromRGB(200, 200, 215)
ResizeMinus.TextSize = 16
ResizeMinus.Parent = TopBar
Instance.new("UICorner", ResizeMinus).CornerRadius = UDim.new(0, 5)
ResizeMinus.MouseEnter:Connect(function()
    u:Create(ResizeMinus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 140, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
ResizeMinus.MouseLeave:Connect(function()
    u:Create(ResizeMinus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 42), TextColor3 = Color3.fromRGB(200, 200, 215)}):Play()
end)

local ResizePlus = Instance.new("TextButton")
ResizePlus.Size = UDim2.new(0, 24, 0, 24)
ResizePlus.Position = UDim2.new(1, -124, 0, 15)
ResizePlus.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
ResizePlus.AutoButtonColor = false
ResizePlus.Font = Enum.Font.GothamBold
ResizePlus.Text = "+"
ResizePlus.TextColor3 = Color3.fromRGB(200, 200, 215)
ResizePlus.TextSize = 16
ResizePlus.Parent = TopBar
Instance.new("UICorner", ResizePlus).CornerRadius = UDim.new(0, 5)
ResizePlus.MouseEnter:Connect(function()
    u:Create(ResizePlus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 60, 80), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
ResizePlus.MouseLeave:Connect(function()
    u:Create(ResizePlus, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 42), TextColor3 = Color3.fromRGB(200, 200, 215)}):Play()
end)

ResizeMinus.MouseButton1Click:Connect(function()
    local ns = math.max(0.6, UIScale.Scale - 0.1)
    u:Create(UIScale, TweenInfo.new(0.15), {Scale = ns}):Play()
end)
ResizePlus.MouseButton1Click:Connect(function()
    local ns = math.min(1.6, UIScale.Scale + 0.1)
    u:Create(UIScale, TweenInfo.new(0.15), {Scale = ns}):Play()
end)

local HeaderDivider = Instance.new("Frame")
HeaderDivider.Name = "HeaderDivider"
HeaderDivider.Size = UDim2.new(1, 0, 0, 1)
HeaderDivider.Position = UDim2.new(0, 0, 0, 55)
HeaderDivider.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
HeaderDivider.BackgroundTransparency = 0.5
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Parent = MainFrame

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 175, 1, -56)
Sidebar.Position = UDim2.new(0, 0, 0, 56)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.VerticalAlignment = Enum.VerticalAlignment.Top
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 15)
SidebarPadding.PaddingLeft = UDim.new(0, 12)
SidebarPadding.PaddingRight = UDim.new(0, 12)
SidebarPadding.Parent = Sidebar

local SidebarDivider = Instance.new("Frame")
SidebarDivider.Name = "SidebarDivider"
SidebarDivider.Size = UDim2.new(0, 1, 1, -56)
SidebarDivider.Position = UDim2.new(0, 175, 0, 56)
SidebarDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
SidebarDivider.BorderSizePixel = 0
SidebarDivider.Parent = MainFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -176, 1, -56)
ContentContainer.Position = UDim2.new(0, 176, 0, 56)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Dragging
local dragging, dragInput, dragStart, startPos
table.insert(connections, TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                conn:Disconnect()
            end
        end)
    end
end))
table.insert(connections, TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end))
table.insert(connections, w.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end))

-- Category Management
local categories = {}
local currentCategory = nil

local function CreateCategory(name, iconId)
    local CategoryButton = Instance.new("TextButton")
    CategoryButton.Name = name .. "Button"
    CategoryButton.Size = UDim2.new(1, 0, 0, 38)
    CategoryButton.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
    CategoryButton.BackgroundTransparency = 1
    CategoryButton.AutoButtonColor = false
    CategoryButton.Text = ""
    CategoryButton.Parent = Sidebar
    Instance.new("UICorner", CategoryButton).CornerRadius = UDim.new(0, 10)

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 18, 0, 18)
    Icon.Position = UDim2.new(0, 12, 0.5, -9)
    Icon.BackgroundTransparency = 1
    Icon.Image = iconId or "rbxassetid://10723346959"
    Icon.ImageColor3 = Color3.fromRGB(150, 165, 190)
    Icon.Parent = CategoryButton

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 38, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamMedium
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(150, 165, 190)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = CategoryButton

    local PageFrame = Instance.new("ScrollingFrame")
    PageFrame.Name = name .. "Page"
    PageFrame.Size = UDim2.new(1, 0, 1, 0)
    PageFrame.BackgroundTransparency = 1
    PageFrame.BorderSizePixel = 0
    PageFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    PageFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    PageFrame.ScrollBarThickness = 3
    PageFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 140, 255)
    PageFrame.Visible = false
    PageFrame.Parent = ContentContainer

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PageLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 10)
    PageLayout.Parent = PageFrame

    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 16)
    PagePadding.PaddingBottom = UDim.new(0, 16)
    PagePadding.PaddingLeft = UDim.new(0, 20)
    PagePadding.PaddingRight = UDim.new(0, 20)
    PagePadding.Parent = PageFrame

    categories[name] = { Button = CategoryButton, Page = PageFrame, Icon = Icon, Label = Label }

    table.insert(connections, CategoryButton.MouseEnter:Connect(function()
        if currentCategory ~= name then
            u:Create(CategoryButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
        end
    end))
    table.insert(connections, CategoryButton.MouseLeave:Connect(function()
        if currentCategory ~= name then
            u:Create(CategoryButton, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end
    end))
    table.insert(connections, CategoryButton.MouseButton1Click:Connect(function()
        for catName, catData in pairs(categories) do
            if catName == name then
                catData.Page.Visible = true
                u:Create(catData.Button, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
                catData.Icon.ImageColor3 = Color3.fromRGB(60, 140, 255)
                catData.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                currentCategory = name
            else
                catData.Page.Visible = false
                u:Create(catData.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                catData.Icon.ImageColor3 = Color3.fromRGB(150, 165, 190)
                catData.Label.TextColor3 = Color3.fromRGB(150, 165, 190)
            end
        end
    end))

    if not currentCategory then
        currentCategory = name
        PageFrame.Visible = true
        CategoryButton.BackgroundTransparency = 0
        Icon.ImageColor3 = Color3.fromRGB(60, 140, 255)
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    return PageFrame
end

local autoFarmPage   = CreateCategory("Auto Farm", "rbxassetid://10709769841")
local eggFilterPage  = CreateCategory("Egg Selection", "rbxassetid://10723407874")
local movementPage   = CreateCategory("Movement", "rbxassetid://10747373176")
local visualsPage    = CreateCategory("Visuals", "rbxassetid://10723346959")
local playerPage     = CreateCategory("Player", "rbxassetid://10747372167")
local settingsPage   = CreateCategory("Settings", "rbxassetid://10734950309")

-- Components
local function AddToggle(parentPage, title, description, defaultState, callback)
    local toggled = defaultState or false
    local ToggleContainer = Instance.new("Frame")
    ToggleContainer.Size = UDim2.new(1, 0, 0, 50)
    ToggleContainer.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    ToggleContainer.BorderSizePixel = 0
    ToggleContainer.Parent = parentPage
    Instance.new("UICorner", ToggleContainer).CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke", ToggleContainer)
    Stroke.Color = Color3.fromRGB(42, 42, 55)
    Stroke.Transparency = 0.3
    Stroke.Thickness = 1
    local TitleLabel = Instance.new("TextLabel", ToggleContainer)
    TitleLabel.Size = UDim2.new(1, -70, 0, 18)
    TitleLabel.Position = UDim2.new(0, 15, 0, 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    local DescLabel = Instance.new("TextLabel", ToggleContainer)
    DescLabel.Size = UDim2.new(1, -70, 0, 15)
    DescLabel.Position = UDim2.new(0, 15, 0, 26)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = description or ""
    DescLabel.TextColor3 = Color3.fromRGB(150, 165, 190)
    DescLabel.TextSize = 11
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    local SwitchBg = Instance.new("Frame", ToggleContainer)
    SwitchBg.Size = UDim2.new(0, 42, 0, 22)
    SwitchBg.Position = UDim2.new(1, -54, 0.5, -11)
    SwitchBg.BackgroundColor3 = toggled and Color3.fromRGB(60, 140, 255) or Color3.fromRGB(40, 40, 52)
    SwitchBg.BorderSizePixel = 0
    Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)
    local SwitchKnob = Instance.new("Frame", SwitchBg)
    SwitchKnob.Size = UDim2.new(0, 16, 0, 16)
    SwitchKnob.Position = toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SwitchKnob.BorderSizePixel = 0
    Instance.new("UICorner", SwitchKnob).CornerRadius = UDim.new(1, 0)
    local ClickButton = Instance.new("TextButton", ToggleContainer)
    ClickButton.Size = UDim2.new(1, 0, 1, 0)
    ClickButton.BackgroundTransparency = 1
    ClickButton.Text = ""
    local function UpdateToggle(state, noCallback)
        toggled = state
        local targetColor = toggled and Color3.fromRGB(60, 140, 255) or Color3.fromRGB(40, 40, 52)
        local targetPos = toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        u:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        u:Create(SwitchKnob, TweenInfo.new(0.2), {Position = targetPos}):Play()
        if not noCallback and callback then pcall(function() callback(toggled) end) end
    end
    table.insert(connections, ClickButton.MouseButton1Click:Connect(function()
        UpdateToggle(not toggled)
    end))
    return { Set = function(state) UpdateToggle(state) end, Get = function() return toggled end }
end

local function AddSlider(parentPage, title, min, max, default, callback)
    local value = default or min
    local SliderContainer = Instance.new("Frame")
    SliderContainer.Size = UDim2.new(1, 0, 0, 60)
    SliderContainer.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    SliderContainer.BorderSizePixel = 0
    SliderContainer.Parent = parentPage
    Instance.new("UICorner", SliderContainer).CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke", SliderContainer)
    Stroke.Color = Color3.fromRGB(42, 42, 55)
    Stroke.Transparency = 0.3
    local TitleLabel = Instance.new("TextLabel", SliderContainer)
    TitleLabel.Size = UDim2.new(1, -70, 0, 18)
    TitleLabel.Position = UDim2.new(0, 15, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    local ValueLabel = Instance.new("TextLabel", SliderContainer)
    ValueLabel.Size = UDim2.new(0, 50, 0, 18)
    ValueLabel.Position = UDim2.new(1, -65, 0, 10)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Font = Enum.Font.GothamMedium
    ValueLabel.Text = tostring(value)
    ValueLabel.TextColor3 = Color3.fromRGB(60, 140, 255)
    ValueLabel.TextSize = 13
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    local SliderTrack = Instance.new("Frame", SliderContainer)
    SliderTrack.Size = UDim2.new(1, -30, 0, 6)
    SliderTrack.Position = UDim2.new(0, 15, 0, 40)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
    SliderTrack.BorderSizePixel = 0
    Instance.new("UICorner", SliderTrack).CornerRadius = UDim.new(1, 0)
    local SliderFill = Instance.new("Frame", SliderTrack)
    SliderFill.Size = UDim2.new(math.clamp((value - min) / (max - min), 0, 1), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
    SliderFill.BorderSizePixel = 0
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)
    local SliderKnob = Instance.new("Frame", SliderTrack)
    SliderKnob.Size = UDim2.new(0, 12, 0, 12)
    SliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    SliderKnob.Position = UDim2.new(SliderFill.Size.X.Scale, 0, 0.5, 0)
    SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderKnob.BorderSizePixel = 0
    Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1, 0)
    local sliding = false
    local function UpdateSlider(input)
        local posX = input.Position.X - SliderTrack.AbsolutePosition.X
        local pct = math.clamp(posX / SliderTrack.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pct)
        SliderFill.Size = UDim2.new(pct, 0, 1, 0)
        SliderKnob.Position = UDim2.new(pct, 0, 0.5, 0)
        ValueLabel.Text = tostring(value)
        if callback then pcall(function() callback(value) end) end
    end
    table.insert(connections, SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            UpdateSlider(input)
        end
    end))
    table.insert(connections, w.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end))
    table.insert(connections, w.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end))
    return {
        Set = function(val)
            value = math.clamp(val, min, max)
            local pct = (value - min) / (max - min)
            SliderFill.Size = UDim2.new(pct, 0, 1, 0)
            SliderKnob.Position = UDim2.new(pct, 0, 0.5, 0)
            ValueLabel.Text = tostring(value)
            if callback then pcall(function() callback(value) end) end
        end,
        Get = function() return value end
    }
end

local function AddButton(parentPage, title, description, callback)
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(1, 0, 0, 50)
    ButtonContainer.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    ButtonContainer.BorderSizePixel = 0
    ButtonContainer.Parent = parentPage
    Instance.new("UICorner", ButtonContainer).CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke", ButtonContainer)
    Stroke.Color = Color3.fromRGB(42, 42, 55)
    Stroke.Transparency = 0.3
    local TitleLabel = Instance.new("TextLabel", ButtonContainer)
    TitleLabel.Size = UDim2.new(1, -30, 0, 18)
    TitleLabel.Position = UDim2.new(0, 15, 0, 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    local DescLabel = Instance.new("TextLabel", ButtonContainer)
    DescLabel.Size = UDim2.new(1, -30, 0, 15)
    DescLabel.Position = UDim2.new(0, 15, 0, 26)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = description or ""
    DescLabel.TextColor3 = Color3.fromRGB(150, 165, 190)
    DescLabel.TextSize = 11
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    local ClickButton = Instance.new("TextButton", ButtonContainer)
    ClickButton.Size = UDim2.new(1, 0, 1, 0)
    ClickButton.BackgroundTransparency = 1
    ClickButton.Text = ""
    table.insert(connections, ClickButton.MouseEnter:Connect(function()
        u:Create(ButtonContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(34, 34, 46)}):Play()
    end))
    table.insert(connections, ClickButton.MouseLeave:Connect(function()
        u:Create(ButtonContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(24, 24, 32)}):Play()
    end))
    table.insert(connections, ClickButton.MouseButton1Click:Connect(function()
        if callback then pcall(callback) end
    end))
end

local function AddMultiDropdown(parentPage, title, options, selectedMap, callback)
    selectedMap = selectedMap or {}
    local isExpanded = false
    local DropdownContainer = Instance.new("Frame")
    DropdownContainer.Size = UDim2.new(1, 0, 0, 48)
    DropdownContainer.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    DropdownContainer.BorderSizePixel = 0
    DropdownContainer.ClipsDescendants = true
    DropdownContainer.Parent = parentPage
    Instance.new("UICorner", DropdownContainer).CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke", DropdownContainer)
    Stroke.Color = Color3.fromRGB(42, 42, 55)
    Stroke.Transparency = 0.3
    local TitleLabel = Instance.new("TextLabel", DropdownContainer)
    TitleLabel.Size = UDim2.new(0, 150, 0, 48)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    local function CountSelected()
        local c = 0
        for _, opt in ipairs(options) do
            if selectedMap[opt] == true then c = c + 1 end
        end
        return c
    end
    local SelectedBtn = Instance.new("TextButton", DropdownContainer)
    SelectedBtn.Size = UDim2.new(0, 160, 0, 28)
    SelectedBtn.Position = UDim2.new(1, -175, 0, 10)
    SelectedBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    SelectedBtn.Font = Enum.Font.GothamMedium
    SelectedBtn.Text = tostring(CountSelected()) .. " / " .. tostring(#options) .. "  ▼"
    SelectedBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    SelectedBtn.TextSize = 12
    Instance.new("UICorner", SelectedBtn).CornerRadius = UDim.new(0, 6)
    local ListHolder = Instance.new("ScrollingFrame", DropdownContainer)
    ListHolder.Size = UDim2.new(1, -30, 0, 0)
    ListHolder.Position = UDim2.new(0, 15, 0, 48)
    ListHolder.BackgroundTransparency = 1
    ListHolder.BorderSizePixel = 0
    ListHolder.ScrollBarThickness = 2
    ListHolder.ScrollBarImageColor3 = Color3.fromRGB(60, 140, 255)
    ListHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ListHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    local ListLayout = Instance.new("UIListLayout", ListHolder)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 4)
    local function UpdateButtonVisual(opt, btn)
        if selectedMap[opt] == true then
            btn.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
            btn.TextColor3 = Color3.fromRGB(160, 160, 175)
        end
    end
    for _, opt in ipairs(options) do
        local OptBtn = Instance.new("TextButton", ListHolder)
        OptBtn.Size = UDim2.new(1, 0, 0, 28)
        OptBtn.BorderSizePixel = 0
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.Text = tostring(opt)
        OptBtn.TextSize = 12
        Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)
        UpdateButtonVisual(opt, OptBtn)
        OptBtn.MouseButton1Click:Connect(function()
            selectedMap[opt] = not (selectedMap[opt] == true)
            UpdateButtonVisual(opt, OptBtn)
            SelectedBtn.Text = tostring(CountSelected()) .. " / " .. tostring(#options) .. "  ▼"
            if callback then pcall(function() callback(selectedMap) end) end
        end)
    end
    SelectedBtn.MouseButton1Click:Connect(function()
        isExpanded = not isExpanded
        if isExpanded then
            local listHeight = math.clamp(#options * 32, 32, 160)
            ListHolder.Size = UDim2.new(1, -30, 0, listHeight)
            u:Create(DropdownContainer, TweenInfo.new(0.25), {Size = UDim2.new(1, 0, 0, 52 + listHeight)}):Play()
        else
            u:Create(DropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 48)}):Play()
            ListHolder.Size = UDim2.new(1, -30, 0, 0)
        end
    end)
    return {
        Get = function() return selectedMap end,
        SetMap = function(newMap)
            selectedMap = newMap
            for opt, btn in pairs(selectedMap) do end
            for _, opt in ipairs(options) do end
            SelectedBtn.Text = tostring(CountSelected()) .. " / " .. tostring(#options) .. "  ▼"
            if callback then pcall(function() callback(selectedMap) end) end
        end
    }
end

-- ==========================================
-- Movement & AntiCheat Core (TPWalk)
-- ==========================================
local tpWalkEnabled = false
local currentSpeedValue = 16
local speedToggleRef = nil

local function TriggerAntiCheatBypass(silent)
    local character = o.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = rootPart
            if humanoid then
                humanoid:Destroy()
                if not silent then
                    Notify("AntiCheat", "Humanoid removed. Camera safe.", 2.5)
                end
                return true
            end
        end
    end
    return false
end

table.insert(connections, y.RenderStepped:Connect(function(dt)
    if tpWalkEnabled then
        local character = o.Character
        if character then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local cam = r.CurrentCamera
                local moveDir = Vector3.zero
                if w:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                if w:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                if w:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                if w:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                moveDir = Vector3.new(moveDir.X, 0, moveDir.Z)
                if moveDir.Magnitude > 0 then
                    local travelDist = currentSpeedValue * dt
                    rootPart.CFrame = rootPart.CFrame + (moveDir.Unit * travelDist)
                    rootPart.AssemblyLinearVelocity = Vector3.zero
                    rootPart.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end
    end
end))

speedToggleRef = AddToggle(movementPage, "TPWalk Speed", "Smooth TPWalk movement (up to 700)", false, function(state)
    tpWalkEnabled = state
    if tpWalkEnabled then
        Notify("Movement", "TPWalk Speed enabled (" .. currentSpeedValue .. ")", 2.5)
    else
        Notify("Movement", "TPWalk Speed disabled", 2.5)
    end
end)

AddSlider(movementPage, "Speed Value", 16, 700, 16, function(value)
    currentSpeedValue = value
end)

AddButton(movementPage, "AntiCheat Bypass", "Deletes Humanoid to bypass checks without breaking camera", function()
    TriggerAntiCheatBypass(false)
end)

AddButton(playerPage, "Reset Character", "Teleports character deep into void to trigger server reset", function()
    local character = o.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            humanoid = Instance.new("Humanoid")
            humanoid.Name = "Humanoid"
            humanoid.Parent = character
            task.wait(0.05)
        end
        pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end)
        local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        if rootPart then
            rootPart.CFrame = CFrame.new(0, -25000, 0)
            rootPart.AssemblyLinearVelocity = Vector3.new(0, -5000, 0)
        else
            character:MoveTo(Vector3.new(0, -25000, 0))
        end
        pcall(function() humanoid.Health = 0 end)
        Notify("Player", "Teleported to void for server reset", 2)
    end
end)

-- ==========================================
-- StealAutoFarm Full Engine (Encapsulated IIFE Module)
-- ==========================================
local AutoFarm = (function()
local e=game:GetService("Players")
local r=game:GetService("Workspace")
local y=game:GetService("RunService")
local u=game:GetService("TweenService")
local w=game:GetService("UserInputService")
local j=game:GetService("ReplicatedStorage")
local k=game:GetService("ProximityPromptService")
local a=game:GetService("HttpService")
local TeleportService=game:GetService("TeleportService")
local o=e.LocalPlayer
local Window=nil
local currentLang="EN"
local executorCheckCaller=typeof(checkcaller)=="function" and checkcaller or function() return false end
local safeNewCClosure=typeof(newcclosure)=="function" and newcclosure or function(fn) return fn end
local V=game:GetService("ProximityPromptService")
pcall(function()
    V.PromptButtonHoldBegan:Connect(function(e,...)
        pcall(function()
            if typeof(fireproximityprompt)=="function" then
                fireproximityprompt(e)
            end
        end)
    end)
end)
local H=function(...)end
local t=function(...)end
local s=nil
pcall(function() s=require((j:WaitForChild("Client",5)):WaitForChild("EggState",5)) end)
if not s then pcall(function() s=require(j.Client.EggState) end) end
local p=nil
pcall(function() p=require(((j:WaitForChild("Shared",5)):WaitForChild("Util",5)):WaitForChild("AssetItems",5)) end)
if not p then pcall(function() p=require(j.Shared.Util.AssetItems) end) end
local B=nil
pcall(function() B=require((j:WaitForChild("Shared",5)):WaitForChild("Remotes",5)) end)
if not B then pcall(function() B=require(j.Shared.Remotes) end) end

local function J(e,r,...)
    local y=(j:FindFirstChild("Packages")and j.Packages:FindFirstChild("Networking"))or j:FindFirstChild("Network")or j
    local u=y:FindFirstChild(e)or j:FindFirstChild(e)
    if u then return u end
    local w=y:FindFirstChild(e,true)or j:FindFirstChild(e,true)
    if w then return w end
    if r then
        local e=y:FindFirstChild(r)or j:FindFirstChild(r)
        if e then return e end
        local u=y:FindFirstChild(r,true)or j:FindFirstChild(r,true)
        if u then return u end
    end
    local k=string.match(e,"[^/]+$")
    if k then
        local e=y:FindFirstChild(k,true)or j:FindFirstChild(k,true)
        if e then return e end
    end
    return nil
end

local K=J("RF/EggWorld/AskPlaceEgg","AskPlaceEgg")
local c=J("RF/EggWorld/AskLiveSnapshot","AskLiveSnapshot")
local v=J("RF/Homestead/AskState","RF/Plots/AskState")or J("AskState")
local i=J("RF/EggWorld/AskFieldEggCarry","AskFieldEggCarry")
local R=J("RF/EggWorld/AskFieldEggSnapshot","AskFieldEggSnapshot")or J("Eggs: RequestAreaEggSnapshot","RequestAreaEggSnapshot")
local g=J("RF/EggWorld/AskHatch","AskHatch")or J("Eggs: RequestHatchEgg")
local Q=J("RF/EggWorld/AskFinishHatch","AskFinishHatch")or J("Eggs: RequestCompleteHatchEgg")
local P=J("RE/GuardPatrol/ForestStrike","ForestStrike")or(B and(B.GuardPatrol and B.GuardPatrol.ForestStrike))
local N=J("SpeedTollOffer","RE/GuardPatrol/SpeedTollOffer")or(B and(B.GuardPatrol and B.GuardPatrol.SpeedTollOffer))
local U=J("RF/Treadmill/AskDoff","AskDoff")
local l=J("RF/Treadmill/AskDon","AskDon")or J("RF/Treadmill/AskMount","AskMount")
local D=J("RF/Treadmill/AskTierRaise","Treadmills: RequestUpgrade","AskTierRaise")
local C=J("RF/Trailwear/AskPurchase","Trailwear: RequestPurchase","AskPurchase")
local q=J("RF/Trailwear/AskChoose","Trailwear: RequestEquip","AskChoose")
local n=J("RF/Trailwear/AskDoff","Trailwear: RequestUnequip","AskDoff")

local f={["Light Dark"]=1300,["LightDark"]=1300,["Titan Temple"]=1100,["Cherry Blossom"]=1000,["Cosmic"]=900,
["Prehistoric"]=800,["Abyss Ocean"]=700,["Volcano"]=600,["Snow"]=500,["Jungle"]=400,
["Desert"]=300,["Lake"]=200,["Forest"]=100}
local M={"Light Dark","Titan Temple","Cherry Blossom","Cosmic","Prehistoric","Abyss Ocean","Volcano","Snow","Jungle","Desert","Lake","Forest"}
local I={["Light Dark"]=420,["LightDark"]=420,["Titan Temple"]=380,["Cherry Blossom"]=330,["Cosmic"]=280,
["Prehistoric"]=240,["Abyss Ocean"]=200,["Volcano"]=180,["Snow"]=160,["Jungle"]=140,
["Desert"]=130,["Lake"]=125,["Forest"]=125}
local L=-360
local E=525
local b=620
local A=130
local S=CFrame.new(4773.7587890625,70.392112731934,-315.73501586914)

local Z="Work_FlightSpeed.txt"
local z="Work_EggSelectConfig.json"

local X={"Divine","Eternal","Secret","Cosmic","Mythic","Legendary","Epic","Rare","Uncommon","Common"}
local F={["Divine"]=6,["Eternal"]=5,["Secret"]=4,["Cosmic"]=3,["Mythic"]=2,
["Legendary"]=1,["Epic"]=0.5,["Rare"]=0.3,["Uncommon"]=0.1,["Common"]=0}

local h
local function O(...)
    local e=600
    pcall(function()
        local r=false
        if isfile then r=isfile(Z) elseif readfile then local e,y=pcall(readfile,Z)r=e and(y~=nil) end
        if r and readfile then
            local r=readfile(Z)
            local u=tonumber(r)
            if u and(u>=100 and u<=1000)then e=math.floor(u) end
        end
    end)
    return e
end
local function Y(e,...) pcall(function()
    if writefile then
        local y=math.clamp(math.floor(tonumber(e)or 600),100,1000)
        writefile(Z,tostring(y))
    end
end) end
local function T(...)
    local e=nil
    pcall(function()
        local r=false
        if isfile then r=isfile(z) elseif readfile then local e,y=pcall(readfile,z)r=e and(y~=nil) end
        if r and(readfile and a)then
            local r=readfile(z)
            if r and r~="" then
                local u=a:JSONDecode(r)
                if type(u)=="table" then e=u end
            end
        end
    end)
    local r={["Light Dark"]=true,["Titan Temple"]=true,["Cherry Blossom"]=true,["Cosmic"]=false,
    ["Prehistoric"]=false,["Abyss Ocean"]=false,["Volcano"]=false,["Snow"]=false,
    ["Jungle"]=false,["Desert"]=false,["Lake"]=false,["Forest"]=false}
    local y={["Divine"]=true,["Eternal"]=true,["Secret"]=true,["Cosmic"]=true,["Mythic"]=true,
    ["Legendary"]=false,["Epic"]=false,["Rare"]=false,["Uncommon"]=false,["Common"]=false}
    if type(e)~="table" then
        e={selectedZones=r,selectedRarities=y,alwaysCollectSecretPlus=true,minRarityTier=2,
        autoTreadmill=true,autoUpgradeTreadmill=true,autoBuyTrails=true,hideNotEnoughMoney=true,
        performanceMode=false,disable3D=false,antiAFK=true,language="EN"}
    else
        if type(e.selectedZones)~="table" then e.selectedZones=r end
        if type(e.selectedRarities)~="table" then e.selectedRarities=y
        else for r,w in ipairs(X)do if e.selectedRarities[w]==nil then e.selectedRarities[w]=(y[w]==true) end end end
        if e.alwaysCollectSecretPlus==nil then e.alwaysCollectSecretPlus=true end
        if e.minRarityTier==nil then e.minRarityTier=2 end
        if e.autoTreadmill==nil then e.autoTreadmill=true end
        if e.autoUpgradeTreadmill==nil then e.autoUpgradeTreadmill=true end
        if e.autoBuyTrails==nil then e.autoBuyTrails=true end
        if e.hideNotEnoughMoney==nil then e.hideNotEnoughMoney=true end
        if e.performanceMode==nil then e.performanceMode=false end
        if e.disable3D==nil then e.disable3D=false end
        if e.antiAFK==nil then e.antiAFK=true end
        if e.language and((e.language=="EN" or e.language=="TH"))then currentLang=e.language end
    end
    return e
end
local function x(...) pcall(function()
    if writefile and(a and h)then
        local r={selectedZones=h.selectedZones or{},selectedRarities=h.selectedRarities or{},
        alwaysCollectSecretPlus=(h.alwaysCollectSecretPlus~=false),minRarityTier=h.minRarityTier or 2,
        autoTreadmill=(h.autoTreadmill==true),autoUpgradeTreadmill=(h.autoUpgradeTreadmill==true),
        autoBuyTrails=(h.autoBuyTrails==true),hideNotEnoughMoney=(h.hideNotEnoughMoney==true),
        performanceMode=(h.performanceMode==true),disable3D=(h.disable3D==true),
        antiAFK=(h.antiAFK==true),language=currentLang or "EN"}
        local y=a:JSONEncode(r)
        writefile(z,y)
    end
end) end

local W=T()
h={godmode=true,autoGlide=true,autoHatch=true,
autoPlaceEvery5=false,
batchStealCount=0,isBatchPlacing=false,isHatching=false,
autoFarmLoop=false,pureTweenFarm=false,
glidingToTarget=false,
securingEgg=false,glideSpeed=O(),
selectedZones=W.selectedZones,selectedRarities=W.selectedRarities,
alwaysCollectSecretPlus=W.alwaysCollectSecretPlus,minRarityTier=W.minRarityTier,
autoTreadmill=(W.autoTreadmill~=false),
autoUpgradeTreadmill=(W.autoUpgradeTreadmill~=false),autoBuyTrails=(W.autoBuyTrails~=false),
hideNotEnoughMoney=true,
performanceMode=(W.performanceMode==true),disable3D=(W.disable3D==true),antiAFK=(W.antiAFK~=false),
onTreadmill=false,lastTreadmillMount=0,laneZ=-360,swapped=false,
teleporting=false,isReturning=false,
delivering=false,holdingEggForGuard=false,currentTargetModel=nil,targetPosition=nil,
stateTime=os.clock(),statusText="Ready",bestEggInfo="Scanning...",
gui=nil,
alive=true,plot=nil,
pen=nil,origin=nil,
tread=nil}

local m,e4,r4,y4,u4,w4,j4,k4,a4,o4,V4,H4,t4,s4,p4,B4,J4,K4,c4,v4,i4,R4,g4,Q4,P4,N4,U4,l4,D4,C4,q4,n4,f4,M4,I4,L4,E4,b4,A4,S4,Z4,z4,d4
local X4={}
local G4=0
local F4=nil
local h4
local O4=0
local Y4="NONE"
local T4
local x4=nil
local W4=nil
pcall(function()
    local e=game:GetService("Lighting")
    (e:GetPropertyChangedSignal("ClockTime")):Connect(function() X4={} G4=0 end)
end)
pcall(function()
    local function e(e,...)
        if e:IsA("RemoteEvent")then
            local y=string.lower(e.Name)
            if string.find(y,"reset")or string.find(y,"night")or string.find(y,"spawn")or string.find(y,"countdown")then
                pcall(function() e.OnClientEvent:Connect(function() X4={} G4=0 end) end)
            end
        end
    end
    for y,u in ipairs(j:GetDescendants())do e(u) end
    j.DescendantAdded:Connect(e)
end)

m=function(e,...)
    if not e or not e:IsA("Tool")then return false end
    local r=string.lower(e.Name)
    if string.find(r,"sword")or string.find(r,"radar")or string.find(r,"basket")or string.find(r,"punch")then return false end
    if e:GetAttribute("EggUid")or e:GetAttribute("UID")or string.find(r,"egg")or e:GetAttribute("Category")or e:GetAttribute("ItemType")=="Egg" then return true end
    return false
end
e4=function(...)
    local e=o.Character
    if e then
        for e,y in ipairs(e:GetChildren())do
            if m(y)then
                local e=y:GetAttribute("UID")or y:GetAttribute("EggUid")
                return y,e or y.Name
            end
        end
    end
    return nil,nil
end
r4=function(...)
    local e=o:FindFirstChild("Backpack")
    if e then
        for e,y in ipairs(e:GetChildren())do
            if m(y)then
                local e=y:GetAttribute("UID")or y:GetAttribute("EggUid")
                return y,e or y.Name
            end
        end
    end
    return nil,nil
end
y4=function(...)
    local e=0
    local r=o:FindFirstChild("Backpack")
    if r then
        for r,y in ipairs(r:GetChildren())do if m(y)then e=e+1 end end
    end
    local y=o.Character
    if y then
        for r,y in ipairs(y:GetChildren())do if m(y)then e=e+1 end end
    end
    return e
end
u4=function(e,...)
    if not e and not((h.pureTweenFarm or h.autoFarmLoop or h.teleporting))then return end
    local r=o.Character
    local y=r and r:FindFirstChildOfClass("Humanoid")
    local u=o:FindFirstChild("Backpack")
    if y then pcall(function() y:UnequipTools() end) end
    if r and u then
        for e,r in ipairs(r:GetChildren())do
            if r:IsA("Tool")then pcall(function() r.Parent=u end) end
        end
    end
end
w4=function(e,...)
    if((h.pureTweenFarm or h.autoFarmLoop))and not h.holdingEggForGuard then
        local e=e4()
        if e then pcall(u4) end
        return false
    end
    local r,y=e4()
    if r then
        if e then
            if y==e or not y then return true end
        else return true end
    end
    local u=o.Character
    local w=u and u:FindFirstChild("HumanoidRootPart")
    if w and w.Position.X<=(E+15)then return false end
    if s and s.ReadFieldEggs then
        local r,y=pcall(s.ReadFieldEggs)
        if r and(y and y.Records)then
            for r,y in ipairs(y.Records)do
                if((y.State=="Carried" or y.State==2))and((y.CarrierUserId==o.UserId or y.Carrier==o.UserId))then
                    if e then
                        if y.Uid==e then return true end
                    else return true end
                end
            end
        end
    end
    return false
end
j4=function(e,...)
    local r,y=e4()
    if r then
        if not e or y==e or not y then return true end
    end
    local u=o:FindFirstChild("Backpack")
    if u then
        for r,y in ipairs(u:GetChildren())do
            if m(y)then
                local r=y:GetAttribute("UID")or y:GetAttribute("EggUid")
                if not e or r==e or y.Name==tostring(e)then return true end
            end
        end
    end
    if e and(s and s.ReadFieldEggs)then
        local r,y=pcall(s.ReadFieldEggs)
        if r and(y and y.Records)then
            for r,y in ipairs(y.Records)do
                if y.Uid==e then
                    if(y.State=="Carried" or y.State==2)then
                        local e=y.CarrierUserId or y.Carrier
                        if e==o.UserId then return true end
                    end
                end
            end
        end
    end
    return false
end
local m4=false
local function ek(...)
    if m4 then return end
    local e=R or j:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot",true)or j:FindFirstChild("AskFieldEggSnapshot",true)or j:FindFirstChild("Eggs: RequestAreaEggSnapshot",true)
    if not e or not e:IsA("RemoteFunction")then return end
    m4=true
    task.spawn(function()
        local r,y=pcall(function() return e:InvokeServer() end)
        if r and type(y)=="table" then
            local e={}
            local r=y.Records or y
            if type(r)=="table" then
                for r,y in pairs(r)do
                    if type(y)=="table" then
                        if not y.Uid and type(r)=="string" then y.Uid=r end
                        table.insert(e,y)
                    end
                end
            end
            if#e>0 then F4=e G4=os.clock() end
        end
        m4=false
    end)
end
task.spawn(function()
    while true do
        task.wait(1.5)
        pcall(ek)
    end
end)

h4=function(e,...)
    local y=os.clock()
    if e or(y-G4>=1.5)or not F4 then ek() end
    local u=((F4 and#F4>0))and F4 or nil
    local w=nil
    if s and s.ReadFieldEggs then
        local e,r=pcall(s.ReadFieldEggs)
        if e and type(r)=="table" then
            local e={}
            local y=r.Records or r
            if type(y)=="table" then
                for r,y in pairs(y)do
                    if type(y)=="table" then
                        if not y.Uid and type(r)=="string" then y.Uid=r end
                        table.insert(e,y)
                    end
                end
            end
            if#e>0 then w=e end
        end
    end
    local j={}
    local k={}
    if u then
        for e,r in ipairs(u)do
            if r.Uid then k[r.Uid]=true table.insert(j,r) end
        end
    end
    if w then
        for e,r in ipairs(w)do
            if r.Uid and not k[r.Uid]then k[r.Uid]=true table.insert(j,r) end
        end
    end
    local a=r:FindFirstChild("AreaEggSlotsClient")
    if a then
        for e,r in ipairs(a:GetChildren())do
            local y=r.Name
            if y and y~="" then
                local e=r:GetPivot()
                local u=e.Position
                if u.X>=530 and not string.find(tostring(y),"FirstArea")then
                    if not k[y]then
                        k[y]=true
                        local u=r:GetAttribute("Category")or r:GetAttribute("AssetCategory")or r.Name
                        local w=r:GetAttribute("AreaId")or r:GetAttribute("Area")
                        local a=r:GetAttribute("Rarity")or r:GetAttribute("RarityTier")
                        local V=r:GetAttribute("RarityRank")or r:GetAttribute("Rank")
                        local H=r:GetAttribute("Income")or r:GetAttribute("EarningRate")
                        local t=r:GetAttribute("Scale")or r:GetAttribute("AssetScale")or 1
                        local s=r:GetAttribute("Mutations")or r:GetAttribute("Mutation")
                        table.insert(j,{Uid=y,AssetCategory=u,AreaId=w,Rarity=a,Rank=V,Income=H,BoundsCFrame=e,
                        BottomCFrame=e,CFrame=e,State="Slot",AssetScale=t,Mutations=s,PhysicalModel=r})
                    else
                        for u,w in ipairs(j)do
                            if w.Uid==y then
                                w.PhysicalModel=r
                                if not w.BoundsCFrame then w.BoundsCFrame=e end
                                if not w.AreaId or w.AreaId=="" or w.AreaId=="Unknown" then
                                    w.AreaId=r:GetAttribute("AreaId")or r:GetAttribute("Area")
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    return j
end
k4=function(e,...)
    if not e then return false,"NoUid" end
    local y=h4(false)
    if y and#y>0 then
        for r,y in ipairs(y)do
            if y.Uid==e then
                if(y.State=="Carried" or y.State==2)then
                    local e=y.CarrierUserId or y.Carrier
                    if e and e==o.UserId then return true,"CarriedBySelf" else return false,"CarriedByOther" end
                end
                if(y.State=="Slot" or y.State=="Dropped" or y.State=="GuardCarried" or y.State==1)then return true,"Available" end
                local e=y.CarrierUserId or y.Carrier
                if e then
                    if e==o.UserId then return true,"CarriedBySelf" else return false,"CarriedByOther" end
                end
                return true,"Available"
            end
        end
    end
    local u=r:FindFirstChild("AreaEggSlotsClient")
    if u then
        for r,y in ipairs(u:GetChildren())do
            if y.Name==tostring(e)or y:GetAttribute("UID")==e or y:GetAttribute("Uid")==e then
                return true,"Available"
            end
        end
    end
    return true,"Unchecked"
end
a4=function(...)
    local e,r=e4()
    if not r then
        local e,y=r4()r=y
    end
    if not r then return false end
    if s and s.ReadFieldEggs then
        local e,u=pcall(s.ReadFieldEggs)
        if e and(u and u.Records)then
            for e,u in ipairs(u.Records)do
                if u.Uid==r then
                    local e=tostring(u.AreaId or"")
                    if e=="Lake" or string.find(string.lower(e),"lake")~=nil then return true end
                end
            end
        end
    end
    if string.find(string.lower(tostring(r)),"lake")~=nil then return true end
    return false
end
o4=function(...)
    local e,r=e4()
    if not r then
        local e,y=r4()r=y
    end
    if not r then return h.glideSpeed or 350 end
    if s and s.ReadFieldEggs then
        local e,u=pcall(s.ReadFieldEggs)
        if e and(u and u.Records)then
            for e,u in ipairs(u.Records)do
                if u.Uid==r and u.AreaId then return I[u.AreaId]or h.glideSpeed or 350 end
            end
        end
    end
    return h.glideSpeed or 350
end
V4=function(e,y,...) y=y or 8
    local u=Instance.new("Part")u.Name="SafetyFloorPad_AntiVoid"u.Size=Vector3.new(28,1.5,28)u.Position=e-Vector3.new(0,3.2,0)u.Anchored=true u.Transparency=1 u.CanCollide=true u.Parent=r
    task.delay(y,function() pcall(function() u:Destroy() end) end)
    return u
end
H4=function(e,...)
    if P and e then
        pcall(function()
            local r=o.Character
            local y=r and r:FindFirstChild("HumanoidRootPart")
            local u=y and(y.CFrame*CFrame.new(0,0,-3))or CFrame.new()
            if P:IsA("RemoteFunction")then P:InvokeServer({EggUid=e,GuardCFrame=u})
            else P:FireServer({EggUid=e,GuardCFrame=u}) end
        end)
    end
end

if typeof(hookmetamethod)=="function" and not _G._DesyncAntiRagdollHooked then
    _G._DesyncAntiRagdollHooked=true
    local e
    e=hookmetamethod(game,"__newindex",safeNewCClosure(function(r,y,u,...)
        if not executorCheckCaller()and typeof(r)=="Instance" then
            if r:IsA("Motor6D")and(y=="Enabled" and u==false)then return nil end
            if r:IsA("Humanoid")then
                if y=="PlatformStand" and u==true then return nil end
                if y=="Sit" and(u==true and((h.pureTweenFarm or h.autoFarmLoop or h.isReturning or h.glidingToTarget)))then return nil end
            end
        end
        return e(r,y,u)
    end))
end

S4=function(e,...) e=e or o.Character
    if not e then return end
    local r=e:FindFirstChild("HumanoidRootPart")
    local y=e:FindFirstChild("Torso")or e:FindFirstChild("UpperTorso")or r
    if not y then return end
    for e,r in ipairs(e:GetDescendants())do
        if r:IsA("BallSocketConstraint")or r:IsA("HingeConstraint")or r:IsA("NoCollisionConstraint")then
            pcall(function() r:Destroy() end)
        end
    end
    for e,r in ipairs(e:GetDescendants())do
        if r:IsA("Motor6D")and(r.Part0 and r.Part1)then
            r.Enabled=true
            local e="RigidJointWeld_"..r.Name
            local y=r.Part1:FindFirstChild(e)
            if not y then
                local y=Instance.new("WeldConstraint")y.Name=e y.Part0=r.Part0 y.Part1=r.Part1 y.Parent=r.Part1
            end
        end
    end
end
Z4=function(e,...)
    if h and h.onTreadmill then return end
    e=e or o.Character
    if not e then return end
    local r=e:FindFirstChildOfClass("Humanoid")
    if r then
        r:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)r:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)r:SetStateEnabled(Enum.HumanoidStateType.Physics,false)r:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)r:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
        if r.PlatformStand then r.PlatformStand=false end
        if r.Sit then r.Sit=false end
    end
    for e,r in ipairs(e:GetDescendants())do
        if r:IsA("LocalScript")and((string.find(string.lower(r.Name),"ragdoll")or string.find(string.lower(r.Name),"fall")))then
            r.Disabled=true
        end
    end
    S4(e)
end
z4=function(e,...)
    if not e then return end
    Z4(e)
    for e,y in ipairs(e:GetDescendants())do
        if y:IsA("Motor6D")then
            (y:GetPropertyChangedSignal("Enabled")):Connect(function()
                if not y.Enabled then y.Enabled=true end
            end)
        end
    end
    e.DescendantAdded:Connect(function(y,...)
        if y:IsA("BallSocketConstraint")or y:IsA("HingeConstraint")or y:IsA("NoCollisionConstraint")then
            task.defer(function() pcall(function() y:Destroy() end)Z4(e) end)
        elseif y:IsA("LocalScript")and((string.find(string.lower(y.Name),"ragdoll")or string.find(string.lower(y.Name),"fall")))then
            y.Disabled=true
        end
    end)
    e.ChildAdded:Connect(function(e,...)
        if e:IsA("Tool")and(((h.pureTweenFarm or h.autoFarmLoop))and not h.holdingEggForGuard)then
            task.defer(function() u4() end)
        end
    end)
end
C4=function(...)
    if h then h.onTreadmill=false end
    local e=o.Character
    local r=e and e:FindFirstChildOfClass("Humanoid")
    local y=e and e:FindFirstChild("HumanoidRootPart")
    if U then task.spawn(function() pcall(function() U:InvokeServer() end) end) end
    if r then
        pcall(function()
            for r,y in ipairs(r:GetPlayingAnimationTracks())do
                local u=y.Animation
                local w=u and u.AnimationId or""
                if string.find(w,"10921259953")or string.find(string.lower(y.Name),"treadmill")or string.find(string.lower(y.Name),"run")then
                    y:Stop(0)
                end
            end
            r.PlatformStand=false r.Sit=false r:SetStateEnabled(Enum.HumanoidStateType.Running,true)r:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)r:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    local u=o:FindFirstChild("PlayerGui")
    if u then
        local e=u:FindFirstChild("SpeedGainAnimation")
        if e then pcall(function() e:Destroy() end) end
    end
    if y then y.AssemblyLinearVelocity=Vector3.zero y.AssemblyAngularVelocity=Vector3.zero end
    Z4(e)
end
local rk=0
local yk=false
E4=function(...)
    local e=o:FindFirstChild("PlayerGui")
    if not e then return false end
    local r=false
    pcall(function()
        for e,u in ipairs(e:GetChildren())do
            if u:IsA("ScreenGui")and u.Enabled then
                for e,u in ipairs(u:GetDescendants())do
                    if((u:IsA("TextButton")or u:IsA("ImageButton")))and u.Visible then
                        local e=(u:IsA("TextButton")and u.Text)or u.Name
                        local w=string.lower(e or"")
                        if string.find(w,"get out")or string.find(w,"treadmill")or string.find(w,"doff")or string.find(w,"leave")or string.find(w,"exit")then
                            if typeof(firesignal)=="function" and u.Activated then
                                pcall(firesignal,u.Activated)
                            elseif typeof(firesignal)=="function" and u.MouseButton1Click then
                                pcall(firesignal,u.MouseButton1Click)
                            elseif typeof(getconnections)=="function" then
                                local e=getconnections(u.MouseButton1Click)or getconnections(u.Activated)or{}
                                for e,r in ipairs(e)do pcall(function() r:Fire() end)break end
                            end
                            r=true
                            break
                        end
                    end
                end
                if r then break end
            end
        end
    end)
    return r
end
L4=function(...)
    local e=o.Character
    local r=e and e:FindFirstChild("HumanoidRootPart")
    if not r then return false end
    local y=(typeof(I4)=="function")and I4()or nil
    if y then
        local e=y.Position+Vector3.new(0,1.8,0)
        local u=((r.Position-e)).Magnitude
        if u>6 then
            if h then h.onTreadmill=false end
            return false
        end
    else
        if r.Position.X>535 then
            if h then h.onTreadmill=false end
            return false
        end
    end
    if h and h.onTreadmill then return true end
    local u=e and e:FindFirstChildOfClass("Humanoid")
    if u then
        for e,r in ipairs(u:GetPlayingAnimationTracks())do
            local y=r.Animation
            local u=y and y.AnimationId or""
            local w=string.lower(r.Name or"")
            if string.find(u,"10921259953")or string.find(w,"treadmill")or string.find(w,"run")then return true end
        end
    end
    local w=o:FindFirstChild("PlayerGui")
    if w and w:FindFirstChild("SpeedGainAnimation")then return true end
    return false
end
M4=function(...)
    if yk then return end
    if os.clock()-rk<0.8 then
        if h then h.onTreadmill=false end
        return
    end
    yk=true rk=os.clock()
    if h then h.onTreadmill=false end
    E4()
    if U then pcall(function() U:InvokeServer() end) end
    local e=o.Character
    local r=e and e:FindFirstChildOfClass("Humanoid")
    local y=e and e:FindFirstChild("HumanoidRootPart")
    if r then
        pcall(function()
            for r,y in ipairs(r:GetPlayingAnimationTracks())do
                local u=y.Animation
                local w=u and u.AnimationId or""
                local j=string.lower(y.Name or"")
                if string.find(w,"10921259953")or string.find(j,"treadmill")or string.find(j,"run")then y:Stop(0) end
            end
            r.PlatformStand=false r.Sit=false r:SetStateEnabled(Enum.HumanoidStateType.Running,true)r:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)r:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    local u=o:FindFirstChild("PlayerGui")
    if u then
        local e=u:FindFirstChild("SpeedGainAnimation")
        if e then pcall(function() e:Destroy() end) end
    end
    if y then y.AssemblyLinearVelocity=Vector3.zero y.AssemblyAngularVelocity=Vector3.zero end
    Z4(e)
    task.wait(0.15)yk=false
end
q4=M4
n4=function(...) pcall(function()
    local e=r:FindFirstChild("Plots")
    if e then
        local r=h and h.plot
        if not r and t4 then r=select(1,t4()) end
        for e,u in ipairs(e:GetChildren())do
            local w=(r~=nil and u==r)
            local j=u:FindFirstChild("TreadmillBottom")
            if j and j:IsA("BasePart")then
                if w and(h and h.autoTreadmill)then j.CanTouch=true j.CanCollide=true
                else j.CanTouch=false j.CanCollide=false end
            end
            local k=u:FindFirstChild("TreadmillUpgrade")
            if k then
                for e,r in ipairs(k:GetDescendants())do
                    if r:IsA("BasePart")then
                        if w and(h and h.autoTreadmill)then r.CanTouch=true
                        else r.CanTouch=false r.CanCollide=false end
                    end
                end
            end
        end
    end
end) end
n4()
r.DescendantAdded:Connect(function(e,...) pcall(function()
    local r=(e.Name=="TreadmillBottom" and e:IsA("BasePart"))
    local y=(e.Name=="TreadmillUpgrade" and e:IsA("Model"))
    if r or y then
        local y=h and h.plot
        if not y and t4 then y=select(1,t4()) end
        local w=y and e:IsDescendantOf(y)
        if w and(h and h.autoTreadmill)then
            if r then e.CanTouch=true e.CanCollide=true
            else for e,r in ipairs(e:GetDescendants())do if r:IsA("BasePart")then r.CanTouch=true end end end
        else
            if r then e.CanTouch=false e.CanCollide=false
            else for e,r in ipairs(e:GetDescendants())do if r:IsA("BasePart")then r.CanTouch=false r.CanCollide=false end end end
        end
    end
end) end)
D4=function(...)
    h.onTreadmill=false h.teleporting=false h.glidingToTarget=false h.securingEgg=false h.isReturning=false h.delivering=false h.holdingEggForGuard=false h.currentTargetModel=nil h.targetPosition=nil h.stateTime=os.clock()
    local e=o.Character
    local r=e and e:FindFirstChild("HumanoidRootPart")
    if r then pcall(function() r.Anchored=false r.AssemblyLinearVelocity=Vector3.zero r.AssemblyAngularVelocity=Vector3.zero end) end
    pcall(function() if C4 then C4() end end)
    pcall(function() if Z4 and e then Z4(e) end end)
    pcall(function() if u4 and((h.pureTweenFarm or h.autoFarmLoop))then u4() end end)
end
d4=function(e,y,...)
    if e then
        for e,r in ipairs(e:GetDescendants())do
            if r:IsA("ProximityPrompt")then
                pcall(function()
                    r.RequiresLineOfSight=false r.HoldDuration=0
                    if typeof(fireproximityprompt)=="function" then
                        fireproximityprompt(r,0)fireproximityprompt(r)
                    end
                end)
            end
        end
    end
    local u=r:FindFirstChild("AreaEggSlotsClient")
    if u and y then
        for e,r in ipairs(u:GetChildren())do
            local u=r:FindFirstChildWhichIsA("BasePart")or r.PrimaryPart
            if u and((u.Position-y)).Magnitude<=18 then
                for e,r in ipairs(r:GetDescendants())do
                    if r:IsA("ProximityPrompt")then
                        pcall(function()
                            r.RequiresLineOfSight=false r.HoldDuration=0
                            if typeof(fireproximityprompt)=="function" then
                                fireproximityprompt(r,0)fireproximityprompt(r)
                            end
                        end)
                    end
                end
            end
        end
    end
end
b4=function(e,...)
    h.godmode=e
    local r=o.Character
    if not r then return end
    local y=r:FindFirstChildOfClass("Humanoid")
    if y then
        y:SetStateEnabled(Enum.HumanoidStateType.Dead,not e)
        if e and y.Health<100 then y.Health=100 end
    end
    for r,y in ipairs(r:GetDescendants())do
        if y:IsA("BasePart")then
            if e then y.CanTouch=false y.CanCollide=false end
        end
    end
    Z4(r)
end

A4=function(...)
    local e=o.Character
    local y=e and e:FindFirstChildOfClass("Humanoid")
    if not e or not y then return false end
    pcall(function()
        y.BreakJointsOnDeath=false
        local w=y:Clone()w.Parent=e y:Destroy()
        local j=w:FindFirstChildOfClass("Animator")
        if not j then j=Instance.new("Animator")j.Parent=w end
        r.CurrentCamera.CameraSubject=w
        local k=e:FindFirstChild("Animate")
        if k and k:IsA("LocalScript")then
            k.Disabled=true
            task.defer(function() task.wait(0.05)k.Disabled=false end)
        end
        w:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)w:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)w:SetStateEnabled(Enum.HumanoidStateType.Running,true)w:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)w.JumpPower=math.max(50,w.JumpPower)w.JumpHeight=math.max(7.2,w.JumpHeight)w:ChangeState(Enum.HumanoidStateType.Running)
    end)
    h.swapped=true
    if h.godmode then b4(true) end
    z4(e)
    return true
end
t4=function(...)
    if h.plot and(h.plot.Parent and(h.pen and(h.origin and h.plotVerified)))then return h.plot,h.pen,h.origin end
    local e=r:FindFirstChild("Plots")
    if not e then return nil,nil,nil end
    local y=o.UserId
    local u=o.Name
    local w=o.DisplayName
    local j=nil
    local k=false
    if v then
        local r,w=pcall(function() return v:InvokeServer() end)
        if r and(type(w)=="table" and type(w.OwnersBySlot)=="table")then
            for r,w in pairs(w.OwnersBySlot)do
                if w==y or tostring(w)==tostring(y)or w==u then
                    j=e:FindFirstChild(tostring(r))
                    if j then k=true break end
                end
            end
        end
    end
    if not j and c then
        local r,u=pcall(function() return c:InvokeServer() end)
        if r and type(u)=="table" then
            for r,u in pairs(u)do
                if type(u)=="table" and((u.OwnerUserId==y or tostring(u.OwnerUserId)==tostring(y)))then
                    local y=u.Slot or r
                    j=e:FindFirstChild(tostring(y))or e:FindFirstChild(tostring(r))
                    if j then k=true break end
                end
            end
        end
    end
    if not j then
        for e,r in ipairs(e:GetChildren())do
            local a=r:GetAttribute("Owner")or r:GetAttribute("OwnerUserId")or r:GetAttribute("UserId")or r:GetAttribute("OwnerId")or r:GetAttribute("Player")
            if a and((a==y or tostring(a)==tostring(y)or a==u or tostring(a)==u or a==w))then j=r k=true break end
            for e,a in ipairs({"Owner","OwnerUserId","OwnerId","UserId","Player","PlayerName"})do
                local o=r:FindFirstChild(a)
                if o and((o.Value==y or tostring(o.Value)==tostring(y)or o.Value==u or o.Value==w))then j=r k=true break end
            end
            if j then break end
        end
    end
    if not j then
        for e,r in ipairs(e:GetChildren())do
            for e,y in ipairs(r:GetDescendants())do
                if y:IsA("TextLabel")and y.Text~="" then
                    local e=string.lower(y.Text)
                    if string.find(e,string.lower(u),1,true)or(w and string.find(e,string.lower(w),1,true))then j=r k=true break end
                end
            end
            if j then break end
        end
    end
    if not j then
        local r=o.Character
        local y=r and r:FindFirstChild("HumanoidRootPart")
        if y and y.Position.X<=(E+30)then
            local r=nil
            local u=999999
            for e,w in ipairs(e:GetChildren())do
                local j=w:FindFirstChild("CenterPoint")or w.PrimaryPart or w:FindFirstChildWhichIsA("BasePart")
                if j then
                    local e=((y.Position-j.Position)).Magnitude
                    if e<u then u=e r=w end
                end
            end
            if r and u<160 then j=r end
        end
    end
    if not j then j=e:FindFirstChild("2")or e:FindFirstChild("1")or(e:GetChildren())[1] end
    if not j then return nil,nil,nil end
    h.plot=j h.plotVerified=k h.origin=j:FindFirstChild("CenterPoint")
    local a=j:FindFirstChild("ToUpdate")
    h.pen=(a and a:FindFirstChild("PetArea"))or j:FindFirstChild("PetArea")
    h.tread=j:FindFirstChild("TreadmillBottom")
    if not h.pen and a then
        for e,r in ipairs(a:GetChildren())do
            if r:IsA("BasePart")and string.find(string.lower(r.Name),"pet")then h.pen=r break end
        end
    end
    if not h.origin then h.origin=j:FindFirstChild("CenterPoint")or h.pen or j.PrimaryPart end
    if not h.pen then h.pen=h.origin end
    return h.plot,h.pen,h.origin
end
s4=function(...)
    local e,r,y=t4()
    if r then return r.Position+Vector3.new(0,3.5,0) end
    if y then return y.Position+Vector3.new(0,3.5,0) end
    return Vector3.new(464.7,71.7,-304)
end
p4=function(e,...)
    local r,y,u=t4()
    if not y then return nil end
    local w=y.Size
    local j=math.max(4,w.X/2-5)
    local k=math.max(4,w.Z/2-5)
    for r=1,60,1 do
        local u=math.random(-math.floor(j),math.floor(j))
        local o=math.random(-math.floor(k),math.floor(k))
        local V=y.CFrame*CFrame.new(u,w.Y/2+1,o)
        local H=true
        for e,r in ipairs(e)do
            if((r-V.Position)).Magnitude<5.5 then H=false break end
        end
        if H then return V end
    end
    return y.CFrame*CFrame.new(math.random(-8,8),w.Y/2+1,math.random(-8,8))
end
B4=function(...)
    local e,r,y=t4()
    if not y or not K then return 0 end
    local u=0
    local w={}
    if c then
        local e,r=pcall(function() return c:InvokeServer() end)
        if e and type(r)=="table" then
            local e={}
            for r,y in pairs(r)do
                if type(y)=="table" and y.OwnerUserId==o.UserId then
                    for r,y in pairs(y.Records or{})do e[r]=y end
                end
            end
            for e,r in pairs(e)do
                if r.Placement and r.Placement.LocalCFrame then
                    w[#w+1]=((y.CFrame*r.Placement.LocalCFrame)).Position
                else
                    local r=p4(w)
                    if r then
                        local j=y.CFrame:ToObjectSpace(r)
                        local k,a=pcall(function() return K:InvokeServer({Uid=e,LocalCFrame=j}) end)
                        if k and a then u=u+1 w[#w+1]=r.Position end
                    end
                end
            end
        end
    end
    local j={}
    local k=o.Character
    if k then
        for e,r in ipairs(k:GetChildren())do if m(r)then table.insert(j,r) end end
    end
    local a=o:FindFirstChild("Backpack")
    if a then
        for e,r in ipairs(a:GetChildren())do if m(r)then table.insert(j,r) end end
    end
    for e,r in ipairs(j)do
        if not h.alive then break end
        local j=r:GetAttribute("UID")or r:GetAttribute("EggUid")or r.Name
        local k=p4(w)
        if k then
            local e=y.CFrame:ToObjectSpace(k)
            local r,a=pcall(function() return K:InvokeServer({Uid=j,LocalCFrame=e}) end)
            if r and a~=false then u=u+1 w[#w+1]=k.Position end
            task.wait(0.04)
        end
    end
    return u
end
J4=function(e,...)
    if(not e and not h.autoHatch)or not g or not Q or not c then return 0 end
    if h.isHatching then return 0 end
    h.isHatching=true
    local y,u=pcall(function() return c:InvokeServer() end)
    if not y or type(u)~="table" then return 0 end
    local w={}
    for e,r in pairs(u)do
        if type(r)=="table" and r.OwnerUserId==o.UserId then
            for e,r in pairs(r.Records or{})do w[e]=r end
        end
    end
    local j={}
    local k=r:GetServerTimeNow()
    for e,r in pairs(w)do
        if not h.alive then break end
        if r.Placement then
            local y=nil
            if s then
                local r=s.IsReadyToHatch or s.IsLocalEggReady
                if r then
                    local u,w=pcall(r,e)
                    if u and type(w)=="boolean" then y=w end
                end
            end
            if y==nil then
                local e=r.Placement.PlacedAt or r.Placement.Time or 0
                local u=30
                if p and(p.Assets and p.Assets[r.AssetCategory])then
                    local e=p.Assets[r.AssetCategory]u=(e and(e.Egg and e.Egg.GrowthTime))or 30
                end
                local w=u/math.max(0.01,r.GrowthSpeedMultiplier or 1)y=(k-e)>=w
            end
            if y then table.insert(j,{uid=e,category=r.AssetCategory or"Egg"}) end
        end
    end
    if#j==0 then h.isHatching=false return 0 end
    h.statusText=string.format("[Hatch] Hatching %d ready eggs...",#j)
    local a=0
    for e,r in ipairs(j)do
        task.spawn(function()
            local e,y=pcall(function()
                if g:IsA("RemoteFunction")then return g:InvokeServer(r.uid)
                else g:FireServer(r.uid) return true end
            end)
            if e and y~=false then
                task.wait(0.9)
                local e,y=pcall(function()
                    if Q:IsA("RemoteFunction")then return Q:InvokeServer(r.uid)
                    else Q:FireServer(r.uid) return true end
                end)
                if e and y~=false then a=a+1 h.hatched=((h.hatched or 0))+1 end
            end
        end)
        task.wait(0.04)
    end
    task.wait(0.95)h.isHatching=false
    return a
end
i4=function(...)
    local e={}
    local y=r:FindFirstChild("__DEBRIS")
    if y then
        for r,y in ipairs(y:GetChildren())do
            local u=y:FindFirstChild("Hitbox")
            if u and u:IsA("BasePart")then table.insert(e,u)
            elseif y:IsA("BasePart")and string.find(y.Name:lower(),"hitbox")then table.insert(e,y) end
        end
    end
    local u=r:FindFirstChild("BossArenaTeleport")
    if u then
        local r=u:FindFirstChild("Hitbox")or u:FindFirstChildWhichIsA("BasePart")or(u:IsA("BasePart")and u)
        if r and r:IsA("BasePart")then table.insert(e,r) end
    end
    return e
end
g4=function(e,r,u,...)
    local w=o.Character
    local j=w and w:FindFirstChild("HumanoidRootPart")
    local k=w and w:FindFirstChildOfClass("Humanoid")
    if not j then return false end
    if k then k.AutoRotate=false end
    local a=s4()e=math.max(100,e or h.glideSpeed or 600)
    local V=h.laneZ or L h.isReturning=true h.stateTime=os.clock()V4(a,20)j.AssemblyLinearVelocity=Vector3.zero j.AssemblyAngularVelocity=Vector3.zero
    local H=o4()
    local t=math.max(e,H)
    local s=os.clock()+25
    while h.alive and(h.isReturning and os.clock()<s)do
        if r and O4~=r then
            if k then k.AutoRotate=true end
            h.isReturning=false
            return false
        end
        if not u and(not h.pureTweenFarm and not h.autoFarmLoop)then
            if k then k.AutoRotate=true end
            h.isReturning=false
            return false
        end
        local e=j.Position
        local w=((a-e)).Magnitude
        if(e.X<=(a.X+3)and math.abs(e.Z-a.Z)<=8)or w<=6 then break end
        local o=y.Heartbeat:Wait()e=j.Position
        local H=t
        if e.X<=b and e.X>E then
            local r=math.clamp(((e.X-E))/((b-E)),0,1)H=A+(((t-A))*r)
        elseif e.X<=E then H=A end
        local s=a.Z
        if e.X>540 then s=V end
        local B=math.sign(a.X-e.X)
        local J=B*math.min(math.abs(a.X-e.X),H*o)
        local K=e.X+J
        local c=math.sign(a.Y-e.Y)
        local v=c*math.min(math.abs(a.Y-e.Y),(H*o)*0.5)
        local i=e.Y+v
        local R=s-e.Z
        local g=math.sign(R)*math.min(math.abs(R),H*o)
        local Q=e.Z+g
        local P=i4()
        local N=false
        if e.X>E then
            for e,r in ipairs(P)do
                local y=r.Position
                local u=((Vector3.new(K,i,Q)-y)).Magnitude
                local w=math.abs(K-y.X)
                local j=math.abs(Q-y.Z)
                if u<22 or(w<18 and j<14)then
                    N=true
                    local e=y.Y+16
                    if i<e then i=math.min(i+((H*o)*1.5),e) end
                    break
                end
            end
        end
        local U=Vector3.new(K,i,Q)
        local l=((U-e)).Magnitude>0.05 and((U-e)).Unit or j.CFrame.LookVector j.CFrame=CFrame.lookAt(U,U+l)j.AssemblyLinearVelocity=Vector3.zero j.AssemblyAngularVelocity=Vector3.zero
    end
    j.CFrame=CFrame.new(a)j.AssemblyLinearVelocity=Vector3.zero j.AssemblyAngularVelocity=Vector3.zero
    if k then k.AutoRotate=true end
    u4()h.isReturning=false h.delivering=false h.statusText="Arrived at Base PetArea!"
    return true
end
v4=function(e,r,y,...)
    local u=o.Character
    local w=u and u:FindFirstChild("HumanoidRootPart")
    local j=u and u:FindFirstChildOfClass("Humanoid")
    if not w or not j then return end
    local k=s4()
    local a=((w.Position-k)).Magnitude
    if a>8 then h.statusText="[Place] Tweening back to base plot..." g4(e or h.glideSpeed or 600,r,true) end
    V4(k,15)w.CFrame=CFrame.new(k)w.AssemblyLinearVelocity=Vector3.zero h.statusText="[Place] Placing All Eggs to Stand..."
    local V=os.clock()+3
    while y4()>0 and(os.clock()<V and h.alive)do B4()task.wait(0.06) end
    h.statusText="[Place] Hatching ready eggs..." J4(true)u4()h.isReturning=false h.delivering=false h.currentTargetModel=nil h.targetPosition=nil
    local H=y4()h.statusText=string.format("Placed & Hatched (Left: %d)! Hands Free.",H)
end
local uk=5
K4=function(e,...)
    if h.isBatchPlacing then return end
    h.isBatchPlacing=true
    local r=O4 h.pureTweenFarm=(e=="TWEEN")h.autoFarmLoop=(e=="WARP")
    local y=o.Character
    local u=y and y:FindFirstChild("HumanoidRootPart")
    local w=y and y:FindFirstChildOfClass("Humanoid")
    local j=s4()
    local k=u and((u.Position-j)).Magnitude or 999
    if k>8 then h.statusText="[AutoPlace] Tweening home to base plot..." g4(h.glideSpeed or 600,r,true) end
    if u then
        V4(j,20)u.CFrame=CFrame.new(j)u.AssemblyLinearVelocity=Vector3.zero u.AssemblyAngularVelocity=Vector3.zero
        if w then w.AutoRotate=true end
    end
    task.spawn(function() pcall(B4)pcall(J4,true) end)u4()
    h.isReturning=false h.delivering=false h.glidingToTarget=false h.securingEgg=false h.teleporting=false h.currentTargetModel=nil h.targetPosition=nil
    for e=5,1,-1 do
        if not h.alive then break end
        h.statusText=string.format("[AutoPlace] At Base: Resuming in %ds...",e)task.wait(1)
    end
    h.isBatchPlacing=false
    if h.alive and O4==r then
        h.statusText=string.format("[AutoPlace] Resuming %s farm...",e)
        if e=="TWEEN" then h.pureTweenFarm=true h.autoFarmLoop=false
        elseif e=="WARP" then h.autoFarmLoop=true h.pureTweenFarm=false end
        Y4=e
    end
end
c4=function(e,...)
    if not h.autoPlaceEvery5 then return false end
    h.batchStealCount=((h.batchStealCount or 0))+1
    if h.batchStealCount>=uk then
        h.batchStealCount=0
        task.spawn(function() K4(e) end)
        return true
    end
    return false
end
local function wk(e,r,u,w,...)
    local j=o.Character
    local k=j and j:FindFirstChild("HumanoidRootPart")
    local a=j and j:FindFirstChildOfClass("Humanoid")
    if not k then return false end
    if a then a.AutoRotate=false end
    r=math.max(60,r or h.glideSpeed or 350)
    local V=e.Position V4(V,14)pcall(function() o:RequestStreamAroundAsync(V) end)k.AssemblyLinearVelocity=Vector3.zero k.AssemblyAngularVelocity=Vector3.zero
    local H=h.laneZ or L h.glidingToTarget=true h.stateTime=os.clock()
    local t=0
    local s=os.clock()+15
    while h.alive and(h.glidingToTarget and os.clock()<s)do
        if w and O4~=w then
            if a then a.AutoRotate=true end
            h.glidingToTarget=false
            return false
        end
        if not h.pureTweenFarm and(not h.autoFarmLoop and not h.teleporting)then
            if a then a.AutoRotate=true end
            h.glidingToTarget=false
            return false
        end
        local e=k.Position
        local j=((V-e)).Magnitude
        local o=((Vector2.new(e.X,e.Z)-Vector2.new(V.X,V.Z))).Magnitude
        local s=math.abs(e.Y-V.Y)
        if j<=6 or(o<=3.5 and s<=6)then break end
        local B=y.Heartbeat:Wait()e=k.Position j=((V-e)).Magnitude o=((Vector2.new(e.X,e.Z)-Vector2.new(V.X,V.Z))).Magnitude
        local J=math.abs(e.X-V.X)
        if u and(os.clock()-t>0.5)then
            t=os.clock()
            local e,r=k4(u)
            if not e and r=="CarriedByOther"then
                if a then a.AutoRotate=true end
                h.glidingToTarget=false
                return false
            end
        end
        local K=V.Z
        if J>40 then K=H end
        local c=math.sign(V.X-e.X)
        local v=c*math.min(math.abs(V.X-e.X),r*B)
        local i=e.X+v
        local R=(o<=25)and 1.2 or 0.5
        local g=math.sign(V.Y-e.Y)
        local Q=g*math.min(math.abs(V.Y-e.Y),(r*B)*R)
        local P=e.Y+Q
        local N=K-e.Z
        local U=math.sign(N)*math.min(math.abs(N),r*B)
        local l=e.Z+U
        local D=false
        if o>25 then
            local e=i4()
            for e,y in ipairs(e)do
                local u=y.Position
                local w=((Vector3.new(i,P,l)-u)).Magnitude
                local j=math.abs(i-u.X)
                local k=math.abs(l-u.Z)
                if w<22 or(j<18 and k<14)then
                    D=true
                    local e=u.Y+16
                    if P<e then P=math.min(P+((r*B)*1.5),e) end
                    break
                end
            end
        end
        local C=Vector3.new(i,P,l)
        local q=((C-e)).Magnitude>0.05 and((C-e)).Unit or k.CFrame.LookVector k.CFrame=CFrame.lookAt(C,C+q)k.AssemblyLinearVelocity=Vector3.zero k.AssemblyAngularVelocity=Vector3.zero
    end
    k.CFrame=e*CFrame.new(0,0.4,0)k.AssemblyLinearVelocity=Vector3.zero k.AssemblyAngularVelocity=Vector3.zero
    if a then a.AutoRotate=true end
    h.glidingToTarget=false
    return true
end
R4=function(e,r,y,u,...)
    local w=o.Character
    local j=w and w:FindFirstChild("HumanoidRootPart")
    if j then
        local w=j.Position.X
        local a=e.Position.X
        if w<=535 and a>510 then
            local e=CFrame.new(500,70,-364)
            local a=((j.Position-e.Position)).Magnitude
            if a>5 then
                local j=wk(e,r,y,u)
                if not j then return false end
                task.wait(0.04)
            end
        end
    end
    return wk(e,r,y,u)
end
Q4=function(e,r,...)
    local u=o.Character
    local w=u and u:FindFirstChild("HumanoidRootPart")
    local j=u and u:FindFirstChildOfClass("Humanoid")
    if not w then return false end
    if j then j.AutoRotate=false end
    local k=h.laneZ or L
    local a=Vector3.new(E-10,70,k)e=math.max(100,e or h.glideSpeed or 350)h.isReturning=true h.stateTime=os.clock()V4(Vector3.new(E,70,k),20)pcall(u4)w.AssemblyLinearVelocity=Vector3.zero w.AssemblyAngularVelocity=Vector3.zero
    local V=o4()
    local H=math.max(e,V)
    local s=os.clock()+15
    while h.alive and(h.isReturning and os.clock()<s)do
        if r and O4~=r then
            if j then j.AutoRotate=true end
            h.isReturning=false
            return false
        end
        if not h.pureTweenFarm and not h.autoFarmLoop then
            if j then j.AutoRotate=true end
            h.isReturning=false
            return false
        end
        local e=w.Position
        local o=((a-e)).Magnitude
        if e.X<=(E+10)or o<=6 then u4()break end
        if u then
            for e,r in ipairs(u:GetChildren())do if r:IsA("Tool")then pcall(u4)break end end
        end
        local V=y.Heartbeat:Wait()e=w.Position
        local s=H
        if e.X<=b and e.X>E then
            local r=math.clamp(((e.X-E))/((b-E)),0,1)s=A+(((H-A))*r)
        elseif e.X<=E then s=A end
        local B=math.sign(a.X-e.X)
        local J=B*math.min(math.abs(a.X-e.X),s*V)
        local K=e.X+J
        local c=math.sign(a.Y-e.Y)
        local v=c*math.min(math.abs(a.Y-e.Y),(s*V)*0.5)
        local i=e.Y+v
        local R=k-e.Z
        local g=math.sign(R)*math.min(math.abs(R),s*V)
        local Q=e.Z+g
        local P=i4()
        local N=false
        for e,r in ipairs(P)do
            local y=r.Position
            local u=((Vector3.new(K,i,Q)-y)).Magnitude
            local w=math.abs(K-y.X)
            local j=math.abs(Q-y.Z)
            if u<22 or(w<18 and j<14)then
                N=true
                local e=y.Y+16
                if i<e then i=math.min(i+((s*V)*1.5),e) end
                break
            end
        end
        local U=Vector3.new(K,i,Q)
        local l=((U-e)).Magnitude>0.05 and((U-e)).Unit or w.CFrame.LookVector w.CFrame=CFrame.lookAt(U,U+l)w.AssemblyLinearVelocity=Vector3.zero w.AssemblyAngularVelocity=Vector3.zero
    end
    w.CFrame=CFrame.new(E,math.max(68,w.Position.Y),k)w.AssemblyLinearVelocity=Vector3.zero w.AssemblyAngularVelocity=Vector3.zero
    if j then j.AutoRotate=true end
    u4()h.isReturning=false h.delivering=false
    if h then h.onTreadmill=false end
    h.statusText="Arrived at Safe Line (X=525)! Hands Free."
    return true
end
local function jk(e,...)
    if not e then return nil end
    local r=e:FindFirstChild("TreadmillBottom")
    if r and r:IsA("BasePart")then return r end
    r=e:FindFirstChild("TreadmillBottom",true)
    if r and r:IsA("BasePart")then return r end
    local y=e:FindFirstChild("TreadmillUpgrade",true)
    if y then
        for e,r in ipairs({"TreadmillBottom","Belt","RunArea","Run","Platform","Pad","Floor","Base"})do
            local w=y:FindFirstChild(r,true)
            if w and w:IsA("BasePart")then return w end
        end
        local e=nil
        local r=999999
        for y,w in ipairs(y:GetDescendants())do
            if w:IsA("BasePart")and(w.Size.X>=1.2 and w.Size.Z>=1.2)then
                if w.Position.Y<r then r=w.Position.Y e=w end
            end
        end
        if e then return e end
        if y.PrimaryPart then return y.PrimaryPart end
        local w=y:FindFirstChildWhichIsA("BasePart",true)
        if w then return w end
    end
    for e,r in ipairs(e:GetDescendants())do
        if r:IsA("BasePart")and string.find(string.lower(r.Name),"treadmill")then return r end
    end
    return nil
end
I4=function(...)
    local e=t4()
    if h.tread and h.tread.Parent then return h.tread end
    local y=nil
    if e then y=jk(e) end
    if not y then
        local w=r:FindFirstChild("Plots")
        if w then
            local r=string.lower(o.Name)
            local j=o.DisplayName and string.lower(o.DisplayName)
            for e,w in ipairs(w:GetChildren())do
                local k=jk(w)
                if k then
                    local e=false
                    for y,w in ipairs(w:GetDescendants())do
                        if w:IsA("TextLabel")and w.Text~="" then
                            local y=string.lower(w.Text)
                            if string.find(y,r,1,true)or(j and string.find(y,j,1,true))then e=true break end
                        end
                    end
                    if e then h.plot=w h.plotVerified=true y=k break end
                end
            end
            if not y and e then y=jk(e) end
        end
    end
    h.tread=y
    return y
end
f4=function(e,...)
    local r=o.Character
    local u=r and r:FindFirstChild("HumanoidRootPart")
    local w=r and r:FindFirstChildOfClass("Humanoid")
    if not u or not w then return false end
    if w.PlatformStand then w.PlatformStand=false end
    if w.Sit then w.Sit=false end
    w:ChangeState(Enum.HumanoidStateType.Running)
    local j=t4()
    local k=I4()
    if not k then return false end
    pcall(function()
        for r,y in ipairs(r:GetChildren())do
            if y:IsA("BasePart")and y.Name~="HumanoidRootPart"then y.CanCollide=false end
        end
    end)
    pcall(function()
        k.CanTouch=true k.CanCollide=true
        local e=j and j:FindFirstChild("TreadmillUpgrade",true)
        if e then
            for e,y in ipairs(e:GetDescendants())do
                if y:IsA("BasePart")then y.CanTouch=true y.CanCollide=true end
            end
        end
        if k.Parent and k.Parent:IsA("Model")then
            for e,y in ipairs(k.Parent:GetDescendants())do
                if y:IsA("BasePart")then y.CanTouch=true y.CanCollide=true end
            end
        end
    end)
    local a=k.Position+Vector3.new(0,1.8,0)
    if u.Position.X>535 then
        Q4(h.glideSpeed,e)
        if e and O4~=e then return false end
        if u.Position.X>535 then
            if u.Position.X<=560 then u.CFrame=CFrame.new(E,70,h.laneZ or L)
            else return false end
        end
    end
    if e and O4~=e then return false end
    local V=((Vector2.new(u.Position.X,u.Position.Z)-Vector2.new(a.X,a.Z))).Magnitude
    if V>4 then
        local r=math.max(250,h.glideSpeed or 400)
        local j=os.clock()
        while h.alive and(((Vector2.new(u.Position.X,u.Position.Z)-Vector2.new(a.X,a.Z))).Magnitude>4 and(os.clock()-j<4))do
            if e and O4~=e then return false end
            local j=y.Heartbeat:Wait()
            local k=u.Position
            local o=Vector3.new(a.X,70,a.Z)
            local V=(o-k)
            local H=V.Unit*math.min(V.Magnitude,r*j)
            local t=k+H u.CFrame=CFrame.lookAt(t,t+((V.Magnitude>0.05 and V.Unit or u.CFrame.LookVector)))u.AssemblyLinearVelocity=Vector3.zero u.AssemblyAngularVelocity=Vector3.zero
            if w then
                if w.PlatformStand then w.PlatformStand=false end
                if w.Sit then w.Sit=false end
                w:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end
    if e and O4~=e then return false end
    local H=os.clock()
    while h.alive and(math.abs(u.Position.Y-a.Y)>2 and(os.clock()-H<1.5))do
        if e and O4~=e then return false end
        local r=y.Heartbeat:Wait()
        local w=u.Position
        local j=a
        local k=(j-w)
        local o=k.Unit*math.min(k.Magnitude,150*r)
        local V=w+o u.CFrame=CFrame.new(V)u.AssemblyLinearVelocity=Vector3.zero u.AssemblyAngularVelocity=Vector3.zero
    end
    u.CFrame=CFrame.new(a)u.AssemblyLinearVelocity=Vector3.zero u.AssemblyAngularVelocity=Vector3.zero
    local s=((u.Position-a)).Magnitude
    if s<=6 then
        pcall(function()
            if typeof(firetouchinterest)=="function" then
                firetouchinterest(u,k,0)task.wait(0.02)firetouchinterest(u,k,1)
            end
        end)
        pcall(function()
            for r,y in ipairs(k:GetDescendants())do
                if y:IsA("ProximityPrompt")and y.Enabled then
                    if typeof(fireproximityprompt)=="function" then fireproximityprompt(y) end
                end
            end
            if k.Parent then
                for r,y in ipairs(k.Parent:GetDescendants())do
                    if y:IsA("ProximityPrompt")and y.Enabled then
                        if typeof(fireproximityprompt)=="function" then fireproximityprompt(y) end
                    end
                end
            end
        end)
        if l then pcall(function() l:InvokeServer() end) end
        h.onTreadmill=true h.lastTreadmillMount=os.clock()h.statusText="[AutoTreadmill] Running on treadmill (Waiting for eggs...)"
        return true
    else
        h.onTreadmill=false
        return false
    end
end
local function kk(...)
    if not h or not h.hideNotEnoughMoney then return end
    local e=o:FindFirstChild("PlayerGui")
    if not e then return end
    pcall(function()
        for e,y in ipairs(e:GetDescendants())do
            if y:IsA("TextLabel")and y.Visible then
                local e=(tostring(y.Text or"")):lower()
                if e:find("not enough money")or e:find("not enough cash")or(e:find("not enough")and((e:find("money")or e:find("cash")or e:find("coin")or e:find("fund"))))then
                    y.Visible=false y.TextTransparency=1 y.TextStrokeTransparency=1
                    local e=y.Parent
                    if e and(((e:IsA("Frame")or e:IsA("CanvasGroup")))and#e:GetChildren()<=3)then e.Visible=false end
                end
            end
        end
    end)
end
local function ak(...)
    local e=o:FindFirstChild("PlayerGui")
    if not e then return end
    local function r(e,...)
        if e:IsA("TextLabel")then
            local function y(...)
                if not h or not h.hideNotEnoughMoney then return end
                local y=(tostring(e.Text or"")):lower()
                if y:find("not enough money")or y:find("not enough cash")or(y:find("not enough")and((y:find("money")or y:find("cash")or y:find("coin")or y:find("fund"))))then
                    e.Visible=false e.TextTransparency=1 e.TextStrokeTransparency=1
                    local r=e.Parent
                    if r and(((r:IsA("Frame")or r:IsA("CanvasGroup")))and#r:GetChildren()<=3)then r.Visible=false end
                end
            end
            y();
            (e:GetPropertyChangedSignal("Text")):Connect(y);
            (e:GetPropertyChangedSignal("Visible")):Connect(function() if e.Visible then y() end end)
        end
    end
    pcall(function()
        for e,y in ipairs(e:GetDescendants())do task.spawn(r,y) end
        e.DescendantAdded:Connect(r)
    end)
    task.spawn(function()
        while h and h.alive do
            if h.hideNotEnoughMoney then kk() end
            task.wait(0.25)
        end
    end)
end
task.spawn(ak)
local function ok(e,...)
    if not e then return 0 end
    local r=(((tostring(e)):gsub("[$,]","")):gsub("%s+","")):lower()
    local y=r:match("[%d%.]+")
    if not y then return 0 end
    local u=tonumber(y)
    if not u then return 0 end
    if r:find("sp")then return u*999999999999999983222784
    elseif r:find("sx")then return u*1000000000000000000000
    elseif r:find("qi")then return u*1000000000000000000
    elseif r:find("qa")or r:find("q")then return u*1000000000000000
    elseif r:find("t")then return u*1000000000000
    elseif r:find("b")then return u*1000000000
    elseif r:find("m")then return u*1000000
    elseif r:find("k")then return u*1000 end
    return u
end
local function Vk(...)
    local e=o:FindFirstChild("leaderstats")
    if e then
        for r,u in ipairs({"Money","Cash","Coins","Currency"})do
            local w=e:FindFirstChild(u)
            if w then
                local e=tonumber(w.Value)or ok(w.Value)
                if e and e>0 then return e end
            end
        end
    end
    local r=o:FindFirstChild("PlayerGui")
    if r then
        local e=r:FindFirstChild("HUD")or r:FindFirstChild("GameHUD")or r:FindFirstChild("MainHUD")or r:FindFirstChild("Main")
        if e then
            for e,r in ipairs(e:GetDescendants())do
                if r:IsA("TextLabel")and r.Visible then
                    local e=r.Name:lower()
                    if e=="money"or e=="cash"or e=="coins"or e=="currency"or e=="value"then
                        local e=ok(r.Text)
                        if e and e>0 then return e end
                    end
                end
            end
        end
    end
    return 0
end
local function Hk(...)
    local e=h.plot or(t4 and t4())
    if not e then return nil end
    local r=e:FindFirstChild("TreadmillUpgrade",true)
    if not r then return nil end
    local y=nil
    for e,r in ipairs(r:GetDescendants())do
        if r:IsA("TextLabel")or r:IsA("TextButton")then
            local e=tostring(r.Text or"")
            local w=e:match("%$([%d%.,]+%s*[kKmMbBtTqQ]?[aA]?)")
            if w then
                local e=ok(w)
                if e and e>0 then if not y or e>y then y=e end end
            end
        end
    end
    return y
end
local tk=0
local sk=10
local function pk(...)
    if not h.autoUpgradeTreadmill then return end
    if os.clock()-tk<sk then return end
    local e=h.plot or(t4 and t4())
    if not e then return end
    local r=e:FindFirstChild("TreadmillUpgrade",true)
    if not r then return end
    local y=Vk()
    local u=Hk()
    if u and(u>0 and y<u)then return end
    tk=os.clock()
    if D then pcall(function() D:InvokeServer() end) end
    local w=o.Character
    local j=w and w:FindFirstChild("HumanoidRootPart")
    pcall(function()
        for r,y in ipairs(r:GetDescendants())do
            if y:IsA("ProximityPrompt")and y.Enabled then
                if typeof(fireproximityprompt)=="function" then
                    fireproximityprompt(y,0)fireproximityprompt(y)
                end
            end
            if y:IsA("GuiButton")and y.Visible then
                local r=(y:IsA("TextButton")and y.Text)or y.Name
                local u=string.lower(r)
                if not string.find(u,"robux")and(not string.find(u,"r%$")and((string.find(u,"%$")or string.find(u,"upgrade")or string.find(u,"cash")or(y.BackgroundColor3 and y.BackgroundColor3.G>y.BackgroundColor3.R))))then
                    if typeof(firesignal)=="function" and y.Activated then
                        firesignal(y.Activated)
                    elseif typeof(firesignal)=="function" and y.MouseButton1Click then
                        firesignal(y.MouseButton1Click)
                    end
                end
            end
            if y:IsA("BasePart")and(y.Name:find("Pad")and j)then
                if((j.Position-y.Position)).Magnitude<10 then
                    if typeof(firetouchinterest)=="function" then
                        firetouchinterest(j,y,0)task.wait(0.02)firetouchinterest(j,y,1)
                    end
                end
            end
        end
    end)
end
local Bk={{id="GreyTrail",base="Grey",name="Grey Trail",price=100,mult=1.5},
{id="GreenTrail",base="Green",name="Green Trail",price=5000,mult=2},
{id="BlueTrail",base="Blue",name="Blue Trail",price=75000,mult=2.5},
{id="PurpleTrail",base="Purple",name="Purple Trail",price=1500000,mult=3},
{id="GoldenTrail",base="Golden",name="Golden Trail",price=1500000,mult=3.5},
{id="RedTrail",base="Red",name="Red Trail",price=750000000,mult=4},
{id="GalaxyTrail",base="Galaxy",name="Galaxy Trail",price=20000000000,mult=5},
{id="SecretTrail",base="Secret",name="Secret Trail",price=500000000000,mult=6},
{id="EternalTrail",base="Eternal",name="Eternal Trail",price=12500000000000,mult=10},
{id="DivineTrail",base="Divine",name="Divine Trail",price=300000000000000,mult=14},
{id="MoonbloomTrail",base="Moonbloom",name="Moonbloom Trail",price=5000000000000000,mult=20}}
local function Jk(...) return Bk end
local function Kk(...)
    local e={}
    local r=o:FindFirstChild("PlayerGui")
    local y=r and((r:FindFirstChild("TrailShop")or r:FindFirstChild("TrailShop",true)))
    local u=y and y:FindFirstChild("ScrollingFrame",true)
    if u then
        pcall(function()
            for y,u in ipairs(u:GetChildren())do
                if u:IsA("GuiObject")and(not u:IsA("UIListLayout")and not u:IsA("UIPadding"))then
                    local y=u.Name
                    for u,w in ipairs(u:GetDescendants())do
                        if w:IsA("GuiButton")or w:IsA("TextButton")then
                            local u=(w:IsA("TextButton")and w.Text:lower())or w.Name:lower()
                            if u:find("unequip")or(u:find("equip")and not u:find("unequip"))then
                                e[y]=true e[y:lower()]=true
                                local u=y:gsub("Trail","")e[u]=true e[u:lower()]=true
                            end
                        end
                    end
                end
            end
        end)
    end
    return e
end
local function ck(e,...)
    if not e then return false end
    pcall(function()
        if typeof(firebutton1click)=="function" then firebutton1click(e)
