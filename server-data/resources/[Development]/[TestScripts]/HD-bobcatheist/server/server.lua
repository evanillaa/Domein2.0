HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Functions.CreateCallback('HD-bobcatheist:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent("fuze:particleserver")
AddEventHandler("fuze:particleserver", function(method)
    TriggerClientEvent("fuze:ptfxparticle", -1, method)
end)

RegisterServerEvent("fuze:particleserversec")
AddEventHandler("fuze:particleserversec", function(method)
    TriggerClientEvent("fuze:ptfxparticlesec", -1, method)
end)

HDCore.Functions.CreateUseableItem("black-card", function(source, item)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    print("Je moeder het werkt")
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        print(item.slot)
        TriggerClientEvent('fuze:getdoor', source, item)
        print("Brime is dom")
    end
end)

RegisterServerEvent('fuze:removeCard')
AddEventHandler('fuze:removeCard', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('black-card', 1)
end)


--HDCore.Functions.CreateUseableItem("thermite", function(source, item)
--    local Player = HDCore.Functions.GetPlayer(source)
--    TriggerClientEvent('seatbelt:client:UseHarness', source, item)
--end)

RegisterServerEvent('fuze:removeItem')
AddEventHandler('fuze:removeItem', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('thermite', 1)
end)

HDCore.Functions.CreateUseableItem("thermite", function(source, item)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    print("Je moeder het werkt")
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        print(item.slot)
        TriggerClientEvent('fuze:getdoor', source, item)
        print("Brime is dom")
    end
end)