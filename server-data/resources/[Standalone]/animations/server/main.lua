HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Commands.Add("am", "Toggle animatie menu", {}, false, function(source, args)
	TriggerClientEvent('animations:client:ToggleMenu', source)
end)

HDCore.Commands.Add("a", "Gebruik een animatie, voor animatie lijst doe /em", {{name = "naam", help = "Emote naam"}}, true, function(source, args)
	TriggerClientEvent('animations:client:EmoteCommandStart', source, args)
end)