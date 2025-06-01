-- ⛓️ Carregando Rayfield com segurança
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
if not Rayfield then
	return warn("Falha ao carregar Rayfield")
end

-- 🪟 Janela principal
local Window = Rayfield:CreateWindow({
	Name = "NovaHubX | Grow a Garden",
	LoadingTitle = "NovaHubX",
	LoadingSubtitle = "by nobody :)",
	ConfigurationSaving = {Enabled = false},
	Discord = {Enabled = false},
	KeySystem = false
})

-- 🔁 Variáveis de controle
local autoFarm, autoSell, autoBuy, autoDuplicate = false, false, false, false
local farmCoroutine, sellCoroutine, buyCoroutine, duplicateCoroutine = nil, nil, nil, nil

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events", 10)
local SellEvent = Events and Events:FindFirstChild("Sell")
local BuySeedEvent = Events and Events:FindFirstChild("BuySeed")
local DuplicateSeedEvent = Events and Events:FindFirstChild("DuplicateSeed") -- hipotético

-- 🌱 Funções
local function StartAutoFarm()
	if farmCoroutine then return end
	farmCoroutine = coroutine.create(function()
		while autoFarm do
			for _, plot in pairs(workspace.Plots:GetChildren()) do
				if plot:FindFirstChild("ClickDetector") then
					pcall(function() fireclickdetector(plot.ClickDetector) end)
				end
			end
			task.wait(0.5)
		end
		farmCoroutine = nil
	end)
	coroutine.resume(farmCoroutine)
end

local function StartAutoSell()
	if sellCoroutine then return end
	sellCoroutine = coroutine.create(function()
		while autoSell do
			if SellEvent then
				pcall(function() SellEvent:FireServer() end)
			end
			task.wait(1)
		end
		sellCoroutine = nil
	end)
	coroutine.resume(sellCoroutine)
end

local function StartAutoBuy()
	if buyCoroutine then return end
	buyCoroutine = coroutine.create(function()
		while autoBuy do
			if BuySeedEvent then
				pcall(function() BuySeedEvent:FireServer("Fruit") end)
			end
			task.wait(2)
		end
		buyCoroutine = nil
	end)
	coroutine.resume(buyCoroutine)
end

local function StartSeedDuplicate()
	if duplicateCoroutine then return end
	duplicateCoroutine = coroutine.create(function()
		while autoDuplicate do
			if DuplicateSeedEvent then
				pcall(function() DuplicateSeedEvent:FireServer() end)
			end
			task.wait(3)
		end
		duplicateCoroutine = nil
	end)
	coroutine.resume(duplicateCoroutine)
end

-- 📦 Aba Farm
local FarmTab = Window:CreateTab("🌱 Farm", 1234567890)

FarmTab:CreateToggle({
	Name = "Auto Farm",
	CurrentValue = false,
	Callback = function(Value)
		autoFarm = Value
		if autoFarm then StartAutoFarm() end
	end,
})

FarmTab:CreateToggle({
	Name = "Auto Sell",
	CurrentValue = false,
	Callback = function(Value)
		autoSell = Value
		if autoSell then StartAutoSell() end
	end,
})

-- 🛒 Aba Loja
local ShopTab = Window:CreateTab("🛒 Loja", 1234567890)

ShopTab:CreateToggle({
	Name = "Auto Comprar Frutas",
	CurrentValue = false,
	Callback = function(Value)
		autoBuy = Value
		if autoBuy then StartAutoBuy() end
	end,
})

-- 🧪 Aba Cheats
local CheatTab = Window:CreateTab("🧪 Cheats", 1234567890)

CheatTab:CreateSlider({
	Name = "Speed Hack",
	Range = {16, 100},
	Increment = 1,
	Suffix = "Velocidade",
	CurrentValue = 16,
	Callback = function(Value)
		local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = Value end
	end,
})

CheatTab:CreateToggle({
	Name = "Auto Duplicar Sementes",
	CurrentValue = false,
	Callback = function(Value)
		autoDuplicate = Value
		if autoDuplicate then StartSeedDuplicate() end
	end,
})

-- 📣 Notificação
Rayfield:Notify({
	Title = "NovaHubX",
	Content = "Script carregado com sucesso!",
	Duration = 5
})
