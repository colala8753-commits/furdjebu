-- furdjehub - Murder Mystery 2 (Full GUI with Movable Toggle)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local mm2 = game:GetService("ReplicatedStorage").Remotes

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "furdjehub"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Movable Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 15, 0, 15)
toggleBtn.Text = "📂"
toggleBtn.TextSize = 28
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = screenGui
toggleBtn.Visible = true

-- Dragging for Toggle Button
local toggleDragging = false
local toggleDragStart, toggleStartPos

toggleBtn.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
toggleDragging = true
toggleDragStart = input.Position
toggleStartPos = toggleBtn.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
toggleDragging = false
end
end)
end
end)

toggleBtn.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement and toggleDragging then
local delta = input.Position - toggleDragStart
toggleBtn.Position = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
end
end)

-- Main Window
local window = Instance.new("Frame")
window.Size = UDim2.new(0, 420, 0, 520)
window.Position = UDim2.new(0.5, -210, 0.5, -260)
window.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
window.BackgroundTransparency = 0.05
window.BorderSizePixel = 0
window.Parent = screenGui
window.Visible = true

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
titleBar.BorderSizePixel = 0
titleBar.Parent = window

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -80, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.Text = "furdjehub | MM2"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -65, 0, 2)
minBtn.Text = "─"
minBtn.TextSize = 20
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 85)
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -32, 0, 2)
closeBtn.Text = "✕"
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

-- Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -35)
scrollFrame.Position = UDim2.new(0, 0, 0, 35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
scrollFrame.Parent = window

local canvas = Instance.new("Frame")
canvas.Size = UDim2.new(1, 0, 0, 0)
canvas.BackgroundTransparency = 1
canvas.Parent = scrollFrame

-- Dragging for Window
local dragging = false
local dragStart, startPos

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

-- Toggle Button Logic
toggleBtn.MouseButton1Click:Connect(function()
if window.Visible then
window.Visible = false
else
window.Visible = true
end
end)

-- Close/Minimize
closeBtn.MouseButton1Click:Connect(function()
window.Visible = false
end)

minBtn.MouseButton1Click:Connect(function()
if window.Visible then
window.Visible = false
else
window.Visible = true
end
end)

-- GUI Elements
local function addSection(text, y)
local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.new(0.92, 0, 0, 25)
lbl.Position = UDim2.new(0.04, 0, 0, y)
lbl.Text = text
lbl.TextColor3 = Color3.fromRGB(160, 160, 210)
lbl.TextSize = 15
lbl.TextXAlignment = Enum.TextXAlignment.Center
lbl.BackgroundTransparency = 1
lbl.Parent = canvas
canvas.Size = UDim2.new(1, 0, 0, y + 30)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, y + 30)
return lbl
end

local function addToggle(text, y, callback)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.92, 0, 0, 30)
btn.Position = UDim2.new(0.04, 0, 0, y)
btn.Text = text .. ": OFF"
btn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
btn.TextColor3 = Color3.fromRGB(230, 230, 230)
btn.TextSize = 14
btn.BorderSizePixel = 0
btn.Parent = canvas
local state = false
btn.MouseButton1Click:Connect(function()
state = not state
btn.Text = text .. (state and ": ON" or ": OFF")
btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(45, 45, 70)
callback(state)
end)
canvas.Size = UDim2.new(1, 0, 0, y + 35)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, y + 35)
return btn
end

local function addButton(text, y, color, callback)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.92, 0, 0, 30)
btn.Position = UDim2.new(0.04, 0, 0, y)
btn.Text = text
btn.BackgroundColor3 = color or Color3.fromRGB(55, 55, 80)
btn.TextColor3 = Color3.fromRGB(230, 230, 230)
btn.TextSize = 14
btn.BorderSizePixel = 0
btn.Parent = canvas
btn.MouseButton1Click:Connect(callback)
canvas.Size = UDim2.new(1, 0, 0, y + 35)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, y + 35)
return btn
end

-- State Variables
local espMurder = false
local espSheriff = false
local xrayActive = false
local noclipActive = false
local flingActive = false
local autoShootActive = false
local gunEspActive = false
local aimbotActive = false
local flyActive = false
local espHighlights = {}
local xrayParts = {}
local noclipConnection = nil
local flyConnection = nil

-- Role Detection
local function getPlayerRole(v)
if v.Character and v.Character:FindFirstChild("Knife") then
return "murderer"
elseif v.Backpack:FindFirstChild("Gun") then
return "sheriff"
else
return "innocent"
end
end

-- ESP Functions
local function updateEspMurder(state)
espMurder = state
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
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
espHighlights[v] = hl
end
end
end
else
for _, hl in pairs(espHighlights) do hl:Destroy() end
espHighlights = {}
end
end

local function updateEspSheriff(state)
espSheriff = state
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
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
espHighlights[v] = hl
end
end
end
else
for _, hl in pairs(espHighlights) do hl:Destroy() end
espHighlights = {}
end
end

-- X-Ray
local function updateXRay(state)
xrayActive = state
if state then
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("Part") or v:IsA("MeshPart") then
if v.Material ~= Enum.Material.Neon and v.Name ~= "Handle" then
xrayParts[v] = v.Transparency
v.Transparency = 0.6
end
end
end
else
for v, trans in pairs(xrayParts) do
if v and v.Parent then v.Transparency = trans end
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

-- Teleport Functions
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
if spawn then root.CFrame = spawn.CFrame * CFrame.new(0, 2, 0) end
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
y = y + 35
addToggle("Fly (WASD/Space)", y, updateFly)
y = y + 35
addToggle("Auto Fling Sheriff", y, updateFling)
y = y + 35
addToggle("Aimbot", y, updateAimbot)
y = y + 35
addToggle("Auto Shoot Murderer", y, updateAutoShoot)
y = y + 35

addSection("═══════ VISUAL ═══════", y)
y = y + 30
addToggle("ESP Murder (Red)", y, updateEspMurder)
y = y + 35
addToggle("ESP Sheriff (Blue)", y, updateEspSheriff)
y = y + 35
addToggle("Gun ESP", y, function(state) gunEspActive = state end)
y = y + 35
addToggle("X-Ray", y, updateXRay)
y = y + 35

addSection("═══════ TELEPORT ═══════", y)
y = y + 30
addButton("Teleport to Spawn", y, Color3.fromRGB(40, 60, 80), teleportToSpawn)
y = y + 35
addButton("Teleport to Murderer", y, Color3.fromRGB(80, 40, 40), teleportToMurderer)
y = y + 35
addButton("Teleport to Sheriff", y, Color3.fromRGB(40, 40, 80), teleportToSheriff)
y = y + 35

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
y = y + 35
addToggle("Speed Boost", y, function(state)
if state then humanoid.WalkSpeed = 40 else humanoid.WalkSpeed = 16 end
end)
y = y + 35
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
y = y + 35

addSection("═══════ FUN ═══════", y)
y = y + 30
addToggle("Super Jump", y, function(state)
if state then humanoid.JumpPower = 200 else humanoid.JumpPower = 50 end
end)
y = y + 35
addToggle("Bhop", y, function(state)
if state then
game:GetService("RunService").Heartbeat:Connect(function()
if state and root and root.Velocity.Magnitude > 10 then
root.Velocity = root.Velocity + Vector3.new(0, 20, 0)
end
end)
end
end)
y = y + 35
addToggle("Spin", y, function(state)
if state then
game:GetService("RunService").Heartbeat:Connect(function()
if state and root then
root.CFrame = root.CFrame * CFrame.Angles(0, 0.1, 0)
end
end)
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
