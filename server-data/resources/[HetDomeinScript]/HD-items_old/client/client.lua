local DoingSomething = false
local currentVest = nil
local currentVestTexture = nil
HDCore = nil

local currentGear = {
    mask = 0,
    tank = 0,
    enabled = false
}
RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
	 Citizen.Wait(250)
 end)
end)

-- Code

RegisterNetEvent('HD-items:client:drink')
AddEventHandler('HD-items:client:drink', function(ItemName, PropName)
	if not exports['HD-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
    	 	Citizen.SetTimeout(1000, function()
    			exports['HD-assets']:AddProp(PropName)
    			TriggerEvent('HD-inventory:client:set:busy', true)
    			exports['HD-assets']:RequestAnimationDict("amb@world_human_drinking@coffee@male@idle_a")
    			TaskPlayAnim(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    	 		HDCore.Functions.Progressbar("drink", "Drinken..", 10000, false, true, {
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
				 
    			 end, function()
					DoingSomething = false
    				exports['HD-assets']:RemoveProp()
    				TriggerEvent('HD-inventory:client:set:busy', false)
    	 			HDCore.Functions.Notify("Geannuleerd..", "error")
    				StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    	 		end)
    	 	end)
		end
	end
end)



RegisterNetEvent('HD-items:client:drink:slushy')
AddEventHandler('HD-items:client:drink:slushy', function()
	if not exports['HD-progressbar']:GetTaskBarStatus() then
		if not DoingSomething then
		DoingSomething = true
    		Citizen.SetTimeout(1000, function()
    			exports['HD-assets']:AddProp('Cup')
    			exports['HD-assets']:RequestAnimationDict("amb@world_human_drinking@coffee@male@idle_a")
    			TaskPlayAnim(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    			TriggerEvent('HD-inventory:client:set:busy', true)
    			HDCore.Functions.Progressbar("drink", "Drinken..", 10000, false, true, {
    				disableMovement = false,
    				disableCarMovement = false,
    				disableMouse = false,
    				disableCombat = true,
    			 }, {}, {}, {}, function() -- Done
					DoingSomething = false
    				 exports['HD-assets']:RemoveProp()
    				 TriggerEvent('HD-inventory:client:set:busy', false)
    				 TriggerServerEvent('HD-hud:Server:RelieveStress', math.random(12, 20))
    				 TriggerServerEvent('HDCore:Server:RemoveItem', 'slushy', 1)
    				 TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['slushy'], "remove")
    				 StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    				 TriggerServerEvent("HDCore:Server:SetMetaData", "thirst", HDCore.Functions.GetPlayerData().metadata["thirst"] + math.random(20, 35))
    			 end, function()
					DoingSomething = false
    				exports['HD-assets']:RemoveProp()
    				TriggerEvent('HD-inventory:client:set:busy', false)
    				HDCore.Functions.Notify("Geannuleerd..", "error")
    				StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    			end)
    		end)
		end
	end
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
    	 			HDCore.Functions.Notify("Geannuleerd..", "error")
    				StopAnimTask(PlayerPedId(), 'amb@world_human_drinking@coffee@male@idle_a', "idle_c", 1.0)
    	 		end)
    	 	end)
		end
	end
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
 				HDCore.Functions.Progressbar("eat", "Eten..", 10000, false, true, {
 					disableMovement = false,
 					disableCarMovement = false,
 					disableMouse = false,
 					disableCombat = true,
				 }, {}, {}, {}, function() -- Done
					 DoingSomething = false
					 exports['HD-assets']:RemoveProp()
					 TriggerEvent('HD-inventory:client:set:busy', false)
					 TriggerServerEvent('HD-hud:Server:RelieveStress', math.random(2, 3))
					 TriggerServerEvent('HDCore:Server:RemoveItem', ItemName, 1)
					 StopAnimTask(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
					 TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items[ItemName], "remove")
					 if ItemName == 'burger-heartstopper' then
						TriggerServerEvent("HDCore:Server:SetMetaData", "hunger", HDCore.Functions.GetPlayerData().metadata["hunger"] + math.random(40, 50))
						TriggerServerEvent('HD-hud:Server:RelieveStress', math.random(22, 40))
					 else
						TriggerServerEvent("HDCore:Server:SetMetaData", "hunger", HDCore.Functions.GetPlayerData().metadata["hunger"] + math.random(20, 35))
					 end
				 	end, function()
					DoingSomething = false
					exports['HD-assets']:RemoveProp()
					TriggerEvent('HD-inventory:client:set:busy', false)
 					HDCore.Functions.Notify("Geannuleerd..", "error")
					StopAnimTask(PlayerPedId(), 'mp_player_inteat@burger', 'mp_player_int_eat_burger', 1.0)
 				end)
 			end)
		end
	end
end)

RegisterNetEvent('HD-items:client:use:armor')
AddEventHandler('HD-items:client:use:armor', function()
	if not exports['HD-progressbar']:GetTaskBarStatus() then
 		local CurrentArmor = GetPedArmour(PlayerPedId())
 		if CurrentArmor <= 100 and CurrentArmor + 50 <= 100 then
			local NewArmor = CurrentArmor + 50
			if CurrentArmor + 33 >= 100 or CurrentArmor >= 100 then NewArmor = 100 end
			 TriggerEvent('HD-inventory:client:set:busy', true)
 		    HDCore.Functions.Progressbar("vest", "Vest aantrekken..", 10000, false, true, {
 		    	disableMovement = false,
 		    	disableCarMovement = false,
 		    	disableMouse = false,
 		    	disableCombat = true,
 		    }, {}, {}, {}, function() -- Done
 		  	 	 SetPedArmour(PlayerPedId(), NewArmor)
				 TriggerEvent('HD-inventory:client:set:busy', false)
				 TriggerServerEvent('HDCore:Server:RemoveItem', 'armor', 1)
 		   	 TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['armor'], "remove")
				 TriggerServerEvent('HD-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
 		    	 HDCore.Functions.Notify("Gelukt", "success")
 		    end, function()
				TriggerEvent('HD-inventory:client:set:busy', false)
 		    	HDCore.Functions.Notify("Geannuleerd..", "error")
 		    end)
 		else
			HDCore.Functions.Notify("Je hebt al een vest om..", "error")
 		end
	end
end)

RegisterNetEvent("HD-items:client:use:heavy")
AddEventHandler("HD-items:client:use:heavy", function()
	if not exports['HD-progressbar']:GetTaskBarStatus() then
    	local Sex = "Man"
    	if HDCore.Functions.GetPlayerData().charinfo.gender == 1 then
    	  Sex = "Vrouw"
    	end
		TriggerEvent('HD-inventory:client:set:busy', true)
    	HDCore.Functions.Progressbar("use_heavyarmor", "Vest aantrekken..", 5000, false, true, {
    	disableMovement = false,
    	disableCarMovement = false,
			disableMouse = false,
			disableCombat = true,
		}, {}, {}, {}, function() -- Done
			TriggerEvent('HD-inventory:client:set:busy', false)
			TriggerServerEvent('HDCore:Server:RemoveItem', 'heavy-armor', 1)
			TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['heavy-armor'], "remove")
    	    if Sex == 'Man' then
    	    currentVest = GetPedDrawableVariation(PlayerPedId(), 9)
    	    currentVestTexture = GetPedTextureVariation(PlayerPedId(), 9)
    	    if GetPedDrawableVariation(PlayerPedId(), 9) == 7 then
    	        SetPedComponentVariation(PlayerPedId(), 9, 19, GetPedTextureVariation(PlayerPedId(), 9), 2)
    	    else
    	        SetPedComponentVariation(PlayerPedId(), 9, 57, 2, 2)
    	    end
    	    SetPedArmour(PlayerPedId(), 100)
    	  else
    	    currentVest = GetPedDrawableVariation(PlayerPedId(), 9)
    	    currentVestTexture = GetPedTextureVariation(PlayerPedId(), 9)
    	    if GetPedDrawableVariation(PlayerPedId(), 9) == 7 then
    	        SetPedComponentVariation(PlayerPedId(), 9, 20, GetPedTextureVariation(PlayerPedId(), 9), 2)
    	    else
    	        SetPedComponentVariation(PlayerPedId(), 9, 5, 0, 2)
    	    end
			SetPedArmour(PlayerPedId(), 100)
			TriggerServerEvent('HD-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
    	  end
		end, function() -- Cancel
    	    TriggerEvent('HD-inventory:client:set:busy', false)
    	    HDCore.Functions.Notify("Geannuleerd..", "error")
    	end)
	end
end)

RegisterNetEvent('HD-items:client:use:jerrycan')
AddEventHandler('HD-items:client:use:jerrycan', function()
	local PlayerCoords = GetEntityCoords(PlayerPedId())
	local Vehicle, Distance = HDCore.Functions.GetClosestVehicle()

	if not IsPedInAnyVehicle(PlayerPedId()) then
		if Distance < 3.0 and not IsPedInAnyVehicle(PlayerPedId()) then
			local EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, 2.5, 0)
			if IsBackEngine(GetEntityModel(Vehicle)) then
			  EnginePos = GetOffsetFromEntityInWorldCoords(Vehicle, 0, -2.5, 0)
			end
		if GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, EnginePos) < 4.0 then
			TriggerEvent('HD-inventory:client:set:busy', true)
			Citizen.Wait(450)
			HDCore.Functions.Progressbar("repair_vehicle", "Jerrycan leegdumpen...", math.random(10000, 20000), false, true, {
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
				  TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['jerrycan'], "remove")
				end
				TriggerServerEvent('HDCore:Server:RemoveItem', 'jerrycan', 1)
				StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
				HDCore.Functions.Notify("Voertuig is volgetankt.")
				exports['HD-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 65, false)
				TriggerEvent('HD-inventory:client:set:busy', false)
			end, function() -- Cancel
				StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
				HDCore.Functions.Notify("Mislukt!", "error")
				TriggerEvent('HD-inventory:client:set:busy', false)
			end)
		end
	 	else
		HDCore.Functions.Notify("Geen voertuig in de buurt", "error")
		end
	else
		HDCore.Functions.Notify("Je zit in een voertuig. Stap er uit.", "error")	
	end	
end)

RegisterNetEvent("HD-items:client:reset:armor")
AddEventHandler("HD-items:client:reset:armor", function()
	if not exports['HD-progressbar']:GetTaskBarStatus() then
    	local ped = PlayerPedId()
    	if currentVest ~= nil and currentVestTexture ~= nil then 
    	    HDCore.Functions.Progressbar("remove-armor", "Vest uittrekken..", 2500, false, false, {
    	        disableMovement = false,
    	        disableCarMovement = false,
    	        disableMouse = false,
    	        disableCombat = true,
    	    }, {}, {}, {}, function() -- Done
    	        SetPedComponentVariation(PlayerPedId(), 9, currentVest, currentVestTexture, 2)
    	        SetPedArmour(PlayerPedId(), 0)
				TriggerServerEvent('HD-items:server:giveitem', 'heavy-armor', 1)
				TriggerServerEvent('HD-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
				currentVest, currentVestTexture = nil, nil
    	    end)
    	else
    	    HDCore.Functions.Notify("Je hebt geen vest aan..", "error")
    	end
	end
end)

RegisterNetEvent("HD-items:client:use:interventieband")
AddEventHandler("HD-items:client:use:interventieband", function()
    local Sex = "Man"
    if HDCore.Functions.GetPlayerData().charinfo.gender == 1 then
      Sex = "Vrouw"
    end
    HDCore.Functions.Progressbar("use_interventieband", "Band aandoen..", 5000, false, true, {
    disableMovement = false,
    disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		TriggerServerEvent('HDCore:Server:RemoveItem', 'interventieband', 1)
		TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['interventieband'], "remove")
        if Sex == 'Man' then
        currentDecal = GetPedDrawableVariation(GetPlayerPed(-1), 10)
        currentDecalTexture = GetPedTextureVariation(GetPlayerPed(-1), 10)
        if GetPedDrawableVariation(GetPlayerPed(-1), 10) then
            SetPedComponentVariation(GetPlayerPed(-1), 10, 1, GetPedTextureVariation(GetPlayerPed(-1), 10), 0)
        end
      else
        currentDecal = GetPedDrawableVariation(GetPlayerPed(-1), 10)
        currentDecalTexture = GetPedTextureVariation(GetPlayerPed(-1), 10)
        if GetPedDrawableVariation(GetPlayerPed(-1), 10) then
            SetPedComponentVariation(GetPlayerPed(-1), 10, 1, GetPedTextureVariation(GetPlayerPed(-1), 10), 0)
        end
      end
    end)
end)

RegisterNetEvent("HD-items:client:reset:band")
AddEventHandler("HD-items:client:reset:band", function()
    local ped = GetPlayerPed(-1)
    if currentDecal ~= nil and currentDecalTexture ~= nil then 
        HDCore.Functions.Progressbar("remove-band", "Band uitdoen..", 2500, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            SetPedComponentVariation(GetPlayerPed(-1), 10, currentDecal, currentDecalTexture, 0)
			TriggerServerEvent('HD-items:server:giveitem', 'interventieband', 1)
        end)
    else
        HDCore.Functions.Notify("Je hebt geen band aan..", "error")
    end
end)

RegisterNetEvent("HD-items:client:use:stethoscoop")
AddEventHandler("HD-items:client:use:stethoscoop", function()
    local Sex = "Man"
    if HDCore.Functions.GetPlayerData().charinfo.gender == 1 then
      Sex = "Vrouw"
    end
    HDCore.Functions.Progressbar("use_stethoscoop", "Stethoscoop aandoen..", 1500, false, true, {
    disableMovement = false,
    disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		TriggerServerEvent('HDCore:Server:RemoveItem', 'stethoscoop', 1)
		TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['stethoscoop'], "remove")
        if Sex == 'Man' then
        currentDecal = GetPedDrawableVariation(GetPlayerPed(-1), 7)
        currentDecalTexture = GetPedTextureVariation(GetPlayerPed(-1), 7)
        if GetPedDrawableVariation(GetPlayerPed(-1), 7) then
            SetPedComponentVariation(GetPlayerPed(-1), 7, 126, GetPedTextureVariation(GetPlayerPed(-1), 7), 0)
        end
      else
        currentDecal = GetPedDrawableVariation(GetPlayerPed(-1), 7)
        currentDecalTexture = GetPedTextureVariation(GetPlayerPed(-1), 7)
        if GetPedDrawableVariation(GetPlayerPed(-1), 7) then
            SetPedComponentVariation(GetPlayerPed(-1), 7, 126, GetPedTextureVariation(GetPlayerPed(-1), 7), 0)
        end
      end
    end)
end)

RegisterNetEvent("HD-items:client:reset:stethoscoop")
AddEventHandler("HD-items:client:reset:stethoscoop", function()
    local ped = GetPlayerPed(-1)
    if currentDecal ~= nil and currentDecalTexture ~= nil then 
        HDCore.Functions.Progressbar("remove-stethoscoop", "Stethoscoop uitdoen..", 1000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            SetPedComponentVariation(GetPlayerPed(-1), 7, currentDecal, currentDecalTexture, 0)
			TriggerServerEvent('HD-items:server:giveitem', 'stethoscoop', 1)
        end)
    else
        HDCore.Functions.Notify("Je hebt geen stethoscoop aan..", "error")
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function EquipParachuteAnim()
    loadAnimDict("clothingshirt")        
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end

local ParachuteEquiped = false

RegisterNetEvent("HD-items:client:UseParachute")
AddEventHandler("HD-items:client:UseParachute", function()
    EquipParachuteAnim()
    HDCore.Functions.Progressbar("use_parachute", "Parachute omhangen..", 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        local ped = PlayerPedId()
        TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items["parachute"], "remove")
        GiveWeaponToPed(ped, GetHashKey("GADGET_PARACHUTE"), 1, false)
        local ParachuteData = {
            outfitData = {
                ["bag"]   = { item = 7, texture = 0},  -- Nek / Das
            }
        }
        --TriggerEvent('rs-clothing:client:loadOutfit', ParachuteData)
        ParachuteEquiped = true
        TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    end)
end)

RegisterNetEvent("HD-items:client:ResetParachute")
AddEventHandler("HD-items:client:ResetParachute", function()
    if ParachuteEquiped then 
        EquipParachuteAnim()
        HDCore.Functions.Progressbar("reset_parachute", "Parachute inpakken..", 40000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            local ped = PlayerPedId()
            TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items["parachute"], "add")
            local ParachuteRemoveData = { 
                outfitData = { 
                    ["bag"] = { item = 0, texture = 0} -- Nek / Das
                }
            }
            --TriggerEvent('rs-clothing:client:loadOutfit', ParachuteRemoveData)
            TaskPlayAnim(ped, "clothingshirt", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            TriggerServerEvent("HD-items:server:AddParachute")
            ParachuteEquiped = false
        end)
    else
        HDCore.Functions.Notify("Je hebt geen parachute om!", "error")
    end
end)

RegisterNetEvent("HD-items:client:use:interventieband")
AddEventHandler("HD-items:client:use:interventieband", function()
    local Sex = "Man"
    if HDCore.Functions.GetPlayerData().charinfo.gender == 1 then
      Sex = "Vrouw"
    end
    HDCore.Functions.Progressbar("use_interventieband", "Band aandoen..", 5000, false, true, {
    disableMovement = false,
    disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		TriggerServerEvent('HDCore:Server:RemoveItem', 'interventieband', 1)
		TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['interventieband'], "remove")
        if Sex == 'Man' then
        currentDecal = GetPedDrawableVariation(GetPlayerPed(-1), 10)
        currentDecalTexture = GetPedTextureVariation(GetPlayerPed(-1), 10)
        if GetPedDrawableVariation(GetPlayerPed(-1), 10) then
            SetPedComponentVariation(GetPlayerPed(-1), 10, 1, GetPedTextureVariation(GetPlayerPed(-1), 10), 0)
        end
      else
        currentDecal = GetPedDrawableVariation(GetPlayerPed(-1), 10)
        currentDecalTexture = GetPedTextureVariation(GetPlayerPed(-1), 10)
        if GetPedDrawableVariation(GetPlayerPed(-1), 10) then
            SetPedComponentVariation(GetPlayerPed(-1), 10, 1, GetPedTextureVariation(GetPlayerPed(-1), 10), 0)
        end
      end
    end)
end)

RegisterNetEvent("HD-items:client:reset:band")
AddEventHandler("HD-items:client:reset:band", function()
    local ped = GetPlayerPed(-1)
    if currentDecal ~= nil and currentDecalTexture ~= nil then 
        HDCore.Functions.Progressbar("remove-band", "Band uitdoen..", 2500, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            SetPedComponentVariation(GetPlayerPed(-1), 10, currentDecal, currentDecalTexture, 0)
			TriggerServerEvent('HD-items:server:giveitem', 'interventieband', 1)
        end)
    else
        HDCore.Functions.Notify("Je hebt geen band aan..", "error")
    end
end)

RegisterNetEvent("HD-items:client:use:stethoscoop")
AddEventHandler("HD-items:client:use:stethoscoop", function()
    local Sex = "Man"
    if HDCore.Functions.GetPlayerData().charinfo.gender == 1 then
      Sex = "Vrouw"
    end
    HDCore.Functions.Progressbar("use_stethoscoop", "Stethoscoop aandoen..", 1500, false, true, {
    disableMovement = false,
    disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		TriggerServerEvent('HDCore:Server:RemoveItem', 'stethoscoop', 1)
		TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['stethoscoop'], "remove")
        if Sex == 'Man' then
        currentDecal = GetPedDrawableVariation(GetPlayerPed(-1), 7)
        currentDecalTexture = GetPedTextureVariation(GetPlayerPed(-1), 7)
        if GetPedDrawableVariation(GetPlayerPed(-1), 7) then
            SetPedComponentVariation(GetPlayerPed(-1), 7, 126, GetPedTextureVariation(GetPlayerPed(-1), 7), 0)
        end
      else
        currentDecal = GetPedDrawableVariation(GetPlayerPed(-1), 7)
        currentDecalTexture = GetPedTextureVariation(GetPlayerPed(-1), 7)
        if GetPedDrawableVariation(GetPlayerPed(-1), 7) then
            SetPedComponentVariation(GetPlayerPed(-1), 7, 126, GetPedTextureVariation(GetPlayerPed(-1), 7), 0)
        end
      end
    end)
end)

RegisterNetEvent("HD-items:client:reset:stethoscoop")
AddEventHandler("HD-items:client:reset:stethoscoop", function()
    local ped = GetPlayerPed(-1)
    if currentDecal ~= nil and currentDecalTexture ~= nil then 
        HDCore.Functions.Progressbar("remove-stethoscoop", "Stethoscoop uitdoen..", 1000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            SetPedComponentVariation(GetPlayerPed(-1), 7, currentDecal, currentDecalTexture, 0)
			TriggerServerEvent('HD-items:server:giveitem', 'stethoscoop', 1)
        end)
    else
        HDCore.Functions.Notify("Je hebt geen stethoscoop aan..", "error")
    end
end)

RegisterNetEvent('HD-items:client:use:repairkit')
AddEventHandler('HD-items:client:use:repairkit', function()
	if not exports['HD-progressbar']:GetTaskBarStatus() then
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
				Citizen.Wait(450)
				TriggerEvent('HD-inventory:client:set:busy', true)
				HDCore.Functions.Progressbar("repair_vehicle", "Bezig met sleutelen..", math.random(10000, 20000), false, true, {
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
					  TriggerServerEvent('HDCore:Server:RemoveItem', 'repairkit', 1)
					  TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['repairkit'], "remove")
					end
					TriggerEvent('HD-inventory:client:set:busy', false)
					SetVehicleDoorShut(Vehicle, VehicleDoor, false)
					StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
					HDCore.Functions.Notify("Voertuig gemaakt!")
					SetVehicleEngineHealth(Vehicle, NewHealth) 
					for i = 1, 6 do
					 SetVehicleTyreFixed(Vehicle, i)
					end
				end, function() -- Cancel
					TriggerEvent('HD-inventory:client:set:busy', false)
					StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
					HDCore.Functions.Notify("Mislukt!", "error")
					SetVehicleDoorShut(Vehicle, VehicleDoor, false)
				end)
			end
		 else
			HDCore.Functions.Notify("Geen voertuig?!?", "error")
		end
		end	
	end
end)


local SeksPop = false
local SekspopObject = nil

RegisterNetEvent('HD-items:client:sekspop')
AddEventHandler('HD-items:client:sekspop', function()
  if not SeksPop then
    local ped = PlayerPedId()
    SekspopObject = CreateObject(GetHashKey("prop_defilied_ragdoll_01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(SekspopObject, ped, GetPedBoneIndex(ped, 57005), 0.16, 0.06, 0.0, 335.0, 300.0, 120.0, true, true, false, true, 5, true)
	-- exports['HD-assets']:AddProp('Sekspop')
  else
    local ped = PlayerPedId()
    DetachEntity(SekspopObject, 0, 0)
    DeleteEntity(SekspopObject)
  end
  SeksPop = not SeksPop
end)

RegisterNetEvent('HD-items:client:dildo')
AddEventHandler('HD-items:client:dildo', function()
  if not SeksPop then
    local ped = PlayerPedId()
    SekspopObject = CreateObject(GetHashKey("prop_cs_dildo_01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(SekspopObject, ped, GetPedBoneIndex(ped, 57005), 0.16, 0.06, 0.0, 335.0, 300.0, 120.0, true, true, false, true, 5, true)
	-- exports['HD-assets']:AddProp('Sekspop')
  else
    local ped = PlayerPedId()
    DetachEntity(SekspopObject, 0, 0)
    DeleteEntity(SekspopObject)
  end
  SeksPop = not SeksPop
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
		CoinFlip = 'Coinflip: ~g~Kop'
     else
		CoinFlip = 'Coinflip: ~y~Munt'
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


RegisterNetEvent('HD-diving:client:UseGear')
AddEventHandler('HD-diving:client:UseGear', function(bool)
    if bool then
        GearAnim()
        HDCore.Functions.Progressbar("equip_gear", "Duikpak aantrekken..", 5000, false, true, {}, {}, {}, {}, function() -- Done
            DeleteGear()
            local maskModel = GetHashKey("p_d_scuba_mask_s")
            local tankModel = GetHashKey("p_s_scuba_tank_s")
    
            RequestModel(tankModel)
            while not HasModelLoaded(tankModel) do
                Citizen.Wait(1)
            end
            TankObject = CreateObject(tankModel, 1.0, 1.0, 1.0, 1, 1, 0)
            local bone1 = GetPedBoneIndex(PlayerPedId(), 24818)
            AttachEntityToEntity(TankObject, PlayerPedId(), bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
            currentGear.tank = TankObject
    
            RequestModel(maskModel)
            while not HasModelLoaded(maskModel) do
                Citizen.Wait(1)
            end
            
            MaskObject = CreateObject(maskModel, 1.0, 1.0, 1.0, 1, 1, 0)
            local bone2 = GetPedBoneIndex(PlayerPedId(), 12844)
            AttachEntityToEntity(MaskObject, PlayerPedId(), bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2, 1)
            currentGear.mask = MaskObject
    
            SetEnableScuba(PlayerPedId(), true)
            SetPedMaxTimeUnderwater(PlayerPedId(), 100.00)
            currentGear.enabled = true
            TriggerServerEvent('HD-diving:server:RemoveGear')
            ClearPedTasks(PlayerPedId())
            TriggerEvent('chatMessage', "SYSTEM", "error", "/duikpak om je duikpak uit te trekken!")
        end)
    else
        if currentGear.enabled then
            GearAnim()
            HDCore.Functions.Progressbar("remove_gear", "Duikpak uittrekken..", 5000, false, true, {}, {}, {}, {}, function() -- Done
                DeleteGear()

                SetEnableScuba(PlayerPedId(), false)
                SetPedMaxTimeUnderwater(PlayerPedId(), 1.00)
                currentGear.enabled = false
                TriggerServerEvent('HD-diving:server:GiveBackGear')
                ClearPedTasks(PlayerPedId())
                HDCore.Functions.Notify('Je hebt je duikpak uitgetrokken')
            end)
        else
            HDCore.Functions.Notify('Je hebt geen duikgear aan..', 'error')
        end
    end
end)

function DeleteGear()
	if currentGear.mask ~= 0 then
        DetachEntity(currentGear.mask, 0, 1)
        DeleteEntity(currentGear.mask)
		currentGear.mask = 0
    end
    
	if currentGear.tank ~= 0 then
        DetachEntity(currentGear.tank, 0, 1)
        DeleteEntity(currentGear.tank)
		currentGear.tank = 0
	end
end

function GearAnim()
    loadAnimDict("clothingshirt")    	
	TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end
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
    local s = "~g~Gedobbled~s~: "
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