-- KerryHub | Menu + AutoFarm + Auto Teleport
-- LocalScript для Roblox Studio

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("KerryHub")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "KerryHub"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 500, 0, 320)
main.Position = UDim2.new(0.5, -250, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = main

-- Заголовок
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -45, 0, 45)
header.Position = UDim2.new(0, 15, 0, 0)
header.BackgroundTransparency = 1
header.Text = "KerryHub"
header.TextColor3 = Color3.fromRGB(120, 170, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 22
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = main

-- Кнопка закрытия
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 32, 0, 32)
close.Position = UDim2.new(1, -40, 0, 7)
close.BackgroundColor3 = Color3.fromRGB(170, 55, 65)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.Parent = main

Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Перетаскивание окна
local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart

        main.Position = UDim2.new(
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

-- Боковое меню
local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.new(0, 10, 0, 55)
sidebar.Size = UDim2.new(0, 145, 1, -65)
sidebar.BackgroundColor3 = Color3.fromRGB(27, 27, 38)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

local content = Instance.new("Frame")
content.Position = UDim2.new(0, 165, 0, 55)
content.Size = UDim2.new(1, -175, 1, -65)
content.BackgroundColor3 = Color3.fromRGB(27, 27, 38)
content.BorderSizePixel = 0
content.Parent = main

Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)

local function makeButton(parent, text, position, size)
    local button = Instance.new("TextButton")
    button.Position = position
    button.Size = size
    button.BackgroundColor3 = Color3.fromRGB(45, 48, 65)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(240, 240, 245)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = parent

    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

    return button
end

local function makeLabel(parent, text, position, size)
    local label = Instance.new("TextLabel")
    label.Position = position
    label.Size = size
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(235, 235, 245)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    return label
end

local tabs = {
    "AutoFarm",
    "Teleport",
    "Diagnostics"
}

local pages = {}
local showPage

for _, tabName in ipairs(tabs) do
    local page = Instance.new("Frame")
    page.Name = tabName
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = content

    pages[tabName] = page

    local tabButton = makeButton(
        sidebar,
        tabName,
        UDim2.new(0, 8, 0, 10 + (#pages - 1) * 45),
        UDim2.new(1, -16, 0, 36)
    )

    tabButton.MouseButton1Click:Connect(function()
        showPage(tabName)
    end)
end

showPage = function(name)
    for pageName, page in pairs(pages) do
        page.Visible = pageName == name
    end
end

-- Состояние функций
local autoFarmEnabled = false
local autoTeleportEnabled = false

-- Подключи сюда разрешённую механику фарма своей игры.
local function AutoFarmStep()
    -- TODO: логика сбора предметов для собственной игры
end

-- Подключи сюда разрешённую механику телепорта своей игры.
local function TeleportToTarget()
    -- TODO: телепорт к разрешённой цели в собственной игре
end

-- Вкладка AutoFarm
makeLabel(
    pages.AutoFarm,
    "Автофарм",
    UDim2.new(0, 5, 0, 5),
    UDim2.new(1, -10, 0, 25)
)

local farmButton = makeButton(
    pages.AutoFarm,
    "AutoFarm: OFF",
    UDim2.new(0, 5, 0, 40),
    UDim2.new(1, -10, 0, 38)
)

farmButton.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled

    farmButton.Text = autoFarmEnabled
        and "AutoFarm: ON"
        or "AutoFarm: OFF"

    farmButton.BackgroundColor3 = autoFarmEnabled
        and Color3.fromRGB(45, 120, 80)
        or Color3.fromRGB(45, 48, 65)
end)

-- Вкладка Teleport
makeLabel(
    pages.Teleport,
    "Автотелепорт",
    UDim2.new(0, 5, 0, 5),
    UDim2.new(1, -10, 0, 25)
)

local teleportButton = makeButton(
    pages.Teleport,
    "Auto Teleport: OFF",
    UDim2.new(0, 5, 0, 40),
    UDim2.new(1, -10, 0, 38)
)

teleportButton.MouseButton1Click:Connect(function()
    autoTeleportEnabled = not autoTeleportEnabled

    teleportButton.Text = autoTeleportEnabled
        and "Auto Teleport: ON"
        or "Auto Teleport: OFF"

    teleportButton.BackgroundColor3 = autoTeleportEnabled
        and Color3.fromRGB(45, 120, 80)
        or Color3.fromRGB(45, 48, 65)
end)

-- Вкладка Diagnostics
makeLabel(
    pages.Diagnostics,
    "Диагностика персонажа",
    UDim2.new(0, 5, 0, 5),
    UDim2.new(1, -10, 0, 25)
)

local diagnosticsLabel = makeLabel(
    pages.Diagnostics,
    "Нажми кнопку для проверки.",
    UDim2.new(0, 5, 0, 40),
    UDim2.new(1, -10, 0, 55)
)

local diagnosticsButton = makeButton(
    pages.Diagnostics,
    "Проверить персонажа",
    UDim2.new(0, 5, 0, 100),
    UDim2.new(1, -10, 0, 38)
)

diagnosticsButton.MouseButton1Click:Connect(function()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")

    diagnosticsLabel.Text = string.format(
        "Персонаж: %s\nHumanoid: %s\nRootPart: %s",
        character and "найден" or "не найден",
        humanoid and "найден" or "не найден",
        root and "найден" or "не найден"
    )
end)

-- Цикл переключателей
task.spawn(function()
    while gui.Parent do
        if autoFarmEnabled then
            pcall(AutoFarmStep)
        end

        if autoTeleportEnabled then
            pcall(TeleportToTarget)
        end

        task.wait(0.25)
    end
end)

showPage("AutoFarm")
