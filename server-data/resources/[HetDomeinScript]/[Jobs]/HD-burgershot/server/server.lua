HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Commands.Add("refreshburgerprops", "Reset de burgershot props", {}, false, function(source, args)
    TriggerClientEvent('HD-burgershot:client:refresh:props', -1)
end, "admin")

HDCore.Functions.CreateCallback('HD-burgershot:server:has:burger:items', function(source, cb)
 local src = source
 local count = 0
 local Player = HDCore.Functions.GetPlayer(src)
 for k, v in pairs(Config.BurgerItems) do
     local BurgerData = Player.Functions.GetItemByName(v)
     if BurgerData ~= nil then
        count = count + 1
        if count == 3 then
            cb(true)
        end
     end
 end
end)

RegisterServerEvent('HD-burgershot:server:finish:burger')
AddEventHandler('HD-burgershot:server:finish:burger', function(BurgerName)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.BurgerItems) do
        Player.Functions.RemoveItem(v, 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[v], "remove")
    end
    Citizen.SetTimeout(350, function()
        Player.Functions.AddItem(BurgerName, 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[BurgerName], "add")
    end)
end)


RegisterServerEvent('HD-burgershot:server:finish:fries')
AddEventHandler('HD-burgershot:server:finish:fries', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem('burger-potato', 1) then
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['burger-potato'], "remove")
        Player.Functions.AddItem('burger-fries', math.random(3, 5))
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['burger-fries'], "add")
    end
end)

RegisterServerEvent('HD-burgershot:server:finish:patty')
AddEventHandler('HD-burgershot:server:finish:patty', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveItem('burger-raw', 1) then
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['burger-raw'], "remove")
        Player.Functions.AddItem('burger-meat', 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['burger-meat'], "add")
    end
end)

RegisterServerEvent('HD-burgershot:server:finish:drink')
AddEventHandler('HD-burgershot:server:finish:drink', function(DrinkName)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(DrinkName, 1)
    TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[DrinkName], "add")
end)

RegisterServerEvent('HD-burgershot:server:add:to:register')
AddEventHandler('HD-burgershot:server:add:to:register', function(Price, Note)
    local RandomID = math.random(1111,9999)
    Config.ActivePayments[RandomID] = {['Price'] = Price, ['Note'] = Note}
    TriggerClientEvent('HD-burgershot:client:sync:register', -1, Config.ActivePayments)
end)

RegisterServerEvent('HD-burgershot:server:pay:receipt')
AddEventHandler('HD-burgershot:server:pay:receipt', function(Price, Note, Id)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    if Player.Functions.RemoveMoney('cash', Price, 'burger-shot') then
        if Config.ActivePayments[tonumber(Id)] ~= nil then
            Config.ActivePayments[tonumber(Id)] = nil
            TriggerEvent('HD-burgershot:give:receipt:to:workers', Note, Price)
            TriggerClientEvent('HD-burgershot:client:sync:register', -1, Config.ActivePayments)
        else
            TriggerClientEvent('HDCore:Notify', src, 'Error..', 'error')
        end
    else
        TriggerClientEvent('HDCore:Notify', src, 'Je hebt niet genoeg contant geld..', 'error')
    end
end)

RegisterServerEvent('HD-burgershot:give:receipt:to:workers')
AddEventHandler('HD-burgershot:give:receipt:to:workers', function(Note, Price)
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

RegisterServerEvent('HD-burgershot:server:sell:tickets')
AddEventHandler('HD-burgershot:server:sell:tickets', function()
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