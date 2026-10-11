ocal Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local remotes = ReplicatedStorage:WaitForChild("EggHeistRemotes")
local farmRemote = remotes:WaitForChild("FarmAction")

local gui = Instance.new("ScreenGui")
gui.Name = "EggHeistMenu"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local openButton = Instance.new("TextButton")
openButton.Name = "OpenMenu"
openButton.Size = UDim2.fromOffset(54, 54)
openButton.Position = UDim2.new(0, 20, 0.5, -27)
openButton.BackgroundColor3 = Color3.fromRGB(112, 75, 220)
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.Text = "EGG"
openButton.TextSize = 16
openButton.Font = Enum.Font.GothamBold
openButton.Parent = gui
Instance.new("UICorner", openButton).CornerRadius = UDim.new(0, 14)

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.fromOffset(300, 340)
panel.Position = UDim2.new(0, 86, 0.5, -170)
panel.BackgroundColor3 = Color3.fromRGB(25, 26, 38)
panel.Visible = false
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(130, 95, 245)
stroke.Thickness = 1.5
stroke.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 42)
title.Position = UDim2.fromOffset(14, 4)
title.BackgroundTransparency = 1
title.Text = "EGG HEIST  •  HUB"
title.TextColor3 = Color3.fromRGB(235, 230, 255)
title.TextSize = 17
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.fromOffset(32, 30)
closeButton.Position = UDim2.new(1, -40, 0, 8)
closeButton.BackgroundColor3 = Color3.fromRGB(58, 48, 77)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Text = "×"
closeButton.TextSize = 22
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = panel
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -28, 0, 26)
status.Position = UDim2.fromOffset(14, 46)
status.BackgroundTransparency = 1
status.Text = "Статус: готово"
status.TextColor3 = Color3.fromRGB(180, 180, 200)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = panel

local active = {
    AutoFarm = false,
    AutoCollect = false,
    AutoHatch = false,
    AutoUpgrade = false,
}
local buttons = {}

local function setStatus(text)
    status.Text = "Статус: " .. text
end

local function requestToggle(action, enabled)
    -- Сервер обязан сам проверять правила игры и доступность действия.
    farmRemote:FireServer(action, enabled)
    setStatus((enabled and "включено — " or "выключено — ") .. action)
end

local function makeToggle(action, label, y)
    local button = Instance.new("TextButton")
    button.Name = action
    button.Size = UDim2.new(1, -28, 0, 42)
    button.Position = UDim2.fromOffset(14, y)
    button.BackgroundColor3 = Color3.fromRGB(48, 49, 68)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.Text = label .. "  [OFF]"
    button.Parent = panel
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 9)

    buttons[action] = button
    button.Activated:Connect(function()
        active[action] = not active[action]
        button.Text = label .. (active[action] and "  [ON]" or "  [OFF]")
        button.BackgroundColor3 = active[action]
            and Color3.fromRGB(92, 65, 160)
            or Color3.fromRGB(48, 49, 68)
        requestToggle(action, active[action])
    end)
end

makeToggle("AutoFarm", "Auto Farm", 82)
makeToggle("AutoCollect", "Auto Collect", 132)
makeToggle("AutoHatch", "Auto Hatch", 182)
makeToggle("AutoUpgrade", "Auto Upgrade", 232)

local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(1, -28, 0, 38)
stopButton.Position = UDim2.fromOffset(14, 286)
stopButton.BackgroundColor3 = Color3.fromRGB(145, 55, 70)
stopButton.TextColor3 = Color3.new(1, 1, 1)
stopButton.Text = "Остановить всё"
stopButton.TextSize = 14
stopButton.Font = Enum.Font.GothamBold
stopButton.Parent = panel
Instance.new("UICorner", stopButton).CornerRadius = UDim.new(0, 9)

stopButton.Activated:Connect(function()
    for action in pairs(active) do
        active[action] = false
        local button = buttons[action]
        if button then
            local label = ({
                AutoFarm = "Auto Farm",
                AutoCollect = "Auto Collect",
                AutoHatch = "Auto Hatch",
                AutoUpgrade = "Auto Upgrade",
            })[action]
            button.Text = label .. "  [OFF]"
            button.BackgroundColor3 = Color3.fromRGB(48, 49, 68)
        end
        requestToggle(action, false)
    end
    setStatus("все действия остановлены")
end)

openButton.Activated:Connect(function()
    panel.Visible = not panel.Visible
end)
closeButton.Activated:Connect(function()
    panel.Visible = false
end)

-- Перетаскивание панели мышью или касанием.
local dragging = false
local dragStart
local startPosition

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = panel.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- =========================
-- ЧАСТЬ B — Server Script
-- ServerScriptService/EggHeistServer.server.lua
-- =========================
-- Этот блок нужно вставить в ОТДЕЛЬНЫЙ Script в ServerScriptService,
-- а не в тот же LocalScript, что и часть A.

--[[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotesFolder = ReplicatedStorage:FindFirstChild("EggHeistRemotes")
if not remotesFolder then
    remotesFolder = Instance.new("Folder")
    remotesFolder.Name = "EggHeistRemotes"
    remotesFolder.Parent = ReplicatedStorage
end

local farmRemote = remotesFolder:FindFirstChild("FarmAction")
if not farmRemote then
    farmRemote = Instance.new("RemoteEvent")
    farmRemote.Name = "FarmAction"
    farmRemote.Parent = remotesFolder
end

local enabled = {}
local lastRequest = {}

local function performOwnedGameAction(player, action)
    -- ПОДКЛЮЧИ СЮДА СВОЮ ИГРОВУЮ ЛОГИКУ.
    -- Примеры:
    -- AutoFarm: выдать награду только если игрок выполнил условия фарма.
    -- AutoCollect: собрать предметы в допустимом радиусе.
    -- AutoHatch: проверить валюту и наличие яйца, затем открыть его.
    -- AutoUpgrade: проверить стоимость улучшения и баланс игрока.
    --
    -- Не доверяй клиенту: все проверки и выдача наград должны происходить на сервере.
    -- Пока здесь безопасная заглушка, чтобы кнопки не выдавали бесплатные награды.
end

farmRemote.OnServerEvent:Connect(function(player, action, isEnabled)
    local allowed = {
        AutoFarm = true,
        AutoCollect = true,
        AutoHatch = true,
        AutoUpgrade = true,
    }
    if not allowed[action] or typeof(isEnabled) ~= "boolean" then
        return
    end

    local now = os.clock()
    if lastRequest[player] and now - lastRequest[player] < 0.12 then
        return
    end
    lastRequest[player] = now

    enabled[player] = enabled[player] or {}
    enabled[player][action] = isEnabled

    if isEnabled then
        task.spawn(function()
            while player.Parent and enabled[player] and enabled[player][action] do
                performOwnedGameAction(player, action)
                task.wait(1)
            end
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    enabled[player] = nil
    lastRequest[player] = nil
end)
]]
