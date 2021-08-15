HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

RegisterServerEvent('HD-alerts:server:send:alert')
AddEventHandler('HD-alerts:server:send:alert', function(data, forBoth)
    forBoth = forBoth ~= nil and forBoth or false
    TriggerClientEvent('HD-alerts:client:send:alert', -1, data, forBoth)
end)