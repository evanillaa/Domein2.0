local LoggedIn = false
local HDCore = nil
local NearGarage = false
local IsMenuActive = false   

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
     Citizen.Wait(250)
     LoggedIn = true
 end)
end)

RegisterNetEvent('HDCore:Client:OnPlayerUnload')
AddEventHandler('HDCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(4)
    if LoggedIn then
        NearGarage = false
        for k, v in pairs(Config.GarageLocations) do
          local Distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v["Coords"]["X"], v["Coords"]["Y"], v["Coords"]["Z"], true) 
          if Distance < v['Distance'] then
           NearGarage = true
           Config.CurrentGarageData = {['GarageNumber'] = k, ['GarageName'] = v['Name']}
          end
        end
        if not NearGarage then
          Citizen.Wait(1500)
          Config.CurrentGarageData = {}
        end
    end
  end
end)

-- // Events \\ --

RegisterNetEvent('HD-garages:client:check:owner')
AddEventHandler('HD-garages:client:check:owner', function()
local Vehicle, VehDistance = HDCore.Functions.GetClosestVehicle()
local Plate = GetVehicleNumberPlateText(Vehicle)
  if VehDistance < 2.3 then
     HDCore.Functions.TriggerCallback("HD-garage:server:is:vehicle:owner", function(IsOwner)
         if IsOwner then
           TriggerEvent('HD-garages:client:set:vehicle:in:garage', Vehicle, Plate)
         else
          HDCore.Functions.Notify('Dit is niet uw voertuig..', 'error')
         end
     end, Plate)
  else
    HDCore.Functions.Notify('Geen voertuig??', 'error')
  end
end)

RegisterNetEvent('HD-garages:client:set:vehicle:in:garage')
AddEventHandler('HD-garages:client:set:vehicle:in:garage', function(Vehicle, Plate)
   local VehicleMeta = {Fuel = exports['HD-fuel']:GetFuelLevel(Plate), Body = GetVehicleBodyHealth(Vehicle), Engine = GetVehicleEngineHealth(Vehicle)}
   local GarageData = Config.CurrentGarageData['GarageName']
    TaskLeaveAnyVehicle(PlayerPedId())
    Citizen.SetTimeout(1650, function()
      TriggerServerEvent('HD-garages:server:set:in:garage', Plate, GarageData, 'in', VehicleMeta)
      HDCore.Functions.DeleteVehicle(Vehicle)
      HDCore.Functions.Notify('Voertuig geplaatst in '..Config.CurrentGarageData['GarageName'], 'success')
    end)
end)

RegisterNetEvent('HD-garages:client:set:vehicle:out:garage')
AddEventHandler('HD-garages:client:set:vehicle:out:garage', function()
  OpenGarageMenu()
end)

RegisterNetEvent('HD-garages:client:open:depot')
AddEventHandler('HD-garages:client:open:depot', function()
  OpenDepotMenu()
end)

RegisterNetEvent('HD-garages:client:spawn:vehicle')
AddEventHandler('HD-garages:client:spawn:vehicle', function(Plate, VehicleName, Metadata)
  local RandomCoords = Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'][math.random(1, #Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'])]['Coords']
  local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}
  HDCore.Functions.SpawnVehicle(VehicleName, function(Vehicle)
    SetVehicleNumberPlateText(Vehicle, Plate)
    DoCarDamage(Vehicle, Metadata.Engine, Metadata.Body)
    Citizen.Wait(25)
    exports['HD-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
    exports['HD-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), Metadata.Fuel, false)
    HDCore.Functions.Notify('Uw voertuig staat op een parkeervak', 'success')
  end, CoordTable, true, false)
end)

RegisterNUICallback('Click', function()
  PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('CloseNui', function()
  SetNuiFocus(false, false)
end)

RegisterNUICallback('TakeOutVehicle', function(data)
  if IsNearGarage() then
    local RandomCoords = Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'][math.random(1, #Config.GarageLocations[Config.CurrentGarageData['GarageNumber']]['Spawns'])]['Coords']
    local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}
    if data.State == 'in' then
      HDCore.Functions.SpawnVehicle(data.Model, function(Vehicle)
        HDCore.Functions.TriggerCallback('HD-garage:server:get:vehicle:mods', function(Mods)
          HDCore.Functions.SetVehicleProperties(Vehicle, Mods)
          SetVehicleNumberPlateText(Vehicle, data.Plate)
          Citizen.Wait(25)
          DoCarDamage(Vehicle, data.Engine, data.Body)
          Citizen.Wait(25)
          exports['HD-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
          exports['HD-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), data.Fuel, false)
          HDCore.Functions.Notify('Uw voertuig staat klaar op een parkeer vak', 'info')
          TriggerServerEvent('HD-garages:server:set:garage:state', data.Plate, 'out')
        end, data.Plate)
      end, CoordTable, true, false)
    else
        HDCore.Functions.Notify("Uw voertuig is in het Depot.", "info", 3500)
    end
  elseif IsNearDepot() then
    HDCore.Functions.TriggerCallback('HD-garage:server:pay:depot', function(DidPayment)
      if DidPayment then
        local CoordTable = {x = 491.59, y = -1314.14, z = 29.25, a = 299.67}
        HDCore.Functions.SpawnVehicle(data.Model, function(Vehicle)
        HDCore.Functions.TriggerCallback('HD-garage:server:get:vehicle:mods', function(Mods)
        HDCore.Functions.SetVehicleProperties(Vehicle, Mods)
          SetVehicleNumberPlateText(Vehicle, data.Plate)
          Citizen.Wait(25)
          DoCarDamage(Vehicle, data.Engine, data.Body)
          Citizen.Wait(25)
          TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, -1)
          exports['HD-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
          exports['HD-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), data.Fuel, false)
          HDCore.Functions.Notify('Voertuig uit het depot gehaalt', 'success')
          TriggerServerEvent('HD-garages:server:set:depot:price', data.Plate, 0)
          TriggerServerEvent('HD-garages:server:set:garage:state', data.Plate, 'out')
          CloseMenuFull()
          end, data.Plate)
        end, CoordTable, true, false)
      end
    end, data.Price)
  elseif IsNearBoatDepot() then
    HDCore.Functions.TriggerCallback('HD-garage:server:pay:depot', function(DidPayment)
      if DidPayment then
        local CoordTable = {x = -799.87, y = -1488.97, z = 0.6260614, a = 299.67}
        HDCore.Functions.SpawnVehicle(data.Model, function(Vehicle)
        HDCore.Functions.TriggerCallback('HD-garage:server:get:vehicle:mods', function(Mods)
        HDCore.Functions.SetVehicleProperties(Vehicle, Mods)
          SetVehicleNumberPlateText(Vehicle, data.Plate)
          Citizen.Wait(25)
          DoCarDamage(Vehicle, data.Engine, data.Body)
          Citizen.Wait(25)
          TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, -1)
          exports['HD-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
          exports['HD-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), data.Fuel, false)
          HDCore.Functions.Notify('Voertuig uit het depot gehaalt', 'success')
          TriggerServerEvent('HD-garages:server:set:depot:price', data.Plate, 0)
          TriggerServerEvent('HD-garages:server:set:garage:state', data.Plate, 'out')
          CloseMenuFull()
          end, data.Plate)
        end, CoordTable, true, false)
      end
    end, data.Price)
  elseif exports['HD-housing']:NearHouseGarage() then
    if data.State == 'in' then
      local VehicleSpawn = exports['HD-housing']:GetGarageCoords()
      local CoordTable = {x = VehicleSpawn['X'], y = VehicleSpawn['Y'], z = VehicleSpawn['Z'], a = VehicleSpawn['H']}
      HDCore.Functions.SpawnVehicle(data.Model, function(Vehicle)
        HDCore.Functions.TriggerCallback('HD-garage:server:get:vehicle:mods', function(Mods)
             HDCore.Functions.SetVehicleProperties(Vehicle, Mods)
             SetVehicleNumberPlateText(Vehicle, data.Plate)
             Citizen.Wait(25)
             DoCarDamage(Vehicle, data.Engine, data.Body)
             Citizen.Wait(25)
             TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, -1)
             exports['HD-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
             exports['HD-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), data.Fuel, false)
             HDCore.Functions.Notify('Voertuig uit het depot gehaalt', 'success')
             TriggerServerEvent('HD-garages:server:set:garage:state', data.Plate, 'out')
             CloseMenuFull()
           end, data.Plate)
        end, CoordTable, true, false)
      else
        HDCore.Functions.Notify("Staat je voertuig in het depot??", "info", 3500)
    end
  end
end)

-- // Functions \\ --

function DoCarDamage(Vehicle, EngineHealth, BodyHealth)
	SmashWindows = false
	damageOutside = false
	damageOutside2 = false 
	local engine = EngineHealth + 0.0
	local body = BodyHealth + 0.0
	if engine < 200.0 then
		engine = 200.0
	end

	if body < 150.0 then
		body = 150.0
	end
	if body < 950.0 then
		SmashWindows = true
	end

	if body < 920.0 then
		damageOutside = true
	end

	if body < 920.0 then
		damageOutside2 = true
	end
	Citizen.Wait(100)
	SetVehicleEngineHealth(Vehicle, engine)
	if SmashWindows then
		SmashVehicleWindow(Vehicle, 0)
		SmashVehicleWindow(Vehicle, 1)
		SmashVehicleWindow(Vehicle, 2)
		SmashVehicleWindow(Vehicle, 3)
		SmashVehicleWindow(Vehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(Vehicle, 1, true)
		SetVehicleDoorBroken(Vehicle, 6, true)
		SetVehicleDoorBroken(Vehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(Vehicle, 1, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 2, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 3, false, 990.0)
		SetVehicleTyreBurst(Vehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(Vehicle, 985.0)
  end
end

function IsNearGarage()
  return NearGarage
end

function IsNearDepot()
  local PlayerCoords = GetEntityCoords(PlayerPedId())
  local Distance = GetDistanceBetweenCoords(PlayerCoords, 491.03, -1313.82, 29.25, true) 
  if Distance < 10.0 then
    return true
  end
end

function IsNearBoatDepot()
  local PlayerCoords = GetEntityCoords(PlayerPedId())
  local DistanceBoat = GetDistanceBetweenCoords(PlayerCoords, -799.87, -1488.97, 0.6260614, true) 
  if DistanceBoat < 10.0 then
    return true
  end
end


function OpenGarageMenu()
  local VehicleTable = {}
  PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  HDCore.Functions.TriggerCallback("HD-garage:server:GetUserVehicles", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
             local Vehicle = {}
             local MetaData = json.decode(v.metadata)
             Vehicle = {['Name'] = HDCore.Shared.Vehicles[v.vehicle]['name'], ['Model'] = v.vehicle, ['Plate'] = v.plate, ['Garage'] = v.garage,['State'] = v.state, ['Fuel'] = MetaData.Fuel, ['Motor'] = math.ceil(MetaData.Engine), ['Body'] = math.ceil(MetaData.Body)}
             table.insert(VehicleTable, Vehicle) 
          end
          SetNuiFocus(true, true)
          Citizen.InvokeNative(0xFC695459D4D0E219, 0.9, 0.25)
          SendNUIMessage({action = "OpenGarage", garagevehicles = VehicleTable})
      else
        HDCore.Functions.Notify("Je hebt geen voertuigen in deze garage..", "error", 5000)
      end
  end, Config.CurrentGarageData['GarageName'])
end

function OpenDepotMenu()
  local VehicleTable = {}
  PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  HDCore.Functions.TriggerCallback("HD-garage:server:GetDepotVehicles", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              if v.state == 'out' then
                local Vehicle = {}
                local MetaData = json.decode(v.metadata)
                Vehicle = {['Name'] = HDCore.Shared.Vehicles[v.vehicle]['name'], ['Model'] = v.vehicle, ['Plate'] = v.plate, ['Garage'] = v.garage, ['State'] = v.state, ['Price'] = v.depotprice, ['Fuel'] = MetaData.Fuel, ['Motor'] = math.ceil(MetaData.Engine), ['Body'] = math.ceil(MetaData.Body)}
                table.insert(VehicleTable, Vehicle)
              end 
          end
          SetNuiFocus(true, true)
          Citizen.InvokeNative(0xFC695459D4D0E219, 0.9, 0.25)
          SendNUIMessage({action = "OpenDepot", depotvehicles = VehicleTable})
      else
        HDCore.Functions.Notify("Het depot is leeg..", "error", 5000)
      end
  end)
end

function OpenHouseGarage(HouseId)
  local VehicleTable = {}
  PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  HDCore.Functions.TriggerCallback("HD-garage:server:GetHouseVehicles", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              local Vehicle = {}
              local MetaData = json.decode(v.metadata)
              Vehicle = {['Name'] = HDCore.Shared.Vehicles[v.vehicle]['name'], ['Model'] = v.vehicle, ['Plate'] = v.plate, ['Garage'] = v.garage, ['State'] = v.state, ['Fuel'] = MetaData.Fuel, ['Motor'] = math.ceil(MetaData.Engine), ['Body'] = math.ceil(MetaData.Body)}
              table.insert(VehicleTable, Vehicle)
          end
          SetNuiFocus(true, true)
          Citizen.InvokeNative(0xFC695459D4D0E219, 0.9, 0.25)
          SendNUIMessage({action = "OpenGarage", garagevehicles = VehicleTable})
      else
        HDCore.Functions.Notify("Je hebt geen voertuigen in deze garage..", "error", 5000)
      end
  end, HouseId)
end


function OpenImpoundGarage(Station)
  local VehicleTable = {}
  PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  HDCore.Functions.TriggerCallback("HD-garage:server:GetPoliceVehicles", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              local Vehicle = {}
              local MetaData = json.decode(v.metadata)
              Vehicle = {['Name'] = HDCore.Shared.Vehicles[v.vehicle]['name'], ['Model'] = v.vehicle, ['Plate'] = v.plate, ['Garage'] = v.garage, ['State'] = v.state, ['Fuel'] = MetaData.Fuel, ['Motor'] = math.ceil(MetaData.Engine), ['Body'] = math.ceil(MetaData.Body)}
              table.insert(VehicleTable, Vehicle)
          end
          SetNuiFocus(true, true)
          Citizen.InvokeNative(0xFC695459D4D0E219, 0.9, 0.25)
          SendNUIMessage({action = "OpenGarage", garagevehicles = VehicleTable})
      else
        HDCore.Functions.Notify("Het depot is leeg..", "error", 5000)
      end
  end, Station)
end

function SetVehicleInHouseGarage(HouseId)
  local Vehicle = GetVehiclePedIsIn(PlayerPedId())
  local Plate = GetVehicleNumberPlateText(Vehicle)
  local VehicleMeta = {Fuel = exports['HD-fuel']:GetFuelLevel(Plate), Body = GetVehicleBodyHealth(Vehicle), Engine = GetVehicleEngineHealth(Vehicle)}
  local GarageData = HouseId
  TaskLeaveAnyVehicle(PlayerPedId())
  Citizen.SetTimeout(1650, function()
    TriggerServerEvent('HD-garages:server:set:in:garage', Plate, GarageData, 'in', VehicleMeta)
    HDCore.Functions.DeleteVehicle(Vehicle)
    HDCore.Functions.Notify('Voertuig geplaatst in '..HouseId, 'success')
  end)
end