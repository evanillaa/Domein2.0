HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Functions.CreateCallback("HD-doorlock:server:get:config", function(source, cb)
    cb(Config)
end)

RegisterServerEvent('HD-doorlock:server:change:door:looks')
AddEventHandler('HD-doorlock:server:change:door:looks', function(Door, Type)
 TriggerClientEvent('HD-doorlock:client:change:door:looks', -1, Door, Type)
end)

RegisterServerEvent('HD-doorlock:server:reset:door:looks')
AddEventHandler('HD-doorlock:server:reset:door:looks', function()
 TriggerClientEvent('HD-doorlock:client:reset:door:looks', -1)
end)

RegisterServerEvent('HD-doorlock:server:updateState')
AddEventHandler('HD-doorlock:server:updateState', function(doorID, state)
 Config.Doors[doorID]['Locked'] = state
 TriggerClientEvent('HD-doorlock:client:setState', -1, doorID, state)
end)