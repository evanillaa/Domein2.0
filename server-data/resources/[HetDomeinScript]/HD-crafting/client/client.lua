local LoggedIn = false
HDCore = nil

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
        Citizen.Wait(250)
		HDCore.Functions.TriggerCallback('HD-crafting:server:get:config', function(ConfigData)
			Config.Locations = ConfigData
		end)
		SetupWeaponInfo()
		ItemsToItemInfo()
        LoggedIn = true
    end)
end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(4)
-- 		if LoggedIn then
-- 			NearLocation = false
-- 			local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
-- 			local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['X'], Config.Locations['Y'], Config.Locations['Z'], true)
-- 			if Distance < 2 then
-- 				NearLocation = true
-- 				DrawMarker(2, Config.Locations['X'], Config.Locations['Y'], Config.Locations['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
-- 				if IsControlJustReleased(0, 38) then
-- 					local Crating = {}
-- 					Crating.label = "Wapen werkbank"
-- 					Crating.items = GetThresholdWeapons()
-- 					TriggerServerEvent('HD-inventory:server:set:inventory:disabled', true)
-- 					TriggerServerEvent("HD-inventory:server:OpenInventory", "crafting_weapon", math.random(1, 99), Crating)
-- 				end
-- 			end
-- 			if not NearLocation then
-- 				Citizen.Wait(1500)
-- 			end
-- 		end
-- 	end
-- end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LoggedIn then
		    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1)), true
		    local CraftObject = GetClosestObjectOfType(PlayerCoords, 2.0, -573669520, false, false, false)
		    if CraftObject ~= 0 then
		    	NearObject = false
		    	local ObjectCoords = GetEntityCoords(CraftObject)
		    	if GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, ObjectCoords.x, ObjectCoords.y, ObjectCoords.z, true) < 1.5 then
		    		NearObject = true
		    		DrawText3D(ObjectCoords.x, ObjectCoords.y, ObjectCoords.z + 1.0, "~g~E~w~ - Craft")
		    		if IsControlJustReleased(0, 38) then
						SetupWeaponInfo()
						ItemsToItemInfo()
		    			local Crating = {}
		    			Crating.label = "Werkbank"
		    			Crating.items = GetThresholdItems()
						TriggerServerEvent('HD-inventory:server:set:inventory:disabled', true)
		    			TriggerServerEvent("HD-inventory:server:OpenInventory", "crafting", math.random(1, 99), Crating)
		    		end
		    	end
		    end
		    if not NearObject then
		    	Citizen.Wait(1000)
			end
		end
	end
end)

-- // Function \\ --

function GetThresholdItems()
	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		if HDCore.Functions.GetPlayerData().metadata["craftingrep"] >= Config.CraftingItems[k].threshold then
			items[k] = Config.CraftingItems[k]
		end
	end
	return items
end

function GetThresholdWeapons()
	local items = {}
	for k, item in pairs(Config.CraftingWeapons) do
		items[k] = Config.CraftingWeapons[k]
	end
	return items
end

function ItemsToItemInfo()
	itemInfos = {
		[1] = {costs = HDCore.Shared.Items["metalscrap"]["label"] .. ": 22x, " ..HDCore.Shared.Items["plastic"]["label"] .. ": 32x."},
		[2] = {costs = HDCore.Shared.Items["metalscrap"]["label"] .. ": 30x, " ..HDCore.Shared.Items["plastic"]["label"] .. ": 42x."},
		[3] = {costs = HDCore.Shared.Items["metalscrap"]["label"] .. ": 30x, " ..HDCore.Shared.Items["plastic"]["label"] .. ": 45x, "..HDCore.Shared.Items["aluminum"]["label"] .. ": 28x."},
		[4] = {costs = HDCore.Shared.Items["plastic"]["label"] .. ": 16x."},
		[5] = {costs = HDCore.Shared.Items["metalscrap"]["label"] .. ": 36x, " ..HDCore.Shared.Items["steel"]["label"] .. ": 24x, "..HDCore.Shared.Items["aluminum"]["label"] .. ": 28x."},
		[6] = {costs = HDCore.Shared.Items["metalscrap"]["label"] .. ": 50x, " ..HDCore.Shared.Items["steel"]["label"] .. ": 37x, "..HDCore.Shared.Items["copper"]["label"] .. ": 26x."},
		[7] = {costs = HDCore.Shared.Items["iron"]["label"] .. ": 33x, " ..HDCore.Shared.Items["steel"]["label"] .. ": 44x, "..HDCore.Shared.Items["plastic"]["label"] .. ": 55x, "..HDCore.Shared.Items["aluminum"]["label"] .. ": 22x."},
		[8] = {costs = HDCore.Shared.Items["metalscrap"]["label"] .. ": 32x, " ..HDCore.Shared.Items["steel"]["label"] .. ": 43x, "..HDCore.Shared.Items["plastic"]["label"] .. ": 61x."},
		[9] = {costs = HDCore.Shared.Items["iron"]["label"] .. ": 60x, " ..HDCore.Shared.Items["glass"]["label"] .. ": 30x."},
		[10] = {costs = HDCore.Shared.Items["aluminum"]["label"] .. ": 60x, " ..HDCore.Shared.Items["glass"]["label"] .. ": 30x."},
	}
	local items = {}
	for k, item in pairs(Config.CraftingItems) do
		local itemInfo = HDCore.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = itemInfos[item.slot],
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.CraftingItems = items
end

function SetupWeaponInfo()
	local items = {}
	for k, item in pairs(Config.CraftingWeapons) do
		local itemInfo = HDCore.Shared.Items[item.name:lower()]
		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = item.info,
			label = itemInfo["label"],
			description = item.description,
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["image"],
			slot = item.slot,
			costs = item.costs,
			threshold = item.threshold,
			points = item.points,
		}
	end
	Config.CraftingWeapons = items
end

function DrawText3D(x, y, z, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x,y,z, 0)
  DrawText(0.0, 0.0)
  ClearDrawOrigin()
end