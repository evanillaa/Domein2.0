local IsBankBeingRobbed = false

HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Functions.CreateCallback("HD-bankrobbery:server:get:status", function(source, cb)
  cb(IsBankBeingRobbed)
end)

HDCore.Functions.CreateCallback("HD-bankrobbery:server:get:key:config", function(source, cb)
  cb(Config)
end)

HDCore.Functions.CreateCallback('HD-bankrobbery:server:HasItem', function(source, cb, ItemName)
  local Player = HDCore.Functions.GetPlayer(source)
  local Item = Player.Functions.GetItemByName(ItemName)
  if Player ~= nil then
     if Item ~= nil then
       cb(true)
     else
       cb(false)
     end
  end
end)

HDCore.Functions.CreateCallback('HD-bankrobbery:server:HasLockpickItems', function(source, cb)
  local Player = HDCore.Functions.GetPlayer(source)
  local LockpickItem = Player.Functions.GetItemByName('lockpick')
  local ToolkitItem = Player.Functions.GetItemByName('toolkit')
  local AdvancedLockpick = Player.Functions.GetItemByName('advancedlockpick')
  if Player ~= nil then
    if LockpickItem ~= nil and ToolkitItem ~= nil or AdvancedLockpick ~= nil then
      cb(true)
    else
      cb(false)
    end
  end
end)

RegisterServerEvent('HD-bankrobbery:server:set:state')
AddEventHandler('HD-bankrobbery:server:set:state', function(BankId, LockerId, Type, bool)
 Config.BankLocations[BankId]['Lockers'][LockerId][Type] = bool
 TriggerClientEvent('HD-bankrobbery:client:set:state', -1, BankId, LockerId, Type, bool)
end)

RegisterServerEvent('HD-bankrobbery:server:set:open')
AddEventHandler('HD-bankrobbery:server:set:open', function(BankId, bool)
 IsBankBeingRobbed = bool
 Config.BankLocations[BankId]['IsOpened'] = bool
 TriggerClientEvent('HD-bankrobbery:client:set:open', -1, BankId, bool)
 StartRestart(BankId)
end)

RegisterServerEvent('HD-bankrobbery:server:random:reward')
AddEventHandler('HD-bankrobbery:server:random:reward', function(Tier)
  local Player = HDCore.Functions.GetPlayer(source)
  local RandomValue = math.random(1, 155)
  print(RandomValue)
  if RandomValue >= 1 and RandomValue <= 18 then
    if Tier == 2 then
      Player.Functions.AddItem('yellow-card', 1)
      TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['yellow-card'], "add")
    end
    Player.Functions.AddMoney('cash', math.random(1000, 2500), "Bank Robbery")
  elseif RandomValue >= 22 and RandomValue <= 35 then
    Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(3500, 5000)})
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['markedbills'], "add")
  elseif RandomValue >= 40 and RandomValue <= 49 then
    Player.Functions.AddItem('gold-bar', math.random(1,4))
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['gold-bar'], "add") 
  elseif RandomValue >= 55 and RandomValue <= 75 then
    Player.Functions.AddItem('gold-necklace', math.random(4,8))
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['gold-necklace'], "add") 
  elseif RandomValue >= 76 and RandomValue <= 96 then
    Player.Functions.AddItem('gold-rolex', math.random(4,8))
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['gold-rolex'], "add")
  elseif RandomValue >= 111 and RandomValue <= 121 then
    Player.Functions.AddItem('sns-handle', 1)
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['sns-handle'], "add")
  --[[ Voorlopig uit tot de SNS de stad in gaat
  elseif RandomValue >= 127 and RandomValue <= 132 then
    Player.Functions.AddItem('sns-blueprint', 1)
    TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['sns-blueprint'], 'add')
  ]]
  else
    TriggerClientEvent('HDCore:Notify', source, "Je vond niks hier..", "error", 4500)
  end
end)

function StartRestart(BankId)
  Citizen.SetTimeout((1000 * 60) * math.random(20,30), function()
    IsBankBeingRobbed = false
    Config.BankLocations[BankId]['IsOpened'] = false
    TriggerClientEvent('HD-bankrobbery:client:set:open', -1, BankId, false)
    -- Lockers
    for k,v in pairs(Config.BankLocations[BankId]['Lockers']) do
     v['IsBusy'] = false
     v['IsOpend'] = false
    TriggerClientEvent('HD-bankrobbery:client:set:state', -1, BankId, k, 'IsBusy', false)
    TriggerClientEvent('HD-bankrobbery:client:set:state', -1, BankId, k, 'IsOpend', false)
    end
  end)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(4)
    for k, v in pairs(Config.BankLocations) do
      local RandomCard = Config.CardType[math.random(1, #Config.CardType)]
      Config.BankLocations[k]['card-type'] = RandomCard
      TriggerClientEvent('HD-bankrobbery:client:set:cards', -1, k, RandomCard)
    end
    Citizen.Wait((1000 * 60) * 60)
  end
end)
-- // Card Types \\ --

HDCore.Functions.CreateUseableItem("red-card", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-bankrobbery:client:use:card', source, 'red-card')
    end
end)

HDCore.Functions.CreateUseableItem("purple-card", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-bankrobbery:client:use:card', source, 'purple-card')
    end
end)

HDCore.Functions.CreateUseableItem("blue-card", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-bankrobbery:client:use:card', source, 'blue-card')
    end
end)