LoggedIn = false

HDCore = nil

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(750, function()
     TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end) 
     Citizen.Wait(150)   
     LoggedIn = true
    end)
end)