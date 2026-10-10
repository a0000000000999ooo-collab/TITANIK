-- Binn & Steve Engine // Full Silent TP Farm for "Steal an Egg"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Глобальная конфигурация
local CONFIG = {
    Enabled = true,
    TeleportDelay = 0.2,
    SpeedHack = true,
    CustomSpeed = 28,
    BypassAnticheat = true
}

-- 1. Базовый обход локального античита (заглушка hookmetamethod)
local function initBypass()
    if not CONFIG.BypassAnticheat then return end
    pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local oldNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" and (tostring(self):lower():find("ban") or tostring(self):lower():find("kick")) then
                return -- Блокируем отправку репорта о кике/бане серверу
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end)
end
initBypass()

-- 2. Поиск наиболее ценного яйца на карте
local function getBestEgg()
    local targetEgg = nil
    local maxVal = -1
    local eggsFolder = Workspace:FindFirstChild("Eggs") or Workspace:FindFirstChild("SpawnedEggs")
    
    if eggsFolder then
        for _, egg in ipairs(eggsFolder:GetChildren()) do
            -- Проверяем атрибуты стоимости или берем первый попавшийся вал
            local val = egg:GetAttribute("Value") or egg:GetAttribute("Price") or 1
            if val > maxVal and (egg:FindFirstChild("PrimaryPart") or egg:IsA("BasePart")) then
                maxVal = val
                targetEgg = egg
            end
        end
    end
    return targetEgg
end

-- 3. Функция бесшумного телепорта и сбора
local function executeSilentTP()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    local egg = getBestEgg()
    if egg then
        local targetPart = egg:FindFirstChild("PrimaryPart") or (egg:IsA("BasePart") and egg)
        if targetPart then
            -- Сохраняем текущую позицию, телепортируем к яйцу, вызываем касание, возвращаем (если нужно, но здесь просто ведем фарм)
            hrp.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
            
            -- Триггерим касание через RemoteEvent или firetouchinterest
            if egg:FindFirstChild("TouchInterest") then
                firetouchinterest(hrp, targetPart, 0)
                firetouchinterest(hrp, targetPart, 1)
            end
            
            -- Дублируем через RemoteEvent, если игра сетевая
            local remote = ReplicatedStorage:FindFirstChild("CollectEgg", true) or ReplicatedStorage:FindFirstChild("Claim", true)
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer(egg)
            end
        end
    end
end

-- 4. Ускорение передвижения
RunService.Heartbeat:Connect(function()
    if CONFIG.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = CONFIG.CustomSpeed
    end
end)

-- 5. Основной асинхронный поток фарма
task.spawn(function()
    print("[BIN-ENGINE]: Полный скрипт Silent TP Farm запущен.")
    while task.wait(CONFIG.TeleportDelay) do
        if CONFIG.Enabled then
            pcall(executeSilentTP)
        end
    end
end)

-- Переключатель по клавише 'P' (Вкл/Выкл)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.P then
        CONFIG.Enabled = not CONFIG.Enabled
        print("[BIN-ENGINE]: Статус фарма -> " .. tostring(CONFIG.Enabled))
    end
end)
