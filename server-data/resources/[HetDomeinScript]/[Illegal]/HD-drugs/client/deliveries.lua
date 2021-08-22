currentDealer = nil
knockingDoor = false

local dealerIsHome = false

local waitingDelivery = nil
local activeDelivery = nil

local interacting = false

local deliveryTimeout = 0

local isHealingPerson = false
local healAnimDict = "mini@cpr@char_a@cpr_str"
local healAnim = "cpr_pumpchest"

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
    HDCore.Functions.TriggerCallback('HD-drugs:server:RequestConfig', function(DealerConfig)
        Config.Dealers = DealerConfig
    end)
end)

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        nearDealer = false

        for id, dealer in pairs(Config.Dealers) do
            local dealerDist = GetDistanceBetweenCoords(pos, dealer["coords"]["x"], dealer["coords"]["y"], dealer["coords"]["z"])

            if dealerDist <= 6 then
                nearDealer = true

                if dealerDist <= 1.5 and not isHealingPerson then
                    if not interacting then
                        if not dealerIsHome then
                            DrawText3D(dealer["coords"]["x"], dealer["coords"]["y"], dealer["coords"]["z"], '~g~E~s~ - Aankloppen')

                            if IsControlJustPressed(0, Keys["E"]) then
                                currentDealer = id
                                knockDealerDoor()
                            end
                        elseif dealerIsHome then
                            if dealer["name"] == "Ouweheer" then
                                DrawText3D(dealer["coords"]["x"], dealer["coords"]["y"], dealer["coords"]["z"], '~g~E~s~ - Inkopen / ~g~G~s~ - Help je maat (€5000)')
                            else
                                --DrawText3D(dealer["coords"]["x"], dealer["coords"]["y"], dealer["coords"]["z"], '~g~E~s~ - Inkopen / ~g~G~s~ - Leveren')
                                DrawText3D(dealer["coords"]["x"], dealer["coords"]["y"], dealer["coords"]["z"], '~g~E~s~ - Leveren')
                            end
                            --[[ if IsControlJustPressed(0, Keys["E"]) then
                                buyDealerStuff()
                            end ]]   

                            if IsControlJustPressed(0, Keys["E"]) then
                                if dealer["name"] == "Ouweheer" then
                                    local player, distance = GetClosestPlayer()
                                    if player ~= -1 and distance < 5.0 then
                                        local playerId = GetPlayerServerId(player)
                                        isHealingPerson = true
                                        HDCore.Functions.Progressbar("hospital_revive", "Persoon omhoog helpen..", 5000, false, true, {
                                            disableMovement = false,
                                            disableCarMovement = false,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {
                                            animDict = healAnimDict,
                                            anim = healAnim,
                                            flags = 16,
                                        }, {}, {}, function() -- Done
                                            isHealingPerson = false
                                            StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                                            HDCore.Functions.Notify("Je hebt de persoon geholpen!")
                                            TriggerServerEvent("hospital:server:RevivePlayer", playerId, true)
                                        end, function() -- Cancel
                                            isHealingPerson = false
                                            StopAnimTask(GetPlayerPed(-1), healAnimDict, "exit", 1.0)
                                            HDCore.Functions.Notify("Mislukt!", "error")
                                        end)
                                    else
                                        HDCore.Functions.Notify("Er is niemand in de buurt..", "error")
                                    end
                                else
                                    if waitingDelivery == nil then
                                        TriggerEvent("chatMessage", "Dealer "..Config.Dealers[currentDealer]["name"], "normal", 'Hier heb je de producten, houd je mail in de gaten betreft de bestelling!')
                                        requestDelivery()
                                        interacting = false
                                        dealerIsHome = false
                                    else
                                        TriggerEvent("chatMessage", "Dealer "..Config.Dealers[currentDealer]["name"], "error", 'Je hebt nog een levering open staan. Waar wacht je op?')
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if not nearDealer then
            dealerIsHome = false
            Citizen.Wait(2000)
        end

        Citizen.Wait(3)
    end
end)

function GetClosestPlayer()
    local closestPlayers = HDCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(GetPlayerPed(-1))

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

knockDealerDoor = function()
    local hours = GetClockHours()
    local min = Config.Dealers[currentDealer]["time"]["min"]
    local max = Config.Dealers[currentDealer]["time"]["max"]

    if hours >= min and hours <= max then
        knockDoorAnim(true)
    else
        knockDoorAnim(false)
    end
end

function buyDealerStuff()
    local repItems = {}
    repItems.label = Config.Dealers[currentDealer]["name"]
    repItems.items = {}
    repItems.slots = 30

    for k, v in pairs(Config.Dealers[currentDealer]["products"]) do
        if HDCore.Functions.GetPlayerData().metadata["dealerrep"] >= Config.Dealers[currentDealer]["products"][k].minrep then
            repItems.items[k] = Config.Dealers[currentDealer]["products"][k]
        end
    end

    --local repItems = {label = Config.Dealers[currentDealer]['name'], items = Config.Dealers[currentDealer]["products"], slots = 30}
    TriggerServerEvent("HD-inventory:server:OpenInventory", "shop", "Dealer_"..Config.Dealers[currentDealer]["name"], repItems)
end

function knockDoorAnim(home)
    local knockAnimLib = "timetable@jimmy@doorknock@"
    local knockAnim = "knockdoor_idle"
    local PlayerPed = GetPlayerPed(-1)
    local myData = HDCore.Functions.GetPlayerData()

    if home then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "knock_door", 0.2)
        Citizen.Wait(100)
        while (not HasAnimDictLoaded(knockAnimLib)) do
            RequestAnimDict(knockAnimLib)
            Citizen.Wait(100)
        end
        knockingDoor = true
        TaskPlayAnim(PlayerPed, knockAnimLib, knockAnim, 3.0, 3.0, -1, 1, 0, false, false, false )
        Citizen.Wait(3500)
        TaskPlayAnim(PlayerPed, knockAnimLib, "exit", 3.0, 3.0, -1, 1, 0, false, false, false)
        knockingDoor = false
        Citizen.Wait(1000)
        dealerIsHome = true
        if Config.Dealers[currentDealer]["name"] == "Ouweheer" then
            TriggerEvent("chatMessage", "Dealer "..Config.Dealers[currentDealer]["name"], "normal", 'Goedendag mijn kind, wat kan ik voor je betekenen?')
        elseif Config.Dealers[currentDealer]["name"] == "Fred" then
            dealerIsHome = false
            TriggerEvent("chatMessage", "Dealer "..Config.Dealers[currentDealer]["name"], "normal", 'Ik doe helaas geen zaken meer... Hadden jullie maar beter met me om moeten gaan.')
        else
            TriggerEvent("chatMessage", "Dealer "..Config.Dealers[currentDealer]["name"], "normal", 'Yo '..myData.charinfo.firstname..', wat kan ik voor je betekenen?')
        end
        -- knockTimeout()
    else
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "knock_door", 0.2)
        Citizen.Wait(100)
        while (not HasAnimDictLoaded(knockAnimLib)) do
            RequestAnimDict(knockAnimLib)
            Citizen.Wait(100)
        end
        knockingDoor = true
        TaskPlayAnim(PlayerPed, knockAnimLib, knockAnim, 3.0, 3.0, -1, 1, 0, false, false, false )
        Citizen.Wait(3500)
        TaskPlayAnim(PlayerPed, knockAnimLib, "exit", 3.0, 3.0, -1, 1, 0, false, false, false)
        knockingDoor = false
        Citizen.Wait(1000)
        HDCore.Functions.Notify('Het lijkt erop dat er niemand thuis is..', 'error', 3500)
    end
end

RegisterNetEvent('HD-drugs:client:updateDealerItems')
AddEventHandler('HD-drugs:client:updateDealerItems', function(itemData, amount)
    TriggerServerEvent('HD-drugs:server:updateDealerItems', itemData, amount, currentDealer)
end)

RegisterNetEvent('HD-drugs:client:setDealerItems')
AddEventHandler('HD-drugs:client:setDealerItems', function(itemData, amount, dealer)
    Config.Dealers[dealer]["products"][itemData.slot].amount = Config.Dealers[dealer]["products"][itemData.slot].amount - amount
end)

function requestDelivery()
    local location = math.random(1, #Config.DeliveryLocations)
    local amount = math.random(1, 3)
    local item = randomDeliveryItemOnRep()
    waitingDelivery = {
        ["coords"] = Config.DeliveryLocations[location]["coords"],
        ["locationLabel"] = Config.DeliveryLocations[location]["label"],
        ["amount"] = amount,
        ["dealer"] = currentDealer,
        ["itemData"] = Config.DeliveryItems[item]
    }
    TriggerServerEvent('HD-drugs:server:giveDeliveryItems', amount)
    SetTimeout(2000, function()
        TriggerServerEvent('HD-phone:server:sendNewMail', {
            sender = Config.Dealers[currentDealer]["name"],
            subject = "Aflever Locatie",
            message = "De bezorg locatie is meegeleverd in deze mail. Zorg dat je optijd bent.<br><br>Levering: "..amount.."x "..HDCore.Shared.Items[waitingDelivery["itemData"]["item"]]["label"].."",
            --message = "De bezorg locatie is meegeleverd in deze mail, zorg dat je optijd bent.",
            button = {
                enabled = true,
                buttonEvent = "HD-drugs:client:setLocation",
                buttonData = waitingDelivery
            }
        })
    end)
end

function randomDeliveryItemOnRep()
    local ped = GetPlayerPed(-1)
    local myRep = HDCore.Functions.GetPlayerData().metadata["dealerrep"]

    retval = nil

    for k, v in pairs(Config.DeliveryItems) do
        if Config.DeliveryItems[k]["minrep"] <= myRep then
            local availableItems = {}
            table.insert(availableItems, k)

            local item = math.random(1, #availableItems)

            retval = item
        end
    end
    return retval
end

function setMapBlip(x, y)
    SetNewWaypoint(x, y)
    HDCore.Functions.Notify('De route naar aflever locatie staat aangegeven op je kaart.', 'success');
end

RegisterNetEvent('HD-drugs:client:setLocation')
AddEventHandler('HD-drugs:client:setLocation', function(locationData)
    if activeDelivery == nil then
        activeDelivery = locationData
    else
        setMapBlip(activeDelivery["coords"]["x"], activeDelivery["coords"]["y"])
        HDCore.Functions.Notify('Je hebt nog een levering open staan...')
        return
    end

    deliveryTimeout = 300

    deliveryTimer()

    setMapBlip(activeDelivery["coords"]["x"], activeDelivery["coords"]["y"])

    Citizen.CreateThread(function()
        while true do

            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            local inDeliveryRange = false

            if activeDelivery ~= nil then
                local dist = GetDistanceBetweenCoords(pos, activeDelivery["coords"]["x"], activeDelivery["coords"]["y"], activeDelivery["coords"]["z"])

                if dist < 15 then
                    inDeliveryRange = true
                    if dist < 1.5 then
                        --DrawText3D(activeDelivery["coords"]["x"], activeDelivery["coords"]["y"], activeDelivery["coords"]["z"], '[E] '..activeDelivery["amount"]..'x '..HDCore.Shared.Items[activeDelivery["itemData"]["item"]]["label"]..' afleveren.')
                        DrawText3D(activeDelivery["coords"]["x"], activeDelivery["coords"]["y"], activeDelivery["coords"]["z"], '~g~E~s~ - Afleveren')

                        if IsControlJustPressed(0, Keys["E"]) then
                            deliverStuff(activeDelivery)
                            activeDelivery = nil
                            waitingDelivery = nil
                            break
                        end
                    end
                end

                if not inDeliveryRange then
                    Citizen.Wait(1500)
                end
            else
                break
            end

            Citizen.Wait(3)
        end
    end)
end)

function deliveryTimer()
    Citizen.CreateThread(function()
        while true do

            if deliveryTimeout - 1 > 0 then
                deliveryTimeout = deliveryTimeout - 1
            else
                deliveryTimeout = 0
                break
            end

            Citizen.Wait(1000)
        end
    end)
end

function deliverStuff(activeDelivery)
    if deliveryTimeout > 0 then
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        Citizen.Wait(500)
        TriggerEvent('animations:client:EmoteCommandStart', {"bumbin"})
        checkPedDistance()
        HDCore.Functions.Progressbar("work_dropbox", "Producten afleveren..", 3500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerServerEvent('HD-drugs:server:succesDelivery', activeDelivery, true)
        end, function() -- Cancel
            ClearPedTasks(GetPlayerPed(-1))
            HDCore.Functions.Notify("Geannuleerd..", "error")
        end)
    else
        TriggerServerEvent('HD-drugs:server:succesDelivery', activeDelivery, false)
    end
    deliveryTimeout = 0
end

function checkPedDistance()
    local PlayerPeds = {}
    if next(PlayerPeds) == nil then
        for _, player in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            table.insert(PlayerPeds, ped)
        end
    end
    
    local closestPed, closestDistance = HDCore.Functions.GetClosestPed(coords, PlayerPeds)

    if closestDistance < 40 and closestPed ~= 0 then
        local callChance = math.random(1, 100)

        if callChance < 40 then
            doPoliceAlert()
        end
    end
end

function doPoliceAlert()
    local StreetLabel = HDCore.Functions.GetStreetLabel()
    TriggerServerEvent('HD-police:server:send:drugs:alert', GetEntityCoords(GetPlayerPed(-1)), StreetLabel)
end

RegisterNetEvent('HD-drugs:client:robberyCall')
AddEventHandler('HD-drugs:client:robberyCall', function(msg, streetLabel, coords)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    TriggerEvent("chatMessage", "112-MELDING", "error", msg)
    local transG = 250
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 458)
    SetBlipColour(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipAlpha(blip, transG)
    SetBlipScale(blip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("112: Drugshandel")
    EndTextCommandSetBlipName(blip)
    while transG ~= 0 do
        Wait(180 * 4)
        transG = transG - 1
        SetBlipAlpha(blip, transG)
        if transG == 0 then
            SetBlipSprite(blip, 2)
            RemoveBlip(blip)
            return
        end
    end
end)

RegisterNetEvent('HD-drugs:client:sendDeliveryMail')
AddEventHandler('HD-drugs:client:sendDeliveryMail', function(type, deliveryData)
    if type == 'perfect' then
        TriggerServerEvent('HD-phone:server:sendNewMail', {
            sender = Config.Dealers[deliveryData["dealer"]]["name"],
            subject = "Levering",
            message = "Je hebt goed werk geleverd. Ik hoop snel weer zaken te kunnen doen.<br><br>Groeten, <br>"..Config.Dealers[deliveryData["dealer"]]["name"]
        })
    elseif type == 'bad' then
        TriggerServerEvent('HD-phone:server:sendNewMail', {
            sender = Config.Dealers[deliveryData["dealer"]]["name"],
            subject = "Levering",
            message = "Ik krijg klachten over je bezorging, laat dit mij niet vaker overkomen..."
        })
    elseif type == 'late' then
        TriggerServerEvent('HD-phone:server:sendNewMail', {
            sender = Config.Dealers[deliveryData["dealer"]]["name"],
            subject = "Levering",
            message = "Je was niet optijd.. Had je belangrijkere dingen te doen dan zaken?"
        })
    end
end)

RegisterNetEvent('HD-drugs:client:CreateDealer')
AddEventHandler('HD-drugs:client:CreateDealer', function(dealerName, minTime, maxTime)
    local ped = GetPlayerPed(-1)
    local loc = GetEntityCoords(ped)
    local DealerData = {
        name = dealerName,
        time = {
            min = minTime,
            max = maxTime,
        },
        pos = {
            x = loc.x,
            y = loc.y,
            z = loc.z,
        }
    }

    TriggerServerEvent('HD-drugs:server:CreateDealer', DealerData)
end)

RegisterNetEvent('HD-drugs:client:RefreshDealers')
AddEventHandler('HD-drugs:client:RefreshDealers', function(DealerData)
    Config.Dealers = DealerData
end)

RegisterNetEvent('HD-drugs:client:GotoDealer')
AddEventHandler('HD-drugs:client:GotoDealer', function(DealerData)
    local ped = GetPlayerPed(-1)

    SetEntityCoords(ped, DealerData["coords"]["x"], DealerData["coords"]["y"], DealerData["coords"]["z"])
    HDCore.Functions.Notify('Je bent naar Dealer: '.. DealerData["name"] .. ' geteleporteerd!', 'success')
end)