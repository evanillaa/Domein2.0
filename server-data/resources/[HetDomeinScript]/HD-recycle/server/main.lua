HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

local ItemTable = {
    "metalscrap",
    "plastic",
    --"copper",
    "iron",
    "aluminum",
    "steel",
    "glass",
    "rubber",
}

--- Event For Getting Recyclable Material----

RegisterServerEvent("HD-recycle:getrecyclablematerial")
AddEventHandler("HD-recycle:getrecyclablematerial", function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    for i = 1, math.random(1, 5), 1 do
        local amount = math.random(2, 6)
        Player.Functions.AddItem("recyclablematerial", amount)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items["recyclablematerial"], 'add')
        Citizen.Wait(500)
    end
end)

--------------------------------------------------

---- Trade Event Starts Over Here ------

RegisterServerEvent("HD-recycle:server:TradeItems")
AddEventHandler("HD-recycle:server:TradeItems", function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    for i = 1, math.random(1, 5), 1 do
        local randItem = ItemTable[math.random(1, #ItemTable)]
        local amount = math.random(1, 3)

        if Player.Functions.GetItemByName('recyclablematerial') ~= nil and Player.Functions.GetItemByName('recyclablematerial').amount >= 10 then
            Player.Functions.RemoveItem("recyclablematerial", "10")
        Player.Functions.AddItem(randItem, amount)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[randItem], 'add')
        Citizen.Wait(5000)
        Player.Functions.AddItem(randItem, amount)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[randItem], 'add')
        Citizen.Wait(5000)
        Player.Functions.AddItem(randItem, amount)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[randItem], 'add')
        else
            TriggerClientEvent('HDCore:Notify', src, "You dont have enough bags")
    end
end
end)

RegisterServerEvent("HD-recycle:server:TradeItemsBulk")
AddEventHandler("HD-recycle:server:TradeItemsBulk", function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    for i = 1, math.random(1, 5), 1 do
        local randItem = ItemTable[math.random(1, #ItemTable)]
        local amount = math.random(1, 15)

        if Player.Functions.GetItemByName('recyclablematerial') ~= nil and Player.Functions.GetItemByName('recyclablematerial').amount >= 100 then
            Player.Functions.RemoveItem("recyclablematerial", "100")
            TriggerClientEvent('HD-HD-inventory:client:ItemBox', src, HDCore.Shared.Items["recyclablematerial"], 'remove')
            Citizen.Wait(5000)

            local Kans = math.random(1, 50)
        Player.Functions.AddItem(randItem, amount)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[randItem], 'add')
        Citizen.Wait(3000)
        Player.Functions.AddItem(randItem, amount)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[randItem], 'add')
        Citizen.Wait(3000)
        Player.Functions.AddItem(randItem, amount)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[randItem], 'add')
        Citizen.Wait(3000)
        Player.Functions.AddItem(randItem, amount)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[randItem], 'add')
        Citizen.Wait(3000)
        Player.Functions.AddItem(randItem, amount)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[randItem], 'add')
        Citizen.Wait(3000)
        Player.Functions.AddItem(randItem, amount)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[randItem], 'add')
        Citizen.Wait(3000)
        Player.Functions.AddItem(randItem, amount)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[randItem], 'add')
        Citizen.Wait(3000)
        if Kans == 10 then
        Player.Functions.AddItem("lockpick", 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items["lockpick"], 'add')
        Citizen.Wait(3000)
        end
        else
            TriggerClientEvent('HDCore:Notify', src, "Je hebt niet genoeg recyclebaar materiaal op zak")
    end
end
end)