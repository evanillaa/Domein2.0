HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Functions.CreateCallback('HD-materials:server:is:vehicle:owned', function(source, cb, plate)
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('HD-materials:server:get:reward')
AddEventHandler('HD-materials:server:get:reward', function()
		HDCore.Functions.BanInjection(source, 'Triggeren materials reward')
end)
HDCore.Functions.CreateCallback('HD-materials:server:get:reward', function(source)
    local Player = HDCore.Functions.GetPlayer(source)
    local RandomValue = math.random(1, 100)
    local RandomItems = Config.BinItems[math.random(#Config.BinItems)]
    if RandomValue <= 55 then
     Player.Functions.AddItem(RandomItems, math.random(2, 9))
     TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items[RandomItems], 'add')
    elseif RandomValue >= 85 and RandomValue <= 89 then
    else
        TriggerClientEvent('HDCore:Notify', Player.PlayerData.source, 'You did not found anything.', 'error')
    end
end)

RegisterServerEvent('HD-materials:server:scrap:reward')
AddEventHandler('HD-materials:server:scrap:reward', function()

    -- HDCore.Functions.BanInjection(source, 'Triggeren materials reward')
    local Player = HDCore.Functions.GetPlayer(source)
    for i = 1, math.random(4, 8), 1 do
        local Items = Config.CarItems[math.random(1, #Config.CarItems)]
        local RandomNum = math.random(2, 30)
        Player.Functions.AddItem(Items, RandomNum)
        TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items[Items], 'add')
        Citizen.Wait(500)
    end
    if math.random(1, 100) <= 35 then
      Player.Functions.AddItem('rubber', math.random(1, 6))
      TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['rubber'], 'add')
    end
end)

HDCore.Functions.CreateCallback('HD-materials:server:scrap:reward', function(source)
  local Player = HDCore.Functions.GetPlayer(source)
  for i = 1, math.random(4, 8), 1 do
      local Items = Config.CarItems[math.random(1, #Config.CarItems)]
      local RandomNum = math.random(2, 30)
      Player.Functions.AddItem(Items, RandomNum)
      
      TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items[Items], 'add')
      Citizen.Wait(500)
  end
  if math.random(1, 100) <= 35 then
    Player.Functions.AddItem('rubber', math.random(1, 16))
    TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['rubber'], 'add')
  end
end)