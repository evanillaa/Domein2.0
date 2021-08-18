local NearHack = false

HDCore = nil
LoggedIn = false

local closestStation = 0
local currentStation = 0
CurrentCops = 0
local currentFires = {}
local currentGate = 0
inRange = false
inRange2 = false

Citizen.CreateThread(function()
	while HDCore == nil do
        TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)  
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("HDCore:Client:OnPlayerLoaded")
AddEventHandler("HDCore:Client:OnPlayerLoaded", function()
    HDCore.Functions.TriggerCallback('HD-bobcatheist:server:GetConfig', function(config)
        Config = config
    end)
    LoggedIn = true
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist

        --if HDCore ~= nil then
            inRange = false
            inRange2 = false
            for k, v in pairs(Config.Thermite) do
                dist = #(pos - vector3(Config.Thermite[k].coords.x, Config.Thermite[k].coords.y, Config.Thermite[k].coords.z))
                if dist < 1.5 then
                    closestStation = k
                    inRange = true
                    --print(inRange)
                end
            end

            for k, v in pairs(Config.Card) do
                dist = #(pos - vector3(Config.Card[k].coords.x, Config.Card[k].coords.y, Config.Card[k].coords.z))
                if dist < 1.5 then
                    inRange2 = true
                    --print(inRange)
                end
            end

            if not inRange then
                Citizen.Wait(1000)
                closestStation = 0
            end
        --end
        Citizen.Wait(3)
    end
end)


local requiredItemsShowed = false
local requiredItems = {}

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        --if HDCore ~= nil then
            if closestStation ~= 0 then
                if not Config.Thermite[closestStation].hit then
                    requiredItems = {
                        [1] = {name = HDCore.Shared.Items["thermite"]["name"], image = HDCore.Shared.Items["thermite"]["image"]},
                    }
                    DrawMarker(2, Config.Thermite[closestStation].coords.x, Config.Thermite[closestStation].coords.y, Config.Thermite[closestStation].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.1, 255, 255, 255, 155, 0, 0, 0, 1, 0, 0, 0)
                    local dist = #(pos - vector3(Config.Thermite[closestStation].coords.x, Config.Thermite[closestStation].coords.y, Config.Thermite[closestStation].coords.z))
                    if dist < 1 then
                        if not requiredItemsShowed then
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                            print(closestStation)
                        end
                    else
                        if requiredItemsShowed then
                            requiredItemsShowed = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                        end
                    end
                end
            else
                Citizen.Wait(1500)
            end
        --end
        Citizen.Wait(1)
    end
end)

function eersteanim()
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(50)
    end
    local ped = PlayerPedId()

    SetEntityHeading(ped, 170.52)
    Citizen.Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
    local bagscene = NetworkCreateSynchronisedScene(882.37554, -2258.035, 32.461315, rotx, roty, rotz + 1.1, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), 882.37554, -2258.035, 32.461315,  true,  true, false)

    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Citizen.Wait(1500)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local bomba = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.3,  true,  true, true)

    SetEntityCollision(bomba, false, true)
    AttachEntityToEntity(bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Citizen.Wait(2000)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    DetachEntity(bomba, 1, 1)
    FreezeEntityPosition(bomba, true)
    TriggerServerEvent("fuze:particleserver", method)
    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

    NetworkStopSynchronisedScene(bagscene)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
    Citizen.Wait(5000)
    ClearPedTasks(ped)
    DeleteObject(bomba)
    StopParticleFxLooped(effect, 0)
	ExecuteCommand("fuze")
    ExecuteCommand("prop")
end

function tweedeanim()
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(50)
    end
    local ped = PlayerPedId()

    SetEntityHeading(ped, 170.52)
    Citizen.Wait(100)
    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
    local bagscene = NetworkCreateSynchronisedScene(880.9819, -2263.831, 32.44168, rotx, roty, rotz + 1.1, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), 880.9819, -2263.831, 32.44168,  true,  true, false)

    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Citizen.Wait(1500)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local bomba = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.3,  true,  true, true)

    SetEntityCollision(bomba, false, true)
    AttachEntityToEntity(bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Citizen.Wait(2000)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    DetachEntity(bomba, 1, 1)
    FreezeEntityPosition(bomba, true)
    TriggerServerEvent("fuze:particleserversec", method)
    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

    NetworkStopSynchronisedScene(bagscene)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
    Citizen.Wait(5000)
    ClearPedTasks(ped)
    DeleteObject(bomba)
    StopParticleFxLooped(effect, 0)
	ExecuteCommand("fuze2")
    ExecuteCommand("prop")
end

RegisterNetEvent('fuze:getdoor') -- BİRİNCİ KAPI
AddEventHandler('fuze:getdoor', function()
    if closestStation == 1 and not inRange2 then
        TriggerEvent('fuze:firstdoor')
    elseif closestStation == 2 and not inRange2 then
        TriggerEvent('fuze:secondoor')
    elseif inRange2 then
        TriggerEvent('fuze:thirdoor')
    end
end)

RegisterNetEvent('fuze:thirdoor')
AddEventHandler('fuze:thirdoor', function()
    HDCore.Functions.Progressbar("using_card", "Opening door", 10000, false, true, {
        disableMovement = false,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function(status) -- Done  
        if not status then
            print("voor create ped")
            TriggerEvent("fuze:bobcatcreateped")            
            print("ped create")   
            TriggerServerEvent('fuze:removeCard')
            print("Ik ben een heel LEKKER WIJF")
            Citizen.Wait(1000)
            ExecuteCommand("fuze3")
            Citizen.Wait(1000)         
        end
    end)
end)

RegisterNetEvent('fuze:firstdoor') -- BİRİNCİ KAPI
AddEventHandler('fuze:firstdoor', function()
    if inRange then
        exports["memorygame"]:thermiteminigame(1, 1, 1, 1,
        function() -- success
            TriggerEvent("fuze:bobcatdeur")
            TriggerServerEvent('fuze:removeItem')
        end,
        function() -- failure
            TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Failure!'})
        end)
    end    
end)

RegisterNetEvent('fuze:secondoor')
AddEventHandler('fuze:secondoor', function()
    exports["memorygame"]:thermiteminigame(1, 1, 1, 1,
    function() -- success
        TriggerEvent("fuze:bobcatdeurtje")
        TriggerServerEvent('fuze:removeItem')
    end,
    function() -- failure
        TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Failure!'})
    end)
end)

function StartMiniGame()
    exports["memorygame"]:thermiteminigame(10, 3, 3, 10,
    function() -- success
        HDCore.Functions.Notify("Success", "error")
        TriggerEvent("fuze:bobcatdeurtje")
        end,
    function()       
        HDCore.Functions.Notify("Je hebt gefaalt..", "error")
        TriggerServerEvent('HD-bobcatheist:server:set:cooldown', false)
        TriggerEvent('HD-inventory:client:set:busy', false)
    end)
end

RegisterNetEvent("fuze:ptfxparticle")
AddEventHandler("fuze:ptfxparticle", function(method)
    local ptfx

    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(1)
    end
        ptfx = vector3(882.1320, -2257.34, 32.461)
    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Citizen.Wait(4000)
    print("fuze")
    StopParticleFxLooped(effect, 0)
end)

RegisterNetEvent("fuze:ptfxparticlesec")
AddEventHandler("fuze:ptfxparticlesec", function(method)
    local ptfx

    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(1)
    end
        ptfx = vector3(881.0317, -2263.50, 32.441)
    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Citizen.Wait(4000)
    print("fuze")
    StopParticleFxLooped(effect, 0)
end)

RegisterNetEvent('fuze:bobcatdeurtje')
AddEventHandler('fuze:bobcatdeurtje', function()
	tweedeanim()
	Citizen.Wait(3500)
	ExecuteCommand("fuze2")
	TriggerServerEvent('HD-doorlock:server:updateState', 34, false)
end)

RegisterNetEvent('fuze:bobcatdeur')
AddEventHandler('fuze:bobcatdeur', function()
	eersteanim()
	Citizen.Wait(3500)
	ExecuteCommand("fuze")
    TriggerServerEvent('HD-doorlock:server:updateState', 33, false)
end)

RegisterCommand("fuze", function()
    TriggerServerEvent('HD-doorlock:server:updateState', 33, false)
end)

RegisterCommand("fuze2", function()
	TriggerServerEvent('HD-doorlock:server:updateState', 34, false)
end)

RegisterCommand("fuze3", function()
	TriggerServerEvent('HD-doorlock:server:updateState', 35, false)
end)

--[[RegisterCommand("fuze4", function()
	TriggerServerEvent('HD-doorlock:change-lock-state', 486, false)
end)]]

RegisterCommand("bewakers", function()
	TriggerEvent("fuze:bobcatcreateped")
end)

RegisterCommand("prop", function()
	TriggerEvent("fuze:propcreate")
end)

RegisterNetEvent('fuze:propcreate')
AddEventHandler('fuze:propcreate', function()
    local weaponbox = CreateObject(GetHashKey("ex_prop_crate_ammo_sc"), 888.0774, -2287.33, 31.441, true,  true, true)
    CreateObject(weaponbox)
    SetEntityHeading(weaponbox, 176.02)
    FreezeEntityPosition(weaponbox, true)

    local weaponbox2 = CreateObject(GetHashKey("ex_prop_crate_expl_sc"), 886.8, -2281.7, 31.441, true,  true, true)
    CreateObject(weaponbox2)
    SetEntityHeading(weaponbox2, 352.02)
    FreezeEntityPosition(weaponbox2, true) 

    local weaponbox3 = CreateObject(GetHashKey("ex_prop_crate_expl_bc"), 882.1840, -2286.8, 31.441, true,  true, true)
    CreateObject(weaponbox3)
    SetEntityHeading(weaponbox3, 158.02)
    FreezeEntityPosition(weaponbox3, true) 

    local weaponbox4 = CreateObject(GetHashKey("ex_prop_crate_ammo_bc"), 881.4557, -2282.61, 31.441, true,  true, true)
    CreateObject(weaponbox4)
    SetEntityHeading(weaponbox4, 52.02)
    FreezeEntityPosition(weaponbox4, true)
end)


RegisterNetEvent('fuze:bobcatcreateped')
AddEventHandler('fuze:bobcatcreateped', function()
	local bobcatped2 = GetHashKey('csb_mweather')
	AddRelationshipGroup('fuze')

		RequestModel(1456041926)
		bobcatped1 = CreatePed(30, 883.4797, -2273.77, 32.441, 30.568, 88.00, true, false)
		SetPedArmour(bobcatped1, 500)
		SetPedAsEnemy(bobcatped1, true)
		SetPedRelationshipGroupHash(bobcatped1, 'fuze')
		GiveWeaponToPed(bobcatped1, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		TaskCombatPed(bobcatped1, GetPlayerPed(-1))
		SetPedAccuracy(bobcatped1, 100)
		SetPedDropsWeaponsWhenDead(bobcatped1, false)
		
		bobcatped2 = CreatePed(30, 1456041926, 892.4030, -2275.25, 32.441, 360.00, true, false)
		SetPedArmour(bobcatped2, 500)
		SetPedAsEnemy(bobcatped2, true)
		SetPedRelationshipGroupHash(bobcatped2, 'fuze')
		GiveWeaponToPed(bobcatped2, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		TaskCombatPed(bobcatped2, GetPlayerPed(-1))
		SetPedAccuracy(bobcatped2, 100)
		SetPedDropsWeaponsWhenDead(bobcatped2, false)

		bobcatped3 = CreatePed(30, 1456041926, 892.6776, -2281.26, 32.441, 350.00, true, false)
		SetPedArmour(bobcatped3, 500)
		SetPedAsEnemy(bobcatped3, true)
		SetPedRelationshipGroupHash(bobcatped3, 'fuze')
		GiveWeaponToPed(bobcatped3, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		TaskCombatPed(bobcatped3, GetPlayerPed(-1))
		SetPedAccuracy(bobcatped3, 100)
		SetPedDropsWeaponsWhenDead(bobcatped3, false)

		bobcatped4 = CreatePed(30, 1456041926, 889.3485, -2292.47, 32.441, 350.00, true, false)
		SetPedArmour(bobcatped4, 500)
		SetPedAsEnemy(bobcatped4, true)
		SetPedRelationshipGroupHash(bobcatped4, 'fuze')
		GiveWeaponToPed(bobcatped4, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		TaskCombatPed(bobcatped4, GetPlayerPed(-1))
		SetPedAccuracy(bobcatped4, 100)
		SetPedDropsWeaponsWhenDead(bobcatped4, false)

		bobcatped5 = CreatePed(30, 1456041926, 880.9854, -2293.40, 32.441, 300.00, true, false)
		SetPedArmour(bobcatped5, 500)
		SetPedAsEnemy(bobcatped5, true)
		SetPedRelationshipGroupHash(bobcatped5, 'fuze')
		GiveWeaponToPed(bobcatped5, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		TaskCombatPed(bobcatped5, GetPlayerPed(-1))
		SetPedAccuracy(bobcatped5, 100)
		SetPedDropsWeaponsWhenDead(bobcatped5, false)


		bobcatped6 = CreatePed(30, 1456041926, 873.4896, -2293.21, 32.441, 266.00, true, false)
		SetPedArmour(bobcatped6, 500)
		SetPedAsEnemy(bobcatped6, true)
		SetPedRelationshipGroupHash(bobcatped6, 'fuze')
		GiveWeaponToPed(bobcatped6, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		TaskCombatPed(bobcatped6, GetPlayerPed(-1))
		SetPedAccuracy(bobcatped6, 100)
		SetPedDropsWeaponsWhenDead(bobcatped6, false)

		bobcatped7 = CreatePed(30, 1456041926,894.1248, -2287.51, 32.446, 298.00, true, false)
		SetPedArmour(bobcatped7, 500)
		SetPedAsEnemy(bobcatped7, true)
		SetPedRelationshipGroupHash(bobcatped7, 'fuze')
		GiveWeaponToPed(bobcatped7, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		TaskCombatPed(bobcatped7, GetPlayerPed(-1))
		SetPedAccuracy(bobcatped7, 100)
		SetPedDropsWeaponsWhenDead(bobcatped7, false)

		bobcatped8 = CreatePed(30, 1456041926, 896.9407, -2280.87, 32.441, 266.00, true, false)
		SetPedArmour(bobcatped8, 500)
		SetPedAsEnemy(bobcatped8, true)
		SetPedRelationshipGroupHash(bobcatped8, 'fuze')
		GiveWeaponToPed(bobcatped8, GetHashKey('WEAPON_CARBINERIFLE'), 250, false, true)
		TaskCombatPed(bobcatped8, GetPlayerPed(-1))
		SetPedAccuracy(bobcatped8, 100)
		SetPedDropsWeaponsWhenDead(bobcatped8, false)
end)

RegisterCommand('bomb', function ()
	local interiorid = GetInteriorAtCoords(883.4142, -2282.372, 31.44168)
	ActivateInteriorEntitySet(interiorid, "np_prolog_broken")
	RemoveIpl(interiorid, "np_prolog_broken")
	DeactivateInteriorEntitySet(interiorid, "np_prolog_clean")
	RefreshInterior(interiorid)
end)

	
Citizen.CreateThread(function()
    local hash = GetHashKey("cs_drfriedlander")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
end
    rehineped = CreatePed("PED_TYPE_CIVFEMALE", "cs_drfriedlander", 870.1760, -2288.20, 31.441, 175.21, false, false)
    SetBlockingOfNonTemporaryEvents(rehineped, true)
            SetPedDiesWhenInjured(rehineped, false)
            SetPedCanPlayAmbientAnims(rehineped, true)
            SetPedCanRagdollFromPlayerImpact(rehineped, false)
	        SetEntityInvincible(rehineped, false)
    --loadAnimDict( "random@arrests" )
	--RequestAnimDict('random@arrests@busted', function()
    --TaskPlayAnim(rehineped, 'random@arrests@busted', 'idle_a', 8.0, 8.0, -1, 33, 0, 0, 0, 0)
    loadAnimDict( "random@arrests" )
    loadAnimDict( "random@arrests@busted" )
    TaskPlayAnim( rehineped, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
    Wait (4000)
    TaskPlayAnim( rehineped, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
    Wait (500)
    TaskPlayAnim( rehineped, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
    Wait (1000)
    TaskPlayAnim( rehineped, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
end)

RegisterNetEvent('fuze:pedwalk') -- PED WALK
AddEventHandler('fuze:pedwalk', function()
	ClearPedTasks(rehineped)
	TaskGoStraightToCoord(rehineped, 869.30865, -2290.879, 32.441646, 258.6455, -1, 265.61, 0)
	Citizen.Wait(5000)
	TaskGoStraightToCoord(rehineped, 892.98449, -2293.389, 32.441646, 93.859413 -1, 350.61, 0) 
	Citizen.Wait(13000)
	TriggerEvent("fuze:pedwalkje")
end)

RegisterNetEvent('fuze:boemwalk') -- PED WALK
AddEventHandler('fuze:boemwalk', function()
    TriggerEvent( "player:receiveItem", "1593441988", 2 )
    TriggerEvent( "player:receiveItem", "-1746263880", 2 )
end)

RegisterNetEvent('fuze:pedwalkje') -- PED WALK
AddEventHandler('fuze:pedwalkje', function()
	TaskGoStraightToCoord(rehineped, 894.6337, -2284.97, 32.441, 150.0, -1, 82.56, 0)
	Citizen.Wait(7500)
    loadAnimDict( "weapons@projectile@grenade_str" )
	--loadAnimDict('weapons@projectile@grenade_str', function()
    --TaskPlayAnim(PlayerPedId(), 'weapons@projectile@grenade_str', 'throw_h_fb_forward', 8.0, 8.0, -1, 33, 0, 0, 0, 0)
    --end)
    TaskPlayAnim( rehineped, "weapons@projectile@grenade_str", "throw_h_fb_forward", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
	Citizen.Wait(1000)
	AddExplosion(890.7849, -2284.88, 32.441, 32, 150000.0, true, false, 4.0)
	AddExplosion(894.0084, -2284.90, 32.580, 32, 150000.0, true, false, 4.0)
	ExecuteCommand("bomb")
    TriggerEvent("fuze:propcreate")
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end 