--[[ KerryHub - Fixed Build | AutoFarm + AntiCheat + Menu ]]
local e=game:GetService("Players")
local r=game:GetService("Workspace")
local y=game:GetService("RunService")
local u=game:GetService("TweenService")
local w=game:GetService("UserInputService")
local j=game:GetService("ReplicatedStorage")
local k=game:GetService("ProximityPromptService")
local a=game:GetService("HttpService")
local CoreGui=game:GetService("CoreGui")
local o=e.LocalPlayer
local Camera=r.CurrentCamera
local executorCheckCaller=typeof(checkcaller)=="function" and checkcaller or function() return false end
local safeNewCClosure=typeof(newcclosure)=="function" and newcclosure or function(fn) return fn end
local V=game:GetService("ProximityPromptService")
pcall(function() V.PromptButtonHoldBegan:Connect(function(e) pcall(function() if typeof(fireproximityprompt)=="function" then fireproximityprompt(e) end end) end) end)

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
    local UICorner=Instance.new("UICorner") UICorner.CornerRadius=UDim.new(0,10) UICorner.Parent=NotifFrame
    local UIStroke=Instance.new("UIStroke") UIStroke.Color=Color3.fromRGB(45,45,55) UIStroke.Transparency=1 UIStroke.Thickness=1 UIStroke.Parent=NotifFrame
    local AccentLine=Instance.new("Frame")
    AccentLine.Size=UDim2.new(0,3,1,-16) AccentLine.Position=UDim2.new(0,8,0,8)
    AccentLine.BackgroundColor3=Color3.fromRGB(120,80,255) AccentLine.BorderSizePixel=0 AccentLine.BackgroundTransparency=1
    local AccentCorner=Instance.new("UICorner") AccentCorner.CornerRadius=UDim.new(1,0) AccentCorner.Parent=AccentLine
    AccentLine.Parent=NotifFrame
    local TitleLabel=Instance.new("TextLabel")
    TitleLabel.Size=UDim2.new(1,-30,0,20) TitleLabel.Position=UDim2.new(0,22,0,10)
    TitleLabel.BackgroundTransparency=1 TitleLabel.Font=Enum.Font.GothamBold TitleLabel.Text=title
    TitleLabel.TextColor3=Color3.fromRGB(240,240,250) TitleLabel.TextSize=13
    TitleLabel.TextXAlignment=Enum.TextXAlignment.Left TitleLabel.TextTransparency=1 TitleLabel.Parent=NotifFrame
    local DescLabel=Instance.new("TextLabel")
    DescLabel.Size=UDim2.new(1,-30,0,20) DescLabel.Position=UDim2.new(0,22,0,30)
    DescLabel.BackgroundTransparency=1 DescLabel.Font=Enum.Font.Gotham DescLabel.Text=message
    DescLabel.TextColor3=Color3.fromRGB(160,160,175) DescLabel.TextSize=12
    DescLabel.TextXAlignment=Enum.TextXAlignment.Left DescLabel.TextTransparency=1 DescLabel.Parent=NotifFrame
    NotifFrame.Parent=NotificationContainer
    u:Create(NotifFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=0.05,Position=UDim2.new(0,0,0,0)}):Play()
    u:Create(UIStroke,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Transparency=0.4}):Play()
    u:Create(AccentLine,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=0}):Play()
    u:Create(TitleLabel,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{TextTransparency=0}):Play()
    u:Create(DescLabel,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{TextTransparency=0}):Play()
    task.delay(duration,function()
        if NotifFrame and NotifFrame.Parent then
            local tweenOut=u:Create(NotifFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{BackgroundTransparency=1,Position=UDim2.new(1,40,0,0)})
            u:Create(UIStroke,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Transparency=1}):Play()
            u:Create(AccentLine,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{BackgroundTransparency=1}):Play()
            u:Create(TitleLabel,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{TextTransparency=1}):Play()
            u:Create(DescLabel,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{TextTransparency=1}):Play()
            tweenOut:Play()
            tweenOut.Completed:Connect(function() NotifFrame:Destroy() end)
        end
    end)
end

local function HookPrompt(p) if p:IsA("ProximityPrompt") then p.HoldDuration=0 p.MaxActivationDistance=50 end end
for _,d in ipairs(r:GetDescendants()) do HookPrompt(d) end
table.insert(connections,r.DescendantAdded:Connect(HookPrompt))

local MainFrame=Instance.new("Frame")
MainFrame.Name="MainFrame" MainFrame.Size=UDim2.new(0,620,0,420)
MainFrame.Position=UDim2.new(0.5,-310,0.5,-210)
MainFrame.BackgroundColor3=Color3.fromRGB(14,14,18) MainFrame.BorderSizePixel=0
MainFrame.ClipsDescendants=true MainFrame.Parent=ScreenGui
local MainCorner=Instance.new("UICorner") MainCorner.CornerRadius=UDim.new(0,14) MainCorner.Parent=MainFrame
local MainStroke=Instance.new("UIStroke") MainStroke.Color=Color3.fromRGB(55,55,70) MainStroke.Transparency=0.2 MainStroke.Thickness=1.2 MainStroke.Parent=MainFrame

local TopBar=Instance.new("Frame")
TopBar.Name="TopBar" TopBar.Size=UDim2.new(1,0,0,55)
TopBar.BackgroundColor3=Color3.fromRGB(20,20,26) TopBar.BorderSizePixel=0 TopBar.Parent=MainFrame

local TitleLabel=Instance.new("TextLabel")
TitleLabel.Size=UDim2.new(0,200,0,22) TitleLabel.Position=UDim2.new(0,20,0,10)
TitleLabel.BackgroundTransparency=1 TitleLabel.Font=Enum.Font.GothamBold TitleLabel.Text="KerryHub"
TitleLabel.TextColor3=Color3.fromRGB(255,255,255) TitleLabel.TextSize=18
TitleLabel.TextXAlignment=Enum.TextXAlignment.Left TitleLabel.Parent=TopBar

local SubtitleLabel=Instance.new("TextLabel")
SubtitleLabel.Size=UDim2.new(0,300,0,15) SubtitleLabel.Position=UDim2.new(0,20,0,30)
SubtitleLabel.BackgroundTransparency=1 SubtitleLabel.Font=Enum.Font.GothamMedium
SubtitleLabel.Text="Steal An Egg - Advanced Farm" SubtitleLabel.TextColor3=Color3.fromRGB(150,150,175)
SubtitleLabel.TextSize=11 SubtitleLabel.TextXAlignment=Enum.TextXAlignment.Left SubtitleLabel.Parent=TopBar

local CloseButton=Instance.new("TextButton")
CloseButton.Size=UDim2.new(0,30,0,30) CloseButton.Position=UDim2.new(1,-40,0,12)
CloseButton.BackgroundColor3=Color3.fromRGB(32,32,42) CloseButton.AutoButtonColor=false
CloseButton.Font=Enum.Font.GothamBold CloseButton.Text="×" CloseButton.TextColor3=Color3.fromRGB(200,200,215)
CloseButton.TextSize=18 CloseButton.Parent=TopBar
local CloseCorner=Instance.new("UICorner") CloseCorner.CornerRadius=UDim.new(0,6) CloseCorner.Parent=CloseButton
CloseButton.MouseEnter:Connect(function() u:Create(CloseButton,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(220,60,60),TextColor3=Color3.fromRGB(255,255,255)}):Play() end)
CloseButton.MouseLeave:Connect(function() u:Create(CloseButton,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(32,32,42),TextColor3=Color3.fromRGB(200,200,215)}):Play() end)
CloseButton.MouseButton1Click:Connect(function()
    local tw=u:Create(MainFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{BackgroundTransparency=1})
    tw:Play() tw.Completed:Connect(function() ScreenGui:Destroy() end)
end)

local HeaderDivider=Instance.new("Frame")
HeaderDivider.Size=UDim2.new(1,0,0,1) HeaderDivider.Position=UDim2.new(0,0,0,55)
HeaderDivider.BackgroundColor3=Color3.fromRGB(40,40,52) HeaderDivider.BorderSizePixel=0 HeaderDivider.Parent=MainFrame

local Sidebar=Instance.new("Frame")
Sidebar.Size=UDim2.new(0,175,1,-56) Sidebar.Position=UDim2.new(0,0,0,56)
Sidebar.BackgroundColor3=Color3.fromRGB(18,18,24) Sidebar.BorderSizePixel=0 Sidebar.Parent=MainFrame
local SidebarLayout=Instance.new("UIListLayout")
SidebarLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
SidebarLayout.VerticalAlignment=Enum.VerticalAlignment.Top
SidebarLayout.SortOrder=Enum.SortOrder.LayoutOrder SidebarLayout.Padding=UDim.new(0,6)
SidebarLayout.Parent=Sidebar
local SidebarPadding=Instance.new("UIPadding")
SidebarPadding.PaddingTop=UDim.new(0,15) SidebarPadding.PaddingLeft=UDim.new(0,12)
SidebarPadding.PaddingRight=UDim.new(0,12) SidebarPadding.Parent=Sidebar

local SidebarDivider=Instance.new("Frame")
SidebarDivider.Size=UDim2.new(0,1,1,-56) SidebarDivider.Position=UDim2.new(0,175,0,56)
SidebarDivider.BackgroundColor3=Color3.fromRGB(40,40,52) SidebarDivider.BorderSizePixel=0 SidebarDivider.Parent=MainFrame

local ContentContainer=Instance.new("Frame")
ContentContainer.Size=UDim2.new(1,-176,1,-56) ContentContainer.Position=UDim2.new(0,176,0,56)
ContentContainer.BackgroundTransparency=1 ContentContainer.Parent=MainFrame

local dragging,dragInput,dragStart,startPos
table.insert(connections,TopBar.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true dragStart=input.Position startPos=MainFrame.Position
        local conn conn=input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false conn:Disconnect() end end)
    end
end))
table.insert(connections,TopBar.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then dragInput=input end
end))
table.insert(connections,w.InputChanged:Connect(function(input)
    if input==dragInput and dragging then
        local delta=input.Position-dragStart
        MainFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end))

local categories,currentCategory={},nil
local function CreateCategory(name,iconId)
    local B=Instance.new("TextButton")
    B.Name=name.."Button" B.Size=UDim2.new(1,0,0,38)
    B.BackgroundColor3=Color3.fromRGB(24,24,34) B.BackgroundTransparency=1 B.AutoButtonColor=false
    B.Font=Enum.Font.GothamMedium B.Text="" B.Parent=Sidebar
    local C=Instance.new("UICorner") C.CornerRadius=UDim.new(0,10) C.Parent=B
    local I=Instance.new("ImageLabel")
    I.Size=UDim2.new(0,18,0,18) I.Position=UDim2.new(0,12,0.5,-9)
    I.BackgroundTransparency=1 I.Image=iconId or "rbxassetid://10723346959"
    I.ImageColor3=Color3.fromRGB(150,150,165) I.Parent=B
    local L=Instance.new("TextLabel")
    L.Size=UDim2.new(1,-40,1,0) L.Position=UDim2.new(0,38,0,0)
    L.BackgroundTransparency=1 L.Font=Enum.Font.GothamMedium L.Text=name
    L.TextColor3=Color3.fromRGB(150,150,165) L.TextSize=13
    L.TextXAlignment=Enum.TextXAlignment.Left L.Parent=B
    local P=Instance.new("ScrollingFrame")
    P.Size=UDim2.new(1,0,1,0) P.BackgroundTransparency=1 P.BorderSizePixel=0
    P.CanvasSize=UDim2.new(0,0,0,0) P.AutomaticCanvasSize=Enum.AutomaticSize.Y
    P.ScrollBarThickness=3 P.ScrollBarImageColor3=Color3.fromRGB(60,60,75)
    P.Visible=false P.Parent=ContentContainer
    local PL=Instance.new("UIListLayout")
    PL.HorizontalAlignment=Enum.HorizontalAlignment.Center PL.VerticalAlignment=Enum.VerticalAlignment.Top
    PL.SortOrder=Enum.SortOrder.LayoutOrder PL.Padding=UDim.new(0,10) PL.Parent=P
    local PP=Instance.new("UIPadding")
    PP.PaddingTop=UDim.new(0,16) PP.PaddingBottom=UDim.new(0,16)
    PP.PaddingLeft=UDim.new(0,20) PP.PaddingRight=UDim.new(0,20) PP.Parent=P
    categories[name]={Button=B,Page=P,Icon=I,Label=L}
    table.insert(connections,B.MouseEnter:Connect(function() if currentCategory~=name then u:Create(B,TweenInfo.new(0.2),{BackgroundTransparency=0.5}):Play() end end))
    table.insert(connections,B.MouseLeave:Connect(function() if currentCategory~=name then u:Create(B,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play() end end))
    table.insert(connections,B.MouseButton1Click:Connect(function()
        for cn,cd in pairs(categories) do
            if cn==name then
                cd.Page.Visible=true
                u:Create(cd.Button,TweenInfo.new(0.2),{BackgroundTransparency=0}):Play()
                cd.Icon.ImageColor3=Color3.fromRGB(140,90,255) cd.Label.TextColor3=Color3.fromRGB(255,255,255)
                currentCategory=name
            else
                cd.Page.Visible=false
                u:Create(cd.Button,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play()
                cd.Icon.ImageColor3=Color3.fromRGB(150,150,165) cd.Label.TextColor3=Color3.fromRGB(150,150,165)
            end
        end
    end))
    if not currentCategory then
        currentCategory=name P.Visible=true B.BackgroundTransparency=0
        I.ImageColor3=Color3.fromRGB(140,90,255) L.TextColor3=Color3.fromRGB(255,255,255)
    end
    return P
end

local autoFarmPage=CreateCategory("Auto Farm","rbxassetid://10709769841")
local eggFilterPage=CreateCategory("Egg Selection","rbxassetid://10723407874")
local movementPage=CreateCategory("Movement","rbxassetid://10747373176")

local function AddToggle(parentPage,title,description,defaultState,callback)
    local toggled=defaultState or false
    local C=Instance.new("Frame")
    C.Size=UDim2.new(1,0,0,50) C.BackgroundColor3=Color3.fromRGB(24,24,32)
    C.BorderSizePixel=0 C.Parent=parentPage
    local Co=Instance.new("UICorner") Co.CornerRadius=UDim.new(0,12) Co.Parent=C
    local St=Instance.new("UIStroke") St.Color=Color3.fromRGB(42,42,55) St.Transparency=0.3 St.Thickness=1 St.Parent=C
    local TL=Instance.new("TextLabel")
    TL.Size=UDim2.new(1,-70,0,18) TL.Position=UDim2.new(0,15,0,8)
    TL.BackgroundTransparency=1 TL.Font=Enum.Font.GothamBold TL.Text=title
    TL.TextColor3=Color3.fromRGB(240,240,250) TL.TextSize=13
    TL.TextXAlignment=Enum.TextXAlignment.Left TL.Parent=C
    local DL=Instance.new("TextLabel")
    DL.Size=UDim2.new(1,-70,0,15) DL.Position=UDim2.new(0,15,0,26)
    DL.BackgroundTransparency=1 DL.Font=Enum.Font.Gotham DL.Text=description or ""
    DL.TextColor3=Color3.fromRGB(160,160,180) DL.TextSize=11
    DL.TextXAlignment=Enum.TextXAlignment.Left DL.Parent=C
    local SB=Instance.new("Frame")
    SB.Size=UDim2.new(0,42,0,22) SB.Position=UDim2.new(1,-54,0.5,-11)
    SB.BackgroundColor3=toggled and Color3.fromRGB(130,85,255) or Color3.fromRGB(40,40,52)
    SB.BorderSizePixel=0 SB.Parent=C
    local SC=Instance.new("UICorner") SC.CornerRadius=UDim.new(1,0) SC.Parent=SB
    local SK=Instance.new("Frame")
    SK.Size=UDim2.new(0,16,0,16)
    SK.Position=toggled and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
    SK.BackgroundColor3=Color3.fromRGB(255,255,255) SK.BorderSizePixel=0 SK.Parent=SB
    local KC=Instance.new("UICorner") KC.CornerRadius=UDim.new(1,0) KC.Parent=SK
    local CB=Instance.new("TextButton")
    CB.Size=UDim2.new(1,0,1,0) CB.BackgroundTransparency=1 CB.Text="" CB.Parent=C
    local function Upd(state,noCb)
        toggled=state
        local tc=toggled and Color3.fromRGB(130,85,255) or Color3.fromRGB(40,40,52)
        local tp=toggled and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
        u:Create(SB,TweenInfo.new(0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundColor3=tc}):Play()
        u:Create(SK,TweenInfo.new(0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=tp}):Play()
        if not noCb and callback then pcall(function() callback(toggled) end) end
    end
    table.insert(connections,CB.MouseButton1Click:Connect(function() Upd(not toggled) end))
    return {Set=function(s) Upd(s) end,Get=function() return toggled end}
end

local function AddSlider(parentPage,title,min,max,default,callback)
    local value=default or min
    local C=Instance.new("Frame")
    C.Size=UDim2.new(1,0,0,60) C.BackgroundColor3=Color3.fromRGB(24,24,32)
    C.BorderSizePixel=0 C.Parent=parentPage
    local Co=Instance.new("UICorner") Co.CornerRadius=UDim.new(0,12) Co.Parent=C
    local St=Instance.new("UIStroke") St.Color=Color3.fromRGB(42,42,55) St.Transparency=0.3 St.Thickness=1 St.Parent=C
    local TL=Instance.new("TextLabel")
    TL.Size=UDim2.new(1,-70,0,18) TL.Position=UDim2.new(0,15,0,10)
    TL.BackgroundTransparency=1 TL.Font=Enum.Font.GothamBold TL.Text=title
    TL.TextColor3=Color3.fromRGB(240,240,250) TL.TextSize=13
    TL.TextXAlignment=Enum.TextXAlignment.Left TL.Parent=C
    local VL=Instance.new("TextLabel")
    VL.Size=UDim2.new(0,50,0,18) VL.Position=UDim2.new(1,-65,0,10)
    VL.BackgroundTransparency=1 VL.Font=Enum.Font.GothamMedium VL.Text=tostring(value)
    VL.TextColor3=Color3.fromRGB(150,100,255) VL.TextSize=13
    VL.TextXAlignment=Enum.TextXAlignment.Right VL.Parent=C
    local TT=Instance.new("Frame")
    TT.Size=UDim2.new(1,-30,0,6) TT.Position=UDim2.new(0,15,0,40)
    TT.BackgroundColor3=Color3.fromRGB(40,40,52) TT.BorderSizePixel=0 TT.Parent=C
    local TC=Instance.new("UICorner") TC.CornerRadius=UDim.new(1,0) TC.Parent=TT
    local SF=Instance.new("Frame")
    SF.Size=UDim2.new(math.clamp((value-min)/(max-min),0,1),0,1,0)
    SF.BackgroundColor3=Color3.fromRGB(130,85,255) SF.BorderSizePixel=0 SF.Parent=TT
    local FC=Instance.new("UICorner") FC.CornerRadius=UDim.new(1,0) FC.Parent=SF
    local SK=Instance.new("Frame")
    SK.Size=UDim2.new(0,12,0,12) SK.AnchorPoint=Vector2.new(0.5,0.5)
    SK.Position=UDim2.new(SF.Size.X.Scale,0,0.5,0)
    SK.BackgroundColor3=Color3.fromRGB(255,255,255) SK.BorderSizePixel=0 SK.Parent=TT
    local KC=Instance.new("UICorner") KC.CornerRadius=UDim.new(1,0) KC.Parent=SK
    local sliding=false
    local function Upd(input)
        local posX=input.Position.X-TT.AbsolutePosition.X
        local pct=math.clamp(posX/TT.AbsoluteSize.X,0,1)
        value=math.floor(min+(max-min)*pct)
        SF.Size=UDim2.new(pct,0,1,0) SK.Position=UDim2.new(pct,0,0.5,0)
        VL.Text=tostring(value)
        if callback then pcall(function() callback(value) end) end
    end
    table.insert(connections,TT.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then sliding=true Upd(input) end
    end))
    table.insert(connections,w.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then Upd(input) end
    end))
    table.insert(connections,w.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then sliding=false end
    end))
    return {Set=function(val) value=math.clamp(val,min,max) local pct=(value-min)/(max-min)
        SF.Size=UDim2.new(pct,0,1,0) SK.Position=UDim2.new(pct,0,0.5,0) VL.Text=tostring(value)
        if callback then pcall(function() callback(value) end) end end, Get=function() return value end}
end

local function AddButton(parentPage,title,description,callback)
    local C=Instance.new("Frame")
    C.Size=UDim2.new(1,0,0,50) C.BackgroundColor3=Color3.fromRGB(24,24,32)
    C.BorderSizePixel=0 C.Parent=parentPage
    local Co=Instance.new("UICorner") Co.CornerRadius=UDim.new(0,12) Co.Parent=C
    local St=Instance.new("UIStroke") St.Color=Color3.fromRGB(42,42,55) St.Transparency=0.3 St.Thickness=1 St.Parent=C
    local TL=Instance.new("TextLabel")
    TL.Size=UDim2.new(1,-30,0,18) TL.Position=UDim2.new(0,15,0,8)
    TL.BackgroundTransparency=1 TL.Font=Enum.Font.GothamBold TL.Text=title
    TL.TextColor3=Color3.fromRGB(240,240,250) TL.TextSize=13
    TL.TextXAlignment=Enum.TextXAlignment.Left TL.Parent=C
    local DL=Instance.new("TextLabel")
    DL.Size=UDim2.new(1,-30,0,15) DL.Position=UDim2.new(0,15,0,26)
    DL.BackgroundTransparency=1 DL.Font=Enum.Font.Gotham DL.Text=description or ""
    DL.TextColor3=Color3.fromRGB(160,160,180) DL.TextSize=11
    DL.TextXAlignment=Enum.TextXAlignment.Left DL.Parent=C
    local CB=Instance.new("TextButton")
    CB.Size=UDim2.new(1,0,1,0) CB.BackgroundTransparency=1 CB.Text="" CB.Parent=C
    table.insert(connections,CB.MouseEnter:Connect(function() u:Create(C,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(34,34,46)}):Play() end))
    table.insert(connections,CB.MouseLeave:Connect(function() u:Create(C,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(24,24,32)}):Play() end))
    table.insert(connections,CB.MouseButton1Click:Connect(function() if callback then pcall(callback) end end))
end

local function AddMultiDropdown(parentPage,title,options,selectedMap,callback)
    selectedMap=selectedMap or {}
    local isExpanded=false
    local C=Instance.new("Frame")
    C.Size=UDim2.new(1,0,0,48) C.BackgroundColor3=Color3.fromRGB(24,24,32)
    C.BorderSizePixel=0 C.ClipsDescendants=true C.Parent=parentPage
    local Co=Instance.new("UICorner") Co.CornerRadius=UDim.new(0,12) Co.Parent=C
    local St=Instance.new("UIStroke") St.Color=Color3.fromRGB(42,42,55) St.Transparency=0.3 St.Thickness=1 St.Parent=C
    local TL=Instance.new("TextLabel")
    TL.Size=UDim2.new(0,150,0,48) TL.Position=UDim2.new(0,15,0,0)
    TL.BackgroundTransparency=1 TL.Font=Enum.Font.GothamBold TL.Text=title
    TL.TextColor3=Color3.fromRGB(240,240,250) TL.TextSize=13
    TL.TextXAlignment=Enum.TextXAlignment.Left TL.Parent=C
    local function CountSel()
        local c=0 for _,opt in ipairs(options) do if selectedMap[opt]==true then c=c+1 end end return c
    end
    local SB=Instance.new("TextButton")
    SB.Size=UDim2.new(0,160,0,28) SB.Position=UDim2.new(1,-175,0,10)
    SB.BackgroundColor3=Color3.fromRGB(28,28,38) SB.Font=Enum.Font.GothamMedium
    SB.Text=tostring(CountSel()).." / "..tostring(#options).."  ▼"
    SB.TextColor3=Color3.fromRGB(180,180,200) SB.TextSize=12 SB.Parent=C
    local BC=Instance.new("UICorner") BC.CornerRadius=UDim.new(0,6) BC.Parent=SB
    local LH=Instance.new("ScrollingFrame")
    LH.Size=UDim2.new(1,-30,0,0) LH.Position=UDim2.new(0,15,0,48)
    LH.BackgroundTransparency=1 LH.BorderSizePixel=0 LH.ScrollBarThickness=2
    LH.ScrollBarImageColor3=Color3.fromRGB(60,60,75)
    LH.AutomaticCanvasSize=Enum.AutomaticSize.Y LH.CanvasSize=UDim2.new(0,0,0,0) LH.Parent=C
    local LL=Instance.new("UIListLayout") LL.SortOrder=Enum.SortOrder.LayoutOrder LL.Padding=UDim.new(0,4) LL.Parent=LH
    local optionButtons={}
    local function UpdBtn(opt,btn)
        if selectedMap[opt]==true then btn.BackgroundColor3=Color3.fromRGB(120,80,255) btn.TextColor3=Color3.fromRGB(255,255,255)
        else btn.BackgroundColor3=Color3.fromRGB(24,24,32) btn.TextColor3=Color3.fromRGB(160,160,175) end
    end
    local function RefreshOpts(newOpts)
        for _,ch in ipairs(LH:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
        optionButtons={}
        for _,opt in ipairs(newOpts) do
            local OB=Instance.new("TextButton")
            OB.Size=UDim2.new(1,0,0,28) OB.BorderSizePixel=0 OB.Font=Enum.Font.Gotham
            OB.Text=tostring(opt) OB.TextSize=12 OB.Parent=LH
            local OC=Instance.new("UICorner") OC.CornerRadius=UDim.new(0,4) OC.Parent=OB
            optionButtons[opt]=OB UpdBtn(opt,OB)
            OB.MouseButton1Click:Connect(function()
                selectedMap[opt]=not (selectedMap[opt]==true)
                UpdBtn(opt,OB)
                SB.Text=tostring(CountSel()).." / "..tostring(#newOpts).."  ▼"
                if callback then pcall(function() callback(selectedMap) end) end
            end)
        end
    end
    RefreshOpts(options)
    SB.MouseButton1Click:Connect(function()
        isExpanded=not isExpanded
        if isExpanded then
            local lh=math.clamp(#options*32,32,140)
            LH.Size=UDim2.new(1,-30,0,lh)
            u:Create(C,TweenInfo.new(0.25),{Size=UDim2.new(1,0,0,52+lh)}):Play()
        else
            u:Create(C,TweenInfo.new(0.2),{Size=UDim2.new(1,0,0,48)}):Play()
            LH.Size=UDim2.new(1,-30,0,0)
        end
    end)
    return {Get=function() return selectedMap end}
end

-- ==========================================
-- AutoFarm Engine (fixed)
-- ==========================================
local AutoFarm=(function()
local e=game:GetService("Players")
local r=game:GetService("Workspace")
local y=game:GetService("RunService")
local u=game:GetService("TweenService")
local w=game:GetService("UserInputService")
local j=game:GetService("ReplicatedStorage")
local a=game:GetService("HttpService")
local o=e.LocalPlayer
local currentLang="EN"
local executorCheckCaller=typeof(checkcaller)=="function" and checkcaller or function() return false end
local safeNewCClosure=typeof(newcclosure)=="function" and newcclosure or function(fn) return fn end
local V=game:GetService("ProximityPromptService")
pcall(function() V.PromptButtonHoldBegan:Connect(function(e) pcall(function() if typeof(fireproximityprompt)=="function" then fireproximityprompt(e) end end) end) end)
local H=function(...) end
local t=function(...) end
local s=nil pcall(function() s=require((j:WaitForChild("Client",5)):WaitForChild("EggState",5)) end)
if not s then pcall(function() s=require(j.Client.EggState) end) end
local p=nil pcall(function() p=require(((j:WaitForChild("Shared",5)):WaitForChild("Util",5)):WaitForChild("AssetItems",5)) end)
if not p then pcall(function() p=require(j.Shared.Util.AssetItems) end) end
local B=nil pcall(function() B=require((j:WaitForChild("Shared",5)):WaitForChild("Remotes",5)) end)
if not B then pcall(function() B=require(j.Shared.Remotes) end) end

local function J(e,r)
    local y=(j:FindFirstChild("Packages") and j.Packages:FindFirstChild("Networking")) or j:FindFirstChild("Network") or j
    local u=y:FindFirstChild(e) or j:FindFirstChild(e)
    if u then return u end
    local w=y:FindFirstChild(e,true) or j:FindFirstChild(e,true)
    if w then return w end
    if r then
        local e=y:FindFirstChild(r) or j:FindFirstChild(r)
        if e then return e end
        local u=y:FindFirstChild(r,true) or j:FindFirstChild(r,true)
        if u then return u end
    end
    local k=string.match(e,"[^/]+$")
    if k then
        local e=y:FindFirstChild(k,true) or j:FindFirstChild(k,true)
        if e then return e end
    end
    return nil
end

local K=J("RF/EggWorld/AskPlaceEgg","AskPlaceEgg")
local c=J("RF/EggWorld/AskLiveSnapshot","AskLiveSnapshot")
local v=J("RF/Homestead/AskState","RF/Plots/AskState") or J("AskState")
local i=J("RF/EggWorld/AskFieldEggCarry","AskFieldEggCarry")
local R=J("RF/EggWorld/AskFieldEggSnapshot","AskFieldEggSnapshot") or J("Eggs: RequestAreaEggSnapshot","RequestAreaEggSnapshot")
local g=J("RF/EggWorld/AskHatch","AskHatch") or J("Eggs: RequestHatchEgg")
local Q=J("RF/EggWorld/AskFinishHatch","AskFinishHatch") or J("Eggs: RequestCompleteHatchEgg")
local P=J("RE/GuardPatrol/ForestStrike","ForestStrike") or (B and B.GuardPatrol and B.GuardPatrol.ForestStrike)
local N=J("SpeedTollOffer","RE/GuardPatrol/SpeedTollOffer") or (B and B.GuardPatrol and B.GuardPatrol.SpeedTollOffer)
local U=J("RF/Treadmill/AskDoff","AskDoff")
local l=J("RF/Treadmill/AskDon","AskDon") or J("RF/Treadmill/AskMount","AskMount")
local D=J("RF/Treadmill/AskTierRaise","Treadmills: RequestUpgrade","AskTierRaise")

local f={["Light Dark"]=1300,["LightDark"]=1300,["Titan Temple"]=1100,["Cherry Blossom"]=1000,["Cosmic"]=900,["Prehistoric"]=800,["Abyss Ocean"]=700,["Volcano"]=600,["Snow"]=500,["Jungle"]=400,["Desert"]=300,["Lake"]=200,["Forest"]=100}
local M={"Light Dark","Titan Temple","Cherry Blossom","Cosmic","Prehistoric","Abyss Ocean","Volcano","Snow","Jungle","Desert","Lake","Forest"}
local I={["Light Dark"]=420,["LightDark"]=420,["Titan Temple"]=380,["Cherry Blossom"]=330,["Cosmic"]=280,["Prehistoric"]=240,["Abyss Ocean"]=200,["Volcano"]=180,["Snow"]=160,["Jungle"]=140,["Desert"]=130,["Lake"]=125,["Forest"]=125}
local L=-360
local E=525
local b=620
local A=130
local S=CFrame.new(4773.7587890625,70.392112731934,-315.73501586914)
local Z="DiceHub_FlightSpeed.txt"
local z="DiceHub_EggSelectConfig.json"
local X={"Divine","Eternal","Secret","Cosmic","Mythic","Legendary","Epic","Rare","Uncommon","Common"}
local F={["Divine"]=6,["Eternal"]=5,["Secret"]=4,["Cosmic"]=3,["Mythic"]=2,["Legendary"]=1,["Epic"]=0.5,["Rare"]=0.3,["Uncommon"]=0.1,["Common"]=0}

local h
local function O()
    local e=600
    pcall(function()
        local r=false
        if isfile then r=isfile(Z) elseif readfile then local ok,_=pcall(readfile,Z) r=ok and true or false end
        if r and readfile then
            local rr=readfile(Z)
            local u=tonumber(rr)
            if u and u>=100 and u<=1000 then e=math.floor(u) end
        end
    end)
    return e
end
local function Y(e)
    pcall(function()
        if writefile then
            local y=math.clamp(math.floor(tonumber(e) or 600),100,1000)
            writefile(Z,tostring(y))
        end
    end)
end
local function T()
    local e=nil
    pcall(function()
        local r=false
        if isfile then r=isfile(z) elseif readfile then local ok,_=pcall(readfile,z) r=ok and true or false end
        if r and readfile and a then
            local rr=readfile(z)
            if rr and rr~="" then
                local u=a:JSONDecode(rr)
                if type(u)=="table" then e=u end
            end
        end
    end)
    local r={["Light Dark"]=true,["Titan Temple"]=true,["Cherry Blossom"]=true,["Cosmic"]=false,["Prehistoric"]=false,["Abyss Ocean"]=false,["Volcano"]=false,["Snow"]=false,["Jungle"]=false,["Desert"]=false,["Lake"]=false,["Forest"]=false}
    local y={["Divine"]=true,["Eternal"]=true,["Secret"]=true,["Cosmic"]=true,["Mythic"]=true,["Legendary"]=false,["Epic"]=false,["Rare"]=false,["Uncommon"]=false,["Common"]=false}
    if type(e)~="table" then
        e={selectedZones=r,selectedRarities=y,alwaysCollectSecretPlus=true,minRarityTier=2,autoTreadmill=true,autoUpgradeTreadmill=true,hideNotEnoughMoney=true,language="EN"}
    else
        if type(e.selectedZones)~="table" then e.selectedZones=r end
        if type(e.selectedRarities)~="table" then e.selectedRarities=y
        else for _,z in ipairs(X) do if e.selectedRarities[z]==nil then e.selectedRarities[z]=(y[z]==true) end end end
        if e.alwaysCollectSecretPlus==nil then e.alwaysCollectSecretPlus=true end
        if e.minRarityTier==nil then e.minRarityTier=2 end
        if e.autoTreadmill==nil then e.autoTreadmill=true end
        if e.autoUpgradeTreadmill==nil then e.autoUpgradeTreadmill=true end
        if e.hideNotEnoughMoney==nil then e.hideNotEnoughMoney=true end
        if e.language and (e.language=="EN" or e.language=="TH") then currentLang=e.language end
    end
    return e
end
local function x()
    pcall(function()
        if writefile and a and h then
            local r={selectedZones=h.selectedZones or {},selectedRarities=h.selectedRarities or {},alwaysCollectSecretPlus=(h.alwaysCollectSecretPlus~=false),minRarityTier=h.minRarityTier or 2,autoTreadmill=(h.autoTreadmill==true),autoUpgradeTreadmill=(h.autoUpgradeTreadmill==true),hideNotEnoughMoney=(h.hideNotEnoughMoney==true),language=currentLang or "EN"}
            writefile(z,a:JSONEncode(r))
        end
    end)
end

local W=T()
h={godmode=true,autoGlide=true,autoHatch=true,autoPlaceEvery5=false,batchStealCount=0,isBatchPlacing=false,isHatching=false,autoFarmLoop=false,pureTweenFarm=false,glidingToTarget=false,securingEgg=false,glideSpeed=O(),selectedZones=W.selectedZones,selectedRarities=W.selectedRarities,alwaysCollectSecretPlus=W.alwaysCollectSecretPlus,minRarityTier=W.minRarityTier,autoTreadmill=(W.autoTreadmill~=false),autoUpgradeTreadmill=(W.autoUpgradeTreadmill~=false),hideNotEnoughMoney=true,onTreadmill=false,lastTreadmillMount=0,laneZ=-360,swapped=false,teleporting=false,isReturning=false,delivering=false,holdingEggForGuard=false,currentTargetModel=nil,targetPosition=nil,stateTime=os.clock(),statusText="Ready",alive=true,plot=nil,pen=nil,origin=nil,tread=nil}

local m,e4,r4,y4,u4,w4,j4,k4,a4,o4,V4,H4,t4,s4,p4,B4,J4,K4,c4,v4,i4,R4,g4,Q4,P4,N4,U4,l4,D4,C4,q4,n4,f4,M4,I4,L4,E4,b4,A4,S4,Z4,z4,d4
local X4={}
local G4=0
local F4=nil
local h4
local O4=0
local Y4="NONE"
local T4

pcall(function()
    local l=game:GetService("Lighting")
    l:GetPropertyChangedSignal("ClockTime"):Connect(function() X4={} G4=0 end)
end)
pcall(function()
    local function chk(inst)
        if inst:IsA("RemoteEvent") then
            local nm=string.lower(inst.Name)
            if string.find(nm,"reset") or string.find(nm,"night") or string.find(nm,"spawn") or string.find(nm,"countdown") then
                pcall(function() inst.OnClientEvent:Connect(function() X4={} G4=0 end) end)
            end
        end
    end
    for _,d in ipairs(j:GetDescendants()) do chk(d) end
    j.DescendantAdded:Connect(chk)
end)

m=function(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local nm=string.lower(tool.Name)
    if string.find(nm,"sword") or string.find(nm,"radar") or string.find(nm,"basket") or string.find(nm,"punch") then return false end
    if tool:GetAttribute("EggUid") or tool:GetAttribute("UID") or string.find(nm,"egg") or tool:GetAttribute("Category") or tool:GetAttribute("ItemType")=="Egg" then return true end
    return false
end

e4=function()
    local ch=o.Character
    if ch then
        for _,tl in ipairs(ch:GetChildren()) do
            if m(tl) then
                local uid=tl:GetAttribute("UID") or tl:GetAttribute("EggUid")
                return tl,uid or tl.Name
            end
        end
    end
    return nil,nil
end
r4=function()
    local bp=o:FindFirstChild("Backpack")
    if bp then
        for _,tl in ipairs(bp:GetChildren()) do
            if m(tl) then
                local uid=tl:GetAttribute("UID") or tl:GetAttribute("EggUid")
                return tl,uid or tl.Name
            end
        end
    end
    return nil,nil
end
y4=function()
    local cnt=0
    local bp=o:FindFirstChild("Backpack")
    if bp then for _,tl in ipairs(bp:GetChildren()) do if m(tl) then cnt=cnt+1 end end end
    local ch=o.Character
    if ch then for _,tl in ipairs(ch:GetChildren()) do if m(tl) then cnt=cnt+1 end end end
    return cnt
end
u4=function(force)
    if not force and not (h.pureTweenFarm or h.autoFarmLoop or h.teleporting) then return end
    local ch=o.Character
    local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    local bp=o:FindFirstChild("Backpack")
    if hu then pcall(function() hu:UnequipTools() end) end
    if ch and bp then
        for _,tl in ipairs(ch:GetChildren()) do
            if tl:IsA("Tool") then pcall(function() tl.Parent=bp end) end
        end
    end
end
w4=function(uid)
    if (h.pureTweenFarm or h.autoFarmLoop) and not h.holdingEggForGuard then
        if e4() then pcall(u4) end
        return false
    end
    local tool,currUid=e4()
    if tool then
        if uid then if currUid==uid or not currUid then return true end
        else return true end
    end
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    if hrp and hrp.Position.X<=E+15 then return false end
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
    local tool,currUid=e4()
    if tool then if not uid or currUid==uid or not currUid then return true end end
    local bp=o:FindFirstChild("Backpack")
    if bp then
        for _,tl in ipairs(bp:GetChildren()) do
            if m(tl) then
                local u2=tl:GetAttribute("UID") or tl:GetAttribute("EggUid")
                if not uid or u2==uid or tl.Name==tostring(uid) then return true end
            end
        end
    end
    if uid and s and s.ReadFieldEggs then
        local ok,data=pcall(s.ReadFieldEggs)
        if ok and data and data.Records then
            for _,rec in ipairs(data.Records) do
                if rec.Uid==uid and (rec.State=="Carried" or rec.State==2) then
                    if (rec.CarrierUserId or rec.Carrier)==o.UserId then return true end
                end
            end
        end
    end
    return false
end

local m4=false
local function ek()
    if m4 then return end
    local rf=R or j:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot",true) or j:FindFirstChild("AskFieldEggSnapshot",true) or j:FindFirstChild("Eggs: RequestAreaEggSnapshot",true)
    if not rf or not rf:IsA("RemoteFunction") then return end
    m4=true
    task.spawn(function()
        local ok,data=pcall(function() return rf:InvokeServer() end)
        if ok and type(data)=="table" then
            local list={}
            local recs=data.Records or data
            if type(recs)=="table" then
                for kk,vv in pairs(recs) do
                    if type(vv)=="table" then
                        if not vv.Uid and type(kk)=="string" then vv.Uid=kk end
                        table.insert(list,vv)
                    end
                end
            end
            if #list>0 then F4=list G4=os.clock() end
        end
        m4=false
    end)
end
task.spawn(function()
    while true do task.wait(1.5) pcall(ek) end
end)

h4=function(forceRefresh)
    local now=os.clock()
    if forceRefresh or (now-G4>=1.5) or not F4 then ek() end
    local u1=((F4 and #F4>0)) and F4 or nil
    local w1=nil
    if s and s.ReadFieldEggs then
        local ok,data=pcall(s.ReadFieldEggs)
        if ok and type(data)=="table" then
            local list={}
            local recs=data.Records or data
            if type(recs)=="table" then
                for kk,vv in pairs(recs) do
                    if type(vv)=="table" then
                        if not vv.Uid and type(kk)=="string" then vv.Uid=kk end
                        table.insert(list,vv)
                    end
                end
            end
            if #list>0 then w1=list end
        end
    end
    local out={}
    local seen={}
    if u1 then for _,r1 in ipairs(u1) do if r1.Uid then seen[r1.Uid]=true table.insert(out,r1) end end end
    if w1 then for _,r1 in ipairs(w1) do if r1.Uid and not seen[r1.Uid] then seen[r1.Uid]=true table.insert(out,r1) end end end
    local slots=r:FindFirstChild("AreaEggSlotsClient")
    if slots then
        for _,mdl in ipairs(slots:GetChildren()) do
            local un=mdl.Name
            if un and un~="" then
                local piv=mdl:GetPivot()
                if piv.Position.X>=530 and not string.find(tostring(un),"FirstArea") then
                    if not seen[un] then
                        seen[un]=true
                        table.insert(out,{Uid=un,AssetCategory=mdl:GetAttribute("Category") or mdl:GetAttribute("AssetCategory") or mdl.Name,AreaId=mdl:GetAttribute("AreaId") or mdl:GetAttribute("Area"),Rarity=mdl:GetAttribute("Rarity") or mdl:GetAttribute("RarityTier"),Rank=mdl:GetAttribute("RarityRank") or mdl:GetAttribute("Rank"),Income=mdl:GetAttribute("Income") or mdl:GetAttribute("EarningRate"),BoundsCFrame=piv,BottomCFrame=piv,CFrame=piv,State="Slot",AssetScale=mdl:GetAttribute("Scale") or mdl:GetAttribute("AssetScale") or 1,Mutations=mdl:GetAttribute("Mutations") or mdl:GetAttribute("Mutation"),PhysicalModel=mdl})
                    else
                        for _,o1 in ipairs(out) do
                            if o1.Uid==un then
                                o1.PhysicalModel=mdl
                                if not o1.BoundsCFrame then o1.BoundsCFrame=piv end
                                if not o1.AreaId or o1.AreaId=="" or o1.AreaId=="Unknown" then o1.AreaId=mdl:GetAttribute("AreaId") or mdl:GetAttribute("Area") end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    return out
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
        for _,mdl in ipairs(slots:GetChildren()) do
            if mdl.Name==tostring(uid) or mdl:GetAttribute("UID")==uid or mdl:GetAttribute("Uid")==uid then return true,"Available" end
        end
    end
    return true,"Unchecked"
end
a4=function()
    local _,uid=e4()
    if not uid then local _,u2=r4() uid=u2 end
    if not uid then return false end
    if s and s.ReadFieldEggs then
        local ok,data=pcall(s.ReadFieldEggs)
        if ok and data and data.Records then
            for _,rec in ipairs(data.Records) do
                if rec.Uid==uid then
                    local ar=tostring(rec.AreaId or "")
                    if ar=="Lake" or string.find(string.lower(ar),"lake") then return true end
                end
            end
        end
    end
    if string.find(string.lower(tostring(uid)),"lake") then return true end
    return false
end
o4=function()
    local _,uid=e4()
    if not uid then local _,u2=r4() uid=u2 end
    if not uid then return h.glideSpeed or 350 end
    if s and s.ReadFieldEggs then
        local ok,data=pcall(s.ReadFieldEggs)
        if ok and data and data.Records then
            for _,rec in ipairs(data.Records) do
                if rec.Uid==uid and rec.AreaId then return I[rec.AreaId] or h.glideSpeed or 350 end
            end
        end
    end
    return h.glideSpeed or 350
end

V4=function(pos,dur)
    dur=dur or 8
    local part=Instance.new("Part")
    part.Name="SafetyFloorPad_AntiVoid" part.Size=Vector3.new(28,1.5,28)
    part.Position=pos-Vector3.new(0,3.2,0) part.Anchored=true part.Transparency=1
    part.CanCollide=true part.Parent=r
    task.delay(dur,function() pcall(function() part:Destroy() end) end)
    return part
end

H4=function(eggUid)
    if P and eggUid then
        pcall(function()
            local ch=o.Character
            local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
            local cfr=hrp and (hrp.CFrame*CFrame.new(0,0,-3)) or CFrame.new()
            if P:IsA("RemoteFunction") then P:InvokeServer({EggUid=eggUid,GuardCFrame=cfr})
            else P:FireServer({EggUid=eggUid,GuardCFrame=cfr}) end
        end)
    end
end

if typeof(hookmetamethod)=="function" and not _G._DesyncAntiRagdollHooked then
    _G._DesyncAntiRagdollHooked=true
    local e
    e=hookmetamethod(game,"__newindex",safeNewCClosure(function(inst,prop,val,...)
        if not executorCheckCaller() and typeof(inst)=="Instance" then
            if inst:IsA("Motor6D") and prop=="Enabled" and val==false then return nil end
            if inst:IsA("Humanoid") then
                if prop=="PlatformStand" and val==true then return nil end
                if prop=="Sit" and val==true and (h.pureTweenFarm or h.autoFarmLoop or h.isReturning or h.glidingToTarget) then return nil end
            end
        end
        return e(inst,prop,val)
    end))
end

S4=function(ch)
    ch=ch or o.Character
    if not ch then return end
    local hrp=ch:FindFirstChild("HumanoidRootPart")
    local torso=ch:FindFirstChild("Torso") or ch:FindFirstChild("UpperTorso") or hrp
    if not torso then return end
    for _,d in ipairs(ch:GetDescendants()) do
        if d:IsA("BallSocketConstraint") or d:IsA("HingeConstraint") or d:IsA("NoCollisionConstraint") then pcall(function() d:Destroy() end) end
    end
    for _,d in ipairs(ch:GetDescendants()) do
        if d:IsA("Motor6D") and d.Part0 and d.Part1 then
            d.Enabled=true
            local wn="RigidJointWeld_"..d.Name
            if not d.Part1:FindFirstChild(wn) then
                local wc=Instance.new("WeldConstraint") wc.Name=wn wc.Part0=d.Part0 wc.Part1=d.Part1 wc.Parent=d.Part1
            end
        end
    end
end
Z4=function(ch)
    if h and h.onTreadmill then return end
    ch=ch or o.Character
    if not ch then return end
    local hu=ch:FindFirstChildOfClass("Humanoid")
    if hu then
        hu:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
        hu:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
        hu:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
        hu:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
        hu:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
        if hu.PlatformStand then hu.PlatformStand=false end
        if hu.Sit then hu.Sit=false end
    end
    for _,d in ipairs(ch:GetDescendants()) do
        if d:IsA("LocalScript") and (string.find(string.lower(d.Name),"ragdoll") or string.find(string.lower(d.Name),"fall")) then d.Disabled=true end
    end
    S4(ch)
end
z4=function(ch)
    if not ch then return end
    Z4(ch)
    for _,d in ipairs(ch:GetDescendants()) do
        if d:IsA("Motor6D") then
            d:GetPropertyChangedSignal("Enabled"):Connect(function() if not d.Enabled then d.Enabled=true end end)
        end
    end
    ch.DescendantAdded:Connect(function(d)
        if d:IsA("BallSocketConstraint") or d:IsA("HingeConstraint") or d:IsA("NoCollisionConstraint") then
            task.defer(function() pcall(function() d:Destroy() end) Z4(ch) end)
        elseif d:IsA("LocalScript") and (string.find(string.lower(d.Name),"ragdoll") or string.find(string.lower(d.Name),"fall")) then d.Disabled=true end
    end)
    ch.ChildAdded:Connect(function(d)
        if d:IsA("Tool") and (h.pureTweenFarm or h.autoFarmLoop) and not h.holdingEggForGuard then
            task.defer(function() u4() end)
        end
    end)
end

C4=function()
    if h then h.onTreadmill=false end
    local ch=o.Character
    local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    if U then task.spawn(function() pcall(function() U:InvokeServer() end) end) end
    if hu then
        pcall(function()
            for _,tr in ipairs(hu:GetPlayingAnimationTracks()) do
                local aid=tr.Animation and tr.Animation.AnimationId or ""
                if string.find(aid,"10921259953") or string.find(string.lower(tr.Name),"treadmill") or string.find(string.lower(tr.Name),"run") then tr:Stop(0) end
            end
            hu.PlatformStand=false hu.Sit=false
            hu:SetStateEnabled(Enum.HumanoidStateType.Running,true)
            hu:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
            hu:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    local pg=o:FindFirstChild("PlayerGui")
    if pg then local sg=pg:FindFirstChild("SpeedGainAnimation") if sg then pcall(function() sg:Destroy() end) end end
    if hrp then hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero end
    Z4(ch)
end

local rk=0
local yk=false
E4=function()
    local pg=o:FindFirstChild("PlayerGui")
    if not pg then return false end
    local found=false
    pcall(function()
        for _,sg in ipairs(pg:GetChildren()) do
            if sg:IsA("ScreenGui") and sg.Enabled then
                for _,btn in ipairs(sg:GetDescendants()) do
                    if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and btn.Visible then
                        local txt=string.lower((btn:IsA("TextButton") and btn.Text) or btn.Name or "")
                        if string.find(txt,"get out") or string.find(txt,"treadmill") or string.find(txt,"doff") or string.find(txt,"leave") or string.find(txt,"exit") then
                            if typeof(firesignal)=="function" and btn.Activated then pcall(firesignal,btn.Activated)
                            elseif typeof(firesignal)=="function" and btn.MouseButton1Click then pcall(firesignal,btn.MouseButton1Click)
                            elseif typeof(getconnections)=="function" then
                                local cs=getconnections(btn.MouseButton1Click) or getconnections(btn.Activated) or {}
                                for _,c1 in ipairs(cs) do pcall(function() c1:Fire() end) break end
                            end
                            found=true break
                        end
                    end
                end
                if found then break end
            end
        end
    end)
    return found
end
L4=function()
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local tw=(typeof(I4)=="function") and I4() or nil
    if tw then
        local tp=tw.Position+Vector3.new(0,1.8,0)
        if (hrp.Position-tp).Magnitude>6 then if h then h.onTreadmill=false end return false end
    else
        if hrp.Position.X>535 then if h then h.onTreadmill=false end return false end
    end
    if h and h.onTreadmill then return true end
    local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    if hu then
        for _,tr in ipairs(hu:GetPlayingAnimationTracks()) do
            local aid=tr.Animation and tr.Animation.AnimationId or ""
            local nm=string.lower(tr.Name or "")
            if string.find(aid,"10921259953") or string.find(nm,"treadmill") or string.find(nm,"run") then return true end
        end
    end
    local pg=o:FindFirstChild("PlayerGui")
    if pg and pg:FindFirstChild("SpeedGainAnimation") then return true end
    return false
end
M4=function()
    if yk then return end
    if os.clock()-rk<0.8 then if h then h.onTreadmill=false end return end
    yk=true rk=os.clock()
    if h then h.onTreadmill=false end
    E4()
    if U then pcall(function() U:InvokeServer() end) end
    local ch=o.Character
    local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    if hu then
        pcall(function()
            for _,tr in ipairs(hu:GetPlayingAnimationTracks()) do
                local aid=tr.Animation and tr.Animation.AnimationId or ""
                local nm=string.lower(tr.Name or "")
                if string.find(aid,"10921259953") or string.find(nm,"treadmill") or string.find(nm,"run") then tr:Stop(0) end
            end
            hu.PlatformStand=false hu.Sit=false
            hu:SetStateEnabled(Enum.HumanoidStateType.Running,true)
            hu:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
            hu:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    local pg=o:FindFirstChild("PlayerGui")
    if pg then local sg=pg:FindFirstChild("SpeedGainAnimation") if sg then pcall(function() sg:Destroy() end) end end
    if hrp then hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero end
    Z4(ch) task.wait(0.15) yk=false
end
q4=M4

n4=function()
    pcall(function()
        local plots=r:FindFirstChild("Plots")
        if plots then
            local myPlot=h and h.plot
            if not myPlot and t4 then myPlot=select(1,t4()) end
            for _,pl in ipairs(plots:GetChildren()) do
                local isMine=(myPlot~=nil and pl==myPlot)
                local tb=pl:FindFirstChild("TreadmillBottom")
                if tb and tb:IsA("BasePart") then
                    if isMine and h and h.autoTreadmill then tb.CanTouch=true tb.CanCollide=true
                    else tb.CanTouch=false tb.CanCollide=false end
                end
                local tu=pl:FindFirstChild("TreadmillUpgrade")
                if tu then
                    for _,p1 in ipairs(tu:GetDescendants()) do
                        if p1:IsA("BasePart") then
                            if isMine and h and h.autoTreadmill then p1.CanTouch=true
                            else p1.CanTouch=false p1.CanCollide=false end
                        end
                    end
                end
            end
        end
    end)
end
n4()
r.DescendantAdded:Connect(function(inst)
    pcall(function()
        local isTB=(inst.Name=="TreadmillBottom" and inst:IsA("BasePart"))
        local isTU=(inst.Name=="TreadmillUpgrade" and inst:IsA("Model"))
        if isTB or isTU then
            local myPlot=h and h.plot
            if not myPlot and t4 then myPlot=select(1,t4()) end
            local isMine=myPlot and inst:IsDescendantOf(myPlot)
            if isMine and h and h.autoTreadmill then
                if isTB then inst.CanTouch=true inst.CanCollide=true
                else for _,p1 in ipairs(inst:GetDescendants()) do if p1:IsA("BasePart") then p1.CanTouch=true end end end
            else
                if isTB then inst.CanTouch=false inst.CanCollide=false
                else for _,p1 in ipairs(inst:GetDescendants()) do if p1:IsA("BasePart") then p1.CanTouch=false p1.CanCollide=false end end end
            end
        end
    end)
end)

D4=function()
    h.onTreadmill=false h.teleporting=false h.glidingToTarget=false h.securingEgg=false
    h.isReturning=false h.delivering=false h.holdingEggForGuard=false
    h.currentTargetModel=nil h.targetPosition=nil h.stateTime=os.clock()
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    if hrp then pcall(function() hrp.Anchored=false hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero end) end
    pcall(function() if C4 then C4() end end)
    pcall(function() if Z4 and ch then Z4(ch) end end)
    pcall(function() if u4 and (h.pureTweenFarm or h.autoFarmLoop) then u4() end end)
end

d4=function(model,pos)
    if model then
        for _,d in ipairs(model:GetDescendants()) do
            if d:IsA("ProximityPrompt") then
                pcall(function()
                    d.RequiresLineOfSight=false d.HoldDuration=0
                    if typeof(fireproximityprompt)=="function" then fireproximityprompt(d,0) fireproximityprompt(d) end
                end)
            end
        end
    end
    local slots=r:FindFirstChild("AreaEggSlotsClient")
    if slots and pos then
        for _,mdl in ipairs(slots:GetChildren()) do
            local bp=mdl:FindFirstChildWhichIsA("BasePart") or mdl.PrimaryPart
            if bp and (bp.Position-pos).Magnitude<=18 then
                for _,d in ipairs(mdl:GetDescendants()) do
                    if d:IsA("ProximityPrompt") then
                        pcall(function()
                            d.RequiresLineOfSight=false d.HoldDuration=0
                            if typeof(fireproximityprompt)=="function" then fireproximityprompt(d,0) fireproximityprompt(d) end
                        end)
                    end
                end
            end
        end
    end
end

b4=function(en)
    h.godmode=en
    local ch=o.Character
    if not ch then return end
    local hu=ch:FindFirstChildOfClass("Humanoid")
    if hu then
        hu:SetStateEnabled(Enum.HumanoidStateType.Dead,not en)
        if en and hu.Health<100 then hu.Health=100 end
    end
    for _,p1 in ipairs(ch:GetDescendants()) do
        if p1:IsA("BasePart") and en then p1.CanTouch=false p1.CanCollide=false end
    end
    Z4(ch)
end
A4=function()
    local ch=o.Character
    local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    if not ch or not hu then return false end
    pcall(function()
        hu.BreakJointsOnDeath=false
        local nh=hu:Clone() nh.Parent=ch hu:Destroy()
        if not nh:FindFirstChildOfClass("Animator") then Instance.new("Animator").Parent=nh end
        r.CurrentCamera.CameraSubject=nh
        local an=ch:FindFirstChild("Animate")
        if an and an:IsA("LocalScript") then
            an.Disabled=true
            task.defer(function() task.wait(0.05) an.Disabled=false end)
        end
        nh:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
        nh:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
        nh:SetStateEnabled(Enum.HumanoidStateType.Running,true)
        nh:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
        nh.JumpPower=math.max(50,nh.JumpPower)
        nh.JumpHeight=math.max(7.2,nh.JumpHeight)
        nh:ChangeState(Enum.HumanoidStateType.Running)
    end)
    h.swapped=true
    if h.godmode then b4(true) end
    z4(ch)
    return true
end

t4=function()
    if h.plot and h.plot.Parent and h.pen and h.origin and h.plotVerified then return h.plot,h.pen,h.origin end
    local plots=r:FindFirstChild("Plots")
    if not plots then return nil,nil,nil end
    local uid=o.UserId
    local nm=o.Name
    local dn=o.DisplayName
    local found=nil
    local verified=false
    if v then
        local ok,data=pcall(function() return v:InvokeServer() end)
        if ok and type(data)=="table" and type(data.OwnersBySlot)=="table" then
            for slot,owner in pairs(data.OwnersBySlot) do
                if owner==uid or tostring(owner)==tostring(uid) or owner==nm then
                    found=plots:FindFirstChild(tostring(slot))
                    if found then verified=true break end
                end
            end
        end
    end
    if not found and c then
        local ok,data=pcall(function() return c:InvokeServer() end)
        if ok and type(data)=="table" then
            for kk,vv in pairs(data) do
                if type(vv)=="table" and (vv.OwnerUserId==uid or tostring(vv.OwnerUserId)==tostring(uid)) then
                    local slot=vv.Slot or kk
                    found=plots:FindFirstChild(tostring(slot)) or plots:FindFirstChild(tostring(kk))
                    if found then verified=true break end
                end
            end
        end
    end
    if not found then
        for _,pl in ipairs(plots:GetChildren()) do
            local at=pl:GetAttribute("Owner") or pl:GetAttribute("OwnerUserId") or pl:GetAttribute("UserId") or pl:GetAttribute("OwnerId") or pl:GetAttribute("Player")
            if at and (at==uid or tostring(at)==tostring(uid) or at==nm or tostring(at)==nm or at==dn) then found=pl verified=true break end
            for _,cn in ipairs({"Owner","OwnerUserId","OwnerId","UserId","Player","PlayerName"}) do
                local cv=pl:FindFirstChild(cn)
                if cv and (cv.Value==uid or tostring(cv.Value)==tostring(uid) or cv.Value==nm or cv.Value==dn) then found=pl verified=true break end
            end
            if found then break end
        end
    end
    if not found then
        for _,pl in ipairs(plots:GetChildren()) do
            for _,d in ipairs(pl:GetDescendants()) do
                if d:IsA("TextLabel") and d.Text~="" then
                    local tx=string.lower(d.Text)
                    if string.find(tx,string.lower(nm),1,true) or (dn and string.find(tx,string.lower(dn),1,true)) then found=pl verified=true break end
                end
            end
            if found then break end
        end
    end
    if not found then
        local ch=o.Character
        local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Position.X<=E+30 then
            local best=nil
            local bestD=999999
            for _,pl in ipairs(plots:GetChildren()) do
                local cp=pl:FindFirstChild("CenterPoint") or pl.PrimaryPart or pl:FindFirstChildWhichIsA("BasePart")
                if cp then
                    local dd=(hrp.Position-cp.Position).Magnitude
                    if dd<bestD then bestD=dd best=pl end
                end
            end
            if best and bestD<160 then found=best end
        end
    end
    if not found then found=plots:FindFirstChild("2") or plots:FindFirstChild("1") or (plots:GetChildren())[1] end
    if not found then return nil,nil,nil end
    h.plot=found h.plotVerified=verified h.origin=found:FindFirstChild("CenterPoint")
    local tu=found:FindFirstChild("ToUpdate")
    h.pen=(tu and tu:FindFirstChild("PetArea")) or found:FindFirstChild("PetArea")
    h.tread=found:FindFirstChild("TreadmillBottom")
    if not h.pen and tu then
        for _,p1 in ipairs(tu:GetChildren()) do
            if p1:IsA("BasePart") and string.find(string.lower(p1.Name),"pet") then h.pen=p1 break end
        end
    end
    if not h.origin then h.origin=found:FindFirstChild("CenterPoint") or h.pen or found.PrimaryPart end
    if not h.pen then h.pen=h.origin end
    return h.plot,h.pen,h.origin
end
s4=function()
    local _,pen,ori=t4()
    if pen then return pen.Position+Vector3.new(0,3.5,0) end
    if ori then return ori.Position+Vector3.new(0,3.5,0) end
    return Vector3.new(464.7,71.7,-304)
end
p4=function(existing)
    local _,pen,_=t4()
    if not pen then return nil end
    local sz=pen.Size
    local mX=math.max(4,sz.X/2-5)
    local mZ=math.max(4,sz.Z/2-5)
    for _=1,60 do
        local ox=math.random(-math.floor(mX),math.floor(mX))
        local oz=math.random(-math.floor(mZ),math.floor(mZ))
        local cf=pen.CFrame*CFrame.new(ox,sz.Y/2+1,oz)
        local ok=true
        for _,p1 in ipairs(existing) do
            if (p1-cf.Position).Magnitude<5.5 then ok=false break end
        end
        if ok then return cf end
    end
    return pen.CFrame*CFrame.new(math.random(-8,8),sz.Y/2+1,math.random(-8,8))
end

B4=function()
    local _,_,ori=t4()
    if not ori or not K then return 0 end
    local cnt=0
    local used={}
    if c then
        local ok,data=pcall(function() return c:InvokeServer() end)
        if ok and type(data)=="table" then
            local mine={}
            for _,pv in pairs(data) do
                if type(pv)=="table" and pv.OwnerUserId==o.UserId then
                    for kk,vv in pairs(pv.Records or {}) do mine[kk]=vv end
                end
            end
            for uid,rec in pairs(mine) do
                if rec.Placement and rec.Placement.LocalCFrame then
                    used[#used+1]=(ori.CFrame*rec.Placement.LocalCFrame).Position
                else
                    local spot=p4(used)
                    if spot then
                        local lc=ori.CFrame:ToObjectSpace(spot)
                        local ok2,res=pcall(function() return K:InvokeServer({Uid=uid,LocalCFrame=lc}) end)
                        if ok2 and res then cnt=cnt+1 used[#used+1]=spot.Position end
                    end
                end
            end
        end
    end
    local tools={}
    local ch=o.Character
    if ch then for _,tl in ipairs(ch:GetChildren()) do if m(tl) then table.insert(tools,tl) end end end
    local bp=o:FindFirstChild("Backpack")
    if bp then for _,tl in ipairs(bp:GetChildren()) do if m(tl) then table.insert(tools,tl) end end end
    for _,tl in ipairs(tools) do
        if not h.alive then break end
        local uid=tl:GetAttribute("UID") or tl:GetAttribute("EggUid") or tl.Name
        local spot=p4(used)
        if spot then
            local lc=ori.CFrame:ToObjectSpace(spot)
            local ok,res=pcall(function() return K:InvokeServer({Uid=uid,LocalCFrame=lc}) end)
            if ok and res~=false then cnt=cnt+1 used[#used+1]=spot.Position end
            task.wait(0.04)
        end
    end
    return cnt
end

J4=function(silent)
    if (not silent and not h.autoHatch) or not g or not Q or not c then return 0 end
    if h.isHatching then return 0 end
    h.isHatching=true
    local ok,data=pcall(function() return c:InvokeServer() end)
    if not ok or type(data)~="table" then h.isHatching=false return 0 end
    local mine={}
    for _,pv in pairs(data) do
        if type(pv)=="table" and pv.OwnerUserId==o.UserId then
            for kk,vv in pairs(pv.Records or {}) do mine[kk]=vv end
        end
    end
    local ready={}
    local srvTime=r:GetServerTimeNow()
    for uid,rec in pairs(mine) do
        if not h.alive then break end
        if rec.Placement then
            local rdy=nil
            if s then
                local fn=s.IsReadyToHatch or s.IsLocalEggReady
                if fn then
                    local ok2,res=pcall(fn,uid)
                    if ok2 and type(res)=="boolean" then rdy=res end
                end
            end
            if rdy==nil then
                local pt=rec.Placement.PlacedAt or rec.Placement.Time or 0
                local gt=30
                if p and p.Assets and p.Assets[rec.AssetCategory] then
                    local ent=p.Assets[rec.AssetCategory]
                    gt=(ent and ent.Egg and ent.Egg.GrowthTime) or 30
                end
                local need=gt/math.max(0.01,rec.GrowthSpeedMultiplier or 1)
                rdy=(srvTime-pt)>=need
            end
            if rdy then table.insert(ready,{uid=uid,category=rec.AssetCategory or "Egg"}) end
        end
    end
    if #ready==0 then h.isHatching=false return 0 end
    local hatched=0
    for _,ent in ipairs(ready) do
        task.spawn(function()
            local ok2,res=pcall(function()
                if g:IsA("RemoteFunction") then return g:InvokeServer(ent.uid)
                else g:FireServer(ent.uid) return true end
            end)
            if ok2 and res~=false then
                task.wait(0.9)
                local ok3,res3=pcall(function()
                    if Q:IsA("RemoteFunction") then return Q:InvokeServer(ent.uid)
                    else Q:FireServer(ent.uid) return true end
                end)
                if ok3 and res3~=false then
                    hatched=hatched+1
                    h.hatched=((h.hatched or 0))+1
                end
            end
        end)
        task.wait(0.04)
    end
    task.wait(0.95)
    h.isHatching=false
    return hatched
end

i4=function()
    local list={}
    local db=r:FindFirstChild("__DEBRIS")
    if db then
        for _,c1 in ipairs(db:GetChildren()) do
            local hb=c1:FindFirstChild("Hitbox")
            if hb and hb:IsA("BasePart") then table.insert(list,hb)
            elseif c1:IsA("BasePart") and string.find(string.lower(c1.Name),"hitbox") then table.insert(list,c1) end
        end
    end
    local ba=r:FindFirstChild("BossArenaTeleport")
    if ba then
        local hb=ba:FindFirstChild("Hitbox") or ba:FindFirstChildWhichIsA("BasePart") or (ba:IsA("BasePart") and ba)
        if hb and hb:IsA("BasePart") then table.insert(list,hb) end
    end
    return list
end

g4=function(speed,session,cont)
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    if not hrp then return false end
    if hu then hu.AutoRotate=false end
    local base=s4()
    speed=math.max(100,speed or h.glideSpeed or 600)
    local laneZ=h.laneZ or L
    h.isReturning=true h.stateTime=os.clock()
    V4(base,20)
    hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
    local zoneSpd=o4()
    local top=math.max(speed,zoneSpd)
    local deadline=os.clock()+25
    while h.alive and h.isReturning and os.clock()<deadline do
        if session and O4~=session then if hu then hu.AutoRotate=true end h.isReturning=false return false end
        if not cont and not h.pureTweenFarm and not h.autoFarmLoop then if hu then hu.AutoRotate=true end h.isReturning=false return false end
        local pp=hrp.Position
        local dist=(base-pp).Magnitude
        if (pp.X<=base.X+3 and math.abs(pp.Z-base.Z)<=8) or dist<=6 then break end
        local dt=y.Heartbeat:Wait()
        pp=hrp.Position
        local spd=top
        if pp.X<=b and pp.X>E then spd=A+((top-A)*math.clamp((pp.X-E)/(b-E),0,1))
        elseif pp.X<=E then spd=A end
        local tz=base.Z
        if pp.X>540 then tz=laneZ end
        local sx=math.sign(base.X-pp.X)*math.min(math.abs(base.X-pp.X),spd*dt)
        local sy=math.sign(base.Y-pp.Y)*math.min(math.abs(base.Y-pp.Y),(spd*dt)*0.5)
        local sz=math.sign(tz-pp.Z)*math.min(math.abs(tz-pp.Z),spd*dt)
        local nx=pp.X+sx
        local ny=pp.Y+sy
        local nz=pp.Z+sz
        if pp.X>E then
            for _,hb in ipairs(i4()) do
                if (Vector3.new(nx,ny,nz)-hb.Position).Magnitude<22 then
                    local raise=hb.Position.Y+16
                    if ny<raise then ny=math.min(ny+(spd*dt)*1.5,raise) end
                    break
                end
            end
        end
        local tgt=Vector3.new(nx,ny,nz)
        local dir=((tgt-pp)).Magnitude>0.05 and ((tgt-pp)).Unit or hrp.CFrame.LookVector
        hrp.CFrame=CFrame.lookAt(tgt,tgt+dir)
        hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
    end
    hrp.CFrame=CFrame.new(base)
    hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
    if hu then hu.AutoRotate=true end
    u4() h.isReturning=false h.delivering=false
    return true
end

v4=function(speed,session,cont)
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    if not hrp or not hu then return end
    local base=s4()
    if (hrp.Position-base).Magnitude>8 then g4(speed or h.glideSpeed or 600,session,true) end
    V4(base,15)
    hrp.CFrame=CFrame.new(base)
    hrp.AssemblyLinearVelocity=Vector3.zero
    local deadline=os.clock()+3
    while y4()>0 and os.clock()<deadline and h.alive do B4() task.wait(0.06) end
    J4(true) u4()
    h.isReturning=false h.delivering=false h.currentTargetModel=nil h.targetPosition=nil
end

local uk=5
K4=function(mode)
    if h.isBatchPlacing then return end
    h.isBatchPlacing=true
    local sess=O4
    h.pureTweenFarm=(mode=="TWEEN")
    h.autoFarmLoop=(mode=="WARP")
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    local base=s4()
    local dd=hrp and (hrp.Position-base).Magnitude or 999
    if dd>8 then g4(h.glideSpeed or 600,sess,true) end
    if hrp then
        V4(base,20)
        hrp.CFrame=CFrame.new(base)
        hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
        if hu then hu.AutoRotate=true end
    end
    task.spawn(function() pcall(B4) pcall(J4,true) end)
    u4()
    h.isReturning=false h.delivering=false h.glidingToTarget=false h.securingEgg=false h.teleporting=false
    h.currentTargetModel=nil h.targetPosition=nil
    for i=5,1,-1 do if not h.alive then break end task.wait(1) end
    h.isBatchPlacing=false
    if h.alive and O4==sess then
        if mode=="TWEEN" then h.pureTweenFarm=true h.autoFarmLoop=false
        elseif mode=="WARP" then h.autoFarmLoop=true h.pureTweenFarm=false end
        Y4=mode
    end
end
c4=function(mode)
    if not h.autoPlaceEvery5 then return false end
    h.batchStealCount=((h.batchStealCount or 0))+1
    if h.batchStealCount>=uk then
        h.batchStealCount=0
        task.spawn(function() K4(mode) end)
        return true
    end
    return false
end

local function wk(targetCF,speed,uid,session)
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    if not hrp then return false end
    if hu then hu.AutoRotate=false end
    speed=math.max(60,speed or h.glideSpeed or 350)
    local tp=targetCF.Position
    V4(tp,14)
    pcall(function() o:RequestStreamAroundAsync(tp) end)
    hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
    local laneZ=h.laneZ or L
    h.glidingToTarget=true h.stateTime=os.clock()
    local lastCheck=0
    local deadline=os.clock()+15
    while h.alive and h.glidingToTarget and os.clock()<deadline do
        if session and O4~=session then if hu then hu.AutoRotate=true end h.glidingToTarget=false return false end
        if not h.pureTweenFarm and not h.autoFarmLoop and not h.teleporting then if hu then hu.AutoRotate=true end h.glidingToTarget=false return false end
        local pp=hrp.Position
        local dist=(tp-pp).Magnitude
        local hDist=((Vector2.new(pp.X,pp.Z)-Vector2.new(tp.X,tp.Z))).Magnitude
        local vDist=math.abs(pp.Y-tp.Y)
        if dist<=6 or (hDist<=3.5 and vDist<=6) then break end
        local dt=y.Heartbeat:Wait()
        pp=hrp.Position
        if uid and os.clock()-lastCheck>0.5 then
            lastCheck=os.clock()
            local ok,reason=k4(uid)
            if not ok and reason=="CarriedByOther" then if hu then hu.AutoRotate=true end h.glidingToTarget=false return false end
        end
        local tz=tp.Z
        if math.abs(pp.X-tp.X)>40 then tz=laneZ end
        local nx=pp.X+math.sign(tp.X-pp.X)*math.min(math.abs(tp.X-pp.X),speed*dt)
        local yFac=(hDist<=25) and 1.2 or 0.5
        local ny=pp.Y+math.sign(tp.Y-pp.Y)*math.min(math.abs(tp.Y-pp.Y),(speed*dt)*yFac)
        local nz=pp.Z+math.sign(tz-pp.Z)*math.min(math.abs(tz-pp.Z),speed*dt)
        if hDist>25 then
            for _,hb in ipairs(i4()) do
                if (Vector3.new(nx,ny,nz)-hb.Position).Magnitude<22 then
                    local raise=hb.Position.Y+16
                    if ny<raise then ny=math.min(ny+(speed*dt)*1.5,raise) end
                    break
                end
            end
        end
        local tgt=Vector3.new(nx,ny,nz)
        local dir=((tgt-pp)).Magnitude>0.05 and ((tgt-pp)).Unit or hrp.CFrame.LookVector
        hrp.CFrame=CFrame.lookAt(tgt,tgt+dir)
        hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
    end
    hrp.CFrame=targetCF*CFrame.new(0,0.4,0)
    hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
    if hu then hu.AutoRotate=true end
    h.glidingToTarget=false
    return true
end

R4=function(targetCF,speed,uid,session)
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    if hrp then
        local xNow=hrp.Position.X
        local xTgt=targetCF.Position.X
        if xNow<=535 and xTgt>510 then
            local wp=CFrame.new(500,70,-364)
            if (hrp.Position-wp.Position).Magnitude>5 then
                if not wk(wp,speed,uid,session) then return false end
                task.wait(0.04)
            end
        end
    end
    return wk(targetCF,speed,uid,session)
end

Q4=function(speed,session)
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    if not hrp then return false end
    if hu then hu.AutoRotate=false end
    local laneZ=h.laneZ or L
    local base=Vector3.new(E-10,70,laneZ)
    speed=math.max(100,speed or h.glideSpeed or 350)
    h.isReturning=true h.stateTime=os.clock()
    V4(Vector3.new(E,70,laneZ),20)
    pcall(u4)
    hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
    local zoneSpd=o4()
    local top=math.max(speed,zoneSpd)
    local deadline=os.clock()+15
    while h.alive and h.isReturning and os.clock()<deadline do
        if session and O4~=session then if hu then hu.AutoRotate=true end h.isReturning=false return false end
        if not h.pureTweenFarm and not h.autoFarmLoop then if hu then hu.AutoRotate=true end h.isReturning=false return false end
        local pp=hrp.Position
        if pp.X<=E+10 or (base-pp).Magnitude<=6 then u4() break end
        local dt=y.Heartbeat:Wait()
        pp=hrp.Position
        local spd=top
        if pp.X<=b and pp.X>E then spd=A+((top-A)*math.clamp((pp.X-E)/(b-E),0,1))
        elseif pp.X<=E then spd=A end
        local nx=pp.X+math.sign(base.X-pp.X)*math.min(math.abs(base.X-pp.X),spd*dt)
        local ny=pp.Y+math.sign(base.Y-pp.Y)*math.min(math.abs(base.Y-pp.Y),(spd*dt)*0.5)
        local nz=pp.Z+math.sign(laneZ-pp.Z)*math.min(math.abs(laneZ-pp.Z),spd*dt)
        for _,hb in ipairs(i4()) do
            if (Vector3.new(nx,ny,nz)-hb.Position).Magnitude<22 then
                local raise=hb.Position.Y+16
                if ny<raise then ny=math.min(ny+(spd*dt)*1.5,raise) end
                break
            end
        end
        local tgt=Vector3.new(nx,ny,nz)
        local dir=((tgt-pp)).Magnitude>0.05 and ((tgt-pp)).Unit or hrp.CFrame.LookVector
        hrp.CFrame=CFrame.lookAt(tgt,tgt+dir)
        hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
    end
    hrp.CFrame=CFrame.new(E,math.max(68,hrp.Position.Y),laneZ)
    hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
    if hu then hu.AutoRotate=true end
    u4() h.isReturning=false h.delivering=false
    if h then h.onTreadmill=false end
    return true
end

local function jk(plot)
    if not plot then return nil end
    local tb=plot:FindFirstChild("TreadmillBottom")
    if tb and tb:IsA("BasePart") then return tb end
    tb=plot:FindFirstChild("TreadmillBottom",true)
    if tb and tb:IsA("BasePart") then return tb end
    local tu=plot:FindFirstChild("TreadmillUpgrade",true)
    if tu then
        for _,nm in ipairs({"TreadmillBottom","Belt","RunArea","Run","Platform","Pad","Floor","Base"}) do
            local cc=tu:FindFirstChild(nm,true)
            if cc and cc:IsA("BasePart") then return cc end
        end
        local lowest=nil
        local lowY=999999
        for _,p1 in ipairs(tu:GetDescendants()) do
            if p1:IsA("BasePart") and p1.Size.X>=1.2 and p1.Size.Z>=1.2 then
                if p1.Position.Y<lowY then lowY=p1.Position.Y lowest=p1 end
            end
        end
        if lowest then return lowest end
        if tu.PrimaryPart then return tu.PrimaryPart end
        local anyp=tu:FindFirstChildWhichIsA("BasePart",true)
        if anyp then return anyp end
    end
    for _,d in ipairs(plot:GetDescendants()) do
        if d:IsA("BasePart") and string.find(string.lower(d.Name),"treadmill") then return d end
    end
    return nil
end
I4=function()
    local plot=t4()
    if h.tread and h.tread.Parent then return h.tread end
    local result=nil
    if plot then result=jk(plot) end
    if not result then
        local plots=r:FindFirstChild("Plots")
        if plots then
            local nm=string.lower(o.Name)
            local dn=o.DisplayName and string.lower(o.DisplayName)
            for _,pl in ipairs(plots:GetChildren()) do
                local tw=jk(pl)
                if tw then
                    local matched=false
                    for _,d in ipairs(pl:GetDescendants()) do
                        if d:IsA("TextLabel") and d.Text~="" then
                            local tx=string.lower(d.Text)
                            if string.find(tx,nm,1,true) or (dn and string.find(tx,dn,1,true)) then matched=true break end
                        end
                    end
                    if matched then h.plot=pl h.plotVerified=true result=tw break end
                end
            end
            if not result and plot then result=jk(plot) end
        end
    end
    h.tread=result
    return result
end

f4=function(session)
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    if not hrp or not hu then return false end
    if hu.PlatformStand then hu.PlatformStand=false end
    if hu.Sit then hu.Sit=false end
    hu:ChangeState(Enum.HumanoidStateType.Running)
    local plot=t4()
    local tw=I4()
    if not tw then return false end
    pcall(function()
        for _,p1 in ipairs(ch:GetChildren()) do
            if p1:IsA("BasePart") and p1.Name~="HumanoidRootPart" then p1.CanCollide=false end
        end
    end)
    pcall(function()
        tw.CanTouch=true tw.CanCollide=true
        local tu=plot and plot:FindFirstChild("TreadmillUpgrade",true)
        if tu then for _,p1 in ipairs(tu:GetDescendants()) do if p1:IsA("BasePart") then p1.CanTouch=true p1.CanCollide=true end end end
        if tw.Parent and tw.Parent:IsA("Model") then
            for _,p1 in ipairs(tw.Parent:GetDescendants()) do if p1:IsA("BasePart") then p1.CanTouch=true p1.CanCollide=true end end
        end
    end)
    local pad=tw.Position+Vector3.new(0,1.8,0)
    if hrp.Position.X>535 then
        Q4(h.glideSpeed,session)
        if session and O4~=session then return false end
        if hrp.Position.X>535 then
            if hrp.Position.X<=560 then hrp.CFrame=CFrame.new(E,70,h.laneZ or L)
            else return false end
        end
    end
    if session and O4~=session then return false end
    local hDist=((Vector2.new(hrp.Position.X,hrp.Position.Z)-Vector2.new(pad.X,pad.Z))).Magnitude
    if hDist>4 then
        local spd=math.max(250,h.glideSpeed or 400)
        local t0=os.clock()
        while h.alive and ((Vector2.new(hrp.Position.X,hrp.Position.Z)-Vector2.new(pad.X,pad.Z))).Magnitude>4 and os.clock()-t0<4 do
            if session and O4~=session then return false end
            local dt=y.Heartbeat:Wait()
            local pp=hrp.Position
            local tgt=Vector3.new(pad.X,70,pad.Z)
            local diff=tgt-pp
            local nxt=pp+diff.Unit*math.min(diff.Magnitude,spd*dt)
            hrp.CFrame=CFrame.lookAt(nxt,nxt+((diff.Magnitude>0.05 and diff.Unit or hrp.CFrame.LookVector)))
            hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
            if hu.PlatformStand then hu.PlatformStand=false end
            if hu.Sit then hu.Sit=false end
            hu:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
    if session and O4~=session then return false end
    local t0=os.clock()
    while h.alive and math.abs(hrp.Position.Y-pad.Y)>2 and os.clock()-t0<1.5 do
        if session and O4~=session then return false end
        local dt=y.Heartbeat:Wait()
        local pp=hrp.Position
        local diff=pad-pp
        local nxt=pp+diff.Unit*math.min(diff.Magnitude,150*dt)
        hrp.CFrame=CFrame.new(nxt)
        hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
    end
    hrp.CFrame=CFrame.new(pad)
    hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
    if (hrp.Position-pad).Magnitude<=6 then
        pcall(function()
            if typeof(firetouchinterest)=="function" then firetouchinterest(hrp,tw,0) task.wait(0.02) firetouchinterest(hrp,tw,1) end
        end)
        pcall(function()
            for _,d in ipairs(tw:GetDescendants()) do
                if d:IsA("ProximityPrompt") and d.Enabled and typeof(fireproximityprompt)=="function" then fireproximityprompt(d) end
            end
            if tw.Parent then
                for _,d in ipairs(tw.Parent:GetDescendants()) do
                    if d:IsA("ProximityPrompt") and d.Enabled and typeof(fireproximityprompt)=="function" then fireproximityprompt(d) end
                end
            end
        end)
        if l then pcall(function() l:InvokeServer() end) end
        h.onTreadmill=true h.lastTreadmillMount=os.clock()
        return true
    else h.onTreadmill=false return false end
end

local function kk()
    if not h or not h.hideNotEnoughMoney then return end
    local pg=o:FindFirstChild("PlayerGui")
    if not pg then return end
    pcall(function()
        for _,d in ipairs(pg:GetDescendants()) do
            if d:IsA("TextLabel") and d.Visible then
                local tx=string.lower(tostring(d.Text or ""))
                if tx:find("not enough money") or tx:find("not enough cash") or (tx:find("not enough") and (tx:find("money") or tx:find("cash") or tx:find("coin") or tx:find("fund"))) then
                    d.Visible=false d.TextTransparency=1 d.TextStrokeTransparency=1
                    local par=d.Parent
                    if par and (par:IsA("Frame") or par:IsA("CanvasGroup")) and #par:GetChildren()<=3 then par.Visible=false end
                end
            end
        end
    end)
end
local function ak()
    local pg=o:FindFirstChild("PlayerGui")
    if not pg then return end
    local function check(lbl)
        if lbl:IsA("TextLabel") then
            local function run()
                if not h or not h.hideNotEnoughMoney then return end
                local tx=string.lower(tostring(lbl.Text or ""))
                if tx:find("not enough money") or tx:find("not enough cash") or (tx:find("not enough") and (tx:find("money") or tx:find("cash") or tx:find("coin") or tx:find("fund"))) then
                    lbl.Visible=false lbl.TextTransparency=1 lbl.TextStrokeTransparency=1
                    local par=lbl.Parent
                    if par and (par:IsA("Frame") or par:IsA("CanvasGroup")) and #par:GetChildren()<=3 then par.Visible=false end
                end
            end
            run()
            lbl:GetPropertyChangedSignal("Text"):Connect(run)
            lbl:GetPropertyChangedSignal("Visible"):Connect(function() if lbl.Visible then run() end end)
        end
    end
    pcall(function()
        for _,d in ipairs(pg:GetDescendants()) do task.spawn(check,d) end
        pg.DescendantAdded:Connect(check)
    end)
    task.spawn(function()
        while h and h.alive do
            if h.hideNotEnoughMoney then kk() end
            task.wait(0.25)
        end
    end)
end
task.spawn(ak)

local function ok(n)
    if not n then return 0 end
    local s1=(((tostring(n)):gsub("[$,]","")):gsub("%s+","")):lower()
    local numS=s1:match("[%d%.]+")
    if not numS then return 0 end
    local num=tonumber(numS)
    if not num then return 0 end
    if s1:find("sp") then return num*1e24
    elseif s1:find("sx") then return num*1e21
    elseif s1:find("qi") then return num*1e18
    elseif s1:find("qa") or s1:find("q") then return num*1e15
    elseif s1:find("t") then return num*1e12
    elseif s1:find("b") then return num*1e9
    elseif s1:find("m") then return num*1e6
    elseif s1:find("k") then return num*1e3 end
    return num
end
local function Vk()
    local ls=o:FindFirstChild("leaderstats")
    if ls then
        for _,nm in ipairs({"Money","Cash","Coins","Currency"}) do
            local v=ls:FindFirstChild(nm)
            if v then
                local n=tonumber(v.Value) or ok(v.Value)
                if n and n>0 then return n end
            end
        end
    end
    local pg=o:FindFirstChild("PlayerGui")
    if pg then
        local hud=pg:FindFirstChild("HUD") or pg:FindFirstChild("GameHUD") or pg:FindFirstChild("MainHUD") or pg:FindFirstChild("Main")
        if hud then
            for _,d in ipairs(hud:GetDescendants()) do
                if d:IsA("TextLabel") and d.Visible then
                    local ln=string.lower(d.Name)
                    if ln=="money" or ln=="cash" or ln=="coins" or ln=="currency" or ln=="value" then
                        local n=ok(d.Text)
                        if n and n>0 then return n end
                    end
                end
            end
        end
    end
    return 0
end
local function Hk()
    local plot=h.plot or (t4 and t4())
    if not plot then return nil end
    local tu=plot:FindFirstChild("TreadmillUpgrade",true)
    if not tu then return nil end
    local best=nil
    for _,d in ipairs(tu:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextButton") then
            local txt=tostring(d.Text or "")
            local m1=txt:match("%$([%d%.,]+%s*[kKmMbBtTqQ]?[aA]?)")
            if m1 then
                local n=ok(m1)
                if n and n>0 and (not best or n>best) then best=n end
            end
        end
    end
    return best
end
local tk=0
local sk=10
local function pk()
    if not h.autoUpgradeTreadmill then return end
    if os.clock()-tk<sk then return end
    local plot=h.plot or (t4 and t4())
    if not plot then return end
    local tu=plot:FindFirstChild("TreadmillUpgrade",true)
    if not tu then return end
    local money=Vk()
    local cost=Hk()
    if cost and cost>0 and money<cost then return end
    tk=os.clock()
    if D then pcall(function() D:InvokeServer() end) end
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    pcall(function()
        for _,d in ipairs(tu:GetDescendants()) do
            if d:IsA("ProximityPrompt") and d.Enabled and typeof(fireproximityprompt)=="function" then fireproximityprompt(d,0) fireproximityprompt(d) end
            if d:IsA("GuiButton") and d.Visible then
                local txt=string.lower((d:IsA("TextButton") and d.Text) or d.Name)
                if not string.find(txt,"robux") and not string.find(txt,"r%$") and (string.find(txt,"%$") or string.find(txt,"upgrade") or string.find(txt,"cash") or (d.BackgroundColor3 and d.BackgroundColor3.G>d.BackgroundColor3.R)) then
                    if typeof(firesignal)=="function" and d.Activated then firesignal(d.Activated)
                    elseif typeof(firesignal)=="function" and d.MouseButton1Click then firesignal(d.MouseButton1Click) end
                end
            end
            if d:IsA("BasePart") and string.find(d.Name,"Pad") and hrp then
                if (hrp.Position-d.Position).Magnitude<10 and typeof(firetouchinterest)=="function" then
                    firetouchinterest(hrp,d,0) task.wait(0.02) firetouchinterest(hrp,d,1)
                end
            end
        end
    end)
end

P4=function()
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local list={}
    local slots=r:FindFirstChild("AreaEggSlotsClient")
    local h4list=h4(false)
    if h4list and #h4list>0 then
        for _,rec in ipairs(h4list) do
            local isFree=(rec.State=="Slot" or rec.State=="Dropped" or rec.State==1)
            local isLake=(rec.AreaId=="Lake") or string.find(string.lower(tostring(rec.AreaId)),"lake") or string.find(string.lower(tostring(rec.Uid)),"lake")
            local cd=X4[rec.Uid] and os.clock()<X4[rec.Uid]
            if isFree and isLake and rec.BoundsCFrame and not cd then
                local pp=rec.BoundsCFrame.Position
                table.insert(list,{Uid=rec.Uid,Model=nil,CFrame=rec.BoundsCFrame,Position=pp,Distance=(hrp.Position-pp).Magnitude,Area="Lake"})
            end
        end
    end
    if #list==0 and h4list and #h4list>0 then
        for _,rec in ipairs(h4list) do
            local isFree=(rec.State=="Slot" or rec.State=="Dropped" or rec.State==1)
            local pp=rec.BoundsCFrame and rec.BoundsCFrame.Position
            local inRange=pp and (pp.X>=545 and pp.X<850)
            local cd=X4[rec.Uid] and os.clock()<X4[rec.Uid]
            if isFree and inRange and not cd then
                table.insert(list,{Uid=rec.Uid,Model=nil,CFrame=rec.BoundsCFrame,Position=pp,Distance=(hrp.Position-pp).Magnitude,Area=rec.AreaId or "Field"})
            end
        end
    end
    if #list==0 then return nil end
    table.sort(list,function(a,b) return a.Distance<b.Distance end)
    local best=list[1]
    if best and slots then
        for _,mdl in ipairs(slots:GetChildren()) do
            local mp=mdl:FindFirstChildWhichIsA("BasePart") or mdl.PrimaryPart
            if mp and (mp.Position-best.Position).Magnitude<=8 then best.Model=mdl break end
        end
    end
    return best
end

local Qk=nil
local Pk=nil
local Nk=350
local function Uk()
    local objs=r:FindFirstChild("__OBJECTS") or r:FindFirstChild("Objects")
    local areas=objs and (objs:FindFirstChild("Areas") or objs:FindFirstChild("Area"))
    local guards=areas and (areas:FindFirstChild("GuardAreas") or areas:FindFirstChild("Guards"))
    if guards then
        local ld=guards:FindFirstChild("Light Dark") or guards:FindFirstChild("LightDark") or guards:FindFirstChild("Light_Dark") or guards:FindFirstChild("Light-Dark")
        if ld then return ld end
        for _,c1 in ipairs(guards:GetChildren()) do
            local nm=string.lower(c1.Name)
            if string.find(nm,"light") and string.find(nm,"dark") then return c1 end
        end
    end
    if areas then
        local ld=areas:FindFirstChild("Light Dark") or areas:FindFirstChild("LightDark") or areas:FindFirstChild("Light_Dark")
        if ld then return ld end
        for _,c1 in ipairs(areas:GetChildren()) do
            local nm=string.lower(c1.Name)
            if string.find(nm,"light") and string.find(nm,"dark") then return c1 end
        end
    end
    for _,top in ipairs(r:GetChildren()) do
        if top.Name=="__OBJECTS" or top.Name=="Objects" or top.Name=="Areas" or top.Name=="Map" then
            for _,d in ipairs(top:GetDescendants()) do
                local nm=string.lower(d.Name)
                if nm=="light dark" or nm=="lightdark" or (string.find(nm,"light") and string.find(nm,"dark")) then
                    if d:IsA("BasePart") or d:IsA("Model") or d:IsA("Folder") then return d end
                end
            end
        end
    end
    return nil
end
local function lk(pos)
    if not pos then return false end
    if Qk then
        if ((Vector3.new(pos.X,0,pos.Z)-Vector3.new(Qk.X,0,Qk.Z))).Magnitude<=Nk then return true end
    end
    local root=Uk()
    if not root then return pos.X>=5200 end
    local inZone=false
    pcall(function()
        local cf,sz=nil,nil
        if root:IsA("BasePart") then cf=root.CFrame sz=root.Size
        elseif root:IsA("Model") then cf,sz=root:GetBoundingBox()
        else
            local minP,maxP=nil,nil
            for _,c1 in ipairs(root:GetChildren()) do
                if c1:IsA("BasePart") then
                    local half=c1.Size/2
                    local mn=c1.Position-half
                    local mx=c1.Position+half
                    if not minP then minP=mn maxP=mx
                    else minP=Vector3.new(math.min(minP.X,mn.X),math.min(minP.Y,mn.Y),math.min(minP.Z,mn.Z)) maxP=Vector3.new(math.max(maxP.X,mx.X),math.max(maxP.Y,mx.Y),math.max(maxP.Z,mx.Z)) end
                end
            end
            if minP and maxP then cf=CFrame.new((minP+maxP)/2) sz=maxP-minP end
        end
        if cf and sz then
            Qk=cf.Position Pk=cf Nk=math.max(350,math.max(sz.X,sz.Z)/2+150)
            if ((Vector3.new(pos.X,0,pos.Z)-Vector3.new(cf.Position.X,0,cf.Position.Z))).Magnitude<=Nk then inZone=true return end
            local lp=cf:PointToObjectSpace(pos)
            local half=sz/2
            if math.abs(lp.X)<=(half.X+200) and math.abs(lp.Z)<=(half.Z+200) then inZone=true return end
        end
        for _,d in ipairs(root:GetDescendants()) do
            if d:IsA("BasePart") and (pos-d.Position).Magnitude<=250 then
                inZone=true
                if not Qk then Qk=d.Position end
                return
            end
        end
    end)
    return inZone
end

local function Dk(areaId,pos,nameStr)
    local xx=pos and pos.X or 0
    local aLow=string.lower(tostring(areaId or ""))
    local nLow=string.lower(tostring(nameStr or ""))
    if nLow~="" and nLow~="egg" then
        local map={
            {"Titan Temple",{"spideron","crustacia","bladehide","mantaris","rhinotaur","mutantshark","mutant shark","gorillaking","gorilla king","nightflame"}},
            {"Cherry Blossom",{"crane","salamander","redpanda","red panda","snowyowl","snowy owl","koiegg","koi egg","stagegg","stag egg","onitiger","oni tiger","kitsune"}},
            {"Cosmic",{"centapede","cosmicgecko","cosmic gecko","cosmicgorilla","cosmic gorilla","saturno","saturnita","vacca","cosmic skeleton","skeletonboss","skeleton boss","cosmicdragon","cosmic dragon","lunardragon","lunar dragon","unicornegg","unicorn egg"}},
            {"Prehistoric",{"dodo","pterodactyl","ankylosaurus","triceratops","bronto","trex","t-rex","tralaledon","mosasaurus"}},
            {"Abyss Ocean",{"parrotfish","swordfish","whaleshark","whale shark","belugawhale","beluga whale","kraken","elmaja","el maja","shark"}},
            {"Volcano",{"lava gecko","lava frog","flaming bull","lava iguana","chillin chilli","cerberus","phoenix","lava dragon"}},
            {"Snow",{"penguin","walrus","polar bear","polarbear","sabertooth","mammoth","yeti","ice dragon","icedragon"}},
            {"Desert",{"sand spider","sandspider","royal sphinx","sphinx","tob tobi","tobtobi","jerboa","fennec","camel","snake"}},
            {"Jungle",{"chimpanzee","toucan","crocodile","orangutini","ananassini","king snake","kingsnake","spider","gorilla","tiger"}},
            {"Lake",{"duckling","catfish","turtle","trulimero","trulicina","swan","axolotl","leviathan","frog"}},
            {"Forest",{"burrowing owl","burrowingowl","brr brr","patapim","chicken","dog","bird","raccoon","fox","bear"}}
        }
        for _,ent in ipairs(map) do
            for _,kw in ipairs(ent[2]) do if string.find(nLow,kw) then return ent[1] end end
        end
    end
    local zoneKw={
        {"Light Dark",function() return (string.find(aLow,"light") and string.find(aLow,"dark")) or aLow=="lightdark" end},
        {"Titan Temple",function() return string.find(aLow,"titan") end},
        {"Cherry Blossom",function() return string.find(aLow,"cherry") end},
        {"Cosmic",function() return string.find(aLow,"cosmic") end},
        {"Prehistoric",function() return string.find(aLow,"prehistoric") or string.find(aLow,"dino") end},
        {"Abyss Ocean",function() return string.find(aLow,"abyss") or string.find(aLow,"ocean") end},
        {"Volcano",function() return string.find(aLow,"volcano") or string.find(aLow,"lava") end},
        {"Snow",function() return string.find(aLow,"snow") or string.find(aLow,"ice") or string.find(aLow,"winter") end},
        {"Jungle",function() return string.find(aLow,"jungle") end},
        {"Desert",function() return string.find(aLow,"desert") or string.find(aLow,"sand") end},
        {"Lake",function() return string.find(aLow,"lake") or string.find(aLow,"water") end},
        {"Forest",function() return string.find(aLow,"forest") end}
    }
    for _,ent in ipairs(zoneKw) do if ent[2]() then return ent[1] end end
    if xx>0 then
        if xx>=5200 then return "Light Dark"
        elseif xx>=4750 then return "Titan Temple"
        elseif xx>=4000 then return "Cherry Blossom"
        elseif xx>=3350 then return "Cosmic"
        elseif xx>=2780 then return "Prehistoric"
        elseif xx>=2250 then return "Abyss Ocean"
        elseif xx>=1850 then return "Volcano"
        elseif xx>=1450 then return "Snow"
        elseif xx>=1150 then return "Jungle"
        elseif xx>=920 then return "Desert"
        elseif xx>=720 then return "Lake"
        else return "Forest" end
    end
    return "Forest"
end

N4=function()
    local eggs=h4(false)
    if not eggs or #eggs==0 then eggs=h4(true) end
    if not eggs or #eggs==0 then return nil end
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    local myPos=hrp and hrp.Position or Vector3.new(525,70,-360)
    local function fmtMoney(n)
        n=tonumber(n) or 0
        if n>=1e12 then return string.format("%.1fT",n/1e12) end
        if n>=1e9 then return string.format("%.1fB",n/1e9) end
        if n>=1e6 then return string.format("%.1fM",n/1e6) end
        if n>=1e3 then return string.format("%.1fK",n/1e3) end
        return string.format("%.0f",n)
    end
    local function detectRarity(rec,cat,inc,rarHint)
        if rec and rec.PhysicalModel then
            local pm=rec.PhysicalModel
            local atr=pm:GetAttribute("Rarity") or pm:GetAttribute("RarityTier") or pm:GetAttribute("Tier")
            if atr and tostring(atr)~="" and tostring(atr)~="Unknown" then rarHint=tostring(atr) end
            if not cat or cat=="Egg" or cat=="" then cat=pm:GetAttribute("Category") or pm:GetAttribute("AssetCategory") or pm.Name end
        end
        local r1=string.lower(tostring(rec.Rarity or ""))
        local r2=string.lower(tostring(rarHint or ""))
        for _,src in ipairs({r1,r2}) do
            if src~="" and src~="unknown" and src~="nil" then
                if string.find(src,"divine") then return 6,"Divine" end
                if string.find(src,"eternal") then return 5,"Eternal" end
                if string.find(src,"secret") then return 4,"Secret" end
                if string.find(src,"cosmic") then return 3,"Cosmic" end
                if string.find(src,"mythic") then return 2,"Mythic" end
                if string.find(src,"legendary") then return 1,"Legendary" end
                if string.find(src,"epic") then return 0.5,"Epic" end
                if string.find(src,"rare") then return 0.3,"Rare" end
                if string.find(src,"uncommon") then return 0.1,"Uncommon" end
                if string.find(src,"common") then return 0,"Common" end
            end
        end
        if inc and inc>=10 then return 6,"Divine"
        elseif inc and inc>=9 then return 5,"Eternal"
        elseif inc and inc>=8 then return 4,"Secret"
        elseif inc and inc>=7 then return 3,"Cosmic"
        elseif inc and inc>=6 then return 2,"Mythic"
        elseif inc and inc>=5 then return 1,"Legendary"
        elseif inc and inc>=4 then return 0.5,"Epic"
        elseif inc and inc>=3 then return 0.3,"Rare"
        elseif inc and inc>=2 then return 0.1,"Uncommon"
        elseif inc and inc>=1 then return 0,"Common" end
        local all=string.lower(string.format("%s %s %s %s %s",tostring(cat or ""),tostring(rec.Uid or ""),tostring(rec.Name or ""),tostring(rec.DisplayName or ""),tostring(rec.EggName or "")))
        local hk={
            {6,"Divine",{"nightflame","unicornegg","unicorn egg","shatteredcolossus","kitsune","elmaja","el maja"}},
            {5,"Eternal",{"gorillaking","gorilla king","lunardragon","lunar dragon","onitiger","oni tiger","mosasaurus"}},
            {4,"Secret",{"mutantshark","mutant shark","skeletonboss","skeleton boss","stagegg","stag egg","cosmicdragon","cosmic dragon","trex","t-rex","tralaledon","kraken"}},
            {3,"Cosmic",{"saturnita","saturno","mantaris","rhinotaur","snowyowl","snowy owl","koiegg","koi egg","triceratops","bronto","whaleshark","whale shark","belugawhale","beluga whale"}},
            {2,"Mythic",{"bladehide","redpanda","red panda","cosmicgorilla","cosmic gorilla","ankylosaurus","orca"}},
            {1,"Legendary",{"spideron","crustacia","salamander","cosmicgecko","cosmic gecko","pterodactyl","sharkegg","shark egg"}},
            {0.5,"Epic",{"crane","centapede","swordfish"}},
            {0.3,"Rare",{"dodo","parrotfish"}}
        }
        for _,ent in ipairs(hk) do for _,kw in ipairs(ent[3]) do if string.find(all,kw) then return ent[1],ent[2] end end end
        local inc2=tonumber(rec.EarningRate or rec.Income or 0)
        if inc2 and inc2>=150000000 then return 4,"Secret" end
        local fallback=(rarHint and rarHint~="Unknown" and rarHint) or "Common"
        return F[fallback] or 0,fallback
    end
    local function pickEgg(allowCD,forceCD)
        local cands={}
        for _,rec in ipairs(eggs) do
            local isFree=(rec.State=="Slot" or rec.State=="Dropped" or rec.State=="GuardCarried" or rec.State==1)
            local isFirstArea=(rec.BoundsCFrame and rec.BoundsCFrame.Position.X<530) or string.find(tostring(rec.Uid),"FirstArea")
            local cd=X4[rec.Uid] and os.clock()<X4[rec.Uid]
            if isFree and not isFirstArea and (forceCD or not cd) and rec.BoundsCFrame then
                local cat=rec.AssetCategory or "Egg"
                local rk=0
                local inc2=0
                local sale=0
                local rarHint="Unknown"
                if p then
                    pcall(function()
                        if p.RarityRankForCategory then rk=p.RarityRankForCategory(cat) or 0 end
                        if p.ProfileIncomePerSecond then inc2=p.ProfileIncomePerSecond(cat) or 0 end
                        if p.SalePrice then sale=p.SalePrice(cat) or 0 end
                        if p.Assets and p.Assets[cat] then
                            local ent=p.Assets[cat]
                            rarHint=ent.Rarity or (ent.Egg and ent.Egg.Rarity) or "Unknown"
                            if not inc2 or inc2==0 then inc2=ent.EarningRate or (ent.Egg and ent.Egg.EarningRate) or 0 end
                        end
                    end)
                end
                local hpos=rec.BoundsCFrame.Position
                local areaId=rec.AreaId
                if (not areaId or areaId=="" or areaId=="Unknown") and rec.PhysicalModel then
                    areaId=rec.PhysicalModel:GetAttribute("AreaId") or rec.PhysicalModel:GetAttribute("Area")
                end
                local nBuf=string.format("%s %s %s %s",tostring(cat or ""),tostring(rec.Uid or ""),tostring(rec.Name or ""),(rec.PhysicalModel and rec.PhysicalModel.Name) or "")
                local zone=Dk(areaId,hpos,nBuf)
                local tier,rar=detectRarity(rec,cat,rarHint,rk)
                local isSecPlus=(tier>=4 or rar=="Secret" or rar=="Eternal" or rar=="Divine")
                local zoneOK=(h.selectedZones and h.selectedZones[zone]==true)
                local rarOK=(h.selectedRarities and h.selectedRarities[rar]==true)
                local want=false
                if isSecPlus then want=true
                elseif zoneOK and rarOK then want=true end
                if want then
                    local sc=tonumber(rec.AssetScale or rec.Scale) or 1
                    local mut=1
                    if rec.Mutations and type(rec.Mutations)=="table" then
                        for _,mv in pairs(rec.Mutations) do
                            local factor=(type(mv)=="table" and tonumber(mv.Multiplier or mv.Value)) or tonumber(mv) or 1.5
                            mut=mut*factor
                        end
                    elseif rec.Mutation then mut=1.5 end
                    local realInc=(inc2*sc)*mut
                    local zw=f[zone] or 50
                    if realInc<=0 then realInc=(((zw^2)*sc)*mut)*10 end
                    table.insert(cands,{Uid=rec.Uid,Category=tostring(cat),Area=tostring(zone),ZoneWeight=zw,Rarity=tostring(rar),RarityTier=tier,Rank=rk,Income=inc2,RealIncome=realInc,Scale=sc,MutMultiplier=mut,CFrame=rec.BoundsCFrame,Position=hpos,Distance=(myPos-hpos).Magnitude,Model=rec.PhysicalModel})
                end
            end
        end
        if #cands==0 then return nil end
        local function score(e1)
            local rt=e1.RarityTier or 0
            local zw=e1.ZoneWeight or 50
            if rt>=4 then return (400000+(rt*10000))+zw
            else return (zw*11)+(rt*1000) end
        end
        table.sort(cands,function(a,b)
            local sa=score(a) local sb=score(b)
            if sa~=sb then return sa>sb end
            if a.ZoneWeight~=b.ZoneWeight then return a.ZoneWeight>b.ZoneWeight end
            if math.abs(a.RealIncome-b.RealIncome)>1 then return a.RealIncome>b.RealIncome end
            if math.abs(a.Scale-b.Scale)>0.05 then return a.Scale>b.Scale end
            return a.Distance<b.Distance
        end)
        return cands[1]
    end
    local chosen=pickEgg(false,false)
    if not chosen then X4={} chosen=pickEgg(false,true) end
    if not chosen then eggs=h4(true) chosen=pickEgg(false,true) end
    if chosen and r:FindFirstChild("AreaEggSlotsClient") then
        for _,mdl in ipairs(r.AreaEggSlotsClient:GetChildren()) do
            local mp=mdl:FindFirstChildWhichIsA("BasePart") or mdl.PrimaryPart
            if mp and (mp.Position-chosen.Position).Magnitude<=12 then chosen.Model=mdl break end
        end
    end
    return chosen
end

U4=function(uid,targetCF,model,session)
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    if not hrp or not hu then return false end
    h.securingEgg=true h.isReturning=false h.stateTime=os.clock() h.holdingEggForGuard=true
    local tp=targetCF.Position
    V4(tp,14)
    h.currentTargetModel=model h.targetPosition=tp
    hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
    Z4(ch)
    pcall(function() o:RequestStreamAroundAsync(tp) end)
    if not model and r:FindFirstChild("AreaEggSlotsClient") then
        for _,mdl in ipairs(r.AreaEggSlotsClient:GetChildren()) do
            local mp=mdl:FindFirstChildWhichIsA("BasePart") or mdl.PrimaryPart
            if mp and (mp.Position-tp).Magnitude<=16 then model=mdl h.currentTargetModel=mdl break end
        end
    end
    if model then
        pcall(function()
            for _,p1 in ipairs(model:GetDescendants()) do
                if p1:IsA("BasePart") and p1.Transparency>0.8 and p1.Name~="Hitbox" and p1.Name~="Root" and not string.find(p1.Name,"Pad") then p1.Transparency=0 end
            end
        end)
    end
    h.statusText="[1/4] Lifting Egg to Trigger Guard..."
    local step1=os.clock()+3.5
    local lastCheck=0
    while not w4() and os.clock()<step1 and h.alive and h.securingEgg do
        if session and O4~=session then break end
        if not h.pureTweenFarm and not h.autoFarmLoop and not h.teleporting then break end
        if uid and os.clock()-lastCheck>0.4 then
            lastCheck=os.clock()
            local ok2,reason=k4(uid)
            if not ok2 and reason=="CarriedByOther" then break end
        end
        ch:PivotTo(targetCF*CFrame.new(0,0.4,0))
        d4(model,tp)
        if uid and i then
            task.spawn(function() pcall(function()
                if i:IsA("RemoteFunction") then i:InvokeServer({Uid=uid}) i:InvokeServer(uid)
                else i:FireServer({Uid=uid}) i:FireServer(uid) end
            end) end)
        end
        y.Heartbeat:Wait()
    end
    if not w4() then
        if uid then X4[uid]=os.clock()+2 end
        h.currentTargetModel=nil h.targetPosition=nil h.securingEgg=false h.holdingEggForGuard=false
        return false
    end
    h.statusText="[2/4] Waiting for Guard Strike..."
    local step2=os.clock()+4.5
    local struck=false
    while w4() and os.clock()<step2 and h.alive and h.securingEgg do
        if session and O4~=session then break end
        if not h.pureTweenFarm and not h.autoFarmLoop and not h.teleporting then break end
        ch:PivotTo(targetCF*CFrame.new(0,0.4,0))
        V4(tp,14)
        if P and not struck then
            task.spawn(function() pcall(function()
                if P:IsA("RemoteFunction") then P:InvokeServer() else P:FireServer() end
            end) end)
            struck=true
        end
        y.Heartbeat:Wait()
    end
    h.statusText="[3/4] Re-grabbing Egg..."
    local step3=os.clock()+3
    while not w4() and os.clock()<step3 and h.alive and h.securingEgg do
        if session and O4~=session then break end
        if not h.pureTweenFarm and not h.autoFarmLoop and not h.teleporting then break end
        ch:PivotTo(targetCF*CFrame.new(0,0.4,0))
        d4(model,tp)
        if uid and i then
            task.spawn(function() pcall(function()
                if i:IsA("RemoteFunction") then i:InvokeServer({Uid=uid}) i:InvokeServer(uid)
                else i:FireServer({Uid=uid}) i:FireServer(uid) end
            end) end)
        end
        y.Heartbeat:Wait()
    end
    local secured=j4(uid)
    if not secured then task.wait(0.12) secured=j4(uid) end
    h.currentTargetModel=nil h.targetPosition=nil h.securingEgg=false h.holdingEggForGuard=false
    if session and O4~=session then return false end
    if secured then
        pcall(u4)
        h.statusText="Egg Secured! Tweening along Z=-360..."
    else
        if uid then X4[uid]=os.clock()+2 end
        h.statusText="[-] Failed to re-grab egg"
    end
    return secured
end

l4=function(eggTarget,session)
    if h.teleporting or h.glidingToTarget or h.delivering or h.securingEgg then return false end
    h.teleporting=true h.isReturning=false h.stateTime=os.clock()
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    if not hrp or not hu then D4() return false end
    hu:UnequipTools()
    h.statusText="[1/7] Pre-Flight Desync..."
    if not h.swapped then A4() end
    if not h.godmode then b4(true) end
    Z4(ch)
    if not eggTarget then eggTarget=N4() end
    local targetCF=eggTarget and eggTarget.CFrame or S
    local targetUid=eggTarget and eggTarget.Uid
    local targetPos=targetCF.Position
    if targetUid then
        local ok,reason=k4(targetUid)
        if not ok and reason~="CarriedBySelf" then
            X4[targetUid]=os.clock()+5 D4()
            return false
        end
    end
    local currUid=select(2,e4())
    if not currUid then
        local lakeTarget=P4()
        if not lakeTarget then D4() return false end
        h.currentTargetModel=lakeTarget.Model h.targetPosition=lakeTarget.Position
        local lDist=(hrp.Position-lakeTarget.Position).Magnitude
        local lCF=lakeTarget.CFrame*CFrame.new(0,0.4,0)
        pcall(function() o:RequestStreamAroundAsync(lakeTarget.Position) end)
        V4(lakeTarget.Position,8)
        if lDist>60 then
            h.statusText=string.format("[2/7] Gliding to Lake Egg (%.0f studs)...",lDist)
            h.glidingToTarget=true
            if not R4(lCF,h.glideSpeed,lakeTarget.Uid,session) then
                X4[lakeTarget.Uid]=os.clock()+5 D4() h.glidingToTarget=false return false
            end
            h.glidingToTarget=false
        else
            h.statusText="[2/7] Aligning with Lake Egg..."
            hrp.CFrame=lCF hrp.AssemblyLinearVelocity=Vector3.zero
            task.wait(0.04)
        end
        hrp.Anchored=true task.wait(0.06) hrp.Anchored=false
        h.holdingEggForGuard=true
        local lakeDeadline=os.clock()+3
        while not w4() and os.clock()<lakeDeadline and h.alive and h.teleporting do
            if session and O4~=session then D4() return false end
            if not h.autoFarmLoop and not h.teleporting then D4() return false end
            d4(lakeTarget.Model,lakeTarget.Position)
            if lakeTarget.Uid and i then
                task.spawn(function() pcall(function()
                    if i:IsA("RemoteFunction") then i:InvokeServer({Uid=lakeTarget.Uid})
                    else i:FireServer({Uid=lakeTarget.Uid}) end
                end) end)
            end
            y.Heartbeat:Wait()
        end
        currUid=select(2,e4())
        if not w4() then D4() return false end
    end
    h.statusText="[3/7] Pre-streaming Target..."
    pcall(function() o:RequestStreamAroundAsync(targetPos) end)
    V4(targetPos,12)
    h.statusText="[4/7] Waiting for physical bounce..."
    hrp.Anchored=false
    hu:ChangeState(Enum.HumanoidStateType.Running)
    local prevWS=(hu.WalkSpeed>0) and hu.WalkSpeed or 16
    hu.WalkSpeed=0
    hu:Move(Vector3.zero,false)
    hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero
    task.wait(0.04)
    local startPos=hrp.Position
    local startY=startPos.Y
    local strikeUid=select(2,e4()) or currUid
    local gotStrike=false
    local strikeConn=nil
    if N and N:IsA("RemoteEvent") then
        strikeConn=N.OnClientEvent:Connect(function() gotStrike=true if strikeConn then strikeConn:Disconnect() end end)
    end
    h.holdingEggForGuard=true
    H4(strikeUid)
    local strikeStart=os.clock()
    local bounced=false
    local bounceDeadline=os.clock()+2.5
    local secondStrikeDone=false
    while os.clock()<bounceDeadline and h.alive and h.teleporting do
        if session and O4~=session then
            if strikeConn then strikeConn:Disconnect() end
            hu.WalkSpeed=prevWS D4() return false
        end
        local elapsed=os.clock()-strikeStart
        local vel=hrp.AssemblyLinearVelocity
        local pos=hrp.Position
        local yDiff=pos.Y-startY
        local distMoved=(pos-startPos).Magnitude
        if elapsed>=0.08 then
            local yes=gotStrike or (vel.Y>=10) or (yDiff>=1.5 and vel.Magnitude>=16) or (distMoved>=2) or (vel.Magnitude>=20)
            if yes then bounced=true break end
        end
        if elapsed>=0.5 and not secondStrikeDone then secondStrikeDone=true H4(strikeUid) end
        y.Heartbeat:Wait()
    end
    if strikeConn then strikeConn:Disconnect() end
    hu.WalkSpeed=prevWS h.holdingEggForGuard=false
    if not bounced then h.statusText="[-] Aborted (No bounce detected)" D4() pcall(u4) return false end
    task.wait(0.05)
    if targetUid then
        local ok,reason=k4(targetUid)
        if not ok and reason=="CarriedByOther" then
            X4[targetUid]=os.clock()+5 D4() return false
        end
    end
    h.currentTargetModel=eggTarget and eggTarget.Model
    h.targetPosition=targetPos
    h.statusText="[5/7] Warping to Target Egg..."
    V4(targetPos,8)
    ch:PivotTo(targetCF*CFrame.new(0,0.4,0))
    hrp.Anchored=true
    for _,p1 in ipairs(ch:GetDescendants()) do
        if p1:IsA("BasePart") then p1.AssemblyLinearVelocity=Vector3.zero p1.AssemblyAngularVelocity=Vector3.zero end
    end
    h.statusText="[6/7] Picking up Target Egg..."
    local bp=o:FindFirstChild("Backpack")
    for _,tl in ipairs(ch:GetChildren()) do
        if tl:IsA("Tool") then pcall(function() if bp then tl.Parent=bp else tl.Parent=r end end) end
    end
    task.wait(0.06)
    hrp.Anchored=false
    hu:ChangeState(Enum.HumanoidStateType.Running)
    local okSec=U4(targetUid,targetCF,eggTarget and eggTarget.Model,session)
    hrp.Anchored=false
    hu:ChangeState(Enum.HumanoidStateType.Running)
    for _,p1 in ipairs(ch:GetDescendants()) do
        if p1:IsA("BasePart") then p1.AssemblyLinearVelocity=Vector3.zero p1.AssemblyAngularVelocity=Vector3.zero end
    end
    if not okSec then D4() return false
    else h.statusText="[7/7] Target Secured! Stashing into Backpack..." h.teleporting=false pcall(u4) return true end
end

T4=function(mode)
    if Y4==mode then return end
    O4=O4+1
    local sess=O4
    Y4="SWITCHING"
    h.pureTweenFarm=false h.autoFarmLoop=false
    pcall(D4) pcall(u4)
    task.delay(0.06,function()
        if O4==sess then
            Y4=mode
            if mode=="TWEEN" then h.pureTweenFarm=true h.autoFarmLoop=false pcall(u4)
            elseif mode=="WARP" then h.autoFarmLoop=true h.pureTweenFarm=false pcall(u4)
            else h.pureTweenFarm=false h.autoFarmLoop=false if not h.isBatchPlacing then h.batchStealCount=0 end end
        end
    end)
end

local lastClear=os.clock()
task.spawn(function()
    while h.alive do
        local ok,err=pcall(function()
            if h.pureTweenFarm and not h.autoFarmLoop and Y4=="TWEEN" and not h.isBatchPlacing and not h.teleporting and not h.glidingToTarget and not h.securingEgg and not h.delivering and not h.isReturning then
                local ch=o.Character
                local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
                local hu=ch and ch:FindFirstChildOfClass("Humanoid")
                if hrp and hu then
                    pcall(u4)
                    if not w4() then
                        local sess=O4
                        local tgt=N4()
                        if tgt and h.pureTweenFarm and Y4=="TWEEN" and O4==sess then
                            if h.onTreadmill or L4() then M4() task.wait(0.08) end
                            local ok2,reason=k4(tgt.Uid)
                            if not ok2 and reason~="CarriedBySelf" then X4[tgt.Uid]=os.clock()+5 task.wait(0.12) return end
                            h.currentTargetModel=tgt.Model h.targetPosition=tgt.Position h.glidingToTarget=true h.stateTime=os.clock()
                            if not h.swapped then A4() end
                            if not h.godmode then b4(true) end
                            Z4(ch)
                            pcall(function() o:RequestStreamAroundAsync(tgt.Position) end)
                            local destCF=tgt.CFrame*CFrame.new(0,0.4,0)
                            local okFly=R4(destCF,h.glideSpeed,tgt.Uid,sess)
                            h.glidingToTarget=false
                            if O4~=sess or not h.pureTweenFarm or Y4~="TWEEN" then return end
                            if not okFly then X4[tgt.Uid]=os.clock()+5 D4() return end
                            if h.pureTweenFarm and Y4=="TWEEN" and (hrp.Position-tgt.Position).Magnitude<=22 then
                                local secured=U4(tgt.Uid,destCF,tgt.Model,sess)
                                if not secured and w4() then secured=true end
                                if O4~=sess or not h.pureTweenFarm or Y4~="TWEEN" then return end
                                if secured then
                                    pcall(u4)
                                    if h.autoGlide then
                                        h.statusText="[AutoSteal] Secured! Tweening to Safe Line X=525..."
                                        Q4(h.glideSpeed,sess)
                                        pcall(u4)
                                    end
                                    pcall(u4)
                                    h.isReturning=false h.delivering=false h.glidingToTarget=false h.securingEgg=false h.currentTargetModel=nil h.targetPosition=nil
                                    if c4("TWEEN") then return end
                                else
                                    if O4==sess and h.pureTweenFarm and Y4=="TWEEN" then X4[tgt.Uid]=os.clock()+5 D4() end
                                end
                            else
                                h.currentTargetModel=nil h.targetPosition=nil h.glidingToTarget=false
                            end
                        else
                            if os.clock()-lastClear>5 then X4={} lastClear=os.clock() end
                            if h.autoTreadmill and not h.isBatchPlacing and not h.isHatching then
                                if not h.onTreadmill and not L4() then f4(sess) end
                            end
                        end
                    end
                end
            end
        end)
        if not ok then pcall(D4) end
        task.wait(0.08)
    end
end)

local lastClear2=os.clock()
task.spawn(function()
    while h.alive do
        local ok,err=pcall(function()
            if h.autoFarmLoop and not h.pureTweenFarm and Y4=="WARP" and not h.isBatchPlacing and not h.teleporting and not h.glidingToTarget and not h.securingEgg and not h.delivering and not h.isReturning then
                local ch=o.Character
                local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
                local hu=ch and ch:FindFirstChildOfClass("Humanoid")
                if hrp and hu then
                    pcall(u4)
                    if not w4() then
                        local sess=O4
                        local tgt=N4()
                        if tgt and h.autoFarmLoop and Y4=="WARP" and O4==sess then
                            if h.onTreadmill or L4() then M4() task.wait(0.08) end
                            local okWarp=l4(tgt,sess)
                            if O4~=sess or not h.autoFarmLoop or Y4~="WARP" then return end
                            if okWarp then
                                pcall(u4)
                                if h.autoGlide then
                                    h.statusText="[SnipeLoop] Target secured! Tweening to Safe Line X=525..."
                                    Q4(h.glideSpeed,sess)
                                    pcall(u4)
                                end
                                pcall(u4) h.isReturning=false h.delivering=false
                                if c4("WARP") then return end
                            else
                                if O4==sess and h.autoFarmLoop and Y4=="WARP" then
                                    if tgt and tgt.Uid then X4[tgt.Uid]=os.clock()+5 end
                                    pcall(D4)
                                end
                            end
                        else
                            if os.clock()-lastClear2>5 then X4={} lastClear2=os.clock() end
                            if h.autoTreadmill and not h.isBatchPlacing and not h.isHatching then
                                if not h.onTreadmill and not L4() then f4(sess) end
                            end
                        end
                    end
                end
            end
        end)
        if not ok then pcall(D4) end
        task.wait(0.08)
    end
end)

task.spawn(function()
    while h.alive do
        pcall(function()
            if h.autoTreadmill and not h.pureTweenFarm and not h.autoFarmLoop and not h.isBatchPlacing and not h.isHatching and not h.teleporting and not h.glidingToTarget and not h.securingEgg and not h.delivering and not h.isReturning then
                local ch=o.Character
                local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
                if hrp and not w4() then
                    if not h.onTreadmill and not L4() then f4() end
                end
            end
        end)
        task.wait(0.5)
    end
end)

task.spawn(function()
    while h.alive do
        pcall(function() if h.autoUpgradeTreadmill then pk() end end)
        task.wait(5)
    end
end)

task.spawn(function()
    while h.alive do
        if h.autoHatch and not h.securingEgg and not h.teleporting and not h.isHatching then
            pcall(function() J4(false) end)
        end
        task.wait(4)
    end
end)

y.Heartbeat:Connect(function()
    local ch=o.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    local hu=ch and ch:FindFirstChildOfClass("Humanoid")
    if not hrp then return end
    if hu and not (h and h.onTreadmill) then
        if hu.PlatformStand then hu.PlatformStand=false hu:ChangeState(Enum.HumanoidStateType.Running) end
        if hu.Sit and (h.pureTweenFarm or h.autoFarmLoop or h.isReturning or h.glidingToTarget) then hu.Sit=false hu:ChangeState(Enum.HumanoidStateType.Running) end
    end
    local pos=hrp.Position
    if pos.Y<45 then
        hrp.CFrame=CFrame.new(pos.X,72,pos.Z)
        hrp.AssemblyLinearVelocity=Vector3.zero
        return
    end
    if (h.pureTweenFarm or h.autoFarmLoop) and not h.holdingEggForGuard then
        local hasTool=false
        for _,tl in ipairs(ch:GetChildren()) do if tl:IsA("Tool") then hasTool=true break end end
        if hasTool then u4() end
    end
    if h.pureTweenFarm or h.autoFarmLoop or h.teleporting or h.glidingToTarget or h.delivering or h.securingEgg or h.isReturning then return end
    if h.alive and h.autoGlide and w4() and not a4() and pos.X>E then
        task.spawn(function() Q4(h.glideSpeed) u4() h.isReturning=false h.delivering=false end)
    end
end)

return {
    State=h,
    SetFarmMode=T4,
    SetDesyncGodmode=b4,
    ResetFarmStates=D4,
    DoffTreadmillState=C4,
    MountTreadmillOff=M4,
    ExecuteManualPlaceSequence=v4,
    GetTotalEggCount=y4,
    SaveEggSelectConfig=x,
    SaveSpeed=Y,
    ZoneList=M,
    RarityList=X
}
end)()

local h=AutoFarm.State

AddToggle(autoFarmPage,"Auto Steal (Tween)","Smoothly fly to steal eggs continuously along Z=-360 highway",h.pureTweenFarm==true,function(state)
    if state then AutoFarm.SetFarmMode("TWEEN") Notify("AutoSteal","Tween Farm Started",2)
    else AutoFarm.SetFarmMode("NONE") Notify("AutoSteal","Tween Farm Stopped",2) end
end)

AddToggle(autoFarmPage,"Auto Steal (Teleport)","Instantly warp to steal target eggs in rapid loop",h.autoFarmLoop==true,function(state)
    if state then AutoFarm.SetFarmMode("WARP") Notify("AutoSteal","Teleport Farm Started",2)
    else AutoFarm.SetFarmMode("NONE") Notify("AutoSteal","Teleport Farm Stopped",2) end
end)

AddToggle(autoFarmPage,"Auto Return","Automatically fly back to safe line (X=525) after stealing",h.autoGlide~=false,function(state)
    h.autoGlide=state Notify("AutoSteal","Auto Return set to: "..tostring(state),2)
end)

AddToggle(autoFarmPage,"Auto Place (Every 5)","Return home every 5 steals to deposit eggs to incubators",h.autoPlaceEvery5==true,function(state)
    h.autoPlaceEvery5=state if not state then h.batchStealCount=0 end
    Notify("AutoPlace","Auto Place (Every 5) set to: "..tostring(state),2)
end)

AddToggle(autoFarmPage,"Auto Hatch","Continuously hatch ready eggs automatically from anywhere",h.autoHatch~=false,function(state)
    h.autoHatch=state Notify("AutoHatch","Auto Hatch set to: "..tostring(state),2)
end)

AddButton(autoFarmPage,"Place Carried Eggs Now","Fly home immediately, place stashed eggs into stands, and hatch",function()
    Notify("AutoPlace","Placing carried eggs...",2)
    task.spawn(function() AutoFarm.ExecuteManualPlaceSequence(h.glideSpeed,nil,true) end)
end)

AddToggle(autoFarmPage,"Auto Treadmill","Run on base treadmill when no target eggs are spawned",h.autoTreadmill~=false,function(state)
    h.autoTreadmill=state AutoFarm.SaveEggSelectConfig(h) Notify("Treadmill","Auto Treadmill set to: "..tostring(state),2)
end)

AddToggle(autoFarmPage,"Auto Upgrade Treadmill","Automatically upgrade base treadmill tier when you have enough cash",h.autoUpgradeTreadmill~=false,function(state)
    h.autoUpgradeTreadmill=state AutoFarm.SaveEggSelectConfig(h) Notify("Treadmill","Auto Upgrade set to: "..tostring(state),2)
end)

AddToggle(autoFarmPage,"Hide 'Not Enough Money' UI","Automatically suppress red 'Not enough money' game alert",h.hideNotEnoughMoney~=false,function(state)
    h.hideNotEnoughMoney=state AutoFarm.SaveEggSelectConfig(h) Notify("UI","Hide Alert set to: "..tostring(state),2)
end)

AddMultiDropdown(eggFilterPage,"Target Zones",AutoFarm.ZoneList,h.selectedZones,function(selectedMap)
    h.selectedZones=selectedMap AutoFarm.SaveEggSelectConfig(h)
end)

AddMultiDropdown(eggFilterPage,"Target Rarities",AutoFarm.RarityList,h.selectedRarities,function(selectedMap)
    h.selectedRarities=selectedMap AutoFarm.SaveEggSelectConfig(h)
end)

AddToggle(eggFilterPage,"Always Steal Secret+ Eggs","Collect Secret, Eternal, Divine eggs from any zone automatically",h.alwaysCollectSecretPlus~=false,function(state)
    h.alwaysCollectSecretPlus=state AutoFarm.SaveEggSelectConfig(h) Notify("EggFilter","Always Secret+ set to: "..tostring(state),2)
end)

AddSlider(movementPage,"Flight Cruise Speed",100,1000,h.glideSpeed or 600,function(val)
    h.glideSpeed=val AutoFarm.SaveSpeed(val)
end)

AddToggle(movementPage,"Desync Godmode","Full immunity against map obstacles, traps, and hazards",h.godmode==true,function(state)
    AutoFarm.SetDesyncGodmode(state) Notify("Safety","Godmode set to: "..tostring(state),2)
end)

AddButton(movementPage,"Get Unstuck / Get Off Treadmill","Instantly break free from treadmills, seats, or map geometry",function()
    AutoFarm.ResetFarmStates() AutoFarm.DoffTreadmillState() AutoFarm.MountTreadmillOff()
    Notify("Safety","Unstuck executed!",2)
end)
