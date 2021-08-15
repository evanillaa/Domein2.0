HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

RegisterServerEvent('HD-assets:server:tackle:player')
AddEventHandler('HD-assets:server:tackle:player', function(playerId)
    TriggerClientEvent("HD-assets:client:get:tackeled", playerId)
end)

RegisterServerEvent('HD-assets:server:display:text')
AddEventHandler('HD-assets:server:display:text', function(Text)
	TriggerClientEvent('HD-assets:client:me:show', -1, Text, source)
end)

-- RegisterServerEvent('HD-assets:server:drop')
-- AddEventHandler('HD-assets:server:drop', function()
-- 	if not HDCore.Functions.HasPermission(source, 'admin') then
-- 		TriggerEvent("HD-logs:server:SendLog", "anticheat", "Nui Devtools", "red", "**".. GetPlayerName(source).. "** Probeerde DevTools te openen.")
-- 		DropPlayer(source, 'DevTools niet openen graag.')
-- 	end
-- end)

HDCore.Commands.Add("id", "Wat is mijn ID?", {}, false, function(source, args)
    TriggerClientEvent('chatMessage', source, "SYSTEEM", "warning", "ID: "..source)
end)
HDCore.Commands.Add("shuffle", "Shuffle seats", {}, false, function(source, args)
 TriggerClientEvent('HD-assets:client:seat:shuffle', source)
end)

HDCore.Commands.Add("me", "Wanneer je iets moet uitvoeren in tekst.", {}, false, function(source, args)
  local Text = table.concat(args, ' ')
  TriggerClientEvent('HD-assets:client:me:show', -1, Text, source)
end)