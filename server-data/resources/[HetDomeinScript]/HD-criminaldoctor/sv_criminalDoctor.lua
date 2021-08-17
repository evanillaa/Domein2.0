HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

RegisterNetEvent("emma:chargehim")
AddEventHandler("emma:chargehim", function(item, count)
    local src = source

    local Player = HDCore.Functions.GetPlayer(src)

    local check = Player.PlayerData.money.cash
    
    if Player then
		if check >= Config.toPay then
            Player.Functions.RemoveMoney('cash', Config.toPay)
            TriggerClientEvent("chip_cDoc:getHelp", src)
		else
            TriggerClientEvent('HDCore:Notify', src, 'Je hebt geen cash genoeg.', 'error')
		end
    end
    

end)

RegisterNetEvent("emma:help")
AddEventHandler("emma:help", function(playertreat)

  local src = source

  local Player = HDCore.Functions.GetPlayer(src)

  TriggerClientEvent('hospital:client:Revive', src)
  print('it worked till server side')

end)