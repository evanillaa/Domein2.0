local NearShop = false
local isLoggedIn = true
local CurrentShop = nil

HDCore = nil

TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    

   
RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
 Citizen.SetTimeout(1250, function()
   TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
    Citizen.Wait(250)
    HDCore.Functions.TriggerCallback("HD-stores:server:GetConfig", function(config)
      Config = config
    end)
   isLoggedIn = true
 end)
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            NearShop = false
            for k, v in pairs(Config.Shops) do
                local PlayerCoords = GetEntityCoords(PlayerPedId())
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Coords']['X'], v['Coords']['Y'], v['Coords']['Z'], true)
                if Distance < 2.5 then
                    NearShop = true
                    CurrentShop = k
                end
            end
            if not NearShop then
                Citizen.Wait(1000)
                CurrentShop = nil
            end
        end
    end
end)

RegisterNetEvent('HD-stores:server:open:shop')
AddEventHandler('HD-stores:server:open:shop', function()
  Citizen.SetTimeout(350, function()
      if CurrentShop ~= nil then 
        local Shop = {label = Config.Shops[CurrentShop]['Name'], items = Config.Shops[CurrentShop]['Product'], slots = 30}
        TriggerServerEvent("HD-inventory:server:OpenInventory", "shop", "Itemshop_"..CurrentShop, Shop)
      end
  end)
end)

RegisterNetEvent('HD-stores:client:update:store')
AddEventHandler('HD-stores:client:update:store', function(ItemData, Amount)
    --TriggerServerEvent('HD-stores:server:update:store:items', CurrentShop, ItemData, Amount)
end)

RegisterNetEvent('HD-stores:client:set:store:items')
AddEventHandler('HD-stores:client:set:store:items', function(ItemData, Amount, ShopId)
    Config.Shops[ShopId]["Product"][ItemData.slot].amount = Config.Shops[ShopId]["Product"][ItemData.slot].amount - Amount
end)

-- // Function \\ --

function IsNearShop()
    return NearShop
end