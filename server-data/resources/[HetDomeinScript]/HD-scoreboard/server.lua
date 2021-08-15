HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Functions.CreateCallback('HD-scoreboard:server:GetActiveCops', function(source, cb)
    local retval = 0
    
    for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                retval = retval + 1
            end
        end
    end

    cb(retval)
end)

HDCore.Functions.CreateCallback('HD-scoreboard:server:GetConfig', function(source, cb)
    cb(Config.IllegalActions)
end)

RegisterServerEvent('HD-scoreboard:server:SetActivityBusy')
AddEventHandler('HD-scoreboard:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('HD-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)