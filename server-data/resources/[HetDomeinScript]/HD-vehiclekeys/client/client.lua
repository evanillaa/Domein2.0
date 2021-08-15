HDCore = nil

local IsRobbing = false
local LastVehicle = nil
local isLoggedIn = false

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
  Citizen.SetTimeout(1250, function()
      TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
      Citizen.Wait(100)
      HDCore.Functions.TriggerCallback("HD-vehiclekeys:server:get:key:config", function(config)
          Config = config
      end)
      isLoggedIn = true
  end)
end)

-- Code

-- // Loops \\ --
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if isLoggedIn then
        local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true))
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), true), -1) == GetPlayerPed(-1) then
            if LastVehicle ~= Vehicle then
            HDCore.Functions.TriggerCallback("HD-vehiclekeys:server:has:keys", function(HasKey)
                if HasKey then
                    HasCurrentKey = true
                    SetVehicleEngineOn(Vehicle, true, false, true)
                else 
                    HasCurrentKey = false
                    SetVehicleEngineOn(Vehicle, false, false, true)
                end
                LastVehicle = Vehicle
            end, Plate)  
            else
            Citizen.Wait(750)
          end
        else
            Citizen.Wait(750)
        end
        if not HasCurrentKey and IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) then
            local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            SetVehicleEngineOn(Vehicle, false, false, true)
        end
     end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if isLoggedIn then
            if not IsRobbing then 
                if GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) ~= nil and GetVehiclePedIsTryingToEnter(GetPlayerPed(-1)) ~= 0 then
                    local Vehicle = GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))
                    local Driver = GetPedInVehicleSeat(Vehicle, -1)
                    if Driver ~= 0 and not IsPedAPlayer(Driver) then
                       if IsEntityDead(Driver) then
                           IsRobbing = true
                           HDCore.Functions.Progressbar("rob_keys", "Grabbing Keys", 3000, false, true,
                            {}, {}, {}, {}, function()
                              SetVehicleKey(GetVehicleNumberPlateText(Vehicle, true), true)
                              IsRobbing = false
                           end) 
                       end
                    end
                end
             else
                Citizen.Wait(10)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if isLoggedIn then
            if IsControlJustReleased(1, Config.Keys["L"]) then
                ToggleLocks()
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('HD-vehiclekeys:client:toggle:engine')
AddEventHandler('HD-vehiclekeys:client:toggle:engine', function()
 local EngineOn = IsVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1)))
 local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
 local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true))
 HDCore.Functions.TriggerCallback("HD-vehiclekeys:server:has:keys", function(HasKey)
     if HasKey then
         if EngineOn then
             SetVehicleEngineOn(Vehicle, false, false, true)
         else
             SetVehicleEngineOn(Vehicle, true, false, true)
         end
     else
         HDCore.Functions.Notify("You have no keys to this vehicle.", 'error')
     end
 end, Plate)
end)

RegisterNetEvent('HD-vehiclekeys:client:set:keys')
AddEventHandler('HD-vehiclekeys:client:set:keys', function(Plate, CitizenId, bool)
    Config.VehicleKeys[Plate] = {['CitizenId'] = CitizenId, ['HasKey'] = bool}
    LastVehicle = nil
end)

RegisterNetEvent('HD-vehiclekeys:client:give:key')
AddEventHandler('HD-vehiclekeys:client:give:key', function(TargetPlayer)
    local Vehicle, VehDistance = HDCore.Functions.GetClosestVehicle()
    local Player, Distance = HDCore.Functions.GetClosestPlayer()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    HDCore.Functions.TriggerCallback("HD-vehiclekeys:server:has:keys", function(HasKey)
        if HasKey then
            if Player ~= -1 and Player ~= 0 and Distance < 2.3 then
                 HDCore.Functions.Notify("You gave keys to the vehicle with the license plate: "..Plate, 'success')
                 TriggerServerEvent('HD-vehiclekeys:server:give:keys', GetPlayerServerId(Player), Plate, true)
            else
                HDCore.Functions.Notify("No citizen nearby?", 'error')
            end
        else
            HDCore.Functions.Notify("You have no keys to this vehicle.", 'error')
        end
    end, Plate)
end)

RegisterNetEvent('HD-items:client:use:lockpick')
AddEventHandler('HD-items:client:use:lockpick', function(IsAdvanced)
 local Vehicle, VehDistance = HDCore.Functions.GetClosestVehicle()
 local Plate = GetVehicleNumberPlateText(Vehicle)
 local VehicleLocks = GetVehicleDoorLockStatus(Vehicle)
 if VehDistance <= 4.5 then
   HDCore.Functions.TriggerCallback("HD-vehiclekeys:server:has:keys", function(HasKey)
      if not HasKey then
       if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
          exports['HD-assets']:RequestAnimationDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
          TaskPlayAnim(GetPlayerPed(-1), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' ,3.0, 3.0, -1, 16, 0, false, false, false)
            exports['HD-lock']:StartLockPickCircle(function(Success)
             if Success then
                 SetVehicleKey(Plate, true)
                 StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
             else
                  if IsAdvanced then
                    if math.random(1,100) < 19 then
                      TriggerServerEvent('HDCore:Server:RemoveItem', 'advancedlockpick', 1)
                      TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['advancedlockpick'], "remove")
                    end
                  else
                    if math.random(1,100) < 35 then
                      TriggerServerEvent('HDCore:Server:RemoveItem', 'lockpick', 1)
                      TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['lockpick'], "remove")
                    end
                  end
                 HDCore.Functions.Notify("Failed.", 'error')
                 StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
             end
          end)
       else
          if VehicleLocks == 2 then
          exports['HD-assets']:RequestAnimationDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
          TaskPlayAnim(GetPlayerPed(-1), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' ,3.0, 3.0, -1, 16, 0, false, false, false)
         exports['HD-lock']:StartLockPickCircle(function(Success)
             if Success then
                 SetVehicleDoorsLocked(Vehicle, 1)
                 HDCore.Functions.Notify("Door broken open", 'success')
                 TriggerEvent('HD-vehicleley:client:blink:lights', Vehicle)
                 TriggerServerEvent("HD-sound:server:play:distance", 5, "car-unlock", 0.2)
                 StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
             else
                if IsAdvanced then
                    if math.random(1,100) < 25 then
                      TriggerServerEvent('HDCore:Server:RemoveItem', 'advancedlockpick', 1)
                      TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['advancedlockpick'], "remove")
                    end
                  else
                    if math.random(1,100) < 35 then
                      TriggerServerEvent('HDCore:Server:RemoveItem', 'lockpick', 1)
                      TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['lockpick'], "remove")
                    end
                end
                HDCore.Functions.Notify("Failed.", 'error')
                StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
             end
           end)
          end
       end
      end
   end, Plate)  
 end
end)

-- // Functions \\ --

function SetVehicleKey(Plate, bool)
 TriggerServerEvent('HD-vehiclekeys:server:set:keys', Plate, bool)
end

function ToggleLocks()
 local Vehicle, VehDistance = HDCore.Functions.GetClosestVehicle()
 if Vehicle ~= nil and Vehicle ~= 0 then
    local VehicleCoords = GetEntityCoords(Vehicle)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    local VehicleLocks = GetVehicleDoorLockStatus(Vehicle)
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if VehDistance <= 2.2 then
        HDCore.Functions.TriggerCallback("HD-vehiclekeys:server:has:keys", function(HasKey)
         if HasKey then
            exports['HD-assets']:RequestAnimationDict("anim@mp_player_intmenu@key_fob@")
            TaskPlayAnim(GetPlayerPed(-1), 'anim@mp_player_intmenu@key_fob@', 'fob_click' ,3.0, 3.0, -1, 49, 0, false, false, false)
            if VehicleLocks == 1 then
                Citizen.Wait(450)
                SetVehicleDoorsLocked(Vehicle, 2)
                ClearPedTasks(GetPlayerPed(-1))
                TriggerEvent('HD-vehicleley:client:blink:lights', Vehicle)
                HDCore.Functions.Notify("Voertuig vergrendeld", 'error')
                TriggerServerEvent("HD-sound:server:play:distance", 5, "car-lock", 0.2)
            else
                Citizen.Wait(450)
                SetVehicleDoorsLocked(Vehicle, 1)
                ClearPedTasks(GetPlayerPed(-1))
                TriggerEvent('HD-vehicleley:client:blink:lights', Vehicle)
                HDCore.Functions.Notify("Voertuig ontgrendeld", 'success')
                TriggerServerEvent("HD-sound:server:play:distance", 5, "car-unlock", 0.2)
            end
         else
            HDCore.Functions.Notify("You have no keys to this vehicle.", 'error')
        end
    end, Plate)
    end
 end
end

RegisterNetEvent('HD-vehicleley:client:blink:lights')
AddEventHandler('HD-vehicleley:client:blink:lights', function(Vehicle)
 SetVehicleLights(Vehicle, 2)
 SetVehicleBrakeLights(Vehicle, true)
 SetVehicleInteriorlight(Vehicle, true)
 SetVehicleIndicatorLights(Vehicle, 0, true)
 SetVehicleIndicatorLights(Vehicle, 1, true)
 Citizen.Wait(450)
 SetVehicleIndicatorLights(Vehicle, 0, false)
 SetVehicleIndicatorLights(Vehicle, 1, false)
 Citizen.Wait(450)
 SetVehicleInteriorlight(Vehicle, true)
 SetVehicleIndicatorLights(Vehicle, 0, true)
 SetVehicleIndicatorLights(Vehicle, 1, true)
 Citizen.Wait(450)
 SetVehicleLights(Vehicle, 0)
 SetVehicleBrakeLights(Vehicle, false)
 SetVehicleInteriorlight(Vehicle, false)
 SetVehicleIndicatorLights(Vehicle, 0, false)
 SetVehicleIndicatorLights(Vehicle, 1, false)
end)