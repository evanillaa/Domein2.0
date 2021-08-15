HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Commands.Add("eyereset", "Reset the eye.", {}, false, function(source, args)
    TriggerClientEvent('HD-eye:client:refresh', source)
end)

RegisterServerEvent('HD-eye:server:setup:trunk:data')
AddEventHandler('HD-eye:server:setup:trunk:data', function(Plate)
    Config.TrunkData[Plate] = {['Busy'] = false}
    TriggerClientEvent('HD-eye:client:sync:trunk:data', -1, Config.TrunkData)
end)

RegisterServerEvent('HD-eye:server:set:trunk:data')
AddEventHandler('HD-eye:server:set:trunk:data', function(Plate, Bool)
    Config.TrunkData[Plate]['Busy'] = Bool
    TriggerClientEvent('HD-eye:client:sync:trunk:data', -1, Config.TrunkData)
end)
