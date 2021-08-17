HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Commands.Add("jail", "Stop een burger in de cel", {{name="id", help="Speler ID"}, {name="tijd", help="Tijd hoelang hij moet zitten"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    local JailPlayer = HDCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.job.name == "police" then
        if JailPlayer ~= nil then
         local Time = tonumber(args[2])
         if Time > 0 then
            local Name = JailPlayer.PlayerData.charinfo.firstname..' '..JailPlayer.PlayerData.charinfo.lastname
            if JailPlayer.PlayerData.job.name ~= 'police' and JailPlayer.PlayerData.job.name ~= 'ambulance' then
             JailPlayer.Functions.SetJob("unemployed", 1)             
             TriggerClientEvent('HDCore:Notify', JailPlayer.PlayerData.source, "Je bent werkloos..", 'error')
            end
            JailPlayer.Functions.SetMetaData("jailtime", Time)
            TriggerClientEvent('HD-prison:client:set:in:jail', JailPlayer.PlayerData.source, Name, Time, JailPlayer.PlayerData.citizenid, os.date('%d-'..'%m-'..'%y'))
         end
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

RegisterServerEvent('HD-prison:server:set:alarm')
AddEventHandler('HD-prison:server:set:alarm', function(bool)
    TriggerClientEvent('HD-prison:client:set:alarm', -1, bool)
end)