HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Functions.CreateCallback('HD-field:server:HasItem', function(source, cb, itemName)
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

RegisterServerEvent('HD-field:server:set:plant:busy')
AddEventHandler('HD-field:server:set:plant:busy', function(PlantId, bool)
    Config.Plants['planten'][PlantId]['IsBezig'] = bool
    TriggerClientEvent('HD-field:client:set:plant:busy', -1, PlantId, bool)
end)

RegisterServerEvent('HD-field:server:set:picked:state')
AddEventHandler('HD-field:server:set:picked:state', function(PlantId, bool)
    Config.Plants['planten'][PlantId]['Geplukt'] = bool
    TriggerClientEvent('HD-field:client:set:picked:state', -1, PlantId, bool)
end)

RegisterServerEvent('HD-field:server:set:dry:busy')
AddEventHandler('HD-field:server:set:dry:busy', function(DryRackId, bool)
    Config.Plants['drogen'][DryRackId]['IsBezig'] = bool
    TriggerClientEvent('HD-field:client:set:dry:busy', -1, DryRackId, bool)
end)

RegisterServerEvent('HD-field:server:set:pack:busy')
AddEventHandler('HD-field:server:set:pack:busy', function(PackerId, bool)
    Config.Plants['verwerk'][PackerId]['IsBezig'] = bool
    TriggerClientEvent('HD-field:client:set:pack:busy', -1, PackerId, bool)
end)

RegisterServerEvent('HD-field:server:add:cash')
AddEventHandler('HD-field:server:add:cash', function()
    local Speler = HDCore.Functions.GetPlayer(source)
    local RandomAmount = math.random(10,34)
    Speler.Functions.AddMoney('cash', RandomAmount, "dried-bud-sell")
end)

RegisterServerEvent('HD-field:server:give:tak')
AddEventHandler('HD-field:server:give:tak', function()
    local Speler = HDCore.Functions.GetPlayer(source)
    Speler.Functions.AddItem('wet-tak', math.random(2,4))
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['wet-tak'], "add")
end)

RegisterServerEvent('HD-field:server:add:item')
AddEventHandler('HD-field:server:add:item', function(Item, Amount)
    local Player = HDCore.Functions.GetPlayer(source)
    Player.Functions.AddItem(Item, Amount)
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items[Item], "add")
end)

RegisterServerEvent('HD-field:server:remove:item')
AddEventHandler('HD-field:server:remove:item', function(Item, Amount)
    local Player = HDCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(Item, Amount)
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items[Item], "remove")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        for k, v in pairs(Config.Plants['planten']) do
         if Config.Plants['planten'][k]['Geplukt'] then
             Citizen.Wait(30000)
             Config.Plants['planten'][k]['Geplukt'] = false
             TriggerClientEvent('HD-field:client:set:picked:state', -1, k, false)
         end
      end
  end
end)

-- Functions

HDCore.Functions.CreateCallback('HD-field:server:GetConfig', function(source, cb)
    cb(Config)
end)

HDCore.Functions.CreateCallback('HD-field:server:has:takken', function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    local ItemTak = Player.Functions.GetItemByName("wet-tak")
	if ItemTak ~= nil then
        if ItemTak.amount >= 2 then
            cb(true)
		else
            cb(false)
		end
	   else
        cb(false)
	end
end)

HDCore.Functions.CreateCallback('HD-field:server:has:nugget', function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    local ItemNugget = Player.Functions.GetItemByName("wet-bud")
    local ItemBag = Player.Functions.GetItemByName("plastic-bag")
	if ItemNugget ~= nil and ItemBag ~= nil then
        if ItemNugget.amount >= 2 and ItemBag.amount >= 1 then
            cb(true)
		else
            cb(false)
		end
	   else
        cb(false)
	end
end)