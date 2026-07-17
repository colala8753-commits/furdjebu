-- furdjehub - Murder Mystery 2 (Stable GUI)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local mm2 = game:GetService("ReplicatedStorage").Remotes

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "furdjehub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Window 600x400
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

-- Content with scrolling
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

-- Use a list layout inside a frame
local list = Instance.new("Frame")
list.Size = UDim2.new(1, 0, 0, 0)
list.BackgroundTransparency = 1
list.Parent = scrollFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = list

local function addSection(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 25)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(180, 180, 220)
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.SourceSansSemibold
    lbl.Parent = list
    return lbl
end

local function addToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 28)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.SourceSans
    btn.Parent = list
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(50, 50, 70)
        callback(state)
    end)
    return btn
end

local function addButton(text, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 28)
    btn.Text = text
    btn.BackgroundColor3 = color or Color3.fromRGB(55, 55, 80)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.SourceSans
    btn.Parent = list
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function addSlider(text, min, max, default, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 18)
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.BackgroundTransparency = 1
    label.Parent = list
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 22)
    btn.Text = "◀ " .. default .. " ▶"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.SourceSans
    btn.Parent = list
    
    local value = default
    btn.MouseButton1Click:Connect(function()
        value = value + 2
        if value > max then value = min end
        btn.Text = "◀ " .. value .. " ▶"
        label.Text = text .. ": " .. value
        callback(value)
    end)
    return btn
end

-- Update list height after adding items
local function updateListHeight()
    local totalHeight = 0
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            totalHeight = totalHeight + child.Size.Y.Offset + layout.Padding.Offset
        end
    end
    list.Size = UDim2.new(1, 0, 0, totalHeight)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
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
local noclipConnection = nil
local autoGrabConnection = nil
local oldPosition = nil
local isGrabbing = false

-- ESP Functions
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

-- Noclip
local function updateNoclip(state)
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    if state then
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            if character and root then
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

-- Auto Grab Gun
local function updateAutoGrab(state)
    if autoGrabConnection then
        autoGrabConnection:Disconnect()
        autoGrabConnection = nil
    end
    if state then
        autoGrabConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if state and root and not isGrabbing then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Part") and v.Name == "Handle" and v.Parent and v.Parent:IsA("Tool") then
                        local dist = (root.Position - v.Position).Magnitude
                        if dist < 200 and dist > 5 then
                            isGrabbing = true
                            oldPosition = root.CFrame
                            root.CFrame = v.CFrame * CFrame.new(0, 2, 0)
                            wait(0.1)
                            pcall(function()
                                mm2.Knife:FireServer(v.Parent)
                            end)
                            wait(0.1)
                            if oldPosition then
                                root.CFrame = oldPosition
                            end
                            isGrabbing = false
                            break
                        elseif dist <= 5 then
                            pcall(function()
                                mm2.Knife:FireServer(v.Parent)
                            end)
                        end
                    end
                end
            end
        end)
    end
end

-- Toggle Button (папка)
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

-- Build GUI with list
addSection("═══════ MAIN ═══════")
addToggle("No Clip", updateNoclip)
addToggle("Auto Grab Gun (TP)", updateAutoGrab)

addSection("═══════ VISUAL ═══════")
addToggle("ESP Murder (Red)", updateEspMurder)
addToggle("ESP Sheriff (Blue)", updateEspSheriff)

addSection("═══════ TELEPORT ═══════")
addButton("Teleport to Lobby", Color3.fromRGB(40, 60, 80), teleportToSpawn)
addButton("Teleport to Murderer", Color3.fromRGB(80, 40, 40), teleportToMurderer)
addButton("Teleport to Sheriff", Color3.fromRGB(40, 40, 80), teleportToSheriff)

addSection("═══════ EXTRA ═══════")
addSlider("Speed Boost", 16, 120, 16, function(value)
    humanoid.WalkSpeed = value
end)

-- Update list height after building
task.wait(0.1)
updateListHeight()

print("furdjehub loaded! (600x400) - Stable GUI with list)")
