local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

HDCore = nil
local isLoggedIn = false
local PlayerData = {}
local PlayerJob = {}

local Bezig = false

local Nearby = false
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if HDCore == nil then
            TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)


RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
    PlayerJob = HDCore.Functions.GetPlayerData().job
	isLoggedIn = true    
end)





RegisterNetEvent('HDCore:Client:OnPlayerUnload')
AddEventHandler('HDCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('HDCore:Client:OnJobUpdate')
AddEventHandler('HDCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if HDCore == nil then
            TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)


RegisterNetEvent('HD-pizzeria:client:SetStock')
AddEventHandler('HD-pizzeria:client:SetStock', function(stock, amount)
	Config.JobData[stock] = amount
end)

-- Code

Citizen.CreateThread(function()
	while true do 
		--Citizen.Wait(7)
		local Positie = GetEntityCoords(GetPlayerPed(-1), false)
		local GebiedA = GetDistanceBetweenCoords(Positie.x, Positie.y, Positie.z, 288.98, -978.43, 29.43, true)
		if GebiedA <= 10.5 then

		  Citizen.Wait(7)
		else
		  
		  Citizen.Wait(1508)
		end
		
		 for k,v in pairs(Config.JobData['locations']) do
		  local Positie = GetEntityCoords(GetPlayerPed(-1), false)
		  local Gebied = GetDistanceBetweenCoords(Positie.x, Positie.y, Positie.z, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, true)
            if PlayerJob.name ==  "pizza" then
			    if Gebied <= 1.5 then
				    if Config.JobData['locations'][k]['name'] == 'Lettuce' then
					    DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Pack of vegetables\n Vegetables stock: ~g~'..Config.JobData['stock-lettuce']..'x')
					    DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 44, 194, 33, 255, false, false, false, 1, false, false, false)
				    elseif Config.JobData['locations'][k]['name'] == 'Meat' then
					    DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Cutting meat\n Meat stock: ~r~'..Config.JobData['stock-meat']..'x')
					    DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 138, 34, 34, 255, false, false, false, 1, false, false, false)
				    elseif Config.JobData['locations'][k]['name'] == 'Shell' then
					    DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Prepare pizza')
					    DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 194, 147, 29, 255, false, false, false, 1, false, false, false)
				    elseif Config.JobData['locations'][k]['name'] == 'Givepizza' then
					    DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Delivery pizza')
					    DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
				    elseif Config.JobData['locations'][k]['name'] == 'Stock' then
					    DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Delivery box')
					    DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
				    elseif Config.JobData['locations'][k]['name'] == 'Register' then
					     if Config.JobData['register'] >= 10000 then
						    DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Grab Money \Register capacity: ~g~Enough money.')
					    else
						    DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Grab Money \Register capacity: ~r~Not Enough')
					    end
					        DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 46, 209, 206, 255, false, false, false, 1, false, false, false)
				    end
				    if IsControlJustPressed(0, Keys['E']) then
				      if not Bezig then
					    if Config.JobData['locations'][k]['name'] == 'Lettuce' then
						    Getgroenten()
					    elseif Config.JobData['locations'][k]['name'] == 'Meat' then
						    BakeMeat()
					    elseif Config.JobData['locations'][k]['name'] == 'Shell' then
						    HDCore.Functions.TriggerCallback('HD-pizza:server:get:ingredient', function(HasItems)  
                            if HasItems then
							    Finishpizza()
						    else
							    HDCore.Functions.Notify("You don't have all the ingredients yet.", "error")
						    end
					    end)
					    elseif Config.JobData['locations'][k]['name'] == 'Register' then
						    TakeMoney()
					    elseif Config.JobData['locations'][k]['name'] == 'Stock' then
						    AddStuff()
					    elseif Config.JobData['locations'][k]['name'] == 'Givepizza' then
						    GivepizzaToShop()
					    end
					     else
						    HDCore.Functions.Notify("You are still working on something.", "error")
					    end
				    end									
			    end
	        end  	
		end
	
	end
end)



-- functions

function Finishpizza()
	Bezig = true
	TriggerEvent('inventory:client:busy:status', true)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "wave", 3.2)
	HDCore.Functions.Progressbar("pickup_sla", "Pizza maken...", 3500, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = false,
	}, {
		animDict = "mp_common",
		anim = "givetake1_a",
		flags = 8,
	}, {}, {}, function() -- Done
		Bezig = false
		TriggerEvent('inventory:client:busy:status', false)
		TriggerServerEvent('HD-pizzeria:server:rem:stuff', "pizzameat")
		TriggerServerEvent('HD-pizzeria:server:rem:stuff', "groenten")
		TriggerServerEvent('HD-pizzeria:server:add:stuff', "pizza")
		TriggerEvent('HD-inventory:client:ItemBox', HDCore.Shared.Items['pizzameat'], 'remove')
		TriggerEvent('HD-inventory:client:ItemBox', HDCore.Shared.Items['groenten'], 'remove')
		TriggerEvent('HD-inventory:client:ItemBox', HDCore.Shared.Items['pizza'], 'add')
		TriggerEvent('HD-sound:client:play', 'micro', 0.2)
	end, function()
		TriggerEvent('inventory:client:busy:status', false)
		HDCore.Functions.Notify("Canceled.", "error")
		Bezig = false
	end)
end

function BakeMeat()
	if Config.JobData['stock-meat'] >= 1 then
	Bezig = true
	TriggerEvent('HD-sound:client:play', 'Pizzameat', 0.7)
	HDCore.Functions.Progressbar("pickup_sla", "Cutting meat...", 5000, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = false,
	}, {
		animDict = "amb@prop_human_bbq@male@base",
		anim = "base",
		flags = 8,
	}, {
		model = "prop_knife",
        bone = 28422,
        coords = { x = -0.05, y = 0.00, z = 0.00 },
        rotation = { x = 175.0, y = 160.0, z = 0.0 },
	}, {}, function() -- Done
		--TriggerServerEvent('HDCore:Server:AddItem', "pizzameat", 1)
		
		TriggerServerEvent('HD-pizzeria:server:add:stuff', "pizzameat")
		TriggerServerEvent('HD-pizza:server:set:pizza:count', 'Min', 'stock-meat', 1)
		TriggerEvent('HD-inventory:client:ItemBox', HDCore.Shared.Items['pizzameat'], 'add')
		Bezig = false
	end, function()
		HDCore.Functions.Notify("Canceled.", "error")
		Bezig = false
	end)
else
	HDCore.Functions.Notify("There is not enough meat in stock.", "error")
 end  
end

function Getgroenten()
	if Config.JobData['stock-lettuce'] >= 1 then
	Bezig = true
			TriggerEvent('HD-sound:client:play', 'fridge', 0.5)
	HDCore.Functions.Progressbar("pickup_sla", "Grabbing Vegetables...", 4100, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = false,
	}, {
		animDict = "amb@prop_human_bum_bin@idle_b",
		anim = "idle_d",
		flags = 8,
	}, {}, {}, function() -- Done
		StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
		TriggerServerEvent('HD-pizzeria:server:add:stuff', 'groenten')
		TriggerServerEvent('HD-pizza:server:set:pizza:count', 'Min', 'stock-lettuce', 1)
		TriggerEvent('HD-inventory:client:ItemBox', HDCore.Shared.Items['groenten'], 'add')
		Bezig = false
	end, function()
		StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
		HDCore.Functions.Notify("Canceled.", "error")
		Bezig = false
	end)
else
	HDCore.Functions.Notify("There is not enough vegetables in stock.", "error")
 end 
end

function GivepizzaToShop()
	HDCore.Functions.TriggerCallback('HD-pizza:server:get:pizzas', function(HasItem, type)
		if HasItem then
		  if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			if Config.JobData['pizzas'] <= 9 then	
				HDCore.Functions.Notify("pizza bezorgd.", "success")
				TriggerServerEvent('HD-pizza:server:set:pizza:count', 'Plus', 'pizzas', 1)
				TriggerServerEvent('HD-pizzeria:server:rem:stuff', "pizza")
				TriggerEvent('HD-inventory:client:ItemBox', HDCore.Shared.Items['pizza'], 'remove')
				else
					HDCore.Functions.Notify("There are still 10 pizzas that need to be sold.We don't waste a food here.", "error")
				end
		  elseif type == 'green' then
			if Config.JobData['green-pizzas'] <= 9 then	
				TriggerServerEvent('HD-pizzeria:server:rem:pizza')
				TriggerEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['green-pizza'], 'remove')
				else
					HDCore.Functions.Notify("There are still 10 pizzas that need to be sold.We don't waste a food here.", "error")
				end
		end
	    else
		HDCore.Functions.Notify("You don't even have a pizza.", "error")
	 end
	end)
end

function AddStuff()
	HDCore.Functions.TriggerCallback('HDCore:HasItem', function(HasItem)
		if HasItem then
			if Config.JobBusy == true then
				--TriggerServerEvent('HDCore:Server:RemoveItem', "pizza-vooraad", 1)
				TriggerEvent('HD-inventory:client:ItemBox', HDCore.Shared.Items['pizza-vooraad'], 'remove')
				
		TriggerServerEvent('HD-pizzeria:server:rem:stuff', "pizza-vooraad")
				TriggerServerEvent('HD-pizza:server:set:pizza:count', 'Plus', 'stock-meat', math.random(1,7))
				TriggerServerEvent('HD-pizza:server:set:pizza:count', 'Plus', 'stock-lettuce', math.random(1,7))
				HDCore.Functions.Notify("pizza Shop is weer aangevuld.", "success")
				Config.JobBusy = false
			else
				HDCore.Functions.Notify("You come directly from the pizza shop.", "error")
			end
		else
			HDCore.Functions.Notify("You don't even have a box with ingredients.", "error")
		end
	end, 'pizza-vooraad')
end

function TakeMoney()
	if Config.JobData['register'] >= 10000 then
		local lockpickTime = math.random(10000,35000)
		RegisterAnim(lockpickTime)
		HDCore.Functions.Progressbar("search_register", "Collect room..", lockpickTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "veh@break_in@0h@p_m_one@",
            anim = "low_force_entry_ds",
            flags = 16,
        }, {}, {}, function() -- Done
            GetMoney = false  
			TriggerServerEvent('HD-pizza:server:set:pizza:count', 'Min', 'register', 10000)    
        end, function() -- Cancel
            GetMoney = false
            ClearPedTasks(GetPlayerPed(-1))
            HDCore.Functions.Notify("Canceled.", "error")
        end)
	else
		HDCore.Functions.Notify("There is not enough money in the cash register..", "error")
	end
end

--Voertuig
function whitelistedVehicle()
    local ped = GetPlayerPed(-1)
    local veh = GetEntityModel(GetVehiclePedIsIn(ped))
    local retval = false

    for i = 1, #Config.AllowedVehicles, 1 do
        if veh == GetHashKey(Config.AllowedVehicles[i].model) then
            retval = true
        end
    end
    return retval
end

function PizzaGarage()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton("Vehicles", "VehicleList", nil)
    Menu.addButton("Close menu", "closeMenuFull", nil) 
end

function VehicleList()
    ped = GetPlayerPed(-1);
    MenuTitle = "Voertuigen:"
    ClearMenu()
    for k, v in pairs(Config.AllowedVehicles) do
        Menu.addButton(Config.AllowedVehicles[k].label, "TakeVehicle", k, "Garage", " Engine: 100%", " Body: 100%", " Fuel: 100%")
    end
        
    Menu.addButton("Terug", "PizzaGarage",nil)
end


Citizen.CreateThread(function()
    while true do

        inRange = false

        if HDCore ~= nil then
            if isLoggedIn then

                if PlayerJob.name == "pizza" then
                    local ped = GetPlayerPed(-1)
                    local pos = GetEntityCoords(ped)

                    local vehDist = GetDistanceBetweenCoords(pos, Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"])

                    if vehDist < 30 then
                        inRange = true

                        DrawMarker(2, Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"], 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.3, 0.5, 0.2, 200, 0, 0, 222, false, false, false, true, false, false, false)

                        if vehDist < 1.5 then
                            if whitelistedVehicle() then
                                DrawText3D(Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"] + 0.3, '[E] Park')
                                if IsControlJustReleased(0, Keys["E"]) then
                                    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                        DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                    end
                                end
                            else
                                DrawText3D(Config.Locations["vehicle"]["x"], Config.Locations["vehicle"]["y"], Config.Locations["vehicle"]["z"] + 0.3, '[E] Grab Vehicle')
                                if IsControlJustReleased(0, Keys["E"]) then
                                    PizzaGarage()
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(3000)
        end

        Citizen.Wait(3)
    end
end)


Citizen.CreateThread(function()
    while true do

        inRange = false

        if HDCore ~= nil then
            if isLoggedIn then
                
            if (PlayerJob ~= nil) and PlayerJob.name == "pizza" then
                    local ped = GetPlayerPed(-1)
                    local pos = GetEntityCoords(ped)

                    local BossDist = GetDistanceBetweenCoords(pos, Config.Locations["Boss"]["x"], Config.Locations["Boss"]["y"], Config.Locations["Boss"]["z"])

                    if BossDist < 3 then
                        inRange = true

                        DrawMarker(2, Config.Locations["Boss"]["x"], Config.Locations["Boss"]["y"], Config.Locations["Boss"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, true, false, false, false)

                        if BossDist < 1.5 then
                            HDCore.Functions.DrawText3D(Config.Locations["Boss"]["x"], Config.Locations["Boss"]["y"], Config.Locations["Boss"]["z"] + 0.3, "Boss")
                                if IsControlJustReleased(0, Keys["E"]) then

                                    TriggerServerEvent("HD-bossmenu:server:openMenu")

                                end
                        end
                    end

                    
                    local StashDist = GetDistanceBetweenCoords(pos, Config.Locations["Stash"]["x"], Config.Locations["Stash"]["y"], Config.Locations["Stash"]["z"])

                    if StashDist < 3 then
                        inRange = true

                        DrawMarker(2, Config.Locations["Stash"]["x"], Config.Locations["Stash"]["y"], Config.Locations["Stash"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, true, false, false, false)

                        if StashDist < 1.5 then
                                HDCore.Functions.DrawText3D(Config.Locations["Stash"]["x"], Config.Locations["Stash"]["y"], Config.Locations["Stash"]["z"] + 0.3, "Stash")
                                if IsControlJustReleased(0, Keys["E"]) then

                                    TriggerServerEvent("HD-inventory:server:OpenInventory", "stash", "pizza")
                                    TriggerEvent("HD-inventory:client:SetCurrentStash", "pizza")

                                end
                        end
                    end
                    local DutyDist = GetDistanceBetweenCoords(pos, Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"])

                    if DutyDist < 3 then
                        inRange = true
                        if DutyDist < 1.5 then
                            DrawMarker(2, Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                            if not onDuty then
                                HDCore.Functions.DrawText3D(Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"] + 0.15, "In Duty")
                                if IsControlJustReleased(0, Keys["E"]) then
                                    TriggerServerEvent("HDCore:ToggleDuty", true)
                                end
                            else
                                HDCore.Functions.DrawText3D(Config.Locations["Duty"]["x"], Config.Locations["Duty"]["y"], Config.Locations["Duty"]["z"] + 0.15, "Out Duty")
                                if IsControlJustReleased(0, Keys['E']) then
                                    TriggerServerEvent("HDCore:ToggleDuty", false)
                                end
                            end
                        end
                    end
                end
            end
        end

        if not inRange then
            Citizen.Wait(3000)
        end

        Citizen.Wait(3)
    end
end)



function TakeVehicle(k)
    local coords = {x = Config.Locations["vehicle"]["x"], y = Config.Locations["vehicle"]["y"], z = Config.Locations["vehicle"]["z"]}
    HDCore.Functions.SpawnVehicle(Config.AllowedVehicles[k].model, function(veh)
        SetVehicleNumberPlateText(veh, "TAXI"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, Config.Locations["vehicle"]["h"])
        closeMenuFull()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['HD-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
        exports['HD-fuel']:SetFuelLevel(veh, GetVehicleNumberPlateText(veh), 100.0, false)
        SetVehicleEngineOn(veh, true, true)
        dutyPlate = GetVehicleNumberPlateText(veh)
        SetVehicleExtra(veh, 2, true)
        SetVehicleLivery(veh, 2)
    end, coords, true)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function RegisterAnim(time)
	time = time / 1000
	loadAnimDict("veh@break_in@0h@p_m_one@")
	TaskPlayAnim(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
	GetMoney = true
	Citizen.CreateThread(function()
	while GetMoney do
		TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
		Citizen.Wait(2000)
		time = time - 2
		TriggerServerEvent('HD-storerobbery:server:takeMoney', currentRegister, false)
		if time <= 0 then
			GetMoney = false
			StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
		end
	end
	end)
	end

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(288.46,-972.12, 29.43)
	SetBlipSprite(blip, 52)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 73)  
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pizzeria")
    EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
	pizzaVoor = AddBlipForCoord(929.48, -2308.08, 30.65)
    SetBlipSprite (pizzaVoor, 569)
    SetBlipDisplay(pizzaVoor, 4)
    SetBlipScale  (pizzaVoor, 0.6)
    SetBlipAsShortRange(pizzaVoor, true)
    SetBlipColour(pizzaVoor, 39)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Pizza Shop stock")
    EndTextCommandSetBlipName(pizzaVoor)
end)
