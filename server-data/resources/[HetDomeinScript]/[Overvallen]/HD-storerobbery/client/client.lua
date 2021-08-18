local OpeningRegister = false
local CurrentSafe = nil
local CurrentRegister = nil
local CurrentCops = 0
local isLoggedIn = false

HDCore = nil
 
RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
  Citizen.SetTimeout(1250, function()
      TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
       Citizen.Wait(100)
      HDCore.Functions.TriggerCallback("HD-storerobbery:server:get:config", function(config)
      Config = config
      end)
      isLoggedIn = true
  end)
end)

RegisterNetEvent('HD-police:SetCopCount')
AddEventHandler('HD-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)

-- Code

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(4)
        if isLoggedIn then
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            InRange = false
            for k, v in pairs(Config.Registers) do
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                if Distance < 1.2 then
                 InRange = true
                  if v['Robbed'] then
                    DrawText3D(v['X'], v['Y'], v['Z'], '~r~De kassa is leeg...')
                  elseif v['Busy'] then
                    DrawText3D(v['X'], v['Y'], v['Z'], 'Openen...')
                  end
               end
            end
            if not InRange then
                Citizen.Wait(1500)
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(4)
        if isLoggedIn then
             local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
             InRange = false
             for k, v in pairs(Config.Safes) do
                 local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                 if Distance < 1.5 then
                  InRange = true
                   if v['Robbed'] then
                     DrawText3D(v['X'], v['Y'], v['Z'], '~r~De kluis is leeg...')
                   elseif v['Busy'] then
                     DrawText3D(v['X'], v['Y'], v['Z'], 'Openen...')
                   else
                     DrawText3D(v['X'], v['Y'], v['Z'], '~g~E~s~ - Combinatie Proberen')
                    if IsControlJustReleased(0, Config.Keys["E"]) then
                        if CurrentCops >= Config.PoliceNeeded then
                           OpenKeyPad(k)
                        else
                            HDCore.Functions.Notify("Niet genoeg agenten! ("..Config.PoliceNeeded.." Nodig)", "info")
                        end
                    end
                   end
                end
             end
             if not InRange then
                 Citizen.Wait(1500)
             end
            else
             Citizen.Wait(1500)
         end
    end
end)

-- // Events \\ --

RegisterNetEvent('HD-storerobbery:client:set:register:robbed')
AddEventHandler('HD-storerobbery:client:set:register:robbed', function(RegisterId, bool)
    Config.Registers[RegisterId]['Robbed'] = bool
end)

RegisterNetEvent('HD-storerobbery:client:set:register:busy')
AddEventHandler('HD-storerobbery:client:set:register:busy', function(RegisterId, bool)
    Config.Registers[RegisterId]['Busy'] = bool
end)

RegisterNetEvent('HD-storerobbery:client:safe:busy')
AddEventHandler('HD-storerobbery:client:safe:busy', function(SafeId, bool)
    Config.Safes[SafeId]['Busy'] = bool
end)

RegisterNetEvent('HD-storerobbery:client:safe:robbed')
AddEventHandler('HD-storerobbery:client:safe:robbed', function(SafeId, bool)
    Config.Safes[SafeId]['Robbed'] = bool
end)

RegisterNetEvent('HD-items:client:use:lockpick')
AddEventHandler('HD-items:client:use:lockpick', function(IsAdvanced)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    for k, v in pairs(Config.Registers) do
        local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
        if Distance < 1.3 and not v['Robbed'] then
         if CurrentCops >= Config.PoliceNeeded then
                if IsAdvanced then
                    CurrentRegister = k
                    LockPickRegister(k, IsAdvanced)
                else
                    HDCore.Functions.TriggerCallback('HD-storerobbery:server:HasItem', function(HasItem)
                        if HasItem then
                            CurrentRegister = k
                            LockPickRegister(k, IsAdvanced)
                        else
                            HDCore.Functions.Notify("Je mist iets..", "error")
                        end
                    end, "toolkit") 
                end
            else
                HDCore.Functions.Notify("Niet genoeg agenten! ("..Config.PoliceNeeded.." Nodig)", "info")
            end
        end
    end
end)

-- Function

function LockPickRegister(RegisterId, IsAdvanced)
 local LockPickTime = math.random(15000, 25000)

 if not IsWearingHandshoes() then
    TriggerServerEvent("HD-police:server:CreateFingerDrop", GetEntityCoords(GetPlayerPed(-1)))
 end

 if math.random(1,100) < 40 then
    local StreetLabel = HDCore.Functions.GetStreetLabel()
    TriggerServerEvent('HD-police:server:send:alert:store', GetEntityCoords(GetPlayerPed(-1)), StreetLabel, Config.Registers[RegisterId]['SafeKey'])
 end

 TriggerServerEvent('HD-storerobbery:server:set:register:busy', RegisterId, true)
 exports['HD-lockpick']:OpenLockpickGame(function(Success)
     if Success then
         LockPickRegisterAnim(LockPickTime)
         TriggerServerEvent('HD-storerobbery:server:set:register:robbed', RegisterId, true)
         TriggerServerEvent('HD-storerobbery:server:set:register:busy', RegisterId, false)
         HDCore.Functions.Progressbar("search_register", "Kassa leeghalen..", LockPickTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done    
            OpeningRegister = false
            CurrentRegister = nil
            TriggerServerEvent('HD-storerobbery:server:rob:register', RegisterId, true)
        end, function() -- Cancel
            OpeningRegister = false
            CurrentRegister = nil
            TriggerServerEvent('HD-storerobbery:server:set:register:busy', RegisterId, false)
        end)
     else
        if IsAdvanced then
            if math.random(1,100) <= 19 then
              TriggerServerEvent('HD-police:server:CreateBloodDrop', GetEntityCoords(GetPlayerPed(-1)))
              TriggerServerEvent('HDCore:Server:RemoveItem', 'advancedlockpick', 1)
              TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['advancedlockpick'], "remove")
            end
        else
            if math.random(1,100) <= 35 then
              TriggerServerEvent('HD-police:server:CreateBloodDrop', GetEntityCoords(GetPlayerPed(-1)))
              TriggerServerEvent('HDCore:Server:RemoveItem', 'lockpick', 1)
              TriggerEvent("HD-inventory:client:ItemBox", HDCore.Shared.Items['lockpick'], "remove")
            end
        end
        HDCore.Functions.Notify("Mislukt..", "error")
        TriggerServerEvent('HD-storerobbery:server:set:register:busy', RegisterId, false)
     end
 end)
end

function LockPickRegisterAnim(time)
 time = time / 1000
 exports['HD-assets']:RequestAnimationDict("veh@break_in@0h@p_m_one@")
 TaskPlayAnim(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
 OpeningRegister = true
 Citizen.CreateThread(function()
     while OpeningRegister do
         --TriggerServerEvent('HD-hud:server:gain:stress', math.random(1, 2))
         TriggerServerEvent('HD-storerobbery:server:rob:register', CurrentRegister, false)  
         TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
         Citizen.Wait(2000)
         time = time - 2
         if time <= 0 then
             OpeningRegister = false
             StopAnimTask(GetPlayerPed(-1), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
         end
     end
 end)
end

function TakeAnimation()
 exports['HD-assets']:RequestAnimationDict("amb@prop_human_bum_bin@idle_b")
 TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
 Citizen.Wait(1500)
 TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
end

function OpenKeyPad(SafeId)
  CurrentSafe = SafeId
  SendNUIMessage({action = "open"})
  SetNuiFocus(true, true)
  if math.random(1,100) < 40 then
    local StreetLabel = HDCore.Functions.GetStreetLabel()
    TriggerServerEvent('HD-police:server:send:alert:store', GetEntityCoords(GetPlayerPed(-1)), StreetLabel, SafeId)
  end
  TriggerServerEvent('HD-storerobbery:server:safe:busy', CurrentSafe, true)
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

function IsWearingHandshoes()
  local armIndex = GetPedDrawableVariation(GetPlayerPed(-1), 3)
  local model = GetEntityModel(GetPlayerPed(-1))
  local retval = true
  if model == GetHashKey("mp_m_freemode_01") then
      if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
          retval = false
      end
  else
      if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
          retval = false
      end
  end
  return retval
end

RegisterNUICallback('PinpadClose', function(data)
  TriggerServerEvent('HD-storerobbery:server:safe:busy', CurrentSafe, false)
  SetNuiFocus(false, false)
  Citizen.SetTimeout(150, function()
    if data.EnteredCode then
      CurrentSafe = nil
    end
  end)
end)

RegisterNUICallback('ErrorMessage', function(data)
    HDCore.Functions.Notify(data.message, 'error')
end)

RegisterNUICallback('EnterPincode', function(data)
  HDCore.Functions.TriggerCallback('HD-storerobbery:server:safe:code', function(code)
      if tonumber(data.pin) ~= nil then
          if tonumber(data.pin) == code then
              TriggerServerEvent('HD-hud:server:gain:stress', math.random(0, 2))
              TriggerServerEvent("HD-storerobbery:server:safe:reward", CurrentSafe)
              TriggerServerEvent('HD-storerobbery:server:safe:busy', CurrentSafe, false)
              TriggerServerEvent("HD-storerobbery:server:safe:robbed", CurrentSafe, true)
              CurrentSafe = nil
              TakeAnimation()
          else
              PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
              TriggerServerEvent('HD-storerobbery:server:safe:busy', CurrentSafe, false)
              CurrentSafe = nil
          end
      end
  end, CurrentSafe)  
end)

RegisterNUICallback('Click', function(data)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('ClickFail', function(data)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)