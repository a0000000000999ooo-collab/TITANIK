-- Шлюха // Steal an Egg AutoFarm Engine
local e=game:GetService("Players")
local r=game:GetService("Workspace")
local y=game:GetService("RunService")
local u=game:GetService("TweenService")
local w=game:GetService("UserInputService")
local j=game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local o=e.LocalPlayer
local Camera = r.CurrentCamera

local connections = {}
local parentGui = (pcall(function() return gethui() end) and gethui()) or CoreGui

if parentGui:FindFirstChild("ShlyuhaScreenGui") then
    parentGui.ShlyuhaScreenGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShlyuhaScreenGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 180)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(120, 80, 255)
MainStroke.Transparency = 0.4
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Шлюха"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -35, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
CloseButton.AutoButtonColor = false
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 215)
CloseButton.TextSize = 16
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Size = UDim2.new(1, 0, 1, -45)
ContentContainer.Position = UDim2.new(0, 0, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 80)
ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentContainer.ScrollBarThickness = 3
ContentContainer.Parent = MainFrame

local PageLayout = Instance.new("UIListLayout")
PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
PageLayout.VerticalAlignment = Enum.VerticalAlignment.Top
PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
PageLayout.Padding = UDim.new(0, 8)
PageLayout.Parent = ContentContainer

local PagePadding = Instance.new("UIPadding")
PagePadding.PaddingTop = UDim.new(0, 10)
PagePadding.PaddingBottom = UDim.new(0, 10)
PagePadding.PaddingLeft = UDim.new(0, 15)
PagePadding.PaddingRight = UDim.new(0, 15)
PagePadding.Parent = ContentContainer

local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
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
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

w.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local function AddToggle(parentPage, title, defaultState, callback)
    local toggled = defaultState or false

    local ToggleContainer = Instance.new("Frame")
    ToggleContainer.Size = UDim2.new(1, 0, 0, 45)
    ToggleContainer.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    ToggleContainer.BorderSizePixel = 0
    ToggleContainer.Parent = parentPage

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = ToggleContainer

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Position = UDim2.new(0, 12, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 250)
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = ToggleContainer

    local SwitchBg = Instance.new("Frame")
    SwitchBg.Size = UDim2.new(0, 40, 0, 20)
    SwitchBg.Position = UDim2.new(1, -50, 0.5, -10)
    SwitchBg.BackgroundColor3 = toggled and Color3.fromRGB(130, 85, 255) or Color3.fromRGB(40, 40, 52)
    SwitchBg.BorderSizePixel = 0
    SwitchBg.Parent = ToggleContainer

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = SwitchBg

    local SwitchKnob = Instance.new("Frame")
    SwitchKnob.Size = UDim2.new(0, 14, 0, 14)
    SwitchKnob.Position = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SwitchKnob.BorderSizePixel = 0
    SwitchKnob.Parent = SwitchBg

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = SwitchKnob

    local ClickButton = Instance.new("TextButton")
    ClickButton.Size = UDim2.new(1, 0, 1, 0)
    ClickButton.BackgroundTransparency = 1
    ClickButton.Text = ""
    ClickButton.Parent = ToggleContainer

    ClickButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        local targetColor = toggled and Color3.fromRGB(130, 85, 255) or Color3.fromRGB(40, 40, 52)
        local targetPos = toggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        
        u:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        u:Create(SwitchKnob, TweenInfo.new(0.2), {Position = targetPos}):Play()
        
        if callback then pcall(function() callback(toggled) end) end
    end)
end

local AutoFarmModule = (function()
    local s=nil pcall(function() s=require((j:WaitForChild("Client", 5)):WaitForChild("EggState", 5)) end)
    local B=nil pcall(function() B=require((j:WaitForChild("Shared", 5)):WaitForChild("Remotes", 5)) end)
    local function J(e,r)
        local y=(j:FindFirstChild("Packages") and j.Packages:FindFirstChild("Networking")) or j:FindFirstChild("Network") or j
        local u=y:FindFirstChild(e) or j:FindFirstChild(e)
        if u then return u end
        return y:FindFirstChild(e, true) or j:FindFirstChild(e, true)
    end
    local i=J("RF/EggWorld/AskFieldEggCarry", "AskFieldEggCarry")
    local R=J("RF/EggWorld/AskFieldEggSnapshot", "AskFieldEggSnapshot")
    local P=J("RE/GuardPatrol/ForestStrike", "ForestStrike") or (B and B.GuardPatrol and B.GuardPatrol.ForestStrike)
    local N=J("SpeedTollOffer", "RE/GuardPatrol/SpeedTollOffer") or (B and B.GuardPatrol and B.GuardPatrol.SpeedTollOffer)
    
    local h = {
        pureTweenFarm = false,
        autoFarmLoop = false,
        glideSpeed = 600,
        laneZ = -360,
        alive = true,
        swapped = false,
        godmode = false,
        holdingEggForGuard = false,
        teleporting = false,
        glidingToTarget = false,
        securingEgg = false,
        isReturning = false,
        delivering = false
    }

    local function m(e)
        if not e or not e:IsA("Tool") then return false end
        local r = string.lower(e.Name)
        if string.find(r, "sword") or string.find(r, "radar") or string.find(r, "basket") or string.find(r, "punch") then return false end
        return e:GetAttribute("EggUid") or e:GetAttribute("UID") or string.find(r, "egg") or e:GetAttribute("Category") or e:GetAttribute("ItemType") == "Egg"
    end

    local function e4()
        local e = o.Character
        if e then
            for _, y in ipairs(e:GetChildren()) do
                if m(y) then return y, y:GetAttribute("UID") or y:GetAttribute("EggUid") or y.Name end
            end
        end
        return nil, nil
    end

    local function r4()
        local e = o:FindFirstChild("Backpack")
        if e then
            for _, y in ipairs(e:GetChildren()) do
                if m(y) then return y, y:GetAttribute("UID") or y:GetAttribute("EggUid") or y.Name end
            end
        end
        return nil, nil
    end

    local function u4()
        local r = o.Character
        local y = r and r:FindFirstChildOfClass("Humanoid")
        local u = o:FindFirstChild("Backpack")
        if y then pcall(function() y:UnequipTools() end) end
        if r and u then
            for _, r in ipairs(r:GetChildren()) do
                if r:IsA("Tool") then pcall(function() r.Parent = u end) end
            end
        end
    end

    local function w4()
        local r, y = e4()
        if r then return true end
        local u = o.Character
        local w = u and u:FindFirstChild("HumanoidRootPart")
        if w and w.Position.X <= 540 then return false end
        if s and s.ReadFieldEggs then
            local r, y = pcall(s.ReadFieldEggs)
            if r and y and y.Records then
                for _, y in ipairs(y.Records) do
                    if (y.State == "Carried" or y.State == 2) and (y.CarrierUserId == o.UserId or y.Carrier == o.UserId) then
                        return true
                    end
                end
            end
        end
        return false
    end

    local function j4(e)
        local r, y = e4()
        if r then
            if not e or y == e or not y then return true end
        end
        local u = o:FindFirstChild("Backpack")
        if u then
            for _, y in ipairs(u:GetChildren()) do
                if m(y) then
                    local r = y:GetAttribute("UID") or y:GetAttribute("EggUid")
                    if not e or r == e or y.Name == tostring(e) then return true end
                end
            end
        end
        return false
    end

    local F4 = nil
    local function ek()
        local e = R or j:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot", true)
        if not e or not e:IsA("RemoteFunction") then return end
        task.spawn(function()
            local r, y = pcall(function() return e:InvokeServer() end)
            if r and type(y) == "table" then
                local e = {}
                local r = y.Records or y
                if type(r) == "table" then
                    for r, y in pairs(r) do
                        if type(y) == "table" then
                            if not y.Uid and type(r) == "string" then y.Uid = r end
                            table.insert(e, y)
                        end
                    end
                end
                if #e > 0 then F4 = e end
            end
        end)
    end

    local function h4()
        ek()
        return F4 or {}
    end

    local function k4(e)
        if not e then return false, "NoUid" end
        local y = h4()
        for _, y in ipairs(y) do
            if y.Uid == e then
                if y.State == "Carried" or y.State == 2 then
                    local e = y.CarrierUserId or y.Carrier
                    if e and e == o.UserId then return true, "CarriedBySelf" end
                    return false, "CarriedByOther"
                end
                return true, "Available"
            end
        end
        return true, "Unchecked"
    end

    local function V4(e, y)
        y = y or 8
        local u = Instance.new("Part")
        u.Name = "SafetyFloorPad_AntiVoid"
        u.Size = Vector3.new(28, 1.5, 28)
        u.Position = e - Vector3.new(0, 3.2, 0)
        u.Anchored = true
        u.Transparency = 1
        u.CanCollide = true
        u.Parent = r
        task.delay(y, function() pcall(function() u:Destroy() end) end)
        return u
    end

    local function H4(e)
        if P and e then
            pcall(function()
                local r = o.Character
                local y = r and r:FindFirstChild("HumanoidRootPart")
                local u = y and (y.CFrame * CFrame.new(0, 0, -3)) or CFrame.new()
                if P:IsA("RemoteFunction") then
                    P:InvokeServer({["EggUid"] = e, ["GuardCFrame"] = u})
                else
                    P:FireServer({["EggUid"] = e, ["GuardCFrame"] = u})
                end
            end)
        end
    end

    local function Z4(e)
        e = e or o.Character
        if not e then return end
        local r = e:FindFirstChildOfClass("Humanoid")
        if r then
            r:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            r:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            r:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
            r.PlatformStand = false
            r.Sit = false
        end
    end

    local function A4()
        local e = o.Character
        local y = e and e:FindFirstChildOfClass("Humanoid")
        if not e or not y then return false end
        pcall(function()
            y.BreakJointsOnDeath = false
            local w = y:Clone()
            w.Parent = e
            y:Destroy()
            Camera.CameraSubject = w
        end)
        h.swapped = true
        Z4(e)
        return true
    end

    local function N4()
        local e = h4()
        if #e == 0 then return nil end
        local y = o.Character
        local u = y and y:FindFirstChild("HumanoidRootPart")
        local w = u and u.Position or Vector3.new(525, 70, -360)
        
        local valid = {}
        for _, r in ipairs(e) do
            local j = r.State == "Slot" or r.State == "Dropped" or r.State == 1
            if j and r.BoundsCFrame then
                r.Distance = (w - r.BoundsCFrame.Position).Magnitude
                table.insert(valid, r)
            end
        end
        if #valid == 0 then return nil end
        table.sort(valid, function(a, b) return a.Distance < b.Distance end)
        return valid[1]
    end

    local function wk(e, r, u)
        local j = o.Character
        local k = j and j:FindFirstChild("HumanoidRootPart")
        if not k then return false end
        local V = e.Position
        V4(V, 14)
        pcall(function() o:RequestStreamAroundAsync(V) end)
        k.AssemblyLinearVelocity = Vector3.zero
        
        local targetCF = e * CFrame.new(0, 0.4, 0)
        k.CFrame = targetCF
        task.wait(0.1)
        return true
    end

    local function R4(e, r, y, u)
        return wk(e, r, y, u)
    end

    local function U4(e, u, w, j)
        local k = o.Character
        local a = k and k:FindFirstChild("HumanoidRootPart")
        if not a then return false end
        h.securingEgg = true
        local s = u.Position
        V4(s, 14)
        a.AssemblyLinearVelocity = Vector3.zero
        
        local p = os.clock() + 3.5
        while not w4() and (os.clock() < p and h.alive and h.securingEgg) do
            k:PivotTo(u * CFrame.new(0, 0.4, 0))
            if e and i then
                pcall(function()
                    if i:IsA("RemoteFunction") then i:InvokeServer({["Uid"] = e}) else i:FireServer({["Uid"] = e}) end
                end)
            end
            y.Heartbeat:Wait()
        end
        
        local K = os.clock() + 4.5
        while w4() and (os.clock() < K and h.alive and h.securingEgg) do
            k:PivotTo(u * CFrame.new(0, 0.4, 0))
            if P then pcall(function() P:FireServer() end) end
            y.Heartbeat:Wait()
        end
        
        local v = os.clock() + 3
        while not w4() and (os.clock() < v and h.alive and h.securingEgg) do
            k:PivotTo(u * CFrame.new(0, 0.4, 0))
            if e and i then
                pcall(function()
                    if i:IsA("RemoteFunction") then i:InvokeServer({["Uid"] = e}) else i:FireServer({["Uid"] = e}) end
                end)
            end
            y.Heartbeat:Wait()
        end
        
        local R = j4(e)
        h.securingEgg = false
        if R then pcall(u4) end
        return R
    end

    task.spawn(function()
        while h.alive do
            if h.pureTweenFarm then
                pcall(function()
                    local r = o.Character
                    local y = r and r:FindFirstChild("HumanoidRootPart")
                    if y and not w4() then
                        local w = N4()
                        if w and w.BoundsCFrame then
                            if not h.swapped then A4() end
                            Z4(r)
                            pcall(function() o:RequestStreamAroundAsync(w.BoundsCFrame.Position) end)
                            local V = w.BoundsCFrame
                            local s = wk(V, h.glideSpeed, w.Uid)
                            if s then
                                U4(w.Uid, V, nil, nil)
                            end
                        end
                    end
                end)
            end
            task.wait(0.2)
        end
    end)

    return {
        SetMode = function(mode)
            if mode == "TWEEN" then
                h.pureTweenFarm = true
            else
                h.pureTweenFarm = false
            end
        end
    }
end)()

AddToggle(ContentContainer, "Авто Фарм (Авто Сбор)", false, function(state)
    if state then
        AutoFarmModule.SetMode("TWEEN")
    else
        AutoFarmModule.SetMode("NONE")
    end
end)
