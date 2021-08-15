RegisterServerEvent('HD-sound:server:play')
AddEventHandler('HD-sound:server:play', function(clientNetId, soundFile, soundVolume)
    TriggerClientEvent('HD-sound:client:play', clientNetId, soundFile, soundVolume)
end)

RegisterServerEvent('HD-sound:server:play:source')
AddEventHandler('HD-sound:server:play:source', function(soundFile, soundVolume)
    TriggerClientEvent('HD-sound:client:play', source, soundFile, soundVolume)
end)

RegisterServerEvent('HD-sound:server:play:distance')
AddEventHandler('HD-sound:server:play:distance', function(maxDistance, soundFile, soundVolume)
    TriggerClientEvent('HD-sound:client:play:distance', -1, source, maxDistance, soundFile, soundVolume)
end)