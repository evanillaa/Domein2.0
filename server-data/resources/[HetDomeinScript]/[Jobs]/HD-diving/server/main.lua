HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

RegisterServerEvent('HD-diving:server:SetBerthVehicle')
AddEventHandler('HD-diving:server:SetBerthVehicle', function(BerthId, vehicleModel)
    TriggerClientEvent('HD-diving:client:SetBerthVehicle', -1, BerthId, vehicleModel)
    
    QBBoatshop.Locations["berths"][BerthId]["boatModel"] = boatModel
end)

RegisterServerEvent('HD-diving:server:SetDockInUse')
AddEventHandler('HD-diving:server:SetDockInUse', function(BerthId, InUse)
    QBBoatshop.Locations["berths"][BerthId]["inUse"] = InUse
    TriggerClientEvent('HD-diving:client:SetDockInUse', -1, BerthId, InUse)
end)

HDCore.Functions.CreateCallback('HD-diving:server:GetBusyDocks', function(source, cb)
    cb(QBBoatshop.Locations["berths"])
end)

RegisterServerEvent('HD-diving:server:BuyBoat')
AddEventHandler('HD-diving:server:BuyBoat', function(boatModel, BerthId)
    local BoatPrice = QBBoatshop.ShopBoats[boatModel]["price"]
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local PlayerMoney = {
        cash = Player.PlayerData.money.cash,
        bank = Player.PlayerData.money.bank,
    }
    local missingMoney = 0
    local plate = "BOOT"..math.random(1111, 9999)

    if PlayerMoney.cash >= BoatPrice then
        Player.Functions.RemoveMoney('cash', BoatPrice, "bought-boat")
        TriggerClientEvent('HD-diving:client:BuyBoat', src, boatModel, plate)
        InsertBoat(boatModel, Player, plate)
    elseif PlayerMoney.bank >= BoatPrice then
        Player.Functions.RemoveMoney('bank', BoatPrice, "bought-boat")
        TriggerClientEvent('HD-diving:client:BuyBoat', src, boatModel, plate)
        InsertBoat(boatModel, Player, plate)
    else
        if PlayerMoney.bank > PlayerMoney.cash then
            missingMoney = (BoatPrice - PlayerMoney.bank)
        else
            missingMoney = (BoatPrice - PlayerMoney.cash)
        end
        TriggerClientEvent('HDCore:Notify', src, 'Je hebt niet voldoende geld, je mist €'..missingMoney, 'error', 4000)
    end
end)

function InsertBoat(boatModel, Player, plate)
    
    local GarageData = "Water Parking"
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
    HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..Player.PlayerData.citizenid.."', '"..boatModel.."', '"..plate.."', '"..GarageData.."', 'out', '{}', '"..json.encode(VehicleMeta).."')")
end

HDCore.Functions.CreateUseableItem("jerry_can", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)

    TriggerClientEvent("HD-diving:client:UseJerrycan", source)
end)

HDCore.Functions.CreateUseableItem("diving_gear", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)

    TriggerClientEvent("HD-diving:client:UseGear", source, true)
end)

RegisterServerEvent('HD-diving:server:RemoveItem')
AddEventHandler('HD-diving:server:RemoveItem', function(item, amount)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem(item, amount)
end)

HDCore.Functions.CreateCallback('HD-diving:server:GetMyBoats', function(source, cb, dock)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    local GarageData = "Water Parking"
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `garage` = '"..GarageData.."'", function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

HDCore.Functions.CreateCallback('HD-diving:server:GetDepotBoats', function(source, cb, dock)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `state` = '0'", function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('HD-diving:server:SetBoatState')
AddEventHandler('HD-diving:server:SetBoatState', function(plate, state, boathouse)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local GarageData = "Water Parking"
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            HDCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `state` = '"..state.."' WHERE `plate` = '"..plate.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
    
            if state == 1 then
                HDCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `garage` = '"..boathouse.."' WHERE `plate` = '"..plate.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
            end
        end
    end)
end)

RegisterServerEvent('HD-diving:server:CallCops')
AddEventHandler('HD-diving:server:CallCops', function(Coords)
    local src = source
    for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                local msg = "Er word mogelijk koraal gestolen!"
                TriggerClientEvent('HD-diving:client:CallCops', Player.PlayerData.source, Coords, msg)
                local alertData = {
                    title = "Illegaalduiken",
                    coords = {x = Coords.x, y = Coords.y, z = Coords.z},
                    description = msg,
                }
                TriggerClientEvent("HD-phone:client:addPoliceAlert", -1, alertData)
            end
        end
	end
end)

-- local AvailableCoral = {}

-- HDCore.Commands.Add("duikpak", "Trek je duikpak uit", {}, false, function(source, args)
--     local Player = HDCore.Functions.GetPlayer(source)
--     TriggerClientEvent("HD-diving:client:UseGear", source, false)
-- end)

-- RegisterServerEvent('HD-diving:server:SellCoral')
-- AddEventHandler('HD-diving:server:SellCoral', function()
--     local src = source
--     local Player = HDCore.Functions.GetPlayer(src)

--     if HasCoral(src) then
--         for k, v in pairs(AvailableCoral) do
--             local Item = Player.Functions.GetItemByName(v.item)
--             local price = (Item.amount * v.price)
--             local Reward = math.ceil(GetItemPrice(Item, price))

--             if Item.amount > 1 then
--                 for i = 1, Item.amount, 1 do
--                     Player.Functions.RemoveItem(Item.name, 1)
--                     TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[Item.name], "remove")
--                     Player.Functions.AddMoney('cash', math.ceil((Reward / Item.amount)), "sold-coral")
--                     Citizen.Wait(250)
--                 end
--             else
--                 Player.Functions.RemoveItem(Item.name, 1)
--                 Player.Functions.AddMoney('cash', Reward, "sold-coral")
--                 TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[Item.name], "remove")
--             end
--         end
--     else
--         TriggerClientEvent('HDCore:Notify', src, 'Je hebt geen koraal om te verkopen..', 'error')
--     end
-- end)

-- function GetItemPrice(Item, price)
--     if Item.amount > 5 then
--         price = price / 100 * 80
--     elseif Item.amount > 10 then
--         price = price / 100 * 70
--     elseif Item.amount > 15 then
--         price = price / 100 * 50
--     end
--     return price
-- end

-- function HasCoral(src)
--     local Player = HDCore.Functions.GetPlayer(src)
--     local retval = false
--     AvailableCoral = {}

--     for k, v in pairs(QBDiving.CoralTypes) do
--         local Item = Player.Functions.GetItemByName(v.item)
--         if Item ~= nil then
--             table.insert(AvailableCoral, v)
--             retval = true
--         end
--     end
--     return retval
-- end


-- RegisterServerEvent('HD-diving:server:RemoveGear')
-- AddEventHandler('HD-diving:server:RemoveGear', function()
--     local src = source
--     local Player = HDCore.Functions.GetPlayer(src)

--     Player.Functions.RemoveItem("diving_gear", 1)
--     TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items["diving_gear"], "remove")
-- end)

-- RegisterServerEvent('HD-diving:server:GiveBackGear')
-- AddEventHandler('HD-diving:server:GiveBackGear', function()
--     local src = source
--     local Player = HDCore.Functions.GetPlayer(src)
    
--     Player.Functions.AddItem("diving_gear", 1)
--     TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items["diving_gear"], "add")
-- end)