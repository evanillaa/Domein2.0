local JailTime = 0
local InJail = false
local AlertSended = false
local isLoggedIn = false
prisonBreak = false
currentGate = 0

local requiredItemsShowed = false
local requiredItems = {}
local inRange = false
local securityLockdown = false
currentLocation = 0
currentBlip = nil
isWorking = false
currentJob = "dozen"

local Gates = {
    [1] = {
        gatekey = 18,
        coords = {x = 1845.99, y = 2604.7, z = 45.58, h = 94.5},  
        hit = false,
    },
    [2] = {
        gatekey = 19,
        coords = {x = 1819.47, y = 2604.67, z = 45.56, h = 98.5},
        hit = false,
    }
    -- [3] = {
    --     gatekey = 20,
    --     coords = {x = 1804.74, y = 2616.311, z = 45.61, h = 335.5},
    --     hit = false,
    -- }
}
HDCore = nil

RegisterNetEvent("HDCore:Client:OnPlayerLoaded")
AddEventHandler("HDCore:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(500, function()
     TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
     Citizen.Wait(150)
     isLoggedIn = true
    end) 
end)

RegisterNetEvent('HDCore:Client:OnPlayerUnload')
AddEventHandler('HDCore:Client:OnPlayerUnload', function()
    InJail = false
    JailTime = 0
    isLoggedIn = false
end)

RegisterNetEvent('HD-prison:client:spawn:prison')
AddEventHandler('HD-prison:client:spawn:prison', function()
  Citizen.SetTimeout(550, function()
    HDCore.Functions.GetPlayerData(function(PlayerData)
     local RandomStartPosition = Config.Locations['Spawns'][math.random(1, #Config.Locations['Spawns'])]
     TriggerEvent('HD-sound:client:play', 'jail-door', 0.5)
     Citizen.Wait(450)
     SetEntityCoords(GetPlayerPed(-1), RandomStartPosition['Coords']['X'], RandomStartPosition['Coords']['Y'], RandomStartPosition['Coords']['Z'] - 0.9, 0, 0, 0, false)
     SetEntityHeading(GetPlayerPed(-1), RandomStartPosition['Coords']['H'])
     Citizen.Wait(1000)
     TriggerEvent('animations:client:EmoteCommandStart', {RandomStartPosition['Animation']})
     Citizen.Wait(2000)
     InJail = true
     JailTime = PlayerData.metadata["jailtime"]
     currentLocation = 1
     if not DoesBlipExist(currentBlip) then
      CreateJobBlip()
   end
     HDCore.Functions.Notify("You are in prison for "..JailTime.." month(s).", "error", 6500)

     DoScreenFadeIn(1000)
    end)
  end)
end)

-- Code

Citizen.CreateThread(function()
  Citizen.Wait(500)
  requiredItems = {
      [1] = {name = HDCore.Shared.Items["electronickit"]["name"], image = HDCore.Shared.Items["electronickit"]["image"]},
      [2] = {name = HDCore.Shared.Items["gatecrack"]["name"], image = HDCore.Shared.Items["gatecrack"]["image"]},
  }
  while true do 
      Citizen.Wait(5)
      inRange = false
      currentGate = 0
      if isLoggedIn and HDCore ~= nil then
          if HDCore.Functions.GetPlayerData().job.name ~= "police" then
              local pos = GetEntityCoords(GetPlayerPed(-1))
              for k, v in pairs(Gates) do
                  local dist = GetDistanceBetweenCoords(pos, Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, true)
                  if (dist < 1.5) then
                      currentGate = k
                      inRange = true
                      if securityLockdown then
                          HDCore.Functions.DrawText3D(Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, "~r~SYSTEM LOCKDOWN")
                      elseif Gates[k].hit then
                          HDCore.Functions.DrawText3D(Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, "SYSTEM BREACH")
                      elseif not requiredItemsShowed then
                          requiredItemsShowed = true
                          TriggerEvent('HD-inventory:client:requiredItems', requiredItems, true)
                      end
                  end
              end

              if not inRange then
                  if requiredItemsShowed then
                      requiredItemsShowed = false
                      TriggerEvent('HD-inventory:client:requiredItems', requiredItems, false)
                  end
                  Citizen.Wait(1000)
              end
          else
              Citizen.Wait(1000)
          end
      else
          Citizen.Wait(5000)
      end
  end
end)

Citizen.CreateThread(function()
while true do
  Citizen.Wait(7)
  local pos = GetEntityCoords(GetPlayerPed(-1), true)
  if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["middle"].coords.x, Config.Locations["middle"].coords.y, Config.Locations["middle"].coords.z, false) > 200.0 and inJail) then
    inJail = false
          jailTime = 0
      RemoveBlip(currentBlip)
          TriggerServerEvent("HD-HD-prison:server:SecurityLockdown")
          HDCore.Functions.Notify("You have escaped the prison .. make you get away!", "error")
  end
end
end)

RegisterNetEvent('electronickit:UseElectronickit')
AddEventHandler('electronickit:UseElectronickit', function()
  if currentGate ~= 0 and not securityLockdown and not Gates[currentGate].hit then 
      HDCore.Functions.TriggerCallback('HDCore:HasItem', function(result)
          if result then 
              TriggerEvent('HD-inventory:client:requiredItems', requiredItems, false)
              HDCore.Functions.Progressbar("hack_gate", "Connect electronic kit..", math.random(5000, 10000), false, true, {
                  disableMovement = true,
                  disableCarMovement = true,
                  disableMouse = false,
                  disableCombat = true,
              }, {
                  animDict = "anim@gangops@facility@servers@",
                  anim = "hotwire",
                  flags = 16,
              }, {}, {}, function() -- Done
                  StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                      TriggerEvent('pepe:numbers:start', math.random(40,60), function(result)
                          if result then
                              TriggerServerEvent("HD-prison:server:SetGateHit", currentGate)
                              TriggerServerEvent('HD-doorlock:server:updateState', Gates[currentGate].gatekey, false)
                          else
                              TriggerServerEvent("HD-prison:server:SecurityLockdown")
                          end
                      end)
              end, function() -- Cancel
                  StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                  HDCore.Functions.Notify("Geannuleerd..", "error")
              end)
          else
              HDCore.Functions.Notify("You miss an item..", "error")
          end
      end, "gatecrack")
  end
end)

RegisterNetEvent('HD-prison:client:SetLockDown')
AddEventHandler('HD-prison:client:SetLockDown', function(isLockdown)
  securityLockdown = isLockdown
  if securityLockDown and inJail then
      TriggerEvent("chatMessage", "JAIL", "error", "Highest security level is active, stay with the cell blocks!")
  end
end)

RegisterNetEvent('HD-prison:client:PrisonBreakAlert')
AddEventHandler('HD-prison:client:PrisonBreakAlert', function()
  TriggerEvent("chatMessage", "ALERT", "error", "Attention All units!Attempted outbreak in prison!")
  local BreakBlip = AddBlipForCoord(Config.Locations["middle"].coords.x, Config.Locations["middle"].coords.y, Config.Locations["middle"].coords.z)
SetBlipSprite(BreakBlip , 161)
SetBlipScale(BreakBlip , 3.0)
SetBlipColour(BreakBlip, 3)
PulseBlip(BreakBlip)
  PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
  Citizen.Wait(100)
  PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
  Citizen.Wait(100)
  PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
  Citizen.Wait(100)
  PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
  Citizen.Wait((1000 * 60 * 5))   
  RemoveBlip(BreakBlip)
end)

RegisterNetEvent('HD-prison:client:SetGateHit')
AddEventHandler('HD-prison:client:SetGateHit', function(key, isHit)
  Gates[key].hit = isHit
end)

-- // Events \\ --

RegisterNetEvent('HD-prison:client:enter:prison')
AddEventHandler('HD-prison:client:enter:prison', function(Time, bool)
    JailTime = Time
    InJail = bool
end)

RegisterNetEvent('HD-prison:client:set:alarm')
AddEventHandler('HD-prison:client:set:alarm', function(bool)
  if bool then
    while not PrepareAlarm("PRISON_ALARMS") do
        Citizen.Wait(10)
    end
    StartAlarm("PRISON_ALARMS", true)
    Citizen.Wait(60 * 1000)
    StopAllAlarms(true)
  else
    StopAllAlarms(true)
  end
end)

RegisterNetEvent('HD-prison:client:leave:prison')
AddEventHandler('HD-prison:client:leave:prison', function()
  local RandomSeat = Config.Locations['Leave-Spawn'][math.random(1, #Config.Locations['Leave-Spawn'])]
  DoScreenFadeOut(1000)
  Citizen.Wait(1000)
  TriggerEvent('HD-sound:client:play', 'jail-cell', 0.2)
  SetEntityCoords(GetPlayerPed(-1), RandomSeat['Coords']['X'], RandomSeat['Coords']['Y'], RandomSeat['Coords']['Z'] - 0.9, 0, 0, 0, false)
  SetEntityHeading(GetPlayerPed(-1), RandomSeat['Coords']['H'])
  Citizen.Wait(250)
  TriggerEvent('animations:client:EmoteCommandStart', {RandomSeat['Animation']})
  Citizen.Wait(2000)
  DoScreenFadeIn(1000)
end)

-- // Loops \\ --

Citizen.CreateThread(function()
	while true do 
    Citizen.Wait(4)
      if isLoggedIn then
        if InJail then
          if JailTime > 0 then
            Citizen.Wait(1000 * 60)
            JailTime = JailTime - 1
            TriggerServerEvent("HD-prison:server:set:jail:state", JailTime)
            if JailTime == 0 and not AlertSended then
              AlertSended = true
              JailTime = 0
              TriggerServerEvent("HD-prison:server:set:jail:leave")
              HDCore.Functions.Notify("Time is out, you can check out at the door!", "success")
            end
          end
        end
      else
        Citizen.Wait(1500)
      end
  end
end)

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(7)
    if isLoggedIn then
      if InJail then
		    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["Prison"]['Coords']['X'], Config.Locations["Prison"]['Coords']['Y'], Config.Locations["Prison"]['Coords']['Z'], false) > 202.0 and InJail) then
          InJail = false
          JailTime = 0
          AlertSended = false
          TriggerServerEvent("HD-prison:server:set:jail:leave")
          TriggerServerEvent('HD-prison:server:set:alarm', true)
          HDCore.Functions.Notify("You have escaped!Get out of this area!", "error")
        else
          Citizen.Wait(5000)
        end
      else
        Citizen.Wait(5000)
      end
   end
	end
end)

Citizen.CreateThread(function()
	while true do
    Citizen.Wait(1)
      if isLoggedIn then
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        InRange = false

        if InJail then

          
           local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Leave']['Coords']['X'], Config.Locations['Leave']['Coords']['Y'], Config.Locations['Leave']['Coords']['Z'], true)
          
           if Distance < 2.5 then
            if JailTime <= 0 then
              DrawText3D(Config.Locations['Leave']['Coords']['X'], Config.Locations['Leave']['Coords']['Y'], Config.Locations['Leave']['Coords']['Z'] + 0.1, '~g~E~s~ - Leave')
              if IsControlJustReleased(0, 38) then
                InJail = false
                AlertSended = false
                TriggerServerEvent("HD-prison:server:get:items:back")
                TriggerServerEvent("HD-prison:server:set:jail:leave")
                TriggerEvent('HD-prison:client:leave:prison')
              end
            else
              DrawText3D(Config.Locations['Leave']['Coords']['X'], Config.Locations['Leave']['Coords']['Y'], Config.Locations['Leave']['Coords']['Z'] + 0.1, 'Wait still: ~r~'..JailTime.. '~s~ Month(s)')
            end
               DrawMarker(2, Config.Locations['Leave']['Coords']['X'], Config.Locations['Leave']['Coords']['Y'], Config.Locations['Leave']['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
             InRange = true
           end
   
           for k, v in pairs(Config.Locations['Search']) do
           local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
             if Distance < 2.5 then
               DrawMarker(2, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)     
               DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z']+0.1, '~g~E~s~ - ??')
               if IsControlJustReleased(0, 38) then
                 SearchPlace(v['Reward'], v['Chance'])
               end
               InRange = true
             end
           end

              local DistanceInleveren = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Inleveren']['Coords']['X'], Config.Locations['Inleveren']['Coords']['Y'], Config.Locations['Inleveren']['Coords']['Z'], true)
          
              if DistanceInleveren < 2.5 then
                 DrawText3D(Config.Locations['Inleveren']['Coords']['X'], Config.Locations['Inleveren']['Coords']['Y'], Config.Locations['Inleveren']['Coords']['Z'] + 0.1, '~g~E~s~ - To hand in')
                 if IsControlJustReleased(0, 38) then
                  Inleveren()
                 end
                  DrawMarker(2, Config.Locations['Inleveren']['Coords']['X'], Config.Locations['Inleveren']['Coords']['Y'], Config.Locations['Inleveren']['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                InRange = true
              end
 
          
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Shop']['Coords']['X'], Config.Locations['Shop']['Coords']['Y'], Config.Locations['Shop']['Coords']['Z'], true)
              if Distance < 2.5 then
                DrawMarker(2, Config.Locations['Shop']['Coords']['X'], Config.Locations['Shop']['Coords']['Y'], Config.Locations['Shop']['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)     
                DrawText3D(Config.Locations['Shop']['Coords']['X'], Config.Locations['Shop']['Coords']['Y'], Config.Locations['Shop']['Coords']['Z']+0.1, '~g~E~s~ - Canteen')
                if IsControlJustReleased(0, 38) then
                  TriggerServerEvent("HD-inventory:server:OpenInventory", "shop", "prison", Config.Items)
                end
                InRange = true
              end
           

              for k, v in pairs(Config.Locations['Jobs']) do
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                --local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations.jobs[currentLocation].coords.x, Config.Locations.jobs[currentLocation].coords.y, Config.Locations.jobs[currentLocation].coords.z, true)
                  if Distance < 2.5 then
                    InRange = true
                    DrawMarker(2, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)     
                    DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z']+0.1, '~g~E~s~ - Take box')
                    if IsControlJustReleased(0, 38) then
                      HDCore.Functions.Progressbar("doospakken", "Grabbing Box", math.random(5000, 10000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "anim@gangops@facility@servers@",
                        anim = "hotwire",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        isWorking = false
                        StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                        JobDone()
                        PickupPackage()
                    end, function() -- Cancel
                        isWorking = false
                        StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                        HDCore.Functions.Notify("Canceled..", "error")
                    end)
                    end
                  end
                --end
              end

           if not InRange then
             Citizen.Wait(1500)
           end

      else
        Citizen.Wait(1500)
      end
    else
      Citizen.Wait(1500)
     end
    end
end)

-- // Functions \\ --
function PickupPackage()
  local pos = GetEntityCoords(GetPlayerPed(-1), true)
  RequestAnimDict("anim@heists@box_carry@")
  while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
      Citizen.Wait(7)
  end
  TaskPlayAnim(GetPlayerPed(-1), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
  local model = GetHashKey("prop_cs_cardbox_01")
  RequestModel(model)
  while not HasModelLoaded(model) do Citizen.Wait(0) end
  local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
  AttachEntityToEntity(object, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.05, 0.1, -0.3, 300.0, 250.0, 20.0, true, true, false, true, 1, true)
  carryPackage = object
end

function DropPackage()
  ClearPedTasks(GetPlayerPed(-1))
  DetachEntity(carryPackage, true, true)
  DeleteObject(carryPackage)
  carryPackage = nil
end

function SearchPlace(Reward, Chance)
  local Label = 'Zoeken..'
  if Reward == 'slushy' then
    Label = 'Slushy maken..'
  end
  HDCore.Functions.Progressbar("search-jail", Label, math.random(5000, 6500), false, true, {
      disableMovement = false,
      disableCarMovement = true,
      disableMouse = false,
      disableCombat = true,
  }, {}, {}, {}, function() -- Done
    if math.random(1,100) < Chance then
      -- GiveItem Reward
      TriggerServerEvent('HD-prison:server:find:reward', Reward)
      HDCore.Functions.Notify("Wow that's cool!", "success")
    else
      HDCore.Functions.Notify("Found nothing.", "error") 
    end
  end, function() -- Cancel
    HDCore.Functions.Notify("Canceled.", "error") 
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

 function GetInJailStatus()
  return InJail
 end
 
function Inleveren()
  if math.random(1, 100) <= 30 then
      HDCore.Functions.Notify("You have received some sentence reduction")
      JailTime = JailTime - math.random(1, 2)
      TriggerServerEvent("HD-prison:server:set:jail:state", JailTime)
      HDCore.Functions.Notify("You are still in prison for "..JailTime.." month(s).", "error", 6500)
  end
  local newLocation = math.random(1, #Config.Locations['Jobs'])
  while (newLocation == currentLocation) do
      Citizen.Wait(100)
      newLocation = math.random(1, #Config.Locations['Jobs'])
  end
  DropPackage()
  currentLocation = newLocation
  CreateJobBlip()
end

function JobDone()
      HDCore.Functions.Notify("Hand in the box to the canteen.")
  local newLocation = Config.Locations['Inleveren']
  currentLocation = newLocation
  --CreateJobBlip()
end

function CreateJobBlip()
  if currentLocation ~= 0 then
      if DoesBlipExist(currentBlip) then
          RemoveBlip(currentBlip)
      end
      currentBlip = AddBlipForCoord(Config.Locations['Jobs'][currentLocation]['Coords']['X'], Config.Locations['Jobs'][currentLocation]['Coords']['Y'], Config.Locations['Jobs'][currentLocation]['Coords']['Z'])

      SetBlipSprite (currentBlip, 402)
      SetBlipDisplay(currentBlip, 4)
      SetBlipScale  (currentBlip, 0.8)
      SetBlipAsShortRange(currentBlip, true)
      SetBlipColour(currentBlip, 1)
  
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentSubstringPlayerName("Work")
      EndTextCommandSetBlipName(currentBlip)
  end
  
end