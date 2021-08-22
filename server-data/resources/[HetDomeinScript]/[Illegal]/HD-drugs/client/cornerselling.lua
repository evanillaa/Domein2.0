cornerselling = false
hasTarget = false
busySelling = false

startLocation = nil

currentPed = nil

lastPed = {}

stealingPed = nil
stealData = {}

availableDrugs = {}

local policeMessage = {
    "Verdachte situtie",
    "Mogelijk drugsverkoop",
}

RegisterNetEvent('HD-drugs:client:cornerselling')
AddEventHandler('HD-drugs:client:cornerselling', function(data)
    HDCore.Functions.TriggerCallback('HD-drugs:server:cornerselling:getAvailableDrugs', function(result)
        if result ~= nil then
            availableDrugs = result

            if not cornerselling then
                cornerselling = true
                HDCore.Functions.Notify('Je bent nu aan het dealen')
                startLocation = GetEntityCoords(GetPlayerPed(-1))
                -- TaskStartScenarioInPlace(GetPlayerPed(-1), "CODE_HUMAN_CROSS_ROAD_WAIT", 0, false)
            else
                cornerselling = false
                HDCore.Functions.Notify('Je bent niet meer aan het dealen')
                -- ClearPedTasks(GetPlayerPed(-1))
            end
        else
            HDCore.Functions.Notify('Je hebt geen drugs op je..', 'error')
        end
    end)
end)

function toFarAway()
    HDCore.Functions.Notify('Je bent teveel aan het lopen.. begin maar weer opnieuw!', 'error')
    cornerselling = false
    hasTarget = false
    busySelling = false
    startLocation = nil
    currentPed = nil
    availableDrugs = {}
    Citizen.Wait(5000)
end

function callPolice()
    local StreetLabel = HDCore.Functions.GetStreetLabel()
    TriggerServerEvent('HD-police:server:send:drugs:alert', GetEntityCoords(GetPlayerPed(-1)), StreetLabel)
end

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(4)
        if stealingPed ~= nil and stealData ~= nil then
            if IsEntityDead(stealingPed) then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                local pedpos = GetEntityCoords(stealingPed)
                if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, pedpos.x, pedpos.y, pedpos.z, true) < 1.5) then
                    DrawText3D(pedpos.x, pedpos.y, pedpos.z, "~g~E~s~ - Spullen terug pakken")
                    if IsControlJustReleased(0, Keys["E"]) then
                        RequestAnimDict("pickup_object")
                        while not HasAnimDictLoaded("pickup_object") do
                            Citizen.Wait(7)
                        end
                        TaskPlayAnim(GetPlayerPed(-1), "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
                        Citizen.Wait(2000)
                        ClearPedTasks(GetPlayerPed(-1))
                        TriggerServerEvent('HD-drugs:server:robCornerRunner', stealData.item, stealData.amount)
                        TriggerEvent('inventory:client:ItemBox', HDCore.Shared.Items[stealData.item], "add")
                        stealingPed = nil
                        stealData = {}
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do

        if cornerselling then
            local player = GetPlayerPed(-1)
            local coords = GetEntityCoords(player)
            if not hasTarget then
                local PlayerPeds = {}
                if next(PlayerPeds) == nil then
                    for _, player in ipairs(GetActivePlayers()) do
                        local ped = GetPlayerPed(player)
                        table.insert(PlayerPeds, ped)
                    end
                end
                
                local closestPed, closestDistance = HDCore.Functions.GetClosestPed(coords, PlayerPeds)

                if closestDistance < 15.0 and closestPed ~= 0 then
                    SellToPed(closestPed)
                end
            end

            local startDist = GetDistanceBetweenCoords(startLocation, GetEntityCoords(GetPlayerPed(-1)))

            if startDist > 10 then
                toFarAway()
            end
        end

        if not cornerselling then
            Citizen.Wait(1000)
        end

        Citizen.Wait(3)
    end
end)

RegisterNetEvent('HD-drugs:client:refreshAvailableDrugs')
AddEventHandler('HD-drugs:client:refreshAvailableDrugs', function(items)
    availableDrugs = items
end)

function SellToPed(ped)
    hasTarget = true
    for i = 1, #lastPed, 1 do
        if lastPed[i] == ped then
            hasTarget = false
            return
        end
    end

    local succesChance = math.random(1, 20)

    local scamChance = math.random(1, 2)

    local getRobbed = math.random(1, 20)

    if succesChance <= 7 then
        hasTarget = false
        return
    elseif succesChance >= 1 then
        callPolice()
        return
    end

    local drugType = math.random(1, #availableDrugs)
    local bagAmount = math.random(1, availableDrugs[drugType].amount)

    if bagAmount > 15 then
        bagAmount = math.random(9, 15)
    end
    currentOfferDrug = availableDrugs[drugType]

    local ddata = Config.DrugsPrice[currentOfferDrug.item]
    local randomPrice = math.random(ddata.min, ddata.max) * bagAmount
    if scamChance == 2 then
       randomPrice = math.random(3, 10) * bagAmount
    end

    SetEntityAsNoLongerNeeded(ped)
    ClearPedTasks(ped)

    local coords = GetEntityCoords(GetPlayerPed(-1), true)
    local pedCoords = GetEntityCoords(ped)
    local pedDist = GetDistanceBetweenCoords(coords, pedCoords)

    if getRobbed == 18 or getRobbed == 9 then
        TaskGoStraightToCoord(ped, coords, 15.0, -1, 0.0, 0.0)
    else
        TaskGoStraightToCoord(ped, coords, 1.2, -1, 0.0, 0.0)
    end

    while pedDist > 1.5 do
        coords = GetEntityCoords(GetPlayerPed(-1), true)
        pedCoords = GetEntityCoords(ped)    
        if getRobbed == 18 or getRobbed == 9 then
            TaskGoStraightToCoord(ped, coords, 15.0, -1, 0.0, 0.0)
        else
            TaskGoStraightToCoord(ped, coords, 1.2, -1, 0.0, 0.0)
        end
        TaskGoStraightToCoord(ped, coords, 1.2, -1, 0.0, 0.0)
        pedDist = GetDistanceBetweenCoords(coords, pedCoords)

        Citizen.Wait(100)
    end

    TaskLookAtEntity(ped, GetPlayerPed(-1), 5500.0, 2048, 3)
    TaskTurnPedToFaceEntity(ped, GetPlayerPed(-1), 5500)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", 0, false)
    currentPed = ped

    if hasTarget then
        while pedDist < 1.5 do
            coords = GetEntityCoords(GetPlayerPed(-1), true)
            pedCoords = GetEntityCoords(ped)
            pedDist = GetDistanceBetweenCoords(coords, pedCoords)

            if getRobbed == 18 or getRobbed == 9 then
                TriggerServerEvent('HD-drugs:server:robCornerDrugs', availableDrugs[drugType].item, bagAmount)
                HDCore.Functions.Notify('Je bent beroofd van '..bagAmount..' zakje(\'s) '..availableDrugs[drugType].label, 'error')
                stealingPed = ped
                stealData = {
                    item = availableDrugs[drugType].item,
                    amount = bagAmount,
                }

                hasTarget = false

                local rand = (math.random(6,9) / 100) + 0.3
                local rand2 = (math.random(6,9) / 100) + 0.3
                if math.random(10) > 5 then
                    rand = 0.0 - rand
                end
            
                if math.random(10) > 5 then
                    rand2 = 0.0 - rand2
                end
            
                local moveto = GetEntityCoords(GetPlayerPed(-1))
                local movetoCoords = {x = moveto.x + math.random(100, 500), y = moveto.y + math.random(100, 500), z = moveto.z, }
                ClearPedTasksImmediately(ped)
                TaskGoStraightToCoord(ped, movetoCoords.x, movetoCoords.y, movetoCoords.z, 15.0, -1, 0.0, 0.0)

                table.insert(lastPed, ped)
                break
            else
                if pedDist < 1.5 then
                    DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z, '~g~E~w~ - '..bagAmount..'x '..currentOfferDrug.label..' voor €'..randomPrice..' / ~g~G~w~ - Afwijzen')
                    if IsControlJustPressed(0, Keys["E"]) then
                        HDCore.Functions.Notify('Aanbod geaccepteerd!', 'success')
                        TriggerServerEvent('HD-drugs:server:sellCornerDrugs', availableDrugs[drugType].item, bagAmount, randomPrice)
                        hasTarget = false

                        loadAnimDict("gestures@f@standing@casual")
                        TaskPlayAnim(GetPlayerPed(-1), "gestures@f@standing@casual", "gesture_point", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                        Citizen.Wait(650)
                        ClearPedTasks(GetPlayerPed(-1))

                        SetPedKeepTask(ped, false)
                        SetEntityAsNoLongerNeeded(ped)
                        ClearPedTasksImmediately(ped)
                        table.insert(lastPed, ped)
                        break
                    end

                    if IsControlJustPressed(0, Keys["G"]) then
                        HDCore.Functions.Notify('Aanbod geweigerd!', 'error')
                        hasTarget = false

                        SetPedKeepTask(ped, false)
                        SetEntityAsNoLongerNeeded(ped)
                        ClearPedTasksImmediately(ped)
                        table.insert(lastPed, ped)
                        break
                    end
                else
                    hasTarget = false
                    SetPedKeepTask(ped, false)
                    SetEntityAsNoLongerNeeded(ped)
                    ClearPedTasksImmediately(ped)
                    table.insert(lastPed, ped)
                end
            end
            
            Citizen.Wait(3)
        end
        
        Citizen.Wait(math.random(4000, 7000))
    end
end

function loadAnimDict(dict)
    RequestAnimDict(dict)

    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
end

function runAnimation(target)
    RequestAnimDict("mp_character_creation@lineup@male_a")
    while not HasAnimDictLoaded("mp_character_creation@lineup@male_a") do
    Citizen.Wait(0)
    end
    if not IsEntityPlayingAnim(target, "mp_character_creation@lineup@male_a", "loop_raised", 3) then
        TaskPlayAnim(target, "mp_character_creation@lineup@male_a", "loop_raised", 8.0, -8, -1, 49, 0, 0, 0, 0)
    end
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end