AddEventHandler('open:minigame', function(callback)
    Callbackk = callback
    openHack()
end)

RegisterNUICallback('callback', function(data, cb)
    closeHack()
    Callbackk(data.success)
    cb('ok')
end)

function openHack()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open"
    })
end

function closeHack()
    SetNuiFocus(false, false)
end
