local IsShitLockPicking = false

HDCore = nil

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
     TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
	   Citizen.Wait(250)
 end)
end)

-- Code shitlockpick

AddEventHandler('HD-lockpick:client:openShitLockpick', function(callback)
    ShitlockpickCallback = callback
    openShitLockpick(true)
end)

function OpenShitLockpickGame(callback)
    ShitlockpickCallback = callback
    openShitLockpick(true)
    TriggerServerEvent('HD-hud:server:gain:stress', math.random(0, 2))
end

RegisterNUICallback('shitcallback', function(data, cb)
    openShitLockpick(false)
	ShitlockpickCallback(data.success)
    cb('ok')
end)

RegisterNUICallback('Shitexit', function(data)
    ShitlockpickCallback(data.success)
    openShitLockpick(false)
end)

function openShitLockpick(bool)
 SetNuiFocus(bool, bool)
 SendNUIMessage({
     action = "ui",
     toggle = bool,
 })
 SetCursorLocation(0.5, 0.2)
 IsShitLockPicking = bool
end

function GetShitLockPickStatus()
    return IsShitLockPicking
end