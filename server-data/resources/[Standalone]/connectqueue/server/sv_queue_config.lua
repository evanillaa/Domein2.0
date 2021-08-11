Config = {}

HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

Config.Priority = {}

Config.RequireSteam = true

Config.PriorityOnly = false

Config.DisableHardCap = true

Config.ConnectTimeOut = 600

Config.QueueTimeOut = 90

Config.EnableGrace = true

Config.GracePower = 2

Config.GraceTime = 120

Config.JoinDelay = 30000

Config.ShowTemp = false

Config.Language = {
    joining = "\xF0\x9F\x8E\x89Inladen..",
    connecting = "\xE2\x8F\xB3Verbinden...",
    idrr = "\xE2\x9D\x97[Queue] Error: Kan geen id's ophalen, probeer opnieuw op te starten.",
    err = "\xE2\x9D\x97[Queue] Er was een error",
    pos = "\xF0\x9F\x90\x8CJe staat %d/%d in de wachtrij \xF0\x9F\x95\x9C%s",
    connectingerr = "\xE2\x9D\x97[Queue] Error: Kan niet toevoegen aan de wachtrij.",
    timedout = "\xE2\x9D\x97[Queue] Error: Timed out",
    wlonly = "\xE2\x9D\x97[Queue] Je moet een whitelist hebben om de server te joinen.",
    steam = "\xE2\x9D\x97 [Queue] Error: Steam moet aan staan."
}

Citizen.CreateThread(function()
	LoadQueueDatabase()
end)

function LoadQueueDatabase()
	HDCore.Functions.ExecuteSql(false, "SELECT * FROM `server_extra`", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				Config.Priority[v.steam] = tonumber(v.priority)
			end
		end
	end)
end

HDCore.Commands.Add("reloadprioriteit", "Herlaad de wachtrij", {}, false, function(source, args)
	LoadQueueDatabase()
	TriggerClientEvent('HDCore:Notify', Player.PlayerData.source, "De wachtrij is ververst..", "success")	
end, "god")

HDCore.Commands.Add("geefprioriteit", "Geef wachtrij prioriteit", {{name="id", help="ID van de burger"}, {name="priority", help="Prioriteit level"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(tonumber(args[1]))
	local level = tonumber(args[2])
	if Player ~= nil then
		AddPriority(Player.PlayerData.source, level)
		TriggerClientEvent('HDCore:Notify', Player.PlayerData.source, "Je wachtrij prioriteit is aangepast.", "success")
        TriggerClientEvent('chatMessage', source, "SYSTEM", "normal", "Je hebt " .. GetPlayerName(Player.PlayerData.source) .. " prioriteit gegeven ("..level..")")	
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Burger is niet online!")	
	end
end, "god")

HDCore.Commands.Add("verwijderprioriteit", "Haal prioriteit weg van iemand", {{name="id", help="ID van de burger"}}, true, function(source, args)
	local Player = HDCore.Functions.GetPlayer(tonumber(args[1]))
	if Player ~= nil then
		RemovePriority(Player.PlayerData.source)
		TriggerClientEvent('HDCore:Notify', Player.PlayerData.source, "Je wachtrij prioriteit is verwijderd.", "error")
        TriggerClientEvent('chatMessage', source, "SYSTEM", "normal", "Je hebt prioriteit weggehaald bij " .. GetPlayerName(Player.PlayerData.source))	
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Burger is niet online!")	
	end
end, "god")

function AddPriority(source, level)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		Config.Priority[GetPlayerIdentifiers(source)[1]] = level
		HDCore.Functions.ExecuteSql(true, "INSERT INTO `server_extra` (`name`, `steam`, `license`, `priority`, `permission`) VALUES ('"..GetPlayerName(source).."', '"..GetPlayerIdentifiers(source)[1].."', '"..GetPlayerIdentifiers(source)[2].."', '"..level.."'), '"..HDCore.Functions.GetPermission(source).."'")
		Player.Functions.UpdatePlayerData()
	end
end

function RemovePriority(source)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player ~= nil then 
		Config.Priority[GetPlayerIdentifiers(source)[1]] = nil
		HDCore.Functions.ExecuteSql(true, "DELETE FROM `server_extra` WHERE `steam` = '"..GetPlayerIdentifiers(source)[1].."'")
	end
end