-- furdjehub - Murder Mystery 2 (Working GUI)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local mm2 = game:GetService("ReplicatedStorage").Remotes

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "furdjehub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Window
local window = Instance.new("Frame")
window.Size = UDim2.new(0, 600, 0, 400)
window.Position = UDim2.new(0.5, -300, 0.5, -200)
window.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
window.BackgroundTransparency = 0
window.BorderSizePixel = 0
window.Parent = screenGui
window.Visible = true

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
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

-- Buttons
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -90, 0, 2)
minBtn.Text = "─"
minBtn.TextSize = 14
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 2)
closeBtn.Text = "✕"
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

closeBtn.MouseEnter:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
end)
closeBtn.MouseLeave:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
end)

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -35)
content.Position = UDim2.new(0, 0, 0, 35)
content.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
content.BorderSizePixel = 0
content.Parent = window

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

-- ESP variables
local espHighlights = {}
local espActive = false

-- ESP Functions
local function updateEspMurder(state)
    if not state then
        for _, hl in pairs(espHighlights) do pcall(function() hl:Destroy() end) end
        espHighlights = {}
        return
    end
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

local function updateEspSheriff(state)
    if not state then
        for _, hl in pairs(espHighlights) do pcall(function() hl:Destroy() end) end
        espHighlights = {}
        return
    end
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

-- Noclip
local function updateNoclip(state)
    if state then
        game:GetService("RunService").Stepped:Connect(function()
            if state and character and root then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Fly
local function updateFly(state)
    if state then
        humanoid.PlatformStand = true
        game:GetService("RunService").Heartbeat:Connect(function()
            if state and root then
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
        humanoid.PlatformStand = false
    end
end

-- Build GUI
local y = 5
y = addSection("═══════ MAIN ═══════", y)
y = addToggle("No Clip", y, updateNoclip)
y = addToggle("Fly (WASD/Space)", y, updateFly)

y = addSection("═══════ VISUAL ═══════", y)
y = addToggle("ESP Murder (Red)", y, updateEspMurder)
y = addToggle("ESP Sheriff (Blue)", y, updateEspSheriff)

y = addSection("═══════ TELEPORT ═══════", y)
y = addButton("Teleport to Lobby", y, Color3.fromRGB(40, 60, 80), teleportToSpawn)
y = addButton("Teleport to Murderer", y, Color3.fromRGB(80, 40, 40), teleportToMurderer)
y = addButton("Teleport to Sheriff", y, Color3.fromRGB(40, 40, 80), teleportToSheriff)

y = addSection("═══════ EXTRA ═══════", y)
y = addToggle("Speed Boost", y, function(state)
    if state then humanoid.WalkSpeed = 40 else humanoid.WalkSpeed = 16 end
end)
y = addToggle("Super Jump", y, function(state)
    if state then humanoid.JumpPower = 200 else humanoid.JumpPower = 50 end
end)

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 50)
toggleBtn.Position = UDim2.new(0, 15, 0, 15)
toggleBtn.Text = "📂"
toggleBtn.TextSize = 20
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
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

print("furdjehub loaded! (600x400)")
