RegisterNetEvent('HD-police:client:send:officer:down')
AddEventHandler('HD-police:client:send:officer:down', function(Coords, StreetName, Info, Priority)
    if (HDCore.Functions.GetPlayerData().job.name == "police") and HDCore.Functions.GetPlayerData().job.onduty then
        local Title, dienstnummer = 'Agent neer', 'CIC'
        if Priority == 3 then
            Title, dienstnummer = 'Agent neer (Flash)', 'CIC'..math.random(10,100)
        end
        TriggerEvent('HD-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = Title,
            priority = Priority,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-id-badge"></i>',
                    detail = Info['dienstnummer']..' | '..Info['Firstname'].. ' ' ..Info['Lastname'],
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            dienstnummer = dienstnummer,
        })
        AddAlert(Title, 306, 250, Coords, false)
    end
end)

RegisterNetEvent('HD-police:client:send:alert:panic:button')
AddEventHandler('HD-police:client:send:alert:panic:button', function(Coords, StreetName, Info)
    if (HDCore.Functions.GetPlayerData().job.name == "police") and HDCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('HD-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = "Noodknop",
            priority = 3,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-id-badge"></i>',
                    detail = Info['dienstnummer']..' | '..Info['Firstname'].. ' ' ..Info['Lastname'],
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            dienstnummer = 'CIC',
        })
        AddAlert('Noodknop', 487, 250, Coords, false)
    end
end)

RegisterNetEvent('HD-police:client:send:alert:gunshots')
AddEventHandler('HD-police:client:send:alert:gunshots', function(Coords, GunType, StreetName, InVeh)
   if (HDCore.Functions.GetPlayerData().job.name == "police") and HDCore.Functions.GetPlayerData().job.onduty then
     local AlertMessage, dienstnummer = 'Schoten gelost', '10-47A'
     if InVeh then
        AlertMessage, dienstnummer = 'Schoten gelost uit voertuig', 'CIC'
     end
     TriggerEvent('HD-alerts:client:send:alert', {
        timeOut = 7500,
        alertTitle = AlertMessage,
        priority = 1,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="far fa-arrow-alt-circle-right"></i>',
                detail = GunType,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        dienstnummer = dienstnummer,
    })
    AddAlert(AlertMessage, 313, 250, Coords, false)
  end
end)

RegisterNetEvent('HD-police:client:send:alert:dead')
AddEventHandler('HD-police:client:send:alert:dead', function(Coords, StreetName)
    if (HDCore.Functions.GetPlayerData().job.name == "police" or HDCore.Functions.GetPlayerData().job.name == "ambulance") and HDCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('HD-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = "Gewonde Burger",
            priority = 1,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            dienstnummer = 'CIC',
        }, true)
        AddAlert('Gewonde Burger', 480, 250, Coords, false)
    end
end)

RegisterNetEvent('HD-police:client:send:bank:alert')
AddEventHandler('HD-police:client:send:bank:alert', function(Coords, StreetName)
    if (HDCore.Functions.GetPlayerData().job.name == "police") and HDCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('HD-alerts:client:send:alert', {
            timeOut = 15000,
            alertTitle = "Fleeca Bank",
            priority = 1,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            dienstnummer = 'CIC',
        }, true)
        AddAlert('Fleeca Bank', 108, 250, Coords, false)
    end
end)


RegisterNetEvent('HD-police:client:send:meter:alert')
AddEventHandler('HD-police:client:send:meter:alert', function(Coords, StreetName)
    if (HDCore.Functions.GetPlayerData().job.name == "police") and HDCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('HD-alerts:client:send:alert', {
            timeOut = 15000,
            alertTitle = "Parking Meter",
            priority = 1,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            dienstnummer = 'CIC',
        }, true)
        AddAlert('Parking Meter', 108, 250, Coords, false)
    end
end)


RegisterNetEvent('HD-police:client:send:alert:jewellery')
AddEventHandler('HD-police:client:send:alert:jewellery', function(Coords, StreetName)
 if (HDCore.Functions.GetPlayerData().job.name == "police") and HDCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('HD-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Vangelico Jewellery",
        priority = 1,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        dienstnummer = 'CIC',
    }, true)
    AddAlert('Vangelico Jewellery', 617, 250, Coords, false)
 end
end)

RegisterNetEvent('HD-police:client:send:alert:store')
AddEventHandler('HD-police:client:send:alert:store', function(Coords, StreetName, StoreNumber)
 if (HDCore.Functions.GetPlayerData().job.name == "police") and HDCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('HD-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Winkel Alarm",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-shopping-basket"></i>',
                detail = 'Winkel: '..StoreNumber,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        dienstnummer = 'CIC',
    }, true)
    AddAlert('Winkel Alarm', 59, 250, Coords, false)
 end
end)

RegisterNetEvent('HD-police:client:send:house:alert')
AddEventHandler('HD-police:client:send:house:alert', function(Coords, StreetName)
 if (HDCore.Functions.GetPlayerData().job.name == "police") and HDCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('HD-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Huis Alarm",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        dienstnummer = 'CIC',
    }, true)
    AddAlert('Huis Alarm', 40, 250, Coords, false)
 end
end)

RegisterNetEvent('HD-police:client:send:ammunation:alert')
AddEventHandler('HD-police:client:send:ammunation:alert', function(Coords, StreetName)
 if (HDCore.Functions.GetPlayerData().job.name == "police") and HDCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('HD-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Bank Truck Alarm",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        dienstnummer = 'CIC',
    }, true)
    AddAlert('Ammunation', 67, 250, Coords, false)
 end
end)

RegisterNetEvent('HD-police:client:send:drugs:alert')
AddEventHandler('HD-police:client:send:drugs:alert', function(Coords, StreetName)
 if (HDCore.Functions.GetPlayerData().job.name == "police") and HDCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('HD-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Verdachte Situatie",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-closed-captioning"></i>',
                detail = 'Mogelijks drugshandel',
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        dienstnummer = 'CIC',
    }, true)
    AddAlert('Verdachte Situatie', 465, 250, Coords, false)
 end
end)

RegisterNetEvent('HD-police:client:send:banktruck:alert')
AddEventHandler('HD-police:client:send:banktruck:alert', function(Coords, Plate, StreetName)
 if (HDCore.Functions.GetPlayerData().job.name == "police") and HDCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('HD-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Bank Truck Alarm",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-closed-captioning"></i>',
                detail = 'Kenteken: '..Plate,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        dienstnummer = 'CIC',
    }, true)
    AddAlert('Banktruck Alarm', 67, 250, Coords, false)
 end
end)

RegisterNetEvent('HD-police:client:send:attempt:blackout:alert')
AddEventHandler('HD-police:client:send:attempt:blackout:alert', function(Coords, StreetName)
 if (HDCore.Functions.GetPlayerData().job.name == "police") and HDCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('HD-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Inbraak Elektriciteitscentrum",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        dienstnummer = 'CIC',
    }, true)
    AddAlert('Inbraak Elektriciteitscentrum', 354, 250, Coords, false)
 end
end)

RegisterNetEvent('HD-police:client:send:blackout:alert')
AddEventHandler('HD-police:client:send:blackout:alert', function(Coords, StreetName)
 if (HDCore.Functions.GetPlayerData().job.name == "police") and HDCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('HD-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Stroomuitval",
        priority = 1,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-closed-captioning"></i>',
                detail = 'Inbraak Elektriciteitscentrum',
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        dienstnummer = 'CIC',
    }, true)
    AddAlert('Stroomuitval', 354, 250, Coords, false)
 end
end)

RegisterNetEvent('HD-police:client:send:tracker:alert')
AddEventHandler('HD-police:client:send:tracker:alert', function(Coords, Name)
    if (HDCore.Functions.GetPlayerData().job.name == "police") and HDCore.Functions.GetPlayerData().job.onduty then
      AddAlert('Enkelband Locatie: '..Name, 480, 250, Coords, true)
    end
end)

-- // Funtions \\ --

function AddAlert(Text, Sprite, Transition, Coords, Tracker)
    local Transition = Transition
    local Blips = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
    SetBlipSprite(Blips, Sprite)
    SetBlipColour(Blips, 6)
    SetBlipDisplay(Blips, 4)
    SetBlipAlpha(Blips, transG)
    SetBlipScale(Blips, 1.0)
    SetBlipAsShortRange(Blips, false)
    SetBlipFlashes(Blips, true)
    BeginTextCommandSetBlipName('STRING')
    if not Tracker then
     AddTextComponentString('Melding: '..Text)
    else
     AddTextComponentString(Text)
    end
    EndTextCommandSetBlipName(Blips)
    while Transition ~= 0 do
        Wait(180 * 4)
        Transition = Transition - 1
        SetBlipAlpha(Blips, Transition)
        if Transition == 0 then
            SetBlipSprite(Blips, 2)
            RemoveBlip(Blips)
            return
        end
    end
end