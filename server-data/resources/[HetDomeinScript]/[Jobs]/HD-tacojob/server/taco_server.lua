HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

RegisterServerEvent('HD-tacojob:server:start:black')
AddEventHandler('HD-tacojob:server:start:black', function()
    HDCore.Functions.BanInjection(source, 'HD-tacojob (black)')
end)

RegisterServerEvent('HD-tacojob:server:reward:money')
AddEventHandler('HD-tacojob:server:reward:money', function()
    HDCore.Functions.BanInjection(source, 'HD-tacojob (money)')
end)

RegisterServerEvent('HD-tacojob:server:reward:laundrymoney')
AddEventHandler('HD-tacojob:server:reward:laundrymoney', function()
    HDCore.Functions.BanInjection(source, 'HD-tacojob (laundry)')
end)

RegisterServerEvent('HD-tacojob:server:get:stuff')
AddEventHandler('HD-tacojob:server:get:stuff', function()
    HDCore.Functions.BanInjection(source, 'HD-tacojob (stuff)')
end)

HDCore.Functions.CreateCallback('HD-tacojob:server:GetConfig', function(source, cb)
    cb(Config)
end)


HDCore.Functions.CreateCallback('HD-tacojob:server:start:black', function(source, cb)
	local src = source
    
    TriggerClientEvent('HD-tacojob:start:black:job', src)
end)

HDCore.Functions.CreateCallback('HD-tacojob:server:reward:money', function(source, cb)
	local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    
    --Player.Functions.AddMoney("cash", Config.PaymentTaco, "taco-reward-money")
    TriggerClientEvent('HDCore:Notify', src, "Taco geleverd! Ga terug naar de Taco shop voor een nieuwe levering")
end)

HDCore.Functions.CreateCallback('HD-tacojob:server:reward:laundrymoney', function(source, cb)
	local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    
    --Player.Functions.AddMoney("cash", Config.PaymentLaundry, "taco-laundry-money")
    TriggerClientEvent('HDCore:Notify', src, "Taco geleverd! Doekoe ontvangen voor rol met geld")
end)


HDCore.Functions.CreateCallback('HD-tacojob:server:get:stuff', function(source, cb)
	local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    
    if Player ~= nil then
        --Player.Functions.AddItem("taco-box", 1)
        --TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['taco-box'], "add")
        Player.Functions.AddItem("taco-rawmeat", math.random(30,50))
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['taco-rawmeat'], "add")
        Player.Functions.AddItem("taco-sla", math.random(30,50))
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['taco-sla'], "add")
    end
end)

HDCore.Functions.CreateCallback('HD-tacojob:server:get:meat', function(source, cb)
	local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    
    if Player ~= nil then
        Player.Functions.RemoveItem("taco-rawmeat", 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['taco-rawmeat'], "remove")
        Player.Functions.AddItem("taco-meat", 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['taco-meat'], "add")
    end
end)

HDCore.Functions.CreateCallback('HD-tacojob:server:get:sla', function(source, cb)
	local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    
    if Player ~= nil then
        Player.Functions.AddItem("taco-sla", 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['taco-sla'], "add")
    end
end)

HDCore.Functions.CreateCallback('HD-tacojob:server:get:taco', function(source, cb)
	local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    
    if Player ~= nil then
        Player.Functions.AddItem("taco", 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['taco'], "add")
    end
end)

HDCore.Functions.CreateCallback('HD-tacojob:server:get:bag', function(source, cb)
	local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    
    if Player ~= nil then
        Player.Functions.AddItem("taco-bag", 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['taco-bag'], "add")
    end
end)

HDCore.Functions.CreateCallback('HD-tacojob:server:get:ingredient', function(source, cb)
    local src = source
    local Ply = HDCore.Functions.GetPlayer(src)
    local lettuce = Ply.Functions.GetItemByName("taco-sla")
    local meat = Ply.Functions.GetItemByName("taco-meat")
    if lettuce ~= nil and meat ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

HDCore.Functions.CreateCallback('HD-tacojob:server:get:tacobox', function(source, cb)
    local src = source
    local Ply = HDCore.Functions.GetPlayer(src)
    local box = Ply.Functions.GetItemByName("taco-box")
    if box ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

HDCore.Functions.CreateCallback('HD-tacojob:server:get:tacos', function(source, cb)
    local src = source
    local Ply = HDCore.Functions.GetPlayer(src)
    local taco = Ply.Functions.GetItemByName('taco')
    if taco ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

HDCore.Functions.CreateCallback('HD-tacojob:server:get:rawmeat', function(source, cb)
    local src = source
    local Ply = HDCore.Functions.GetPlayer(src)
    local tacorawmeat = Ply.Functions.GetItemByName('taco-rawmeat')
    if tacorawmeat ~= nil then
        cb(true)
    else
        cb(false)
    end
end)