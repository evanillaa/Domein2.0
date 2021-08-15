HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Functions.CreateCallback("HD-fuel:server:get:fuel:config", function(source, cb)
    cb(Config)
end)

HDCore.Functions.CreateCallback('HD-fuel:server:can:fuel', function(source, cb, price)
    local CanFuel = false
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney("cash", price, "car-wash") then
        CanFuel = true
    else 
        CanFuel = false
    end
    cb(CanFuel)
end)

RegisterServerEvent('HD-fuel:server:register:fuel')
AddEventHandler('HD-fuel:server:register:fuel', function(Plate, Vehicle, Amount)
    Config.VehicleFuel[Plate] = Amount
    TriggerClientEvent('HD-fuel:client:register:vehicle:fuel', -1, Plate, Vehicle, Amount)
end)

RegisterServerEvent('HD-fuel:server:update:fuel')
AddEventHandler('HD-fuel:server:update:fuel', function(Plate, Vehicle, Amount)
    Config.VehicleFuel[Plate] = Amount
    TriggerClientEvent('HD-fuel:client:update:vehicle:fuel', -1, Plate, Vehicle, Amount)
end)