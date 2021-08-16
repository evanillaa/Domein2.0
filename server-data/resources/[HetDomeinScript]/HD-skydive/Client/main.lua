HDCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if HDCore == nil then
            TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

PlayerJob = {}
LoggedIn = true

local purchase = false 
local hyo23 = false 
local banamera = false
local Vliegtuig = nil

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(500, function()
        TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
        Citizen.Wait(150)
        LoggedIn = true
    end)
end)


RegisterNetEvent('HDCore:Client:OnJobUpdate')
AddEventHandler('HDCore:Client:OnJobUpdate', function(JobInfo)
    LoggedIn = true
    PilotVehicle = nil
    hasPlane = false
    hasBag = false
    PilotLocation = 0
    DeliveryBlip = nil
    IsWorking = false
    AmountOfBags = 0
    PilotObject = nil
    EndBlip = nil
    PlayerJob = JobInfo
end)

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

RegisterNetEvent('HD-skydive:client:spawned')
AddEventHandler('HD-skydive:client:spawned', function(value, heli)
	passenger = value
	syncHeli = heli
end)

Citizen.CreateThread(function() -- Ped
    JanSkyDive = GetHashKey("s_m_y_airworker")
    RequestModel(JanSkyDive)
    while not HasModelLoaded(JanSkyDive) do
    Wait(5)
    end
  
    JanSkyDive_ped = CreatePed(5, JanSkyDive , -1131.78, -2878.26, 13.95 - 1, 146.14, 0, 0)
    FreezeEntityPosition(JanSkyDive_ped, true) 
    SetEntityInvincible(JanSkyDive_ped, true)
    SetBlockingOfNonTemporaryEvents(JanSkyDive_ped, true)
    TaskStartScenarioInPlace(JanSkyDive_ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
end)

RegisterNetEvent('HD-skydive:client:Skydive')
AddEventHandler('HD-skydive:client:Skydive', function()
    HDCore.Functions.TriggerCallback('HD-skydive:server:HasMoney', function(HasMoney)
    if HasMoney then
        HDCore.Functions.Notify("Je hebt €2000,- betaald", "success")
        HDCore.Functions.Notify("Veel Skydive fun", "success")        
	    modelHash = GetHashKey(Config.spawnedheli)
	    pilotModel = GetHashKey(Config.pilot)
	
        local CoordTable =  Config.Locations["vehicle"].coords

	    RequestModel(modelHash)
	    while not HasModelLoaded(modelHash) do
	    Citizen.Wait(0)
	    end
	
	    RequestModel(pilotModel)
	    while not HasModelLoaded(pilotModel) do
	    Citizen.Wait(0)
	    end
	
	    if HasModelLoaded(modelHash) and HasModelLoaded(pilotModel) then
		    --ClearAreaOfEverything(v.coords.x, v.coords.y, v.coords.z, 10, false, false, false, false, false)
		    if DoesEntityExist(globalveh) then
			    --ESX.Game.DeleteVehicle(globalveh)
		    end
        
            HDCore.Functions.SpawnVehicle(modelHash, function(AirPlane)
                Vliegtuig = AirPlane
                print("aanmaken van heli")
		        SetVehicleEngineOn(Vliegtuig, true, true, true)
		        SetEntityProofs(Vliegtuig, true, true, true, true, true, true, true, false)
		        pilot = CreatePedInsideVehicle(Vliegtuig, 6, pilotModel, -1, true, false)
		        SetEntityAsMissionEntity(Vliegtuig, true, true)
		        SetVehicleHasBeenOwnedByPlayer(Vliegtuig, true)
		        SetBlockingOfNonTemporaryEvents(pilot, true)
		        ready = true
                print("ready")
		        SetVehicleUndriveable(Vliegtuig, false)
		        TaskWarpPedIntoVehicle(GetPlayerPed(-1), Vliegtuig, 0)
		        TriggerServerEvent('HD-skydive:server:spawned', true , GetVehicleNumberPlateText(Vliegtuig))
		        --SetVehicleDoorsLockedForAllPlayers(PilotVehicle, true)
		        SetPedCanBeDraggedOut(pilot, false)
                exports['HD-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vliegtuig), true)
		        Citizen.Wait(1000*Config.timetotakeoff)
                print("15 sec voorbij")
		        TriggerServerEvent('HD-skydive:server:spawned', false , 0)
		        TaskVehicleDriveToCoord(pilot, Vliegtuig, -2910.3786621094,-2533.8823242188,1188.837890625, 17.0, 0, modelHash, 2883621, 1, true)
                print("task drive to coords")
		        SetPedKeepTask(pilot, true)
		        enroute = true
		        while enroute do
			        Citizen.Wait(10)
			        distanceToTarget = GetDistanceBetweenCoords(-2910.3786621094,-2533.8823242188,1188.837890625, GetEntityCoords(Vliegtuig).x, GetEntityCoords(Vliegtuig).y, GetEntityCoords(Vliegtuig).z, true)
			        --print(distanceToTarget)
			        if distanceToTarget < 10 then
				        hyo23 = true
                        HDCore.Functions.DeleteVehicle(Vliegtuig)
				        DeleteEntity(pilot)
				        SetEntityAsNoLongerNeeded(pilot)
				        SetEntityAsNoLongerNeeded(Vliegtuig)
				        SetPedKeepTask(pilot, false)
				        wait(5000)
				        DeletePed(pilot)
				        ready = false
                        HDCore.DeleteVehicle.DeleteVehicle(Vliegtuig)
				        banamera = false
				        break
			        end   
                end
            end, CoordTable, true, true)    
	    end
    else
        HDCore.Functions.Notify("Je hebt niet genoeg geld...", "error")     
    end
    end)
end)


Citizen.CreateThread(function()
    while true do
            Citizen.Wait(10)
            if HDCore == nil then
                TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)
                Citizen.Wait(200)
            end
	    local ply = GetPlayerPed(-1)
	    local plyCoords = GetEntityCoords(ply)
	    local helio = HDCore.Functions.GetClosestVehicle(plyCoords, Config.spawnedheli2)
	    local vehCoords = GetEntityCoords(helio)
	    if Config.shareyourtrip then
		    for k,v in pairs(Config.SkyDive) do
			    if (GetDistanceBetweenCoords(plyCoords, v.spawn.x, v.spawn.y, v.spawn.z, true) < 5) and GetDistanceBetweenCoords( vehCoords, plyCoords) < 5 then
				    SetTextComponentFormat("STRING");
				    AddTextComponentString("Druk ~INPUT_CONTEXT~ om met jouw vriend mee te gaan!");
				    DisplayHelpTextFromStringLabel(0, false, true, -1);  
				    if IsControlJustPressed(1, 51) then
					    SetPedIntoVehicle(ply, helio, math.random(2,3))
				    end
			    end
		    end
	    end
    end    
end)