HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Commands.Add("nieuwscam", "Grab a news camera", {}, false, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Cam:ToggleCam", source)
    end
end)

HDCore.Commands.Add("nieuwsmic", "Grab a news microphone", {}, false, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Mic:ToggleMic", source)
    end
end)

