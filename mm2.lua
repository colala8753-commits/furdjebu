-- furdjehub - Murder Mystery 2 (Pulse Hub Style)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local mm2 = game:GetService("ReplicatedStorage").Remotes

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "furdjehub"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 520)
frame.Position = UDim2.new(0.5, -175, 0.5, -260)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BackgroundTransparency = 0.1
frame.Parent = screenGui

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "furdjehub | MM2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = frame

-- Toggle button (outside GUI)
local toggleGui = Instance.new("TextButton")
toggleGui.Size = UDim2.new(0, 50, 0, 50)
toggleGui.Position = UDim2.new(0, 10, 0, 10)
toggleGui.Text = "📂"
toggleGui.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleGui.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
toggleGui.Parent = screenGui
toggleGui.Visible = false

local guiVisible = true

closeBtn.MouseButton1Click:Connect(function()
frame.Visible = false
toggleGui.Visible = true
guiVisible = false
end)

toggleGui.MouseButton1Click:Connect(function()
frame.Visible = true
toggleGui.Visible = false
guiVisible = true
end)

local function createButton(name, y, color, callback)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0, 35)
btn.Position = UDim2.new(0.1, 0, y, 0)
btn.Text = name
btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 60)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Parent = frame
btn.MouseButton1Click:Connect(callback)
return btn
end

local function createToggle(name, y, callback)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0, 35)
btn.Position = UDim2.new(0.1, 0, y, 0)
btn.Text = name .. ": OFF"
btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Parent = frame
local state = false
btn.MouseButton1Click:Connect(function()
state = not state
btn.Text = name .. (state and ": ON" or ": OFF")
btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 60)
callback(state)
end)
return btn
end

local function createSlider(name, y, min, max, default, callback)
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0.8, 0, 0, 20)
label.Position = UDim2.new(0.1, 0, y, 0)
label.Text = name .. ": " .. default
label.TextColor3 = Color3.fromRGB(200, 200, 200)
label.BackgroundTransparency = 1
label.Parent = frame
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.8, 0, 0, 25)
btn.Position = UDim2.new(0.1, 0, y + 0.05, 0)
btn.Text = "◀ " .. default .. " ▶"
btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Parent = frame
local value = default
btn.MouseButton1Click:Connect(function()
value = value + 1
if value > max then value = min end
btn.Text = "◀ " .. value .. " ▶"
label.Text = name .. ": " .. value
callback(value)
end)
return btn
end

-- Main category buttons
createButton("🔪 MAIN", 0.12, Color3.fromRGB(60, 60, 100), function() end)
createToggle("Role ESP", 0.20, function(state)
if state then
for _, v in pairs(game.Players:GetPlayers()) do
if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
local hl = Instance.new("Highlight")
hl.Parent = v.Character
hl.Adornee = v.Character
hl.FillColor = Color3.fromRGB(255, 0, 0)
hl.FillTransparency = 0.3
hl.OutlineColor = Color3.fromRGB(255, 255, 255)
hl.OutlineTransparency = 0
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end
end
else
for _, v in pairs(game.Players:GetPlayers()) do
if v.Character then
for _, hl in ipairs(v.Character:GetDescendants()) do
if hl:IsA("Highlight") then hl:Destroy() end
end
end
end
end
end)

createToggle("X-Ray", 0.30, function(state)
if state then
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("Part") and v.Name == "Base" then
v.Transparency = 0.6
end
end
else
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("Part") and v.Name == "Base" then
v.Transparency = 0
end
end
end
end)

createSlider("X-Ray Strength", 0.40, 10, 90, 64, function(val)
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("Part") and v.Name == "Base" then
v.Transparency = val / 100
end
end
end)

createToggle("No Clip", 0.55, function(state)
if state then
game:GetService("RunService").Stepped:Connect(function()
if character and root then
for _, part in ipairs(character:GetDescendants()) do
if part:IsA("BasePart") then
part.CanCollide = false
end
end
end
end)
end
end)

createToggle("Auto Fling Sheriff", 0.65, function(state)
if state then
game:GetService("RunService").Heartbeat:Connect(function()
for _, v in pairs(game.Players:GetPlayers()) do
if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
if v.Backpack:FindFirstChild("Gun") then
local target = v.Character.HumanoidRootPart
target.Velocity = Vector3.new(0, 100, 0)
end
end
end
end)
end
end)

createButton("🔫 SHERIFF", 0.78, Color3.fromRGB(100, 60, 60), function() end)
createToggle("Gun ESP", 0.86, function(state)
if state then
game:GetService("RunService").Heartbeat:Connect(function()
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("Part") and v.Name == "Handle" and v.Parent and v.Parent:IsA("Tool") then
local hl = Instance.new("Highlight")
hl.Parent = v
hl.Adornee = v
hl.FillColor = Color3.fromRGB(0, 255, 0)
hl.FillTransparency = 0.2
hl.OutlineColor = Color3.fromRGB(255, 255, 255)
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end
end
end)
end
end)

createButton("🔪 MURDER", 0.96, Color3.fromRGB(100, 60, 60), function() end)

print("furdjehub loaded!")
