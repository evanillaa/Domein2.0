local HouseData, OffSets = nil, nil
local HouseBlips = {}
Currenthouse = nil
IsNearHouse = false
local HouseCam = nil
local NearGarage = false
IsInHouse = false
HasKey = false
local StashLocation = nil
local ClothingLocation = nil
local LogoutLocation = nil
local Other = nil
local LoggedIn = false

HDCore = nil

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)
        Citizen.Wait(125)
        HDCore.Functions.TriggerCallback("HD-housing:server:get:config", function(config)
           Config = config
        end)
        Citizen.Wait(145)
        AddBlipForHouse()
        LoggedIn = true
    end)
end)

RegisterNetEvent('HDCore:Client:OnPlayerUnload')
AddEventHandler('HDCore:Client:OnPlayerUnload', function()
    RemoveHouseBlip()
    IsInHouse = false
    Currenthouse = nil
    HasKey = false
    LoggedIn = false
end)

-- Code

-- // Loops \\

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if LoggedIn then
            if not IsInHouse then
                 IsNearHouse = false
                 for k, v in pairs(Config.Houses) do
                     local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                     local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['Enter']['X'], v['Coords']['Enter']['Y'], v['Coords']['Enter']['Z'], true)
                     if Distance < 14.5 then
                         IsNearHouse = true
                         Currenthouse = k
                         HDCore.Functions.TriggerCallback('HD-housing:server:has:house:key', function(HasHouseKey)
                             HasKey = HasHouseKey
                         end, k)
                         Citizen.Wait(10)
                     end
                 end
                 if not IsNearHouse and not IsInHouse then
                     Citizen.Wait(3500)
                     Currenthouse = nil
                 end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if Currenthouse ~= nil then

                local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
                
                if not IsInHouse then
                    if not Config.Houses[Currenthouse]['Owned'] then
                      if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Houses[Currenthouse]['Coords']['Enter']['X'], Config.Houses[Currenthouse]['Coords']['Enter']['Y'], Config.Houses[Currenthouse]['Coords']['Enter']['Z'], true) < 3.0) then
                        DrawText3D(Config.Houses[Currenthouse]['Coords']['Enter']['X'], Config.Houses[Currenthouse]['Coords']['Enter']['Y'], Config.Houses[Currenthouse]['Coords']['Enter']['Z'], '~g~E~w~ - Huis Bezichtigen')
                        if IsControlJustReleased(0, 38) then
                            TriggerServerEvent('HD-housing:server:view:house', Currenthouse)
                        end
                      end
                    end

                    if Config.Houses[Currenthouse]['Garage'] ~= nil then
                        if Config.Houses[Currenthouse]['Owned'] and HasKey then
                            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Houses[Currenthouse]['Garage']['X'], Config.Houses[Currenthouse]['Garage']['Y'], Config.Houses[Currenthouse]['Garage']['Z'], true) < 3.0) then
                                NearGarage = true
                                DrawMarker(2, Config.Houses[Currenthouse]['Garage']['X'], Config.Houses[Currenthouse]['Garage']['Y'], Config.Houses[Currenthouse]['Garage']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                                DrawText3D(Config.Houses[Currenthouse]['Garage']['X'], Config.Houses[Currenthouse]['Garage']['Y'], Config.Houses[Currenthouse]['Garage']['Z'] + 0.12, '~g~E~w~ - Garage')
                                if IsControlJustReleased(0, 38) then
                                    local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
                                    if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
                                      exports['HD-garages']:OpenHouseGarage(Currenthouse)
                                    else
                                        HDCore.Functions.TriggerCallback('HD-materials:server:is:vehicle:owned', function(IsOwned)
                                            if IsOwned then
                                                exports['HD-garages']:SetVehicleInHouseGarage(Currenthouse)
                                            else
                                                HDCore.Functions.Notify("Dit voertuig is van niemand..", "error")
                                            end
                                        end, GetVehicleNumberPlateText(Vehicle))
                                    end
                                end
                            else
                                NearGarage = false
                            end
                        end
                    end


                end


                  -- // Verlaten \\ --
        if IsInHouse then
           if OffSets ~= nil then


                if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Houses[Currenthouse]['Coords']['Enter']['X'] - OffSets.exit.x, Config.Houses[Currenthouse]['Coords']['Enter']['Y'] - OffSets.exit.y, Config.Houses[Currenthouse]['Coords']['Enter']['Z'] - OffSets.exit.z, true) < 2.0) then
                  DrawMarker(2, Config.Houses[Currenthouse]['Coords']['Enter']['X'] - OffSets.exit.x, Config.Houses[Currenthouse]['Coords']['Enter']['Y'] - OffSets.exit.y, Config.Houses[Currenthouse]['Coords']['Enter']['Z'] - OffSets.exit.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                  DrawText3D(Config.Houses[Currenthouse]['Coords']['Enter']['X'] - OffSets.exit.x, Config.Houses[Currenthouse]['Coords']['Enter']['Y'] - OffSets.exit.y, Config.Houses[Currenthouse]['Coords']['Enter']['Z'] - OffSets.exit.z + 0.12, '~g~E~s~ - Verlaten')
                     if IsControlJustReleased(0, 38) then
                         LeaveHouse()
                     end
                end

                -- // Stash \\ --

                if CurrentBell ~= nil then
                    if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Houses[Currenthouse]['Coords']['Enter']['X'] - OffSets.exit.x, Config.Houses[Currenthouse]['Coords']['Enter']['Y'] - OffSets.exit.y, Config.Houses[Currenthouse]['Coords']['Enter']['Z'] - OffSets.exit.z, true) < 2.0) then
                        DrawMarker(2, Config.Houses[Currenthouse]['Coords']['Enter']['X'] - OffSets.exit.x, Config.Houses[Currenthouse]['Coords']['Enter']['Y'] - OffSets.exit.y, Config.Houses[Currenthouse]['Coords']['Enter']['Z'] - OffSets.exit.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                        DrawText3D(Config.Houses[Currenthouse]['Coords']['Enter']['X'] - OffSets.exit.x, Config.Houses[Currenthouse]['Coords']['Enter']['Y'] - OffSets.exit.y, Config.Houses[Currenthouse]['Coords']['Enter']['Z'] - OffSets.exit.z + 0.32, '~g~G~s~ - Open Doen')
                        if IsControlJustReleased(0, 47) then
                            TriggerServerEvent("HD-housing:server:open:door", CurrentBell, Currenthouse)
                            CurrentBell = nil
                        end
                    end
                end
                    
                if StashLocation ~= nil then
                     if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, StashLocation['X'], StashLocation['Y'], StashLocation['Z'], true) < 1.65) then
                      DrawMarker(2, StashLocation['X'], StashLocation['Y'], StashLocation['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                      DrawText3D(StashLocation['X'], StashLocation['Y'], StashLocation['Z'], '~g~E~s~ - Stash')
                         if IsControlJustReleased(0, 38) then
                            TriggerEvent("HD-inventory:client:SetCurrentStash", Currenthouse)
                            TriggerServerEvent("HD-inventory:server:OpenInventory", "stash", Currenthouse, Other)
                            TriggerEvent("HD-sound:client:play", "stash-open", 0.4)
                         end
                     end
                end

                if ClothingLocation ~= nil then
                    if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, ClothingLocation['X'], ClothingLocation['Y'], ClothingLocation['Z'], true) < 1.65) then
                     DrawMarker(2, ClothingLocation['X'], ClothingLocation['Y'], ClothingLocation['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                     DrawText3D(ClothingLocation['X'], ClothingLocation['Y'], ClothingLocation['Z'], '~g~E~s~ - Kleding')
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent('HD-clothing:client:openOutfitMenu')
                        end
                    end
                end

                if LogoutLocation ~= nil then
                    if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, LogoutLocation['X'], LogoutLocation['Y'], LogoutLocation['Z'], true) < 1.65) then
                     DrawMarker(2, LogoutLocation['X'], LogoutLocation['Y'], LogoutLocation['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                     DrawText3D(LogoutLocation['X'], LogoutLocation['Y'], LogoutLocation['Z'], '~g~E~s~ - Logout')
                        if IsControlJustReleased(0, 38) then
                            LogoutPlayer()
                        end
                    end
                end



                end  
            end
        end


        end
    end
end)

-- // Events \\ --

RegisterNetEvent('HD-housing:client:enter:house')
AddEventHandler('HD-housing:client:enter:house', function()
    local Housing = {}
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    local CoordsTable = {x = Config.Houses[Currenthouse]['Coords']['Enter']['X'], y = Config.Houses[Currenthouse]['Coords']['Enter']['Y'], z = Config.Houses[Currenthouse]['Coords']['Enter']['Z'] - 35.0}
    IsInHouse = true
    TriggerEvent("HD-sound:client:play", "house-door-open", 0.1)
    OpenDoorAnim()
    Citizen.Wait(350)
    SetHouseLocations()
    if Config.Houses[Currenthouse]['Tier'] == 1 then
        Other = {maxweight = 650000, slots = 25}
        Housing = exports['HD-interiors']:HouseTierOne(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 2 then
        Other = {maxweight = 650000, slots = 25}
        Housing = exports['HD-interiors']:HouseTierTwo(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 3 then
        Other = {maxweight = 650000, slots = 25}
        Housing = exports['HD-interiors']:HouseTierThree(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 4 then
        Other = {maxweight = 950000, slots = 35}
        Housing = exports['HD-interiors']:HouseTierFour(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 5 then
        Other = {maxweight = 1200000, slots = 45}
        Housing = exports['HD-interiors']:HouseTierFive(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 6 then
        Other = {maxweight = 1200000, slots = 45}
        Housing = exports['HD-interiors']:HouseTierSix(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 7 then
        Other = {maxweight = 1200000, slots = 45}
        Housing = exports['HD-interiors']:HouseTierSeven(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 8 then
        Other = {maxweight = 1200000, slots = 45}
        Housing = exports['HD-interiors']:HouseTierEight(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 9 then
        Other = {maxweight = 1200000, slots = 45}
        Housing = exports['HD-interiors']:HouseTierNine(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 10 then
        Other = {maxweight = 1200000, slots = 45}
        Housing = exports['HD-interiors']:HouseTierTen(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 11 then
        Other = {maxweight = 1350000, slots = 50}
        Housing = exports['HD-interiors']:GarageTierOne(CoordsTable)
    elseif Config.Houses[Currenthouse]['Tier'] == 12 then
        Other = {maxweight = 1550000, slots = 55}
        Housing = exports['HD-interiors']:GarageTierTwo(CoordsTable)
    end
    LoadDecorations(Currenthouse)
    TriggerEvent('HD-weathersync:client:DisableSync')
    HouseData, OffSets = Housing[1], Housing[2]
    Citizen.SetTimeout(450, function()
        exports['HD-houseplants']:LoadHousePlants(Currenthouse)
    end)
end)

RegisterNetEvent('HD-housing:client:add:to:config')
AddEventHandler('HD-housing:client:add:to:config', function(Name, Owner, CoordsTable, Owned, Tier, Price, DoorLocked, KeyHolder, Label, Garage)
    Config.Houses[Name] = {
        ['Coords'] = CoordsTable,
        ['Owned'] = Owned,
        ['Owner'] = Owner,
        ['Tier'] = Tier,
        ['Price'] = Price,
        ['Door-Lock'] = DoorLocked,
        ['Adres'] = Label,
        ['Garage'] = Garage,
        ['Key-Holders'] = KeyHolder,
        ['Decorations'] = {}
    }
end)

RegisterNetEvent('HD-housing:client:set:garage')
AddEventHandler('HD-housing:client:set:garage', function(HouseId, Coords)
    Config.Houses[HouseId]['Garage'] = Coords
end)

RegisterNetEvent('HD-housing:client:set:owned')
AddEventHandler('HD-housing:client:set:owned', function(HouseId, Owned, CitizenId)
    Config.Houses[HouseId]['Owner'] = CitizenId
    Config.Houses[HouseId]['Owned'] = Owned
    Config.Houses[HouseId]['Key-Holders'] = {[1] = CitizenId}
    Citizen.SetTimeout(100, function()
        RefreshHouseBlips()
    end)
end)

RegisterNetEvent('HD-housing:client:create:house')
AddEventHandler('HD-housing:client:create:house', function(Price, Tier)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    local PlayerHeading = GetEntityHeading(GetPlayerPed(-1))
    local StreetNative = Citizen.InvokeNative(0x2EB41072B4C1E4C0, PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
    local StreetName = GetStreetNameFromHashKey(StreetNative)
    local CoordsTable = {['Enter'] = {['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z, ['H'] = PlayerHeading}, ['Cam'] = {['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z, ['H'] = PlayerHeading, ['Yaw'] = -10.0}}
    TriggerServerEvent('HD-housing:server:add:new:house', StreetName:gsub("%-", " "), CoordsTable, Price, Tier)
end)

RegisterNetEvent('HD-housing:client:delete:successful')
AddEventHandler('HD-housing:client:delete:successful', function(HouseId)
    Currenthouse = nil
    Config.Houses[HouseId] = {}
end)

RegisterNetEvent('HD-housing:client:delete:house')
AddEventHandler('HD-housing:client:delete:house', function()
    if Currenthouse ~= nil then 
        TriggerServerEvent('HD-housing:server:detlete:house', Currenthouse)
    else
        HDCore.Functions.Notify("Geen huis in de buurt..", "error")
    end
end)

RegisterNetEvent('HD-housing:client:add:garage')
AddEventHandler('HD-housing:client:add:garage', function()
    if Currenthouse ~= nil then 
        local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
        local PlayerHeading = GetEntityHeading(GetPlayerPed(-1))
        local CoordsTable = {['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z, ['H'] = PlayerHeading}
        TriggerServerEvent('HD-housing:server:add:garage', Currenthouse, Config.Houses[Currenthouse]['Adres'], CoordsTable)
    else
        HDCore.Functions.Notify("Geen huis in de buurt..", "error")
    end
end)

RegisterNetEvent('HD-housing:client:view:house')
AddEventHandler('HD-housing:client:view:house', function(houseprice, brokerfee, bankfee, taxes, firstname, lastname)
    SetHouseCam(Config.Houses[Currenthouse]['Coords']['Cam'], Config.Houses[Currenthouse]['Coords']['Cam']['H'], Config.Houses[Currenthouse]['Coords']['Cam']['Yaw'])
    Citizen.Wait(500)
    OpenHouseContract(true)
    SendNUIMessage({
        type = "setupContract",
        firstname = firstname,
        lastname = lastname,
        street = Config.Houses[Currenthouse]['Adres'],
        houseprice = houseprice,
        brokerfee = brokerfee,
        bankfee = bankfee,
        taxes = taxes,
        totalprice = (houseprice + brokerfee + bankfee + taxes)
    })
end)

RegisterNetEvent('HD-housing:client:set:location')
AddEventHandler('HD-housing:client:set:location', function(Type)
 local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
 local CoordsTable = {['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z}
 if IsInHouse then
     if HasKey then
         if Type == 'stash' then
          TriggerServerEvent('HD-housing:server:set:location', Currenthouse, CoordsTable, 'stash')
         elseif Type == 'clothes' then
          TriggerServerEvent('HD-housing:server:set:location', Currenthouse, CoordsTable, 'clothes')
        elseif Type == 'logout' then
          TriggerServerEvent('HD-housing:server:set:location', Currenthouse, CoordsTable, 'logout')
        end
     end
 end
end)

RegisterNetEvent('HD-housing:client:refresh:location')
AddEventHandler('HD-housing:client:refresh:location', function(HouseId, CoordsTable, Type)
 if HouseId == Currenthouse then
    if IsInHouse then
         if Type == 'stash' then
            StashLocation = CoordsTable
         elseif Type == 'clothes' then
            ClothingLocation = CoordsTable
        elseif Type == 'logout' then
            LogoutLocation = CoordsTable
        end
    end
 end
end)

RegisterNetEvent('HD-housing:client:give:keys')
AddEventHandler('HD-housing:client:give:keys', function()
  local Player, Distance = HDCore.Functions.GetClosestPlayer()
  if Player ~= -1 and Distance < 1.5 then  
    HDCore.Functions.GetPlayerData(function(PlayerData)
      if Config.Houses[Currenthouse]['Owner'] == PlayerData.citizenid then
         TriggerServerEvent('HD-housing:server:give:keys', Currenthouse, GetPlayerServerId(Player))
      else
        HDCore.Functions.Notify("Je bent niet de eigenaar van dit huis..", "error")
      end
    end)
  else
    HDCore.Functions.Notify("Niemand gevonden?", "error")
  end
end)

RegisterNetEvent('HD-housing:client:ring:door')
AddEventHandler('HD-housing:client:ring:door', function()
    if Currenthouse ~= nil then
      TriggerServerEvent('HD-housing:server:ring:door', Currenthouse)
    end
end)

RegisterNetEvent('HD-housing:client:ringdoor')
AddEventHandler('HD-housing:client:ringdoor', function(Player, HouseId)
    if Currenthouse == HouseId and IsInHouse then
        CurrentBell = Player
        TriggerEvent("HD-sound:client:play", "house-doorbell", 0.1)
        HDCore.Functions.Notify("Er staat iemand aan de deur..")
    end
end)

RegisterNetEvent('HD-housing:client:set:in:house')
AddEventHandler('HD-housing:client:set:in:house', function(House)
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Houses[House]['Coords']['Enter']['X'], Config.Houses[House]['Coords']['Enter']['Y'], Config.Houses[House]['Coords']['Enter']['Z'], true) < 5.0) then
        TriggerEvent('HD-housing:client:enter:house')
    end
end)

RegisterNetEvent('HD-housing:client:set:new:key:holders')
AddEventHandler('HD-housing:client:set:new:key:holders', function(HouseId, HouseKeys)
    Config.Houses[HouseId]['Key-Holders'] = HouseKeys
end)

RegisterNetEvent('HD-housing:client:set:house:door')
AddEventHandler('HD-housing:client:set:house:door', function(HouseId, bool)
    Config.Houses[HouseId]['Door-Lock'] = bool
end)

RegisterNetEvent('HD-housing:client:reset:house:door')
AddEventHandler('HD-housing:client:reset:house:door', function()
    if IsNearHouse then
        if not Config.Houses[Currenthouse]['Door-Lock'] then
            OpenDoorAnim()
            TriggerServerEvent('HD-sound:server:play:source', 'doorlock-keys', 0.4)
            TriggerServerEvent('HD-housing:server:set:house:door', Currenthouse, true)
        else
            HDCore.Functions.Notify("Deur is al dicht..", 'error')
        end
    else
        HDCore.Functions.Notify("Geen huis?!?", 'error')
    end
end)

RegisterNetEvent('HD-housing:client:breaking:door')
AddEventHandler('HD-housing:client:breaking:door', function()
    if IsNearHouse then
        if Config.Houses[Currenthouse]['Door-Lock'] then
            RamAnimation(true)
            HDCore.Functions.Progressbar("bonk-door", "Deur Bonken..", 15000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                RamAnimation(false)
                TriggerServerEvent('HD-housing:server:set:house:door', Currenthouse, false)
            end, function() -- Cancel
                RamAnimation(false)
            end)
        else
            HDCore.Functions.Notify("Deur is al open..", 'error')
        end
    else
        HDCore.Functions.Notify("Geen huis?!?", 'error')
    end
end)

-- // Functions \\ --

function LeaveHouse()
    TriggerEvent("HD-sound:client:play", "house-door-open", 0.1)
    OpenDoorAnim()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    exports['HD-interiors']:DespawnInterior(HouseData, function()
        SetEntityCoords(GetPlayerPed(-1), Config.Houses[Currenthouse]['Coords']['Enter']['X'], Config.Houses[Currenthouse]['Coords']['Enter']['Y'], Config.Houses[Currenthouse]['Coords']['Enter']['Z'])
        TriggerEvent('HD-weathersync:client:EnableSync')
        exports['HD-houseplants']:UnloadHousePlants(Currenthouse)
        UnloadDecorations()
        Citizen.Wait(1000)
        IsInHouse = false
        Other = nil
        Currenthouse = nil
        StashLocation, ClothingLocation, LogoutLocation = nil, nil, nil
        HouseData, OffSets = nil, nil
        DoScreenFadeIn(1000)
        TriggerEvent("HD-sound:client:play", "house-door-close", 0.1)
    end)
end

function LogoutPlayer()
    TriggerEvent("HD-sound:client:play", "house-door-open", 0.1)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    exports['HD-interiors']:DespawnInterior(HouseData, function()
        SetEntityCoords(GetPlayerPed(-1), Config.Houses[Currenthouse]['Coords']['Enter']['X'], Config.Houses[Currenthouse]['Coords']['Enter']['Y'], Config.Houses[Currenthouse]['Coords']['Enter']['Z'])
        TriggerEvent('HD-weathersync:client:EnableSync')
        UnloadDecorations()
        Citizen.Wait(1000)
        IsInHouse = false
        Other = nil
        Currenthouse = nil
        StashLocation, ClothingLocation, LogoutLocation = nil, nil, nil
        HouseData, OffSets = nil, nil
        TriggerEvent("HD-sound:client:play", "house-door-close", 0.1)
        Citizen.Wait(450)
        TriggerServerEvent('HD-housing:server:logout')
    end)
  end

function SetHouseLocations()
  if Currenthouse ~= nil then
      HDCore.Functions.TriggerCallback('HD-housing:server:get:locations', function(result)
          if result ~= nil then
              if result.stash ~= nil then
                StashLocation = json.decode(result.stash)
              end  
              if result.outfit ~= nil then
                ClothingLocation = json.decode(result.outfit)
              end  
              if result.logout ~= nil then
                LogoutLocation = json.decode(result.logout)
              end
          end
      end, Currenthouse)
  end
end

function RamAnimation(bool)
    if bool then
      exports['HD-assets']:RequestAnimationDict("missheistfbi3b_ig7")
      TaskPlayAnim(GetPlayerPed(-1), "missheistfbi3b_ig7", "lift_fibagent_loop", 8.0, 8.0, -1, 1, -1, false, false, false)
    else
      exports['HD-assets']:RequestAnimationDict("missheistfbi3b_ig7")
      TaskPlayAnim(GetPlayerPed(-1), "missheistfbi3b_ig7", "exit", 8.0, 8.0, -1, 1, -1, false, false, false)
    end
end

function EnterNearHouse()
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    if Currenthouse ~= nil then
        local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Houses[Currenthouse]['Coords']['Enter']['X'], Config.Houses[Currenthouse]['Coords']['Enter']['Y'], Config.Houses[Currenthouse]['Coords']['Enter']['Z'], true)
        if Area < 2.0 and HasKey or Area < 2.0 and not Config.Houses[Currenthouse]['Door-Lock'] then
            if not IsInHouse then
                return true
            end
        end
    end
end

function HasEnterdHouse()
    if IsInHouse and HasKey then
        return true
    end
end

function OpenDoorAnim()
  exports['HD-assets']:RequestAnimationDict('anim@heists@keycard@')
  TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
  Citizen.Wait(400)
  ClearPedTasks(GetPlayerPed(-1))
end

function SetHouseCam(coords, h, yaw)
    HouseCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords['X'], coords['Y'], coords['Z'], yaw, 0.00, h, 80.00, false, 0)
    SetCamActive(HouseCam, true)
    RenderScriptCams(true, true, 500, true, true)
end

function OpenHouseContract(bool)
  SetNuiFocus(bool, bool)
  SendNUIMessage({
      type = "toggle",
      status = bool,
  })
end

function NearHouseGarage()
    return NearGarage
end

function GetGarageCoords()
    return Config.Houses[Currenthouse]['Garage']
end

function AddBlipForHouse()
    HDCore.Functions.GetPlayerData(function(PlayerData)
      for k, v in pairs(Config.Houses) do
         if Config.Houses[k]['Owner'] == PlayerData.citizenid then
            Blips = AddBlipForCoord(Config.Houses[k]['Coords']['Enter']['X'], Config.Houses[k]['Coords']['Enter']['Y'], Config.Houses[k]['Coords']['Enter']['Z'])
            SetBlipSprite (Blips, 40)
            SetBlipDisplay(Blips, 4)
            SetBlipScale  (Blips, 0.48)
            SetBlipAsShortRange(Blips, true)
            SetBlipColour(Blips, 26)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(Config.Houses[k]['Adres'])
            EndTextCommandSetBlipName(Blips)
            table.insert(HouseBlips, Blips)
         end
      end
    end)
end

function RefreshHouseBlips()
    RemoveHouseBlip()
    Citizen.SetTimeout(450, function()
        AddBlipForHouse()
    end)
end

function RemoveHouseBlip()
    if HouseBlips ~= nil then
      for k, v in pairs(HouseBlips) do
          RemoveBlip(v)
      end
      HouseBlips = {}
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

-- // NUI \\ --

RegisterNUICallback('buy', function()
  OpenHouseContract(false)
  if DoesCamExist(HouseCam) then
   RenderScriptCams(false, true, 500, true, true)
   SetCamActive(HouseCam, false)
   DestroyCam(HouseCam, true)
  end
  TriggerServerEvent('HD-housing:server:buy:house', Currenthouse)
end)

RegisterNUICallback('exit', function()
  OpenHouseContract(false)
  if DoesCamExist(HouseCam) then
    RenderScriptCams(false, true, 500, true, true)
    SetCamActive(HouseCam, false)
    DestroyCam(HouseCam, true)
  end
end)