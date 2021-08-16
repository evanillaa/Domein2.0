local LoggedIn = false

HDCore = nil

RegisterNetEvent("HDCore:Client:OnPlayerLoaded")
AddEventHandler("HDCore:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(1000, function()
        TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
        Citizen.Wait(250)
        HDCore.Functions.TriggerCallback("HD-wapenkluis:server:get:config", function(config)
            Config = config
        end)
        LoggedIn = true
    end)
end)

-- Code

RegisterNetEvent('HD-wapenkluis:enter:code')
AddEventHandler('HD-wapenkluis:enter:code', function()
    Citizen.SetTimeout(450, function()
        SetNuiFocus(true, true)
        SendNUIMessage({action = "open"})
    end)
end)

RegisterNUICallback('PinpadClose', function(data)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ErrorMessage', function(data)
    HDCore.Functions.Notify(data.message, 'error')
end)

RegisterNUICallback('EnterPincode', function(data)
  HDCore.Functions.TriggerCallback('HD-wapenkluis:server:pin:code', function(Code)
      if tonumber(data.pin) ~= nil then
          if tonumber(data.pin) == Code then
            TriggerEvent('HD-police:client:target:wapenkluis')
          else
            PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
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