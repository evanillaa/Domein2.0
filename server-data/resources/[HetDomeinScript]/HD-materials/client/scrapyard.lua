local NearScrapYard = false
local CurrentScrapYard = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
         local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
         NearScrapYard = false
         for k, v in pairs(Config.ScrapyardLocations) do 
             local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
             if Area < 7.5 then
                CurrentScrapYard = k
                NearScrapYard = true
             end
         end
         if not NearScrapYard then
            Citizen.Wait(2500)
            CurrentScrapYard = false
         end
        end
    end
end)

RegisterNetEvent('HD-materials:client:scrap:vehicle')
AddEventHandler('HD-materials:client:scrap:vehicle', function()
    local Vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
    --local veh = GetVehiclePedIsIn(PlayerPedId(),false)
    local driver = GetPedInVehicleSeat(Vehicle, -1)
    if Config.CanScrap then
        Config.CanScrap = false
	    -- HDCore.Functions.TriggerCallback('HD-materials:server:is:vehicle:owned', function(IsOwned)
        -- if not IsOwned then
			if driver == PlayerPedId() then
            -- start scrap
            local Time = math.random(30000, 40000)
	        ScrapVehicleAnim(Time)
	    	HDCore.Functions.Progressbar("scrap-vehicle", "Voertuig slopen..", Time, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
               
                HDCore.Functions.DeleteVehicle(Vehicle)
                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                TriggerServerEvent('HD-materials:server:scrap:reward')
                --local curRep = Player.PlayerData.metadata["alcoholaddiction"]
                --Player.Functions.SetMetaData('alcoholaddiction', (curRep + 1))
                Citizen.SetTimeout((1000 * 60) * 2, function()
                   Config.CanScrap = true
                end)
            end, function() -- Cancel
                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                HDCore.Functions.Notify("Geannuleerd..", "error")
            end)
            else
                HDCore.Functions.Notify("Je zit niet op de bestuurderskant...", "error")
            end

	    -- else
	    -- 	HDCore.Functions.Notify("Dit voertuig kan niet worden geschraapt.", "error")									end
        -- end, GetVehicleNumberPlateText(Vehicle))
    else
      HDCore.Functions.Notify("Je moet nog even wachten..", "error")	
    end								
end)

function IsNearScrapYard()
  if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
      return NearScrapYard
  else
      return false
  end
end

function ScrapVehicleAnim(time)
    time = (time / 1000)
    exports['HD-assets']:RequestAnimationDict("mp_car_bomb")
    TaskPlayAnim(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    Scrapping = true
    Citizen.CreateThread(function()
        while Scrapping do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(2000)
			time = time - 2
            if time <= 0 then
                Scrapping = false
                StopAnimTask(GetPlayerPed(-1), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

Citizen.CreateThread(function() -- Peds

    Marleen = GetHashKey("s_m_y_armymech_01")
    RequestModel(Marleen)
    while not HasModelLoaded(Marleen) do
    Wait(5)
    end
  
    Marleen_ped = CreatePed(5, Marleen , -420.18, -1688.0, 19.03 - 1, 105.11, 0, 0)
    FreezeEntityPosition(Marleen_ped, true) 
    SetEntityInvincible(Marleen_ped, true)
    SetBlockingOfNonTemporaryEvents(Marleen_ped, true)
    TaskStartScenarioInPlace(Marleen_ped, "WORLD_HUMAN_CLIPBOARD", 0, true)

  end)