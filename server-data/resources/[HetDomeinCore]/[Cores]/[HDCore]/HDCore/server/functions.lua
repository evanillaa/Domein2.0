HDCore.Functions = {}

HDCore.Functions.ExecuteSql = function(wait, query, cb)
	local rtndata = {}
	local waiting = true
	exports['ghmattimysql']:execute(query, {}, function(data)
		if cb ~= nil and wait == false then
			cb(data)
		end
		rtndata = data
		waiting = false
	end)
	if wait then
		while waiting do
			Citizen.Wait(5)
		end
		if cb ~= nil and wait == true then
			cb(rtndata)
		end
	end
	return rtndata
end

HDCore.Functions.GetIdentifier = function(source, idtype)
	local idtype = idtype ~=nil and idtype or Config.IdentifierType
	for _, identifier in pairs(GetPlayerIdentifiers(source)) do
		if string.find(identifier, idtype) then
			return identifier
		end
	end
	return nil
end

HDCore.Functions.GetSource = function(identifier)
	for src, player in pairs(HDCore.Players) do
		local idens = GetPlayerIdentifiers(src)
		for _, id in pairs(idens) do
			if identifier == id then
				return src
			end
		end
	end
	return 0
end

HDCore.Functions.GetPlayer = function(source)
	if type(source) == "number" then
		return HDCore.Players[source]
	else
		return HDCore.Players[HDCore.Functions.GetSource(source)]
	end
end

HDCore.Functions.GetPlayerByCitizenId = function(citizenid)
	for src, player in pairs(HDCore.Players) do
		local cid = citizenid
		if HDCore.Players[src].PlayerData.citizenid == cid then
			return HDCore.Players[src]
		end
	end
	return nil
end

HDCore.Functions.GetPlayerByPhone = function(number)
	for src, player in pairs(HDCore.Players) do
		local cid = citizenid
		if HDCore.Players[src].PlayerData.charinfo.phone == number then
			return HDCore.Players[src]
		end
	end
	return nil
end

HDCore.Functions.GetPlayers = function()
	local sources = {}
	for k, v in pairs(HDCore.Players) do
		table.insert(sources, k)
	end
	return sources
end

HDCore.Functions.CreateCallback = function(name, cb)
	HDCore.ServerCallbacks[name] = cb
end

HDCore.Functions.TriggerCallback = function(name, source, cb, ...)
	if HDCore.ServerCallbacks[name] ~= nil then
		HDCore.ServerCallbacks[name](source, cb, ...)
	end
end

HDCore.Functions.CreateUseableItem = function(item, cb)
	HDCore.UseableItems[item] = cb
end

HDCore.Functions.CanUseItem = function(item)
	return HDCore.UseableItems[item] ~= nil
end

HDCore.Functions.UseItem = function(source, item)
	HDCore.UseableItems[item.name](source, item)
end

HDCore.Functions.Kick = function(source, reason, setKickReason, deferrals)
	local src = source
	reason = "\n"..reason.."\n🔸 Kijk op onze discord voor meer informatie: "..HDCore.Config.Server.discord
	if(setKickReason ~=nil) then
		setKickReason(reason)
	end
	Citizen.CreateThread(function()
		if(deferrals ~= nil)then
			deferrals.update(reason)
			Citizen.Wait(2500)
		end
		if src ~= nil then
			DropPlayer(src, reason)
		end
		local i = 0
		while (i <= 4) do
			i = i + 1
			while true do
				if src ~= nil then
					if(GetPlayerPing(src) >= 0) then
						break
					end
					Citizen.Wait(100)
					Citizen.CreateThread(function() 
						DropPlayer(src, reason)
					end)
				end
			end
			Citizen.Wait(5000)
		end
	end)
end

HDCore.Functions.BanInjection = function(source, script)
	local reason = "[AUTO BAN] Bedankt voor het uittesten van onze anticheat!"
	local banTime = 2147483647
	local timeTable = os.date("*t", banTime)
	TriggerClientEvent('chatMessage', -1, "BANHAMMER", "error", GetPlayerName(source).." is verbannen voor: "..reason.."")
	
	TriggerEvent("HD-log:server:CreateLog", "bans", "Player Banned", "orange", "Speler: "..GetPlayerName(source).." is verbannen voor het gebruiken van ServerTriggerEvents via een externe programma (Resource: "..script..")")

	HDCore.Functions.ExecuteSql(false, "INSERT INTO `bans` (`name`, `steam`, `license`, `discord`,`ip`, `reason`, `expire`) VALUES ('"..GetPlayerName(source).."', '"..GetPlayerIdentifiers(source)[1].."', '"..GetPlayerIdentifiers(source)[2].."', '"..GetPlayerIdentifiers(source)[3].."', '"..GetPlayerIdentifiers(source)[4].."', '"..reason.."', "..banTime..")")
	DropPlayer(source, "Hé jammer joh, je bent verbannen van de server:\n"..reason.."\n\nJe ban verloopt "..timeTable["day"].. "/" .. timeTable["month"] .. "/" .. timeTable["year"] .. " " .. timeTable["hour"].. ":" .. timeTable["min"] .. "\n🔸 Kijk op onze discord voor meer informatie")
	
end
HDCore.Functions.AddPermission = function(source, permission)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		HDCore.Config.Server.PermissionList[GetPlayerIdentifiers(source)[1]] = {
			steam = GetPlayerIdentifiers(source)[1],
			license = GetPlayerIdentifiers(source)[2],
			permission = permission:lower(),
		}
		HDCore.Functions.ExecuteSql(true, "UPDATE `server_extra` SET permission='"..permission:lower().."' WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		Player.Functions.UpdatePlayerData()
	end
end

HDCore.Functions.RemovePermission = function(source)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		HDCore.Config.Server.PermissionList[GetPlayerIdentifiers(source)[1]] = nil
		HDCore.Functions.ExecuteSql(true, "UPDATE `server_extra` SET permission='user' WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
		Player.Functions.UpdatePlayerData()
	end
end

HDCore.Functions.HasPermission = function(source, permission)
	local retval = false
	local steamid = GetPlayerIdentifiers(source)[1]
	local licenseid = GetPlayerIdentifiers(source)[2]
	local permission = tostring(permission:lower())
	if permission == "user" then
		retval = true
	else
		if HDCore.Config.Server.PermissionList[steamid] ~= nil then 
			if HDCore.Config.Server.PermissionList[steamid].steam == steamid and HDCore.Config.Server.PermissionList[steamid].license == licenseid then
				if HDCore.Config.Server.PermissionList[steamid].permission == permission or HDCore.Config.Server.PermissionList[steamid].permission == "god" then
					retval = true
				end
			end
		end
	end
	return retval
end

HDCore.Functions.GetPermission = function(source)
	local retval = "user"
	Player = HDCore.Functions.GetPlayer(source)
	local steamid = GetPlayerIdentifiers(source)[1]
	local licenseid = GetPlayerIdentifiers(source)[2]
	if Player ~= nil then
		if HDCore.Config.Server.PermissionList[Player.PlayerData.steam] ~= nil then 
			if HDCore.Config.Server.PermissionList[Player.PlayerData.steam].steam == steamid and HDCore.Config.Server.PermissionList[Player.PlayerData.steam].license == licenseid then
				retval = HDCore.Config.Server.PermissionList[Player.PlayerData.steam].permission
			end
		end
	end
	return retval
end

HDCore.Functions.IsOptin = function(source)
	local retval = false
	local steamid = GetPlayerIdentifiers(source)[1]
	if HDCore.Functions.HasPermission(source, "admin") then
		retval = HDCore.Config.Server.PermissionList[steamid].optin
	end
	return retval
end

HDCore.Functions.ToggleOptin = function(source)
	local steamid = GetPlayerIdentifiers(source)[1]
	if HDCore.Functions.HasPermission(source, "admin") then
		HDCore.Config.Server.PermissionList[steamid].optin = not HDCore.Config.Server.PermissionList[steamid].optin
	end
end


HDCore.Functions.RefreshPerms = function()
 HDCore.Config.Server.PermissionList = {}
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
end
HDCore.Functions.IsPlayerBanned = function(source)
	local IsBanned = nil
	local Message = nil
	HDCore.Functions.ExecuteSql(true, "SELECT * FROM `server_bans` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."' OR `license` = '"..GetPlayerIdentifiers(source)[2].."'", function(result)
		if result[1] ~= nil then
			Message = "\n🔰 Je bent verbannen van de server. \n🛑 Reden: " ..result[1].reason.. '\n🛑 Verbannen Door: ' ..result[1].bannedby.. '\n\n Voor een unban kan je een ticket openen in de discord.'
			IsBanned = true
		else
			IsBanned = false
		end
	end)
	return IsBanned, Message
end