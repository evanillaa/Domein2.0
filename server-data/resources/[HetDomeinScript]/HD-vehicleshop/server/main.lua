HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

-- code


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
RegisterNetEvent('HD-vehicleshop:server:buyVehicle')
AddEventHandler('HD-vehicleshop:server:buyVehicle', function(vehicleData, garage)
    local src = source
    local pData = HDCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local vData = HDCore.Shared.Vehicles[vehicleData["model"]]
    local balance = pData.PlayerData.money["bank"]
    local GarageData = {garagename = 'Blokken Parking', garagenumber = 1}
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}

    if (balance - vData["price"]) >= 0 then
        local plate = GeneratePlate()
        --HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `garage`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..vData["model"].."', '"..GetHashKey(vData["model"]).."', '{}', '"..plate.."', '"..garage.."')")
        HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..pData.PlayerData.citizenid.."', '"..vData["model"].."', '"..plate.."', '"..json.encode(GarageData).."', 'out', '{}', '"..json.encode(VehicleMeta).."')")
 
        TriggerClientEvent("HDCore:Notify", src, "Dank u voor de aankoop!", "success", 5000)
        pData.Functions.RemoveMoney('bank', vData["price"], "vehicle-bought-in-shop")
       else
		TriggerClientEvent("HDCore:Notify", src, "Je hebt niet genoeg geld op de bank... Je mist nog: €"..format_thousand(vData["price"] - balance), "error", 5000)
    end
end)

RegisterNetEvent('HD-vehicleshop:server:buyShowroomVehicle')
AddEventHandler('HD-vehicleshop:server:buyShowroomVehicle', function(vehicle, class)
    local src = source
    local pData = HDCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    
    local GarageData = {garagename = 'Blokken Parking', garagenumber = 1}
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
    local balance = pData.PlayerData.money["bank"]
    local vehiclePrice = HDCore.Shared.Vehicles[vehicle]["price"]
    --print(vehicle)
    local Model = HDCore.Shared.Vehicles[vehicle]["price"]
    local plate = GeneratePlate()

    if (balance - vehiclePrice) >= 0 then
        --HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..vehicle.."', '"..GetHashKey(vehicle).."', '{}', '"..plate.."', 0)")
        HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..pData.PlayerData.citizenid.."', '"..vehicle.."', '"..plate.."', '"..json.encode(GarageData).."', 'out', '{}', '"..json.encode(VehicleMeta).."')")
 
        TriggerClientEvent("HDCore:Notify", src, "Dank u voor de aankoop!", "success", 5000)
        TriggerClientEvent('HD-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', vehiclePrice, "vehicle-bought-in-showroom")
    else
        TriggerClientEvent("HDCore:Notify", src, "Je hebt niet genoeg geld op de bank... Je mist nog: €"..format_thousand(vehiclePrice - balance), "error", 5000)
    end
end)

function format_thousand(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

function GeneratePlate()
    local plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    HDCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        while (result[1] ~= nil) do
            plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
        end
        return plate
    end)
    return plate:upper()
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

RegisterServerEvent('HD-vehicleshop:server:setShowroomCarInUse')
AddEventHandler('HD-vehicleshop:server:setShowroomCarInUse', function(showroomVehicle, bool)
    Pepe.ShowroomVehicles[showroomVehicle].inUse = bool
    TriggerClientEvent('HD-vehicleshop:client:setShowroomCarInUse', -1, showroomVehicle, bool)
end)

RegisterServerEvent('HD-vehicleshop:server:setShowroomVehicle')
AddEventHandler('HD-vehicleshop:server:setShowroomVehicle', function(vData, k)
    Pepe.ShowroomVehicles[k].chosenVehicle = vData
    TriggerClientEvent('HD-vehicleshop:client:setShowroomVehicle', -1, vData, k)
end)

RegisterServerEvent('HD-vehicleshop:server:SetCustomShowroomVeh')
AddEventHandler('HD-vehicleshop:server:SetCustomShowroomVeh', function(vData, k)
    Pepe.ShowroomVehicles[k].vehicle = vData
    TriggerClientEvent('HD-vehicleshop:client:SetCustomShowroomVeh', -1, vData, k)
end)

HDCore.Commands.Add("sellv", "Sell vehicle from Luxery", {}, false, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    local TargetId = args[1]

    if Player.PlayerData.job.name == "cardealer" then
        if TargetId ~= nil then
            TriggerClientEvent('HD-vehicleshop:client:SellCustomVehicle', source, TargetId)
        else
            TriggerClientEvent('HDCore:Notify', source, 'You need to enter an ID!', 'error')
        end
    else
        TriggerClientEvent('HDCore:Notify', source, 'You are not a cardealer', 'error')
    end
end)

HDCore.Commands.Add("testrit", "Do a testdrive", {}, false, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    local TargetId = args[1]

    if Player.PlayerData.job.name == "cardealer" then
        TriggerClientEvent('HD-vehicleshop:client:DoTestrit', source, GeneratePlate())
    else
        TriggerClientEvent('HDCore:Notify', source, 'You are not a cardealer', 'error')
    end
end)

RegisterServerEvent('HD-vehicleshop:server:SellCustomVehicle')
AddEventHandler('HD-vehicleshop:server:SellCustomVehicle', function(TargetId, ShowroomSlot)
    TriggerClientEvent('HD-vehicleshop:client:SetVehicleBuying', TargetId, ShowroomSlot)
end)

RegisterServerEvent('HD-vehicleshop:server:ConfirmVehicle')
AddEventHandler('HD-vehicleshop:server:ConfirmVehicle', function(ShowroomVehicle)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local VehPrice = HDCore.Shared.Vehicles[ShowroomVehicle.vehicle].price

    local VehicleData = HDCore.Shared.Vehicles[ShowroomVehicle]
    local plate = GeneratePlate()

    local GarageData = {garagename = 'Blokken Parking', garagenumber = 1}
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
    if Player.PlayerData.money.cash >= VehPrice then
        Player.Functions.RemoveMoney('cash', VehPrice)
        TriggerClientEvent('HD-vehicleshop:client:ConfirmVehicle', src, ShowroomVehicle, plate)
        HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..Player.PlayerData.citizenid.."', '"..ShowroomVehicle.."', '"..Plate.."', '"..json.encode(GarageData).."', 'out', '{}', '"..json.encode(VehicleMeta).."')")
    elseif Player.PlayerData.money.bank >= VehPrice then
        Player.Functions.RemoveMoney('bank', VehPrice)
        TriggerClientEvent('HD-vehicleshop:client:ConfirmVehicle', src, ShowroomVehicle, plate)
       HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..Player.PlayerData.citizenid.."', '"..ShowroomVehicle.."', '"..Plate.."', '"..json.encode(GarageData).."', 'out', '{}', '"..json.encode(VehicleMeta).."')")
    else
        if Player.PlayerData.money.cash > Player.PlayerData.money.bank then
            TriggerClientEvent('HDCore:Notify', src, 'You dont have enough cash. You are missing: ('..(Player.PlayerData.money.cash - VehPrice)..',-)')
        else
            TriggerClientEvent('HDCore:Notify', src, 'You dont have enough funds on the bank account. You are missing: ('..(Player.PlayerData.money.bank - VehPrice)..',-)')
        end
    end
end)

HDCore.Functions.CreateCallback('HD-vehicleshop:server:SellVehicle', function(source, cb, vehicle, plate)
    local VehicleData = HDCore.Shared.VehicleModels[vehicle]
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            Player.Functions.AddMoney('bank', math.ceil(VehicleData["price"] / 100 * 60))
            HDCore.Functions.ExecuteSql(false, "DELETE FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `plate` = '"..plate.."'")
            cb(true)
        else
            cb(false)
        end
    end)
end)