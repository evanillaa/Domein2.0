HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Functions.CreateCallback("HD-garage:server:is:vehicle:owner", function(source, cb, plate)
    HDCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..PlateEscapeSqli(plate).."'", function(result)
        local Player = HDCore.Functions.GetPlayer(source)
        if result[1] ~= nil then
            if result[1].citizenid == Player.PlayerData.citizenid then
              cb(true)
            else
              cb(false)
            end
        else
            cb(false)
        end
    end)
end)

HDCore.Functions.CreateCallback("HD-garage:server:GetHouseVehicles", function(source, cb, HouseId)
  HDCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `garage` = '"..HouseId.."'", function(result)
    if result ~= nil then
      cb(result)
    end 
  end)
end)

HDCore.Functions.CreateCallback("HD-garage:server:GetUserVehicles", function(source, cb, garagename)
  local src = source
  local Player = HDCore.Functions.GetPlayer(src)
  HDCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND garage = '"..garagename.."'", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              cb(result)
          end
      end
      cb(nil)
  end)
end)

HDCore.Functions.CreateCallback("HD-garage:server:GetDepotVehicles", function(source, cb)
  local src = source
  local Player = HDCore.Functions.GetPlayer(src)
  HDCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
              cb(result)
          end
      end
      cb(nil)
  end)
end)

HDCore.Functions.CreateCallback("HD-garage:server:pay:depot", function(source, cb, price)
  local src = source
  local Player = HDCore.Functions.GetPlayer(src)
  if Player.Functions.RemoveMoney("cash", price, "Depot Paid") then
    cb(true)
  else
    TriggerClientEvent('HDCore:Notify', src, "Je hebt niet genoeg contant..", "error")
    cb(false)
  end
end)

HDCore.Functions.CreateCallback("HD-garage:server:get:vehicle:mods", function(source, cb, plate)
  local src = source
  local properties = {}
  HDCore.Functions.ExecuteSql(false, "SELECT `mods` FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
      if result[1] ~= nil then
          properties = json.decode(result[1].mods)
      end
      cb(properties)
  end)
end)

RegisterServerEvent('HD-garages:server:set:in:garage')
AddEventHandler('HD-garages:server:set:in:garage', function(Plate, GarageData, Status, MetaData)
 TriggerEvent('HD-garages:server:set:garage:state', Plate, 'in')
 HDCore.Functions.ExecuteSql(true, "UPDATE `player_vehicles` SET garage = '" ..GarageData.. "', state = '"..Status.."', metadata = '" ..json.encode(MetaData).. "' WHERE `plate` = '"..PlateEscapeSqli(Plate).."'")
end)

RegisterServerEvent('HD-garages:server:set:in:impound')
AddEventHandler('HD-garages:server:set:in:impound', function(Plate)
 TriggerEvent('HD-garages:server:set:garage:state', Plate, 'in')
 local MetaData = "{"Engine":1000.0,"Fuel":100.0,"Body":1000.0}"
 HDCore.Functions.ExecuteSql(true, "UPDATE `player_vehicles` SET garage = 'Police', state = 'in', metadata = '" ..json.encode(MetaData).. "' WHERE `plate` = '"..PlateEscapeSqli(Plate).."'")
end)

RegisterServerEvent('HD-garages:server:set:garage:state')
AddEventHandler('HD-garages:server:set:garage:state', function(Plate, Status)
  HDCore.Functions.ExecuteSql(true, "UPDATE `player_vehicles` SET state = '"..Status.."' WHERE `plate` = '"..PlateEscapeSqli(Plate).."'")
end)

RegisterServerEvent('HD-garages:server:set:depot:price')
AddEventHandler('HD-garages:server:set:depot:price', function(Plate, Price)
  HDCore.Functions.ExecuteSql(true, "UPDATE `player_vehicles` SET depotprice = '"..Price.."' WHERE `plate` = '"..PlateEscapeSqli(Plate).."'")
end)

-- // Server Function \\ --

function PlateEscapeSqli(str)
	if str:len() <= 8 then 
	 local replacements = { ['"'] = '\\"', ["'"] = "\\'"}
	 return str:gsub( "['\"]", replacements)
	end
end