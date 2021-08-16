local ResetStress = false -- stress

RegisterServerEvent("HD-hud:Server:UpdateStress")
AddEventHandler('HD-hud:Server:UpdateStress', function(StressGain)
	local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local newStress
    if Player ~= nil then
        if not ResetStress then
            if Player.PlayerData.metadata["stress"] == nil then
                Player.PlayerData.metadata["stress"] = 0
            end
            newStress = Player.PlayerData.metadata["stress"] + StressGain
            if newStress <= 0 then newStress = 0 end
        else
            newStress = 0
        end
        if newStress > 100 then
            newStress = 100
        end
        Player.Functions.SetMetaData("stress", newStress)
		TriggerClientEvent("HD-hud:client:update:stress", src, newStress)
	end
end)

RegisterServerEvent('HD-hud:server:gain:stress')
AddEventHandler('HD-hud:server:gain:stress', function(amount)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local newStress
    if Player ~= nil then
        if not ResetStress then
            if Player.PlayerData.metadata["stress"] == nil then
                Player.PlayerData.metadata["stress"] = 0
            end
            newStress = Player.PlayerData.metadata["stress"] + amount
            if newStress <= 0 then newStress = 0 end
        else
            newStress = 0
        end
        if newStress > 100 then
            newStress = 100
        end
        Player.Functions.SetMetaData("stress", newStress)
        TriggerClientEvent("HD-hud:client:update:stress", src, newStress)
        TriggerClientEvent('HDCore:Notify', src, 'Gained stress', 'error', 1500)
	end
end)

RegisterServerEvent('HD-hud:Server:RelieveStress')
AddEventHandler('HD-hud:Server:RelieveStress', function(amount)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local newStress
    if Player ~= nil then
        if not ResetStress then
            if Player.PlayerData.metadata["stress"] == nil then
                Player.PlayerData.metadata["stress"] = 0
            end
            newStress = Player.PlayerData.metadata["stress"] - amount
            if newStress <= 0 then newStress = 0 end
        else
            newStress = 0
        end
        if newStress > 100 then
            newStress = 100
        end
        Player.Functions.SetMetaData("stress", newStress)
        TriggerClientEvent("HD-hud:client:update:stress", src, newStress)
        TriggerClientEvent('HDCore:Notify', src, 'Stress relieved')
	end
end)

RegisterServerEvent('HD-hud:server:remove:stress')
AddEventHandler('HD-hud:server:remove:stress', function(Amount)
    local Player = HDCore.Functions.GetPlayer(source)
    local NewStress = nil
    if Player ~= nil then
      NewStress = Player.PlayerData.metadata["stress"] - Amount
      if NewStress <= 0 then NewStress = 0 end
      if NewStress > 105 then NewStress = 100 end
      Player.Functions.SetMetaData("stress", NewStress)
      TriggerClientEvent("HD-hud:client:update:stress", Player.PlayerData.source, NewStress)
    end
end)