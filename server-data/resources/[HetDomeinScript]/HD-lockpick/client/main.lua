local IsLockPicking = false

HDCore = nil

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
	   Citizen.Wait(250)
 end)
end)

-- Code lockpick

AddEventHandler('HD-lockpick:client:openLockpick', function(callback)
    lockpickCallback = callback
    openLockpick(true)
end)

function OpenLockpickGame(callback)
 lockpickCallback = callback
 openLockpick(true)
 TriggerServerEvent('HD-hud:server:gain:stress', math.random(0, 2))
end

RegisterNUICallback('callback', function(data, cb)
    openLockpick(false)
	lockpickCallback(data.success)
    cb('ok')
end)

RegisterNUICallback('exit', function(data)
    lockpickCallback(data.success)
    openLockpick(false)
end)

 function openLockpick(bool)
 SetNuiFocus(bool, bool)
 SendNUIMessage({
     action = "ui",
     toggle = bool,
 })
 SetCursorLocation(0.5, 0.2)
 IsLockPicking = bool
end

function GetLockPickStatus()
    return IsLockPicking
end
