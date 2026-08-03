--[[ 
  furdjehub loader
  Загружает оригинальный KitagawaHub и переименовывает GUI на furdjehub
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Запоминаем, какие ScreenGui уже были
local existingGuis = {}
for _, gui in ipairs(PlayerGui:GetChildren()) do
	if gui:IsA("ScreenGui") then
		existingGuis[gui] = true
	end
end

-- Запускаем оригинальный скрипт
loadstring(game:HttpGet("https://raw.githubusercontent.com/Terfiscript1/KitagawaHub/refs/heads/main/kitagawahub"))()

-- Ждём появления нового GUI и переименовываем
task.spawn(function()
	local attempts = 0
	while attempts < 50 do -- максимум ~5 секунд
		task.wait(0.1)
		attempts += 1

		for _, gui in ipairs(PlayerGui:GetChildren()) do
			if gui:IsA("ScreenGui") and not existingGuis[gui] then
				-- Нашли новый GUI от KitagawaHub
				gui.Name = "furdjehub"

				-- Пробуем поменять текст заголовка
				for _, obj in ipairs(gui:GetDescendants()) do
					if obj:IsA("TextLabel") or obj:IsA("TextButton") then
						local text = tostring(obj.Text):lower()
						if text:find("kitagawa") or text:find("hub") or text:find("v1") then
							obj.Text = obj.Text:gsub("[Kk]itagawa[Hh]ub", "furdjehub")
							obj.Text = obj.Text:gsub("Kitagawa", "furdje")
						end
					end
				end

				print("✅ GUI успешно переименован в furdjehub")
				return
			end
		end
	end
	warn("⚠️ Не удалось найти GUI KitagawaHub для переименования")
end)
