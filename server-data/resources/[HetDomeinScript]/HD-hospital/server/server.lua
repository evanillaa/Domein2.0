HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)



RegisterServerEvent('HD-hospital:server:set:state')
AddEventHandler('HD-hospital:server:set:state', function(type, state)
	local src = source
	local Player = HDCore.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.Functions.SetMetaData(type, state)
	end
end)


RegisterServerEvent('HD-hospital:server:hospital:respawn')
AddEventHandler('HD-hospital:server:hospital:respawn', function()
	local Player = HDCore.Functions.GetPlayer(source)
	local src = source
	Player.Functions.RemoveMoney('bank', Config.BedPayment, 'Hospital')
	TriggerClientEvent('HD-hospital:client:SendBillEmail', src, Config.BedPayment)
end)

RegisterServerEvent('HD-hospital:server:dead:respawn')
AddEventHandler('HD-hospital:server:dead:respawn', function()
	local Player = HDCore.Functions.GetPlayer(source)
	Player.Functions.ClearInventory()
	Citizen.SetTimeout(250, function()
		Player.Functions.Save()
	end)
	Player.Functions.RemoveMoney('bank', Config.RespawnPrice, 'respawn-fund')
end)

RegisterServerEvent('HD-hospital:server:save:health:armor')
AddEventHandler('HD-hospital:server:save:health:armor', function(PlayerHealth, PlayerArmor)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player ~= nil then
		Player.Functions.SetMetaData('health', PlayerHealth)
		Player.Functions.SetMetaData('armor', PlayerArmor)
	end
end)

RegisterServerEvent('HD-hospital:server:revive:player')
AddEventHandler('HD-hospital:server:revive:player', function(PlayerId)
	local TargetPlayer = HDCore.Functions.GetPlayer(PlayerId)
	if TargetPlayer ~= nil then
		TriggerClientEvent('HD-hospital:client:revive', TargetPlayer.PlayerData.source, true, true)
	end
end)

RegisterServerEvent('HD-hospital:server:heal:player')
AddEventHandler('HD-hospital:server:heal:player', function(TargetId)
	local TargetPlayer = HDCore.Functions.GetPlayer(TargetId)
	if TargetPlayer ~= nil then
		TriggerClientEvent('HD-hospital:client:heal', TargetPlayer.PlayerData.source)
	end
end)

RegisterServerEvent('HD-hospital:server:SendDoctorAlert')
AddEventHandler('HD-hospital:server:SendDoctorAlert', function()
	local src = source
	for k, v in pairs(HDCore.Functions.GetPlayers()) do
		local Player = HDCore.Functions.GetPlayer(v)
		if Player ~= nil then 
			if ((Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
				TriggerClientEvent("HD-hospital:client:SendAlert", v, "Er is een dokter nodig bij Pillbox Ziekenhuis 1ste verdiep")
			end
		end
	end
end)

RegisterServerEvent('HD-hospital:server:SetDoctor')
AddEventHandler('HD-hospital:server:SetDoctor', function()
	local amount = 0
	for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if ((Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
	end
	TriggerClientEvent("HD-hospital:client:SetDoctorCount", -1, amount)
end)

RegisterServerEvent('HD-hospital:server:take:blood:player')
AddEventHandler('HD-hospital:server:take:blood:player', function(TargetId)
	local src = source
	local SourcePlayer = HDCore.Functions.GetPlayer(src)
	local TargetPlayer = HDCore.Functions.GetPlayer(TargetId)
	if TargetPlayer ~= nil then
	 local Info = {vialid = math.random(11111,99999), vialname = TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname, bloodtype = TargetPlayer.PlayerData.metadata['bloodtype'], vialbsn = TargetPlayer.PlayerData.citizenid}
	 SourcePlayer.Functions.AddItem('bloodvial', 1, false, Info)
	 TriggerClientEvent('HD-inventory:client:ItemBox', SourcePlayer.PlayerData.source, HDCore.Shared.Items['bloodvial'], "add")
	end
end)

RegisterServerEvent('HD-hospital:server:set:bed:state')
AddEventHandler('HD-hospital:server:set:bed:state', function(BedData, bool)
	Config.Beds[BedData]['Busy'] = bool
	TriggerClientEvent('HD-hospital:client:set:bed:state', -1 , BedData, bool)
end)

HDCore.Functions.CreateCallback('HD-hospital:GetDoctors', function(source, cb)
	local amount = 0
	for k, v in pairs(HDCore.Functions.GetPlayers()) do
		local Player = HDCore.Functions.GetPlayer(v)
		if Player ~= nil then 
			if ((Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
				amount = amount + 1
			end
		end
	end
	cb(amount)
end)

HDCore.Commands.Add("revive", "Revive een speler of jezelf", {{name="id", help="Speler ID (mag leeg zijn)"}}, false, function(source, args)
	if args[1] ~= nil then
		local Player = HDCore.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('HD-hospital:client:revive', Player.PlayerData.source, true, true)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
		end
	else
		TriggerClientEvent('HD-hospital:client:revive', source, true, true)
	end
end, "admin")

HDCore.Commands.Add("aanwervenambulance", "Geef de ambulance baan aan iemand ", {{name="id", help="Speler ID"}, {name="grade", help="rang"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    local TargetPlayer = HDCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('HDCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen bij het ziekenhuis!', 'success')
          TriggerClientEvent('HDCore:Notify', Player.PlayerData.source, 'Je hebt'..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen bij het ziekenhuis!', 'success')
          TargetPlayer.Functions.SetJob('ambulance', 0)
      end
    end
end)

HDCore.Commands.Add("onstlagambulance", "Ontsla een ambulance!", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    local TargetPlayer = HDCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('HDCore:Notify', TargetPlayer.PlayerData.source, 'Je bent onslagen bij het ziekenhuis!', 'error')
          TriggerClientEvent('HDCore:Notify', Player.PlayerData.source, 'Je hebt'..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..'ontslaan bij het ziekenhuis!', 'success')
          TargetPlayer.Functions.SetJob('unemployed', 0)
      end
    end
end)