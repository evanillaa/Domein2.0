HDCore = nil
CurrentCops = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if HDCore == nil then
            TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

-- Code

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

RegisterNetEvent('HD-drugs:AddWeapons')
AddEventHandler('HD-drugs:AddWeapons', function()
    table.insert(Config.Dealers[2]["products"], {
        name = "weapon_snspistol",
        price = 5000,
        amount = 1,
        info = {
            serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
        },
        type = "item",
        slot = 5,
        minrep = 200,
    })
    table.insert(Config.Dealers[3]["products"], {
        name = "weapon_snspistol",
        price = 5000,
        amount = 1,
        info = {
            serie = tostring(Config.RandomInt(2) .. Config.RandomStr(3) .. Config.RandomInt(1) .. Config.RandomStr(2) .. Config.RandomInt(3) .. Config.RandomStr(4))
        },
        type = "item",
        slot = 5,
        minrep = 200,
    })
end)