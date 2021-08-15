HDCore = nil

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
  Citizen.SetTimeout(1250, function()
      TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
      Citizen.Wait(100)
  end)
end)

-- Code
--[[
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Location['X'], Config.Location['Y'], Config.Location['Z'], true)
            if Distance < 2.5 then
                DrawMarker(2, Config.Location['X'], Config.Location['Y'], Config.Location['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                DrawText3D(Config.Location['X'], Config.Location['Y'], Config.Location['Z'] + 0.15, '~g~E~w~ - Open Gemeentehuis')
                if IsControlJustPressed(0, 38) then
                    TriggerEvent('HD-cityhall:client:open:nui')
                end
            end
        end
end)
]]
-- // Events \\ --

RegisterNetEvent('HD-cityhall:client:open:nui')
AddEventHandler('HD-cityhall:client:open:nui', function()
    Citizen.SetTimeout(350, function()
        OpenCityHall()
    end)
end)

-- // Functions \\ 

function OpenCityHall()
 SetNuiFocus(true, true)  
 SendNUIMessage({
     action = "open"
 }) 
end

RegisterNUICallback('Close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('Click', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('requestId', function(data)
    local idType = data.idType
    TriggerServerEvent('HD-cityhall:server:requestId', Config.IdTypes[idType])
    HDCore.Functions.Notify('Je hebt je '..Config.IdTypes[idType].label..' aangevraagd voor €50', 'success', 3500)
end)

RegisterNUICallback('requestLicenses', function(data, cb)
    local PlayerData = HDCore.Functions.GetPlayerData()
    local licensesMeta = PlayerData.metadata["licences"]
    local availableLicenses = {}
    for type,_ in pairs(licensesMeta) do
        if licensesMeta[type] then
            local licenseType = nil
            local label = nil
            if type == "driver" then licenseType = "rijbewijs" label = "Rijbewijs" end
            table.insert(availableLicenses, {
                idType = licenseType,
                label = label
            })
        end
    end
    cb(availableLicenses)
end)

RegisterNUICallback('applyJob', function(data)
    TriggerServerEvent('HD-cityhall:server:ApplyJob', data.job)
end)

-- // Functions \\ --

function CanOpenCityHall()
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Location['X'], Config.Location['Y'], Config.Location['Z'], true)
    if Distance < 3.0 then  
      return true
    end
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