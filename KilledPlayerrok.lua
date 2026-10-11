local ch=game.Players.LocalPlayer.Character
local root=ch and ch:FindFirstChild("HumanoidRootPart")
if root then print("X:", root.Position.X, "Y:", root.Position.Y, "Z:", root.Position.Z) end
