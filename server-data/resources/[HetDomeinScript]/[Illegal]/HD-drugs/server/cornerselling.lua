HDCore.Functions.CreateCallback('HD-drugs:server:cornerselling:getAvailableDrugs', function(source, cb)
    local AvailableDrugs = {}
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            table.insert(AvailableDrugs, {
                item = item.name,
                amount = item.amount,
                label = HDCore.Shared.Items[item.name]["label"]
            })
        end
    end

    if next(AvailableDrugs) ~= nil then
        cb(AvailableDrugs)
    else
        cb(nil)
    end
end)

RegisterServerEvent('HD-drugs:server:sellCornerDrugs')
AddEventHandler('HD-drugs:server:sellCornerDrugs', function(item, amount, price)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local AvailableDrugs = {}

    Player.Functions.RemoveItem(item, amount)
    Player.Functions.AddMoney('cash', price, "sold-cornerdrugs")

    TriggerClientEvent('inventory:client:ItemBox', src, HDCore.Shared.Items[item], "remove")

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            table.insert(AvailableDrugs, {
                item = item.name,
                amount = item.amount,
                label = HDCore.Shared.Items[item.name]["label"]
            })
        end
    end

    TriggerClientEvent('HD-drugs:client:refreshAvailableDrugs', src, AvailableDrugs)
end)

RegisterServerEvent('HD-drugs:server:robCornerDrugs')
AddEventHandler('HD-drugs:server:robCornerDrugs', function(item, amount, price)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local AvailableDrugs = {}

    Player.Functions.RemoveItem(item, amount)

    TriggerClientEvent('inventory:client:ItemBox', src, HDCore.Shared.Items[item], "remove")

    for i = 1, #Config.CornerSellingDrugsList, 1 do
        local item = Player.Functions.GetItemByName(Config.CornerSellingDrugsList[i])

        if item ~= nil then
            table.insert(AvailableDrugs, {
                item = item.name,
                amount = item.amount,
                label = HDCore.Shared.Items[item.name]["label"]
            })
        end
    end

    TriggerClientEvent('HD-drugs:client:refreshAvailableDrugs', src, AvailableDrugs)
end)

RegisterServerEvent('HD-drugs:server:robCornerRunner')
AddEventHandler('HD-drugs:server:robCornerRunner', function(item, amount)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item, amount)
end)