--------------------------------------------------
-- TOGGLE
--------------------------------------------------
if getgenv().ESP_OTHER_ITEMS then
	getgenv().ESP_OTHER_ITEMS = false

	-- 🧹 borrar todos los ESP
	for _,v in pairs(workspace:GetDescendants()) do
		if v.Name == "ESP_OTHER" then
			v:Destroy()
		end
	end

	return
end

getgenv().ESP_OTHER_ITEMS = true
--------------------------------------------------

repeat task.wait() until game:IsLoaded()

local itemsFolder = workspace:WaitForChild("Map")
	:WaitForChild("Util")
	:WaitForChild("Items")

-- 🔥 excluir
local excluded = {
	Bandage = true,
	Medkit = true,

	Cake = true,
	Burger = true,
	Cola = true,
	Hotdog = true,
	Ham = true,

	GreenCube = true,
	RedCube = true,
	BlueCube = true,

	SingleToken = true,
	Katana = true,

	SodaGun = true,
	AR = true,
	GoldAR = true,
	Pistol = true,
	GoldMinigun = true,
	M4A1 = true,
	Mac10 = true,
	ScrappySMG = true,
	PumpShotgun = true,
	ScrappyShotgun = true
}

local function isAmmo(name)
	return string.find(name, "^Ammo")
end

--------------------------------------------------
-- FUNCIONES
--------------------------------------------------

local function removeESP(part)
	local esp = part:FindFirstChild("ESP_OTHER")
	if esp then esp:Destroy() end
end

local function createESP(tool)

	if not getgenv().ESP_OTHER_ITEMS then return end
	if excluded[tool.Name] then return end
	if isAmmo(tool.Name) then return end

	local handle = tool:FindFirstChild("Handle")
	if not handle or not handle:IsA("BasePart") then return end

	if handle:FindFirstChild("ESP_OTHER") then return end

	local box = Instance.new("BoxHandleAdornment")
	box.Name = "ESP_OTHER"
	box.Adornee = handle
	box.AlwaysOnTop = true
	box.Size = handle.Size
	box.Color3 = Color3.fromRGB(255,255,255)
	box.Transparency = 0.3
	box.ZIndex = 10
	box.Parent = handle

	-- 🔄 auto actualizar tamaño
	handle:GetPropertyChangedSignal("Size"):Connect(function()
		if box and box.Parent and getgenv().ESP_OTHER_ITEMS then
			box.Size = handle.Size
		end
	end)

end

local function update(tool)

	if not getgenv().ESP_OTHER_ITEMS then return end
	if not tool:IsA("Tool") then return end

	local handle = tool:FindFirstChild("Handle")
	if not handle then return end

	if tool.Parent == itemsFolder then
		createESP(tool)
	else
		removeESP(handle)
	end

end

--------------------------------------------------
-- EXISTENTES
--------------------------------------------------
for _, tool in pairs(itemsFolder:GetChildren()) do
	update(tool)

	tool.AncestryChanged:Connect(function()
		update(tool)
	end)
end

--------------------------------------------------
-- NUEVOS
--------------------------------------------------
itemsFolder.ChildAdded:Connect(function(tool)
	task.wait(0.2)
	update(tool)

	tool.AncestryChanged:Connect(function()
		update(tool)
	end)
end)
