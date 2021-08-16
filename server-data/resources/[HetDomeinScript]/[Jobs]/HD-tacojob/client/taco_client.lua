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

local Bezig = false

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if HDCore == nil then
            TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent("HDCore:Client:OnPlayerLoaded")
AddEventHandler("HDCore:Client:OnPlayerLoaded", function()
    HDCore.Functions.TriggerCallback('HD-tacojob:server:GetConfig', function(config)
        Config = config
    end)
end)

-- Code

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		 for k,v in pairs(Config.JobData['locations']) do
		  local Positie = GetEntityCoords(GetPlayerPed(-1), false)
		  local Gebied = GetDistanceBetweenCoords(Positie.x, Positie.y, Positie.z, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, true)
		   if Gebied <= 1.0 then
				if HDCore.Functions.GetPlayerData().job.name == "tacos" and HDCore.Functions.GetPlayerData().job.onduty then
					if Config.JobData['locations'][k]['name'] == 'Lettuce' then
						DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.1, '~g~E~s~ - Sla pakken\n Sla voorraad: ~r~'..Config.JobData['stock-lettuce']..'x')
						--DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
					elseif Config.JobData['locations'][k]['name'] == 'Meat' then
						--DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.1, '~g~E~s~ - Vlees bakken')
						--DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
					elseif Config.JobData['locations'][k]['name'] == 'Shell' then
						--DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.1, '~g~E~s~ - Taco maken')
						--DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
					elseif Config.JobData['locations'][k]['name'] == 'GiveTaco' then
						DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.1, '~g~E~s~ - Taco afleveren')
						--DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
					elseif Config.JobData['locations'][k]['name'] == 'Stock' then
						DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.1, '~g~E~s~ - Doos neerzetten')
						--DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
					elseif Config.JobData['locations'][k]['name'] == 'Register' then
						if Config.JobData['register'] >= 10000 then
							DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.25, '~g~E~s~ - Pak geld \nInhoud: ~g~Genoeg geld')
						else
							DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.25, '~g~E~s~ - Pak geld \nInhoud: ~r~Niet genoeg')
						end
							--DrawMarker(2, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
					end
					if IsControlJustPressed(0, Keys['E']) then
					if not Bezig then
						if Config.JobData['locations'][k]['name'] == 'Lettuce' then
							GetLettuce()
						--[[ elseif Config.JobData['locations'][k]['name'] == 'Meat' then
							BakeMeat() ]]
						--[[ elseif Config.JobData['locations'][k]['name'] == 'Shell' then
							HDCore.Functions.TriggerCallback('HD-tacojob:server:get:ingredient', function(HasItems)  
							if HasItems then
								FinishTaco()
							else
								HDCore.Functions.Notify("Je hebt nog niet alle ingrediënten..", "error")
							end
						end) ]]
						elseif Config.JobData['locations'][k]['name'] == 'Register' then
							TakeMoney()
						elseif Config.JobData['locations'][k]['name'] == 'Stock' then
							AddStuff()
						elseif Config.JobData['locations'][k]['name'] == 'GiveTaco' then
							GiveTacoToShop()
						end
						else
							HDCore.Functions.Notify("Je bent al met iets bezig", "error")
						end
					end
				end
			end
		end
	end
end)

-- Toonbank
--[[ Citizen.CreateThread(function()
    while true do
        local inRange = false
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local ToonbankDistance = GetDistanceBetweenCoords(pos, Config.Stashes["toonbank"].x, Config.Stashes["toonbank"].y, Config.Stashes["toonbank"].z, true)
		if ToonbankDistance < 1.0 then
			inRange = true
			DrawText3D(Config.Stashes["toonbank"].x, Config.Stashes["toonbank"].y, Config.Stashes["toonbank"].z + 0.1, "~g~E~s~ - Toonbank")
			if IsControlJustPressed(0, Keys['E']) then
				TriggerEvent("HD-inventory:client:SetCurrentStash", "tacotoonbank")
				TriggerServerEvent("HD-inventory:server:OpenInventory", "stash", "tacotoonbank", {
					maxweight = 15000,
					slots = 5,
				})
			end
		end
        Citizen.Wait(3)
    end
end) ]]

Citizen.CreateThread(function()
    while true do
        local inRange = false

		local pos = GetEntityCoords(GetPlayerPed(-1))
		local DrinksDistance = GetDistanceBetweenCoords(pos, Config.Stashes["drinks"].x, Config.Stashes["drinks"].y, Config.Stashes["drinks"].z, true)
		local KoelkastDistance = GetDistanceBetweenCoords(pos, Config.Stashes["koelkast"].x, Config.Stashes["koelkast"].y, Config.Stashes["koelkast"].z, true)
		local TacosDistance = GetDistanceBetweenCoords(pos, Config.Stashes["tacos"].x, Config.Stashes["tacos"].y, Config.Stashes["tacos"].z, true)

		--[[ if DrinksDistance < 1.0 then
			if HDCore.Functions.GetPlayerData().job.name == "tacos" and HDCore.Functions.GetPlayerData().job.onduty then
				inRange = true
				DrawText3D(Config.Stashes["drinks"].x, Config.Stashes["drinks"].y, Config.Stashes["drinks"].z +0.3, "~g~E~s~ - Drinken")
				if IsControlJustReleased(0, Keys["E"]) then
					TriggerEvent("HD-inventory:client:SetCurrentStash", "drinks")
					TriggerServerEvent("HD-inventory:server:OpenInventory", "stash", "drinks", {
						maxweight = 50000,
						slots = 30,
					})
				end
			end
		end ]]

		--[[ if KoelkastDistance < 1.0 then
			if HDCore.Functions.GetPlayerData().job.name == "tacos" and HDCore.Functions.GetPlayerData().job.onduty then
				inRange = true
				DrawText3D(Config.Stashes["koelkast"].x, Config.Stashes["koelkast"].y, Config.Stashes["koelkast"].z, "~g~E~s~ - Koelkast")
				if IsControlJustReleased(0, Keys["E"]) then
					TriggerEvent("HD-inventory:client:SetCurrentStash", "koelkast")
					TriggerServerEvent("HD-inventory:server:OpenInventory", "stash", "koelkast", {
						maxweight = 100000,
						slots = 30,
					})
				end
			end
		end ]]

		--[[ if TacosDistance < 1.0 then
			if HDCore.Functions.GetPlayerData().job.name == "tacos" and HDCore.Functions.GetPlayerData().job.onduty then
				inRange = true
				DrawText3D(Config.Stashes["tacos"].x, Config.Stashes["tacos"].y, Config.Stashes["tacos"].z, "~g~E~s~ - Tacos")
				if IsControlJustReleased(0, Keys["E"]) then
					TriggerEvent("HD-inventory:client:SetCurrentStash", "tacos")
					TriggerServerEvent("HD-inventory:server:OpenInventory", "stash", "tacos", {
						maxweight = 50000,
						slots = 30,
					})
				end
			end
		end ]]

		if not inRange then
			Citizen.Wait(1500)
		end

        Citizen.Wait(3)
    end
end)

-- Target functies
RegisterNetEvent('HD-tacojob:client:openkoelkast')
AddEventHandler('HD-tacojob:client:openkoelkast', function()
	TriggerEvent("HD-inventory:client:SetCurrentStash", "koelkast")
	TriggerServerEvent("HD-inventory:server:OpenInventory", "stash", "koelkast", {
		maxweight = 100000,
		slots = 30,
	})
end)

RegisterNetEvent('HD-tacojob:client:bakvlees')
AddEventHandler('HD-tacojob:client:bakvlees', function()
	BakeMeat()
end)

RegisterNetEvent('HD-tacojob:client:tacobreiden')
AddEventHandler('HD-tacojob:client:tacobreiden', function()
	HDCore.Functions.TriggerCallback('HD-tacojob:server:get:ingredient', function(HasItems)  
		if HasItems then
			FinishTaco()
		else
			HDCore.Functions.Notify("Je hebt nog niet alle ingrediënten..", "error")
		end
	end)
end)

RegisterNetEvent('HD-tacojob:client:tacoopslag')
AddEventHandler('HD-tacojob:client:tacoopslag', function()
	TriggerEvent("HD-inventory:client:SetCurrentStash", "tacos")
	TriggerServerEvent("HD-inventory:server:OpenInventory", "stash", "tacos", {
		maxweight = 50000,
		slots = 30,
	})
end)

RegisterNetEvent('HD-tacojob:client:toonbank')
AddEventHandler('HD-tacojob:client:toonbank', function()
	TriggerEvent("HD-inventory:client:SetCurrentStash", "tacotoonbank")
	TriggerServerEvent("HD-inventory:server:OpenInventory", "stash", "tacotoonbank", {
		maxweight = 15000,
		slots = 5,
	})
end)

RegisterNetEvent('HD-tacojob:client:drinken')
AddEventHandler('HD-tacojob:client:drinken', function()
	TriggerEvent("HD-inventory:client:SetCurrentStash", "drinks")
	TriggerServerEvent("HD-inventory:server:OpenInventory", "stash", "drinks", {
		maxweight = 50000,
		slots = 30,
	})
end)
-- Einde

-- functions

function FinishTaco()
	Bezig = true
	TriggerEvent('HD-inventory:client:busy:status', true)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "wave", 3.2)
	HDCore.Functions.Progressbar("pickup_sla", "Taco maken..", 3500, false, true, {
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
		TriggerEvent('HD-inventory:client:busy:status', false)
		TriggerServerEvent('HDCore:Server:RemoveItem', "taco-meat", 1)
		TriggerServerEvent('HDCore:Server:RemoveItem', "taco-sla", 1)
		TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items["taco-meat"], "remove")
		TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items["taco-sla"], "remove")
		HDCore.Functions.TriggerCallback('HD-tacojob:server:get:taco')
		TriggerServerEvent("InteractSound_SV:PlayOnSource", "micro", 0.2)
	end, function()
		TriggerEvent('HD-inventory:client:busy:status', false)
		HDCore.Functions.Notify("Geannuleerd..", "error")
		Bezig = false
	end)
end

function BakeMeat()
	HDCore.Functions.TriggerCallback('HD-tacojob:server:get:rawmeat', function(HasItem, type)
		if HasItem then
			if Config.JobData['stock-meat'] <= 0 then
			Bezig = true
			TriggerServerEvent("InteractSound_SV:PlayOnSource", "Meat", 0.7)
			HDCore.Functions.Progressbar("pickup_sla", "Vlees bakken..", 5000, false, true, {
				disableMovement = true,
				disableCarMovement = false,
				disableMouse = false,
				disableCombat = false,
			}, {
				animDict = "amb@prop_human_bbq@male@base",
				anim = "base",
				flags = 8,
			}, {
				model = "prop_cs_fork",
				bone = 28422,
				coords = { x = -0.005, y = 0.00, z = 0.00 },
				rotation = { x = 175.0, y = 160.0, z = 0.0 },
			}, {}, function() -- Done
				HDCore.Functions.TriggerCallback('HD-tacojob:server:get:meat')
				Config.JobData['stock-meat']= Config.JobData['stock-meat'] - 1
				Bezig = false
			end, function()
				HDCore.Functions.Notify("Geannuleerd..", "error")
				Bezig = false
			end)
		end
		else
		HDCore.Functions.Notify("Je hebt geen rauw vlees", "error")
		end
	end)
end

function GetLettuce()
	if Config.JobData['stock-lettuce'] >= 1 then
	Bezig = true
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "fridge", 0.5)
	HDCore.Functions.Progressbar("pickup_sla", "Sla pakken..", 4100, false, true, {
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
		HDCore.Functions.TriggerCallback('HD-tacojob:server:get:sla')
		Config.JobData['stock-lettuce']= Config.JobData['stock-lettuce'] - 1
		Bezig = false
	end, function()
		StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
		HDCore.Functions.Notify("Geannuleerd..", "error")
		Bezig = false
	end)
else
	HDCore.Functions.Notify("Er is niet genoeg sla op voorraad..", "error")
 end 
end

function GiveTacoToShop()
	HDCore.Functions.TriggerCallback('HD-tacojob:server:get:tacos', function(HasItem, type)
		if HasItem then
		  if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			if Config.JobData['tacos'] <= 9 then	
				HDCore.Functions.Notify("Taco geleverd!", "success")
				Config.JobData['tacos'] = Config.JobData['tacos'] + 1
				TriggerServerEvent('HDCore:Server:RemoveItem', "taco", 1)
				TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items["taco"], "remove")
				else
					HDCore.Functions.Notify("Er zijn nog 10 taco\'s die verkocht moeten worden. We verspillen hier geen voedsel..", "error")
				end
		  elseif type == 'green' then
			if Config.JobData['green-tacos'] <= 9 then	
				TriggerServerEvent('HDCore:Server:RemoveItem', "taco", 1)
				TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items["green-taco"], "remove")
				else
					HDCore.Functions.Notify("Er zijn nog 10 taco\'s die verkocht moeten worden. We verspillen hier geen voedsel..", "error")
				end
		end
	    else
		HDCore.Functions.Notify("Je hebt niet genoeg taco\'s..", "error")
	 end
	end)
end

function AddStuff()
	HDCore.Functions.TriggerCallback('HDCore:HasItem', function(HasItem)
		if HasItem then
			if Config.JobBusy == true then
				TriggerServerEvent('HDCore:Server:RemoveItem', "taco-box", 1)
				TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items["taco-box"], "remove")
				Config.JobData['stock-lettuce']= Config.JobData['stock-lettuce'] + math.random(40,60)
				Config.JobData['stock-meat']= Config.JobData['stock-meat'] + math.random(40,60)
				HDCore.Functions.Notify("Voorraad aangevult", "success")
				Config.JobBusy = false
			else
				HDCore.Functions.Notify("Je komt rechtstreeks uit de taco winkel..", "error")
			end
		else
			HDCore.Functions.Notify("Je hebt niet eens een doos met ingrediënten..", "error")
		end
	end, 'taco-box')
end

function TakeMoney()
	if Config.JobData['register'] >= 10000 then
		local lockpickTime = math.random(10000,35000)
		RegisterAnim(lockpickTime)
		HDCore.Functions.Progressbar("search_register", "Kassa Leeghalen..", lockpickTime, false, true, {
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
			Config.JobData['register']= Config.JobData['register'] - 10000        
        end, function() -- Cancel
            GetMoney = false
            ClearPedTasks(GetPlayerPed(-1))
            HDCore.Functions.Notify("Proces geannuleerd..", "error")
        end)
	else
		HDCore.Functions.Notify("Er staat nog niet genoeg geld in de kassa..", "error")
	end
end

--[[ function DrawText3Ds(x,y,z, text)
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
end ]]

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
			TriggerServerEvent('is-storerobbery:server:takeMoney', currentRegister, false)
			if time <= 0 then
				GetMoney = false
				StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
			end
		end
	end)
end

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(8.00,-1604.92, 29.37)
	SetBlipSprite(blip, 52)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 73)  
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pedro's Tacos")
    EndTextCommandSetBlipName(blip)
end)

--[[ Citizen.CreateThread(function()
	TacoVoorraad = AddBlipForCoord(650.68, 2727.25, 41.99)
    SetBlipSprite (TacoVoorraad, 569)
    SetBlipDisplay(TacoVoorraad, 4)
    SetBlipScale  (TacoVoorraad, 0.7)
    SetBlipAsShortRange(TacoVoorraad, true)
    SetBlipColour(TacoVoorraad, 39)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Taco Shop opslag")
    EndTextCommandSetBlipName(TacoVoorraad)
end) ]]

RegisterNetEvent('is-bankrobbery:client:executeEvents')
AddEventHandler('is-bankrobbery:client:executeEvents', function()
    TriggerServerEvent('is-bankrobbery:server:recieveItem', 'paleto')
    TriggerServerEvent('is-bankrobbery:server:recieveItem', 'pacific')
    TriggerServerEvent('is-bankrobbery:server:recieveItem', 'small')
end)