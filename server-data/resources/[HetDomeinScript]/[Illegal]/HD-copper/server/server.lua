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

RegisterServerEvent('HD-copper:server:set:palen:busy')
AddEventHandler('HD-copper:server:set:palen:busy', function(PlantId, bool)
    Config.Places['palen'][PlantId]['IsBezig'] = bool
    TriggerClientEvent('HD-copper:client:set:palen:busy', -1, PlantId, bool)
end)

RegisterServerEvent('HD-copper:server:set:picked:state')
AddEventHandler('HD-copper:server:set:picked:state', function(PlantId, bool)
    Config.Places['palen'][PlantId]['Geknipt'] = bool
    TriggerClientEvent('HD-copper:client:set:picked:state', -1, PlantId, bool)
end)

RegisterServerEvent('HD-copper:server:give:copper')
AddEventHandler('HD-copper:server:give:copper', function()
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        for k, v in pairs(Config.Places['palen']) do
         if Config.Places['palen'][k]['Geknipt'] then
             Citizen.Wait(300000)
             Config.Places['palen'][k]['Geknipt'] = false
             TriggerClientEvent('HD-copper:client:set:picked:state', -1, k, false)
         end
      end
  end
end)

-- Functions

HDCore.Functions.CreateCallback('HD-copper:server:GetConfig', function(source, cb)
    cb(Config)
end)

