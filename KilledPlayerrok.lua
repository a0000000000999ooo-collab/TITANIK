--[[
    KerryHub - Minimal Core UI (AutoFarm + AutoTeleport + AntiCheat Bypass)
]]--

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local parentGui = (pcall(function() return gethui() end) and gethui()) or CoreGui

if parentGui:FindFirstChild("KerryHubScreenGui") then
    parentGui.KerryHubScreenGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KerryHubScreenGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parentGui

-- Состояние скрипта
local FarmState = {
    pureTweenFarm = false,
    autoFarmLoop = false,
    autoGlide = true,
    glideSpeed = 600,
    laneZ = -360,
    godmode = true,
    swapped = false,
    alive = true,
    statusText = "Ready"
}

-- Ремоты
local function GetRemote(name)
    local pkg = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Networking") or ReplicatedStorage:FindFirstChild("Network") or ReplicatedStorage
    return pkg:FindFirstChild(name, true) or ReplicatedStorage:FindFirstChild(name, true)
end

local RF_Carry = GetRemote("AskFieldEggCarry")
local RF_Snapshot = GetRemote("AskFieldEggSnapshot") or GetRemote("RequestAreaEggSnapshot")
local RE_Strike = GetRemote("ForestStrike")

-- Быстрый прок промтов
pcall(function()
    game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
        if typeof(fireproximityprompt) == "function" then
            fireproximityprompt(prompt)
        end
    end)
end)

-- Обход Античита (Bypass)
local function TriggerAntiCheatBypass()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if root and hum then
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = root
            hum:Destroy()
        end
    end
end

local function SwapHumanoid()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then return end
    pcall(function()
        hum.BreakJointsOnDeath = false
        local clone = hum:Clone()
        clone.Parent = char
        hum:Destroy()
        Camera.CameraSubject = clone
        clone:ChangeState(Enum.HumanoidStateType.Running)
    end)
    FarmState.swapped = true
end

-- Поиск яиц на карте
local function GetBestEgg()
    local areaSlots = Workspace:FindFirstChild("AreaEggSlotsClient")
    if not areaSlots then return nil end
    for _, slot in ipairs(areaSlots:GetChildren()) do
        local pivot = slot:GetPivot()
        if slot.Name and slot.Name ~= "" then
            return {
                Uid = slot.Name,
                CFrame = pivot,
                Position = pivot.Position,
                Model = slot
            }
        end
    end
    return nil
end

-- Логика движения к яйцу
local function FlyToEgg(targetCF, speed)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    speed = math.max(100, speed or FarmState.glideSpeed)
    local targetPos = targetCF.Position
    local startTime = os.clock()
    
    while FarmState.alive and (os.clock() - startTime < 12) do
        local currentPos = root.Position
        local dist = (targetPos - currentPos).Magnitude
        if dist <= 6 then break end
        
        local dt = RunService.Heartbeat:Wait()
        local moveDir = (targetPos - currentPos).Unit
        root.CFrame = root.CFrame + (moveDir * math.min(dist, speed * dt))
        root.AssemblyLinearVelocity = Vector3.zero
    end
    
    root.CFrame = targetCF * CFrame.new(0, 0.4, 0)
    root.AssemblyLinearVelocity = Vector3.zero
    return true
end

-- Поклев/забор яйца
local function SecureEgg(egg)
    if not egg then return false end
    if not FarmState.swapped then SwapHumanoid() end
    
    if RF_Carry then
        pcall(function()
            if RF_Carry:IsA("RemoteFunction") then
                RF_Carry:InvokeServer({ Uid = egg.Uid })
            else
                RF_Carry:FireServer({ Uid = egg.Uid })
            end
        end)
    end
    return true
end

-- Циклы фармов
task.spawn(function()
    while FarmState.alive do
        if FarmState.pureTweenFarm then
            local egg = GetBestEgg()
            if egg then
                FarmState.statusText = "Flying to Egg..."
                if FlyToEgg(egg.CFrame, FarmState.glideSpeed) then
                    SecureEgg(egg)
                    FarmState.statusText = "Secured!"
                end
            else
                FarmState.statusText = "Scanning for eggs..."
            end
        end
        task.wait(0.2)
    end
end)

task.spawn(function()
    while FarmState.alive do
        if FarmState.autoFarmLoop then
            local egg = GetBestEgg()
            if egg then
                FarmState.statusText = "Warping to Egg..."
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = egg.CFrame * CFrame.new(0, 0.4, 0)
                    SecureEgg(egg)
                    FarmState.statusText = "Warp Secured!"
                end
            else
                FarmState.statusText = "Searching for targets..."
            end
        end
        task.wait(0.2)
    end
end)

-- UI Сборка
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 260)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "KerryHub - Steal An Egg"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 20
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.
