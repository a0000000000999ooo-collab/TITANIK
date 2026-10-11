--[[
    KerryHub - Final
    Auto Steal + AntiCheat Bypass
    Safe Zone: Forest (576.7, 70.6, -368.1)
    Zones: + Angels & Demons + Enchanted Forest
    Return: Rise +10 → escape-jump → teleport-hops → descend at Forest
    Boss-lock protection: anti-anchored hook
    UI: Minimize/Restore icon
]]--

local e=game:GetService("Players")
local r=game:GetService("Workspace")
local y=game:GetService("RunService")
local u=game:GetService("TweenService")
local w=game:GetService("UserInputService")
local j=game:GetService("ReplicatedStorage")
local a=game:GetService("HttpService")
local CoreGui=game:GetService("CoreGui")
local o=e.LocalPlayer
local executorCheckCaller=typeof(checkcaller)=="function" and checkcaller or function() return false end
local safeNewCClosure=typeof(newcclosure)=="function" and newcclosure or function(fn) return fn end
local V=game:GetService("ProximityPromptService")
pcall(function()
    V.PromptButtonHoldBegan:Connect(function(p)
        pcall(function()
            if typeof(fireproximityprompt)=="function" then fireproximityprompt(p) end
        end)
    end)
end)
local Camera=r.CurrentCamera
local connections={}
local parentGui=(pcall(function() return gethui() end) and gethui()) or CoreGui
if parentGui:FindFirstChild("KerryHubScreenGui") then parentGui.KerryHubScreenGui:Destroy() end

local ScreenGui=Instance.new("ScreenGui")
ScreenGui.Name="KerryHubScreenGui"
ScreenGui.ResetOnSpawn=false
ScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
ScreenGui.Parent=parentGui

local NotificationContainer=Instance.new("Frame")
NotificationContainer.Size=UDim2.new(0,300,1,-40)
NotificationContainer.Position=UDim2.new(1,-320,0,20)
NotificationContainer.BackgroundTransparency=1
NotificationContainer.Parent=ScreenGui
local UIListLayout_Notif=Instance.new("UIListLayout")
UIListLayout_Notif.HorizontalAlignment=Enum.HorizontalAlignment.Right
UIListLayout_Notif.VerticalAlignment=Enum.VerticalAlignment.Bottom
UIListLayout_Notif.SortOrder=Enum.SortOrder.LayoutOrder
UIListLayout_Notif.Padding=UDim.new(0,10)
UIListLayout_Notif.Parent=NotificationContainer

local function Notify(title,message,duration)
    duration=duration or 3
    local NotifFrame=Instance.new("Frame")
    NotifFrame.Size=UDim2.new(0,300,0,65)
    NotifFrame.BackgroundColor3=Color3.fromRGB(18,18,22)
    NotifFrame.BackgroundTransparency=1
    NotifFrame.BorderSizePixel=0
    NotifFrame.Position=UDim2.new(1,40,0,0)
    Instance.new("UICorner",NotifFrame).CornerRadius=UDim.new(0,10)
    local UIStroke=Instance.new("UIStroke",NotifFrame)
    UIStroke.Color=Color3.fromRGB(45,45,55); UIStroke.Transparency=1; UIStroke.Thickness=1
    local AccentLine=Instance.new("Frame",NotifFrame)
    AccentLine.Size=UDim2.new(0,3,1,-16); AccentLine.Position=UDim2.new(0,8,0,8)
    AccentLine.BackgroundColor3=Color3.fromRGB(120,80,255); AccentLine.BorderSizePixel=0; AccentLine.BackgroundTransparency=1
    Instance.new("UICorner",AccentLine).CornerRadius=UDim.new(1,0)
    local TitleLabel=Instance.new("TextLabel",NotifFrame)
    TitleLabel.Size=UDim2.new(1,-30,0,20); TitleLabel.Position=UDim2.new(0,22,0,10)
    TitleLabel.BackgroundTransparency=1; TitleLabel.Font=Enum.Font.GothamBold; TitleLabel.Text=title
    TitleLabel.TextColor3=Color3.fromRGB(240,240,250); TitleLabel.TextSize=13
    TitleLabel.TextXAlignment=Enum.TextXAlignment.Left; TitleLabel.TextTransparency=1
    local DescLabel=Instance.new("TextLabel",NotifFrame)
    DescLabel.Size=UDim2.new(1,-30,0,20); DescLabel.Position=UDim2.new(0,22,0,30)
    DescLabel.BackgroundTransparency=1; DescLabel.Font=Enum.Font.Gotham; DescLabel.Text=message
    DescLabel.TextColor3=Color3.fromRGB(160,160,175); DescLabel.TextSize=12
    DescLabel.TextXAlignment=Enum.TextXAlignment.Left; DescLabel.TextTransparency=1
    NotifFrame.Parent=NotificationContainer
    u:Create(NotifFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=0.05,Position=UDim2.new(0,0,0,0)}):Play()
    u:Create(UIStroke,TweenInfo.new(0.3),{Transparency=0.4}):Play()
    u:Create(AccentLine,TweenInfo.new(0.3),{BackgroundTransparency=0}):Play()
    u:Create(TitleLabel,TweenInfo.new(0.3),{TextTransparency=0}):Play()
    u:Create(DescLabel,TweenInfo.new(0.3),{TextTransparency=0}):Play()
    task.delay(duration,function()
        if NotifFrame and NotifFrame.Parent then
            local tOut=u:Create(NotifFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{BackgroundTransparency=1,Position=UDim2.new(1,40,0,0)})
            u:Create(UIStroke,TweenInfo.new(0.3),{Transparency=1}):Play()
            u:Create(AccentLine,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
            u:Create(TitleLabel,TweenInfo.new(0.3),{TextTransparency=1}):Play()
            u:Create(DescLabel,TweenInfo.new(0.3),{TextTransparency=1}):Play()
            tOut:Play()
            tOut.Completed:Connect(function() NotifFrame:Destroy() end)
        end
    end)
end

local function HookPrompt(prompt)
    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration=0
        prompt.MaxActivationDistance=50
    end
end
for _,d in ipairs(r:GetDescendants()) do HookPrompt(d) end
table.insert(connections,r.DescendantAdded:Connect(HookPrompt))

local AutoFarm
local h

-- ==========================================
-- UI Window
-- ==========================================
local MainFrame=Instance.new("Frame")
MainFrame.Name="MainFrame"
MainFrame.Size=UDim2.new(0,620,0,420)
MainFrame.Position=UDim2.new(0.5,-310,0.5,-210)
MainFrame.BackgroundColor3=Color3.fromRGB(14,14,18)
MainFrame.BorderSizePixel=0
MainFrame.ClipsDescendants=true
MainFrame.Parent=ScreenGui
Instance.new("UICorner",MainFrame).CornerRadius=UDim.new(0,14)
local MainStroke=Instance.new("UIStroke",MainFrame)
MainStroke.Color=Color3.fromRGB(55,55,70); MainStroke.Transparency=0.2; MainStroke.Thickness=1.2

local TopBar=Instance.new("Frame",MainFrame)
TopBar.Size=UDim2.new(1,0,0,55)
TopBar.BackgroundColor3=Color3.fromRGB(20,20,26)
TopBar.BorderSizePixel=0

local TitleLabel=Instance.new("TextLabel",TopBar)
TitleLabel.Size=UDim2.new(0,200,0,22); TitleLabel.Position=UDim2.new(0,20,0,10)
TitleLabel.BackgroundTransparency=1; TitleLabel.Font=Enum.Font.GothamBold; TitleLabel.Text="KerryHub"
TitleLabel.TextColor3=Color3.fromRGB(255,255,255); TitleLabel.TextSize=18; TitleLabel.TextXAlignment=Enum.TextXAlignment.Left

local SubtitleLabel=Instance.new("TextLabel",TopBar)
SubtitleLabel.Size=UDim2.new(0,300,0,15); SubtitleLabel.Position=UDim2.new(0,20,0,30)
SubtitleLabel.BackgroundTransparency=1; SubtitleLabel.Font=Enum.Font.GothamMedium
SubtitleLabel.Text="Auto Steal - Safe: Forest"
SubtitleLabel.TextColor3=Color3.fromRGB(150,150,175); SubtitleLabel.TextSize=11; SubtitleLabel.TextXAlignment=Enum.TextXAlignment.Left

local CloseButton=Instance.new("TextButton",TopBar)
CloseButton.Size=UDim2.new(0,30,0,30); CloseButton.Position=UDim2.new(1,-40,0,12)
CloseButton.BackgroundColor3=Color3.fromRGB(32,32,42); CloseButton.AutoButtonColor=false
CloseButton.Font=Enum.Font.GothamBold; CloseButton.Text="×"
CloseButton.TextColor3=Color3.fromRGB(200,200,215); CloseButton.TextSize=18
Instance.new("UICorner",CloseButton).CornerRadius=UDim.new(0,6)
CloseButton.MouseEnter:Connect(function() u:Create(CloseButton,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(220,60,60),TextColor3=Color3.fromRGB(255,255,255)}):Play() end)
CloseButton.MouseLeave:Connect(function() u:Create(CloseButton,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(32,32,42),TextColor3=Color3.fromRGB(200,200,215)}):Play() end)

local MinimizeButton=Instance.new("TextButton",TopBar)
MinimizeButton.Size=UDim2.new(0,30,0,30); MinimizeButton.Position=UDim2.new(1,-76,0,12)
MinimizeButton.BackgroundColor3=Color3.fromRGB(32,32,42); MinimizeButton.AutoButtonColor=false
MinimizeButton.Font=Enum.Font.GothamBold; MinimizeButton.Text="—"
MinimizeButton.TextColor3=Color3.fromRGB(200,200,215); MinimizeButton.TextSize=18
Instance.new("UICorner",MinimizeButton).CornerRadius=UDim.new(0,6)
MinimizeButton.MouseEnter:Connect(function() u:Create(MinimizeButton,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(120,80,255),TextColor3=Color3.fromRGB(255,255,255)}):Play() end)
MinimizeButton.MouseLeave:Connect(function() u:Create(MinimizeButton,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(32,32,42),TextColor3=Color3.fromRGB(200,200,215)}):Play() end)

local RestoreIcon=Instance.new("TextButton",ScreenGui)
RestoreIcon.Name="RestoreIcon"
RestoreIcon.Size=UDim2.new(0,55,0,55)
RestoreIcon.Position=UDim2.new(0,25,0.5,-27)
RestoreIcon.BackgroundColor3=Color3.fromRGB(20,20,26)
RestoreIcon.AutoButtonColor=false
RestoreIcon.Text="K"
RestoreIcon.Font=Enum.Font.GothamBold
RestoreIcon.TextColor3=Color3.fromRGB(140,90,255)
RestoreIcon.TextSize=24
RestoreIcon.Visible=false
Instance.new("UICorner",RestoreIcon).CornerRadius=UDim.new(1,0)
local RestoreStroke=Instance.new("UIStroke",RestoreIcon)
RestoreStroke.Color=Color3.fromRGB(120,80,255)
RestoreStroke.Thickness=2
RestoreIcon.MouseEnter:Connect(function()
    u:Create(RestoreIcon,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(40,30,70)}):Play()
    u:Create(RestoreStroke,TweenInfo.new(0.2),{Thickness=3}):Play()
end)
RestoreIcon.MouseLeave:Connect(function()
    u:Create(RestoreIcon,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(20,20,26)}):Play()
    u:Create(RestoreStroke,TweenInfo.new(0.2),{Thickness=2}):Play()
end)

do
    local dIcon=false; local dStart; local dPos; local dInput
    RestoreIcon.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dIcon=true; dStart=input.Position; dPos=RestoreIcon.Position
            local conn
            conn=input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then
                    dIcon=false; conn:Disconnect()
                end
            end)
        end
    end)
    RestoreIcon.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            dInput=input
        end
    end)
    w.InputChanged:Connect(function(input)
        if input==dInput and dIcon then
            local d=input.Position-dStart
            RestoreIcon.Position=UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y)
        end
    end)
end

local isMinimized=false
local function MinimizeMenu()
    if isMinimized then return end
    isMinimized=true
    u:Create(MainFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{
        Position=UDim2.new(-1,0,0.5,-210)
    }):Play()
    task.delay(0.32,function()
        MainFrame.Visible=false
        RestoreIcon.Visible=true
        RestoreIcon.Size=UDim2.new(0,0,0,0)
        u:Create(RestoreIcon,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,55,0,55)}):Play()
    end)
end
local function RestoreMenu()
    if not isMinimized then return end
    isMinimized=false
    u:Create(RestoreIcon,TweenInfo.new(0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play()
    task.delay(0.2,function()
        RestoreIcon.Visible=false
        MainFrame.Position=UDim2.new(0.5,-310,0.5,-210)
        MainFrame.Visible=true
    end)
end
MinimizeButton.MouseButton1Click:Connect(MinimizeMenu)
RestoreIcon.MouseButton1Click:Connect(RestoreMenu)
CloseButton.MouseButton1Click:Connect(function()
    pcall(function() if AutoFarm then AutoFarm.SetFarmMode("NONE") end end)
    pcall(function() if AutoFarm then AutoFarm.ResetFarmStates() end end)
    pcall(function() if h then h.alive=false end end)
    if ScreenGui then ScreenGui:Destroy() end
end)

local HeaderDivider=Instance.new("Frame",MainFrame)
HeaderDivider.Size=UDim2.new(1,0,0,1); HeaderDivider.Position=UDim2.new(0,0,0,55)
HeaderDivider.BackgroundColor3=Color3.fromRGB(40,40,52); HeaderDivider.BorderSizePixel=0

local Sidebar=Instance.new("Frame",MainFrame)
Sidebar.Size=UDim2.new(0,175,1,-56); Sidebar.Position=UDim2.new(0,0,0,56)
Sidebar.BackgroundColor3=Color3.fromRGB(18,18,24); Sidebar.BorderSizePixel=0
local SidebarLayout=Instance.new("UIListLayout",Sidebar)
SidebarLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
SidebarLayout.SortOrder=Enum.SortOrder.LayoutOrder
SidebarLayout.Padding=UDim.new(0,6)
local SidebarPadding=Instance.new("UIPadding",Sidebar)
SidebarPadding.PaddingTop=UDim.new(0,15); SidebarPadding.PaddingLeft=UDim.new(0,12); SidebarPadding.PaddingRight=UDim.new(0,12)

local SidebarDivider=Instance.new("Frame",MainFrame)
SidebarDivider.Size=UDim2.new(0,1,1,-56); SidebarDivider.Position=UDim2.new(0,175,0,56)
SidebarDivider.BackgroundColor3=Color3.fromRGB(40,40,52); SidebarDivider.BorderSizePixel=0

local ContentContainer=Instance.new("Frame",MainFrame)
ContentContainer.Size=UDim2.new(1,-176,1,-56); ContentContainer.Position=UDim2.new(0,176,0,56)
ContentContainer.BackgroundTransparency=1

local dragging,dragInput,dragStart,startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true; dragStart=input.Position; startPos=MainFrame.Position
        local conn
        conn=input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then dragging=false; conn:Disconnect() end
        end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
end)
w.InputChanged:Connect(function(input)
    if input==dragInput and dragging then
        local d=input.Position-dragStart
        MainFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)

local categories={}
local currentCategory=nil
local function CreateCategory(name,iconId)
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(1,0,0,38)
    btn.BackgroundColor3=Color3.fromRGB(24,24,34)
    btn.BackgroundTransparency=1
    btn.AutoButtonColor=false
    btn.Text=""
    btn.Parent=Sidebar
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,10)
    local Icon=Instance.new("ImageLabel",btn)
    Icon.Size=UDim2.new(0,18,0,18); Icon.Position=UDim2.new(0,12,0.5,-9)
    Icon.BackgroundTransparency=1
    Icon.Image=iconId or "rbxassetid://10723346959"
    Icon.ImageColor3=Color3.fromRGB(150,150,165)
    local Label=Instance.new("TextLabel",btn)
    Label.Size=UDim2.new(1,-40,1,0); Label.Position=UDim2.new(0,38,0,0)
    Label.BackgroundTransparency=1; Label.Font=Enum.Font.GothamMedium
    Label.Text=name; Label.TextColor3=Color3.fromRGB(150,150,165)
    Label.TextSize=13; Label.TextXAlignment=Enum.TextXAlignment.Left
    local PageFrame=Instance.new("ScrollingFrame",ContentContainer)
    PageFrame.Size=UDim2.new(1,0,1,0); PageFrame.BackgroundTransparency=1
    PageFrame.BorderSizePixel=0; PageFrame.CanvasSize=UDim2.new(0,0,0,0)
    PageFrame.AutomaticCanvasSize=Enum.AutomaticSize.Y
    PageFrame.ScrollBarThickness=3; PageFrame.ScrollBarImageColor3=Color3.fromRGB(60,60,75)
    PageFrame.Visible=false
    local PageLayout=Instance.new("UIListLayout",PageFrame)
    PageLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    PageLayout.SortOrder=Enum.SortOrder.LayoutOrder; PageLayout.Padding=UDim.new(0,10)
    local PagePadding=Instance.new("UIPadding",PageFrame)
    PagePadding.PaddingTop=UDim.new(0,16); PagePadding.PaddingBottom=UDim.new(0,16)
    PagePadding.PaddingLeft=UDim.new(0,20); PagePadding.PaddingRight=UDim.new(0,20)
    categories[name]={Button=btn,Page=PageFrame,Icon=Icon,Label=Label}
    btn.MouseEnter:Connect(function() if currentCategory~=name then u:Create(btn,TweenInfo.new(0.2),{BackgroundTransparency=0.5}):Play() end end)
    btn.MouseLeave:Connect(function() if currentCategory~=name then u:Create(btn,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play() end end)
    btn.MouseButton1Click:Connect(function()
        for catName,catData in pairs(categories) do
            if catName==name then
                catData.Page.Visible=true
                u:Create(catData.Button,TweenInfo.new(0.2),{BackgroundTransparency=0}):Play()
                catData.Icon.ImageColor3=Color3.fromRGB(140,90,255)
                catData.Label.TextColor3=Color3.fromRGB(255,255,255)
                currentCategory=name
            else
                catData.Page.Visible=false
                u:Create(catData.Button,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play()
                catData.Icon.ImageColor3=Color3.fromRGB(150,150,165)
                catData.Label.TextColor3=Color3.fromRGB(150,150,165)
            end
        end
    end)
    if not currentCategory then
        currentCategory=name; PageFrame.Visible=true
        btn.BackgroundTransparency=0
        Icon.ImageColor3=Color3.fromRGB(140,90,255)
        Label.TextColor3=Color3.fromRGB(255,255,255)
    end
    return PageFrame
end

local autoFarmPage=CreateCategory("Auto Farm","rbxassetid://10709769841")
local eggFilterPage=CreateCategory("Egg Selection","rbxassetid://10723407874")
local movementPage=CreateCategory("Movement","rbxassetid://10747373176")

local function AddToggle(parentPage,title,description,defaultState,callback)
    local toggled=defaultState or false
    local box=Instance.new("Frame",parentPage)
    box.Size=UDim2.new(1,0,0,50)
    box.BackgroundColor3=Color3.fromRGB(24,24,32)
    box.BorderSizePixel=0
    Instance.new("UICorner",box).CornerRadius=UDim.new(0,12)
    local Stroke=Instance.new("UIStroke",box)
    Stroke.Color=Color3.fromRGB(42,42,55); Stroke.Transparency=0.3
    local TL=Instance.new("TextLabel",box)
    TL.Size=UDim2.new(1,-70,0,18); TL.Position=UDim2.new(0,15,0,8)
    TL.BackgroundTransparency=1; TL.Font=Enum.Font.GothamBold; TL.Text=title
    TL.TextColor3=Color3.fromRGB(240,240,250); TL.TextSize=13; TL.TextXAlignment=Enum.TextXAlignment.Left
    local DL=Instance.new("TextLabel",box)
    DL.Size=UDim2.new(1,-70,0,15); DL.Position=UDim2.new(0,15,0,26)
    DL.BackgroundTransparency=1; DL.Font=Enum.Font.Gotham; DL.Text=description or ""
    DL.TextColor3=Color3.fromRGB(160,160,180); DL.TextSize=11; DL.TextXAlignment=Enum.TextXAlignment.Left
    local SBg=Instance.new("Frame",box)
    SBg.Size=UDim2.new(0,42,0,22); SBg.Position=UDim2.new(1,-54,0.5,-11)
    SBg.BackgroundColor3=toggled and Color3.fromRGB(130,85,255) or Color3.fromRGB(40,40,52)
    SBg.BorderSizePixel=0
    Instance.new("UICorner",SBg).CornerRadius=UDim.new(1,0)
    local SKnob=Instance.new("Frame",SBg)
    SKnob.Size=UDim2.new(0,16,0,16)
    SKnob.Position=toggled and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
    SKnob.BackgroundColor3=Color3.fromRGB(255,255,255); SKnob.BorderSizePixel=0
    Instance.new("UICorner",SKnob).CornerRadius=UDim.new(1,0)
    local ClickBtn=Instance.new("TextButton",box)
    ClickBtn.Size=UDim2.new(1,0,1,0); ClickBtn.BackgroundTransparency=1; ClickBtn.Text=""
    local function setState(state,noCb)
        toggled=state
        local col=toggled and Color3.fromRGB(130,85,255) or Color3.fromRGB(40,40,52)
        local pos=toggled and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
        u:Create(SBg,TweenInfo.new(0.2),{BackgroundColor3=col}):Play()
        u:Create(SKnob,TweenInfo.new(0.2),{Position=pos}):Play()
        if not noCb and callback then pcall(function() callback(toggled) end) end
    end
    ClickBtn.MouseButton1Click:Connect(function() setState(not toggled) end)
    return {Set=function(s) setState(s) end, Get=function() return toggled end}
end

local function AddSlider(parentPage,title,min,max,default,callback)
    local value=default or min
    local box=Instance.new("Frame",parentPage)
    box.Size=UDim2.new(1,0,0,60)
    box.BackgroundColor3=Color3.fromRGB(24,24,32)
    box.BorderSizePixel=0
    Instance.new("UICorner",box).CornerRadius=UDim.new(0,12)
    local Stroke=Instance.new("UIStroke",box)
    Stroke.Color=Color3.fromRGB(42,42,55); Stroke.Transparency=0.3
    local TL=Instance.new("TextLabel",box)
    TL.Size=UDim2.new(1,-70,0,18); TL.Position=UDim2.new(0,15,0,10)
    TL.BackgroundTransparency=1; TL.Font=Enum.Font.GothamBold; TL.Text=title
    TL.TextColor3=Color3.fromRGB(240,240,250); TL.TextSize=13; TL.TextXAlignment=Enum.TextXAlignment.Left
    local VL=Instance.new("TextLabel",box)
    VL.Size=UDim2.new(0,50,0,18); VL.Position=UDim2.new(1,-65,0,10)
    VL.BackgroundTransparency=1; VL.Font=Enum.Font.GothamMedium; VL.Text=tostring(value)
    VL.TextColor3=Color3.fromRGB(150,100,255); VL.TextSize=13; VL.TextXAlignment=Enum.TextXAlignment.Right
    local Track=Instance.new("Frame",box)
    Track.Size=UDim2.new(1,-30,0,6); Track.Position=UDim2.new(0,15,0,40)
    Track.BackgroundColor3=Color3.fromRGB(40,40,52); Track.BorderSizePixel=0
    Instance.new("UICorner",Track).CornerRadius=UDim.new(1,0)
    local Fill=Instance.new("Frame",Track)
    Fill.Size=UDim2.new(math.clamp((value-min)/(max-min),0,1),0,1,0)
    Fill.BackgroundColor3=Color3.fromRGB(130,85,255); Fill.BorderSizePixel=0
    Instance.new("UICorner",Fill).CornerRadius=UDim.new(1,0)
    local Knob=Instance.new("Frame",Track)
    Knob.Size=UDim2.new(0,12,0,12); Knob.AnchorPoint=Vector2.new(0.5,0.5)
    Knob.Position=UDim2.new(Fill.Size.X.Scale,0,0.5,0)
    Knob.BackgroundColor3=Color3.fromRGB(255,255,255); Knob.BorderSizePixel=0
    Instance.new("UICorner",Knob).CornerRadius=UDim.new(1,0)
    local sliding=false
    local function update(input)
        local posX=input.Position.X-Track.AbsolutePosition.X
        local pct=math.clamp(posX/Track.AbsoluteSize.X,0,1)
        value=math.floor(min+(max-min)*pct)
        Fill.Size=UDim2.new(pct,0,1,0)
        Knob.Position=UDim2.new(pct,0,0.5,0)
        VL.Text=tostring(value)
        if callback then pcall(function() callback(value) end) end
    end
    Track.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            sliding=true; update(input)
        end
    end)
    w.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then update(input) end
    end)
    w.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then sliding=false end
    end)
    return {Set=function(v) value=math.clamp(v,min,max); local pct=(value-min)/(max-min)
        Fill.Size=UDim2.new(pct,0,1,0); Knob.Position=UDim2.new(pct,0,0.5,0); VL.Text=tostring(value)
        if callback then pcall(function() callback(value) end) end end,
        Get=function() return value end}
end

local function AddButton(parentPage,title,description,callback)
    local box=Instance.new("Frame",parentPage)
    box.Size=UDim2.new(1,0,0,50)
    box.BackgroundColor3=Color3.fromRGB(24,24,32)
    box.BorderSizePixel=0
    Instance.new("UICorner",box).CornerRadius=UDim.new(0,12)
    local Stroke=Instance.new("UIStroke",box)
    Stroke.Color=Color3.fromRGB(42,42,55); Stroke.Transparency=0.3
    local TL=Instance.new("TextLabel",box)
    TL.Size=UDim2.new(1,-30,0,18); TL.Position=UDim2.new(0,15,0,8)
    TL.BackgroundTransparency=1; TL.Font=Enum.Font.GothamBold; TL.Text=title
    TL.TextColor3=Color3.fromRGB(240,240,250); TL.TextSize=13; TL.TextXAlignment=Enum.TextXAlignment.Left
    local DL=Instance.new("TextLabel",box)
    DL.Size=UDim2.new(1,-30,0,15); DL.Position=UDim2.new(0,15,0,26)
    DL.BackgroundTransparency=1; DL.Font=Enum.Font.Gotham; DL.Text=description or ""
    DL.TextColor3=Color3.fromRGB(160,160,180); DL.TextSize=11; DL.TextXAlignment=Enum.TextXAlignment.Left
    local ClickBtn=Instance.new("TextButton",box)
    ClickBtn.Size=UDim2.new(1,0,1,0); ClickBtn.BackgroundTransparency=1; ClickBtn.Text=""
    ClickBtn.MouseEnter:Connect(function() u:Create(box,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(34,34,46)}):Play() end)
    ClickBtn.MouseLeave:Connect(function() u:Create(box,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(24,24,32)}):Play() end)
    ClickBtn.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
end

local function AddMultiDropdown(parentPage,title,options,selectedMap,callback)
    selectedMap=selectedMap or {}
    local isExpanded=false
    local box=Instance.new("Frame",parentPage)
    box.Size=UDim2.new(1,0,0,48)
    box.BackgroundColor3=Color3.fromRGB(24,24,32)
    box.BorderSizePixel=0
    box.ClipsDescendants=true
    Instance.new("UICorner",box).CornerRadius=UDim.new(0,12)
    local Stroke=Instance.new("UIStroke",box)
    Stroke.Color=Color3.fromRGB(42,42,55); Stroke.Transparency=0.3
    local TL=Instance.new("TextLabel",box)
    TL.Size=UDim2.new(0,150,0,48); TL.Position=UDim2.new(0,15,0,0)
    TL.BackgroundTransparency=1; TL.Font=Enum.Font.GothamBold; TL.Text=title
    TL.TextColor3=Color3.fromRGB(240,240,250); TL.TextSize=13; TL.TextXAlignment=Enum.TextXAlignment.Left
    local function count()
        local c=0
        for _,opt in ipairs(options) do if selectedMap[opt]==true then c=c+1 end end
        return c
    end
    local SelBtn=Instance.new("TextButton",box)
    SelBtn.Size=UDim2.new(0,160,0,28); SelBtn.Position=UDim2.new(1,-175,0,10)
    SelBtn.BackgroundColor3=Color3.fromRGB(28,28,38)
    SelBtn.Font=Enum.Font.GothamMedium
    SelBtn.Text=tostring(count()).." / "..tostring(#options).."  ▼"
    SelBtn.TextColor3=Color3.fromRGB(180,180,200); SelBtn.TextSize=12
    Instance.new("UICorner",SelBtn).CornerRadius=UDim.new(0,6)
    local ListHolder=Instance.new("ScrollingFrame",box)
    ListHolder.Size=UDim2.new(1,-30,0,0); ListHolder.Position=UDim2.new(0,15,0,48)
    ListHolder.BackgroundTransparency=1; ListHolder.BorderSizePixel=0
    ListHolder.ScrollBarThickness=2; ListHolder.ScrollBarImageColor3=Color3.fromRGB(60,60,75)
    ListHolder.AutomaticCanvasSize=Enum.AutomaticSize.Y; ListHolder.CanvasSize=UDim2.new(0,0,0,0)
    local LL=Instance.new("UIListLayout",ListHolder)
    LL.SortOrder=Enum.SortOrder.LayoutOrder; LL.Padding=UDim.new(0,4)
    local function updVisual(opt,btn)
        if selectedMap[opt]==true then
            btn.BackgroundColor3=Color3.fromRGB(120,80,255); btn.TextColor3=Color3.fromRGB(255,255,255)
        else
            btn.BackgroundColor3=Color3.fromRGB(24,24,32); btn.TextColor3=Color3.fromRGB(160,160,175)
        end
    end
    for _,opt in ipairs(options) do
        local ob=Instance.new("TextButton",ListHolder)
        ob.Size=UDim2.new(1,0,0,28); ob.BorderSizePixel=0
        ob.Font=Enum.Font.Gotham; ob.Text=tostring(opt); ob.TextSize=12
        Instance.new("UICorner",ob).CornerRadius=UDim.new(0,4)
        updVisual(opt,ob)
        ob.MouseButton1Click:Connect(function()
            selectedMap[opt]=not (selectedMap[opt]==true)
            updVisual(opt,ob)
            SelBtn.Text=tostring(count()).." / "..tostring(#options).."  ▼"
            if callback then pcall(function() callback(selectedMap) end) end
        end)
    end
    SelBtn.MouseButton1Click:Connect(function()
        isExpanded=not isExpanded
        if isExpanded then
            local hh=math.clamp(#options*32,32,160)
            ListHolder.Size=UDim2.new(1,-30,0,hh)
            u:Create(box,TweenInfo.new(0.25),{Size=UDim2.new(1,0,0,52+hh)}):Play()
        else
            u:Create(box,TweenInfo.new(0.2),{Size=UDim2.new(1,0,0,48)}):Play()
            ListHolder.Size=UDim2.new(1,-30,0,0)
        end
    end)
    return {Get=function() return selectedMap end}
end

-- ==========================================
-- AutoFarm Module
-- ==========================================
AutoFarm=(function()
local e=game:GetService("Players")
local r=game:GetService("Workspace")
local y=game:GetService("RunService")
local w=game:GetService("UserInputService")
local j=game:GetService("ReplicatedStorage")
local a=game:GetService("HttpService")
local o=e.LocalPlayer
local safeNewCClosure=typeof(newcclosure)=="function" and newcclosure or function(fn) return fn end
local V=game:GetService("ProximityPromptService")
pcall(function()
    V.PromptButtonHoldBegan:Connect(function(p)
        pcall(function()
            if typeof(fireproximityprompt)=="function" then fireproximityprompt(p) end
        end)
    end)
end)
local s=nil
pcall(function() s=require((j:WaitForChild("Client",5)):WaitForChild("EggState",5)) end)
if not s then pcall(function() s=require(j.Client.EggState) end) end
local p=nil
pcall(function() p=require(((j:WaitForChild("Shared",5)):WaitForChild("Util",5)):WaitForChild("AssetItems",5)) end)
if not p then pcall(function() p=require(j.Shared.Util.AssetItems) end) end
local B=nil
pcall(function() B=require((j:WaitForChild("Shared",5)):WaitForChild("Remotes",5)) end)
if not B then pcall(function() B=require(j.Shared.Remotes) end) end

local function J(name,alt)
    local y=(j:FindFirstChild("Packages") and j.Packages:FindFirstChild("Networking")) or j:FindFirstChild("Network") or j
    local u=y:FindFirstChild(name) or j:FindFirstChild(name)
    if u then return u end
    local w=y:FindFirstChild(name,true) or j:FindFirstChild(name,true)
    if w then return w end
    if alt then
        local a=y:FindFirstChild(alt) or j:FindFirstChild(alt)
        if a then return a end
        local b=y:FindFirstChild(alt,true) or j:FindFirstChild(alt,true)
        if b then return b end
    end
    local k=string.match(name,"[^/]+$")
    if k then
        local c=y:FindFirstChild(k,true) or j:FindFirstChild(k,true)
        if c then return c end
    end
    return nil
end

local i=J("RF/EggWorld/AskFieldEggCarry","AskFieldEggCarry")
local R=J("RF/EggWorld/AskFieldEggSnapshot","AskFieldEggSnapshot") or J("Eggs: RequestAreaEggSnapshot","RequestAreaEggSnapshot")
local P=J("RE/GuardPatrol/ForestStrike","ForestStrike") or (B and B.GuardPatrol and B.GuardPatrol.ForestStrike)
local N=J("SpeedTollOffer","RE/GuardPatrol/SpeedTollOffer") or (B and B.GuardPatrol and B.GuardPatrol.SpeedTollOffer)

warn(string.format("[KerryHub] Remotes -> carry=%s snapshot=%s strike=%s toll=%s",
    tostring(i~=nil),tostring(R~=nil),tostring(P~=nil),tostring(N~=nil)))

local f={
    ["Enchanted Forest"]=1700,
    ["Angels & Demons"]=1500,["Angels and Demons"]=1500,["AngelsDemons"]=1500,["Angels"]=1500,["Demons"]=1500,
    ["Light Dark"]=1300,["LightDark"]=1300,
    ["Titan Temple"]=1100,["Cherry Blossom"]=1000,["Cosmic"]=900,
    ["Prehistoric"]=800,["Abyss Ocean"]=700,["Volcano"]=600,
    ["Snow"]=500,["Jungle"]=400,["Desert"]=300,["Lake"]=200,["Forest"]=100
}
local M={"Enchanted Forest","Angels & Demons","Titan Temple","Cherry Blossom","Cosmic","Prehistoric","Abyss Ocean","Volcano","Snow","Jungle","Desert","Lake","Forest"}
local I={
    ["Enchanted Forest"]=480,
    ["Angels & Demons"]=450,["Angels and Demons"]=450,["AngelsDemons"]=450,["Angels"]=450,["Demons"]=450,
    ["Light Dark"]=420,["LightDark"]=420,["Titan Temple"]=380,["Cherry Blossom"]=330,["Cosmic"]=280,
    ["Prehistoric"]=240,["Abyss Ocean"]=200,["Volcano"]=180,["Snow"]=160,["Jungle"]=140,
    ["Desert"]=130,["Lake"]=125,["Forest"]=125
}

local SAFE_ZONE_X = 576.7
local SAFE_ZONE_LANE_Z = -368.1
local SAFE_ZONE_Y = 70.6
local HIGH_Y = SAFE_ZONE_Y + 10   -- высота при хопах (можно менять)

local HOP_POINTS = {
    {X=6681.2,  Z=-355.4},
    {X=5649.6,  Z=-334.6},
    {X=5200,    Z=-360},
    {X=4750,    Z=-360},
    {X=4000,    Z=-360},
    {X=3350,    Z=-360},
    {X=2780,    Z=-360},
    {X=2250,    Z=-360},
    {X=1850,    Z=-360},
    {X=1450,    Z=-360},
    {X=1150,    Z=-360},
    {X=920,     Z=-360},
    {X=720,     Z=-360},
    {X=SAFE_ZONE_X, Z=SAFE_ZONE_LANE_Z}
}

local L = SAFE_ZONE_LANE_Z
local E = 525
local b = 620
local A = 130

local Z="DiceHub_FlightSpeed.txt"
local z="DiceHub_EggSelectConfig.json"
local X={"Divine","Eternal","Secret","Cosmic","Mythic","Legendary","Epic","Rare","Uncommon","Common"}
local F={["Divine"]=6,["Eternal"]=5,["Secret"]=4,["Cosmic"]=3,["Mythic"]=2,
["Legendary"]=1,["Epic"]=0.5,["Rare"]=0.3,["Uncommon"]=0.1,["Common"]=0}

local hh
local function O() local e=600
    pcall(function()
        local r=false
        if isfile then r=isfile(Z) elseif readfile then local a,b=pcall(readfile,Z); r=a and(b~=nil) end
        if r and readfile then local u=tonumber(readfile(Z)); if u and u>=100 and u<=1000 then e=math.floor(u) end end
    end)
    return e
end
local function Y(v) pcall(function() if writefile then writefile(Z,tostring(math.clamp(math.floor(tonumber(v) or 600),100,1000))) end end) end
local function T()
    local e=nil
    pcall(function()
        local r=false
        if isfile then r=isfile(z) elseif readfile then local a,b=pcall(readfile,z); r=a and(b~=nil) end
        if r and readfile and a then
            local raw=readfile(z)
            if raw and raw~="" then local d=a:JSONDecode(raw); if type(d)=="table" then e=d end end
        end
    end)
    local dZ={["Enchanted Forest"]=true,["Angels & Demons"]=true,["Light Dark"]=true,["Titan Temple"]=true,["Cherry Blossom"]=true,["Cosmic"]=true,
    ["Prehistoric"]=false,["Abyss Ocean"]=false,["Volcano"]=false,["Snow"]=false,
    ["Jungle"]=false,["Desert"]=false,["Lake"]=false,["Forest"]=false}
    local dR={["Divine"]=true,["Eternal"]=true,["Secret"]=true,["Cosmic"]=true,["Mythic"]=true,
    ["Legendary"]=false,["Epic"]=false,["Rare"]=false,["Uncommon"]=false,["Common"]=false}
    if type(e)~="table" then
        e={selectedZones=dZ,selectedRarities=dR,alwaysCollectSecretPlus=true}
    else
        if type(e.selectedZones)~="table" then e.selectedZones=dZ
        else
            if e.selectedZones["Angels & Demons"]==nil then e.selectedZones["Angels & Demons"]=true end
            if e.selectedZones["Enchanted Forest"]==nil then e.selectedZones["Enchanted Forest"]=true end
        end
        if type(e.selectedRarities)~="table" then e.selectedRarities=dR
        else for _,w2 in ipairs(X) do if e.selectedRarities[w2]==nil then e.selectedRarities[w2]=(dR[w2]==true) end end end
        if e.alwaysCollectSecretPlus==nil then e.alwaysCollectSecretPlus=true end
    end
    return e
end
local function x()
    pcall(function()
        if writefile and a and hh then
            local d={selectedZones=hh.selectedZones or {},selectedRarities=hh.selectedRarities or {},
            alwaysCollectSecretPlus=(hh.alwaysCollectSecretPlus~=false)}
            writefile(z,a:JSONEncode(d))
        end
    end)
end

local W=T()
hh={godmode=true,autoGlide=true,
pureTweenFarm=false,autoFarmLoop=false,
glidingToTarget=false,securingEgg=false,glideSpeed=O(),
selectedZones=W.selectedZones,selectedRarities=W.selectedRarities,
alwaysCollectSecretPlus=W.alwaysCollectSecretPlus,
laneZ=SAFE_ZONE_LANE_Z,swapped=false,
teleporting=false,isReturning=false,delivering=false,holdingEggForGuard=false,
currentTargetModel=nil,targetPosition=nil,
stateTime=os.clock(),statusText="Ready",alive=true}

local m,e4,r4,y4,u4,w4,j4,k4,a4,o4,V4,H4,t4,s4,p4,B4,N4,U4,l4,D4,T4,i4,ek,h4,Dk,wk
local X4={}
local O4=0
local Y4="NONE"
local F4=nil
local G4=0
local m4=false

m=function(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local n=string.lower(tool.Name)
    if string.find(n,"sword") or string.find(n,"radar") or string.find(n,"basket") or string.find(n,"punch") then return false end
    if tool:GetAttribute("EggUid") or tool:GetAttribute("UID") or string.find(n,"egg") or tool:GetAttribute("Category") or tool:GetAttribute("ItemType")=="Egg" then return true end
    return false
end
e4=function()
    local ch=o.Character
    if ch then
        for _,it in ipairs(ch:GetChildren()) do
            if m(it) then return it,it:GetAttribute("UID") or it:GetAttribute("EggUid") or it.Name end
        end
    end
    return nil,nil
end
r4=function()
    local bp=o:FindFirstChild("Backpack")
    if bp then
        for _,it in ipairs(bp:GetChildren()) do
            if m(it) then return it,it:GetAttribute("UID") or it:GetAttribute("EggUid") or it.Name end
        end
    end
    return nil,nil
end
y4=function()
    local c=0
    local bp=o:FindFirstChild("Backpack")
    if bp then for _,it in ipairs(bp:GetChildren()) do if m(it) then c=c+1 end end end
    local ch=o.Character
    if ch then for _,it in ipairs(ch:GetChildren()) do if m(it) then c=c+1 end end end
    return c
end
u4=function()
    local ch=o.Character
    local hb=ch and ch:FindFirstChildOfClass("Humanoid")
    local bp=o:FindFirstChild("Backpack")
    if hb then pcall(function() hb:UnequipTools() end) end
    if ch and bp then
        for _,it in ipairs(ch:GetChildren()) do
            if it:IsA("Tool") then pcall(function() it.Parent=bp end) end
        end
    end
end
w4=function(uid)
    if (hh.pureTweenFarm or hh.autoFarmLoop) and not hh.holdingEggForGuard then
        if e4() then pcall(u4); return false end
    end
    local tool,tu=e4()
    if tool then
        if uid then if tu==uid or not tu then return true end else return true end
    end
    local ch=o.Character
    local root=ch and ch:FindFirstChild("HumanoidRootPart")
    if root and root.Position.X<=E+15 then return false end
    if s and s.ReadFieldEggs then
        local ok,data=pcall(s.ReadFieldEggs)
        if ok and data and data.Records then
            for _,rec in ipairs(data.Records) do
                if (rec.State=="Carried" or rec.State==2) and (rec.CarrierUserId==o.UserId or rec.Carrier==o.UserId) then
                    if uid then if rec.Uid==uid then return true end else return true end
                end
            end
        end
    end
    return false
end
j4=function(uid)
    local tool,tu=e4()
    if tool then if not uid or tu==uid or not tu then return true end end
    local bp=o:FindFirstChild("Backpack")
    if bp then
        for _,it in ipairs(bp:GetChildren()) do
            if m(it) then
                local uu=it:GetAttribute("UID") or it:GetAttribute("EggUid")
                if not uid or uu==uid or it.Name==tostring(uid) then return true end
            end
        end
    end
    if uid and s and s.ReadFieldEggs then
        local ok,data=pcall(s.ReadFieldEggs)
        if ok and data and data.Records then
            for _,rec in ipairs(data.Records) do
                if rec.Uid==uid and (rec.State=="Carried" or rec.State==2) then
                    local cr=rec.CarrierUserId or rec.Carrier
                    if cr==o.UserId then return true end
                end
            end
        end
    end
    return false
end
k4=function(uid)
    if not uid then return false,"NoUid" end
    local list=h4(false)
    if list and #list>0 then
        for _,rec in ipairs(list) do
            if rec.Uid==uid then
                if rec.State=="Carried" or rec.State==2 then
                    local cr=rec.CarrierUserId or rec.Carrier
                    if cr and cr==o.UserId then return true,"CarriedBySelf" else return false,"CarriedByOther" end
                end
                if rec.State=="Slot" or rec.State=="Dropped" or rec.State=="GuardCarried" or rec.State==1 then return true,"Available" end
                local cr=rec.CarrierUserId or rec.Carrier
                if cr then if cr==o.UserId then return true,"CarriedBySelf" else return false,"CarriedByOther" end end
                return true,"Available"
            end
        end
    end
    local slots=r:FindFirstChild("AreaEggSlotsClient")
    if slots then
        for _,ch in ipairs(slots:GetChildren()) do
            if ch.Name==tostring(uid) or ch:GetAttribute("UID")==uid or ch:GetAttribute("Uid")==uid then return true,"Available" end
        end
    end
    return true,"Unchecked"
end
a4=function()
    local _,uid=e4()
    if not uid then local _,u2=r4(); uid=u2 end
    if not uid then return false end
    if s and s.ReadFieldEggs then
        local ok,data=pcall(s.ReadFieldEggs)
        if ok and data and data.Records then
            for _,rec in ipairs(data.Records) do
                if rec.Uid==uid then
                    local aid=tostring(rec.AreaId or "")
                    if aid=="Lake" or string.find(string.lower(aid),"lake") then return true end
                end
            end
        end
    end
    if string.find(string.lower(tostring(uid)),"lake") then return true end
    return false
end
o4=function()
    local _,uid=e4()
    if not uid then local _,u2=r4(); uid=u2 end
    if not uid then return hh.glideSpeed or 350 end
    if s and s.ReadFieldEggs then
        local ok,data=pcall(s.ReadFieldEggs)
        if ok and data and data.Records then
            for _,rec in ipairs(data.Records) do
                if rec.Uid==uid and rec.AreaId then return I[rec.AreaId] or hh.glideSpeed or 350 end
            end
        end
    end
    return hh.glideSpeed or 350
end
V4=function(pos,dur)
    dur=dur or 8
    local pad=Instance.new("Part")
    pad.Name="SafetyFloorPad"
    pad.Size=Vector3.new(28,1.5,28)
    pad.Position=pos-Vector3.new(0,3.2,0)
    pad.Anchored=true; pad.Transparency=1; pad.CanCollide=true
    pad.Parent=r
    task.delay(dur,function() pcall(function() pad:Destroy() end) end)
    return pad
end
H4=function(uid)
    if P and uid then
        pcall(function()
            local ch=o.Character
            local root=ch and ch:FindFirstChild("HumanoidRootPart")
            local cf=root and (root.CFrame*CFrame.new(0,0,-3)) or CFrame.new()
            if P:IsA("RemoteFunction") then P:InvokeServer({EggUid=uid,GuardCFrame=cf})
            else P:FireServer({EggUid=uid,GuardCFrame=cf}) end
        end)
    end
end

_G._KerryHubSelfAnchor=false
if typeof(hookmetamethod)=="function" and not _G._DesyncAntiRagdollHooked then
    _G._DesyncAntiRagdollHooked=true
    local old
    old=hookmetamethod(game,"__newindex",safeNewCClosure(function(t,k,v)
        if not executorCheckCaller() and typeof(t)=="Instance" then
            if t:IsA("Motor6D") and k=="Enabled" and v==false then return nil end
            if t:IsA("Humanoid") then
                if k=="PlatformStand" and v==true then return nil end
                if k=="Sit" and v==true and (hh.pureTweenFarm or hh.autoFarmLoop or hh.isReturning or hh.glidingToTarget) then return nil end
            end
            if t:IsA("BasePart") and k=="Anchored" and v==true and not _G._KerryHubSelfAnchor then
                local ch=o.Character
                if ch and t:IsDescendantOf(ch) and (hh.pureTweenFarm or hh.autoFarmLoop) then
                    return nil
                end
            end
        end
        return old(t,k,v)
    end))
end

local function fixJoints(ch)
    if not ch then return end
    local root=ch:FindFirstChild("HumanoidRootPart")
    local torso=ch:FindFirstChild("Torso") or ch:FindFirstChild("UpperTorso") or root
    if not torso then return end
    for _,d in ipairs(ch:GetDescendants()) do
        if d:IsA("BallSocketConstraint") or d:IsA("HingeConstraint") or d:IsA("NoCollisionConstraint") then
            pcall(function() d:Destroy() end)
        end
    end
    for _,d in ipairs(ch:GetDescendants()) do
        if d:IsA("Motor6D") and d.Part0 and d.Part1 then
            d.Enabled=true
            local wn="RigidJointWeld_"..d.Name
            if not d.Part1:FindFirstChild(wn) then
                local wc=Instance.new("WeldConstraint")
                wc.Name=wn; wc.Part0=d.Part0; wc.Part1=d.Part1
                wc.Parent=d.Part1
            end
        end
    end
end
local function antiRagdoll(ch)
    ch=ch or o.Character
    if not ch then return end
    local hb=ch:FindFirstChildOfClass("Humanoid")
    if hb then
        hb:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
        hb:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
        hb:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
        hb:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
        hb:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
        if hb.PlatformStand then hb.PlatformStand=false end
        if hb.Sit then hb.Sit=false end
    end
    for _,d in ipairs(ch:GetDescendants()) do
        if d:IsA("LocalScript") and (string.find(string.lower(d.Name),"ragdoll") or string.find(string.lower(d.Name),"fall")) then
            d.Disabled=true
        end
    end
    fixJoints(ch)
end
local function bindAntiRagdoll(ch)
    if not ch then return end
    antiRagdoll(ch)
    for _,d in ipairs(ch:GetDescendants()) do
        if d:IsA("Motor6D") then
            d:GetPropertyChangedSignal("Enabled"):Connect(function() if not d.Enabled then d.Enabled=true end end)
        end
    end
    ch.DescendantAdded:Connect(function(d)
        if d:IsA("BallSocketConstraint") or d:IsA("HingeConstraint") or d:IsA("NoCollisionConstraint") then
            task.defer(function() pcall(function() d:Destroy() end); antiRagdoll(ch) end)
        elseif d:IsA("LocalScript") and (string.find(string.lower(d.Name),"ragdoll") or string.find(string.lower(d.Name),"fall")) then
            d.Disabled=true
        end
    end)
    ch.ChildAdded:Connect(function(c)
        if c:IsA("Tool") and (hh.pureTweenFarm or hh.autoFarmLoop) and not hh.holdingEggForGuard then
            task.defer(function() u4() end)
        end
    end)
end

local function setGodmode(state)
    hh.godmode=state
    local ch=o.Character
    if not ch then return end
    local hb=ch:FindFirstChildOfClass("Humanoid")
    if hb then
        hb:SetStateEnabled(Enum.HumanoidStateType.Dead,not state)
        if state and hb.Health<100 then hb.Health=100 end
    end
    for _,d in ipairs(ch:GetDescendants()) do
        if d:IsA("BasePart") and state then d.CanTouch=false; d.CanCollide=false end
    end
    antiRagdoll(ch)
end

local function swapHumanoid()
    local ch=o.Character
    local hb=ch and ch:FindFirstChildOfClass("Humanoid")
    if not ch or not hb then return false end
    pcall(function()
        hb.BreakJointsOnDeath=false
        local clone=hb:Clone(); clone.Parent=ch; hb:Destroy()
        if not clone:FindFirstChildOfClass("Animator") then Instance.new("Animator",clone) end
        r.CurrentCamera.CameraSubject=clone
        local an=ch:FindFirstChild("Animate")
        if an and an:IsA("LocalScript") then an.Disabled=true; task.defer(function() task.wait(0.05); an.Disabled=false end) end
        clone:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
        clone:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
        clone:SetStateEnabled(Enum.HumanoidStateType.Running,true)
        clone:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
        clone.JumpPower=math.max(50,clone.JumpPower)
        clone.JumpHeight=math.max(7.2,clone.JumpHeight)
        clone:ChangeState(Enum.HumanoidStateType.Running)
    end)
    hh.swapped=true
    if hh.godmode then setGodmode(true) end
    bindAntiRagdoll(ch)
    return true
end

D4=function()
    hh.teleporting=false; hh.glidingToTarget=false; hh.securingEgg=false
    hh.isReturning=false; hh.delivering=false; hh.holdingEggForGuard=false
    hh.currentTargetModel=nil; hh.targetPosition=nil
    hh.stateTime=os.clock()
    local ch=o.Character
    local root=ch and ch:FindFirstChild("HumanoidRootPart")
    if root then pcall(function()
        if _G._KerryHubSelfAnchor then _G._KerryHubSelfAnchor=false end
        root.Anchored=false; root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero
    end) end
    pcall(function() if antiRagdoll and ch then antiRagdoll(ch) end end)
end

local function firePrompts(target,pos)
    if target then
        for _,d in ipairs(target:GetDescendants()) do
            if d:IsA("ProximityPrompt") then
                pcall(function()
                    d.RequiresLineOfSight=false; d.HoldDuration=0
                    if typeof(fireproximityprompt)=="function" then fireproximityprompt(d,0); fireproximityprompt(d) end
                end)
            end
        end
    end
    local slots=r:FindFirstChild("AreaEggSlotsClient")
    if slots and pos then
        for _,ch in ipairs(slots:GetChildren()) do
            local bp=ch:FindFirstChildWhichIsA("BasePart") or ch.PrimaryPart
            if bp and (bp.Position-pos).Magnitude<=18 then
                for _,d in ipairs(ch:GetDescendants()) do
                    if d:IsA("ProximityPrompt") then
                        pcall(function()
                            d.RequiresLineOfSight=false; d.HoldDuration=0
                            if typeof(fireproximityprompt)=="function" then fireproximityprompt(d,0); fireproximityprompt(d) end
                        end)
                    end
                end
            end
        end
    end
end

Dk=function(name,x,z)
    local ux=x and x or 0
    local wl=string.lower(tostring(name or ""))
    local jl=string.lower(tostring(z or ""))
    if jl~="" and jl~="egg" then
        if string.find(jl,"enchanted") then return "Enchanted Forest" end
        if string.find(jl,"angel") or string.find(jl,"demon") or string.find(jl,"heaven") or string.find(jl,"hell") then return "Angels & Demons" end
        if string.find(jl,"spideron") or string.find(jl,"crustacia") or string.find(jl,"bladehide") or string.find(jl,"mantaris") or string.find(jl,"rhinotaur") or string.find(jl,"mutantshark") or string.find(jl,"gorillaking") or string.find(jl,"nightflame") then return "Titan Temple" end
        if string.find(jl,"crane") or string.find(jl,"salamander") or string.find(jl,"redpanda") or string.find(jl,"snowyowl") or string.find(jl,"koiegg") or string.find(jl,"stagegg") or string.find(jl,"onitiger") or string.find(jl,"kitsune") then return "Cherry Blossom" end
        if string.find(jl,"centapede") or string.find(jl,"cosmicgecko") or string.find(jl,"cosmicgorilla") or string.find(jl,"saturno") or string.find(jl,"saturnita") or string.find(jl,"vacca") or string.find(jl,"skeletonboss") or string.find(jl,"cosmicdragon") or string.find(jl,"lunardragon") or string.find(jl,"unicornegg") then return "Cosmic" end
        if string.find(jl,"dodo") or string.find(jl,"pterodactyl") or string.find(jl,"ankylosaurus") or string.find(jl,"triceratops") or string.find(jl,"bronto") or string.find(jl,"trex") or string.find(jl,"tralaledon") or string.find(jl,"mosasaurus") then return "Prehistoric" end
        if string.find(jl,"parrotfish") or string.find(jl,"swordfish") or string.find(jl,"whaleshark") or string.find(jl,"belugawhale") or string.find(jl,"kraken") or string.find(jl,"elmaja") then return "Abyss Ocean" end
        if string.find(jl,"lava gecko") or string.find(jl,"lava frog") or string.find(jl,"flaming bull") or string.find(jl,"lava iguana") or string.find(jl,"chillin chilli") or string.find(jl,"cerberus") or string.find(jl,"phoenix") or string.find(jl,"lava dragon") then return "Volcano" end
        if string.find(jl,"penguin") or string.find(jl,"walrus") or string.find(jl,"polar bear") or string.find(jl,"sabertooth") or string.find(jl,"mammoth") or string.find(jl,"yeti") or string.find(jl,"ice dragon") then return "Snow" end
        if string.find(jl,"sand spider") or string.find(jl,"sphinx") or string.find(jl,"tob tobi") or string.find(jl,"jerboa") or string.find(jl,"fennec") or string.find(jl,"camel") then return "Desert" end
        if string.find(jl,"chimpanzee") or string.find(jl,"toucan") or string.find(jl,"crocodile") or string.find(jl,"orangutini") or string.find(jl,"ananassini") or string.find(jl,"king snake") then return "Jungle" end
        if string.find(jl,"duckling") or string.find(jl,"catfish") or string.find(jl,"turtle") or string.find(jl,"trulimero") or string.find(jl,"trulicina") or string.find(jl,"swan") or string.find(jl,"axolotl") or string.find(jl,"leviathan") then return "Lake" end
        if string.find(jl,"burrowing owl") or string.find(jl,"brr brr") or string.find(jl,"patapim") or string.find(jl,"chicken") or string.find(jl,"dog") or string.find(jl,"bird") or string.find(jl,"raccoon") or string.find(jl,"fox") then return "Forest" end
    end
    if string.find(wl,"enchanted") then return "Enchanted Forest" end
    if (string.find(wl,"angel") or string.find(wl,"demon")) then return "Angels & Demons" end
    if (string.find(wl,"light") and string.find(wl,"dark")) or wl=="lightdark" then return "Light Dark"
    elseif string.find(wl,"titan") then return "Titan Temple"
    elseif string.find(wl,"cherry") then return "Cherry Blossom"
    elseif string.find(wl,"cosmic") then return "Cosmic"
    elseif string.find(wl,"prehistoric") or string.find(wl,"dino") then return "Prehistoric"
    elseif string.find(wl,"abyss") or string.find(wl,"ocean") then return "Abyss Ocean"
    elseif string.find(wl,"volcano") or string.find(wl,"lava") then return "Volcano"
    elseif string.find(wl,"snow") or string.find(wl,"ice") or string.find(wl,"winter") then return "Snow"
    elseif string.find(wl,"jungle") then return "Jungle"
    elseif string.find(wl,"desert") or string.find(wl,"sand") then return "Desert"
    elseif string.find(wl,"lake") or string.find(wl,"water") then return "Lake"
    elseif string.find(wl,"forest") then return "Forest" end
    if ux>0 then
        if ux>=6300 then return "Enchanted Forest"
        elseif ux>=5300 then return "Angels & Demons"
        elseif ux>=5200 then return "Light Dark"
        elseif ux>=4750 then return "Titan Temple"
        elseif ux>=4000 then return "Cherry Blossom"
        elseif ux>=3350 then return "Cosmic"
        elseif ux>=2780 then return "Prehistoric"
        elseif ux>=2250 then return "Abyss Ocean"
        elseif ux>=1850 then return "Volcano"
        elseif ux>=1450 then return "Snow"
        elseif ux>=1150 then return "Jungle"
        elseif ux>=920 then return "Desert"
        elseif ux>=720 then return "Lake"
        else return "Forest" end
    end
    return "Forest"
end

i4=function()
    local list={}
    local deb=r:FindFirstChild("__DEBRIS")
    if deb then
        for _,it in ipairs(deb:GetChildren()) do
            local hb=it:FindFirstChild("Hitbox")
            if hb and hb:IsA("BasePart") then table.insert(list,hb)
            elseif it:IsA("BasePart") and string.find(it.Name:lower(),"hitbox") then table.insert(list,it) end
        end
    end
    local ba=r:FindFirstChild("BossArenaTeleport")
    if ba then
        local hb=ba:FindFirstChild("Hitbox") or ba:FindFirstChildWhichIsA("BasePart") or (ba:IsA("BasePart") and ba)
        if hb and hb:IsA("BasePart") then table.insert(list,hb) end
    end
    return list
end

N4=function()
    local list=h4(false)
    if not list or #list==0 then list=h4(true) end
    if not list or #list==0 then return nil end
    local ch=o.Character
    local root=ch and ch:FindFirstChild("HumanoidRootPart")
    local myPos=root and root.Position or Vector3.new(SAFE_ZONE_X,SAFE_ZONE_Y,SAFE_ZONE_LANE_Z)
    local function scoreOf(rec)
        local rt=rec.RarityTier or 0
        local zw=rec.ZoneWeight or 50
        if rt>=4 then return 400000+(rt*10000)+zw else return (zw*11)+(rt*1000) end
    end
    local function rarTier(rec,cat,extra)
        local rr=string.lower(tostring(rec.Rarity or ""))
        local jr=string.lower(tostring(extra or ""))
        for _,r2 in ipairs({rr,jr}) do
            if r2~="" and r2~="unknown" and r2~="nil" then
                if string.find(r2,"divine") then return 6,"Divine" end
                if string.find(r2,"eternal") then return 5,"Eternal" end
                if string.find(r2,"secret") then return 4,"Secret" end
                if string.find(r2,"cosmic") then return 3,"Cosmic" end
                if string.find(r2,"mythic") then return 2,"Mythic" end
                if string.find(r2,"legendary") then return 1,"Legendary" end
                if string.find(r2,"epic") then return 0.5,"Epic" end
                if string.find(r2,"rare") then return 0.3,"Rare" end
                if string.find(r2,"uncommon") then return 0.1,"Uncommon" end
                if string.find(r2,"common") then return 0,"Common" end
            end
        end
        local joined=string.lower(string.format("%s %s %s",tostring(cat or ""),tostring(rec.Uid or ""),tostring(rec.Name or "")))
        if string.find(joined,"nightflame") or string.find(joined,"unicornegg") or string.find(joined,"kitsune") or string.find(joined,"elmaja")
           or string.find(joined,"archangel") or string.find(joined,"worldburner") or string.find(joined,"celestialdragon")
           or string.find(joined,"enchantedphoenix") or string.find(joined,"eternaltreant") or string.find(joined,"spiritwolf") then return 6,"Divine" end
        if string.find(joined,"gorillaking") or string.find(joined,"lunardragon") or string.find(joined,"onitiger") or string.find(joined,"mosasaurus")
           or string.find(joined,"pegasus") or string.find(joined,"skeletonhorse") or string.find(joined,"moonlightwolf")
           or string.find(joined,"forestguardian") then return 5,"Eternal" end
        if string.find(joined,"mutantshark") or string.find(joined,"skeletonboss") or string.find(joined,"stagegg") or string.find(joined,"cosmicdragon")
           or string.find(joined,"trex") or string.find(joined,"tralaledon") or string.find(joined,"kraken")
           or string.find(joined,"gargoyle") or string.find(joined,"razorfang") or string.find(joined,"centaur") or string.find(joined,"purejellyfish")
           or string.find(joined,"mossdragon") or string.find(joined,"fairyqueen") then return 4,"Secret" end
        if string.find(joined,"saturnita") or string.find(joined,"saturno") or string.find(joined,"mantaris") or string.find(joined,"rhinotaur")
           or string.find(joined,"snowyowl") or string.find(joined,"koiegg") or string.find(joined,"triceratops") or string.find(joined,"bronto")
           or string.find(joined,"whaleshark") or string.find(joined,"belugawhale") or string.find(joined,"imp") or string.find(joined,"demonhound")
           or string.find(joined,"sacredmoth") or string.find(joined,"holypeacock") or string.find(joined,"glowdeer") or string.find(joined,"pixiedragon") then return 3,"Cosmic" end
        if string.find(joined,"bladehide") or string.find(joined,"redpanda") or string.find(joined,"cosmicgorilla") or string.find(joined,"ankylosaurus")
           or string.find(joined,"toro") or string.find(joined,"wingedlamb") or string.find(joined,"mushroomfrog") or string.find(joined,"treant") then return 2,"Mythic" end
        if string.find(joined,"spideron") or string.find(joined,"crustacia") or string.find(joined,"salamander") or string.find(joined,"cosmicgecko")
           or string.find(joined,"pterodactyl") or string.find(joined,"flamesprite") or string.find(joined,"lightdove")
           or string.find(joined,"sprite") or string.find(joined,"firefly") then return 1,"Legendary" end
        if string.find(joined,"crane") or string.find(joined,"centapede") or string.find(joined,"swordfish") then return 0.5,"Epic" end
        if string.find(joined,"dodo") or string.find(joined,"parrotfish") then return 0.3,"Rare" end
        return F[extra or "Common"] or 0, extra or "Common"
    end
    local function collect(ignoreBlocked)
        local out={}
        for _,rec in ipairs(list) do
            local ok=(rec.State=="Slot" or rec.State=="Dropped" or rec.State=="GuardCarried" or rec.State==1)
            local inBase=(rec.BoundsCFrame and rec.BoundsCFrame.Position.X<530) or string.find(tostring(rec.Uid),"FirstArea")
            local blocked=X4[rec.Uid] and os.clock()<X4[rec.Uid]
            if ok and not inBase and (ignoreBlocked or not blocked) and rec.BoundsCFrame then
                local cat=rec.AssetCategory or "Egg"
                local inc=0; local rnk=0
                if p then
                    pcall(function()
                        if p.RarityRankForCategory then rnk=p.RarityRankForCategory(cat) or 0 end
                        if p.ProfileIncomePerSecond then inc=p.ProfileIncomePerSecond(cat) or 0 end
                    end)
                end
                local zone=Dk(rec.AreaId,rec.BoundsCFrame.Position.X,tostring(cat).." "..tostring(rec.Uid))
                local tier,rarName=rarTier(rec,cat,rec.Rarity)
                local rarOk=(hh.selectedRarities and hh.selectedRarities[rarName]==true)
                local zoneOk=(hh.selectedZones and hh.selectedZones[zone]==true)
                local alwaysHigh=(tier>=4 or rarName=="Secret" or rarName=="Eternal" or rarName=="Divine")
                local take=false
                if alwaysHigh and hh.alwaysCollectSecretPlus then take=true
                elseif zoneOk and rarOk then take=true end
                if take then
                    local sc=tonumber(rec.AssetScale or rec.Scale) or 1
                    local mm=1
                    if rec.Mutations and type(rec.Mutations)=="table" then
                        for _,mv in pairs(rec.Mutations) do
                            local m2=(type(mv)=="table" and tonumber(mv.Multiplier or mv.Value)) or tonumber(mv) or 1.5
                            mm=mm*m2
                        end
                    elseif rec.Mutation then mm=1.5 end
                    local realInc=(inc*sc)*mm
                    local zw=f[zone] or 50
                    if realInc<=0 then realInc=(((zw^2)*sc)*mm)*10 end
                    table.insert(out,{Uid=rec.Uid,Category=tostring(cat),Area=tostring(zone),ZoneWeight=zw,Rarity=rarName,
                    RarityTier=tier,Rank=rnk,Income=inc,RealIncome=realInc,
                    Scale=sc,MutMultiplier=mm,CFrame=rec.BoundsCFrame,
                    Position=rec.BoundsCFrame.Position,Distance=(myPos-rec.BoundsCFrame.Position).Magnitude,
                    Model=rec.PhysicalModel})
                end
            end
        end
        return out
    end
    local cands=collect(false)
    if #cands==0 then X4={}; cands=collect(true) end
    if #cands==0 then return nil end
    table.sort(cands,function(a1,b1)
        local sa=scoreOf(a1); local sb=scoreOf(b1)
        if sa~=sb then return sa>sb end
        if a1.ZoneWeight~=b1.ZoneWeight then return a1.ZoneWeight>b1.ZoneWeight end
        if math.abs(a1.RealIncome-b1.RealIncome)>1 then return a1.RealIncome>b1.RealIncome end
        if math.abs(a1.Scale-b1.Scale)>0.05 then return a1.Scale>b1.Scale end
        return a1.Distance<b1.Distance
    end)
    return cands[1]
end

ek=function()
    if m4 then return end
    local rem=R or j:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot",true) or j:FindFirstChild("AskFieldEggSnapshot",true) or j:FindFirstChild("Eggs: RequestAreaEggSnapshot",true)
    if not rem or not rem:IsA("RemoteFunction") then return end
    m4=true
    task.spawn(function()
        local ok,res=pcall(function() return rem:InvokeServer() end)
        if ok and type(res)=="table" then
            local out={}
            local rec=res.Records or res
            if type(rec)=="table" then
                for k,vv in pairs(rec) do
                    if type(vv)=="table" then
                        if not vv.Uid and type(k)=="string" then vv.Uid=k end
                        table.insert(out,vv)
                    end
                end
            end
            if #out>0 then F4=out; G4=os.clock() end
        end
        m4=false
    end)
end

task.spawn(function()
    while true do task.wait(1.5); pcall(ek) end
end)

h4=function(force)
    local now=os.clock()
    if force or (now-G4>=1.5) or not F4 then ek() end
    local fromF=(F4 and #F4>0) and F4 or nil
    local fromS=nil
    if s and s.ReadFieldEggs then
        local ok,res=pcall(s.ReadFieldEggs)
        if ok and type(res)=="table" then
            local out={}
            local rec=res.Records or res
            if type(rec)=="table" then
                for k,vv in pairs(rec) do
                    if type(vv)=="table" then
                        if not vv.Uid and type(k)=="string" then vv.Uid=k end
                        table.insert(out,vv)
                    end
                end
            end
            if #out>0 then fromS=out end
        end
    end
    local merged={}; local seen={}
    if fromF then for _,vv in ipairs(fromF) do if vv.Uid then seen[vv.Uid]=true; table.insert(merged,vv) end end end
    if fromS then for _,vv in ipairs(fromS) do if vv.Uid and not seen[vv.Uid] then seen[vv.Uid]=true; table.insert(merged,vv) end end end
    local slots=r:FindFirstChild("AreaEggSlotsClient")
    if slots then
        for _,ch in ipairs(slots:GetChildren()) do
            local nm=ch.Name
            if nm and nm~="" then
                local cf=ch:GetPivot(); local pos=cf.Position
                if pos.X>=530 and not string.find(tostring(nm),"FirstArea") then
                    if not seen[nm] then
                        seen[nm]=true
                        table.insert(merged,{Uid=nm,
                            AssetCategory=ch:GetAttribute("Category") or ch:GetAttribute("AssetCategory") or ch.Name,
                            AreaId=ch:GetAttribute("AreaId") or ch:GetAttribute("Area"),
                            Rarity=ch:GetAttribute("Rarity") or ch:GetAttribute("RarityTier"),
                            Rank=ch:GetAttribute("RarityRank") or ch:GetAttribute("Rank"),
                            Income=ch:GetAttribute("Income") or ch:GetAttribute("EarningRate"),
                            AssetScale=ch:GetAttribute("Scale") or ch:GetAttribute("AssetScale") or 1,
                            Mutations=ch:GetAttribute("Mutations") or ch:GetAttribute("Mutation"),
                            BoundsCFrame=cf,BottomCFrame=cf,CFrame=cf,State="Slot",PhysicalModel=ch})
                    end
                end
            end
        end
    end
    return merged
end

wk=function(targetPos,speed,uid,session)
    local ch=o.Character
    local root=ch and ch:FindFirstChild("HumanoidRootPart")
    local hb=ch and ch:FindFirstChildOfClass("Humanoid")
    if not root then return false end
    if hb then hb.AutoRotate=false end
    speed=math.max(60,speed or hh.glideSpeed or 350)
    local dest=targetPos.Position
    V4(dest,14)
    pcall(function() o:RequestStreamAroundAsync(dest) end)
    root.AssemblyLinearVelocity=Vector3.zero
    root.AssemblyAngularVelocity=Vector3.zero
    local lane=hh.laneZ or L
    hh.glidingToTarget=true; hh.stateTime=os.clock()
    local lastCheck=0
    local deadline=os.clock()+15
    while hh.alive and hh.glidingToTarget and os.clock()<deadline do
        if session and O4~=session then
            if hb then hb.AutoRotate=true end
            hh.glidingToTarget=false; return false
        end
        if not hh.pureTweenFarm and not hh.autoFarmLoop and not hh.teleporting then
            if hb then hb.AutoRotate=true end
            hh.glidingToTarget=false; return false
        end
        if root.Anchored then pcall(function() root.Anchored=false end) end
        local pos=root.Position
        local dist=(dest-pos).Magnitude
        local hor=((Vector2.new(pos.X,pos.Z)-Vector2.new(dest.X,dest.Z))).Magnitude
        local vert=math.abs(pos.Y-dest.Y)
        if dist<=6 or (hor<=3.5 and vert<=6) then break end
        local dt=y.Heartbeat:Wait()
        pos=root.Position
        dist=(dest-pos).Magnitude
        if uid and (os.clock()-lastCheck>0.5) then
            lastCheck=os.clock()
            local ok,st=k4(uid)
            if not ok and st=="CarriedByOther" then
                if hb then hb.AutoRotate=true end
                hh.glidingToTarget=false; return false
            end
        end
        local dxAbs=math.abs(pos.X-dest.X)
        local tz=dest.Z
        if dxAbs>40 then tz=lane end
        local sx=math.sign(dest.X-pos.X)*math.min(math.abs(dest.X-pos.X),speed*dt)
        local nX=pos.X+sx
        local yFac=(hor<=25) and 1.2 or 0.5
        local sy=math.sign(dest.Y-pos.Y)*math.min(math.abs(dest.Y-pos.Y),(speed*dt)*yFac)
        local nY=pos.Y+sy
        local sz=math.sign(tz-pos.Z)*math.min(math.abs(tz-pos.Z),speed*dt)
        local nZ=pos.Z+sz
        local trap=false
        if hor>25 then
            local traps=i4()
            for _,tp in ipairs(traps) do
                local tpos=tp.Position
                local d3=((Vector3.new(nX,nY,nZ)-tpos)).Magnitude
                local dx2=math.abs(nX-tpos.X); local dz2=math.abs(nZ-tpos.Z)
                if d3<22 or (dx2<18 and dz2<14) then
                    trap=true
                    local safeY=tpos.Y+16
                    if nY<safeY then nY=math.min(nY+(speed*dt)*1.5,safeY) end
                    break
                end
            end
        end
        local tgt=Vector3.new(nX,nY,nZ)
        local dir=(tgt-pos).Magnitude>0.05 and (tgt-pos).Unit or root.CFrame.LookVector
        root.CFrame=CFrame.lookAt(tgt,tgt+dir)
        root.AssemblyLinearVelocity=Vector3.zero
        root.AssemblyAngularVelocity=Vector3.zero
        hh.statusText=trap and string.format("Gliding Out (Z: %.0f) [DODGING!]",nZ) or string.format("Gliding -> Egg (%.0f studs)",dist)
    end
    root.CFrame=targetPos*CFrame.new(0,0.4,0)
    root.AssemblyLinearVelocity=Vector3.zero
    root.AssemblyAngularVelocity=Vector3.zero
    if hb then hb.AutoRotate=true end
    hh.glidingToTarget=false
    return true
end

t4=function(targetPos,speed,uid,session)
    local ch=o.Character
    local root=ch and ch:FindFirstChild("HumanoidRootPart")
    if root then
        if root.Position.X<=SAFE_ZONE_X+35 and targetPos.Position.X>SAFE_ZONE_X-10 then
            local wp=CFrame.new(SAFE_ZONE_X+20,SAFE_ZONE_Y,SAFE_ZONE_LANE_Z)
            if (root.Position-wp.Position).Magnitude>5 then
                hh.statusText="[AutoSteal] Exiting Forest -> waypoint..."
                local ok=wk(wp,speed,uid,session)
                if not ok then return false end
                task.wait(0.04)
            end
        end
    end
    return wk(targetPos,speed,uid,session)
end

-- ==========================================
-- RETURN: Rise +10 → Escape-jump → Hops (high) → Descend at Forest
-- ==========================================
s4=function(speed,session)
    local ch=o.Character
    local root=ch and ch:FindFirstChild("HumanoidRootPart")
    local hb=ch and ch:FindFirstChildOfClass("Humanoid")
    if not root then return false end

    hh.isReturning=true; hh.stateTime=os.clock()

    -- 1) Сброс ступора
    pcall(function()
        if _G._KerryHubSelfAnchor then _G._KerryHubSelfAnchor=false end
        root.Anchored=false
        if hb then
            hb.PlatformStand=false; hb.Sit=false
            hb:ChangeState(Enum.HumanoidStateType.Running)
            if hb.WalkSpeed<=0 then hb.WalkSpeed=16 end
        end
        antiRagdoll(ch)
        u4()
    end)

    -- 2) ПОДЪЁМ НА +10 studs
    hh.statusText="[Escape] Rising +10 studs..."
    local curX = root.Position.X
    local liftPos = Vector3.new(curX, HIGH_Y, SAFE_ZONE_LANE_Z)
    pcall(function() o:RequestStreamAroundAsync(liftPos) end)
    for i=1,3 do
        if session and O4~=session then break end
        pcall(function()
            local r2=o.Character and o.Character:FindFirstChild("HumanoidRootPart")
            if r2 then
                r2.Anchored=false
                r2.CFrame=CFrame.new(liftPos)
                r2.AssemblyLinearVelocity=Vector3.zero
                r2.AssemblyAngularVelocity=Vector3.zero
            end
        end)
        task.wait(0.03)
    end
    task.wait(0.05)

    -- 3) ESCAPE-JUMP от босса (на высоте +10)
    hh.statusText="[Escape] Jumping away from boss..."
    local cx=(o.Character and o.Character:FindFirstChild("HumanoidRootPart") and o.Character.HumanoidRootPart.Position.X) or curX
    local escapeX=math.max(SAFE_ZONE_X, cx-600)
    local escapePos=Vector3.new(escapeX, HIGH_Y, SAFE_ZONE_LANE_Z)
    pcall(function() o:RequestStreamAroundAsync(escapePos) end)
    for i=1,3 do
        if session and O4~=session then break end
        pcall(function()
            local r2=o.Character and o.Character:FindFirstChild("HumanoidRootPart")
            if r2 then
                r2.Anchored=false
                r2.CFrame=CFrame.new(escapePos)
                r2.AssemblyLinearVelocity=Vector3.zero
                r2.AssemblyAngularVelocity=Vector3.zero
            end
        end)
        task.wait(0.03)
    end
    V4(escapePos,6)
    task.wait(0.05)

    -- 4) ОБЫЧНЫЕ ХОПЫ, на высоте +10 (последний — спуск)
    local myX=(o.Character and o.Character:FindFirstChild("HumanoidRootPart") and o.Character.HumanoidRootPart.Position.X) or escapeX
    local startIdx=#HOP_POINTS
    for idx,point in ipairs(HOP_POINTS) do
        if myX>=point.X-200 then startIdx=idx; break end
    end

    hh.statusText=string.format("Hop (high) from idx %d -> Forest...",startIdx)

    for idx=startIdx,#HOP_POINTS do
        if not hh.alive then break end
        if session and O4~=session then break end
        if not hh.pureTweenFarm and not hh.autoFarmLoop then break end

        local point=HOP_POINTS[idx]
        local isLast=(idx==#HOP_POINTS)
        local targetY=isLast and SAFE_ZONE_Y or HIGH_Y
        local targetPos=Vector3.new(point.X, targetY, point.Z or SAFE_ZONE_LANE_Z)
        pcall(function() o:RequestStreamAroundAsync(targetPos) end)

        pcall(function()
            if _G._KerryHubSelfAnchor then _G._KerryHubSelfAnchor=false end
            local r2=o.Character and o.Character:FindFirstChild("HumanoidRootPart")
            if r2 then
                r2.Anchored=false
                r2.CFrame=CFrame.new(targetPos)
                r2.AssemblyLinearVelocity=Vector3.zero
                r2.AssemblyAngularVelocity=Vector3.zero
            end
            if hb then
                if hb.PlatformStand then hb.PlatformStand=false end
                if hb.Sit then hb.Sit=false end
                hb:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
        task.wait(0.06)
        pcall(function()
            local r2=o.Character and o.Character:FindFirstChild("HumanoidRootPart")
            if r2 then
                r2.CFrame=CFrame.new(targetPos)
                r2.AssemblyLinearVelocity=Vector3.zero
                r2.AssemblyAngularVelocity=Vector3.zero
            end
        end)
        V4(targetPos,6)
        if isLast then
            hh.statusText="Descending to Forest (normal height)..."
        else
            hh.statusText=string.format("Hop %d/%d (X=%.0f, Y=%.0f)",idx,#HOP_POINTS,point.X,HIGH_Y)
        end
        task.wait(0.12)
    end

    -- 5) Финальная фиксация
    task.wait(0.08)
    pcall(function()
        local r2=o.Character and o.Character:FindFirstChild("HumanoidRootPart")
        if r2 then
            r2.Anchored=false
            r2.CFrame=CFrame.new(SAFE_ZONE_X,SAFE_ZONE_Y,SAFE_ZONE_LANE_Z)
            r2.AssemblyLinearVelocity=Vector3.zero
            r2.AssemblyAngularVelocity=Vector3.zero
        end
        if hb then hb.AutoRotate=true end
    end)
    pcall(u4)
    hh.isReturning=false
    hh.statusText="Arrived at Forest (Safe Zone)!"
    return true
end

U4=function(uid,targetCF,targetModel,session)
    local ch=o.Character
    local root=ch and ch:FindFirstChild("HumanoidRootPart")
    local hb=ch and ch:FindFirstChildOfClass("Humanoid")
    if not root or not hb then return false end
    hh.securingEgg=true; hh.isReturning=false; hh.stateTime=os.clock()
    hh.holdingEggForGuard=true
    local pos=targetCF.Position
    V4(pos,14)
    hh.currentTargetModel=targetModel
    hh.targetPosition=pos
    root.AssemblyLinearVelocity=Vector3.zero
    root.AssemblyAngularVelocity=Vector3.zero
    antiRagdoll(ch)
    pcall(function() o:RequestStreamAroundAsync(pos) end)
    if not targetModel and r:FindFirstChild("AreaEggSlotsClient") then
        for _,cm in ipairs(r.AreaEggSlotsClient:GetChildren()) do
            local bp=cm:FindFirstChildWhichIsA("BasePart") or cm.PrimaryPart
            if bp and (bp.Position-pos).Magnitude<=16 then targetModel=cm; hh.currentTargetModel=cm; break end
        end
    end
    hh.statusText="[1/4] Lifting Egg..."
    local t1=os.clock()+3.5
    local lastCheck=0
    while not w4() and os.clock()<t1 and hh.alive and hh.securingEgg do
        if session and O4~=session then break end
        if not hh.pureTweenFarm and not hh.autoFarmLoop and not hh.teleporting then break end
        if root.Anchored then pcall(function() root.Anchored=false end) end
        if uid and (os.clock()-lastCheck>0.4) then
            lastCheck=os.clock()
            local ok,st=k4(uid)
            if not ok and st=="CarriedByOther" then break end
        end
        ch:PivotTo(targetCF*CFrame.new(0,0.4,0))
        firePrompts(targetModel,pos)
        if uid and i then
            task.spawn(function() pcall(function()
                if i:IsA("RemoteFunction") then i:InvokeServer({Uid=uid}); i:InvokeServer(uid)
                else i:FireServer({Uid=uid}); i:FireServer(uid) end
            end) end)
        end
        y.Heartbeat:Wait()
    end
    if not w4() then
        hh.currentTargetModel=nil; hh.targetPosition=nil; hh.securingEgg=false; hh.holdingEggForGuard=false
        return false
    end
    hh.statusText="[2/4] Waiting Guard Strike..."
    local t2=os.clock()+4.5
    local fired=false
    while w4() and os.clock()<t2 and hh.alive and hh.securingEgg do
        if session and O4~=session then break end
        if not hh.pureTweenFarm and not hh.autoFarmLoop and not hh.teleporting then break end
        ch:PivotTo(targetCF*CFrame.new(0,0.4,0))
        V4(pos,14)
        if P and not fired then
            task.spawn(function() pcall(function()
                if P:IsA("RemoteFunction") then P:InvokeServer() else P:FireServer() end
            end) end)
            fired=true
        end
        y.Heartbeat:Wait()
    end
    hh.statusText="[3/4] Re-grabbing Egg..."
    local t3=os.clock()+3
    while not w4() and os.clock()<t3 and hh.alive and hh.securingEgg do
        if session and O4~=session then break end
        if not hh.pureTweenFarm and not hh.autoFarmLoop and not hh.teleporting then break end
        ch:PivotTo(targetCF*CFrame.new(0,0.4,0))
        firePrompts(targetModel,pos)
        if uid and i then
            task.spawn(function() pcall(function()
                if i:IsA("RemoteFunction") then i:InvokeServer({Uid=uid}); i:InvokeServer(uid)
                else i:FireServer({Uid=uid}); i:FireServer(uid) end
            end) end)
        end
        y.Heartbeat:Wait()
    end
    local ok=j4(uid)
    if not ok then task.wait(0.12); ok=j4(uid) end
    hh.currentTargetModel=nil; hh.targetPosition=nil; hh.securingEgg=false; hh.holdingEggForGuard=false
    if session and O4~=session then return false end
    if ok then
        pcall(u4)
        hh.statusText="Egg Secured! Returning to Forest..."
    else
        hh.statusText="[-] Failed to re-grab egg"
        if uid then X4[uid]=os.clock()+2 end
    end
    return ok
end

l4=function(target,session)
    if hh.teleporting or hh.glidingToTarget or hh.delivering or hh.securingEgg then return false end
    hh.teleporting=true; hh.isReturning=false; hh.stateTime=os.clock()
    local ch=o.Character
    local root=ch and ch:FindFirstChild("HumanoidRootPart")
    local hb=ch and ch:FindFirstChildOfClass("Humanoid")
    if not root or not hb then D4(); return false end
    hb:UnequipTools()
    hh.statusText="[1/7] Pre-Flight Desync..."
    if not hh.swapped then swapHumanoid() end
    if not hh.godmode then setGodmode(true) end
    antiRagdoll(ch)
    if not target then D4(); return false end
    local tCF=target.CFrame
    local uid=target.Uid
    local tPos=tCF.Position
    if uid then
        local ok,st=k4(uid)
        if not ok and st~="CarriedBySelf" then
            X4[uid]=os.clock()+5; D4(); return false
        end
    end
    hh.statusText="[3/7] Pre-streaming Target..."
    pcall(function() o:RequestStreamAroundAsync(tPos) end)
    V4(tPos,12)
    hh.statusText="[4/7] Waiting for physical bounce..."
    root.Anchored=false
    hb:ChangeState(Enum.HumanoidStateType.Running)
    local savedWS=(hb.WalkSpeed>0) and hb.WalkSpeed or 16
    hb.WalkSpeed=0
    hb:Move(Vector3.zero,false)
    root.AssemblyLinearVelocity=Vector3.zero
    root.AssemblyAngularVelocity=Vector3.zero
    task.wait(0.04)
    local startPos=root.Position
    local startY=startPos.Y
    local strikeUID=select(2,e4()) or uid
    local bounceSignal=false
    local conn=nil
    if N and N:IsA("RemoteEvent") then
        conn=N.OnClientEvent:Connect(function() bounceSignal=true; if conn then conn:Disconnect() end end)
    end
    hh.holdingEggForGuard=true
    H4(strikeUID)
    local t0=os.clock()
    local bounced=false
    local deadline=os.clock()+2.5
    local refired=false
    while os.clock()<deadline and hh.alive and hh.teleporting do
        if session and O4~=session then
            if conn then conn:Disconnect() end
            hb.WalkSpeed=savedWS; D4(); return false
        end
        if root.Anchored then pcall(function() root.Anchored=false end) end
        local e2=os.clock()-t0
        local vel=root.AssemblyLinearVelocity
        local p2=root.Position
        local dy=p2.Y-startY
        local moved=(p2-startPos).Magnitude
        if e2>=0.08 then
            local ok=bounceSignal or vel.Y>=10 or (dy>=1.5 and vel.Magnitude>=16) or moved>=2 or vel.Magnitude>=20
            if ok then bounced=true; break end
        end
        if e2>=0.5 and not refired then refired=true; H4(strikeUID) end
        y.Heartbeat:Wait()
    end
    if conn then conn:Disconnect() end
    hb.WalkSpeed=savedWS
    hh.holdingEggForGuard=false
    if not bounced then
        hh.statusText="[-] Aborted (No bounce detected)"
        D4(); pcall(u4); return false
    end
    task.wait(0.05)
    if uid then
        local ok,st=k4(uid)
        if not ok and st=="CarriedByOther" then
            X4[uid]=os.clock()+5; D4(); return false
        end
    end
    hh.currentTargetModel=target.Model
    hh.targetPosition=tPos
    hh.statusText="[5/7] Warping to Target Egg..."
    V4(tPos,8)
    ch:PivotTo(tCF*CFrame.new(0,0.4,0))
    _G._KerryHubSelfAnchor=true
    root.Anchored=true
    for _,d in ipairs(ch:GetDescendants()) do
        if d:IsA("BasePart") then d.AssemblyLinearVelocity=Vector3.zero; d.AssemblyAngularVelocity=Vector3.zero end
    end
    hh.statusText="[6/7] Picking up Target Egg..."
    local bp=o:FindFirstChild("Backpack")
    for _,it in ipairs(ch:GetChildren()) do
        if it:IsA("Tool") then
            pcall(function() if bp then it.Parent=bp else it.Parent=r end end)
        end
    end
    task.wait(0.06)
    root.Anchored=false
    _G._KerryHubSelfAnchor=false
    hb:ChangeState(Enum.HumanoidStateType.Running)
    local ok=U4(uid,tCF,target.Model,session)
    root.Anchored=false
    _G._KerryHubSelfAnchor=false
    hb:ChangeState(Enum.HumanoidStateType.Running)
    for _,d in ipairs(ch:GetDescendants()) do
        if d:IsA("BasePart") then d.AssemblyLinearVelocity=Vector3.zero; d.AssemblyAngularVelocity=Vector3.zero end
    end
    if not ok then
        hh.statusText="[-] Guard Strike failed"
        D4(); return false
    end
    hh.statusText="[7/7] Target Secured!"
    hh.teleporting=false
    pcall(u4)
    return true
end

T4=function(mode)
    if Y4==mode then return end
    O4=O4+1
    local mySession=O4
    Y4="SWITCHING"
    hh.pureTweenFarm=false; hh.autoFarmLoop=false
    pcall(D4); pcall(u4)
    task.delay(0.06,function()
        if O4==mySession then
            Y4=mode
            if mode=="TWEEN" then
                hh.pureTweenFarm=true; hh.autoFarmLoop=false
                pcall(u4)
            elseif mode=="WARP" then
                hh.autoFarmLoop=true; hh.pureTweenFarm=false
                pcall(u4)
            else
                hh.pureTweenFarm=false; hh.autoFarmLoop=false
            end
        end
    end)
end

local Ck=os.clock()
task.spawn(function()
    while hh.alive do
        local ok,err=pcall(function()
            if hh.pureTweenFarm and not hh.autoFarmLoop and Y4=="TWEEN"
            and not hh.teleporting and not hh.glidingToTarget and not hh.securingEgg
            and not hh.isReturning then
                local ch=o.Character
                local root=ch and ch:FindFirstChild("HumanoidRootPart")
                local hb=ch and ch:FindFirstChildOfClass("Humanoid")
                if root and hb then
                    pcall(u4)
                    if not w4() then
                        local mySession=O4
                        local target=N4()
                        if target and hh.pureTweenFarm and Y4=="TWEEN" and O4==mySession then
                            local ok2,st=k4(target.Uid)
                            if not ok2 and st~="CarriedBySelf" then
                                X4[target.Uid]=os.clock()+5; task.wait(0.12); return
                            end
                            hh.currentTargetModel=target.Model
                            hh.targetPosition=target.Position
                            hh.glidingToTarget=true; hh.stateTime=os.clock()
                            hh.statusText=string.format("[AutoSteal] Flying to %s (%s)...",target.Category or "Egg",target.Area or "Field")
                            if not hh.swapped then swapHumanoid() end
                            if not hh.godmode then setGodmode(true) end
                            antiRagdoll(ch)
                            pcall(function() o:RequestStreamAroundAsync(target.Position) end)
                            local destCF=target.CFrame*CFrame.new(0,0.4,0)
                            local reached=t4(destCF,hh.glideSpeed,target.Uid,mySession)
                            hh.glidingToTarget=false
                            if O4~=mySession or not hh.pureTweenFarm or Y4~="TWEEN" then return end
                            if not reached then
                                X4[target.Uid]=os.clock()+5; D4(); return
                            end
                            if hh.pureTweenFarm and Y4=="TWEEN" and (root.Position-target.Position).Magnitude<=22 then
                                local secured=U4(target.Uid,destCF,target.Model,mySession)
                                if not secured and w4() then secured=true end
                                if O4~=mySession or not hh.pureTweenFarm or Y4~="TWEEN" then return end
                                if secured then
                                    pcall(u4)
                                    hh.statusText="[AutoSteal] Secured! Returning to Forest..."
                                    s4(hh.glideSpeed,mySession)
                                    pcall(u4)
                                    hh.isReturning=false
                                    hh.glidingToTarget=false
                                    hh.securingEgg=false
                                    hh.currentTargetModel=nil
                                    hh.targetPosition=nil
                                else
                                    if O4==mySession and hh.pureTweenFarm and Y4=="TWEEN" then
                                        X4[target.Uid]=os.clock()+5; D4()
                                    end
                                end
                            else
                                hh.currentTargetModel=nil; hh.targetPosition=nil; hh.glidingToTarget=false
                            end
                        else
                            if os.clock()-Ck>5 then X4={}; Ck=os.clock() end
                            hh.statusText="[AutoSteal] Scanning for targets..."
                        end
                    end
                end
            end
        end)
        if not ok then
            warn("[AutoSteal Loop Error]",tostring(err))
            pcall(D4)
        end
        task.wait(0.08)
    end
end)

local qk=os.clock()
task.spawn(function()
    while hh.alive do
        local ok,err=pcall(function()
            if hh.autoFarmLoop and not hh.pureTweenFarm and Y4=="WARP"
            and not hh.teleporting and not hh.glidingToTarget and not hh.securingEgg
            and not hh.isReturning then
                local ch=o.Character
                local root=ch and ch:FindFirstChild("HumanoidRootPart")
                local hb=ch and ch:FindFirstChildOfClass("Humanoid")
                if root and hb then
                    pcall(u4)
                    if not w4() then
                        local mySession=O4
                        local target=N4()
                        if target and hh.autoFarmLoop and Y4=="WARP" and O4==mySession then
                            hh.statusText=string.format("[SnipeLoop] Warping for %s...",target.Category or "Egg")
                            local secured=l4(target,mySession)
                            if O4~=mySession or not hh.autoFarmLoop or Y4~="WARP" then return end
                            if secured then
                                pcall(u4)
                                hh.statusText="[SnipeLoop] Target secured! Returning to Forest..."
                                s4(hh.glideSpeed,mySession)
                                pcall(u4)
                                hh.isReturning=false
                            else
                                if O4==mySession and hh.autoFarmLoop and Y4=="WARP" then
                                    if target.Uid then X4[target.Uid]=os.clock()+5 end
                                    pcall(D4)
                                end
                            end
                        else
                            if os.clock()-qk>5 then X4={}; qk=os.clock() end
                            hh.statusText="[SnipeLoop] Searching for targets..."
                        end
                    end
                end
            end
        end)
        if not ok then
            warn("[SnipeLoop Error]",tostring(err))
            pcall(D4)
        end
        task.wait(0.08)
    end
end)

y.Heartbeat:Connect(function()
    local ch=o.Character
    local root=ch and ch:FindFirstChild("HumanoidRootPart")
    local hb=ch and ch:FindFirstChildOfClass("Humanoid")
    if not root then return end
    if hb then
        if hb.PlatformStand then hb.PlatformStand=false; hb:ChangeState(Enum.HumanoidStateType.Running) end
        if hb.Sit and (hh.pureTweenFarm or hh.autoFarmLoop or hh.isReturning or hh.glidingToTarget) then
            hb.Sit=false; hb:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
    local pos=root.Position
    local carrying=w4()
    if pos.Y<45 then
        root.CFrame=CFrame.new(pos.X,SAFE_ZONE_Y,pos.Z)
        root.AssemblyLinearVelocity=Vector3.zero
        return
    end
    if (hh.pureTweenFarm or hh.autoFarmLoop) and not hh.holdingEggForGuard then
        local hasTool=false
        for _,it in ipairs(ch:GetChildren()) do if it:IsA("Tool") then hasTool=true; break end end
        if hasTool then u4() end
    end
    if (hh.pureTweenFarm or hh.autoFarmLoop) and root.Anchored and not _G._KerryHubSelfAnchor then
        pcall(function() root.Anchored=false end)
    end
    if hh.pureTweenFarm or hh.autoFarmLoop or hh.teleporting or hh.glidingToTarget or hh.delivering or hh.securingEgg or hh.isReturning then return end
    if hh.alive and hh.autoGlide and carrying and not a4() and pos.X>SAFE_ZONE_X+50 then
        task.spawn(function() s4(hh.glideSpeed); u4(); hh.isReturning=false; hh.delivering=false end)
    end
end)

return {
    State=hh,
    SetFarmMode=T4,
    SetDesyncGodmode=setGodmode,
    ResetFarmStates=D4,
    GetTotalEggCount=y4,
    SaveEggSelectConfig=x,
    SaveSpeed=Y,
    ZoneList=M,
    RarityList=X
}
end)()

h=AutoFarm.State
h.autoGlide=true  -- форс-включение Auto Return

-- ==========================================
-- UI Registration
-- ==========================================
local StatusCard=Instance.new("Frame",autoFarmPage)
StatusCard.Size=UDim2.new(1,0,0,55)
StatusCard.BackgroundColor3=Color3.fromRGB(24,24,32)
StatusCard.BorderSizePixel=0
Instance.new("UICorner",StatusCard).CornerRadius=UDim.new(0,12)
local SCS=Instance.new("UIStroke",StatusCard)
SCS.Color=Color3.fromRGB(120,80,255); SCS.Transparency=0.4
local SCT=Instance.new("TextLabel",StatusCard)
SCT.Size=UDim2.new(1,-20,0,18); SCT.Position=UDim2.new(0,12,0,8)
SCT.BackgroundTransparency=1; SCT.Font=Enum.Font.GothamBold; SCT.Text="SYSTEM STATUS"
SCT.TextColor3=Color3.fromRGB(140,90,255); SCT.TextSize=11; SCT.TextXAlignment=Enum.TextXAlignment.Left
local SCD=Instance.new("TextLabel",StatusCard)
SCD.Size=UDim2.new(1,-20,0,22); SCD.Position=UDim2.new(0,12,0,26)
SCD.BackgroundTransparency=1; SCD.Font=Enum.Font.GothamMedium; SCD.Text="Ready"
SCD.TextColor3=Color3.fromRGB(230,230,240); SCD.TextSize=13; SCD.TextXAlignment=Enum.TextXAlignment.Left

task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        if SCD and SCD.Parent then
            local bag=AutoFarm.GetTotalEggCount()
            local st=tostring(h.statusText or "Ready")
            if st:sub(1,1)=="[" then SCD.Text=string.format("%s • Bag: %d eggs",st,bag)
            else SCD.Text=string.format("[%s] • Bag: %d eggs",st,bag) end
        end
        task.wait(0.2)
    end
end)

AddToggle(autoFarmPage,"Auto Steal (Tween)","Smoothly fly to steal eggs, return via teleports",h.pureTweenFarm==true,function(state)
    if state then AutoFarm.SetFarmMode("TWEEN"); Notify("AutoSteal","Tween Farm Started",2)
    else AutoFarm.SetFarmMode("NONE"); Notify("AutoSteal","Tween Farm Stopped",2) end
end)
AddToggle(autoFarmPage,"Auto Steal (Teleport)","Instantly warp to steal target eggs, return via teleports",h.autoFarmLoop==true,function(state)
    if state then AutoFarm.SetFarmMode("WARP"); Notify("AutoSteal","Teleport Farm Started",2)
    else AutoFarm.SetFarmMode("NONE"); Notify("AutoSteal","Teleport Farm Stopped",2) end
end)
AddToggle(autoFarmPage,"Auto Return","Return to Forest via teleport-hops (always on)",true,function(state)
    h.autoGlide=true
    Notify("AutoSteal","Auto Return всегда ON",2)
end)

AddMultiDropdown(eggFilterPage,"Target Zones",AutoFarm.ZoneList,h.selectedZones,function(map)
    h.selectedZones=map; AutoFarm.SaveEggSelectConfig(h)
end)
AddMultiDropdown(eggFilterPage,"Target Rarities",AutoFarm.RarityList,h.selectedRarities,function(map)
    h.selectedRarities=map; AutoFarm.SaveEggSelectConfig(h)
end)
AddToggle(eggFilterPage,"Always Steal Secret+ Eggs","Collect Secret, Eternal, Divine eggs from any zone automatically",h.alwaysCollectSecretPlus~=false,function(state)
    h.alwaysCollectSecretPlus=state; AutoFarm.SaveEggSelectConfig(h)
    Notify("EggFilter","Always Secret+ set to: "..tostring(state),2)
end)

AddSlider(movementPage,"Flight Cruise Speed",100,1000,h.glideSpeed or 600,function(val)
    h.glideSpeed=val; AutoFarm.SaveSpeed(val)
end)
AddToggle(movementPage,"Desync Godmode","Full immunity against map obstacles, traps, and hazards",h.godmode==true,function(state)
    AutoFarm.SetDesyncGodmode(state)
    Notify("Safety","Godmode set to: "..tostring(state),2)
end)
AddButton(movementPage,"AntiCheat Bypass","Removes Humanoid to bypass server-side anti-cheat checks",function()
    local ch=o.Character
    if ch then
        local hb=ch:FindFirstChildOfClass("Humanoid")
        local root=ch:FindFirstChild("HumanoidRootPart")
        if root then
            Camera.CameraType=Enum.CameraType.Custom
            Camera.CameraSubject=root
            if hb then hb:Destroy(); Notify("AntiCheat","Humanoid removed. Camera safe.",2.5) end
        end
    end
end)
AddButton(movementPage,"Get Unstuck / Reset","Instantly break free from seats, treadmills, or geometry",function()
    AutoFarm.ResetFarmStates()
    Notify("Safety","Reset executed!",2)
end)
AddButton(movementPage,"Unload Script","Terminate all farm loops and close interface",function()
    h.alive=false
    AutoFarm.SetFarmMode("NONE")
    AutoFarm.ResetFarmStates()
    if ScreenGui then ScreenGui:Destroy() end
end)

warn("[KerryHub] Loaded. Return: rise+10 → escape-jump → hops(high) → descend at Forest.")
