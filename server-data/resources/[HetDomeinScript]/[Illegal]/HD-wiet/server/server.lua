HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)
  
HDCore.Functions.CreateCallback('HD-wiet:server:GetConfig', function(source, cb)
    cb(Config)
end)

HDCore.Functions.CreateUseableItem("scissor", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('HD-wiet:client:use:scissor', source)
    end
end)


RegisterServerEvent('HD-wiet:server:set:dry:busy')
AddEventHandler('HD-wiet:server:set:dry:busy', function(DryRackId, bool)
    --Config.Plants['drogen'][DryRackId]['IsBezig'] = bool
    TriggerClientEvent('HD-wiet:client:set:dry:busy', -1, DryRackId, bool)
end)

RegisterServerEvent('HD-wiet:server:set:pack:busy')
AddEventHandler('HD-wiet:server:set:pack:busy', function(PackerId, bool)
    Config.WeedLocations[PackerId]['IsBezig'] = bool
    TriggerClientEvent('HD-wiet:client:set:pack:busy', -1, PackerId, bool)
end)

RegisterServerEvent('HD-wiet:server:give:tak')
AddEventHandler('HD-wiet:server:give:tak', function()
    local Speler = HDCore.Functions.GetPlayer(source)
    Speler.Functions.AddItem('wet-tak', math.random(2,4))
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['wet-tak'], "add")
end)

RegisterServerEvent('HD-wiet:server:add:item21212')
AddEventHandler('HD-wiet:server:add:item21212', function(Item, Amount)
    local Player = HDCore.Functions.GetPlayer(source)
    Player.Functions.AddItem(Item, Amount)
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items[Item], "add")
end)

RegisterServerEvent('HD-wiet:server:remove:item')
AddEventHandler('HD-wiet:server:remove:item', function(Item, Amount)
    local Player = HDCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(Item, Amount)
    TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items[Item], "remove")
end)

HDCore.Functions.CreateCallback('HD-wiet:server:has:takken', function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    local ItemTak = Player.Functions.GetItemByName("wet-tak")
	if ItemTak ~= nil then
        if ItemTak.amount >= 2 then
            cb(true)
		else
            cb(false)
		end
	   else
        cb(false)
	end
end)

HDCore.Functions.CreateCallback('HD-wiet:server:has:nugget', function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    local ItemNugget = Player.Functions.GetItemByName("wet-tak")
    local ItemBag = Player.Functions.GetItemByName("plastic-bag")
	if ItemNugget ~= nil and ItemBag ~= nil then
        if ItemNugget.amount >= 2 and ItemBag.amount >= 1 then
            cb(true)
		else
            cb(false)
		end
	   else
        cb(false)
	end
end)

RegisterServerEvent('HD-wiet:server:weed:reward')
AddEventHandler('HD-wiet:server:weed:reward', function()
    local Player = HDCore.Functions.GetPlayer(source)
    local RandomValue = math.random(1, 1000)
    if RandomValue >= 100 and RandomValue < 650 then
        local SubValue = math.random(1,3)
        if SubValue == 1 then
            Player.Functions.AddItem('wet-tak', 1)
            TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['wet-tak'], "add") 
        elseif SubValue == 2 then
            Player.Functions.AddItem('wet-tak', 2)
            TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['wet-tak'], "add") 
        else
            Player.Functions.AddItem('wet-tak', 4)
            TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['wet-tak'], "add") 
        end
    elseif RandomValue >= 700 and RandomValue < 820 then
        local SubValue = math.random(1,50)
        if SubValue == 1 then
            Player.Functions.AddItem('wet-tak', 9)
            TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['wet-tak'], "add")  
        else
            Player.Functions.AddItem('plastic-bag', 2)
            TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['plastic-bag'], "add") 
        end
    else
        TriggerClientEvent('HDCore:Notify', source, "This plant has nothing ripe yet.", "error")
    end
end)