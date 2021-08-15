HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

RegisterServerEvent('HD-cityhall:server:requestId')
AddEventHandler('HD-cityhall:server:requestId', function(identityData)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local licenses = {
        ["driver"] = true,
    }
    local info = {}
    if identityData.item == "id-card" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
    elseif identityData.item == "drive-card" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = "A1-A2-A | AM-B | C1-C-CE"
    end
    Player.Functions.AddItem(identityData.item, 1, false, info)
    TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[identityData.item], 'add')
end)

RegisterServerEvent('HD-cityhall:server:ApplyJob')
AddEventHandler('HD-cityhall:server:ApplyJob', function(job)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local JobInfo = HDCore.Shared.Jobs[job]

    Player.Functions.SetJob(job, 0)

    --TriggerClientEvent('HDCore:Notify', src, 'Gefeliciteerd met je nieuwe baan! ('..JobInfo.label..')')
    TriggerClientEvent('HDCore:Notify', source, 'Gefeliciteerd met je nieuwe baan! ('..JobInfo.label..')')
end)