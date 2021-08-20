HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Functions.CreateCallback("HD-houseplants:server:get:config", function(source, cb)
    cb(Config)
end)

Citizen.CreateThread(function()
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houseplants`", function(result)
        for k, v in pairs(result) do
            Config.Plants[v.houseid] = json.decode(v.plants)
            TriggerClientEvent('HD-houseplants:client:sync:plant:data', -1, Config.Plants)
        end
    end)
end)

RegisterServerEvent('HD-houseplants:server:destroy:plant')
AddEventHandler('HD-houseplants:server:destroy:plant', function(HouseId, RemoveId, IsDead)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houseplants` WHERE `houseid` = '"..HouseId.."'", function(result)
        local PlantData = json.decode(result[1].plants)
        local NewPlants = {}
        for k, v in pairs(PlantData) do
            if k ~= RemoveId then
              table.insert(NewPlants, v)
            end
        end
        HDCore.Functions.ExecuteSql(false, "UPDATE `player_houseplants` SET `plants` = '"..json.encode(NewPlants).."' WHERE `houseid` = '"..HouseId.."'")
        RefreshPlants(HouseId)
        if IsDead then
            Player.Functions.AddItem('wet-tak', math.random(1, 3))
            TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['wet-tak'], "add")
        end
    end)
end)

RegisterServerEvent('HD-houseplants:server:add:plant')
AddEventHandler('HD-houseplants:server:add:plant', function(HouseId, NewPlant)
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houseplants` WHERE `houseid` = '"..HouseId.."'", function(result)
        if result[1] ~= nil then
            Config.Plants[HouseId] = NewPlant
            SaveCurrentHousePlants(HouseId)
        else
            HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_houseplants` (`houseid`, `plants`) VALUES ('"..HouseId.."', '"..json.encode(NewPlant).."')")
            Citizen.SetTimeout(150, function()
                RefreshPlants(HouseId)
            end)
        end
    end)
end)

RegisterServerEvent('HD-houseplants:server:feed:plant')
AddEventHandler('HD-houseplants:server:feed:plant', function(HouseId, PlantId)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    if Config.Plants[HouseId] ~= nil then
       if Config.Plants[HouseId][PlantId]['Food'] < 100 then
            local RandomPlusAmouont = math.random(15, 25)
            if Config.Plants[HouseId][PlantId]['Food'] + RandomPlusAmouont < 100 then
                Config.Plants[HouseId][PlantId]['Food'] = Config.Plants[HouseId][PlantId]['Food'] + RandomPlusAmouont
                SaveCurrentHousePlants(HouseId)
            else
                Config.Plants[HouseId][PlantId]['Food'] = 100
                SaveCurrentHousePlants(HouseId)
            end
            TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['weed-nutrition'], "remove")
            Player.Functions.RemoveItem('weed-nutrition', 1)
       end
    end
end)

RegisterServerEvent('HD-houseplants:server:harvest:plant')
AddEventHandler('HD-houseplants:server:harvest:plant', function(HouseId, PlantId, Amount)
   local src = source
   local Player = HDCore.Functions.GetPlayer(src)
   local curRep = Player.PlayerData.metadata["dealerrep"]
   local RandomWeedAmount = math.random(4, 8)
   local PlasticBag = Player.Functions.GetItemByName('plastic-bag')
   if Config.Plants[HouseId] ~= nil then
        if PlasticBag.amount >= RandomWeedAmount then
            Player.Functions.RemoveItem('plastic-bag', RandomWeedAmount)
            if Config.Plants[HouseId][PlantId]['Sort'] == 'White-Widow' then
                Player.Functions.AddItem('weed_white-widow', RandomWeedAmount)
                TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['weed_white-widow'], "add")
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('skunk-seed', Amount)
                end
            elseif Config.Plants[HouseId][PlantId]['Sort'] == 'Skunk' then
                Player.Functions.AddItem('weed_skunk', RandomWeedAmount)
                TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['weed_skunk'], "add")
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('purple-haze-seed', Amount)
                end
            elseif Config.Plants[HouseId][PlantId]['Sort'] == 'Purple-Haze' then
                Player.Functions.AddItem('weed_purple-haze', RandomWeedAmount)
                TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['weed_purple-haze'], "add")
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('og-kush-seed', Amount)
                end
            elseif Config.Plants[HouseId][PlantId]['Sort'] == 'Og-Kush' then
                Player.Functions.AddItem('weed_og-kush', RandomWeedAmount)
                TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['weed_og-kush'], "add")
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('amnesia-seed', Amount)
                end
            elseif Config.Plants[HouseId][PlantId]['Sort'] == 'Amnesia' then
                Player.Functions.AddItem('weed_amnesia', RandomWeedAmount)
                TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['weed_amnesia'], "add")
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('ak47-seed', Amount)
                end
            elseif Config.Plants[HouseId][PlantId]['Sort'] == 'AK47' then
                Player.Functions.AddItem('weed_ak47', RandomWeedAmount)
                TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items['weed_ak47'], "add")
                if math.random(1,5) <= 2 and Config.Plants[HouseId][PlantId]['Gender'] == 'Man' then
                    Player.Functions.AddItem('ak47-seed', Amount)
                end
            end
            
            Player.Functions.SetMetaData('dealerrep', (curRep + 3))
            TriggerEvent('HD-houseplants:server:destroy:plant', HouseId, PlantId, false)
        else
            TriggerClientEvent('HDCore:Notify', src, 'Not enough bags', 'error', 3500)
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.SetTimeout(750, function()
        while true do
            local RandomValue = math.random(1, 3)
            for k, v in pairs(Config.Plants) do
                for weed, plant in pairs(v) do
                    if plant['Food'] > 0 and plant['Food'] - RandomValue > 0 then
                        plant['Food'] = plant['Food'] - RandomValue
                    else
                        plant['Food'] = 0
                    end
                    if plant['Food'] < 50 then
                        if plant['Health'] > 0 then
                            plant['Health'] = plant['Health'] - 5
                        else
                            plant['Health'] = 0
                        end
                    elseif plant['Food'] > 50 then
                        if plant['Health'] < 100 and plant['Health'] ~= 0 then
                            plant['Health'] = plant['Health'] + 5
                        else
                            plant['Health'] = 100
                        end
                    end
                    if plant['Health'] > 0 then
                        if plant['Progress'] < 100 then
                            local RandomGrowth = math.random(1, 3)
                            plant['Progress'] = plant['Progress'] + RandomGrowth
                            if plant['Progress'] >= 10 and plant['Progress'] < 20 then
                                plant['Stage'] = 'Stage-B'
                            elseif plant['Progress'] >= 20 and plant['Progress'] < 30 then
                                plant['Stage'] = 'Stage-C'
                            elseif plant['Progress'] >= 30 and plant['Progress'] < 40 then
                                plant['Stage'] = 'Stage-D'
                            elseif plant['Progress'] >= 40 and plant['Progress'] < 65 then
                                plant['Stage'] = 'Stage-E'
                            elseif plant['Progress'] >= 65 and plant['Progress'] < 70 then
                                plant['Stage'] = 'Stage-F'
                            elseif plant['Progress'] >= 70 and plant['Progress'] < 100 then
                                plant['Stage'] = 'Stage-G'
                            end
                        end
                    end
                end
            end
            SaveAllPlants()
            Citizen.Wait(14 * (60 * 1000))
        end
    end)
end)

function SaveCurrentHousePlants(HouseId)
    HDCore.Functions.ExecuteSql(false, "UPDATE `player_houseplants` SET `plants` = '"..json.encode(Config.Plants[HouseId]).."' WHERE `houseid` = '"..HouseId.."'")
    Citizen.SetTimeout(150, function()
        RefreshPlants(HouseId)
    end)
end

function SaveAllPlants()
    for k, v in pairs(Config.Plants) do
        HDCore.Functions.ExecuteSql(false, "UPDATE `player_houseplants` SET `plants` = '"..json.encode(Config.Plants[k]).."' WHERE `houseid` = '"..k.."'")
        Citizen.SetTimeout(150, function()
            RefreshPlants(k)
        end)
    end
end

function RefreshPlants(HouseId)
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houseplants` WHERE `houseid` = '"..HouseId.."'", function(result)
        Config.Plants[HouseId] = json.decode(result[1].plants)
        TriggerClientEvent('HD-houseplants:client:sync:plant:data', -1, Config.Plants)
        TriggerClientEvent('HD-houseplants:client:sync:plants', -1, HouseId)
    end)
end