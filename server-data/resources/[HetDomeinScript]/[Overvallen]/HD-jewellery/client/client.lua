local LoggedIn = false
local NearHack = false
local CurrentCops = nil
local HasAlertSend = false

HDCore = nil
  
RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
     TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
       Citizen.Wait(150)
     HDCore.Functions.TriggerCallback("HD-jewellery:server:GetConfig", function(config)
      Config = config
     end)
     LoggedIn = true
    end) 
end)

RegisterNetEvent('HD-police:SetCopCount')
AddEventHandler('HD-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)

RegisterNetEvent('HD-jewellery:client:set:vitrine:isopen')
AddEventHandler('HD-jewellery:client:set:vitrine:isopen', function(CaseId, bool)
    Config.Vitrines[CaseId]["IsOpen"]= bool
end)

RegisterNetEvent('HD-jewellery:client:set:vitrine:busy')
AddEventHandler('HD-jewellery:client:set:vitrine:busy', function(CaseId, bool)
    Config.Vitrines[CaseId]["IsBusy"] = bool
end)

RegisterNetEvent('HD-jewellery:client:set:cooldown')
AddEventHandler('HD-jewellery:client:set:cooldown',function(bool)
    Config.Cooldown = bool
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
         local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
         local Distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.Locations['use-card']["Coords"]["X"], Config.Locations['use-card']["Coords"]["Y"], Config.Locations['use-card']["Coords"]["Z"], true)
         NearHack = false
         if Distance <= 1.5 then 
            NearHack = true
            DrawMarker(2, Config.Locations['use-card']["Coords"]["X"], Config.Locations['use-card']["Coords"]["Y"], Config.Locations['use-card']["Coords"]["Z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 3, 252, 32, 255, false, false, false, 1, false, false, false)
        end
         if not NearHack then
            Citizen.Wait(1500)
         end
    end
end)

-- Code

-- // Events \\ --

RegisterNetEvent('HD-jewellery:client:use:card')
AddEventHandler('HD-jewellery:client:use:card', function()
    local CurrentTime = GetClockHours()
        if NearHack then
          if CurrentTime >= 0 and CurrentTime <= 6 then
              if CurrentCops >= Config.PoliceNeeded then
                if not Config.Cooldown then
                    HDCore.Functions.TriggerCallback('HDCore:HasItem', function(HasItem)
                        if HasItem then
                            TriggerEvent('HD-inventory:client:set:busy', true)
                            TriggerServerEvent('HD-jewellery:server:set:cooldown', true)
                            StartMiniGame()
                        else
                            HDCore.Functions.Notify("Je mist iets..", "error")
                        end
                      end, "electronickit")
                else
                  HDCore.Functions.Notify("Beveiligings slot is nog actief..", "error")
                end
              else
               HDCore.Functions.Notify("Niet genoeg agenten! ("..Config.PoliceNeeded.." Nodig)", "info")
              end
          else
              HDCore.Functions.Notify("Het is nog niet de juiste tijd..", "error")
        end
    end
end)

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            InRange = false
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                local JewelleryDist = GetDistanceBetweenCoords(PlayerCoords, Config.Locations['store']["Coords"]["X"], Config.Locations['store']["Coords"]["Y"], Config.Locations['store']["Coords"]["Z"], true)
                if JewelleryDist < 30.0 then
                    if HDCore.Functions.GetPlayerData().job.name ~= 'police' and HDCore.Functions.GetPlayerData().job.onduty or HDCore.Functions.GetPlayerData().job.name == "police" and not HDCore.Functions.GetPlayerData().job.onduty then
                    for k, v in pairs(Config.Vitrines) do
                        local VitrineDist = GetDistanceBetweenCoords(PlayerCoords, Config.Vitrines[k]["Coords"]["X"], Config.Vitrines[k]["Coords"]["Y"], Config.Vitrines[k]["Coords"]["Z"], true)
                        if VitrineDist < 0.6 then
                            InRange = true
                            if not Config.Vitrines[k]["IsOpen"] and not Config.Vitrines[k]["IsBusy"] then
                                DrawText3D(Config.Vitrines[k]["Coords"]["X"], Config.Vitrines[k]["Coords"]["Y"], Config.Vitrines[k]["Coords"]["Z"], '~g~E~s~ - Vitrine in slaan')
                                if IsControlJustReleased(0, 38) then
                                    if HasValidWeapon() then
                                        if not HasAlertSend then
                                            HasAlertSend = true
                                            TriggerServerEvent('HD-police:server:send:alert:jewellery', GetEntityCoords(GetPlayerPed(-1)), HDCore.Functions.GetStreetLabel())
                                         end
                                        SmashGlass(k)
                                    else
                                        HDCore.Functions.Notify("Dit wapen is niet sterk genoeg..", "error")
                                    end
                                end
                            else
                                Citizen.Wait(200)
                            end
                        end
                    end
                else
                    Citizen.Wait(500)
                end
             else
                Citizen.Wait(1500)
             end
           if not InRange then
            Citizen.Wait(500)
           end
        end
    end
end)

-- // Functions \\ --

function StartMiniGame()
    exports['minigame-phone']:ShowHack()
    exports['minigame-phone']:StartHack(math.random(1,4), math.random(8,12), function(Success)
        if Success then
            TriggerServerEvent('HD-doorlock:server:updateState', 66, false)
            TriggerServerEvent('HDCore:Server:RemoveItem', 'yellow-card', 1)
            TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['yellow-card'], "remove")
            TriggerEvent('HD-inventory:client:set:busy', false)
        else
            HDCore.Functions.Notify("Je hebt gefaalt..", "error")
            TriggerServerEvent('HD-jewellery:server:set:cooldown', false)
            TriggerEvent('HD-inventory:client:set:busy', false)
        end
        exports['minigame-phone']:HideHack()
    end)
end

function SmashGlass(CaseId)
    local Smashing = true
    LoadParticles()
    TriggerServerEvent('HD-jewellery:server:set:vitrine:busy', CaseId, true)
    StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", GetEntityCoords(GetPlayerPed(-1)).x, GetEntityCoords(GetPlayerPed(-1)).y, GetEntityCoords(GetPlayerPed(-1)).z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    HDCore.Functions.Progressbar("smash_vitrine", "Vitrine aan het inslaan..", 15000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        Smashing = false
        TriggerServerEvent('HD-jewellery:vitrine:reward')
        TriggerServerEvent('HD-jewellery:server:start:reset')
        TriggerServerEvent('HD-jewellery:server:set:vitrine:isopen', CaseId, true)
        TriggerServerEvent('HD-jewellery:server:set:vitrine:busy', CaseId, false)
        TaskPlayAnim(GetPlayerPed(-1), "missheist_jewel", "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end, function() -- Cancel
        Smashing = false
        TriggerServerEvent('HD-jewellery:server:set:vitrine:busy', CaseId, false)
        TaskPlayAnim(GetPlayerPed(-1), "missheist_jewel", "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end)
    while Smashing do
        exports['HD-assets']:RequestAnimationDict("missheist_jewel")
        TaskPlayAnim(GetPlayerPed(-1), "missheist_jewel", "smash_case", 3.0, 3.0, -1, 2, 0, 0, 0, 0 )
        Citizen.Wait(500)
        TriggerEvent("HD-sound:client:play", "jewellery-glass", 0.25)
        LoadParticles()
        TriggerServerEvent('HD-hud:server:gain:stress', math.random(1, 3))
        StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 0.6, 0).x, GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 0.6, 0).y, GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 0.6, 0).z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        Citizen.Wait(2500)
    end
end

function HasValidWeapon()
  local CurrentWeapon = GetSelectedPedWeapon(GetPlayerPed(-1))
  for k, v in pairs(Config.VitrineWeapons) do
    if CurrentWeapon == v then
        return true
    end
  end
end

function LoadParticles()
 if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
    RequestNamedPtfxAsset("scr_jewelheist")
 end
 while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
    Citizen.Wait(0)
 end
 SetPtfxAssetNextCall("scr_jewelheist")
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