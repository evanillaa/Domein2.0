HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Commands.Add("jail", "Send a citizen to prison", {{name="id", help="Player ID"}, {name="tijd", help="Time in numbers to serve!"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    local JailPlayer = HDCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "judge" then
        if JailPlayer ~= nil then
         local Time = tonumber(args[2])
         if Time > 0 then
            local Name = JailPlayer.PlayerData.charinfo.firstname..' '..JailPlayer.PlayerData.charinfo.lastname
            if JailPlayer.PlayerData.job.name ~= 'police' and JailPlayer.PlayerData.job.name ~= 'ambulance' then
             JailPlayer.Functions.SetJob("unemployed")
             TriggerClientEvent('HDCore:Notify', JailPlayer.PlayerData.source, "Je baan is op de hoogte gesteld en ze hebben je als werknemer verwijderd.", 'error')
            end
            JailPlayer.Functions.SetMetaData("jailtime", Time)
            TriggerClientEvent('HD-prison:client:set:in:jail', JailPlayer.PlayerData.source, Name, Time, JailPlayer.PlayerData.citizenid, os.date('%d-'..'%m-'..'%y'))
         end
      end
    end
end)

HDCore.Commands.Add("rehab", "Send a citizen to a rehab clinic", {{name="id", help="Player ID"}, {name="tijd", help="Time in numbers to serve!"}}, true, function(source, args)
    local src = source
    local Player = HDCore.Functions.GetPlayer(source)
    
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "judge" or Player.PlayerData.job.name == "ambulance" then
        if args[1] then
            if args[2] == true then
                TriggerClientEvent("beginJailRehab", args[1], true)
            else
                TriggerClientEvent("beginJailRehab", args[1], false)
            end
        else
            TriggerClientEvent('HDCore:Notify', source, 'No player found', 'error')
        end
    end
end)

RegisterServerEvent('HD-prison:server:set:jail:state')
AddEventHandler('HD-prison:server:set:jail:state', function(Time)
 local Player = HDCore.Functions.GetPlayer(source)
 Player.Functions.SetMetaData("jailtime", Time)
 Citizen.SetTimeout(500, function()
    Player.Functions.Save()
 end)
end)

RegisterServerEvent('HD-prison:server:set:jail:leave')
AddEventHandler('HD-prison:server:set:jail:leave', function()
  local Player = HDCore.Functions.GetPlayer(source)
  Player.Functions.SetMetaData("jailtime", 0)
  Citizen.SetTimeout(500, function()
     Player.Functions.Save()
  end)
end)

RegisterServerEvent('HD-prison:server:set:jail:items')
AddEventHandler('HD-prison:server:set:jail:items', function(Time)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    if Player.PlayerData.metadata["jailitems"] == nil or next(Player.PlayerData.metadata["jailitems"]) == nil then 
        Player.Functions.SetMetaData("jailitems", Player.PlayerData.items)
        Player.Functions.ClearInventory()
        Citizen.Wait(1000)
        Player.Functions.AddItem("water", Time)
        Player.Functions.AddItem("sandwich", Time)
    end
end)

RegisterServerEvent('HD-prison:server:get:items:back')
AddEventHandler('HD-prison:server:get:items:back', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    Citizen.Wait(100)
    for k, v in pairs(Player.PlayerData.metadata["jailitems"]) do
        Player.Functions.AddItem(v.name, v.amount, false, v.info)
    end
    Player.Functions.SetMetaData("jailitems", {})
end)

RegisterServerEvent('HD-prison:server:find:reward')
AddEventHandler('HD-prison:server:find:reward', function(reward)
   local Player = HDCore.Functions.GetPlayer(source)
   Player.Functions.AddItem(reward, 1)
   TriggerClientEvent("HD-inventory:client:ItemBox", source, HDCore.Shared.Items[reward], "add")
end)

RegisterServerEvent('HD-prison:server:SecurityLockdown')
AddEventHandler('HD-prison:server:SecurityLockdown', function()
    local src = source
    TriggerClientEvent("HD-prison:client:SetLockDown", -1, true)
    for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                TriggerClientEvent("HD-prison:client:PrisonBreakAlert", v)
            end
        end
	end
end)

RegisterServerEvent('HD-prison:server:set:alarm')
AddEventHandler('HD-prison:server:set:alarm', function(bool)
    TriggerClientEvent('HD-prison:client:set:alarm', -1, bool)
end)

RegisterServerEvent('HD-prison:server:SetGateHit')
AddEventHandler('HD-prison:server:SetGateHit', function(key)
    local src = source
    TriggerClientEvent("HD-prison:client:SetGateHit", -1, key, true)
    if math.random(1, 100) <= 50 then
        for k, v in pairs(HDCore.Functions.GetPlayers()) do
            local Player = HDCore.Functions.GetPlayer(v)
            if Player ~= nil then 
                if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                    TriggerClientEvent("HD-prison:client:PrisonBreakAlert", v)
                end
            end
        end
    end
end)