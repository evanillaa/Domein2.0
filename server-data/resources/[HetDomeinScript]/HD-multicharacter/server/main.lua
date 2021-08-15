HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Commands.Add("logout", "Ga naar het karakter menu.", {}, false, function(source, args)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    HDCore.Player.Logout(src)
    Citizen.Wait(650)
    TriggerClientEvent('HD-multicharacter:client:chooseChar', src)
end, "admin")

RegisterServerEvent('HD-multicharacter:server:loadUserData')
AddEventHandler('HD-multicharacter:server:loadUserData', function(cData)
    local src = source
    if HDCore.Player.Login(src, false, cData.citizenid) then
        print('^2[HDCore]^7 '..GetPlayerName(src)..' (Citizen ID: '..cData.citizenid..') has succesfully loaded!')
        HDCore.Commands.Refresh(src)
       TriggerClientEvent('HD-spawn:client:choose:spawn', src)
        TriggerEvent("HD-logs:server:SendLog", "joinleave", "Loaded", "green", "**".. GetPlayerName(src) .. "** ("..cData.citizenid.." | "..src..") loaded..")
	end
end)

RegisterServerEvent('HD-multicharacter:server:createCharacter')
AddEventHandler('HD-multicharacter:server:createCharacter', function(data)
    local src = source
    local newData = {firstname = data.firstname, lastname = data.lastname, birthdate = data.birthdate, nationality = data.nationality, gender = data.gender, cid = data.cid}
    if HDCore.Player.Login(src, true, false, newData) then
        print('^2[HDCore]^7 '..GetPlayerName(src)..' has succesfully created their char!')
        HDCore.Commands.Refresh(src)
        GiveStarterItems(src)
        TriggerClientEvent('HD-spawn:client:choose:appartment', src)
        TriggerClientEvent("HD-multicharacter:client:closeNUI", src)
	end
end)

RegisterServerEvent('HD-multicharacter:server:deleteCharacter')
AddEventHandler('HD-multicharacter:server:deleteCharacter', function(citizenid)
    local Player = HDCore.Functions.GetPlayer(source)
    HDCore.Player.DeleteCharacter(source, citizenid)
end)

HDCore.Functions.CreateCallback("HD-multicharacter:server:get:char:data", function(source, cb)
    local steamId = GetPlayerIdentifiers(source)[1]
    local plyChars = {}
    exports['ghmattimysql']:execute('SELECT * FROM player_metadata WHERE steam = @steam', {['@steam'] = steamId}, function(result)
        for i = 1, (#result), 1 do
            result[i].charinfo = json.decode(result[i].charinfo)
            result[i].money = json.decode(result[i].money)
            result[i].job = json.decode(result[i].job)
            table.insert(plyChars, result[i])
        end
        cb(plyChars)
    end)
end)

HDCore.Functions.CreateCallback("HD-multicharacter:server:getSkin", function(source, cb, cid)
    local src = source
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_skins` WHERE `citizenid` = '"..cid.."'", function(result)
        if result[1] ~= nil then
            cb(result[1].model, result[1].skin)
        else
            cb(nil)
        end
    end)
end)

function GiveStarterItems(source)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    for k, v in pairs(HDCore.Shared.StarterItems) do
        local info = {}
        if v.item == "id-card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "drive-card" then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = "A1-A2-A | AM-B | C1-C-CE"
        end
        Player.Functions.AddItem(v.item, v.amount, false, info)
    end
end