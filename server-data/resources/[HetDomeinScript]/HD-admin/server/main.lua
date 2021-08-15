HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

local permissions = {
    ["kick"] = "admin",
    ["ban"] = "admin",
    ["noclip"] = "admin",
    ["kickall"] = "admin",
    ["devmode"] = "admin",
}

RegisterServerEvent('HD-admin:checkperms')
AddEventHandler('HD-admin:checkperms', function(target)
    local Player = HDCore.Functions.GetPlayer(src)
    local group = HDCore.Functions.GetPermission(source)   
    if group == "admin" or group == 'god' then
        TriggerClientEvent("HD-admin:client:toggleNoclip", source)
    end
end)

RegisterServerEvent('HD-admin:checkperm')
AddEventHandler('HD-admin:checkperm', function(target)
    local Player = HDCore.Functions.GetPlayer(src)
    local group = HDCore.Functions.GetPermission(source)   
    if group == "admin" or group == 'god' then
        TriggerClientEvent('HD-admin:client:openMenu', source, group)
    end
end)

RegisterServerEvent('HD-admin:server:togglePlayerNoclip')
AddEventHandler('HD-admin:server:togglePlayerNoclip', function(playerId, reason)
    local src = source
    if HDCore.Functions.HasPermission(src, permissions["noclip"]) then
        TriggerClientEvent("HD-admin:client:toggleNoclip", playerId)
    end
end)

HDCore.Commands.Add("admincar", "Voertuig toevoegen aan de garage", {}, false, function(source, args)
    local ply = HDCore.Functions.GetPlayer(source)
    TriggerClientEvent('HD-admin:client:SaveCar', source)
end, "admin")

RegisterServerEvent('HD-admin:server:debugtool')
AddEventHandler('HD-admin:server:debugtool', function()
    local src = source
    if HDCore.Functions.HasPermission(src, permissions["devmode"]) then
        TriggerClientEvent('koil-debug:toggle', src)
    end
end)

RegisterServerEvent('HD-admin:server:killPlayer')
AddEventHandler('HD-admin:server:killPlayer', function(playerId)
    TriggerClientEvent('HD-hospital:client:KillPlayer', playerId)
end)

RegisterServerEvent('HD-admin:server:kickPlayer')
AddEventHandler('HD-admin:server:kickPlayer', function(playerId, reason)
    local src = source
    if HDCore.Functions.HasPermission(src, permissions["kick"]) then
        DropPlayer(playerId, "\n🛑 Je bent gekicked uit de server:\n🛑 Reden: "..reason.."\n\n")
    end
end)

RegisterServerEvent('HD-admin:server:Freeze')
AddEventHandler('HD-admin:server:Freeze', function(playerId, toggle)
    TriggerClientEvent('HD-admin:client:Freeze', playerId, toggle)
end)

RegisterServerEvent('HD-admin:server:serverKick')
AddEventHandler('HD-admin:server:serverKick', function(reason)
    local src = source
    if HDCore.Functions.HasPermission(src, permissions["kickall"]) then
        for k, v in pairs(HDCore.Functions.GetPlayers()) do
            if v ~= src then 
                DropPlayer(v, "\n🛑 Je bent gekicked uit de server:\n🛑 Reden: Server Restart..\n\n")
            end
        end
    end
end)

RegisterServerEvent('HD-admin:server:banPlayer')
AddEventHandler('HD-admin:server:banPlayer', function(playerId, Reason)
    local src = source
    if HDCore.Functions.HasPermission(src, permissions["ban"]) then
        TriggerClientEvent('chatMessage', -1, "BANHAMMER", "error", GetPlayerName(playerId).." is verbannen voor: "..Reason)
        HDCore.Functions.ExecuteSql(false, "INSERT INTO `server_bans` (`name`, `steam`, `license`, `reason`, `bannedby`) VALUES ('"..GetPlayerName(playerId).."', '"..GetPlayerIdentifiers(playerId)[1].."', '"..GetPlayerIdentifiers(playerId)[2].."', '"..Reason.."', '"..GetPlayerName(src).."')")
        TriggerEvent("HD-logs:server:SendLog", "bans", "Verbannen", "green", "**Speler:** "..GetPlayerName(playerId).." \n**Reden:** " ..Reason.. "\n**Door:** "..GetPlayerName(src))
        DropPlayer(playerId, "\n🔰 Je bent verbannen van de server. \n🛑 Reden: " ..Reason.. '\n🛑 Verbannen Door: ' ..GetPlayerName(source).. '\n\n Voor een unban kan je een ticket openen in de discord.')
    end      
end)

HDCore.Commands.Add("announce", "Stuur een bericht naar iedereen", {}, false, function(source, args)
    local msg = table.concat(args, " ")
    for i = 1, 3, 1 do
        TriggerClientEvent('chatMessage', -1, "SYSTEM", "error", msg)
    end
end, "admin")

HDCore.Commands.Add("admin", "Open admin menu", {}, false, function(source, args)
    local group = HDCore.Functions.GetPermission(source)
    TriggerClientEvent('HD-admin:client:openMenu', source, group)
end, "admin")

HDCore.Commands.Add("report", "Stuur een report naar admins", {{name="bericht", help="Bericht die je wilt sturen"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    local Player = HDCore.Functions.GetPlayer(source)
    TriggerClientEvent('HD-admin:client:SendReport', -1, GetPlayerName(source), source, msg)
    TriggerClientEvent('chatMessage', source, "REPORT VERSTUURD", "normal", msg)
    TriggerEvent("ec-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {message=msg})
end)

HDCore.Commands.Add("s", "Bericht naar alle staff sturen", {{name="bericht", help="Bericht die je wilt sturen"}}, true, function(source, args)
    local msg = table.concat(args, " ")

    TriggerClientEvent('HD-admin:client:SendStaffChat', -1, GetPlayerName(source), msg)
end, "admin")

HDCore.Commands.Add("reportr", "Reply op een report", {}, false, function(source, args)
    local playerId = tonumber(args[1])
    table.remove(args, 1)
    local msg = table.concat(args, " ")
    local OtherPlayer = HDCore.Functions.GetPlayer(playerId)
    local Player = HDCore.Functions.GetPlayer(source)
    if OtherPlayer ~= nil then
        TriggerClientEvent('chatMessage', playerId, "ADMIN - "..GetPlayerName(source), "reportr", msg)
        TriggerClientEvent('HDCore:Notify', source, "Reactie gestuurd")
        TriggerEvent("ec-log:server:sendLog", Player.PlayerData.citizenid, "reportreply", {otherCitizenId=OtherPlayer.PlayerData.citizenid, message=msg})
        for k, v in pairs(HDCore.Functions.GetPlayers()) do
            if HDCore.Functions.HasPermission(v, "admin") then
                if HDCore.Functions.IsOptin(v) then
                    TriggerClientEvent('chatMessage', v, "ReportReply("..source..") - "..GetPlayerName(source), "reportr", msg)
                end
            end
        end
    else
        TriggerClientEvent('HDCore:Notify', source, "Persoon is niet online", "error")
    end
end, "admin")

HDCore.Commands.Add("reporttoggle", "Toggle inkomende reports uit of aan", {}, false, function(source, args)
    HDCore.Functions.ToggleOptin(source)
    if HDCore.Functions.IsOptin(source) then
        TriggerClientEvent('HDCore:Notify', source, "Je krijgt WEL reports", "success")
    else
        TriggerClientEvent('HDCore:Notify', source, "Je krijgt GEEN reports", "error")
    end
end, "admin")

HDCore.Commands.Add("unban", "Unban een speler", {{name="Naam", help="Steam naam van de speler"}}, true, function(source, args)
    local src = source
    local Bericht = table.concat(args, " ")
    if Bericht ~= nil then
    HDCore.Functions.ExecuteSql(true, "SELECT * FROM `server_bans` WHERE `name` = '"..Bericht.."'", function(result)
        if result[1] ~= nil then 
            HDCore.Functions.ExecuteSql(true, "DELETE FROM `server_bans` WHERE `name` = '"..Bericht.."'")
            TriggerClientEvent('chat:addMessage', src, {
                template = '<div class="chat-message error"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Speler:</strong> {1} <br><strong>Status:</strong> {2} <br><strong>Unbanned Door:</strong> {3} </div></div>',
                args = {'Unban Informatie', args, 'Speler zijn verbanning is ingetrokken', GetPlayerName(src)}
            })
            TriggerEvent("HD-logs:server:SendLog", "bans", "Unban", "red", "**Speler:** "..Bericht.." \n**Status:** Unbanned. \n**Door:** "..GetPlayerName(src))
        else
        TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Geen bans gevonden op deze naam')
        end
    end)
    else 
    TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Geef een naam op..')
    end
end, "admin")

HDCore.Commands.Add("baninfo", "Verkrijg de ban informatie van een speler", {{name="Naam", help="Steam naam van de speler"}}, true, function(source, args)
    local src = source
    local Bericht = table.concat(args, " ")
    if Bericht ~= nil then
        HDCore.Functions.ExecuteSql(true, "SELECT * FROM `server_bans` WHERE `name` = '"..Bericht.."'", function(result)
            if result[1] ~= nil then 
                local Info = result[1].reason
                local bannedby = result[1].bannedby
                TriggerClientEvent('chat:addMessage', src, {
                    template = '<div class="chat-message error"><div class="chat-message-body"><strong>{0}:</strong><br><br> <strong>Speler:</strong> {1} <br><strong>Ban Reden:</strong> {2} <br><strong>Verbannen Door:</strong> {3} <br><strong>Notitie:</strong> {4} </div></div>',
                    args = {'Ban Informatie', args, Info, bannedby, '/unban ' ..Bericht.. ' | Als u deze speler wilt unbannen'}
                })
            else
            TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Geen bans gevonden op deze naam')
            end
        end)
    else 
    TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Geef een naam op..')
    end
end, "admin")

RegisterCommand("kickall", function(source, args, rawCommand)
    local src = source
    if src > 0 then
        local reason = table.concat(args, ' ')
        local Player = HDCore.Functions.GetPlayer(src)
        if HDCore.Functions.HasPermission(src, "god") then
            if args[1] ~= nil then
                for k, v in pairs(HDCore.Functions.GetPlayers()) do
                    local Player = HDCore.Functions.GetPlayer(v)
                    if Player ~= nil then 
                        DropPlayer(Player.PlayerData.source, reason)
                    end
                end
            else
                TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Geef een reden op..')
            end
        else
            TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Dit kan jij niet zomaar doen kindje..')
        end
    else
        for k, v in pairs(HDCore.Functions.GetPlayers()) do
            local Player = HDCore.Functions.GetPlayer(v)
            if Player ~= nil then 
                DropPlayer(Player.PlayerData.source, "Server restart, kijk op discord voor meer informatie! (https://discord.gg/KTgCgPSXs9)")
            end
        end
    end
end, false)

RegisterServerEvent('HD-admin:server:bringTp')
AddEventHandler('HD-admin:server:bringTp', function(targetId, coords)
    TriggerClientEvent('HD-admin:client:bringTp', targetId, coords)
end)

HDCore.Functions.CreateCallback('HD-admin:server:hasPermissions', function(source, cb, group)
    local src = source
    local retval = false
    if HDCore.Functions.HasPermission(src, group) then
        retval = true
    end
    cb(retval)
end)

RegisterServerEvent('HD-admin:server:setPermissions')
AddEventHandler('HD-admin:server:setPermissions', function(targetId, group)
    HDCore.Functions.AddPermission(targetId, group.rank)
    TriggerClientEvent('HDCore:Notify', targetId, 'Je permissie groep is gezet naar '..group.label)
end)

RegisterServerEvent('HD-admin:server:OpenSkinMenu')
AddEventHandler('HD-admin:server:OpenSkinMenu', function(targetId)
    TriggerClientEvent("HD-clothing:client:openMenu", targetId)
end)

RegisterServerEvent('HD-admin:server:SendReport')
AddEventHandler('HD-admin:server:SendReport', function(name, targetSrc, msg)
    local src = source
    local Players = HDCore.Functions.GetPlayers()

    if HDCore.Functions.HasPermission(src, "admin") then
        if HDCore.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "REPORT - "..name.." ("..targetSrc..")", "report", msg)
        end
    end
end)

RegisterServerEvent('HD-admin:server:StaffChatMessage')
AddEventHandler('HD-admin:server:StaffChatMessage', function(name, msg)
    local src = source
    local Players = HDCore.Functions.GetPlayers()

    if HDCore.Functions.HasPermission(src, "admin") then
        if HDCore.Functions.IsOptin(src) then
            TriggerClientEvent('chatMessage', src, "STAFFCHAT - "..name, "error", msg)
        end
    end
end)

RegisterServerEvent('HD-admin:server:crash')
AddEventHandler('HD-admin:server:crash', function(id)
    TriggerClientEvent("HD-admin:client:crash", id)
end)