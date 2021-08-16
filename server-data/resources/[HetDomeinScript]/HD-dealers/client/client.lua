local LoggedIn = false
local CurrentDealer = nil

HDCore = nil

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(450, function()
  TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
  Citizen.Wait(250)
  HDCore.Functions.TriggerCallback("HD-dealers:server:get:config", function(config)
    Config.Dealers = config
  end)
  LoggedIn = true
 end)
end)

-- Code

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(4)
      if LoggedIn then
        NearDealer = false
        for k, v in pairs(Config.Dealers) do 
          local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
          local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
             if Distance < 2.0 then 
                NearDealer = true
                --DrawMarker(2, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                --DrawText3D(v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'] + 0.15, '~g~E~w~ - Dealer')
                --[[if IsControlJustPressed(0, 38) then
                  TriggerEvent('HD-dealers:client:open:dealer')
                end ]]
                CurrentDealer = k
             end
         end
         if not NearDealer then
            Citizen.Wait(2500)
            CurrentDealer = nil
         end
      end
    end
end)

RegisterNetEvent('HD-dealers:client:open:dealer')
AddEventHandler('HD-dealers:client:open:dealer', function()
    Citizen.SetTimeout(350, function()
        SetupDealerSerials()
        if CurrentDealer ~= nil then 
          local Shop = {label = Config.Dealers[CurrentDealer]['Name'], items = Config.Dealers[CurrentDealer]['Products'], slots = 30}
          TriggerServerEvent("HD-inventory:server:OpenInventory", "shop", "Dealer_"..CurrentDealer, Shop)
        end
    end)
end)

RegisterNetEvent('HD-dealers:client:update:dealer:items')
AddEventHandler('HD-dealers:client:update:dealer:items', function(ItemData, Amount)
    TriggerServerEvent('HD-dealers:server:update:dealer:items', ItemData, Amount, CurrentDealer)
end)

RegisterNetEvent('HD-dealers:client:set:dealer:items')
AddEventHandler('HD-dealers:client:set:dealer:items', function(ItemData, Amount, Dealer)
    Config.Dealers[Dealer]["Products"][ItemData.slot].amount = Config.Dealers[Dealer]["Products"][ItemData.slot].amount - Amount
end)

RegisterNetEvent('HD-dealers:client:reset:items')
AddEventHandler('HD-dealers:client:reset:items', function()
  -- // Old thing \\
  --Config.Dealers[2]['Products'][1].amount = Config.Dealers[2]['Products'][1].resetamount
  --Config.Dealers[2]['Products'][2].amount = Config.Dealers[2]['Products'][2].resetamount
  --Config.Dealers[3]['Products'][1].amount = Config.Dealers[3]['Products'][1].resetamount
  --Config.Dealers[3]['Products'][2].amount = Config.Dealers[3]['Products'][2].resetamount
  --Config.Dealers[4]['Products'][1].amount = Config.Dealers[4]['Products'][1].resetamount
  --Config.Dealers[4]['Products'][1].amount = Config.Dealers[4]['Products'][2].resetamount
  --Config.Dealers[5]['Products'][1].amount = Config.Dealers[5]['Products'][1].resetamount -- Deze is sws uit
  --Config.Dealers[5]['Products'][2].amount = Config.Dealers[5]['Products'][2].resetamount -- Deze is ook sws uit

  -- // New thing \\
  Config.Dealers[1]['Products'][1].amount = Config.Dealers[1]['Products'][1].resetamount
  Config.Dealers[1]['Products'][2].amount = Config.Dealers[1]['Products'][2].resetamount
  Config.Dealers[2]['Products'][1].amount = Config.Dealers[2]['Products'][1].resetamount
  Config.Dealers[2]['Products'][2].amount = Config.Dealers[2]['Products'][2].resetamount
  Config.Dealers[2]['Products'][3].amount = Config.Dealers[2]['Products'][3].resetamount
  Config.Dealers[3]['Products'][1].amount = Config.Dealers[3]['Products'][1].resetamount
  Config.Dealers[4]['Products'][1].amount = Config.Dealers[4]['Products'][1].resetamount
  Config.Dealers[4]['Products'][2].amount = Config.Dealers[4]['Products'][2].resetamount
end)

function CanOpenDealerShop()
    if CurrentDealer ~= nil then
        return true
    end
end

function SetupDealerSerials()
    --Config.Dealers[5]["Products"][1].info.serie = Config.RandomStr(2) .. math.random(10,99)..Config.RandomStr(3)..math.random(100,999).. Config.RandomStr(2) ..math.random(1,9)
    --Config.Dealers[5]["Products"][2].info.serie = Config.RandomStr(2) .. math.random(10,99)..Config.RandomStr(3)..math.random(100,999).. Config.RandomStr(2) ..math.random(1,9)
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

Citizen.CreateThread(function() -- Peds
  -- // Sally De Pil \\ --
  Marleen = GetHashKey("s_f_y_scrubs_01")
  RequestModel(Marleen)
  while not HasModelLoaded(Marleen) do
  Wait(5)
  end

  Marleen_ped = CreatePed(5, Marleen , -271.54, 6320.75, 32.43 - 1, 357.47, 0, 0)
  FreezeEntityPosition(Marleen_ped, true) 
  SetEntityInvincible(Marleen_ped, true)
  SetBlockingOfNonTemporaryEvents(Marleen_ped, true)
  TaskStartScenarioInPlace(Marleen_ped, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
  -- // Einde \\ --

  -- // Robert Nesta \\ --
  Robert = GetHashKey("s_m_y_dealer_01")
  RequestModel(Robert)
  while not HasModelLoaded(Robert) do
   Wait(5)
  end

  Robert_ped = CreatePed(5, Robert , 391.08, -909.54,  29.42 - 1, 311.11, 0, 0)
  FreezeEntityPosition(Robert_ped, true) 
  SetEntityInvincible(Robert_ped, true)
  SetBlockingOfNonTemporaryEvents(Robert_ped, true)
  TaskStartScenarioInPlace(Robert_ped, "WORLD_HUMAN_SMOKING_POT", 0, true)
  -- // Einde \\ --

  -- // Peter Shank \\ --
  Sally = GetHashKey("u_m_m_partytarget")
  RequestModel(Sally)
  while not HasModelLoaded(Sally) do
  Wait(5)
  end

  Sally_ped = CreatePed(5, Sally , -1202.32, -2741.4,  14.13 - 1, 53.35, 0, 0)
  FreezeEntityPosition(Sally_ped, true) 
  SetEntityInvincible(Sally_ped, true)
  SetBlockingOfNonTemporaryEvents(Sally_ped, true)
  TaskStartScenarioInPlace(Sally_ped, "WORLD_HUMAN_LEANING", 0, true)
  -- // Einde \\ --

  -- // Tim de Klusser \\ --
  Tim = GetHashKey("s_m_m_gaffer_01")
  RequestModel(Tim)
  while not HasModelLoaded(Tim) do
  Wait(5)
  end

  Tim_ped = CreatePed(5, Tim, 764.99, -1359.1, 27.88 - 1, 4.23, 0, 0)
  FreezeEntityPosition(Tim_ped, true) 
  SetEntityInvincible(Tim_ped, true)
  SetBlockingOfNonTemporaryEvents(Tim_ped, true)
  TaskStartScenarioInPlace(Tim_ped, "WORLD_HUMAN_SMOKING", 0, true)
  -- // Einde \\ --

end)








  



  
 
  


