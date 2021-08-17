HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

RegisterServerEvent('HD-mine:getItem')
AddEventHandler('HD-mine:getItem', function()
	local xPlayer, randomItem = HDCore.Functions.GetPlayer(source), Config.Items[math.random(1, #Config.Items)]
	
	if math.random(0, 100) <= Config.ChanceToGetItem then
		local Item = xPlayer.Functions.GetItemByName(randomItem)
		if Item == nil then
			xPlayer.Functions.AddItem(randomItem, 1)
            TriggerClientEvent('HD-inventory:client:ItemBox', xPlayer.PlayerData.source, HDCore.Shared.Items[randomItem], 'add')
		else	
		if Item.amount < 35 then
        
        xPlayer.Functions.AddItem(randomItem, 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', xPlayer.PlayerData.source, HDCore.Shared.Items[randomItem], 'add')
		else
			TriggerClientEvent('HDCore:Notify', source, 'Inventory is full', "error")  
		end
	    end
    end
end)



RegisterServerEvent('HD-mine:sell')
AddEventHandler('HD-mine:sell', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    
if Player ~= nil then

    if Player.Functions.RemoveItem("steel", 1) then
        TriggerClientEvent("HDCore:Notify", src, "You have sold 1x steel", "success", 1000)
        Player.Functions.AddMoney("cash", Config.pricexd.steel)
        Citizen.Wait(200)
        TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['steel'], 'remove')
    else
        TriggerClientEvent("HDCore:Notify", src, "You don't have items to sell.", "error", 1000)
    end
        Citizen.Wait(1000)
    if Player.Functions.RemoveItem("iron", 1) then
        TriggerClientEvent("HDCore:Notify", src, "You have sold 1x iron", "success", 1000)
        Player.Functions.AddMoney("cash", Config.pricexd.iron)
        Citizen.Wait(200)
        TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['iron'], 'remove')
    else
        TriggerClientEvent("HDCore:Notify", src, "You don't have items to sell.", "error", 1000)
    end
        Citizen.Wait(1000)
    if Player.Functions.RemoveItem("copper", 1) then
        TriggerClientEvent("HDCore:Notify", src, "You have sold 1x copper", "success", 1000)
        Player.Functions.AddMoney("cash", Config.pricexd.copper)
        Citizen.Wait(200)
        TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['copper'], 'remove')
    else
        TriggerClientEvent("HDCore:Notify", src, "You don't have items to sell.", "error", 1000)
    end
        Citizen.Wait(1000)
    if Player.Functions.RemoveItem("diamond", 1) then
        TriggerClientEvent("HDCore:Notify", src, "You have sold 1x Diamand", "success", 1000)
        Player.Functions.AddMoney("cash", Config.pricexd.diamond)
        Citizen.Wait(200)
        TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['diamond'], 'remove')
    else
        TriggerClientEvent("HDCore:Notify", src, "You don't have items to sell.", "error", 1000)
    end
        Citizen.Wait(1000)
    if Player.Functions.RemoveItem("emerald", 1) then
        TriggerClientEvent("HDCore:Notify", src, "You have sold 1x emerald", "success", 1000)
        Player.Functions.AddMoney("cash", Config.pricexd.emerald)
        Citizen.Wait(200)
        TriggerClientEvent('HD-inventory:client:ItemBox', Player.PlayerData.source, HDCore.Shared.Items['emerald'], 'remove')
    else
        TriggerClientEvent("HDCore:Notify", src, "You don't have items to sell.", "error", 1000)
    end
end
end)
