local TotalGoldBars = 0

HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Functions.CreateCallback('HD-pawnshop:server:has:gold', function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.Functions.GetItemByName("gold-necklace") ~= nil or Player.Functions.GetItemByName("gold-rolex") or Player.Functions.GetItemByName("diamond-ring") ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent('HD-pawnshop:server:sell:gold:items')
AddEventHandler('HD-pawnshop:server:sell:gold:items', function()
  local Player = HDCore.Functions.GetPlayer(source)
  local Price = 0
  if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
     for k, v in pairs(Player.PlayerData.items) do
         if Config.ItemPrices[Player.PlayerData.items[k].name] ~= nil then
            Price = Price + (Config.ItemPrices[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
            Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
         end
     end
     if Price > 0 then
       Player.Functions.AddMoney("cash", Price, "sold-pawn-items")
       TriggerClientEvent('HDCore:Notify', source, "You have sold your gold")
     end
  end
end)

RegisterServerEvent('HD-pawnshop:server:sell:gold:bars')
AddEventHandler('HD-pawnshop:server:sell:gold:bars', function()
    local Player = HDCore.Functions.GetPlayer(source)
    local GoldItem = Player.Functions.GetItemByName("gold-bar")
    Player.Functions.RemoveItem('gold-bar', GoldItem.amount)
    TriggerClientEvent("HD-inventory:client:ItemBox", source, HDCore.Shared.Items['gold-bar'], "remove")
    Player.Functions.AddMoney("cash", math.random(550, 800) * GoldItem.amount, "sold-pawn-items")
end)

RegisterServerEvent('HD-pawnshop:server:smelt:gold')
AddEventHandler('HD-pawnshop:server:smelt:gold', function()
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
        for k, v in pairs(Player.PlayerData.items) do
            if Config.SmeltItems[Player.PlayerData.items[k].name] ~= nil then
               local ItemAmount = (Player.PlayerData.items[k].amount / Config.SmeltItems[Player.PlayerData.items[k].name])
                if ItemAmount >= 1 then
                    ItemAmount = math.ceil(Player.PlayerData.items[k].amount / Config.SmeltItems[Player.PlayerData.items[k].name])
                    if Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k) then
                        TriggerClientEvent("HD-inventory:client:ItemBox", source, HDCore.Shared.Items[Player.PlayerData.items[k].name], "remove")
                        TotalGoldBars = TotalGoldBars + ItemAmount
                        if TotalGoldBars > 0 then
                          TriggerClientEvent('HD-pawnshop:client:start:process', -1)
                        end
                    end
                end
            end
        end
     end
end)

-- RegisterServerEvent('HD-pawnshop:server:redeem:gold:bars')
-- AddEventHandler('HD-pawnshop:server:redeem:gold:bars', function()
--     local Player = HDCore.Functions.GetPlayer(source)
--     Player.Functions.AddItem("gold-bar", TotalGoldBars)
--     TriggerClientEvent("HD-inventory:client:ItemBox", source, HDCore.Shared.Items["gold-bar"], "add")
--     TriggerClientEvent('HD-pawnshop:server:reset:smelter', -1)
-- end)

RegisterServerEvent('HD-pawnshop:server:redeem:gold:bars')
AddEventHandler('HD-pawnshop:server:redeem:gold:bars', function()
    local Player = HDCore.Functions.GetPlayer(source)
    if TotalGoldBars > 0 then
        if Player.Functions.AddItem("gold-bar", TotalGoldBars) then
            TotalGoldBars = 0
            TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items["gold-bar"], "add")
            TriggerClientEvent('HD-pawnshop:server:reset:smelter', -1)
        end
    end
end)