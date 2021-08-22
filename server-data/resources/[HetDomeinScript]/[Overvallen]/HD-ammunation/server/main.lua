HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

local timeOut = false

local alarmTriggered = false

RegisterServerEvent('HD-ammunation:server:setVitrineState')
AddEventHandler('HD-ammunation:server:setVitrineState', function(stateType, state, k)
    Config.Locations[k][stateType] = state
    TriggerClientEvent('HD-ammunation:client:setVitrineState', -1, stateType, state, k)
end)

RegisterServerEvent('HD-ammunation:server:vitrineReward')
AddEventHandler('HD-ammunation:server:vitrineReward', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local otherchance = math.random(1, 4)
    local odd = math.random(1, 3)

    if otherchance == odd then
        local item = math.random(1, #Config.VitrineRewards)
        local amount = math.random(Config.VitrineRewards[item]["amount"]["min"], Config.VitrineRewards[item]["amount"]["max"])
        if Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, HDCore.Shared.Items[Config.VitrineRewards[item]["item"]], 'add')
        else
            TriggerClientEvent('HDCore:Notify', src, 'Je hebt teveel op zak..', 'error')
        end
    else
        local amount = math.random(2, 4)
        if Player.Functions.AddItem("pistol-ammo", amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, HDCore.Shared.Items["pistol-ammo"], 'add')
        else
            TriggerClientEvent('HDCore:Notify', src, 'Je hebt teveel op zak..', 'error')
        end
    end
end)

RegisterServerEvent('HD-ammunation:server:setTimeout')
AddEventHandler('HD-ammunation:server:setTimeout', function()
    if not timeOut then
        timeOut = true
        TriggerEvent('HD-scoreboard:server:SetActivityBusy', "ammunation", true)
        Citizen.CreateThread(function()
            Citizen.Wait(Config.Timeout)

            for k, v in pairs(Config.Locations) do
                Config.Locations[k]["isOpened"] = false
                TriggerClientEvent('HD-ammunation:client:setVitrineState', -1, 'isOpened', false, k)
                TriggerClientEvent('HD-ammunation:client:setAlertState', -1, false)
                TriggerEvent('HD-scoreboard:server:SetActivityBusy', "ammunation", false)
            end
            timeOut = false
            alarmTriggered = false
        end)
    end
end)

RegisterServerEvent('HD-ammunation:server:PoliceAlertMessage')
AddEventHandler('HD-ammunation:server:PoliceAlertMessage', function(title, coords, blip)
    local src = source
    local alertData = {
        title = title,
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = "Mogelijk overval gaande bij de Ammu Nation<br>Beschikbare camera: Nvt",
    }

    for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                if blip then
                    if not alarmTriggered then
                        TriggerClientEvent("HD-phone:client:addPoliceAlert", v, alertData)
                        TriggerClientEvent("HD-ammunation:client:PoliceAlertMessage", v, title, coords, blip)
                        alarmTriggered = true
                    end
                else
                    TriggerClientEvent("HD-phone:client:addPoliceAlert", v, alertData)
                    TriggerClientEvent("HD-ammunation:client:PoliceAlertMessage", v, title, coords, blip)
                end
            end
        end
    end
end)

HDCore.Functions.CreateCallback('HD-ammunation:server:getCops', function(source, cb)
	local amount = 0
    for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
	end
	cb(amount)
end)