For police alerts to work head over to your police script server place this in under any other police alert you already have

RegisterServerEvent('police:server:ParkingRobberyCall')
AddEventHandler('police:server:ParkingRobberyCall', function(coords, message, gender, streetLabel)
    local src = source
    local alertData = {
        title = "Parking Robbery",
        coords = {x = coords.x, y = coords.y, z = coords.z},
        description = message,
    }
    TriggerClientEvent("police:client:ParkingRobberyCall", -1, coords, message, gender, streetLabel)
    TriggerClientEvent("in-phone:client:addPoliceAlert", -1, alertData)
end)


Then head to client main in police and same again under any other police alert paste this

RegisterNetEvent('police:client:ParkingRobberyCall')
AddEventHandler('police:client:ParkingRobberyCall', function(coords, msg, gender, streetLabel)
    if PlayerJob.name == 'police' and onDuty then
        TriggerEvent('HD-policenotifier:client:AddPoliceAlert', {
            timeOut = 5000,
            alertTitle = "Parking meter robbery",
            coords = {
                x = coords.x,
                y = coords.y,
                z = coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-venus-mars"></i>',
                    detail = gender,
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = streetLabel,
                },
            },
            dienstnummer = CashoutCore.Functions.GetPlayerData().metadata["dienstnummer"],
        })

        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 411)
        SetBlipColour(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Report: Parking meter")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)