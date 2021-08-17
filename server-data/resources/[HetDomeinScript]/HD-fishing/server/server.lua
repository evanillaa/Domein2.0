HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)



HDCore.Functions.CreateCallback('HD-fishing:server:can:pay', function(source, cb, price)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney("cash", price, "boat-price") then
        cb(true)
    else 
        cb(false)
    end
end)

HDCore.Functions.CreateUseableItem("fishrod", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-fishing:client:use:fishingrod', source)
    end
end)

RegisterServerEvent('HD-fishing:server:fish:reward')
AddEventHandler('HD-fishing:server:fish:reward', function()
    
--HDCore.Functions.CreateCallback('HD-fishing:server:fish:reward', function()
    local Player = HDCore.Functions.GetPlayer(source)
    local RandomValue = math.random(1, 1000)
    if RandomValue >= 100 and RandomValue < 650 then
        local SubValue = math.random(1,3)
        if SubValue == 1 then
            Player.Functions.AddItem('fish-1', 1)
            TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['fish-1'], "add") 
        elseif SubValue == 2 then
            Player.Functions.AddItem('fish-2', 1)
            TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['fish-2'], "add") 
        else
            Player.Functions.AddItem('fish-3', 1)
            TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['fish-3'], "add") 
        end
    elseif RandomValue >= 700 and RandomValue < 820 then
        local SubValue = math.random(1,991)
        if SubValue == 1 then
            Player.Functions.AddItem('burner-phone', 1)
            TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['burner-phone'], "add")  
        else
            Player.Functions.AddItem('plasticbag', 1)
            TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['plasticbag'], "add") 
        end
    else
        TriggerClientEvent('HDCore:Notify', source, "You had nothing on your hook.", "error")
    end
end)

RegisterServerEvent('HD-fishing:server:sell:items')
AddEventHandler('HD-fishing:server:sell:items', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.SellItems) do
        local Item = Player.Functions.GetItemByName(k)
        if Item ~= nil then
          if Item.amount > 0 then
              for i = 1, Item.amount do
                  Player.Functions.RemoveItem(Item.name, 1)
                  TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[Item.name], "remove")
                  if v['Type'] == 'item' then
                      Player.Functions.AddItem(v['Item'], v['Amount'])
                  else
                      Player.Functions.AddMoney('cash', v['Amount'], 'sold-fish')
                  end
                  Citizen.Wait(500)
              end
          end
        end
    end
end)