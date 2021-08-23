HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Functions.CreateCallback('HD-copper:server:HasItem', function(source, cb, itemName)
    local Player = HDCore.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName(itemName)
	if Player ~= nil then
        if Item ~= nil then
			cb(true)
        else
			cb(false)
        end
	end
end)

RegisterServerEvent('HD-copper:server:set:plant:busy')
AddEventHandler('HD-copper:server:set:plant:busy', function(PlantId, bool)
    Config.Plants['planten'][PlantId]['IsBezig'] = bool
    TriggerClientEvent('HD-copper:client:set:plant:busy', -1, PlantId, bool)
end)

RegisterServerEvent('HD-copper:server:set:picked:state')
AddEventHandler('HD-copper:server:set:picked:state', function(PlantId, bool)
    Config.Plants['planten'][PlantId]['Geplukt'] = bool
    TriggerClientEvent('HD-copper:client:set:picked:state', -1, PlantId, bool)
end)

--[[RegisterServerEvent('HD-copper:server:set:dry:busy')
AddEventHandler('HD-copper:server:set:dry:busy', function(DryRackId, bool)
    Config.Plants['drogen'][DryRackId]['IsBezig'] = bool
    TriggerClientEvent('HD-copper:client:set:dry:busy', -1, DryRackId, bool)
end)

RegisterServerEvent('HD-copper:server:set:pack:busy')
AddEventHandler('HD-copper:server:set:pack:busy', function(PackerId, bool)
    Config.Plants['verwerk'][PackerId]['IsBezig'] = bool
    TriggerClientEvent('HD-copper:client:set:pack:busy', -1, PackerId, bool)
end)

RegisterServerEvent('HD-copper:server:add:cash')
AddEventHandler('HD-copper:server:add:cash', function()
    local Speler = HDCore.Functions.GetPlayer(source)
    local RandomAmount = math.random(10,34)
    Speler.Functions.AddMoney('cash', RandomAmount, "dried-bud-sell")
end)]]

RegisterServerEvent('HD-copper:server:give:tak')
AddEventHandler('HD-copper:server:give:tak', function()
    local Speler = HDCore.Functions.GetPlayer(source)
    Speler.Functions.AddItem('copper', math.random(2,4))
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['copper'], "add")
end)

RegisterServerEvent('HD-copper:server:add:item')
AddEventHandler('HD-copper:server:add:item', function(Item, Amount)
    local Player = HDCore.Functions.GetPlayer(source)
    Player.Functions.AddItem(Item, Amount)
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items[Item], "add")
end)

RegisterServerEvent('HD-copper:server:remove:item')
AddEventHandler('HD-copper:server:remove:item', function(Item, Amount)
    local Player = HDCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(Item, Amount)
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items[Item], "remove")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        for k, v in pairs(Config.Plants['planten']) do
         if Config.Plants['planten'][k]['Geplukt'] then
             Citizen.Wait(300000)
             Config.Plants['planten'][k]['Geplukt'] = false
             TriggerClientEvent('HD-copper:client:set:picked:state', -1, k, false)
         end
      end
  end
end)

-- Functions

HDCore.Functions.CreateCallback('HD-copper:server:GetConfig', function(source, cb)
    cb(Config)
end)

