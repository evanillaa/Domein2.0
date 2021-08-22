HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Functions.CreateCallback('HD-banktruck:server:GetConfig', function(source, cb)
    cb(Config)
end)

HDCore.Functions.CreateCallback('HD-banktruck:server:HasItem', function(source, cb, itemName)
    local Player = HDCore.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName(itemName)
	if Player ~= nil then
        if Item ~= nil then
			cb(true)
        else
			cb(false)
        end
	end
end)

RegisterServerEvent('HD-banktruck:server:OpenTruck')
AddEventHandler('HD-banktruck:server:OpenTruck', function(Veh) 
    TriggerClientEvent('HD-banktruck:client:OpenTruck', source, Veh)
end)

RegisterServerEvent('HD-banktruck:server:updateplates')
AddEventHandler('HD-banktruck:server:updateplates', function(Plate)
 Config.RobbedPlates[Plate] = true
 TriggerClientEvent('HD-banktruck:plate:table', -1, Plate)
end)

RegisterServerEvent('HD-banktruck:sever:send:cop:alert')
AddEventHandler('HD-banktruck:sever:send:cop:alert', function(coords, veh, plate)
    local msg = "Er wordt een geld wagen overvallen.<br>"..plate
    local alertData = {
        title = "Geld Wagen Alarm",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg,
    }
    TriggerClientEvent("HD-banktruck:client:send:cop:alert", -1, coords, veh, plate)
    TriggerClientEvent("HD-phone:client:addPoliceAlert", -1, alertData)
end)

RegisterServerEvent('HD-bankrob:server:remove:card')
AddEventHandler('HD-bankrob:server:remove:card', function()
local Player = HDCore.Functions.GetPlayer(source)
 Player.Functions.RemoveItem('green-card', 1)
 TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['green-card'], "remove")
end)

RegisterServerEvent('blijf:uit:mijn:scripts:rewards')
AddEventHandler('blijf:uit:mijn:scripts:rewards', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local RandomWaarde = math.random(1,100)
    if RandomWaarde >= 1 and RandomWaarde <= 30 then
    local info = {worth = math.random(7500, 12500)}
    Player.Functions.AddItem('markedbills', 1, false, info)
    TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['markedbills'], "add")
    TriggerEvent("HD-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Speler:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Gekregen: **Marked Bills\n**Waarde: **"..info.worth)
    elseif RandomWaarde >= 31 and RandomWaarde <= 50 then
        local AmountGoldStuff = math.random(6,25)
        Player.Functions.AddItem('gold-rolex', AmountGoldStuff)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['gold-rolex'], "add")
    elseif RandomWaarde >= 51 and RandomWaarde <= 80 then 
        local AmountGoldStuff = math.random(6,25)
        Player.Functions.AddItem('gold-necklace', AmountGoldStuff)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['gold-necklace'], "add")
        TriggerEvent("HD-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Speler:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Gekregen: **Gouden Ketting\n**Aantal: **"..AmountGoldStuff)
    elseif RandomWaarde == 91 or RandomWaarde == 98 or RandomWaarde == 85 or RandomWaarde == 65 then
        local RandomAmount = math.random(2,6)
        Player.Functions.AddItem('gold-bar', RandomAmount)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['gold-bar'], "add") 
        TriggerEvent("HD-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Speler:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Gekregen: **Goud Staaf\n**Aantal: **"..RandomAmount)
    elseif RandomWaarde == 26 or RandomWaarde == 52 then 
        Player.Functions.AddItem('yellow-card', 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['yellow-card'], "add") 
        TriggerEvent("HD-log:server:CreateLog", "banktruck", "Banktruck Rewards", "green", "**Speler:** "..GetPlayerName(src).." (citizenid: *"..Player.PlayerData.citizenid.."*)\n**Gekregen: **Gele Kaart\n**Aantal:** 1x")
    end
end)

HDCore.Functions.CreateUseableItem("green-card", function(source, item)
    TriggerClientEvent("HD-truckrob:client:UseCard", source)
end)