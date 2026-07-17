-- furdjehub - Murder Mystery 2 (Windows 10 Style GUI)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local mm2 = game:GetService("ReplicatedStorage").Remotes

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "furdjehub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Window (600x400)
local window = Instance.new("Frame")
window.Size = UDim2.new(0, 600, 0, 400)
window.Position = UDim2.new(0.5, -300, 0.5, -200)
window.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
window.BackgroundTransparency = 0
window.BorderSizePixel = 0
window.Parent = screenGui
window.Visible = true

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
titleBar.BorderSizePixel = 0
titleBar.Parent = window

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -100, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.Text = "furdjehub | MM2"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextSize = 14
titleText.BackgroundTransparency = 1
titleText.Parent = titleBar

-- Buttons: min, max, close
local function createTitleButton(text, x)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(1, x, 0, 2)
    btn.Text = text
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.BorderSizePixel = 0
    btn.Parent = titleBar
    return btn
end

local minBtn = createTitleButton("─", -90)
local maxBtn = createTitleButton("□", -60)
local closeBtn = createTitleButton("✕", -30)

closeBtn.MouseEnter:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
end)
closeBtn.MouseLeave:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
end)

-- Content Area
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -35)
content.Position = UDim2.new(0, 0, 0, 35)
content.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
content.BorderSizePixel = 0
content.Parent = window

-- Scrolling Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -10)
scrollFrame.Position = UDim2.new(0, 5, 0, 5)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 5
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 90)
scrollFrame.Parent = content

local canvas = Instance.new("Frame")
canvas.Size = UDim2.new(1, 0, 0, 0)
canvas.BackgroundTransparency = 1
canvas.Parent = scrollFrame

-- Dragging window
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

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 15, 0, 15)
toggleBtn.Text = "📂"
toggleBtn.TextSize = 20
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = screenGui
toggleBtn.Visible = true
toggleBtn.ResetOnSpawn = false

toggleBtn.MouseButton1Click:Connect(function()
    window.Visible = not window.Visible
end)

-- Window controls
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

minBtn.MouseButton1Click:Connect(function()
    window.Visible = false
end)

local maximized = false
maxBtn.MouseButton1Click:Connect(function()
    maximized = not maximized
    if maximized then
        window.Size = UDim2.new(0, 800, 0, 500)
        window.Position = UDim2.new(0.5, -400, 0.5, -250)
        maxBtn.Text = "❐"
    else
        window.Size = UDim2.new(0, 600, 0, 400)
        window.Position = UDim2.new(0.5, -300, 0.5, -200)
        maxBtn.Text = "□"
    end
end)

-- Helper functions
local function addSection(text, y)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 25)
    lbl.Position = UDim2.new(0, 10, 0, y)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(180, 180, 220)
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.SourceSansSemibold
    lbl.Parent = canvas
    local newY = y + 30
    canvas.Size = UDim2.new(1, 0, 0, newY)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, newY)
    return newY
end

local function addToggle(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.SourceSans
    btn.Parent = canvas
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(50, 50, 70)
        callback(state)
    end)
    local newY = y + 35
    canvas.Size = UDim2.new(1, 0, 0, newY)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, newY)
    return newY
end

local function addButton(text, y, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text
    btn.BackgroundColor3 = color or Color3.fromRGB(55, 55, 80)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.SourceSans
    btn.Parent = canvas
    btn.MouseButton1Click:Connect(callback)
    local newY = y + 35
    canvas.Size = UDim2.new(1, 0, 0, newY)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, newY)
    return newY
end

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

-- ESP functions
local espHighlights = {}

local function updateEspMurder(state)
    for _, hl in pairs(espHighlights) do pcall(function() hl:Destroy() end) end
    espHighlights = {}
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
    end
end

local function updateEspSheriff(state)
    for _, hl in pairs(espHighlights) do pcall(function() hl:Destroy() end) end
    espHighlights = {}
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
    end
end

-- Teleport functions
local function teleportToSpawn()
    local spawns = workspace:GetDescendants()
    for _, v in ipairs(spawns) do
        if v:IsA("SpawnLocation") then
            root.CFrame = v.CFrame * CFrame.new(0, 2, 0)
            return
        end
    end
    local spawn = workspace:FindFirstChild("SpawnLocation")
    if spawn then root.CFrame = spawn.CFrame * CFrame.new(0, 2, 0) end
end

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

-- Build GUI (перенесено в конец, чтобы все функции были объявлены)
local y = 5
y = addSection("═══════ MAIN ═══════", y)
y = addToggle("No Clip", y, function(state) end)
y = addToggle("Fly (WASD/Space)", y, function(state) end)
y = addToggle("Auto Fling Sheriff", y, function(state) end)
y = addToggle("Aimbot", y, function(state) end)
y = addToggle("Auto Shoot Murderer", y, function(state) end)

y = addSection("═══════ VISUAL ═══════", y)
y = addToggle("ESP Murder (Red)", y, updateEspMurder)
y = addToggle("ESP Sheriff (Blue)", y, updateEspSheriff)
y = addToggle("Gun ESP", y, function(state) end)
y = addToggle("X-Ray", y, function(state) end)

y = addSection("═══════ TELEPORT ═══════", y)
y = addButton("Teleport to Lobby", y, Color3.fromRGB(40, 60, 80), teleportToSpawn)
y = addButton("Teleport to Murderer", y, Color3.fromRGB(80, 40, 40), teleportToMurderer)
y = addButton("Teleport to Sheriff", y, Color3.fromRGB(40, 40, 80), teleportToSheriff)

y = addSection("═══════ EXTRA ═══════", y)
y = addToggle("Speed Boost", y, function(state)
    if state then humanoid.WalkSpeed = 40 else humanoid.WalkSpeed = 16 end
end)
y = addToggle("Infinite Jump", y, function(state) end)
y = addToggle("Super Jump", y, function(state)
    if state then humanoid.JumpPower = 200 else humanoid.JumpPower = 50 end
end)

print("furdjehub loaded! Width 600, Height 400")
