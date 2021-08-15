HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Functions.CreateCallback('HD-stores:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('HD-stores:server:update:store:items')
AddEventHandler('HD-stores:server:update:store:items', function(Shop, ItemData, Amount)
    Config.Shops[Shop]["Product"][ItemData.slot].amount = Config.Shops[Shop]["Product"][ItemData.slot].amount - Amount
    TriggerClientEvent('HD-stores:client:set:store:items', -1, ItemData, Amount, Shop)
end)