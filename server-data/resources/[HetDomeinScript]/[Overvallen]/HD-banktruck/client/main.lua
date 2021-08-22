HDCore = nil

local CurrentCops = 0


RegisterNetEvent("HDCore:Client:OnPlayerLoaded")
AddEventHandler("HDCore:Client:OnPlayerLoaded", function()
  Citizen.SetTimeout(1000, function()
      TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)
      Citizen.Wait(150)
      HDCore.Functions.TriggerCallback('HD-banktruck:server:GetConfig', function(config)
          config = Config
      end)
  end)
end)

RegisterNetEvent('HD-police:SetCopCount')
AddEventHandler('HD-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)

-- Code

RegisterNetEvent('HD-truckrob:client:UseCard')
AddEventHandler('HD-truckrob:client:UseCard', function()
local Vehicle = HDCore.Functions.GetClosestVehicle()
local model = GetDisplayNameFromVehicleModel(GetEntityModel(Vehicle))
local PedPos = GetEntityCoords(GetPlayerPed(-1))
local GetTruckCoords = GetOffsetFromEntityInWorldCoords(Vehicle, 0.0, -2.0, 1.0)
local TruckDist = GetDistanceBetweenCoords(PedPos.x, PedPos.y, PedPos.z, GetTruckCoords.x, GetTruckCoords.y, GetTruckCoords.z, true)
local Plate = GetVehicleNumberPlateText(Vehicle)
if TruckDist <= 5.0 then
    if model:lower() == 'stockade' then
        if CurrentCops >= Config.PoliceNeeded then
          if not Config.RobbedPlates[Plate] then
            local StreetLabel = HDCore.Functions.GetStreetLabel()
            TriggerEvent('HD-inventory:client:set:busy', true)
            TriggerServerEvent('HD-police:server:send:banktruck:alert', GetEntityCoords(GetPlayerPed(-1)), Plate, StreetLabel)
            StartRobbingVan(Vehicle)
           else
            HDCore.Functions.Notify("Deze truck is recent overvallen..", "error")
            end
        else
            HDCore.Functions.Notify("Niet genoeg politie.. (4 nodig)", "error")
        end
          else
              HDCore.Functions.Notify("Dit is geen geld wagen..", "error")
          end
      else
          HDCore.Functions.Notify("Geen truck in de buurt..", "error")
    end
end)

RegisterNetEvent('HD-banktruck:plate:table')
AddEventHandler('HD-banktruck:plate:table', function(Plate)
    Config.RobbedPlates[Plate] = true
end)

function StartRobbingVan(Veh)
    IsRobbing = true
    local TimeSearch = math.random(25000, 55000)
    local Coords = GetEntityCoords(Veh)
    local PedPos = GetEntityCoords(GetPlayerPed(-1))
    if math.random(1, 100) <= 65 and not IsWearingHandshoes() then
        TriggerServerEvent("HD-police:server:CreateFingerDrop", GetEntityCoords(GetPlayerPed(-1)))
    end
    SearchAnim()
    HDCore.Functions.Progressbar("open_locker", "Bank pas gebruiken..", math.random(8000, 10000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        IsRobbing = false
        local Plate = GetVehicleNumberPlateText(Veh)
        TriggerServerEvent('HD-bankrob:server:remove:card')
        TriggerEvent('HD-inventory:client:set:busy', false)
        TriggerServerEvent('HD-banktruck:server:OpenTruck', Veh)
        TriggerServerEvent('HD-banktruck:server:set:truckamount', 'Count-Minus', 1)
        StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
        HDCore.Functions.Notify("Gelukt!", "success")
    end, function() -- Cancel
        IsRobbing = false
        TriggerEvent('HD-inventory:client:set:busy', false)
        StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
        HDCore.Functions.Notify("Geannuleerd..", "error")
    end)
    Citizen.CreateThread(function()
        while IsRobbing do
            TriggerServerEvent('HD-hud:Server:gain:stress', math.random(2, 4))
            Citizen.Wait(12000)
        end
    end)
end

function SearchAnim()
    exports['HD-assets']:RequestAnimationDict("anim@gangops@facility@servers@")
    TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire" ,3.0, 3.0, -1, 16, 0, false, false, false)
    Citizen.CreateThread(function()
        while IsRobbing do
            TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(1000)
        end
   end)
end

RegisterNetEvent('HD-banktruck:client:OpenTruck')
AddEventHandler('HD-banktruck:client:OpenTruck', function(Veh)
    local Plate = GetVehicleNumberPlateText(Veh)
    RequestModel("s_m_m_armoured_01")
    while not HasModelLoaded("s_m_m_armoured_01") do
        Wait(10)
    end
    RequestModel("s_m_m_armoured_02")
    while not HasModelLoaded("s_m_m_armoured_02") do
        Wait(10)
    end
    SetVehicleUndriveable(Veh, true)
    SetVehicleEngineHealth(Veh, 100.0)
    SetVehicleBodyHealth(Veh, 100.0)
    SetEntityAsNoLongerNeeded(Veh)
    for i = -1, 4 do
    Citizen.Wait(1) 
    --local Yew = CreatePedInsideVehicle(Veh, 5, "s_m_m_armoured_01", i, 1, 1), CreatePedInsideVehicle(Veh, 5, "s_m_m_armoured_02", i, 1, 1)
    local Yew1 = CreatePedInsideVehicle(Veh, 5, "s_m_m_armoured_01", 1, 1, 1)
    local Yew2 = CreatePedInsideVehicle(Veh, 5, "s_m_m_armoured_02", 2, 1, 1)
    SetPedShootRate(Yew1, 750)
    SetPedShootRate(Yew2, 750)
    SetPedCombatAttributes(Yew1, 46, true)
    SetPedCombatAttributes(Yew2, 46, true)
    SetPedFleeAttributes(Yew1, 0, 0)
    SetPedFleeAttributes(Yew2, 0, 0)
    SetPedAsEnemy(Yew1,true)
    SetPedAsEnemy(Yew2,true)
    SetPedArmour(Yew1, 200.0)
    SetPedArmour(Yew2, 200.0)
    SetPedMaxHealth(Yew1, 900.0)
    SetPedMaxHealth(Yew2, 900.0)
    SetPedAlertness(Yew1, 3)
    SetPedAlertness(Yew2, 3)
    SetPedCombatRange(Yew1, 0)
    SetPedCombatRange(Yew2, 0)
    SetPedCombatMovement(Yew1, 3)
    SetPedCombatMovement(Yew2, 3)
    TaskCombatPed(Yew1, GetPlayerPed(-1), 0,16)
    TaskCombatPed(Yew2, GetPlayerPed(-1), 0,16)
    TaskLeaveVehicle(Yew1, Veh, 256)
    TaskLeaveVehicle(Yew2, Veh, 256)
    GiveWeaponToPed(Yew1, GetHashKey("WEAPON_PISTOL_MK2"), 5000, true, true)
    GiveWeaponToPed(Yew2, GetHashKey("WEAPON_PISTOL_MK2"), 5000, true, true)
    SetPedRelationshipGroupHash(Yew1, GetHashKey("HATES_PLAYER"))
    SetPedRelationshipGroupHash(Yew2, GetHashKey("HATES_PLAYER"))
    end
    SetVehicleDoorOpen(Veh, 2, false, true)
    SetVehicleDoorOpen(Veh, 3, false, true)
    RobbingVan = true
    Citizen.CreateThread(function()
        while RobbingVan do
            Citizen.Wait(5)
            local PedPos = GetEntityCoords(GetPlayerPed(-1))
            local GetTruckCoords = GetOffsetFromEntityInWorldCoords(Veh, 0.0, -3.5, 0.5)
            local TruckDist = GetDistanceBetweenCoords(PedPos.x, PedPos.y, PedPos.z, GetTruckCoords.x, GetTruckCoords.y, GetTruckCoords.z, true)
            if TruckDist <= 4.2 then
            if not Config.RobbedPlates[Plate] then
             DrawText3D(GetTruckCoords.x, GetTruckCoords.y, GetTruckCoords.z, '~g~E~s~ - Spullen Stelen')
             DrawMarker(2, GetTruckCoords.x, GetTruckCoords.y, GetTruckCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
             if IsControlJustPressed(0, 38) then
                TriggerServerEvent('HD-banktruck:server:updateplates', Plate)
                RobbingVan = false
                KankerJanken()
             end
            end
          end
        end
    end)
end)

function KankerJanken()
    LeegTrekken = true
    if math.random(1, 100) <= 85 and not IsWearingHandshoes() then
        TriggerServerEvent("HD-police:server:CreateFingerDrop", GetEntityCoords(GetPlayerPed(-1)))
    end
    HDCore.Functions.Progressbar("open_locker", "Spullen Stelen..", math.random(34000, 58000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@heists@ornate_bank@grab_cash_heels",
        anim = "grab",
        flags = 16,
    }, {
       model = "prop_cs_heist_bag_02",
       bone = 57005,
       coords = { x = -0.005, y = 0.00, z = -0.16 },
       rotation = { x = 250.0, y = -30.0, z = 0.0 },
    }, {}, function() -- Done
        LeegTrekken = false
        StopAnimTask(GetPlayerPed(-1), "anim@heists@ornate_bank@grab_cash_heels", "grab", 1.0)
        HDCore.Functions.Notify("Gelukt!", "success")
    end, function() -- Cancel
        LeegTrekken = false
        StopAnimTask(GetPlayerPed(-1), "anim@heists@ornate_bank@grab_cash_heels", "grab", 1.0)
        HDCore.Functions.Notify("Geannuleerd..", "error")
    end)
    Citizen.CreateThread(function()
        while LeegTrekken do
            -- Als je dit triggert zie ik dat je cheat kanker nerd.
            TriggerServerEvent('blijf:uit:mijn:scripts:rewards')
            Citizen.Wait(6500)
        end
    end)
    Citizen.CreateThread(function()
        while LeegTrekken do
            TriggerServerEvent('HD-hud:Server:gain:stress', math.random(2, 4))
            Citizen.Wait(12000)
        end
    end)
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

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(GetPlayerPed(-1), 3)
    local model = GetEntityModel(GetPlayerPed(-1))
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

--// Test nieuwe banktruck systeem yeahletsgo \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 707.23, -966.91, 30.41, true)
        if Distance < 1.5 then
            --[[ DrawMarker(2, 707.23, -966.91, 30.41, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
            DrawText3D(707.23, -966.91, 30.41 + 0.15, '~g~E~w~ - Hacken')
            if IsControlJustPressed(0, 38) then
                StartMiniGame()
            end ]]
        end
    end
end)

RegisterNetEvent("HD-banktruck:client:startMission")
AddEventHandler("HD-banktruck:client:startMission",function(spot)
	local num = math.random(1,#Config.ArmoredTruck)
	local numy = 0
	while Config.ArmoredTruck[num].InUse and numy < 100 do
		numy = numy+1
		num = math.random(1,#Config.ArmoredTruck)
	end
	if numy == 100 then
		--ESX.ShowNotification(Config.NoMissionsAvailable)
	else
		CurrentEventNum = num
		TriggerEvent("HD-banktruck:client:startTheEvent",num)
		--PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
		--ESX.ShowNotification(Config.TruckMarkedOnMap)
	end
end)

RegisterNetEvent("HD-banktruck:client:starthacking")
AddEventHandler("HD-banktruck:client:starthacking",function()
	StartMiniGame()
end)

RegisterNetEvent('HD-banktruck:client:startTheEvent')
AddEventHandler('HD-banktruck:client:startTheEvent', function(num)
	
	local loc = Config.ArmoredTruck[num]
	Config.ArmoredTruck[num].InUse = true
	local playerped = GetPlayerPed(-1)
	
	TriggerServerEvent("HD-banktruck:client:syncMissionData",Config.ArmoredTruck)

	RequestModel(GetHashKey('stockade'))
	while not HasModelLoaded(GetHashKey('stockade')) do
		Citizen.Wait(0)
	end

	ClearAreaOfVehicles(loc.Location.x, loc.Location.y, loc.Location.z, 15.0, false, false, false, false, false) 	
	ArmoredTruckVeh = CreateVehicle(GetHashKey('stockade'), loc.Location.x, loc.Location.y, loc.Location.z, -2.436,  996.786, 25.1887, true, true)
	SetEntityAsMissionEntity(ArmoredTruckVeh)
	SetEntityHeading(ArmoredTruckVeh, 52.00)
	
	local taken = false
	local blip = CreateMissionBlip(loc.Location)
	
    RequestModel("s_m_m_armoured_01")
    while not HasModelLoaded("s_m_m_armoured_01") do
        Wait(10)
    end
    RequestModel("s_m_m_armoured_02")
    while not HasModelLoaded("s_m_m_armoured_02") do
        Wait(10)
    end
	
	local TruckDriver = CreatePedInsideVehicle(ArmoredTruckVeh, 1, "s_m_m_armoured_02", -1, true, true)
	local TruckPassenger = CreatePedInsideVehicle(ArmoredTruckVeh, 1, "s_m_m_armoured_01", 0, true, true)
	
	SetPedFleeAttributes(TruckDriver, 0, 0)
	SetPedFleeAttributes(TruckPassenger, 0, 0)
	SetPedCombatAttributes(TruckDriver, 46, 1)
	SetPedCombatAttributes(TruckPassenger, 46, 1)
	SetPedCombatAbility(TruckDriver, 100)
	SetPedCombatAbility(TruckPassenger, 100)
	SetPedCombatMovement(TruckDriver, 2)
	SetPedCombatMovement(TruckPassenger, 2)
	SetPedCombatRange(TruckDriver, 2)
	SetPedCombatRange(TruckPassenger, 2)
	SetPedKeepTask(TruckDriver, true)
	SetPedKeepTask(TruckPassenger, true)
	TaskEnterVehicle(TruckPassenger,ArmoredTruckVeh,-1,0,1.0,1)
	GiveWeaponToPed(TruckDriver, GetHashKey("WEAPON_PISTOL_MK2"),250,false,true)
	GiveWeaponToPed(TruckPassenger, GetHashKey("WEAPON_PISTOL_MK2"),250,false,true)
	SetPedAsCop(TruckDriver, true)
	SetPedAsCop(TruckPassenger, true)
	SetPedDropsWeaponsWhenDead(TruckDriver, false)
	SetPedDropsWeaponsWhenDead(TruckPassenger, false)
	TaskVehicleDriveWander(TruckDriver, ArmoredTruckVeh, 80.0, 443)
	
	missionInProgress = true
	
	while not taken do
		Citizen.Wait(3)
		
		if missionInProgress == true then
			local pos = GetEntityCoords(GetPlayerPed(-1), false)
			local TruckPos = GetEntityCoords(ArmoredTruckVeh) 
			local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, TruckPos.x, TruckPos.y, TruckPos.z, false)
        end
		
		if missionCompleted == true then
			--ESX.ShowNotification(Config.MissionCompleted)
			Config.ArmoredTruck[num].InUse = false
			RemoveBlip(blip)
			TriggerServerEvent("HD-banktruck:client:syncMissionData",Config.ArmoredTruck)
			taken = true
			missionInProgress = false
			missionCompleted = false
			TruckIsExploded = false
			TruckIsDemolished = false
			KillGuardsText = false
			break
		end
		
	end
end)

function CreateMissionBlip(location)
    local blip = AddBlipForEntity(ArmoredTruckVeh)
	SetBlipSprite(blip, 461)
	SetBlipColour(blip, 2)
	AddTextEntry('MYBLIP', 'Banktruck')
	BeginTextCommandSetBlipName('MYBLIP')
	AddTextComponentSubstringPlayerName(name)
	EndTextCommandSetBlipName(blip)
	SetBlipScale(blip, 0.53) 
	SetBlipAsShortRange(blip, true)
	return blip
end

RegisterNetEvent("HD-banktruck:client:syncMissionData")
AddEventHandler("HD-banktruck:client:syncMissionData",function(data)
	Config.ArmoredTruck = data
end)

function StartMiniGame()
    HDCore.Functions.TriggerCallback('HD-banktruck:server:HasItem', function(HasItem)
        if HasItem then
            exports['minigame-phone']:ShowHack()
            exports['minigame-phone']:StartHack(math.random(1,4), math.random(10,15), function(Success)
                if Success then
                    --TriggerServerEvent('HDCore:Server:RemoveItem', 'yellow-card', 1)
                    --TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['yellow-card'], "remove")
                    TriggerEvent('HD-inventory:client:set:busy', false)
                    HDCore.Functions.Notify("Je hebt de banktruck locatie gehacked", "success")
                    TriggerEvent('HD-banktruck:client:startMission')
                else
                    HDCore.Functions.Notify("Je hebt gefaalt..", "error")
                    --TriggerServerEvent('HD-jewellery:server:set:cooldown', false)
                    TriggerEvent('HD-inventory:client:set:busy', false)
                end
                exports['minigame-phone']:HideHack()
            end)
        else
            HDCore.Functions.Notify("Je mist iets..", "error")
        end
    end, "green-card")
end