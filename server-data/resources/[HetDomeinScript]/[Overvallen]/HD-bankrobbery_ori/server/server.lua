local IsBankBeingRobbed = false
cooldowntime = Config.Cooldown 
atmcooldown = false

HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Functions.CreateCallback("HD-bankrobbery:server:get:status", function(source, cb)
  cb(IsBankBeingRobbed)
end)

HDCore.Functions.CreateCallback("HD-bankrobbery:server:get:key:config", function(source, cb)
  cb(Config)
end)

HDCore.Functions.CreateCallback("HD-atmrobbery:getHackerDevice",function(source,cb)
	local xPlayer = HDCore.Functions.GetPlayer(source)
	if xPlayer.Functions.GetItemByName("electronickit") and xPlayer.Functions.GetItemByName("drill") then
		cb(true)
	else
		cb(false)
		TriggerClientEvent('HDCore:Notify', source, _U("needdrill"))
	end
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

RegisterServerEvent('HD-atm:rem:drill')
AddEventHandler('HD-atm:rem:drill', function()
local xPlayer = HDCore.Functions.GetPlayer(source)
	xPlayer.Functions.RemoveItem('drill', 1)
end)

HDCore.Functions.CreateUseableItem('electronickit', function(source)
	TriggerClientEvent('HD-atm:item', source)
end)


RegisterServerEvent("HD-atmrobbery:success")
AddEventHandler("HD-atmrobbery:success",function()
	local xPlayer = HDCore.Functions.GetPlayer(source)
    local reward = math.random(Config.MinReward,Config.MaxReward)
		xPlayer.Functions.AddMoney(Config.RewardAccount, tonumber(reward))

		TriggerClientEvent("HDCore:Notify",source,_U("success") ..""..reward.. " !")
end)

RegisterServerEvent('HD-atm:CooldownServer')
AddEventHandler('HD-atm:CooldownServer', function(bool)
    atmcooldown = bool
	if bool then 
		cooldown()
	end	 
end)



RegisterServerEvent('kwk-robparking:server:1I1i01I1')
AddEventHandler('kwk-robparking:server:1I1i01I1', function(count)
    local src = source
    local xPlayer = HDCore.Functions.GetPlayer(src)
    --print("haha")
    local data = {
        worth = math.random(75,150)
    }

    xPlayer.Functions.AddItem('markedbills', 1, false, data)
    TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items["markedbills"], 'add')
    TriggerClientEvent('HDCore:Notify', src, 'Totaal bedrag uit de parkeermeter getrokken: € ' ..data.worth, "success")
end)

RegisterServerEvent('HD-atm:CooldownNotify')
AddEventHandler('HD-atm:CooldownNotify', function()
	TriggerClientEvent("HDCore:Notify",source,_U("atmrob") ..""..cooldowntime.." Minutes!")
end)

function cooldown()

	while true do 
	Citizen.Wait(60000)

	cooldowntime = cooldowntime - 1 

	if cooldowntime <= 0 then
		atmcooldown = false
		break
	end

end
end

HDCore.Functions.CreateCallback("HD-atm:GetCooldown",function(source,cb)
	cb(atmcooldown)
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
AddEventHandler('HD-bankrobbery:server:random:reward', function(Tier, BankId)
  local Player = HDCore.Functions.GetPlayer(source)
  local RandomValue = math.random(1, 110)
  TriggerEvent('HD-board:server:SetActivityBusy', "bankrobbery", true)
  if BankId ~= 6 then
      if RandomValue >= 1 and RandomValue <= 18 then
        if Tier == 2 then
          Player.Functions.AddItem('yellow-card', 1)
          TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['yellow-card'], "add")
        elseif Tier == 3 then
          Player.Functions.AddItem('purple-card', 1)
          TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['purple-card'], "add")
        end
        Player.Functions.AddMoney('cash', math.random(6000, 18500), "Bank Robbery")
      elseif RandomValue >= 22 and RandomValue <= 35 then
        Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(3500, 5000)})
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['markedbills'], "add")
      elseif RandomValue >= 40 and RandomValue <= 52 then
        Player.Functions.AddItem('gold-bar', math.random(1,4))
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['gold-bar'], "add") 
      elseif RandomValue >= 55 and RandomValue <= 75 then
        Player.Functions.AddItem('gold-necklace', math.random(4,8))
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['gold-necklace'], "add") 
      elseif RandomValue >= 76 and RandomValue <= 96 then
        Player.Functions.AddItem('gold-rolex', math.random(4,8))
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['gold-rolex'], "add")
      else
        TriggerClientEvent('HDCore:Notify', source, _U("nopes"), "error", 4500)
      end
  else
      if RandomValue >= 1 and RandomValue <= 18 then
        if Tier == 2 then
          Player.Functions.AddItem('yellow-card', 1)
          TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['yellow-card'], "add")
        elseif Tier == 3 then
          Player.Functions.AddItem('black-card', 1)
          TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['black-card'], "add")
        end
        Player.Functions.AddMoney('cash', math.random(2500, 23500), "Bank Robbery")
      elseif RandomValue >= 22 and RandomValue <= 36 then
        Player.Functions.AddItem('markedbills', 1, false, {worth = math.random(7500, 18000)})
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['markedbills'], "add")
      elseif RandomValue >= 40 and RandomValue <= 55 then
        Player.Functions.AddItem('gold-bar', math.random(1,4))
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['gold-bar'], "add") 
      elseif RandomValue >= 62 and RandomValue <= 96 then
        Player.Functions.AddItem('gold-rolex', math.random(4,8))
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['gold-rolex'], "add")
      elseif RandomValue == 110 or RandomValue == 97 or RandomValue == 98 or RandomValue == 105 then
        if Tier == 1 then
          Player.Functions.AddItem('blue-card', 1)
          TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['blue-card'], "add")
        elseif Tier == 2 then
          Player.Functions.AddItem('black-card', 1)
          TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['black-card'], "add")
        elseif Tier == 3 then
          Player.Functions.AddItem('pistol-ammo', math.random(2,6))
          TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['pistol-ammo'], "add")
        end
      else
        TriggerClientEvent('HDCore:Notify', source, _U("nopes"), "error", 4500)
      end
  end
end)

RegisterServerEvent('HD-bankrobbery:server:rob:pacific:money')
AddEventHandler('HD-bankrobbery:server:rob:pacific:money', function()
  local Player = HDCore.Functions.GetPlayer(source)
  local RandomValue = math.random(1, 110)
  Player.Functions.AddMoney('cash', math.random(1500, 10000), "Bank Robbery")
  if RandomValue > 15 and  RandomValue < 20 then
     Player.Functions.AddItem('money-roll', 1, false, {worth = math.random(250, 580)})
     TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['money-roll'], "add")
  end
end)

RegisterServerEvent('HD-bankrobbery:server:pacific:start')
AddEventHandler('HD-bankrobbery:server:pacific:start', function()
  Config.SpecialBanks[1]['Open'] = true
  IsBankBeingRobbed = true
  -- TriggerEvent('HD-board:server:SetActivityBusy', "skim", true)
  TriggerClientEvent('HD-bankrobbery:client:pacific:start', -1)
  Citizen.SetTimeout((1000 * 60) * math.random(20,30), function()
    TriggerClientEvent('HD-bankrobbery:client:clear:trollys', -1)
    TriggerClientEvent('HD-doorlock:server:reset:door:looks', -1)
    IsBankBeingRobbed = false
    for k,v in pairs(Config.Trollys) do 
      v['Open-State'] = false
    end
  end)
end)

RegisterServerEvent('HD-bankrobbery:server:set:trolly:state')
AddEventHandler('HD-bankrobbery:server:set:trolly:state', function(TrollyNumber, bool)
 Config.Trollys[TrollyNumber]['Open-State'] = bool
 TriggerClientEvent('HD-bankrobbery:client:set:trolly:state', -1, TrollyNumber, bool)
end)

function StartRestart(BankId)
  Citizen.SetTimeout((1000 * 60) * math.random(20,30), function()
    IsBankBeingRobbed = false
    Config.BankLocations[BankId]['IsOpened'] = false
    TriggerClientEvent('HD-bankrobbery:client:set:open', -1, BankId, false)
    --DOORS reset
    for k, v in pairs(Config.BankLocations[BankId]['DoorId']) do
      TriggerEvent('HD-doorlock:server:updateState', v, true)
    end
    -- Lockers
    for k,v in pairs(Config.BankLocations[BankId]['Lockers']) do
     v['IsBusy'] = false
     v['IsOpend'] = false
    TriggerClientEvent('HD-bankrobbery:client:set:state', -1, BankId, k, 'IsBusy', false)
    TriggerClientEvent('HD-bankrobbery:client:set:state', -1, BankId, k, 'IsOpend', false)
    end
    
    TriggerEvent('HD-board:server:SetActivityBusy', "bankrobbery", false)
  end)
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(4)
    for k, v in pairs(Config.BankLocations) do
      local RandomCard = Config.CardType[math.random(1, #Config.CardType)]
      Config.BankLocations[k]['card-type'] = RandomCard
      TriggerClientEvent('HD-bankrobbery:client:set:cards', -1, k, Config.BankLocations[k]['card-type'])
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

HDCore.Functions.CreateUseableItem("black-card", function(source, item)
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