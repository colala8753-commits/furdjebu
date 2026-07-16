-- furdjehub - Murder Mystery 2 (Advanced GUI)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local mm2 = game:GetService("ReplicatedStorage").Remotes

-- Window GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "furdjehub"
screenGui.Parent = player:WaitForChild("PlayerGui")

local window = Instance.new("Frame")
window.Size = UDim2.new(0, 400, 0, 500)
window.Position = UDim2.new(0.5, -200, 0.5, -250)
window.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
window.BackgroundTransparency = 0.05
window.BorderSizePixel = 0
window.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
titleBar.BorderSizePixel = 0
titleBar.Parent = window

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 5, 0, 0)
title.Text = "furdjehub | MM2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 2)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -70, 0, 2)
minBtn.Text = "─"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar

-- Scrolling frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -35)
scrollFrame.Position = UDim2.new(0, 0, 0, 35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
scrollFrame.Parent = window

local canvas = Instance.new("Frame")
canvas.Size = UDim2.new(1, 0, 0, 0)
canvas.BackgroundTransparency = 1
canvas.Parent = scrollFrame

local function addElement(type, y, text, callback)
if type == "button" then
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.9, 0, 0, 35)
btn.Position = UDim2.new(0.05, 0, 0, y)
btn.Text = text
btn.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.BorderSizePixel = 0
btn.Parent = canvas
btn.MouseButton1Click:Connect(callback)
canvas.Size = UDim2.new(1, 0, 0, y + 40)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, y + 40)
return btn
elseif type == "toggle" then
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.9, 0, 0, 35)
btn.Position = UDim2.new(0.05, 0, 0, y)
btn.Text = text .. ": OFF"
btn.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.BorderSizePixel = 0
btn.Parent = canvas
local state = false
btn.MouseButton1Click:Connect(function()
state = not state
btn.Text = text .. (state and ": ON" or ": OFF")
btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(55, 55, 75)
callback(state)
end)
canvas.Size = UDim2.new(1, 0, 0, y + 40)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, y + 40)
return btn
elseif type == "slider" then
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0.9, 0, 0, 20)
label.Position = UDim2.new(0.05, 0, 0, y)
label.Text = text .. ": 50"
label.TextColor3 = Color3.fromRGB(200, 200, 200)
label.BackgroundTransparency = 1
label.Parent = canvas
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.9, 0, 0, 25)
btn.Position = UDim2.new(0.05, 0, 0, y + 20)
btn.Text = "◀ 50 ▶"
btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.BorderSizePixel = 0
btn.Parent = canvas
local value = 50
btn.MouseButton1Click:Connect(function()
value = value + 5
if value > 100 then value = 0 end
btn.Text = "◀ " .. value .. " ▶"
label.Text = text .. ": " .. value
callback(value)
end)
canvas.Size = UDim2.new(1, 0, 0, y + 50)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, y + 50)
return btn
end
end

-- State variables
local toggles = {}
local noclipConnection = nil
local espHighlights = {}
local xrayParts = {}
local xrayActive = false
local noclipActive = false
local flingActive = false
local autoShootActive = false
local gunEspActive = false

-- Role detection
local function getPlayerRole(v)
if v.Character and v.Character:FindFirstChild("Knife") then
return "murderer"
elseif v.Backpack:FindFirstChild("Gun") then
return "sheriff"
else
return "innocent"
end
end

-- ESP with roles
local function updateESP(state)
if state then
for _, v in pairs(game.Players:GetPlayers()) do
if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
local role = getPlayerRole(v)
local color = role == "murderer" and Color3.fromRGB(255, 0, 0) or 
role == "sheriff" and Color3.fromRGB(0, 100, 255) or 
Color3.fromRGB(0, 255, 0)
local hl = Instance.new("Highlight")
hl.Parent = v.Character
hl.Adornee = v.Character
hl.FillColor = color
hl.FillTransparency = 0.4
hl.OutlineColor = Color3.fromRGB(255, 255, 255)
hl.OutlineTransparency = 0
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
espHighlights[v] = hl
end
end
-- Update on player change
game.Players.PlayerAdded:Connect(function(newPlayer)
if espActive then
newPlayer.CharacterAdded:Connect(function()
wait(0.5)
local role = getPlayerRole(newPlayer)
local color = role == "murderer" and Color3.fromRGB(255, 0, 0) or 
role == "sheriff" and Color3.fromRGB(0, 100, 255) or 
Color3.fromRGB(0, 255, 0)
local hl = Instance.new("Highlight")
hl.Parent = newPlayer.Character
hl.Adornee = newPlayer.Character
hl.FillColor = color
hl.FillTransparency = 0.4
hl.OutlineColor = Color3.fromRGB(255, 255, 255)
hl.OutlineTransparency = 0
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
espHighlights[newPlayer] = hl
end)
end
end)
else
for _, hl in pairs(espHighlights) do
if hl then hl:Destroy() end
end
espHighlights = {}
end
end

-- X-Ray
local function updateXRay(state, strength)
if state then
xrayActive = true
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("Part") or v:IsA("MeshPart") then
if v.Material ~= Enum.Material.Neon and v.Name ~= "Handle" then
local origTrans = v.Transparency
v.Transparency = math.clamp(strength / 100, 0.2, 0.9)
xrayParts[v] = origTrans
end
end
end
else
xrayActive = false
for v, origTrans in pairs(xrayParts) do
if v and v.Parent then
v.Transparency = origTrans
end
end
xrayParts = {}
end
end

-- Noclip
local function updateNoclip(state)
noclipActive = state
if state then
if noclipConnection then noclipConnection:Disconnect() end
noclipConnection = game:GetService("RunService").Stepped:Connect(function()
if character and root and noclipActive then
for _, part in ipairs(character:GetDescendants()) do
if part:IsA("BasePart") then
part.CanCollide = false
end
end
end
end)
else
if noclipConnection then
noclipConnection:Disconnect()
noclipConnection = nil
end
if character then
for _, part in ipairs(character:GetDescendants()) do
if part:IsA("BasePart") then
part.CanCollide = true
end
end
end
end
end

-- Auto Shoot (Sheriff)
local function updateAutoShoot(state)
autoShootActive = state
end

game:GetService("RunService").Heartbeat:Connect(function()
if autoShootActive then
local murderer = nil
for _, v in pairs(game.Players:GetPlayers()) do
if v ~= player and v.Character and v.Character:FindFirstChild("Knife") then
murderer = v
break
end
end
if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
local target = murderer.Character.HumanoidRootPart
local gun = character:FindFirstChildOfClass("Tool")
if gun and gun.Name == "Gun" then
root.CFrame = CFrame.lookAt(root.Position, target.Position)
wait(0.02)
mm2.Shoot:FireServer(target)
else
local gunItem = player.Backpack:FindFirstChild("Gun")
if gunItem then
gunItem.Parent = character
wait(0.1)
end
end
end
end
end)

-- Auto Fling Sheriff
local function updateFling(state)
flingActive = state
end

game:GetService("RunService").Heartbeat:Connect(function()
if flingActive then
for _, v in pairs(game.Players:GetPlayers()) do
if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
if v.Backpack:FindFirstChild("Gun") then
local target = v.Character.HumanoidRootPart
target.Velocity = Vector3.new(0, 150, 0)
end
end
end
end
end)

-- Gun ESP
local function updateGunESP(state)
gunEspActive = state
end

game:GetService("RunService").Heartbeat:Connect(function()
if gunEspActive then
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("Part") and v.Name == "Handle" and v.Parent and v.Parent:IsA("Tool") then
if not v:FindFirstChild("GunHighlight") then
local hl = Instance.new("Highlight")
hl.Name = "GunHighlight"
hl.Parent = v
hl.Adornee = v
hl.FillColor = Color3.fromRGB(0, 255, 0)
hl.FillTransparency = 0.3
hl.OutlineColor = Color3.fromRGB(255, 255, 255)
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end
end
end
else
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("Part") and v.Name == "Handle" and v.Parent and v.Parent:IsA("Tool") then
local hl = v:FindFirstChild("GunHighlight")
if hl then hl:Destroy() end
end
end
end
end)

-- Add elements to GUI
local y = 5

-- Main section
addElement("button", y, "═══════ MAIN ═══════", function() end)
y = y + 45

local espActive = false
addElement("toggle", y, "Role ESP", function(state)
espActive = state
updateESP(state)
end)
y = y + 45

addElement("toggle", y, "X-Ray", function(state)
updateXRay(state, 50)
end)
y = y + 45

addElement("slider", y, "X-Ray Strength", function(val)
if xrayActive then
updateXRay(true, val)
end
end)
y = y + 55

addElement("toggle", y, "No Clip", function(state)
updateNoclip(state)
end)
y = y + 45

addElement("toggle", y, "Auto Fling Sheriff", function(state)
updateFling(state)
end)
y = y + 45

-- Sheriff section
addElement("button", y, "═══════ SHERIFF ═══════", function() end)
y = y + 45

addElement("toggle", y, "Gun ESP", function(state)
updateGunESP(state)
end)
y = y + 45

addElement("toggle", y, "Auto Shoot Murderer", function(state)
updateAutoShoot(state)
end)
y = y + 45

-- Murder section
addElement("button", y, "═══════ MURDER ═══════", function() end)
y = y + 45

addElement("button", y, "Kill Aura (Coming Soon)", function() end)
y = y + 45

-- Fun section
addElement("button", y, "═══════ FUN ═══════", function() end)
y = y + 45

local jumpPower = 50
addElement("slider", y, "Jump Power", function(val)
humanoid.JumpPower = val
end)
y = y + 55

local walkSpeed = 16
addElement("slider", y, "Walk Speed", function(val)
humanoid.WalkSpeed = val
end)
y = y + 55

-- Close/Minimize functions
closeBtn.MouseButton1Click:Connect(function()
screenGui:Destroy()
end)

local minimized = false
minBtn.MouseButton1Click:Connect(function()
minimized = not minimized
window.Visible = not minimized
minBtn.Text = minimized and "□" or "─"
end)

-- Toggle button when closed
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "📂"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = screenGui
toggleBtn.Visible = false

toggleBtn.MouseButton1Click:Connect(function()
window.Visible = true
toggleBtn.Visible = false
minimized = false
minBtn.Text = "─"
end)

-- Override close to show toggle
local origClose = closeBtn.MouseButton1Click
closeBtn.MouseButton1Click:Connect(function()
window.Visible = false
toggleBtn.Visible = true
end)

print("furdjehub loaded!")
