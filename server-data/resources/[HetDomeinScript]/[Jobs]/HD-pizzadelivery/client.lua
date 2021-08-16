------------
-- CONFIG --
------------

Config = {}

Config.Zones = {

	Vehicle = {
		Pos   = {x = 538.17, y = 101.61, z = 95.63}
	},

	Spawn = {
        Pos   = {x = 548.39, y = 125.23, z = 96.47, h = 70.0},
        Heading = 70.0
	},

}

---------
-- ESX --
---------

HDCore = nil
PlayerData = {}
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)


RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerData = HDCore.Functions.GetPlayerData()
end)
-------------
-- Variables --
-------------

local InService = false
local Hired = true
local BlipSell = nil
local BlipEnd = nil
local BlipCancel = nil
local TargetPos = nil
local HasPizza = false
local NearVan = false
local LastGoal = 0
local DeliveriesCount = 0
local Delivered = false
local xxx = nil
local yyy = nil
local zzz = nil
local Blipy = {}
local JuzBlip = false
local PizzaDelivered = false
local ownsVan = false

---------------
-- Functions --
---------------

-- Create Job Blip
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if not JuzBlip then
            Blipy['praca'] = AddBlipForCoord(538.17, 101.61, 96.53)
            SetBlipSprite(Blipy['praca'], 93)
            SetBlipDisplay(Blipy['praca'], 0)
            SetBlipScale(Blipy['praca'], 0.7)
            SetBlipAsShortRange(Blipy['praca'], true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Pizza This')
            EndTextCommandSetBlipName(Blipy['praca'])
						JuzBlip = true
        end
    end
end)

--Spawn Van
function PullOutVehicle()
    if ownsVan == true then
        HDCore.Functions.Notify("Je hebt al een voertuig", "error")
    elseif ownsVan == false then
        coords = Config.Zones.Spawn.Pos
        HDCore.Functions.SpawnVehicle('panto', function(veh)
            SetVehicleNumberPlateText(veh, "PIZZA"..tostring(math.random(1000, 9999)))
            SetEntityHeading(veh, coords.h)
            exports['HD-fuel']:SetFuelLevel(veh, GetVehicleNumberPlateText(veh), 100, false)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            exports['HD-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
            SetVehicleEngineOn(veh, true, true)
            plaquevehicule = GetVehicleNumberPlateText(veh)
        end, coords, true)
        InService = true
        DrawTarget()
        AddCancelBlip()
        ownsVan = true
        TriggerServerEvent("RoutePizza:TakeDeposit")
    end
end

-- Garaz
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Hired then
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            local dist = GetDistanceBetweenCoords(pos, Config.Zones.Vehicle.Pos.x, Config.Zones.Vehicle.Pos.y, Config.Zones.Vehicle.Pos.z, true)
            if dist <= 2.5 then
                local GaragePos = {
                    ["x"] = Config.Zones.Vehicle.Pos.x,
                    ["y"] = Config.Zones.Vehicle.Pos.y,
                    ["z"] = Config.Zones.Vehicle.Pos.z + 1
                }
                DrawText3Ds(GaragePos["x"],GaragePos["y"],GaragePos["z"], "~g~E~s~ - Pizza's Bezorgen")
                if dist <= 3.0 then
                    if IsControlJustReleased(0, 38) then
                        PullOutVehicle()
                    end
                end
            end
        end
    end
end)

-------------------
-- Target Search --
-------------------

function DrawTarget()
    local RandomPoint = math.random(1, 21)
    if DeliveriesCount == 4 then
        HDCore.Functions.Notify("Alle pizza's zijn bezorgd","success")
        RemoveCancelBlip()
        SetBlipRoute(BlipSell, false)
        AddFinnishBlip()
        Delivered = true
				xxx = nil
				yyy = nil
				zzz = nil
    else
      local pizza = 5 - DeliveriesCount
      if pizza == 1 then
        HDCore.Functions.Notify("Je moet 1 pizza leveren.","success")
      else
        if pizza == 5 then
            pizza = '5'
        elseif pizza == 4 then
          pizza = '4'
        elseif pizza == 3 then
          pizza = '3'
        elseif pizza == 2 then
          pizza = '2'
        end
        HDCore.Functions.Notify("Je moet "..pizza.." pizza's leveren.","success")
      end
        if LastGoal == RandomPoint then
            DrawTarget()
        else
            if RandomPoint == 1 then
								xxx =-37.53
								yyy =170.36
								zzz =95.36
                LastGoal = 1
            elseif RandomPoint == 2 then
								xxx =-149.89
								yyy =123.84
								zzz =70.23
                LastGoal = 2
            elseif RandomPoint == 3 then
								xxx =-438.04
								yyy =-66.69
								zzz =43.0
                LastGoal = 3
            elseif RandomPoint == 4 then
								xxx =-998.28
								yyy =158.14
								zzz =62.32
                LastGoal = 4
            elseif RandomPoint == 5 then
								xxx =-598.85
								yyy =170.47
								zzz =66.06
                LastGoal = 5
            elseif RandomPoint == 6 then
								xxx =-53.17
								yyy =-397.4
								zzz =38.13
                LastGoal = 6
            elseif RandomPoint == 7 then
								xxx =-315.36
								yyy =-1036.46
								zzz =36.35
                LastGoal = 7
            elseif RandomPoint == 8 then
								xxx =57.13
								yyy =-1004.96
								zzz =29.36
                LastGoal = 8
            elseif RandomPoint == 9 then
								xxx =288.05
								yyy =-1094.91
								zzz =29.42
                LastGoal = 9
            elseif RandomPoint == 10 then
								xxx =296.18
								yyy =-1027.4
								zzz =29.21
                LastGoal = 10
            elseif RandomPoint == 11 then -- zrobione
								xxx =298.74
								yyy =-759.07
								zzz =29.39
                LastGoal = 11
            elseif RandomPoint == 12 then
								xxx =1139.28
								yyy =-342.14
								zzz =67.05
                LastGoal = 12
            elseif RandomPoint == 13 then
								xxx =1262.44
								yyy =-429.95
								zzz =70.01
                LastGoal = 13
            elseif RandomPoint == 14 then
								xxx =862.55
								yyy =-138.6
								zzz =79.21
                LastGoal = 14
            elseif RandomPoint == 15 then
								xxx =-2.37
								yyy =-1496.36
								zzz =31.85
                LastGoal = 15
            elseif RandomPoint == 16 then
								xxx =252.98
								yyy =-1670.91
								zzz =29.66
                LastGoal = 16
            elseif RandomPoint == 17 then
								xxx =431.27
								yyy =-1725.51
								zzz =29.6
                LastGoal = 17
            elseif RandomPoint == 18 then
								xxx =-345.32
								yyy =17.94
								zzz =47.86
                LastGoal = 18
            elseif RandomPoint == 19 then
								xxx =-1252.85
								yyy =-1144.57
								zzz =8.51
                LastGoal = 19
            elseif RandomPoint == 20 then
								xxx =441.31
								yyy =-981.99
								zzz =30.69
                LastGoal = 20
            elseif RandomPoint == 21 then
								xxx =308.75
								yyy =-592.54
								zzz =43.28
                LastGoal = 21
            end
		    AddObjBlip(TargetPos)
        end
    end
end

--------------------
-- Creating Blips --
--------------------

-- Blip celu podrózy
function AddObjBlip(TargetPos)
    Blipy['obj'] = AddBlipForCoord(xxx, yyy, zzz)
    SetBlipRoute(Blipy['obj'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Klant')
	EndTextCommandSetBlipName(Blipy['obj'])
end

-- Blip anulowania pracy
function AddCancelBlip()
    Blipy['cancel'] = AddBlipForCoord(558.52, 121.27, 97.37)
		SetBlipColour(Blipy['cancel'], 59)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Cancel orders')
	EndTextCommandSetBlipName(Blipy['cancel'])
end

-- Blip zakonczenia pracy
function AddFinnishBlip()
    Blipy['end'] = AddBlipForCoord(571.25, 116.78, 97.36)
		SetBlipColour(Blipy['end'], 2)
    SetBlipRoute(Blipy['end'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Klaar met werken')
	EndTextCommandSetBlipName(Blipy['end'])
end

------------------
-- Delete Blips --
------------------

function RemoveBlipObj()
    RemoveBlip(Blipy['obj'])
end

function RemoveCancelBlip()
    RemoveBlip(Blipy['cancel'])
end

function RemoveAllBlips()
    RemoveBlip(Blipy['obj'])
    RemoveBlip(Blipy['cancel'])
    RemoveBlip(Blipy['end'])
end

-------------------
-- DELIVERY AREA --
-------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local dist = GetDistanceBetweenCoords(pos, xxx, yyy, zzz, true)
        if dist <= 20.0 and Hired and (not HasPizza) then
            local DeliveryPoint = {
                ["x"] = xxx,
                ["y"] = yyy,
                ["z"] = zzz
            }
            DrawText3Ds(DeliveryPoint["x"],DeliveryPoint["y"],DeliveryPoint["z"], "Pak een pizza uit je voertuig")
            local Vehicle = GetClosestVehicle(pos, 6.0, 0, 70)
            if IsVehicleModel(Vehicle, GetHashKey('panto')) then
                local VehPos = GetEntityCoords(Vehicle)
								local distance = GetDistanceBetweenCoords(pos, VehPos, true)
                DrawText3Ds(VehPos.x,VehPos.y,VehPos.z, "~g~E~s~ - Pizza Pakken")
								if dist >= 4 and distance <= 5 then
                	                NearVan = true
								end
            end
        elseif dist <= 25 and HasPizza and Hired then
            local DeliveryPoint = {
                ["x"] = xxx,
                ["y"] = yyy,
                ["z"] = zzz
            }
            DrawText3Ds(DeliveryPoint["x"],DeliveryPoint["y"],DeliveryPoint["z"], "~g~E~s~ - Leveren")
            if dist <= 3 then
                if IsControlJustReleased(0, 38) then
                    TakePizza()
                    DeliverPizza() 
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if (not HasPizza) and NearVan then
			if IsControlJustReleased(0, 38) then
                TakePizza()
                NearVan = false
			end
		end
	end
end)

-------------------
-- DELIVER PIZZA --
-------------------

function loadAnimDict(dict)
	while ( not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end

function TakePizza()
    local player = GetPlayerPed(-1)
    if not IsPedInAnyVehicle(player, false) then
        local ad = "anim@heists@box_carry@"
        local prop_name = 'prop_pizza_box_01'
        if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
            loadAnimDict( ad )
            if HasPizza then
                TaskPlayAnim( player, ad, "exit", 3.0, 1.0, -1, 49, 0, 0, 0, 0 )
                DetachEntity(prop, 1, 1)
                DeleteObject(prop)
                Wait(1000)
                ClearPedSecondaryTask(PlayerPedId())
                HasPizza = false
            else
                local x,y,z = table.unpack(GetEntityCoords(player))
                prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
                AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 60309), 0.2, 0.08, 0.2, -45.0, 290.0, 0.0, true, true, false, true, 1, true)
                TaskPlayAnim( player, ad, "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
                HasPizza = true
            end
        end
    end
end

function DeliverPizza()
    if not PizzaDelivered then
        PizzaDelivered = true
        DeliveriesCount = DeliveriesCount + 1
        RemoveBlipObj()
        SetBlipRoute(BlipSell, false)
        HasPizza = false    
        NextDelivery()
        Citizen.Wait(2500)
        PizzaDelivered = false
    end
end

function NextDelivery()
    TriggerServerEvent('RoutePizza:Payment')
    Citizen.Wait(300)
    DrawTarget()
end
-----------------
-- END OF WORK --
-----------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local DistanceFromEndZone = GetDistanceBetweenCoords(pos, 571.25, 116.78, 97.36, true)
        local DistanceFromCancelZone = GetDistanceBetweenCoords(pos, 558.52, 121.27, 97.37, true)
        if InService then
            if Delivered then
                if DistanceFromEndZone <= 2.5 then
                    local endPoint = { --x = 571.25, y = 116.78, z = 97.36
                        ["x"] = 571.25,
                        ["y"] = 116.78,
                        ["z"] = 97.36
                    }
                    DrawText3Ds(endPoint["x"],endPoint["y"],endPoint["z"], "~g~E~s~ - Werk afronden")
                    if DistanceFromEndZone <= 7 then
                        if IsControlJustReleased(0, 38) then
                            EndOfWork()
                        end
                    end
                end
            else
                if DistanceFromCancelZone <= 2.5 then
                    local cancel = { --x = 558.52, y = 121.27, z = 97.37
                        ["x"] = 558.52,
                        ["y"] = 121.27,
                        ["z"] = 97.37
                    }
                    DrawText3Ds(cancel["x"],cancel["y"],cancel["z"], "~g~E~s~ - Werk annuleren")
                    if DistanceFromCancelZone <= 7 then
                        if IsControlJustReleased(0, 38) then
                            HDCore.Functions.Notify("Orders geannuleerd", "error")
							EndOfWork()
                        end
                    end
                end
            end
        end
    end
end)

function EndOfWork()
    RemoveAllBlips()
    local ped = GetPlayerPed(-1)
    if IsPedInAnyVehicle(ped, false) then
        local Van = GetVehiclePedIsIn(ped, false)
        if IsVehicleModel(Van, GetHashKey('panto')) then
            HDCore.Functions.DeleteVehicle(Van)
            if Delivered == true then
                TriggerServerEvent("RoutePizza:ReturnDeposit", 'end')
            end
            InService = false
            BlipSell = nil
            BlipEnd = nil
            BlipCancel = nil
            TargetPos = nil
            HasPizza = false
            LastGoal = nil
            DeliveriesCount = 0
            xxx = nil
            yyy = nil
            zzz = nil
            ownsVan = false
            Delivered = false
        else
            HDCore.Functions.Notify("Je moet terug naar Pizza This", "error")
        end
    else
        InService = false
        BlipSell = nil
        BlipEnd = nil
        BlipCancel = nil
        TargetPos = nil
        HasPizza = false
        LastGoal = nil
        DeliveriesCount = 0
        xxx = nil
        yyy = nil
        zzz = nil
        ownsVan = false
        Delivered = false
    end
end

----------------------
-- 3D text function --
----------------------
DrawText3Ds = function(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	--DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end