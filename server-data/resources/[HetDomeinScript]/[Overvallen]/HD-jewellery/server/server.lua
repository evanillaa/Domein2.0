local IsCooldownActive = false
HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Functions.CreateCallback('HD-jewellery:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('HD-jewellery:server:set:cooldown')
AddEventHandler('HD-jewellery:server:set:cooldown', function(bool)
    Config.Cooldown = bool
    TriggerClientEvent('HD-jewellery:client:set:cooldown', -1, bool)
end)

RegisterServerEvent('HD-jewellery:server:set:vitrine:isopen')
AddEventHandler('HD-jewellery:server:set:vitrine:isopen', function(CaseId, bool)
    Config.Vitrines[CaseId]["IsOpen"] = bool
    TriggerClientEvent('HD-jewellery:client:set:vitrine:isopen', -1, CaseId, bool)
end)

RegisterServerEvent('HD-jewellery:server:set:vitrine:busy')
AddEventHandler('HD-jewellery:server:set:vitrine:busy', function(CaseId, bool)
    Config.Vitrines[CaseId]["IsBusy"] = bool
    TriggerClientEvent('HD-jewellery:client:set:vitrine:busy', -1, CaseId, bool)
end)

RegisterServerEvent('HD-jewellery:server:start:reset')
AddEventHandler('HD-jewellery:server:start:reset', function()
    if not IsCooldownActive then
        IsCooldownActive = true
        Citizen.SetTimeout(Config.TimeOut, function()
            for k,v in pairs(Config.Vitrines) do
                Config.Vitrines[k]["IsOpen"] = false
                Config.Vitrines[k]["IsBusy"] = false
            end
            TriggerEvent('HD-jewellery:server:set:cooldown', false)
            TriggerEvent('HD-doorlock:server:updateState', 27, true)
            IsCooldownActive = false
        end)
    end
end)

RegisterServerEvent('HD-jewellery:vitrine:reward')
AddEventHandler('HD-jewellery:vitrine:reward', function()
    local Player = HDCore.Functions.GetPlayer(source)
    local RandomValue = math.random(1,100)
    if RandomValue <= 25 then
     Player.Functions.AddItem('gold-rolex', math.random(5,9))
     TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['gold-rolex'], "add")
    elseif RandomValue >= 26 and RandomValue <= 45 then
     Player.Functions.AddItem('gold-necklace', math.random(5,9))
     TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['gold-necklace'], "add")
    elseif RandomValue >= 46 and RandomValue <= 69 then
     Player.Functions.AddItem('diamond-ring', math.random(5,9))
     TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['diamond-ring'], "add")
    elseif RandomValue >= 90 and RandomValue <= 98 then
      if math.random(1,2) == 1 then
       Player.Functions.AddItem('diamond-blue', math.random(1,2))
       TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['diamond-blue'], "add")
      else
       Player.Functions.AddItem('diamond-red', math.random(1,2))
       TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['diamond-red'], "add")
      end
    else
      Player.Functions.AddItem('gold-necklace', math.random(8))
      TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['gold-necklace'], "add")
    end
end)

HDCore.Functions.CreateUseableItem("yellow-card", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-jewellery:client:use:card', source, 'yellow-card')
    end
end)