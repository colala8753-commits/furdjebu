-- furdjehub - Murder Mystery 2 (Full GUI)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local mm2 = game:GetService("ReplicatedStorage").Remotes

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "furdjehub"
screenGui.Parent = player:WaitForChild("PlayerGui")

local window = Instance.new("Frame")
window.Size = UDim2.new(0, 340, 0, 420)
window.Position = UDim2.new(0.5, -170, 0.5, -210)
window.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
window.BackgroundTransparency = 0.05
window.BorderSizePixel = 0
window.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(38, 38, 55)
titleBar.BorderSizePixel = 0
titleBar.Parent = window

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 5, 0, 0)
title.Text = "furdjehub | MM2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -55, 0, 2)
minBtn.Text = "─"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -28, 0, 2)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

-- Scroll frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -30)
scrollFrame.Position = UDim2.new(0, 0, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
scrollFrame.Parent = window

local canvas = Instance.new("Frame")
canvas.Size = UDim2.new(1, 0, 0, 0)
canvas.BackgroundTransparency = 1
canvas.Parent = scrollFrame

-- Dragging
local dragging = false
local dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true
dragStart = input.Position
startPos = window.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
dragging = false
end
end)
end
end)

titleBar.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
local delta = input.Position - dragStart
window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end)

-- GUI elements
local function addToggle(text, y, callback)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.92, 0, 0, 28)
btn.Position = UDim2.new(0.04, 0, 0, y)
btn.Text = text .. ": OFF"
btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
btn.TextColor3 = Color3.fromRGB(220, 220, 220)
btn.TextSize = 13
btn.BorderSizePixel = 0
btn.Parent = canvas
local state = false
btn.MouseButton1Click:Connect(function()
state = not state
btn.Text = text .. (state and ": ON" or ": OFF")
btn.BackgroundColor3 = state and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(45, 45, 65)
callback(state)
end)
canvas.Size = UDim2.new(1, 0, 0, y + 33)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, y + 33)
return btn
end

local function addSlider(text, y, callback)
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0.92, 0, 0, 16)
label.Position = UDim2.new(0.04, 0, 0, y)
label.Text = text .. ": 50"
label.TextColor3 = Color3.fromRGB(180, 180, 180)
label.TextSize = 12
label.BackgroundTransparency = 1
label.Parent = canvas
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.92, 0, 0, 22)
btn.Position = UDim2.new(0.04, 0, 0, y + 17)
btn.Text = "◄ 50 ►"
btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
btn.TextColor3 = Color3.fromRGB(200, 200, 200)
btn.TextSize = 12
btn.BorderSizePixel = 0
btn.Parent = canvas
local value = 50
btn.MouseButton1Click:Connect(function()
value = value + 5
if value > 100 then value = 0 end
btn.Text = "◄ " .. value .. " ►"
label.Text = text .. ": " .. value
callback(value)
end)
canvas.Size = UDim2.new(1, 0, 0, y + 42)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, y + 42)
return btn
end

local function addButton(text, y, color, callback)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.92, 0, 0, 28)
btn.Position = UDim2.new(0.04, 0, 0, y)
btn.Text = text
btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 70)
btn.TextColor3 = Color3.fromRGB(220, 220, 220)
btn.TextSize = 13
btn.BorderSizePixel = 0
btn.Parent = canvas
btn.MouseButton1Click:Connect(callback)
canvas.Size = UDim2.new(1, 0, 0, y + 33)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, y + 33)
return btn
end

local function addSection(text, y)
local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.new(0.92, 0, 0, 22)
lbl.Position = UDim2.new(0.04, 0, 0, y)
lbl.Text = text
lbl.TextColor3 = Color3.fromRGB(150, 150, 200)
lbl.TextSize = 14
lbl.TextXAlignment = Enum.TextXAlignment.Center
lbl.BackgroundTransparency = 1
lbl.Parent = canvas
canvas.Size = UDim2.new(1, 0, 0, y + 28)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, y + 28)
return lbl
end

-- State vars
local espMurderActive = false
local espSheriffActive = false
local xrayActive = false
local noclipActive = false
local flingActive = false
local autoShootActive = false
local gunEspActive = false
local aimbotActive = false
local espAllActive = false
local flyActive = false
local noclipConnection = nil
local espHighlights = {}
local xrayParts = {}
local flyConnection = nil

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

-- ESP Murder
local function updateEspMurder(state)
espMurderActive = state
if state then
for _, v in pairs(game.Players:GetPlayers()) do
if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
if getPlayerRole(v) == "murderer" then
local hl = Instance.new("Highlight")
hl.Parent = v.Character
hl.Adornee = v.Character
hl.FillColor = Color3.fromRGB(255, 0, 0)
hl.FillTransparency = 0.3
hl.OutlineColor = Color3.fromRGB(255, 255, 255)
hl.OutlineTransparency = 0
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
espHighlights[v] = hl
end
end
end
else
for _, hl in pairs(espHighlights) do
if hl then hl:Destroy() end
end
espHighlights = {}
end
end

-- ESP Sheriff
local function updateEspSheriff(state)
espSheriffActive = state
if state then
for _, v in pairs(game.Players:GetPlayers()) do
if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
if getPlayerRole(v) == "sheriff" then
local hl = Instance.new("Highlight")
hl.Parent = v.Character
hl.Adornee = v.Character
hl.FillColor = Color3.fromRGB(0, 100, 255)
hl.FillTransparency = 0.3
hl.OutlineColor = Color3.fromRGB(255, 255, 255)
hl.OutlineTransparency = 0
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
espHighlights[v] = hl
end
end
end
else
for _, hl in pairs(espHighlights) do
if hl then hl:Destroy() end
end
espHighlights = {}
end
end

-- X-Ray
local function updateXRay(state, strength)
xrayActive = state
if state then
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("Part") or v:IsA("MeshPart") then
if v.Material ~= Enum.Material.Neon and v.Name ~= "Handle" then
local origTrans = v.Transparency
v.Transparency = math.clamp(strength / 100, 0.2, 0.85)
xrayParts[v] = origTrans
end
end
end
else
for v, origTrans in pairs(xrayParts) do
if v and v.Parent then v.Transparency = origTrans end
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
if part:IsA("BasePart") then part.CanCollide = false end
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
if part:IsA("BasePart") then part.CanCollide = true end
end
end
end
end

-- Fly
local function updateFly(state)
flyActive = state
if state then
if flyConnection then flyConnection:Disconnect() end
humanoid.PlatformStand = true
flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
if flyActive and root then
local move = Vector3.new(0, 0, 0)
local input = game:GetService("UserInputService")
local cam = workspace.CurrentCamera
if input:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector * 50 end
if input:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector * 50 end
if input:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector * 50 end
if input:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector * 50 end
if input:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 50, 0) end
if input:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 50, 0) end
root.Velocity = move
end
end)
else
if flyConnection then
flyConnection:Disconnect()
flyConnection = nil
end
humanoid.PlatformStand = false
end
end

-- Teleport functions
local function teleportToMurderer()
for _, v in pairs(game.Players:GetPlayers()) do
if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and getPlayerRole(v) == "murderer" then
root.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
break
end
end
end

local function teleportToSheriff()
for _, v in pairs(game.Players:GetPlayers()) do
if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and getPlayerRole(v) == "sheriff" then
root.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
break
end
end
end

local function teleportToSpawn()
local spawn = workspace:FindFirstChild("SpawnLocation")
if spawn then
root.CFrame = spawn.CFrame * CFrame.new(0, 2, 0)
end
end

-- Auto Shoot
local function updateAutoShoot(state)
autoShootActive = state
end

game:GetService("RunService").Heartbeat:Connect(function()
if autoShootActive then
for _, v in pairs(game.Players:GetPlayers()) do
if v ~= player and v.Character and v.Character:FindFirstChild("Knife") then
local target = v.Character.HumanoidRootPart
if target then
local gun = character:FindFirstChildOfClass("Tool")
if gun and gun.Name == "Gun" then
root.CFrame = CFrame.lookAt(root.Position, target.Position)
wait(0.02)
mm2.Shoot:FireServer(target)
else
local gunItem = player.Backpack:FindFirstChild("Gun")
if gunItem then gunItem.Parent = character wait(0.1) end
end
end
break
end
end
end
end)

-- Auto Fling
local function updateFling(state)
flingActive = state
end

game:GetService("RunService").Heartbeat:Connect(function()
if flingActive then
for _, v in pairs(game.Players:GetPlayers()) do
if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
if v.Backpack:FindFirstChild("Gun") then
v.Character.HumanoidRootPart.Velocity = Vector3.new(0, 150, 0)
end
end
end
end
end)

-- Aimbot
local function updateAimbot(state)
aimbotActive = state
end

game:GetService("RunService").Heartbeat:Connect(function()
if aimbotActive then
local target = nil
local dist = math.huge
for _, v in pairs(game.Players:GetPlayers()) do
if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
local d = (root.Position - v.Character.HumanoidRootPart.Position).Magnitude
if d < dist then
dist = d
target = v
end
end
end
if target then
root.CFrame = CFrame.lookAt(root.Position, target.Character.HumanoidRootPart.Position)
end
end
end)

-- Build GUI
local y = 5

addSection("═══════ MAIN ═══════", y)
y = y + 30
addToggle("No Clip", y, updateNoclip)
y = y + 33
addToggle("Fly (WASD/Space)", y, updateFly)
y = y + 33
addToggle("Auto Fling Sheriff", y, updateFling)
y = y + 33
addToggle("Aimbot", y, updateAimbot)
y = y + 33
addToggle("Auto Shoot Murderer", y, updateAutoShoot)
y = y + 33

addSection("═══════ VISUAL ═══════", y)
y = y + 30
addToggle("ESP Murder (Red)", y, updateEspMurder)
y = y + 33
addToggle("ESP Sheriff (Blue)", y, updateEspSheriff)
y = y + 33
addToggle("Gun ESP", y, function(state)
gunEspActive = state
end)
y = y + 33
addToggle("X-Ray", y, function(s) updateXRay(s, 50) end)
y = y + 33
addSlider("X-Ray Strength", y, function(v) if xrayActive then updateXRay(true, v) end end)
y = y + 47

addSection("═══════ TELEPORT ═══════", y)
y = y + 30
addButton("Teleport to Spawn", y, Color3.fromRGB(40, 60, 80), teleportToSpawn)
y = y + 33
addButton("Teleport to Murderer", y, Color3.fromRGB(80, 40, 40), teleportToMurderer)
y = y + 33
addButton("Teleport to Sheriff", y, Color3.fromRGB(40, 40, 80), teleportToSheriff)
y = y + 33

addSection("═══════ EXTRA ═══════", y)
y = y + 30
addToggle("Auto Collect Gun", y, function(state)
if state then
game:GetService("RunService").Heartbeat:Connect(function()
if state then
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("Part") and v.Name == "Handle" and v.Parent and v.Parent:IsA("Tool") then
if (root.Position - v.Position).Magnitude < 20 then
mm2.Knife:FireServer(v.Parent)
end
end
end
end
end)
end
end)
y = y + 33
addToggle("Auto Respawn", y, function(state)
if state then
player.CharacterAdded:Connect(function()
wait(0.5)
character = player.Character
humanoid = character:WaitForChild("Humanoid")
root = character:WaitForChild("HumanoidRootPart")
end)
end
end)
y = y + 33
addToggle("Speed Boost", y, function(state)
if state then
humanoid.WalkSpeed = 40
else
humanoid.WalkSpeed = 16
end
end)
y = y + 33
addToggle("Infinite Jump", y, function(state)
if state then
game:GetService("UserInputService").JumpRequest:Connect(function()
if state then
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
wait(0.02)
root.Velocity = Vector3.new(root.Velocity.X, 60, root.Velocity.Z)
end
end)
end
end)
y = y + 33

addSection("═══════ FUN ═══════", y)
y = y + 30
addToggle("Super Jump", y, function(state)
if state then
humanoid.JumpPower = 200
else
humanoid.JumpPower = 50
end
end)
y = y + 33
addToggle("Bhop", y, function(state)
if state then
game:GetService("RunService").Heartbeat:Connect(function()
if state and root then
if root.Velocity.Magnitude > 10 then
root.Velocity = root.Velocity + Vector3.new(0, 20, 0)
end
end
end)
end
end)
y = y + 33
addToggle("Spin", y, function(state)
if state then
game:GetService("RunService").Heartbeat:Connect(function()
if state and root then
root.CFrame = root.CFrame * CFrame.Angles(0, 0.1, 0)
end
end)
end
end)

-- Close/Minimize toggle
closeBtn.MouseButton1Click:Connect(function()
screenGui:Destroy()
end)

local minimized = false
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
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

minBtn.MouseButton1Click:Connect(function()
minimized = not minimized
window.Visible = not minimized
minBtn.Text = minimized and "□" or "─"
if minimized then
toggleBtn.Visible = false
end
end)

-- Gun ESP
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
hl.FillTransparency = 0.25
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

print("furdjehub loaded!")
