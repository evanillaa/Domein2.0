local currentVest = nil
local currentVestTexture = nil
HDCore = nil

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
	 Citizen.Wait(250)
 end)
end)

TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end) 

-- Code

RegisterNetEvent('HD-items:client:drink')
AddEventHandler('HD-items:client:drink', function(ItemName, PropName)
	TriggerServerEvent('HDCore:Server:RemoveItem', ItemName, 1)
	--TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items[ItemName], "remove")
 Citizen.SetTimeout(1000, function()
 	TriggerEvent('HD-assets:addprop:with:anim', PropName, 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 10000)
 	HDCore.Functions.Progressbar("drink", "Drinking..", 6000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	 }, {}, {}, {}, function() -- Done
		 exports['HD-assets']:RemoveProp()
		 TriggerServerEvent("HDCore:Server:SetMetaData", "thirst", HDCore.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
	 end, function()
		exports['HD-assets']:RemoveProp()
 		HDCore.Functions.Notify("Cancelled..", "error")
		 TriggerServerEvent('HDCore:Server:AddItem', ItemName, 1)
		 --TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items[ItemName], "add")
 	end)
 end)
end)

RegisterNetEvent('HD-items:client:drink:alcohol')
AddEventHandler('HD-items:client:drink:alcohol', function(ItemName, PropName)
	if not exports['HD-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
    	 	Citizen.SetTimeout(1000, function()
    			exports['HD-assets']:AddProp(PropName)
    			TriggerEvent('HD-inventory:client:set:busy', true)
    			exports['HD-assets']:RequestAnimationDict("amb@world_human_drinking@coffee@male@idle_a")
    			TaskPlayAnim(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    	 		HDCore.Functions.Progressbar("drink", "Drinking..", 10000, false, true, {
    	 			disableMovement = false,
    	 			disableCarMovement = false,
    	 			disableMouse = false,
    	 			disableCombat = true,
    			 }, {}, {}, {}, function() -- Done
					 DoingSomething = false
    				 exports['HD-assets']:RemoveProp()
    				 TriggerEvent('HD-inventory:client:set:busy', false)
    				 TriggerServerEvent('HDCore:Server:RemoveItem', ItemName, 1)
    				 TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items[ItemName], "remove")
    				 StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    				 TriggerServerEvent("HDCore:Server:SetMetaData", "thirst", HDCore.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
             		TriggerEvent('fullsatan:GetDrunk')
 
    			 end, function()
					DoingSomething = false
    				exports['HD-assets']:RemoveProp()
    				TriggerEvent('HD-inventory:client:set:busy', false)
    	 			HDCore.Functions.Notify("Cancelled..", "error")
    				StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    	 		end)
    	 	end)
		end
	end
end)

RegisterNetEvent('HD-items:client:drink:slushy')
AddEventHandler('HD-items:client:drink:slushy', function()
	TriggerServerEvent('HDCore:Server:RemoveItem', 'slushy', 1)
	--TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['slushy'], "remove")
 Citizen.SetTimeout(1000, function()
 	TriggerEvent('HD-assets:addprop:with:anim', 'Cup', 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 10000)
 	HDCore.Functions.Progressbar("drink", "Drinking..", 6000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	 }, {}, {}, {}, function() -- Done
		 exports['HD-assets']:RemoveProp()
		 TriggerServerEvent('HD-hud:server:remove:stress', math.random(12, 20))
		 TriggerServerEvent("HDCore:Server:SetMetaData", "thirst", HDCore.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
	 end, function()
		exports['HD-assets']:RemoveProp()
 		HDCore.Functions.Notify("Cancelled..", "error")
		 TriggerServerEvent('HDCore:Server:AddItem', 'slushy', 1)
		 --TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['slushy'], "add")
 	end)
 end)
end)

RegisterNetEvent('HD-items:client:eat')
AddEventHandler('HD-items:client:eat', function(ItemName, PropName)
	if not exports['HD-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
 			Citizen.SetTimeout(1000, function()
				exports['HD-assets']:AddProp(PropName)
				TriggerEvent('HD-inventory:client:set:busy', true)
				exports['HD-assets']:RequestAnimationDict("mp_player_inteat@burger")
				TaskPlayAnim(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 8.0, 1.0, -1, 49, 0, 0, 0, 0)
 				HDCore.Functions.Progressbar("eat", "Eating..", 10000, false, true, {
 					disableMovement = false,
 					disableCarMovement = false,
 					disableMouse = false,
 					disableCombat = true,
				 }, {}, {}, {}, function() -- Done
					 DoingSomething = false
					 exports['HD-assets']:RemoveProp()
					 TriggerEvent('HD-inventory:client:set:busy', false)
					 TriggerServerEvent('HD-hud:server:remove:stress', math.random(6, 10))
					 TriggerServerEvent('HDCore:Server:RemoveItem', ItemName, 1)
					 StopAnimTask(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
					 TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items[ItemName], "remove")
					 if ItemName == 'burger-heartstopper' then
						TriggerServerEvent("HDCore:Server:SetMetaData", "hunger", HDCore.Functions.GetPlayerData().metadata["hunger"] + math.random(40, 50))
					 else
						TriggerServerEvent("HDCore:Server:SetMetaData", "hunger", HDCore.Functions.GetPlayerData().metadata["hunger"] + math.random(20, 35))
					 end
				 	end, function()
					DoingSomething = false
					exports['HD-assets']:RemoveProp()
					TriggerEvent('HD-inventory:client:set:busy', false)
 					HDCore.Functions.Notify("Canceled..", "error")
					StopAnimTask(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
 				end)
 			end)
		end
	end
end)

RegisterNetEvent('HD-items:client:use:armor')
AddEventHandler('HD-items:client:use:armor', function()
 local CurrentArmor = GetPedArmour(PlayerPedId())
 if CurrentArmor <= 100 and CurrentArmor + 33 <= 100 then
	local NewArmor = CurrentArmor + 33
	if CurrentArmor + 33 >= 100 or CurrentArmor >= 100 then NewArmor = 100 end
	TriggerServerEvent('HDCore:Server:RemoveItem', 'armor', 1)
	--TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['armor'], "remove")
     HDCore.Functions.Progressbar("vest", "Putting on vest..", 1000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
     }, {}, {}, {}, function() -- Done
   	 	 SetPedArmour(PlayerPedId(), NewArmor)
		 TriggerServerEvent('HD-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
     	 HDCore.Functions.Notify("Success", "success")
     end, function()
     	HDCore.Functions.Notify("Cancelled..", "error")
		 TriggerServerEvent('HDCore:Server:AddItem', 'armor', 1)
    	 --TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['armor'], "add")
     end)
 else
	HDCore.Functions.Notify("You are already wearing an armor..", "error")
 end
end)

RegisterNetEvent("HD-items:client:use:heavy")
AddEventHandler("HD-items:client:use:heavy", function()
	TriggerServerEvent('HDCore:Server:RemoveItem', 'heavy-armor', 1)
    local Sex = "Man"
    if HDCore.Functions.GetPlayerData().charinfo.gender == 1 then
      Sex = "Vrouw"
    end
    HDCore.Functions.Progressbar("use_heavyarmor", "Putting on vest..", 5000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		--TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['heavy-armor'], "remove")
        if Sex == 'Man' then
        currentVest = GetPedDrawableVariation(PlayerPedId(), 9)
        currentVestTexture = GetPedTextureVariation(PlayerPedId(), 9)
        if GetPedDrawableVariation(PlayerPedId(), 9) == 7 then
            SetPedComponentVariation(PlayerPedId(), 0, 0, GetPedTextureVariation(PlayerPedId(), 0), 0)
        else
            SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
        end
        SetPedArmour(PlayerPedId(), 100)
      else
        currentVest = GetPedDrawableVariation(PlayerPedId(), 9)
        currentVestTexture = GetPedTextureVariation(PlayerPedId(), 9)
        if GetPedDrawableVariation(PlayerPedId(), 9) == 7 then
            SetPedComponentVariation(PlayerPedId(), 9, 20, GetPedTextureVariation(PlayerPedId(), 9), 2)
        else
            SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)
        end
		SetPedArmour(PlayerPedId(), 100)
		TriggerServerEvent('HD-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
      end
    end)
end)

RegisterNetEvent("HD-items:client:reset:armor")
AddEventHandler("HD-items:client:reset:armor", function()
    local ped = PlayerPedId()
    if currentVest ~= nil and currentVestTexture ~= nil then 
        HDCore.Functions.Progressbar("remove-armor", "Taking off vest..", 2500, false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            SetPedComponentVariation(PlayerPedId(), 0, currentVest, currentVestTexture, 0)
            SetPedArmour(PlayerPedId(), 0)
			HDCore.Functions.TriggerCallback('HD-items:server:giveitem', 'heavy-armor', 1)
			TriggerServerEvent('HD-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
        end)
    else
        HDCore.Functions.Notify("You are not wearing a vest.", "error")
    end
end)

RegisterNetEvent('HD-items:client:use:repairkit')
AddEventHandler('HD-items:client:use:repairkit', function()
	local PlayerCoords = GetEntityCoords(PlayerPedId())
	local Vehicle, Distance = HDCore.Functions.GetClosestVehicle()
	if GetVehicleEngineHealth(Vehicle) < 1000.0 then
		NewHealth = GetVehicleEngineHealth(Vehicle) + 250.0
		if GetVehicleEngineHealth(Vehicle) + 250.0 > 1000.0 then 
			NewHealth = 1000.0 
		end
		if Distance < 4.0 and not IsPedInAnyVehicle(PlayerPedId()) then
			local EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, 2.5, 0)
			if IsBackEngine(GetEntityModel(Vehicle)) then
			  EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -2.5, 0)
			end
		if GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, EnginePos) < 4.0 then
			local VehicleDoor = nil
			if IsBackEngine(GetEntityModel(Vehicle)) then
				VehicleDoor = 5
			else
				VehicleDoor = 4
			end
			SetVehicleDoorOpen(Vehicle, VehicleDoor, false, false)
			TriggerServerEvent('HDCore:Server:RemoveItem', 'repairkit', 1)
			Citizen.Wait(450)
			HDCore.Functions.Progressbar("repair_vehicle", "Working On Vehicle..", math.random(10000, 20000), false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {
				animDict = "mini@repair",
				anim = "fixing_a_player",
				flags = 16,
			}, {}, {}, function() -- Done
				if math.random(1,50) < 10 then
				  TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['repairkit'], "remove")
				end
				SetVehicleDoorShut(Vehicle, VehicleDoor, false)
				StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
				HDCore.Functions.Notify("Vehicle has been repaired", "success")
				SetVehicleEngineHealth(Vehicle, NewHealth) 
				for i = 1, 6 do
				 SetVehicleTyreFixed(Vehicle, i)
				end
			end, function() -- Cancel
				StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
				HDCore.Functions.Notify("Failed!", "error")
				SetVehicleDoorShut(Vehicle, VehicleDoor, false)
			end)
		end
	 else
		HDCore.Functions.Notify("No vehicle nearby", "error")
	end
	end	
end)

RegisterNetEvent('HD-items:client:dobbel')
AddEventHandler('HD-items:client:dobbel', function(Amount, Sides)
	local DiceResult = {}
	for i = 1, Amount do
		table.insert(DiceResult, math.random(1, Sides))
	end
	local RollText = CreateRollText(DiceResult, Sides)
	TriggerEvent('HD-items:client:dice:anim')
	Citizen.SetTimeout(1900, function()
		TriggerServerEvent('HD-sound:server:play:distance', 2.0, 'dice', 0.5)
		TriggerServerEvent('HD-assets:server:display:text', RollText)
	end)
end)

RegisterNetEvent('HD-items:client:coinflip')
AddEventHandler('HD-items:client:coinflip', function()
	local CoinFlip = {}
	local Random = math.random(1,2)
     if Random <= 1 then
		CoinFlip = 'Coinflip: ~g~Heads'
     else
		CoinFlip = 'Coinflip: ~y~Tails'
	 end
	 TriggerEvent('HD-items:client:dice:anim')
	 Citizen.SetTimeout(1900, function()
		TriggerServerEvent('HD-sound:server:play:distance', 2.0, 'coin', 0.5)
		TriggerServerEvent('HD-assets:server:display:text', CoinFlip)
	 end)
end)

RegisterNetEvent('HD-items:client:dice:anim')
AddEventHandler('HD-items:client:dice:anim', function()
	exports['HD-assets']:RequestAnimationDict("anim@mp_player_intcelebrationmale@wank")
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Citizen.Wait(1500)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('HD-items:client:use:duffel-bag')
AddEventHandler('HD-items:client:use:duffel-bag', function(BagId)
    TriggerServerEvent("HD-inventory:server:OpenInventory", "stash", 'tas_'..BagId, {maxweight = 25000, slots = 3})
    TriggerEvent("HD-inventory:client:SetCurrentStash", 'tas_'..BagId)
end)
--  // Functions \\ --

function IsBackEngine(Vehicle)
    for _, model in pairs(Config.BackEngineVehicles) do
        if GetHashKey(model) == Vehicle then
            return true
        end
    end
    return false
end

function CreateRollText(rollTable, sides)
    local s = "~g~Dices~s~: "
    local total = 0
    for k, roll in pairs(rollTable, sides) do
        total = total + roll
        if k == 1 then
            s = s .. roll .. "/" .. sides
        else
            s = s .. " | " .. roll .. "/" .. sides
        end
    end
    s = s .. " | (Total: ~g~"..total.."~s~)"
    return s
end



RegisterNetEvent('HD-items:client:use:cigarette')
AddEventHandler('HD-items:client:use:cigarette', function()
  Citizen.SetTimeout(1000, function()
    HDCore.Functions.Progressbar("smoke-cigarette", "Taking out a cigarette..", 4500, false, true, {
     disableMovement = false,
     disableCarMovement = false,
     disableMouse = false,
     disableCombat = true,
     }, {}, {}, {}, function() -- Done
        TriggerServerEvent('HDCore:Server:RemoveItem', 'ciggy', 1)
        TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items["ciggy"], "remove")
        TriggerEvent('HD-items:client:smoke:effect')
        if IsPedInAnyVehicle(PlayerPedId(), false) then
			TriggerEvent('animations:client:EmoteCommandStart', {"smoke"})
        else
            TriggerEvent('animations:client:EmoteCommandStart', {"smoke2"})
		end
    end)
  end)
end)

RegisterNetEvent('HD-items:client:smoke:effect')
AddEventHandler('HD-items:client:smoke:effect', function()
  OnWeed = true
  Time = 15
  while OnWeed do
    if Time > 0 then
     Citizen.Wait(1000)
     Time = Time - 1
     TriggerServerEvent('HD-hud:server:remove:stress', math.random(1, 3))
    end
     if Time <= 0 then
      OnWeed = false
     end 
  end
end)