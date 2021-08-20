local CurrentShownPlants = {}
local HDCore =  nil
local CurrentHouse = nil
local LoggedIn = false
local NearPlant = false
local PlacedPlant = false

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
      TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)
      Citizen.Wait(150)
      HDCore.Functions.TriggerCallback('HD-houseplants:server:get:config', function(ConfigData)
        Config = ConfigData
      end)
      LoggedIn = true
    end)
end)

RegisterNetEvent('HDCore:Client:OnPlayerUnload')
AddEventHandler('HDCore:Client:OnPlayerUnload', function()
    UnloadHousePlants()
    Citizen.SetTimeout(150, function()
        CurrentHouse = nil
        NearPlant = false
        LoggedIn = false
    end)
end)

-- Code

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(4)
        if CurrentHouse ~= nil then
            if Config.Plants[CurrentHouse] ~= nil then
                NearPlant = false
                if PlacedPlant then
                    for k, v in pairs(Config.Plants[CurrentHouse]) do
                        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                        local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                        if Distance < 0.8 then
                            NearPlant = true
                            ClosestPlant = k
                            if v['Gender'] == 'Man' then
                                DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], '| [~g~'..v['Name']..'~s~] | [~b~Man~s~] | [~r~Voeding:~s~ '..v['Food'].. '%] | [~r~Health:~s~ '..v['Health']..'%] |')
                            else
                                DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], '| [~g~'..v['Name']..'~s~] | [~p~Vrouw~s~] | [~r~Voeding:~s~ '..v['Food'].. '%] | [~r~Health:~s~ '..v['Health']..'%] |')
                            end
                            if v['Health'] == 0 then
                                DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'] - 0.075, '~g~E~s~ - Destroy')
                                if IsControlJustReleased(0, 38) then
                                    DestroyDeadPlant(k)
                                end
                            elseif v['Progress'] >= 100 then
                                DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'] - 0.075, '~g~E~s~ - Pluck')
                                if IsControlJustReleased(0, 38) then
                                    PickSelectedPlant(k)
                                end
                            end
                        end
                    end
                end
                if not NearPlant then
                    Citizen.Wait(1500)
                    ClosestPlant = nil
                end
            end
        end
    end
end)

RegisterNetEvent('HD-houseplants:client:sync:plant:data')
AddEventHandler('HD-houseplants:client:sync:plant:data', function(ConfigData)
    Config.Plants = ConfigData
end)

RegisterNetEvent('HD-houseplants:client:sync:plants')
AddEventHandler('HD-houseplants:client:sync:plants', function(HouseId)
    if CurrentHouse ~= nil then
        if CurrentHouse == HouseId then
            PlacedPlant = false
            for k, v in pairs(CurrentShownPlants) do
                DeleteEntity(v)
                Citizen.Wait(50)
            end
            CurrentShownPlants = {}
            Citizen.SetTimeout(750, function()
                LoadHousePlants(CurrentHouse)
            end)
        end
    end
end)

RegisterNetEvent('HD-houseplants:client:feed:plants')
AddEventHandler('HD-houseplants:client:feed:plants', function()
    if CurrentHouse ~= nil then
        if ClosestPlant ~= nil then
            if Config.Plants[CurrentHouse][ClosestPlant]['Food'] < 100 then
                FeedSelectedPlant(ClosestPlant)
            else
                HDCore.Functions.Notify("You do you want this plant or something.", "error")
            end 
        else
            HDCore.Functions.Notify("And where do you see a plant then?", "error")
        end
    else
        HDCore.Functions.Notify("Are you in a house?", "error")
    end
end)

RegisterNetEvent('HD-houseplants:client:plant')
AddEventHandler('HD-houseplants:client:plant', function(PlantName, PlantType, ItemName)
    if CurrentHouse ~= nil then
        if ClosestPlant == nil then
            PlantPlantHere(PlantName, PlantType, ItemName)
        else
            HDCore.Functions.Notify("No place dude!", "error")
        end
    else
        HDCore.Functions.Notify("Are you in a house?", "error")
    end
end)

function PlantPlantHere(PlantName, PlantType, ItemName)
    TriggerEvent('HD-inventory:client:set:busy', true)
    HDCore.Functions.Progressbar("plant-weed", "Planten...", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "amb@world_human_gardener_plant@male@base",
        anim = "base",
        flags = 16,
    }, {}, {}, function() -- Done
        AddPlant(PlantName, PlantType, ItemName)
        TriggerEvent('HD-inventory:client:set:busy', false)
        TriggerServerEvent('HDCore:Server:RemoveItem', ItemName, 1)
        TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items[ItemName], "remove")
        StopAnimTask(GetPlayerPed(-1), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end, function()
        TriggerEvent('HD-inventory:client:set:busy', false)
        StopAnimTask(GetPlayerPed(-1), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
        HDCore.Functions.Notify("Canceled.", "error")
    end)
end

function PickSelectedPlant(PlantId)
    HDCore.Functions.TriggerCallback('HDCore:HasItem', function(HasItem)
        if HasItem then
            HDCore.Functions.Progressbar("pick-weed", "Plucking plants...", 10000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "amb@world_human_gardener_plant@male@base",
                anim = "base",
                flags = 16,
            }, {}, {}, function() -- Done
                TriggerServerEvent('HD-houseplants:server:harvest:plant', CurrentHouse, PlantId, math.random(1, 5))
                StopAnimTask(GetPlayerPed(-1), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
            end, function()
                StopAnimTask(GetPlayerPed(-1), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
                HDCore.Functions.Notify("Canceled..", "error")
            end)
        else
            HDCore.Functions.Notify("I think you miss something..", "error")
        end
      end, 'plastic-bag')
end

function DestroyDeadPlant(PlantId)
    HDCore.Functions.Progressbar("destroy-weed", "Destroying plant...", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "amb@world_human_gardener_plant@male@base",
        anim = "base",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(GetPlayerPed(-1), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
        TriggerServerEvent('HD-houseplants:server:destroy:plant', CurrentHouse, PlantId, true)
    end, function()
        StopAnimTask(GetPlayerPed(-1), "amb@world_human_gardener_plant@male@base", "base", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
        HDCore.Functions.Notify("Canceled..", "error")
    end)
end

function FeedSelectedPlant(PlantId)
    exports['HD-assets']:RequestAnimationDict("weapon@w_sp_jerrycan")
    TaskPlayAnim( PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    HDCore.Functions.Progressbar("feed-weed", "Feeding plant...", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('HD-houseplants:server:feed:plant', CurrentHouse, PlantId)
        StopAnimTask(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end, function()
        StopAnimTask(GetPlayerPed(-1), "weapon@w_sp_jerrycan", "fire", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
        HDCore.Functions.Notify("Canceled.", "error")
    end)
end

function LoadHousePlants(HouseId)
    CurrentHouse = HouseId
    if not PlacedPlant then
       PlacedPlant = true
       Citizen.SetTimeout(650, function()
           if Config.Plants[CurrentHouse] ~= nil then
               for k, v in pairs(Config.Plants[CurrentHouse]) do
                 PlantObject = CreateObject(GetHashKey(Config.StageProps[v["Stage"]]), v["Coords"]["X"], v["Coords"]["Y"], v["Coords"]["Z"], false, false, false)
                 SetEntityAsMissionEntity(PlantObject, false, false)
                 FreezeEntityPosition(PlantObject, true)
                 PlaceObjectOnGroundProperly(PlantObject)
                 Citizen.Wait(20)
                 PlaceObjectOnGroundProperly(PlantObject)
                 table.insert(CurrentShownPlants, PlantObject)
                 Citizen.Wait(50)
               end
           end
       end)
    end
 end
  
function UnloadHousePlants()
    if PlacedPlant then
        PlacedPlant = false
        CurrentHouse = nil
        for k, v in pairs(CurrentShownPlants) do
            DeleteEntity(v)
            Citizen.Wait(50)
        end
        CurrentShownPlants = {}
    end
end

function AddPlant(PlantName, PlantType)
    local PlayerCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 0.75, 0) GetEntityCoords(GetPlayerPed(-1))
    local RandomNum = math.random(1, 2)
    local Gender = 'Man'
    if RandomNum == 2 then Gender = 'Vrouw' end
    if CurrentHouse ~= nil then
        if Config.Plants[CurrentHouse] ~= nil then
            local Data = {['Name'] = PlantName, ['PlantId'] = math.random(1111,9999), ['Stage'] = 'Stage-A', ['Sort'] = PlantType, ['Gender'] = Gender, ['Food'] = 100, ['Health'] = 100, ['Progress'] = 0, ['SpeedMultiplier'] = 1, ['Coords'] = {['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z}}
            table.insert(Config.Plants[CurrentHouse], Data)
            TriggerServerEvent('HD-houseplants:server:add:plant', CurrentHouse, Config.Plants[CurrentHouse])
        else
            Config.Plants[CurrentHouse] = {[1] = {['Name'] = PlantName, ['PlantId'] = math.random(1111,9999), ['Stage'] = 'Stage-A', ['Sort'] = PlantType, ['Gender'] = Gender, ['Food'] = 100, ['Health'] = 100, ['Progress'] = 0, ['SpeedMultiplier'] = 1, ['Coords'] = {['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z}}}
            TriggerServerEvent('HD-houseplants:server:add:plant', CurrentHouse, Config.Plants[CurrentHouse])
        end
    end
end

function DrawText3D(x, y, z, text)
  SetTextScale(0.30, 0.30)
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