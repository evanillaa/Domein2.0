HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Functions.CreateCallback('HD-coper:server:HasItem', function(source, cb, itemName)
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

RegisterServerEvent('HD-copper:server:give:tak')
AddEventHandler('HD-copper:server:give:tak', function()
    local Speler = HDCore.Functions.GetPlayer(source)
    Speler.Functions.AddItem('copper', math.random(2,8))
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['copper'], "add")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        for k, v in pairs(Config.Plants['planten']) do
         if Config.Plants['planten'][k]['Geplukt'] then
             Citizen.Wait(30000)
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

HDCore.Functions.CreateCallback('HD-copper:server:has:takken', function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    local ItemTak = Player.Functions.GetItemByName("copper")
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