HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

RegisterServerEvent('HD-pizza:server:start:black')
AddEventHandler('HD-pizza:server:start:black', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(source)
    TriggerClientEvent('HD-pizza:start:black:job', src)
    Player.Functions.AddItem("pizza-doos", 1)
    TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['pizza-doos'], 'add')
    --TriggerClientEvent("hud:client:OnMoneyChange")
end)

HDCore.Functions.CreateCallback('HD-pizzeria:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('HD-pizza:server:reward:money')
AddEventHandler('HD-pizza:server:reward:money', function()
--HDCore.Functions.CreateCallback('HD-pizza:server:reward:money', function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', math.random(90, 360), "pizza-shop-reward")
    TriggerClientEvent('HDCore:Notify', source, "Pizza delivered! Go back to the pizza shop for a new delivery.")
    Player.Functions.RemoveItem('pizza-doos', 1)
    TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['pizza-doos'], 'remove')

end)

RegisterServerEvent('HD-pizzeria:server:get:stuff')
AddEventHandler('HD-pizzeria:server:get:stuff', function()
    local Player = HDCore.Functions.GetPlayer(source)
    
    if Player ~= nil then
        Player.Functions.AddItem('pizza-vooraad', 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['pizza-vooraad'], 'add')
    end
end)


RegisterServerEvent('HD-pizzeria:server:rem:pizza')
AddEventHandler('HD-pizzeria:server:rem:pizza', function()
    local Player = HDCore.Functions.GetPlayer(source)
    
    if Player ~= nil then
        Player.Functions.RemoveItem('pizza', 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['pizza'], 'add')
    end
end)

RegisterServerEvent('HD-pizzeria:server:rem:pizzabox')
AddEventHandler('HD-pizzeria:server:rem:pizzabox', function()
    local Player = HDCore.Functions.GetPlayer(source)
    
    if Player ~= nil then
        Player.Functions.RemoveItem('pizza', 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['pizza'], 'add')
    end
end)

RegisterServerEvent('HD-pizzeria:server:rem:stuff')
AddEventHandler('HD-pizzeria:server:rem:stuff', function(what)
    local Player = HDCore.Functions.GetPlayer(source)
    
   -- if Player ~= nil then
    if Player ~= nil and what == "pizzameat" or what == "groenten" or what == "pizza-vooraad" or what == "pizza" then
        Player.Functions.RemoveItem(what, 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['what'], 'add')
    end
end)

RegisterServerEvent('HD-pizzeria:server:add:stuff')
AddEventHandler('HD-pizzeria:server:add:stuff', function(what)
    local Player = HDCore.Functions.GetPlayer(source)
    
    --if Player ~= nil then
    if Player ~= nil and what == "pizzameat" or what == "groenten" or what == "pizza-vooraad" or what == "pizza" then
        Player.Functions.AddItem(what, 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['what'], 'add')
    end
end)


RegisterServerEvent('HD-pizza:server:set:pizza:count')
AddEventHandler('HD-pizza:server:set:pizza:count', function(plusormin, stock, amount)
    local meatstock
    local lettucestock
    if plusormin == 'Min' then
        if stock == 'stock-meat' then
            Config.JobData[stock] = Config.JobData[stock] - amount
            TriggerClientEvent('HD-pizzeria:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "stock-lettuce" then
            Config.JobData[stock] = Config.JobData[stock] - amount
            TriggerClientEvent('HD-pizzeria:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "pizzas" then
            Config.JobData[stock] = Config.JobData[stock] - amount
            TriggerClientEvent('HD-pizzeria:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "register" then
            Config.JobData[stock] = Config.JobData[stock] - amount
            TriggerClientEvent('HD-pizzeria:client:SetStock', -1, stock, Config.JobData[stock])
        end   
    elseif plusormin == 'Plus' then
        if stock == 'stock-meat' then
            Config.JobData[stock] = Config.JobData[stock] + amount
            TriggerClientEvent('HD-pizzeria:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "stock-lettuce" then
            Config.JobData[stock] = Config.JobData[stock] + amount
            TriggerClientEvent('HD-pizzeria:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "pizzas" then
            Config.JobData[stock] = Config.JobData[stock] + amount
            TriggerClientEvent('HD-pizzeria:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "register" then
            Config.JobData[stock] = Config.JobData[stock] + amount
            TriggerClientEvent('HD-pizzeria:client:SetStock', -1, stock, Config.JobData[stock])
        end
    end
end)


HDCore.Functions.CreateCallback('HD-pizza:server:get:ingredient', function(source, cb)
    local src = source
    local Ply = HDCore.Functions.GetPlayer(src)
    local lettuce = Ply.Functions.GetItemByName("groenten")
    local meat = Ply.Functions.GetItemByName("pizzameat")
    if lettuce ~= nil and meat ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

HDCore.Functions.CreateCallback('HD-pizza:server:get:pizzabox', function(source, cb)
    local src = source
    local Ply = HDCore.Functions.GetPlayer(src)
    local box = Ply.Functions.GetItemByName("pizza-vooraad")
    if box ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

HDCore.Functions.CreateCallback('HD-pizza:server:get:pizzas', function(source, cb)
    local src = source
    local Ply = HDCore.Functions.GetPlayer(src)
    local pizza = Ply.Functions.GetItemByName('pizza')
    if pizza ~= nil then
        cb(true)
    else
        cb(false)
    end
end)