RegisterServerEvent('HD-drugs:server:updateDealerItems')
AddEventHandler('HD-drugs:server:updateDealerItems', function(itemData, amount, dealer)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    if Config.Dealers[dealer]["products"][itemData.slot].amount - 1 >= 0 then
        Config.Dealers[dealer]["products"][itemData.slot].amount = Config.Dealers[dealer]["products"][itemData.slot].amount - amount
        TriggerClientEvent('HD-drugs:client:setDealerItems', -1, itemData, amount, dealer)
    else
        Player.Functions.RemoveItem(itemData.name, amount)
        Player.Functions.AddMoney('cash', amount * Config.Dealers[dealer]["products"][itemData.slot].price)

        TriggerClientEvent("HDCore:Notify", _src, "Dit item is niet meer beschikbaar.. Je hebt je geld terug ontvangen.", "error")
    end
end)

RegisterServerEvent('HD-drugs:server:giveDeliveryItems')
AddEventHandler('HD-drugs:server:giveDeliveryItems', function(amount)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    Player.Functions.AddItem('weed_brick', amount)
    TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items["weed_brick"], "add")
end)

HDCore.Functions.CreateCallback('HD-drugs:server:RequestConfig', function(source, cb)
    cb(Config.Dealers)
end)

RegisterServerEvent('HD-drugs:server:succesDelivery')
AddEventHandler('HD-drugs:server:succesDelivery', function(deliveryData, inTime)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local curRep = Player.PlayerData.metadata["dealerrep"]

    if inTime then
        if Player.Functions.GetItemByName('weed_brick') ~= nil and Player.Functions.GetItemByName('weed_brick').amount >= deliveryData["amount"] then
            Player.Functions.RemoveItem('weed_brick', deliveryData["amount"])
            local cops = GetCurrentCops()
            local price = 3000
            if cops == 1 then
                price = 4000
            elseif cops == 2 then
                price = 5000
            elseif cops >= 3 then
                price = 6000
            end
            if curRep < 10 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 8), "dilvery-drugs")
            elseif curRep >= 10 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 10), "dilvery-drugs")
            elseif curRep >= 20 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 12), "dilvery-drugs")
            elseif curRep >= 30 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 15), "dilvery-drugs")
            elseif curRep >= 40 then
                Player.Functions.AddMoney('cash', (deliveryData["amount"] * price / 100 * 18), "dilvery-drugs")
            end

            TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items["weed_brick"], "remove")
            TriggerClientEvent('HDCore:Notify', src, 'De bestelling is compleet afgeleverd', 'success')

            SetTimeout(math.random(5000, 10000), function()
                TriggerClientEvent('HD-drugs:client:sendDeliveryMail', src, 'perfect', deliveryData)

                Player.Functions.SetMetaData('dealerrep', (curRep + 1))
            end)
        else
            TriggerClientEvent('HDCore:Notify', src, 'Dit voldoet niet aan de bestelling...', 'error')

            if Player.Functions.GetItemByName('weed_brick').amount >= 0 then
                Player.Functions.RemoveItem('weed_brick', Player.Functions.GetItemByName('weed_brick').amount)
                Player.Functions.AddMoney('cash', (Player.Functions.GetItemByName('weed_brick').amount * 6000 / 100 * 5))
            end

            TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items["weed_brick"], "remove")

            SetTimeout(math.random(5000, 10000), function()
                TriggerClientEvent('HD-drugs:client:sendDeliveryMail', src, 'bad', deliveryData)

                if curRep - 1 > 0 then
                    Player.Functions.SetMetaData('dealerrep', (curRep - 1))
                else
                    Player.Functions.SetMetaData('dealerrep', 0)
                end
            end)
        end
    else
        TriggerClientEvent('HDCore:Notify', src, 'Je bent te laat...', 'error')

        Player.Functions.RemoveItem('weed_brick', deliveryData["amount"])
        Player.Functions.AddMoney('cash', (deliveryData["amount"] * 6000 / 100 * 4), "dilvery-drugs-too-late")

        TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items["weed_brick"], "remove")

        SetTimeout(math.random(5000, 10000), function()
            TriggerClientEvent('HD-drugs:client:sendDeliveryMail', src, 'late', deliveryData)

            if curRep - 1 > 0 then
                Player.Functions.SetMetaData('dealerrep', (curRep - 1))
            else
                Player.Functions.SetMetaData('dealerrep', 0)
            end
        end)
    end
end)

RegisterServerEvent('HD-drugs:server:callCops')
AddEventHandler('HD-drugs:server:callCops', function(streetLabel, coords)
    local msg = "Er is een verdachte situatie op "..streetLabel..", mogelijk drugs handel."
    local alertData = {
        title = "Drugshandel",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = msg
    }
    for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                TriggerClientEvent("HD-drugs:client:robberyCall", Player.PlayerData.source, msg, streetLabel, coords)
                TriggerClientEvent("HD-phone:client:addPoliceAlert", Player.PlayerData.source, alertData)
            end
        end
	end
end)

function GetCurrentCops()
    local amount = 0
    for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    return amount
end

HDCore.Commands.Add("plaatsdealer", "Plaats een dealer", {
    {name = "naam", help = "Naam van de dealer"},
    {name = "min", help = "Minimale tijd"},
    {name = "max", help = "Maximale tijd"},
}, true, function(source, args)
    local dealerName = args[1]
    local mintime = tonumber(args[2])
    local maxtime = tonumber(args[3])

    TriggerClientEvent('HD-drugs:client:CreateDealer', source, dealerName, mintime, maxtime)
end, "admin")

HDCore.Commands.Add("verwijderdealer", "Plaats een dealer", {
    {name = "naam", help = "Naam van de dealer"},
}, true, function(source, args)
    local dealerName = args[1]
    
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `server_dealers` WHERE `name` = '"..dealerName.."'", function(result)
        if result[1] ~= nil then
            HDCore.Functions.ExecuteSql(false, "DELETE FROM `server_dealers` WHERE `name` = '"..dealerName.."'")
            Config.Dealers[dealerName] = nil
            TriggerClientEvent('HD-drugs:client:RefreshDealers', -1, Config.Dealers)
            TriggerClientEvent('HDCore:Notify', source, "Je hebt Dealer "..dealerName.." verwijderd!", "success")
        else
            TriggerClientEvent('HDCore:Notify', source, "Dealer "..dealerName.." bestaat niet..", "error")
        end
    end)
end, "admin")

HDCore.Commands.Add("dealers", "Krijg overzicht van alle Dealers", {}, false, function(source, args)
    local DealersText = ""
    if Config.Dealers ~= nil and next(Config.Dealers) ~= nil then
        for k, v in pairs(Config.Dealers) do
            DealersText = DealersText .. "Naam: " .. v["name"] .. "<br>"
        end
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-message advert"><div class="chat-message-body"><strong>Lijst van alle dealers: </strong><br><br> '..DealersText..'</div></div>',
            args = {}
        })
    else
        TriggerClientEvent('HDCore:Notify', source, 'Er zijn geen dealers geplaatst.', 'error')
    end
end, "admin")

HDCore.Commands.Add("dealergoto", "TP naar dealer locatie toe.", {{name = "naam", help = "Naam van de Dealer"}}, true, function(source, args)
    local DealerName = tostring(args[1])

    if Config.Dealers[DealerName] ~= nil then
        TriggerClientEvent('HD-drugs:client:GotoDealer', source, Config.Dealers[DealerName])
    else
        TriggerClientEvent('HDCore:Notify', source, 'Deze dealer bestaat niet.', 'error')
    end
end, "admin")

Citizen.CreateThread(function()
    Wait(500)
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `server_dealers`", function(dealers)
        if dealers[1] ~= nil then
            for k, v in pairs(dealers) do
                local coords = json.decode(v.coords)
                local time = json.decode(v.time)

                Config.Dealers[v.name] = {
                    ["name"] = v.name,
                    ["coords"] = {
                        ["x"] = coords.x,
                        ["y"] = coords.y,
                        ["z"] = coords.z,
                    },
                    ["time"] = {
                        ["min"] = time.min,
                        ["max"] = time.max,
                    },
                    ["products"] = Config.Products,
                }
            end
        end
        TriggerClientEvent('HD-drugs:client:RefreshDealers', -1, Config.Dealers)
    end)
end)

RegisterServerEvent('HD-drugs:server:CreateDealer')
AddEventHandler('HD-drugs:server:CreateDealer', function(DealerData)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `server_dealers` WHERE `name` = '"..DealerData.name.."'", function(result)
        if result[1] ~= nil then
            TriggerClientEvent('HDCore:Notify', src, "Er is al een Dealer met deze naam..", "error")
        else
            HDCore.Functions.ExecuteSql(false, "INSERT INTO `server_dealers` (`name`, `coords`, `time`, `createdby`) VALUES ('"..DealerData.name.."', '"..json.encode(DealerData.pos).."', '"..json.encode(DealerData.time).."', '"..Player.PlayerData.citizenid.."')", function()
                Config.Dealers[DealerData.name] = {
                    ["name"] = DealerData.name,
                    ["coords"] = {
                        ["x"] = DealerData.pos.x,
                        ["y"] = DealerData.pos.y,
                        ["z"] = DealerData.pos.z,
                    },
                    ["time"] = {
                        ["min"] = DealerData.time.min,
                        ["max"] = DealerData.time.max,
                    },
                    ["products"] = Config.Products,
                }

                TriggerClientEvent('HD-drugs:client:RefreshDealers', -1, Config.Dealers)
            end)
        end
    end)
end)

function GetDealers()
    return Config.Dealers
end