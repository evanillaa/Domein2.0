HDCore = nil

local IsSelling = false
local CurrentRadiusBlip = {}
local CurrentLocation = {
    ['Name'] = 'Wiet1',
    ['Coords'] = {['X'] = 5211.1103, ['Y'] = -5169.724, ['Z'] = 12.056114},
}
local CurrentBlip = {}
local LastLocation = nil  

local LoggedIn = false

RegisterNetEvent("HDCore:Client:OnPlayerLoaded")
AddEventHandler("HDCore:Client:OnPlayerLoaded", function()
  Citizen.SetTimeout(650, function()
      TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)   
      Citizen.Wait(200)
      HDCore.Functions.TriggerCallback('HD-field:server:GetConfig', function(config)
          Config = config
          Citizen.Wait(250)
          LoggedIn = true
      end) 
      SetRandomLocation()  
      LoggedIn = true 
  end)
end)

RegisterNetEvent('HDCore:Client:OnPlayerUnload')
AddEventHandler('HDCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

RegisterNetEvent('HD-wiet:client:set:picked:state')
AddEventHandler('HD-wiet:client:set:picked:state',function(PlantId, bool)
    Config.Plants['planten'][PlantId]['Geplukt'] = bool
end)

RegisterNetEvent('HD-wiet:client:set:dry:busy')
AddEventHandler('HD-wiet:client:set:dry:busy',function(DryRackId, bool)
    Config.WeedLocations['drogen'][DryRackId]['IsBezig'] = bool
end)

RegisterNetEvent('HD-wiet:client:set:pack:busy')
AddEventHandler('HD-wiet:client:set:pack:busy',function(PackerId, bool)
    Config.WeedLocations['verwerk'][PackerId]['IsBezig'] = bool
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
          Citizen.Wait(1000 * 60 * 55)
          SetRandomLocation()
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(15000)
    while true do
        Citizen.Wait(4)
        if LoggedIn then
          NearWietField = false
          local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
          local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, CurrentLocation['Coords']['X'], CurrentLocation['Coords']['Y'], CurrentLocation['Coords']['Z'], true)
          if Distance <= 75.0 then
              NearWietField = true
              Config.CanWiet = true
          end
          if not NearWietField then
              Citizen.Wait(1500)
              Config.CanWiet = false
          end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
         local SpelerCoords = GetEntityCoords(GetPlayerPed(-1))
            NearAnything = false

            for k, v in pairs(Config.WeedLocations["verwerk"]) do
                local PlantDistance = GetDistanceBetweenCoords(SpelerCoords.x, SpelerCoords.y, SpelerCoords.z, Config.WeedLocations["verwerk"][k]['x'], Config.WeedLocations["verwerk"][k]['y'], Config.WeedLocations["verwerk"][k]['z'], true)
                if PlantDistance < 1.2 then
                NearAnything = true
                 DrawMarker(2, Config.WeedLocations["verwerk"][k]['x'], Config.WeedLocations["verwerk"][k]['y'], Config.WeedLocations["verwerk"][k]['z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 67, 156, 77, 255, false, false, false, 1, false, false, false)
                 if IsControlJustPressed(0, Config.Keys['E']) then
                  if not Config.WeedLocations['verwerk'][k]['IsBezig'] then
                    HDCore.Functions.TriggerCallback('HD-wiet:server:has:nugget', function(HasNugget)
                      if HasNugget then
                          PackagePlant(k)
                      else
                          HDCore.Functions.Notify("You miss something ..", "error")
                      end
                  end)
              else
                  HDCore.Functions.Notify("Someone is already packing.", "error")
              end
            end
            end
            end
            if not NearAnything then
                Citizen.Wait(2500)
            end
        end
    end
end)

RegisterNetEvent('HD-wiet:client:rod:anim')
AddEventHandler('HD-wiet:client:rod:anim', function()
    exports['HD-assets']:AddProp('Schaar')
    exports['HD-assets']:RequestAnimationDict('amb@world_human_gardener_plant@male@idle_a')
    TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_gardener_plant@male@idle_a", "idle_a", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
end)

RegisterNetEvent('HD-wiet:client:use:scissor')
AddEventHandler('HD-wiet:client:use:scissor', function()
  Citizen.SetTimeout(1000, function()
      if not Config.UsingRod then
       if Config.CanWiet then
          if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
           if not IsEntityInWater(GetPlayerPed(-1)) then
               Config.UsingRod = true
               FreezeEntityPosition(GetPlayerPed(-1), true)
               local Skillbar = exports['HD-skillbar']:GetSkillbarObject()
               local SucceededAttempts = 0
               local NeededAttempts = math.random(2, 5)
               TriggerEvent('HD-wiet:client:rod:anim')
               Skillbar.Start({
                   duration = math.random(500, 1300),
                   pos = math.random(10, 30),
                   width = math.random(10, 20),
               }, function()
                   if SucceededAttempts + 1 >= NeededAttempts then
                       -- Finish
                       FreezeEntityPosition(GetPlayerPed(-1), false)
                       exports['HD-assets']:RemoveProp()
                       Config.UsingRod = false
                       SucceededAttempts = 0
                       TriggerServerEvent('HD-wiet:server:weed:reward')
                       StopAnimTask(GetPlayerPed(-1), "amb@world_human_gardener_plant@male@idle_a", "idle_a", 1.0)
                   else
                       -- Repeat
                       Skillbar.Repeat({
                           duration = math.random(500, 1300),
                           pos = math.random(10, 40),
                           width = math.random(5, 13),
                       })
                       SucceededAttempts = SucceededAttempts + 1
                   end
               end, function()
                   -- Fail
                   FreezeEntityPosition(GetPlayerPed(-1), false)
                   exports['HD-assets']:RemoveProp()
                   Config.UsingRod = false
                   HDCore.Functions.Notify('Je faalde..', 'error')
                   SucceededAttempts = 0
                   StopAnimTask(GetPlayerPed(-1), "amb@world_human_gardener_plant@male@idle_a", "idle_a", 1.0)
               end)
           else
               HDCore.Functions.Notify('You are swimming.', 'error')
           end
          else
              HDCore.Functions.Notify('You are in a vehicle.', 'error')
          end
       else
           HDCore.Functions.Notify('You are not in the breeding area.', 'error')
       end
      end
  end)
end)

function SetRandomLocation()
    RandomLocation = Config.WeedLocations[math.random(1, #Config.WeedLocations)]
    if CurrentLocation['Name'] ~= RandomLocation['Name'] then
     if CurrentBlip ~= nil and CurrentRadiosBlip ~= nil then
      RemoveBlip(CurrentBlip)
      RemoveBlip(CurrentRadiosBlip)
     end
     Citizen.SetTimeout(250, function()
         CurrentRadiosBlip = AddBlipForRadius(RandomLocation['Coords']['X'], RandomLocation['Coords']['Y'], RandomLocation['Coords']['Z'], 75.0)        
         SetBlipRotation(CurrentRadiosBlip, 0)
         SetBlipColour(CurrentRadiosBlip, 19)
     
         CurrentBlip = AddBlipForCoord(RandomLocation['Coords']['X'], RandomLocation['Coords']['Y'], RandomLocation['Coords']['Z'])
         SetBlipSprite(CurrentBlip, 140)
         SetBlipDisplay(CurrentBlip, 4)
         SetBlipScale(CurrentBlip, 0.7)
         SetBlipColour(CurrentBlip, 0)
         SetBlipAsShortRange(CurrentBlip, true)
         BeginTextCommandSetBlipName('STRING')
         AddTextComponentSubstringPlayerName('Wietveld')
         EndTextCommandSetBlipName(CurrentBlip)
         CurrentLocation = RandomLocation
     end)
    else
        SetRandomLocation()
    end
end

function DryPlant(DryRackId)
    TriggerServerEvent('HD-wiet:server:remove:item21212', 'wet-tak', 2)
    TriggerServerEvent('HD-wiet:server:set:dry:busy', DryRackId, true)
    HDCore.Functions.Progressbar("pick_plant", "Drying...", math.random(6000, 11000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerServerEvent('HD-wiet:server:add:item21212', 'wet-bud', math.random(1,3))
        TriggerServerEvent('HD-wiet:server:set:dry:busy', DryRackId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        HDCore.Functions.Notify("Success!", "success")
    end, function() -- Cancel
        TriggerServerEvent('HD-wiet:server:set:dry:busy', DryRackId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        HDCore.Functions.Notify("Canceled.", "error")
    end) 
end

function PackagePlant(PackerId)
    local WeedItems = Config.WeedSoorten[math.random(#Config.WeedSoorten)]
    TriggerServerEvent('HD-wiet:server:remove:item21212', 'wet-tak', 2)
    TriggerServerEvent('HD-wiet:server:remove:item', 'plastic-bag', 1)
    TriggerServerEvent('HD-wiet:server:set:pack:busy', PackerId, true)
    HDCore.Functions.Progressbar("pick_plant", "Packing...", math.random(3500, 6500), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerServerEvent('HD-wiet:server:add:item21212', WeedItems, 1)
        TriggerServerEvent('HD-wiet:server:set:pack:busy', PackerId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        HDCore.Functions.Notify("Success!", "success")
    end, function() -- Cancel
        TriggerServerEvent('HD-wiet:server:set:pack:busy', PackerId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        HDCore.Functions.Notify("Canceled.", "error")
    end) 
end