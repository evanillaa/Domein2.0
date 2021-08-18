HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

RegisterServerEvent('HD-cafe:server:finish:drink')
AddEventHandler('HD-cafe:server:finish:drink', function(DrinkName)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(DrinkName, 1)
    TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[DrinkName], "add")
end)

RegisterServerEvent('HD-cafe:server:pay:receipt')
AddEventHandler('HD-cafe:server:pay:receipt', function(Price, Note, Id)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveMoney('cash', Price, 'burger-shot') then
        if Config.ActivePayments[tonumber(Id)] ~= nil then
            Config.ActivePayments[tonumber(Id)] = nil
            TriggerEvent('HD-cafe:give:receipt:to:workers', Note, Price)
            TriggerClientEvent('HD-cafe:client:sync:register', -1, Config.ActivePayments)
        else
            TriggerClientEvent('HDCore:Notify', src, 'Error..', 'error')
        end
    else
        TriggerClientEvent('HDCore:Notify', src, 'Je hebt niet genoeg contant geld..', 'error')
    end
end)

RegisterServerEvent('HD-cafe:give:receipt:to:workers')
AddEventHandler('HD-cafe:give:receipt:to:workers', function(Note, Price)
    local src = source
    for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if Player.PlayerData.job.name == 'burger' and Player.PlayerData.job.onduty then
                local Info = {note = Note, price = Price}
                Player.Functions.AddItem('burger-ticket', 1, false, Info)
                TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['burger-ticket'], "add")
            end
        end
    end
end)

RegisterServerEvent('HD-cafe:server:sell:tickets')
AddEventHandler('HD-cafe:server:sell:tickets', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    for k, v in pairs(Player.PlayerData.items) do
        if v.name == 'burger-ticket' then
            Player.Functions.RemoveItem('burger-ticket', 1)
            Player.Functions.AddMoney('cash', math.random(60, 100), 'burgershot-payment')
        end
    end
    TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['burger-ticket'], "remove")
end)

-- burger-potato burger-raw
RegisterServerEvent('HD-cafe:job:goods')
AddEventHandler('HD-cafe:job:goods', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['burger-potato'], "add")
        Player.Functions.AddItem('burger-potato', math.random(3, 8))

        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['burger-raw'], "add")
        Player.Functions.AddItem('burger-raw', math.random(3, 9))

        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['burger-bun'], "add")
        Player.Functions.AddItem('burger-bun', math.random(13, 19))

        
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['burger-lettuce'], "add")
        Player.Functions.AddItem('burger-lettuce', math.random(3, 8))
end)