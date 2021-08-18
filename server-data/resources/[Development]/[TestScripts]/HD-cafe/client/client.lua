local CurrentWorkObject = {}
local LoggedIn = false
local InRange = false
local HDCore = nil  

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
        Citizen.Wait(450)
        LoggedIn = true
    end)
end)

RegisterNetEvent('HDCore:Client:OnPlayerUnload')
AddEventHandler('HDCore:Client:OnPlayerUnload', function()
	RemoveWorkObjects()
  LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(4)
      if LoggedIn then
          local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
          local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, -1193.70, -892.50, 13.99, true)
          InRange = false
          if Distance < 40.0 then
              InRange = true
              if not Config.EntitysSpawned then
                  Config.EntitysSpawned = true
                  SpawnWorkObjects()
              end
          end
          if not InRange then
              if Config.EntitysSpawned then
                Config.EntitysSpawned = false
                RemoveWorkObjects()
              end
              CheckDuty()
              Citizen.Wait(1500)
          end
      end
  end
end)

RegisterNetEvent('HD-cafe:client:refresh:props')
AddEventHandler('HD-cafe:client:refresh:props', function()
  if InRange and Config.EntitysSpawned then
     RemoveWorkObjects()
     Citizen.SetTimeout(1000, function()
        SpawnWorkObjects()
     end)
  end
end)

RegisterNetEvent('HD-cafe:client:open:payment')
AddEventHandler('HD-cafe:client:open:payment', function()
  SetNuiFocus(true, true)
  SendNUIMessage({action = 'OpenPayment', payments = Config.ActivePayments})
end)

RegisterNetEvent('HD-cafe:client:open:register')
AddEventHandler('HD-cafe:client:open:register', function()
  SetNuiFocus(true, true)
  SendNUIMessage({action = 'OpenRegister'})
end)

RegisterNetEvent('HD-cafe:client:sync:register')
AddEventHandler('HD-cafe:client:sync:register', function(RegisterConfig)
  Config.ActivePayments = RegisterConfig
end)

RegisterNetEvent('HD-cafe:client:open:cold:storage')
AddEventHandler('HD-cafe:client:open:cold:storage', function()
    TriggerServerEvent("HD-inventory:server:OpenInventory", "stash", "burger_storage", {maxweight = 1000000, slots = 10})
    TriggerEvent("HD-inventory:client:SetCurrentStash", "burger_storage")
end)

RegisterNetEvent('HD-cafe:client:open:tray')
AddEventHandler('HD-cafe:client:open:tray', function(Numbers)
    TriggerServerEvent("HD-inventory:server:OpenInventory", "stash", "foodtray"..Numbers, {maxweight = 100000, slots = 3})
    TriggerEvent("HD-inventory:client:SetCurrentStash", "foodtray"..Numbers)
end)

RegisterNetEvent('HD-cafe:client:create:burger')
AddEventHandler('HD-cafe:client:create:burger', function(BurgerType)
  HDCore.Functions.TriggerCallback('HD-cafe:server:has:burger:items', function(HasCafeItems)
    if HasCafeItems then
       MakeBurger(BurgerType)
    else
      HDCore.Functions.Notify("Je mist ingredienten om dit broodje te maken..", "error")
    end
  end)
end)

function SpawnWorkObjects()
    for k, v in pairs(Config.WorkProps) do
      exports['HD-assets']:RequestModelHash(v['Prop'])
      WorkObject = CreateObject(GetHashKey(v['Prop']), v["Coords"]["X"], v["Coords"]["Y"], v["Coords"]["Z"], false, false, false)
      SetEntityHeading(WorkObject, v['Coords']['H'])
      if v['PlaceOnGround'] then
          PlaceObjectOnGroundProperly(WorkObject)
      end
      if not v['ShowItem'] then
          SetEntityVisible(WorkObject, false)
      end
      SetModelAsNoLongerNeeded(WorkObject)
      FreezeEntityPosition(WorkObject, true)
      SetEntityInvincible(WorkObject, true)
      table.insert(CurrentWorkObject, WorkObject)
      Citizen.Wait(50)
    end
end

function MakeDrink(DrinkName)
    TriggerEvent('HD-inventory:client:set:busy', true)
    TriggerEvent("HD-sound:client:play", "pour-drink", 0.4)
    exports['HD-assets']:RequestAnimationDict("amb@world_human_hang_out_street@female_hold_arm@idle_a")
    TaskPlayAnim(GetPlayerPed(-1), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a" ,3.0, 3.0, -1, 8, 0, false, false, false)
    HDCore.Functions.Progressbar("open-brick", "Drinken Tappen..", 6500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('HD-cafe:server:finish:drink', DrinkName)
        TriggerEvent('HD-inventory:client:set:busy', false)
        StopAnimTask(GetPlayerPed(-1), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
    end, function()
        TriggerEvent('HD-inventory:client:set:busy', false)
        HDCore.Functions.Notify("Geannuleerd..", "error")
        StopAnimTask(GetPlayerPed(-1), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
    end)
  end
  
  function CheckDuty()
    if HDCore.Functions.GetPlayerData().job.name =='burger' and HDCore.Functions.GetPlayerData().job.onduty then
       TriggerServerEvent('HDCore:ToggleDuty')
       HDCore.Functions.Notify("Je bent tever van je werk terwijl je ingeklokt bent!", "error")
    end
  end
  
  function RemoveWorkObjects()
    for k, v in pairs(CurrentWorkObject) do
         DeleteEntity(v)
    end
  end
  
  function GetActiveRegister()
    return Config.ActivePayments
  end
  
  RegisterNUICallback('Click', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
  end)
  
  RegisterNUICallback('ErrorClick', function()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
  end)
  
  RegisterNUICallback('AddPrice', function(data)
    TriggerServerEvent('HD-cafe:server:add:to:register', data.Price, data.Note)
  end)
  
  RegisterNUICallback('PayReceipt', function(data)
    TriggerServerEvent('HD-cafe:server:pay:receipt', data.Price, data.Note, data.Id)
  end)
  
  RegisterNUICallback('CloseNui', function()
    SetNuiFocus(false, false)
  end)