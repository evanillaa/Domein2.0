local HasItem, AddedProp = false, false
HDCore = nil
LoggedIn = false

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
        Citizen.Wait(1250)
        HDCore.Functions.TriggerCallback('HD-illegal:server:get:config', function(ConfigData)
            Config = ConfigData
        end)
        Citizen.Wait(350)
        SpawnNpcs()
        LoggedIn = true
    end)
end)

RegisterNetEvent('HDCore:Client:OnPlayerUnload')
AddEventHandler('HDCore:Client:OnPlayerUnload', function()
    DespawnNpcs()
    RemovePropFromHands()
    ResetCornerSelling()
    LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            HDCore.Functions.TriggerCallback('HD-illegal:serverhas:robbery:item', function(HoldItem)
                if HoldItem then
                    if not AddedProp then
                        AddedProp = true
                        AddPropToHands(HoldItem)
                    end
                else
                    if AddedProp then
                        AddedProp = false
                        RemovePropFromHands()
                    end
                end
            end)
            Citizen.Wait(350)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('HD-illegal:client:unpack:coke')
AddEventHandler('HD-illegal:client:unpack:coke', function()
    Citizen.SetTimeout(750, function()
        TriggerEvent('HD-inventory:client:set:busy', true)
        TriggerEvent("HD-sound:client:play", "unwrap", 0.4)
        HDCore.Functions.Progressbar("open-brick", "Uitpakken..", 7500, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "amb@world_human_clipboard@male@idle_a",
            anim = "idle_c",
            flags = 49,
        }, {}, {}, function() -- Done
            TriggerEvent('HD-inventory:client:set:busy', false)
            TriggerServerEvent('HD-illegal:server:unpack:coke')
            HDCore.Functions.Notify("Uitgepakt yay", "success")
            StopAnimTask(GetPlayerPed(-1), "amb@world_human_clipboard@male@idle_a", "idle_c", 1.0)
        end, function()
            TriggerEvent('HD-inventory:client:set:busy', false)
            HDCore.Functions.Notify("Geannuleerd..", "error")
            StopAnimTask(GetPlayerPed(-1), "amb@world_human_clipboard@male@idle_a", "idle_c", 1.0)
        end)
    end)
end)

-- // Functions \\ --

function GetActiveServerPlayers()
    local PlayerPeds = {}
    if next(PlayerPeds) == nil then
        for _, Player in ipairs(GetActivePlayers()) do
            local PlayerPed = GetPlayerPed(Player)
            table.insert(PlayerPeds, PlayerPed)
        end
        return PlayerPeds
    end
end

function AddPropToHands(PropName)
    HasItem = true
    exports['HD-assets']:AddProp(PropName)
    if PropName ~= 'Duffel' then
        while HasItem do
            Citizen.Wait(4)
            if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
                exports['HD-assets']:RequestAnimationDict("anim@heists@box_carry@")
                TaskPlayAnim(GetPlayerPed(-1), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
            else
                Citizen.Wait(100)
            end
        end
    end
end

function RemovePropFromHands()
    HasItem = false
    exports['HD-assets']:RemoveProp()
    StopAnimTask(GetPlayerPed(-1), 'anim@heists@box_carry@', 'idle', 1.0)
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