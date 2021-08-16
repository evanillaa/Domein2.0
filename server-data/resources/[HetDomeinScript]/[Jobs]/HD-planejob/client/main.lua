HDCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if HDCore == nil then
            TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

isLoggedIn = false
PlayerJob = {}

local PilotVehicle = nil
local hasPlane = false
local hasBag = false
local PilotLocation = 0
local DeliveryBlip = nil
local IsWorking = false
local AmountOfBags = 0
local PilotObject = nil
local EndBlip = nil
local PilotBlip = nil
local Earnings = 0
local CanTakeBag = true

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    PlayerJob = HDCore.Functions.GetPlayerData().job
    PilotVehicle = nil
    hasPlane = false
    hasBag = false
    PilotLocation = 0
    DeliveryBlip = nil
    IsWorking = false
    AmountOfBags = 0
    PilotObject = nil
    EndBlip = nil

    if PlayerJob.name == "pilot" then
        PilotBlip = AddBlipForCoord(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z)
        SetBlipSprite(PilotBlip, 318)
        SetBlipDisplay(PilotBlip, 4)
        SetBlipScale(PilotBlip, 0.6)
        SetBlipAsShortRange(PilotBlip, true)
        SetBlipColour(PilotBlip, 39)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations["main"].label)
        EndTextCommandSetBlipName(PilotBlip)
    end
end)

RegisterNetEvent('HDCore:Client:OnJobUpdate')
AddEventHandler('HDCore:Client:OnJobUpdate', function(JobInfo)
    isLoggedIn = true
    PilotVehicle = nil
    hasPlane = false
    hasBag = false
    PilotLocation = 0
    DeliveryBlip = nil
    IsWorking = false
    AmountOfBags = 0
    PilotObject = nil
    EndBlip = nil

    if PlayerJob.name == "pilot" then
        if PilotBlip ~= nil then
            RemoveBlip(PilotBlip)
        end
    end

    if JobInfo.name == "pilot" then
        PilotBlip = AddBlipForCoord(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z)
        SetBlipSprite(PilotBlip, 307)
        SetBlipDisplay(PilotBlip, 4)
        SetBlipScale(PilotBlip, 0.6)
        SetBlipAsShortRange(PilotBlip, true)
        SetBlipColour(PilotBlip, 0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations["main"].label)
        EndTextCommandSetBlipName(PilotBlip)
    end

    PlayerJob = JobInfo
end)

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
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function DrawText3D2(coords, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x,coords.y,coords.z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function LoadModel(hash)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(10)
    end
end

function LoadAnimation(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(10)
	end
end

function BringBackCar()
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
    DeleteVehicle(veh)
    if EndBlip ~= nil then
        RemoveBlip(EndBlip)
    end
    if DeliveryBlip ~= nil then
        RemoveBlip(DeliveryBlip)
    end
    if Earnings > 0 then
        PayCheckLoop(PilotLocation)
    end
    PilotVehicle = nil
    hasPlane = false
    hasBag = false
    PilotLocation = 0
    DeliveryBlip = nil
    IsWorking = false
    AmountOfBags = 0
    PilotObject = nil
    EndBlip = nil
end

function PayCheckLoop(location)
    Citizen.CreateThread(function()
        while Earnings > 0 do
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)
            local coords = Config.Locations["paycheck"].coords
            local distance = GetDistanceBetweenCoords(pos, coords.x, coords.y, coords.z, true)

            if distance < 20 then
                DrawMarker(2, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 233, 55, 22, 222, false, false, false, true, false, false, false)
                if distance < 1.5 then
                    DrawText3D(coords.x, coords.y, coords.z, "~g~E~w~ - Loonstrook")
                    if IsControlJustPressed(0, Keys["E"]) then
                        HDCore.Functions.TriggerCallback('HD-planejob:server:ShiftPayment', function(result)

                        end, Earnings, location)
                        Earnings = 0
                    end
                elseif distance < 5 then
                    DrawText3D(coords.x, coords.y, coords.z, "Loonstrook")
                end
            end

            Citizen.Wait(1)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local spawnplek = Config.Locations["vehicle"].label
        local InVehicle = IsPedInAnyVehicle(GetPlayerPed(-1), false)
        local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, true)
        
        if isLoggedIn then
            if PlayerJob.name == "pilot" then
                if distance < 10.0 then
                    DrawMarker(2, Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 233, 55, 22, 222, false, false, false, true, false, false, false)
                    if distance < 1.5 then
                        if InVehicle then
                            DrawText3D(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, "~g~E~w~ - Vliegtuig opbergen")
                            if IsControlJustReleased(0, Keys["E"]) then
                                HDCore.Functions.TriggerCallback('HD-planejob:server:CheckBail', function(DidBail)
                                    if DidBail then
                                        BringBackCar()
                                        HDCore.Functions.Notify("Je hebt €750,- borg terug ontvangen!")
                                    else
                                        HDCore.Functions.Notify("Je hebt geen borg betaald over dit voertuig..")
                                    end
                                end)
                            end
                        else
                            DrawText3D(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, "~g~E~w~ - Vliegtuig")
                            if IsControlJustReleased(0, Keys["E"]) then
                                HDCore.Functions.TriggerCallback('HD-planejob:server:HasMoney', function(HasMoney)
                                    if HasMoney then
                                        local coords = Config.Locations["vehicle"].coords
                                        HDCore.Functions.SpawnVehicle("velum", function(veh)
                                            PilotVehicle = veh
                                            SetVehicleNumberPlateText(veh, "PLANE"..tostring(math.random(1000, 9999)))
                                            SetEntityHeading(veh, coords.h)
                                            exports['HD-fuel']:SetFuelLevel(veh, GetVehicleNumberPlateText(veh), 100, false)
                                            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                                            SetEntityAsMissionEntity(veh, true, true)
                                            exports['HD-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
                                            SetVehicleEngineOn(veh, true, true)
                                            hasPlane = true
                                            PilotLocation = 1
                                            IsWorking = true
                                            SetPilotRoute()
                                            HDCore.Functions.Notify("Je hebt €1000,- borg betaald!")
                                            HDCore.Functions.Notify("Je bent begonnen met werken, locatie staat aangegeven op je GPS!")
                                        end, coords, true)
                                    else
                                        HDCore.Functions.Notify("Je hebt niet genoeg geld voor de borg.. Borg kosten zijn €750,-")
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end

        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do

        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local inRange = false

        if isLoggedIn then
            if PlayerJob.name == "pilot" then
                if IsWorking then
                    if PilotLocation ~= 0 then
                        if DeliveryBlip ~= nil then
                            local DeliveryData = Config.Locations["cargoholders"][PilotLocation]
                            local Distance = GetDistanceBetweenCoords(pos, DeliveryData.coords.x, DeliveryData.coords.y, DeliveryData.coords.z, true)

                            if Distance < 20 or hasBag then
                                LoadAnimation('missfbi4prepp1')
                                DrawMarker(2, DeliveryData.coords.x, DeliveryData.coords.y, DeliveryData.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 55, 22, 255, false, false, false, false, false, false, false)
                                if not hasBag then
                                    if CanTakeBag then
                                        if Distance < 1.5 then
                                            DrawText3D2(DeliveryData.coords, "~g~G~w~ - Koffer pakken")
                                            if IsControlJustPressed(0, 47) then
                                                if AmountOfBags == 0 then
                                                    -- Hier zet ie hoeveel koffers er moeten worden afgeleverd als het nog niet bepaald is
                                                    AmountOfBags = math.random(3, 5)
                                                end 
                                                hasBag = true
                                                TakeAnim()
                                            end
                                        elseif Distance < 10 then
                                            DrawText3D2(DeliveryData.coords, "Ga hier staan om een koffer te pakken.")
                                        end
                                    end
                                else
                                    if DoesEntityExist(PilotVehicle) then
                                        if Distance < 10 then
                                            DrawText3D2(DeliveryData.coords, "Zet de koffer in het vliegtuig..")
                                        end

                                        local Coords = GetOffsetFromEntityInWorldCoords(PilotVehicle, 0.0, -4.5, 0.0)
                                        local TruckDist = GetDistanceBetweenCoords(pos, Coords.x, Coords.y, Coords.z, true)

                                        if TruckDist < 2 then
                                            DrawText3D(Coords.x, Coords.y, Coords.z, "~g~G~w~ - Koffer in de het vliegtuig plaatsen")
                                            if IsControlJustPressed(0, 47) then
                                                hasBag = false
                                                local AmountOfLocations = #Config.Locations["cargoholders"]
                                                -- Kijkt of je alle koffers hebt afgeleverd
                                                if (AmountOfBags - 1) == 0 then
                                                    -- Alle koffers afgeleverd
                                                    Earnings = Earnings + math.random(250, 270)
                                                    if (PilotLocation + 1) <= AmountOfLocations then
                                                        -- Hier zet ie je volgende locatie en ben je nog niet klaar met werken.
                                                        PilotLocation = PilotLocation + 1
                                                        SetPilotRoute()
                                                        HDCore.Functions.Notify("Alle koffers zijn ingeladen, ga door naar de volgende hangar locatie!")
                                                    else
                                                        -- Hier ben je klaar met werken.
                                                        HDCore.Functions.Notify("Je bent klaar met vliegen! Ga terug naar LSIA Vliegveld.")
                                                        IsWorking = false
                                                        RemoveBlip(DeliveryBlip)
                                                        SetRouteBack()
                                                    end
                                                    AmountOfBags = 0
                                                    hasBag = false
                                                else
                                                    -- Hier heb je nog niet alle koffers afgeleverd
                                                    AmountOfBags = AmountOfBags - 1
                                                    if AmountOfBags > 1 then
                                                        HDCore.Functions.Notify("Er zijn nog "..AmountOfBags.." koffers over!")
                                                    else
                                                        HDCore.Functions.Notify("Er is nog "..AmountOfBags.." koffer over!")
                                                    end
                                                    hasBag = false
                                                end
                                                DeliverAnim()
                                            end
                                        elseif TruckDist < 10 then
                                            DrawText3D(Coords.x, Coords.y, Coords.z, "Ga hier staan..")
                                        end
                                    else
                                        DrawText3D2(DeliveryData.coords, "Je hebt geen vliegtuig..")
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if not IsWorking then
            Citizen.Wait(1000)
        end

        Citizen.Wait(1)
    end
end)

function SetPilotRoute()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local CurrentLocation = Config.Locations["cargoholders"][PilotLocation]

    if DeliveryBlip ~= nil then
        RemoveBlip(DeliveryBlip)
    end

    DeliveryBlip = AddBlipForCoord(CurrentLocation.coords.x, CurrentLocation.coords.y, CurrentLocation.coords.z)
    SetBlipSprite(DeliveryBlip, 1)
    SetBlipDisplay(DeliveryBlip, 2)
    SetBlipScale(DeliveryBlip, 1.0)
    SetBlipAsShortRange(DeliveryBlip, false)
    SetBlipColour(DeliveryBlip, 27)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Locations["cargoholders"][PilotLocation].name)
    EndTextCommandSetBlipName(DeliveryBlip)
    SetBlipRoute(DeliveryBlip, true)
end

function SetRouteBack()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local inleverpunt = Config.Locations["vehicle"]

    EndBlip = AddBlipForCoord(inleverpunt.coords.x, inleverpunt.coords.y, inleverpunt.coords.z)
    SetBlipSprite(EndBlip, 1)
    SetBlipDisplay(EndBlip, 2)
    SetBlipScale(EndBlip, 1.0)
    SetBlipAsShortRange(EndBlip, false)
    SetBlipColour(EndBlip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Locations["vehicle"].name)
    EndTextCommandSetBlipName(EndBlip)
    SetBlipRoute(EndBlip, true)
end

function TakeAnim()
    local ped = GetPlayerPed(-1)

    LoadAnimation('missfbi4prepp1')
    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
    PilotObject = CreateObject(GetHashKey("prop_ld_suitcase_02"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(PilotObject, ped, GetPedBoneIndex(ped, 57005), 0.12, 0.0, -0.05, 220.0, 120.0, 0.0, true, true, false, true, 1, true)

    AnimCheck()
end

function AnimCheck()
    Citizen.CreateThread(function()
        while true do
            local ped = GetPlayerPed(-1)

            if hasBag then
                if not IsEntityPlayingAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 3) then
                    ClearPedTasksImmediately(ped)
                    LoadAnimation('missfbi4prepp1')
                    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
                end
            else
                break
            end

            Citizen.Wait(200)
        end
    end)
end

function DeliverAnim()
    local ped = GetPlayerPed(-1)

    LoadAnimation('missfbi4prepp1')
    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_throw_garbage_man', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
    FreezeEntityPosition(ped, true)
    SetEntityHeading(ped, GetEntityHeading(PilotVehicle))
    CanTakeBag = false

    SetTimeout(1250, function()
        DetachEntity(PilotObject, 1, false)
        DeleteObject(PilotObject)
        TaskPlayAnim(ped, 'missfbi4prepp1', 'exit', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
        FreezeEntityPosition(ped, false)
        PilotObject = nil
        CanTakeBag = true
    end)
end

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        if PilotObject ~= nil then
            DeleteEntity(PilotObject)
            PilotObject = nil
        end
    end
end)

RegisterNetEvent('HD-planejob')
AddEventHandler('HD-planejob', function(event)
    TriggerServerEvent('HD-planejob:server:PayShit', Earnings, location)
end)