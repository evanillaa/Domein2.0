local CurrentDivingArea = math.random(1, #QBDiving.Locations)

HDCore.Functions.CreateCallback('HD-diving:server:GetDivingConfig', function(source, cb)
    cb(QBDiving.Locations, CurrentDivingArea)
end)

RegisterServerEvent('HD-diving:server:TakeCoral')
AddEventHandler('HD-diving:server:TakeCoral', function(Area, Coral, Bool)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local CoralType = math.random(1, #QBDiving.CoralTypes)
    local Amount = math.random(1, QBDiving.CoralTypes[CoralType].maxAmount)
    local ItemData = HDCore.Shared.Items[QBDiving.CoralTypes[CoralType].item]

    if Amount > 1 then
        for i = 1, Amount, 1 do
            Player.Functions.AddItem(ItemData["name"], 1)
            TriggerClientEvent('HD-inventory:client:ItemBox', src, ItemData, "add")
            Citizen.Wait(250)
        end
    else
        Player.Functions.AddItem(ItemData["name"], Amount)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, ItemData, "add")
    end

    if (QBDiving.Locations[Area].TotalCoral - 1) == 0 then
        for k, v in pairs(QBDiving.Locations[CurrentDivingArea].coords.Coral) do
            v.PickedUp = false
        end
        QBDiving.Locations[CurrentDivingArea].TotalCoral = QBDiving.Locations[CurrentDivingArea].DefaultCoral

        local newLocation = math.random(1, #QBDiving.Locations)
        while (newLocation == CurrentDivingArea) do
            Citizen.Wait(3)
            newLocation = math.random(1, #QBDiving.Locations)
        end
        CurrentDivingArea = newLocation
        
        TriggerClientEvent('HD-diving:client:NewLocations', -1)
    else
        QBDiving.Locations[Area].coords.Coral[Coral].PickedUp = Bool
        QBDiving.Locations[Area].TotalCoral = QBDiving.Locations[Area].TotalCoral - 1
    end

    TriggerClientEvent('HD-diving:server:UpdateCoral', -1, Area, Coral, Bool)
end)

RegisterServerEvent('HD-diving:server:RemoveGear')
AddEventHandler('HD-diving:server:RemoveGear', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem("diving_gear", 1)
    TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items["diving_gear"], "remove")
end)

RegisterServerEvent('HD-diving:server:GiveBackGear')
AddEventHandler('HD-diving:server:GiveBackGear', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    
    Player.Functions.AddItem("diving_gear", 1)
    TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items["diving_gear"], "add")
end)