-- Binn & Steve Engine // Full GUI + Farm Suite for "Steal an Egg"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local State = {
    AutoFarm = false,
    TweenSpeed = 60,
    ESP = false
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BinnEngineGUI"
ScreenGui.Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 260)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Title.Text = " BIN-CORE // STEAL AN EGG "
Title.TextColor3 = Color3.fromRGB(220, 50, 50)
Title.TextSize = 14
Title.Font = Enum.Font.Code
Title.Parent = MainFrame

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 40)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Container

local function createButton(text, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15
    btn.Text = text
    btn.BorderSizePixel = 0
    btn.Parent = Container
    
    btn.MouseButton1Click:Connect(function()
        onClick(btn)
    end)
    return btn
end

createButton("Auto-Farm: OFF", function(btn)
    State.AutoFarm = not State.AutoFarm
    if State.AutoFarm then
        btn.Text = "Auto-Farm: ACTIVE"
        btn.BackgroundColor3 = Color3.fromRGB(40, 140, 60)
    else
        btn.Text = "Auto-Farm: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    end
end)

createButton("ESP Eggs: OFF", function(btn)
    State.ESP = not State.ESP
    if State.ESP then
        btn.Text = "ESP Eggs: ACTIVE"
        btn.BackgroundColor3 = Color3.fromRGB(40, 140, 60)
    else
        btn.Text = "ESP Eggs: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    end
end)

createButton("Speed: Normal (60)", function(btn)
    if State.TweenSpeed == 60 then
        State.TweenSpeed = 120
        btn.Text = "Speed: Fast (120)"
    elseif State.TweenSpeed == 120 then
        State.TweenSpeed = 200
        btn.Text = "Speed: INSANE (200)"
    else
        State.TweenSpeed = 60
        btn.Text = "Speed: Normal (60)"
    end
end)

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 25)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "[Insert] — Скрыть / Показать Меню"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.TextSize = 12
infoLabel.Font = Enum.Font.Code
infoLabel.Parent = Container

game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

local function getBestEgg()
    local eggsFolder = Workspace:FindFirstChild("Eggs") or Workspace:FindFirstChild("SpawnedEggs") or Workspace
    local targetEgg = nil
    local maxVal = -1
    
    for _, egg in ipairs(eggsFolder:GetChildren()) do
        if egg.Name:lower():find("egg") or egg:GetAttribute("Value") then
            local val = egg:GetAttribute("Value") or 1
            local primary = egg:FindFirstChild("PrimaryPart") or (egg:IsA("BasePart") and egg)
            if val > maxVal and primary then
                maxVal = val
                targetEgg = egg
            end
        end
    end
    return targetEgg
end

task.spawn(function()
    while task.wait(0.3) do
        if State.AutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart
                
                local egg = getBestEgg()
                if egg then
                    local targetPart = egg:FindFirstChild("PrimaryPart") or (egg:IsA("BasePart") and egg)
                    if targetPart then
                        local dist = (hrp.Position - targetPart.Position).Magnitude
                        local travelTime = dist / State.TweenSpeed
                        
                        local tw = TweenService:Create(hrp, TweenInfo.new(travelTime, Enum.EasingStyle.Linear), {CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)})
                        tw:Play()
                        tw.Completed:Wait()
                        
                        if egg:FindFirstChild("TouchInterest") then
                            firetouchinterest(hrp, targetPart, 0)
                            firetouchinterest(hrp, targetPart, 1)
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if State.ESP then
            pcall(function()
                local eggsFolder = Workspace:FindFirstChild("Eggs") or Workspace:FindFirstChild("SpawnedEggs") or Workspace
                for _, egg in ipairs(eggsFolder:GetChildren()) do
                    if (egg.Name:lower():find("egg") or egg:GetAttribute("Value")) and not egg:FindFirstChildOfClass("Highlight") then
                        local hl = Instance.new("Highlight")
                        hl.FillColor = Color3.fromRGB(255, 0, 80)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.Parent = egg
                    end
                end
            end)
        end
    end
end)

print("[BINN-CORE]: GUI Меню успешно загружено.")
