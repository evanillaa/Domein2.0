prisonBreak = false
currentGate = 0

local requiredItemsShowed = false
local requiredItems = {}
local inRange = false
local securityLockdown = false

local Gates = {
    [1] = {
        gatekey = 18,
        coords = {x = 1845.99, y = 2604.7, z = 45.58, h = 94.5},  
        hit = false,
    },
    [2] = {
        gatekey = 19,
        coords = {x = 1819.47, y = 2604.67, z = 45.56, h = 98.5},
        hit = false,
    }
    -- [3] = {
    --     gatekey = 20,
    --     coords = {x = 1804.74, y = 2616.311, z = 45.61, h = 335.5},
    --     hit = false,
    -- }
}

Citizen.CreateThread(function()
    Citizen.Wait(500)
    requiredItems = {
        [1] = {name = HDCore.Shared.Items["electronickit"]["name"], image = HDCore.Shared.Items["electronickit"]["image"]},
        [2] = {name = HDCore.Shared.Items["gatecrack"]["name"], image = HDCore.Shared.Items["gatecrack"]["image"]},
    }
    while true do 
        Citizen.Wait(5)
        inRange = false
        currentGate = 0
        --if isLoggedIn and HDCore ~= nil then
            if HDCore.Functions.GetPlayerData().job.name ~= "police" then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                for k, v in pairs(Gates) do
                    local dist = GetDistanceBetweenCoords(pos, Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, true)
                    if (dist < 1.5) then
                        currentGate = k
                        inRange = true
                        if securityLockdown then
                            HDCore.Functions.DrawText3D(Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, "~r~SYSTEM LOCKDOWN")
                        elseif Gates[k].hit then
                            HDCore.Functions.DrawText3D(Gates[k].coords.x, Gates[k].coords.y, Gates[k].coords.z, "SYSTEM BREACH")
                        elseif not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('HD-inventory:client:requiredItems', requiredItems, true)
                        end
                    end
                end

                if not inRange then
                    if requiredItemsShowed then
                        requiredItemsShowed = false
                        TriggerEvent('HD-inventory:client:requiredItems', requiredItems, false)
                    end
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(1000)
            end
        --else
        --    Citizen.Wait(5000)
        --end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["middle"].coords.x, Config.Locations["middle"].coords.y, Config.Locations["middle"].coords.z, false) > 200.0 and inJail) then
			inJail = false
            jailTime = 0
		    RemoveBlip(currentBlip)
            TriggerServerEvent("HD-HD-prison:server:SecurityLockdown")
            HDCore.Functions.Notify("You have escaped the prison .. make you get away!", "error")
		end
	end
end)

RegisterNetEvent('electronickit:UseElectronickit')
AddEventHandler('electronickit:UseElectronickit', function()
    if currentGate ~= 0 and not securityLockdown and not Gates[currentGate].hit then 
        HDCore.Functions.TriggerCallback('HDCore:HasItem', function(result)
            if result then 
                TriggerEvent('HD-inventory:client:requiredItems', requiredItems, false)
                HDCore.Functions.Progressbar("hack_gate", "Electronic kit aansluiten..", math.random(5000, 10000), false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = "anim@gangops@facility@servers@",
                    anim = "hotwire",
                    flags = 16,
                }, {}, {}, function() -- Done
                    StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                        TriggerEvent('pepe:numbers:start', math.random(40,60), function(result)
                            if result then
                                TriggerServerEvent("HD-prison:server:SetGateHit", currentGate)
                                TriggerServerEvent('HD-doorlock:server:updateState', Gates[currentGate].gatekey, false)
                            else
                                TriggerServerEvent("HD-prison:server:SecurityLockdown")
                            end
                        end)
                end, function() -- Cancel
                    StopAnimTask(GetPlayerPed(-1), "anim@gangops@facility@servers@", "hotwire", 1.0)
                    HDCore.Functions.Notify("Canceled..", "error")
                end)
            else
                HDCore.Functions.Notify("You miss an item ..", "error")
            end
        end, "gatecrack")
    end
end)

RegisterNetEvent('HD-prison:client:SetLockDown')
AddEventHandler('HD-prison:client:SetLockDown', function(isLockdown)
    securityLockdown = isLockdown
    if securityLockDown and inJail then
        TriggerEvent("chatMessage", "JAIL", "error", "Highest security level is active, stay with the cell blocks!")
    end
end)

RegisterNetEvent('HD-prison:client:PrisonBreakAlert')
AddEventHandler('HD-prison:client:PrisonBreakAlert', function()
    TriggerEvent("chatMessage", "ALERT", "error", "Attention All units! Attempted outbreak in prison!")
    local BreakBlip = AddBlipForCoord(Config.Locations["middle"].coords.x, Config.Locations["middle"].coords.y, Config.Locations["middle"].coords.z)
	SetBlipSprite(BreakBlip , 161)
	SetBlipScale(BreakBlip , 3.0)
	SetBlipColour(BreakBlip, 3)
	PulseBlip(BreakBlip)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    Citizen.Wait(100)
    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait(100)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    Citizen.Wait(100)
    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait((1000 * 60 * 5))   
    RemoveBlip(BreakBlip)
end)

RegisterNetEvent('HD-prison:client:SetGateHit')
AddEventHandler('HD-prison:client:SetGateHit', function(key, isHit)
    Gates[key].hit = isHit
end)