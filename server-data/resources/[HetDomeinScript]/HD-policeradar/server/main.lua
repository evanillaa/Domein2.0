HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Commands.Add("radar", "Toggle speedradar :)", {}, false, function(source, args)
	local Player = HDCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("wk:toggleRadar", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for emergency only!")
    end
end)