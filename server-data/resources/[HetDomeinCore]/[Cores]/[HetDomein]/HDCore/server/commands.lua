HDCore.Commands = {}
HDCore.Commands.List = {}

HDCore.Commands.Add = function(name, help, arguments, argsrequired, callback, permission) -- [name] = command name (ex. /givemoney), [help] = help text, [arguments] = arguments that need to be passed (ex. {{name="id", help="ID of a player"}, {name="amount", help="amount of money"}}), [argsrequired] = set arguments required (true or false), [callback] = function(source, args) callback, [permission] = rank or job of a player
	HDCore.Commands.List[name:lower()] = {
		name = name:lower(),
		permission = permission ~= nil and permission:lower() or "user",
		help = help,
		arguments = arguments,
		argsrequired = argsrequired,
		callback = callback,
	}
end

HDCore.Commands.Refresh = function(source)
	local Player = HDCore.Functions.GetPlayer(tonumber(source))
	if Player ~= nil then
		for command, info in pairs(HDCore.Commands.List) do
			if HDCore.Functions.HasPermission(source, "god") or HDCore.Functions.HasPermission(source, HDCore.Commands.List[command].permission) then
				TriggerClientEvent('chat:addSuggestion', source, "/"..command, info.help, info.arguments)
			end
		end
	end
end

HDCore.Commands.Add("tp", "Teleport naar een speler of location", {{name="id/x", help="ID van een speler of X positie"}, {name="y", help="Y positie"}, {name="z", help="Z positie"}}, false, function(source, args)
	if (args[1] ~= nil and (args[2] == nil and args[3] == nil)) then
		-- tp to player
		local Player = HDCore.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
			TriggerClientEvent('HDCore:Command:TeleportToPlayer', source, Player.PlayerData.source)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
		end
	else
		-- tp to location
		if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil then
			local x = tonumber(args[1])
			local y = tonumber(args[2])
			local z = tonumber(args[3])
			TriggerClientEvent('HDCore:Command:TeleportToCoords', source, x, y, z)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Niet elk argument is ingevuld (x, y, z)")
		end
	end
end, "admin")

HDCore.Commands.Add("addpermission", "Geef permissie aan iemand (god/admin)", {{name="id", help="ID van de speler"}, {name="permission", help="Permission level"}}, true, function(source, args)
	local Player = HDCore.Functions.GetPlayer(tonumber(args[1]))
	local permission = tostring(args[2]):lower()
	if Player ~= nil then
		HDCore.Functions.AddPermission(Player.PlayerData.source, permission)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")	
	end
end, "admin")

HDCore.Commands.Add("removepermission", "Haal permissie weg van iemand", {{name="id", help="ID van de speler"}}, true, function(source, args)
	local Player = HDCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		HDCore.Functions.RemovePermission(Player.PlayerData.source)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")	
	end
end, "admin")

HDCore.Commands.Add("sv", "Spawn een voertuig", {{name="model", help="Model naam van het voertuig"}}, true, function(source, args)
	TriggerClientEvent('HDCore:Command:SpawnVehicle', source, args[1])
end, "admin")

HDCore.Commands.Add("debug", "Zet debug mode aan/uit", {}, false, function(source, args)
	TriggerClientEvent('koil-debug:toggle', source)
end, "admin")

HDCore.Commands.Add("closenui", "Zet een nui scherm uit", {}, false, function(source, args)
	TriggerClientEvent('HDCore:client:closenui', source)
end)

HDCore.Commands.Add("opennui", "Open een nui scherm", {}, false, function(source, args)
	TriggerClientEvent('HDCore:client:opennui', source)
end)

HDCore.Commands.Add("dv", "Verwijder een voertuig", {}, false, function(source, args)
	TriggerClientEvent('HDCore:Command:DeleteVehicle', source)
end, "admin")

HDCore.Commands.Add("tpm", "Teleport naar een marker", {}, false, function(source, args)
	TriggerClientEvent('HDCore:Command:GoToMarker', source)
end, "admin")

HDCore.Commands.Add("givemoney", "Geef geld aan een speler", {{name="id", help="Speler ID"},{name="moneytype", help="Type geld (cash, bank, crypto)"}, {name="amount", help="Aantal munnies"}}, true, function(source, args)
	local Player = HDCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.AddMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "admin")

HDCore.Commands.Add("setmoney", "Zet het geld voor een speler", {{name="id", help="Speler ID"},{name="moneytype", help="Type geld (cash, bank, crypto)"}, {name="amount", help="Aantal munnies"}}, true, function(source, args)
	local Player = HDCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		Player.Functions.SetMoney(tostring(args[2]), tonumber(args[3]))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "admin")

HDCore.Commands.Add("setjob", "Geef een baan aan een speler", {{name="id", help="Speler ID"}, {name="job", help="Naam van een baan"}, {name="grade", help="level"}}, true, function(source, args)
	local Player = HDCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		if not Player.Functions.SetJob(tostring(args[2]), args[3]) then
			TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Job niet correct!")
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "admin")

HDCore.Commands.Add("baan", "Kijk wat je baan is", {}, false, function(source, args)
	local Player = HDCore.Functions.GetPlayer(source)
	local duty = ""
	if Player.PlayerData.job.onduty then
		duty = "In dienst"
	else
		duty = "Uit dienst"
	end
	
	local grade = (Player.PlayerData.job.grade ~= nil and Player.PlayerData.job.grade.name ~= nil) and Player.PlayerData.job.grade.name or 'No Grades'
	TriggerClientEvent('chat:addMessage', source, {
        template = '<div class="chat-message" style="background-color: rgba(219, 52, 235, 0.75);"><b>Job Information</b> {0} [{1}] | {2}</div>',
    	args = { Player.PlayerData.job.label, duty, grade}
	})
end)

HDCore.Commands.Add("clearinv", "Leeg de inventory van jezelf of een speler", {{name="id", help="Speler ID"}}, false, function(source, args)
	local playerId = args[1] ~= nil and args[1] or source 
	local Player = HDCore.Functions.GetPlayer(tonumber(playerId))
	if Player ~= nil then
		Player.Functions.ClearInventory()
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Speler is niet online!")
	end
end, "admin")

HDCore.Commands.Add("ooc", "Out Of Character chat bericht (alleen gebruiken wanneer nodig)", {}, false, function(source, args)
	local message = table.concat(args, " ")
	TriggerClientEvent("HDCore:Client:LocalOutOfCharacter", -1, source, GetPlayerName(source), message)
	local Players = HDCore.Functions.GetPlayers()

	for k, v in pairs(HDCore.Functions.GetPlayers()) do
		if HDCore.Functions.HasPermission(v, "admin") then
			if HDCore.Functions.IsOptin(v) then
				TriggerClientEvent('chatMessage', v, "OOC | " .. GetPlayerName(source), "normal", message)
			end
		end
	end
end)