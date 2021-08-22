local LoggedIn = false

HDCore = nil

RegisterNetEvent("HDCore:Client:OnPlayerLoaded")
AddEventHandler("HDCore:Client:OnPlayerLoaded", function()
  Citizen.SetTimeout(650, function()
      TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)   
      Citizen.Wait(200)
      HDCore.Functions.TriggerCallback('HD-copper:server:GetConfig', function(config)
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

RegisterNetEvent('HD-copper:client:set:plant:busy')
AddEventHandler('HD-copper:client:set:plant:busy',function(PlantId, bool)
    Config.Plants['planten']['IsBezig'] = bool
end)

RegisterNetEvent('HD-copper:client:set:picked:state')
AddEventHandler('HD-copper:client:set:picked:state',function(PlantId, bool)
    Config.Plants['planten']['Geplukt'] = bool
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
            if not NearAnything then
                Citizen.Wait(2500)
            end
        end
    end
end)

-- Functions 

function PickPlant(PlantId)
    HDCore.Functions.TriggerCallback('HD-copper:server:HasItem', function(HasItem)
        if HasItem then
            TriggerServerEvent('HD-copper:server:set:plant:busy', PlantId, true)
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
                TriggerServerEvent('HD-copper:server:set:plant:busy', PlantId, false)
                TriggerServerEvent('HD-copper:server:set:picked:state', PlantId, true)
                TriggerServerEvent('HD-copper:server:give:tak')
                StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
                HDCore.Functions.Notify("Gelukt", "success")
            end, function() -- Cancel
                TriggerServerEvent('HD-copper:server:set:plant:busy', PlantId, false)
                StopAnimTask(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)
                HDCore.Functions.Notify("Geannuleerd..", "error")
            end)
        else
            HDCore.Functions.Notify("Je mist iets..", "error")
        end
    end, "betonschaar")
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