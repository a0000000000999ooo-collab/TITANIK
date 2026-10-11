-- == Live Coordinate Viewer ==
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local plr = Players.LocalPlayer

-- Удалить старую плашку, если есть
local parentGui = (pcall(function() return gethui() end) and gethui()) or CoreGui
if parentGui:FindFirstChild("CoordViewerGui") then
    parentGui.CoordViewerGui:Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "CoordViewerGui"
sg.ResetOnSpawn = false
sg.Parent = parentGui

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 320, 0, 130)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(140, 90, 255)
stroke.Thickness = 2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "LIVE COORDINATES"
title.TextColor3 = Color3.fromRGB(140, 90, 255)
title.TextSize = 14
title.Position = UDim2.new(0, 0, 0, 5)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, -20, 1, -40)
label.Position = UDim2.new(0, 10, 0, 33)
label.BackgroundTransparency = 1
label.Font = Enum.Font.Code
label.TextColor3 = Color3.fromRGB(230, 230, 240)
label.TextSize = 14
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Top
label.Text = "Ожидание персонажа..."

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -28, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.AutoButtonColor = false
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)
closeBtn.MouseButton1Click:Connect(function()
    sg:Destroy()
end)

RunService.RenderStepped:Connect(function()
    local ch = plr.Character
    local root = ch and ch:FindFirstChild("HumanoidRootPart")
    if root then
        local p = root.Position
        label.Text = string.format(
            "X: %.1f\nY: %.1f\nZ: %.1f",
            p.X, p.Y, p.Z
        )
    else
        label.Text = "Персонаж не загружен..."
    end
end)

-- Также выведем в warn (часто warn видно в консоли)
task.spawn(function()
    while sg.Parent do
        local ch = plr.Character
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        if root then
            warn(string.format("[COORD] X=%.1f Y=%.1f Z=%.1f", root.Position.X, root.Position.Y, root.Position.Z))
        end
        task.wait(2)
    end
end)

warn("[CoordViewer] Скрипт запущен. Плашка должна появиться в левом верхнем углу.")
