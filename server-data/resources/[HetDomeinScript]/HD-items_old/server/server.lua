HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

-- BurgerShot

HDCore.Functions.CreateUseableItem("burger-bleeder", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:eat', source, 'burger-bleeder', 'hamburger')
    end
end)

HDCore.Functions.CreateUseableItem("burger-moneyshot", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:eat', source, 'burger-moneyshot', 'hamburger')
    end
end)

HDCore.Functions.CreateUseableItem("burger-torpedo", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:eat', source, 'burger-torpedo', 'hamburger')
    end
end)

HDCore.Functions.CreateUseableItem("burger-heartstopper", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:eat', source, 'burger-heartstopper', 'hamburger')
    end
end)

HDCore.Functions.CreateUseableItem("burger-softdrink", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink', source, 'burger-softdrink', 'burger-soft')
    end
end)

HDCore.Functions.CreateUseableItem("burger-fries", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:eat', source, 'burger-fries', 'burger-fries')
    end
end)

HDCore.Functions.CreateUseableItem("burger-box", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-burgershot:client:open:box', source, item.info.boxid)
    end
end)

HDCore.Functions.CreateUseableItem("sekspop", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:sekspop', source)
    end
end)

HDCore.Functions.CreateUseableItem("dildo", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:dildo', source)
    end
end)

HDCore.Functions.CreateUseableItem("burger-coffee", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink', source, 'burger-coffee', 'coffee')
    end
end)

HDCore.Functions.CreateUseableItem("coffee", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink', source, 'coffee', 'coffee')
    end
end)
-- // Lockpick \\ --
HDCore.Functions.CreateUseableItem("advancedlockpick", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:use:lockpick', source, true)
    end
end)

HDCore.Functions.CreateUseableItem("drill", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:use:drill', source)
    end
end)

HDCore.Functions.CreateUseableItem("lockpick", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:use:lockpick', source, false)
    end
end)
-- // Eten \\ --

HDCore.Functions.CreateUseableItem("water", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink', source, 'water', 'water')
    end
end)

HDCore.Functions.CreateUseableItem("ecola", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink', source, 'ecola', 'cola')
    end
end)

HDCore.Functions.CreateUseableItem("sprunk", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink', source, 'sprunk', 'cola')
    end
end)

HDCore.Functions.CreateUseableItem("slushy", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink:slushy', source)
    end
end)

HDCore.Functions.CreateUseableItem("sandwich", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:eat', source, 'sandwich', 'sandwich')
    end
end)

HDCore.Functions.CreateUseableItem("carapils", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drinkbeer', source, 'beer', 'beer')
    end
end)

HDCore.Functions.CreateUseableItem("pizza", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:use:pizza', source)
    end
end)


HDCore.Functions.CreateUseableItem("chocolade", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:eat', source, 'chocolade', 'chocolade')
    end
end)

HDCore.Functions.CreateUseableItem("donut", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:eat', source, 'donut', 'donut')
    end
end)

HDCore.Functions.CreateUseableItem("glasswhiskey", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink:alcohol', source, 'glasswhiskey', 'glasswhiskey')
    end
end)

HDCore.Functions.CreateUseableItem("vodka", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink:alcohol', source, 'vodka', 'vodka')
    end
end)

HDCore.Functions.CreateUseableItem("glasswine", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink:alcohol', source, 'glasswine', 'glasswine')
    end
end)

HDCore.Functions.CreateUseableItem("glassbeer", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink:alcohol', source, 'glassbeer', 'glassbeer')
    end
end)

HDCore.Functions.CreateUseableItem("bloodymary", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink:alcohol', source, 'bloodymary', 'bloodymary')
    end
end)

HDCore.Functions.CreateUseableItem("champagne", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink:alcohol', source, 'champagne', 'champagne')
    end
end)

HDCore.Functions.CreateUseableItem("glasschampagne", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink:alcohol', source, 'glasschampagne', 'glasschampagne')
    end
end)

HDCore.Functions.CreateUseableItem("dusche", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink:alcohol', source, 'dusche', 'dusche')
    end
end)

HDCore.Functions.CreateUseableItem("tequila", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink:alcohol', source, 'tequila', 'tequila')
    end
end)

HDCore.Functions.CreateUseableItem("tequilashot", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink:alcohol', source, 'tequilashot', 'tequilashot')
    end
end)

HDCore.Functions.CreateUseableItem("whitewine", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink:alcohol', source, 'whitewine', 'whitewine')
    end
end)

HDCore.Functions.CreateUseableItem("pinacolada", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:drink:alcohol', source, 'pinacolada', 'pinacolada')
    end
end)

-- Drugs --


HDCore.Functions.CreateUseableItem("key-a", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-illegal:client:use:key', source, 'key-a')
    end
end)

HDCore.Functions.CreateUseableItem("key-b", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-illegal:client:use:key', source, 'key-b')
    end
end)

HDCore.Functions.CreateUseableItem("key-c", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-illegal:client:use:key', source, 'key-c')
    end
end)
HDCore.Functions.CreateUseableItem("packed-coke-brick", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-illegal:client:unpack:coke', source)
    end
end)
HDCore.Functions.CreateUseableItem("burner-phone", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-illegal:client:start:burner-call', source)
    end
end)

HDCore.Functions.CreateUseableItem("weed_nutrition", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-houseplants:client:feed:plants', source)
    end
end)

HDCore.Functions.CreateUseableItem("oxy", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("HD-hospital:client:use:painkillers", source)
    end
end)

HDCore.Functions.CreateUseableItem("white-widow-seed", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-houseplants:client:plant', source, 'White Widow', 'White-Widow', 'white-widow-seed')
    end
end)

HDCore.Functions.CreateUseableItem("skunk-seed", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-houseplants:client:plant', source, 'Skunk', 'Skunk', 'skunk-seed')
    end
end)

HDCore.Functions.CreateUseableItem("purple-haze-seed", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-houseplants:client:plant', source, 'Purple Haze', 'Purple-Haze', 'purple-haze-seed')
    end
end)

HDCore.Functions.CreateUseableItem("og-kush-seed", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-houseplants:client:plant', source, 'OG Kush', 'Og-Kush', 'og-kush-seed')
    end
end)

HDCore.Functions.CreateUseableItem("amnesia-seed", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-houseplants:client:plant', source, 'Amnesia', 'Amnesia', 'amnesia-seed')
    end
end)

HDCore.Functions.CreateUseableItem("ak47-seed", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-houseplants:client:plant', source, 'AK47', 'AK47', 'ak47-seed')
    end
end)

-- // Other \\ --

HDCore.Functions.CreateUseableItem("binoculars", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
    TriggerClientEvent("binoculars:Toggle", source)
end)

HDCore.Functions.CreateUseableItem("duffel-bag", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:use:duffel-bag', source, item.info.bagid)
    end
end)

HDCore.Functions.CreateUseableItem("bag", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
    TriggerClientEvent("HD-inventory:bag:UseBag", source)
    TriggerEvent("HD-log:server:CreateLog", "inventory", "Bags", "white", "Citizen opens a bag **"..GetPlayerName(source).."** Burger ID: **"..Player.PlayerData.citizenid.. "**", false)
end)

HDCore.Functions.CreateUseableItem("armor", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:use:armor', source)
    end
end)

HDCore.Functions.CreateUseableItem("heavy-armor", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:use:heavy', source)
    end
end)

HDCore.Functions.CreateUseableItem("interventieband", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:use:interventieband', source)
    end
end)

HDCore.Functions.CreateUseableItem("stethoscoop", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:use:stethoscoop', source)
    end
end)

HDCore.Functions.CreateUseableItem("repairkit", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:use:repairkit', source)
    end
end)


HDCore.Functions.CreateUseableItem("jerrycan", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:use:jerrycan', source)
    end
end)

HDCore.Functions.CreateUseableItem("bandage", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-hospital:client:use:bandage', source)
    end
end)

HDCore.Functions.CreateUseableItem("health-pack", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-hospital:client:use:health-pack', source)
    end
end)

HDCore.Functions.CreateUseableItem("painkillers", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-hospital:client:use:painkillers', source)
    end
end)

HDCore.Functions.CreateUseableItem("joint", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:use:joint', source)
    end
end)

HDCore.Functions.CreateUseableItem("superjoint", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:use:superjoint', source)
    end
end)

HDCore.Functions.CreateUseableItem("coke-bag", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:use:coke', source)
    end
end)

HDCore.Functions.CreateUseableItem("lsd-strip", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("HD-items:client:use:lsd", source)
    end
end)

HDCore.Functions.CreateUseableItem("meth-bag", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
    TriggerClientEvent("HD-items:client:use:meth", source)
end)

HDCore.Functions.CreateUseableItem("coin", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-items:client:coinflip', source)
    end
end)

HDCore.Functions.CreateUseableItem("dice", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
    local DiceItems = Player.Functions.GetItemByName("dice")
      local Amount = 2
      local Sides = 6
      if DiceItems ~= nil then
             TriggerClientEvent('HD-items:client:dobbel', source, Amount, Sides)
      else
        TriggerClientEvent('HDCore:Notify', source, "You dont have any dices", "error", 3500)
      end
end)

HDCore.Commands.Add("dices", "Play with dices", {{name="aantal", help="Number of dices"}, {name="sides", help="Sides"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    local DiceItems = Player.Functions.GetItemByName("dice")
    if args[1] ~= nil and args[2] ~= nil then 
      local Amount = tonumber(args[1])
      local Sides = tonumber(args[2])
      if DiceItems ~= nil then
         if (Sides > 0 and Sides <= 20) and (Amount > 0 and Amount <= 5) then 
             TriggerClientEvent('HD-items:client:dobbel', source, Amount, Sides)
         else
             TriggerClientEvent('HDCore:Notify', source, "To many dices 0 (max: 5) or to many sides 0 (max: 20)", "error", 3500)
         end
      else
        TriggerClientEvent('HDCore:Notify', source, "You dont have any dices", "error", 3500)
      end
  end
end)

HDCore.Commands.Add("armoroff", "Take of your armor", {}, false, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("HD-items:client:reset:armor", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "This command is for emergency personal")
    end
end)

HDCore.Functions.CreateCallback('HD-items:server:giveitem', function(ItemName, Amount)
    local Player = HDCore.Functions.GetPlayer(source)
    Player.Functions.AddItem(ItemName, Amount)
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items[ItemName], "add")
end)

HDCore.Functions.CreateUseableItem("diving_gear", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)

    TriggerClientEvent("HD-diving:client:UseGear", source, true)
end)

HDCore.Functions.CreateUseableItem("parachute", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("HD-items:client:UseParachute", source)
    end
end)

HDCore.Commands.Add("parachuteoff", "Take of your parachute", {}, false, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
        TriggerClientEvent("HD-items:client:ResetParachute", source)
end)

HDCore.Commands.Add("divesuit", "Remove diving gear", {}, false, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    TriggerClientEvent("HD-diving:client:UseGear", source, false)
end)

HDCore.Commands.Add("banduit", "Doe je interventieband uit", {}, false, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("HD-items:client:reset:band", source)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je hebt geen bevoegdheden tot dit commando.")
    end
end)

RegisterServerEvent("HD-items:server:AddParachute")
AddEventHandler("HD-items:server:AddParachute", function()
    local src = source
    local Ply = HDCore.Functions.GetPlayer(src)

    Ply.Functions.AddItem("parachute", 1)
end)

RegisterServerEvent('HD-diving:server:RemoveGear')
AddEventHandler('HD-diving:server:RemoveGear', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)


    Player.Functions.RemoveItem("diving_gear", 1)
    TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items["diving_gear"], "remove")
end)

RegisterServerEvent('HD-diving:server:GiveBackGear')
AddEventHandler('HD-diving:server:GiveBackGear', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    
    Player.Functions.AddItem("diving_gear", 1)
    TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items["diving_gear"], "add")
end)

