HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

RegisterServerEvent('HD-appartments:server:set:appartment:data')
AddEventHandler('HD-appartments:server:set:appartment:data', function(AppartmentName)
local Player = HDCore.Functions.GetPlayer(source)
local NewAppartmentData = {Id = Player.PlayerData.metadata['appartment-data'].Id, Name = AppartmentName}
    Player.Functions.SetMetaData("appartment-data", NewAppartmentData)
    TriggerClientEvent('HD-appartments:client:enter:appartment', source, true, AppartmentName)
end)

RegisterServerEvent('HD-appartments:server:logout')
AddEventHandler('HD-appartments:server:logout', function()
 local src = source
 local Player = HDCore.Functions.GetPlayer(src)
 local PlayerItems = Player.PlayerData.items
 TriggerClientEvent('HD-radio:onRadioDrop', src)
 if PlayerItems ~= nil then
    HDCore.Functions.ExecuteSql(true, "UPDATE `player_metadata` SET `inventory` = '"..HDCore.EscapeSqli(json.encode(PlayerItems)).."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
 else
    HDCore.Functions.ExecuteSql(true, "UPDATE `player_metadata` SET `inventory` = '{}' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
 end
 HDCore.Player.Logout(src)
 Citizen.Wait(450)
 TriggerClientEvent('HD-multichar:client:open:select', src)
end)

function GetAppartmentName(AppartmentId)
    return Config.Locations[AppartmentId]['Label']
end

HDCore.Commands.Add("searchproperty", "Open appartement stash", {{name="id", help="Appartment ID"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    local AppartementID = args[1]
    if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'judge' and Player.PlayerData.metadata['ishighcommand'] then
        TriggerClientEvent('HD-appartments:client:open:appartment:stash', source, AppartementID)
    end
end)