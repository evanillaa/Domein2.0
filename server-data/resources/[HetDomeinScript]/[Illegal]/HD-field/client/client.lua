local LoggedIn = false

HDCore = nil

RegisterNetEvent("HDCore:Client:OnPlayerLoaded")
AddEventHandler("HDCore:Client:OnPlayerLoaded", function()
  Citizen.SetTimeout(650, function()
      TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)   
      Citizen.Wait(200)
      HDCore.Functions.TriggerCallback('HD-field:server:GetConfig', function(config)
          Config = config
      end) 
      LoggedIn = true
  end)
end)

RegisterNetEvent('HDCore:Client:OnPlayerUnload')
AddEventHandler('HDCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

RegisterNetEvent('HD-field:client:set:plant:busy')
AddEventHandler('HD-field:client:set:plant:busy',function(PlantId, bool)
    Config.Plants['planten'][PlantId]['IsBezig'] = bool
end)

RegisterNetEvent('HD-field:client:set:picked:state')
AddEventHandler('HD-field:client:set:picked:state',function(PlantId, bool)
    Config.Plants['planten'][PlantId]['Geplukt'] = bool
end)

RegisterNetEvent('HD-field:client:set:dry:busy')
AddEventHandler('HD-field:client:set:dry:busy',function(DryRackId, bool)
    Config.Plants['drogen'][DryRackId]['IsBezig'] = bool
end)

RegisterNetEvent('HD-field:client:set:pack:busy')
AddEventHandler('HD-field:client:set:pack:busy',function(PackerId, bool)
    Config.Plants['verwerk'][PackerId]['IsBezig'] = bool
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
         local SpelerCoords = GetEntityCoords(GetPlayerPed(-1))
            NearAnything = false
            for k, v in pairs(Config.Plants["planten"]) do
                local PlantDistance = GetDistanceBetweenCoords(SpelerCoords.x, SpelerCoords.y, SpelerCoords.z, Config.Plants["planten"][k]['x'], Config.Plants["planten"][k]['y'], Config.Plants["planten"][k]['z'], true)
                if PlantDistance < 1.2 then
                NearAnything = true
                 if IsControlJustPressed(0, Config.Keys['E']) then
                    if not Config.Plants['planten'][k]['IsBezig'] then
                        if not Config.Plants['planten'][k]['Geplukt'] then
                          PickPlant(k)
                        else
                          HDCore.Functions.Notify("Het lijkt erop dat deze al geplukt is..", "error")
                      end
                    else
                     HDCore.Functions.Notify("Het lijkt erop dat iemand deze plant al aan het plukken is..", "error")
                 end
            end
            end
            end

            for k, v in pairs(Config.Plants["drogen"]) do
                local PlantDistance = GetDistanceBetweenCoords(SpelerCoords.x, SpelerCoords.y, SpelerCoords.z, Config.Plants["drogen"][k]['x'], Config.Plants["drogen"][k]['y'], Config.Plants["drogen"][k]['z'], true)
                if PlantDistance < 1.2 then
                 NearAnything = true
                 DrawMarker(2, Config.Plants["drogen"][k]['x'], Config.Plants["drogen"][k]['y'], Config.Plants["drogen"][k]['z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                 DrawText3D(Config.Plants["drogen"][k]['x'], Config.Plants["drogen"][k]['y'], Config.Plants["drogen"][k]['z'] + 0.15, '~g~E~w~ - Verwerken')
                 if IsControlJustPressed(0, Config.Keys['E']) then
                  if not Config.Plants['drogen'][k]['IsBezig'] then
                    HDCore.Functions.TriggerCallback('HD-field:server:has:takken', function(HasTak)
                      if HasTak then
                          DryPlant(k)
                      else
                          HDCore.Functions.Notify("Je mist iets..", "error")
                      end
                  end)
              else
                  HDCore.Functions.Notify("Er is al iemand met de droger bezig..", "error")
              end
            end
            end
            end

            for k, v in pairs(Config.Plants["verwerk"]) do
                local PlantDistance = GetDistanceBetweenCoords(SpelerCoords.x, SpelerCoords.y, SpelerCoords.z, Config.Plants["verwerk"][k]['x'], Config.Plants["verwerk"][k]['y'], Config.Plants["verwerk"][k]['z'], true)
                if PlantDistance < 1.2 then
                NearAnything = true
                 DrawMarker(2, Config.Plants["verwerk"][k]['x'], Config.Plants["verwerk"][k]['y'], Config.Plants["verwerk"][k]['z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                 DrawText3D(Config.Plants["verwerk"][k]['x'], Config.Plants["verwerk"][k]['y'], Config.Plants["verwerk"][k]['z'] + 0.15, '~g~E~w~ - Verpakken')
                 if IsControlJustPressed(0, Config.Keys['E']) then
                  if not Config.Plants['verwerk'][k]['IsBezig'] then
                    HDCore.Functions.TriggerCallback('HD-field:server:has:nugget', function(HasNugget)
                      if HasNugget then
                          PackagePlant(k)
                      else
                          HDCore.Functions.Notify("Je mist iets..", "error")
                      end
                  end)
              else
                  HDCore.Functions.Notify("Er is al iemand met de verpaker bezig..", "error")
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


-- Functions 

function PickPlant(PlantId)
    HDCore.Functions.TriggerCallback('HD-field:server:HasItem', function(HasItem)
        if HasItem then
            TriggerServerEvent('HD-field:server:set:plant:busy', PlantId, true)
            HDCore.Functions.Progressbar("pick_plant", "Knippen..", math.random(3500, 6500), false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "amb@prop_human_bum_bin@idle_b",
                anim = "idle_d",
                flags = 16,
            }, {}, {}, function() -- Done
                TriggerServerEvent('HD-field:server:set:plant:busy', PlantId, false)
                TriggerServerEvent('HD-field:server:set:picked:state', PlantId, true)
                TriggerServerEvent('HD-field:server:give:tak')
                StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
                HDCore.Functions.Notify("Gelukt", "success")
            end, function() -- Cancel
                TriggerServerEvent('HD-field:server:set:plant:busy', PlantId, false)
                StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
                HDCore.Functions.Notify("Geannuleerd..", "error")
            end)
        else
            HDCore.Functions.Notify("Je mist iets..", "error")
        end
    end, "tuinschaar")
end

function DryPlant(DryRackId)
    TriggerServerEvent('HD-field:server:remove:item', 'wet-tak', 2)
    TriggerServerEvent('HD-field:server:set:dry:busy', DryRackId, true)
    HDCore.Functions.Progressbar("pick_plant", "Drogen..", math.random(6000, 11000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerServerEvent('HD-field:server:add:item', 'wet-bud', math.random(1,3))
        TriggerServerEvent('HD-field:server:set:dry:busy', DryRackId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        HDCore.Functions.Notify("Gelukt", "success")
    end, function() -- Cancel
        TriggerServerEvent('HD-field:server:set:dry:busy', DryRackId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        HDCore.Functions.Notify("Geannuleerd..", "error")
    end) 
end

function PackagePlant(PackerId)
    local WeedItems = Config.WeedSoorten[math.random(#Config.WeedSoorten)]
    TriggerServerEvent('HD-field:server:remove:item', 'wet-bud', 2)
    TriggerServerEvent('HD-field:server:remove:item', 'plastic-bag', 1)
    TriggerServerEvent('HD-field:server:set:pack:busy', PackerId, true)
    HDCore.Functions.Progressbar("pick_plant", "Verpakken..", math.random(3500, 6500), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        TriggerServerEvent('HD-field:server:add:item', WeedItems, 1)
        TriggerServerEvent('HD-field:server:set:pack:busy', PackerId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        HDCore.Functions.Notify("Gelukt", "success")
    end, function() -- Cancel
        TriggerServerEvent('HD-field:server:set:pack:busy', PackerId, false)
        StopAnimTask(GetPlayerPed(-1), "anim@narcotics@trash", "drop_front", 1.0)
        HDCore.Functions.Notify("Geannuleerd..", "error")
    end) 
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