-- Player joined
RegisterServerEvent("HDCore:PlayerJoined")
AddEventHandler('HDCore:PlayerJoined', function()
	local src = source
end)

AddEventHandler('playerDropped', function(reason) 
	local src = source
	TriggerClientEvent('HDCore:Client:OnPlayerUnload', src)
	TriggerClientEvent('HDCore:Player:UpdatePlayerPosition', src)
	TriggerEvent("HD-logs:server:SendLog", "joinleave", "Dropped", "red", "**".. GetPlayerName(src) .. "** ("..GetPlayerIdentifiers(src)[1]..") left..")
	if reason ~= "Reconnecting" and src > 60000 then return false end
	if(src==nil or (HDCore.Players[src] == nil)) then return false end
	HDCore.Players[src].Functions.Save()
	HDCore.Players[src] = nil
end)

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	deferrals.defer()
	local src = source
	Wait(1500)
	deferrals.update("Checking name...")
	Wait(1500)
	local name = GetPlayerName(src)
	if name == nil then 
		HDCore.Functions.Kick(src, 'Gelieve geen lege steam naam te gebruiken.', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	if(string.match(name, "[*%%'=`\"]")) then
        HDCore.Functions.Kick(src, 'Je hebt in je naam een teken('..string.match(name, "[*%%'=`\"]")..') zitten wat niet is toegestaan.\nGelieven deze uit je steam-naam te halen.', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	if (string.match(name, "drop") or string.match(name, "table") or string.match(name, "database")) then
        HDCore.Functions.Kick(src, 'Je hebt in je naam een woord (drop/table/database) zitten wat niet is toegestaan.\nGelieven je steam naam te veranderen.', setKickReason, deferrals)
        CancelEvent()
        return false
	end
	Wait(1500)
	deferrals.update("Checking identifiers...")
	Wait(1500)
    local identifiers = GetPlayerIdentifiers(src)
	local steamid = identifiers[1]
	local license = identifiers[2]
    if (Config.IdentifierType == "steam" and (steamid:sub(1,6) == "steam:") == false) then
        HDCore.Functions.Kick(src, 'Je moet steam aan hebben staan om te spelen.', setKickReason, deferrals)
        CancelEvent()
		return false
	elseif (Config.IdentifierType == "license" and (steamid:sub(1,6) == "license:") == false) then
		HDCore.Functions.Kick(src, 'Geen socialclub license gevonden.', setKickReason, deferrals)
        CancelEvent()
		return false
	end
	Wait(2500)
	deferrals.update("Checking ban status...")
	Wait(2500)
	local isBanned, Message = HDCore.Functions.IsPlayerBanned(src)
    if (isBanned) then
		deferrals.update(Message)
        CancelEvent()
        return false
    end
	TriggerEvent("HD-logs:server:SendLog", "joinleave", "Queue", "orange", "**"..name .. "** ("..json.encode(GetPlayerIdentifiers(src))..") in queue..")
	TriggerEvent("connectqueue:playerConnect", src, setKickReason, deferrals)
end)

RegisterServerEvent("HDCore:Server:TriggerCallback")
AddEventHandler('HDCore:Server:TriggerCallback', function(name, ...)
	local src = source
	HDCore.Functions.TriggerCallback(name, src, function(...)
		TriggerClientEvent("HDCore:Client:TriggerCallback", src, name, ...)
	end, ...)
end)

RegisterServerEvent("HDCore:UpdatePlayer")
AddEventHandler('HDCore:UpdatePlayer', function(data)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player ~= nil then
		local newHunger = Player.PlayerData.metadata["hunger"] - 4.3
		local newThirst = Player.PlayerData.metadata["thirst"] - 4.3
		if newHunger <= 0 then newHunger = 0 end
		if newThirst <= 0 then newThirst = 0 end
		Player.PlayerData.position = data.position
		Player.Functions.SetMetaData("thirst", newThirst)
		Player.Functions.SetMetaData("hunger", newHunger)
		TriggerClientEvent("HD-hud:client:update:needs", source, newHunger, newThirst)
		Player.Functions.Save()
	end
end)

RegisterServerEvent("HDCore:Salary")
AddEventHandler('HDCore:Salary', function(data)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player ~= nil then
	 Player.Functions.AddMoney("cash", Player.PlayerData.job.payment)
	end
end)

--[[RegisterServerEvent("Cube:Salary")
AddEventHandler('Cube:Salary', function(data)
	local Player = Cube.Functions.GetPlayer(source)
	if Player ~= nil then
		Player.Functions.AddItem('paycheck', 1, false, {worth = Player.PlayerData.job.payment})
		TriggerClientEvent('Cube:Notify', source, "Je hebt je loonstrook ontvangen..", "success")
	end
end)]]

RegisterServerEvent("HDCore:UpdatePlayerPosition")
AddEventHandler("HDCore:UpdatePlayerPosition", function(position)
	local src = source
	local Player = HDCore.Functions.GetPlayer(src)
	if Player ~= nil then
		Player.PlayerData.position = position
	end
end)

RegisterServerEvent('HDCore:Server:SetMetaData')
AddEventHandler('HDCore:Server:SetMetaData', function(Meta, Data)
	local Player = HDCore.Functions.GetPlayer(source)
	if Meta == 'hunger' or Meta == 'thirst' then
		if Data >= 100 then
			Data = 100
		end
	end
	if Player ~= nil then 
		Player.Functions.SetMetaData(Meta, Data)
	end
	TriggerClientEvent("HD-hud:client:update:needs", source, Player.PlayerData.metadata["hunger"], Player.PlayerData.metadata["thirst"])
end)

AddEventHandler('chatMessage', function(source, n, message)
	if string.sub(message, 1, 1) == "/" then
		local args = HDCore.Shared.SplitStr(message, " ")
		local command = string.gsub(args[1]:lower(), "/", "")
		CancelEvent()
		if HDCore.Commands.List[command] ~= nil then
			local Player = HDCore.Functions.GetPlayer(tonumber(source))
			if Player ~= nil then
				table.remove(args, 1)
				if (HDCore.Functions.HasPermission(source, "god") or HDCore.Functions.HasPermission(source, HDCore.Commands.List[command].permission)) then
					if (HDCore.Commands.List[command].argsrequired and #HDCore.Commands.List[command].arguments ~= 0 and args[#HDCore.Commands.List[command].arguments] == nil) then
					    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Alle argumenten moeten ingevuld worden!")
					    local agus = ""
					    for name, help in pairs(HDCore.Commands.List[command].arguments) do
					    	agus = agus .. " ["..help.name.."]"
					    end
				        TriggerClientEvent('chatMessage', source, "/"..command, false, agus)
					else
						HDCore.Commands.List[command].callback(source, args)
					end
				else
					TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je hebt geen toegang tot dit commando..")
				end
			end
		end
	end
end)

RegisterNetEvent("DevMode")
AddEventHandler("DevMode", function()
    local src = source
    --TriggerEvent("9bfc3dda2d58f3dd581b9fb0ff967e5e", src, 75)
    TriggerEvent("HD-log:server:CreateLog", "anticheat", "Opening devtools", "orange", "**".. GetPlayerName(src) .. " heeft geprobeert devtools te openen")
    HDCore.Functions.Kick(src, "You don't have permission...", nil, nil)

end)
RegisterServerEvent('HDCore:CallCommand')
AddEventHandler('HDCore:CallCommand', function(command, args)
	if HDCore.Commands.List[command] ~= nil then
		local Player = HDCore.Functions.GetPlayer(tonumber(source))
		if Player ~= nil then
			if (HDCore.Functions.HasPermission(source, "god")) or (HDCore.Functions.HasPermission(source, HDCore.Commands.List[command].permission)) or (HDCore.Commands.List[command].permission == Player.PlayerData.job.name) then
				if (HDCore.Commands.List[command].argsrequired and #HDCore.Commands.List[command].arguments ~= 0 and args[#HDCore.Commands.List[command].arguments] == nil) then
					TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Alle argumenten moeten ingevuld worden!")
					local agus = ""
					for name, help in pairs(HDCore.Commands.List[command].arguments) do
						agus = agus .. " ["..help.name.."]"
					end
					TriggerClientEvent('chatMessage', source, "/"..command, false, agus)
				else
					HDCore.Commands.List[command].callback(source, args)
				end
			else
				TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je hebt geen toegang tot dit commando..")
			end
		end
	end
end)

RegisterServerEvent("HDCore:AddCommand")
AddEventHandler('HDCore:AddCommand', function(name, help, arguments, argsrequired, callback, persmission)
	HDCore.Commands.Add(name, help, arguments, argsrequired, callback, persmission)
end)

RegisterServerEvent("HDCore:ToggleDuty")
AddEventHandler('HDCore:ToggleDuty', function(Value)
	local Player = HDCore.Functions.GetPlayer(source)
	if Value then
		Player.Functions.SetJobDuty(true)
		TriggerClientEvent('HDCore:Notify', source, "Je bent nu in dienst!")
		TriggerClientEvent("HDCore:Client:SetDuty", source, true)
		if Player.PlayerData.job.name == 'police' then
			TriggerEvent("HD-police:server:UpdateCurrentCops")
			TriggerClientEvent('HD-radialmenu:client:update:duty:vehicles', source)
		end
	else
		Player.Functions.SetJobDuty(false)
		TriggerClientEvent('HDCore:Notify', source, "Je bent nu uit dienst!")
		TriggerClientEvent("HDCore:Client:SetDuty", source, false)
		if Player.PlayerData.job.name == 'police' then
			TriggerEvent("HD-police:server:UpdateCurrentCops")
			TriggerClientEvent('HD-radialmenu:client:update:duty:vehicles', source)
		end
 	end
end)

Citizen.CreateThread(function()
	HDCore.Functions.ExecuteSql(true, "SELECT * FROM `server_extra`", function(result)
		if result[1] ~= nil then
		 for k, v in pairs(result) do
		 	HDCore.Config.Server.PermissionList[v.steam] = {
		 		steam = v.steam,
		 		license = v.license,
		 		permission = v.permission,
		 		optin = true,
		 	}
		 end
	  end
	end)
end)

RegisterServerEvent("HDCore:Server:UseItem")
AddEventHandler('HDCore:Server:UseItem', function(item)
	local src = source
	local Player = HDCore.Functions.GetPlayer(src)
	if item ~= nil and item.amount > 0 then
		if HDCore.Functions.CanUseItem(item.name) then
			HDCore.Functions.UseItem(src, item)
		end
	end
end)

RegisterServerEvent("HDCore:Server:RemoveItem")
AddEventHandler('HDCore:Server:RemoveItem', function(itemName, amount, slot)
	local src = source
	local Player = HDCore.Functions.GetPlayer(src)
	Player.Functions.RemoveItem(itemName, amount, slot)
end)

HDCore.Functions.CreateCallback('HDCore:HasItem', function(source, cb, itemName)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player ~= nil then
		if Player.Functions.GetItemByName(itemName) ~= nil then
			cb(true)
		else
			cb(false)
		end
	end
end)	