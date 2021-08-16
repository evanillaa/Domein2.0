HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Functions.CreateCallback('HD-carwash:server:can:wash', function(source, cb, price)
    local CanWash = false
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney("cash", price, "car-wash") then
        CanWash = true
    else 
        CanWash = false
    end
    cb(CanWash)
end)

RegisterServerEvent('HD-carwash:server:set:busy')
AddEventHandler('HD-carwash:server:set:busy', function(CarWashId, bool)
 Config.CarWashLocations[CarWashId]['Busy'] = bool
 TriggerClientEvent('HD-carwash:client:set:busy', -1, CarWashId, bool)
end)

RegisterServerEvent('HD-carwash:server:sync:wash')
AddEventHandler('HD-carwash:server:sync:wash', function(Vehicle)
 TriggerClientEvent('HD-carwash:client:sync:wash', -1, Vehicle)
end)

RegisterServerEvent('HD-carwash:server:sync:water')
AddEventHandler('HD-carwash:server:sync:water', function(WaterId)
 TriggerClientEvent('HD-carwash:client:sync:water', -1, WaterId)
end)

RegisterServerEvent('HD-carwash:server:stop:water')
AddEventHandler('HD-carwash:server:stop:water', function(WaterId)
 TriggerClientEvent('HD-carwash:client:stop:water', -1, WaterId)
end)
