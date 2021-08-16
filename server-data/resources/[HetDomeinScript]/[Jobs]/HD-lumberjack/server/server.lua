
HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)


RegisterServerEvent('wood:getItem')
AddEventHandler('wood:getItem', function()
	local xPlayer, randomItem = HDCore.Functions.GetPlayer(source), Config.Items[math.random(1, #Config.Items)]
	
	if math.random(0, 100) <= Config.ChanceToGetItem then
		local Item = xPlayer.Functions.GetItemByName('wood_cut')
		if Item == nil then
			xPlayer.Functions.AddItem(randomItem, 1)
			TriggerClientEvent("HD-inventory:client:ItemBox", source, HDCore.Shared.Items[randomItem], "add")
		else	
		if Item.amount < 20 then
		xPlayer.Functions.AddItem(randomItem, 1)
		TriggerClientEvent("HD-inventory:client:ItemBox", source, HDCore.Shared.Items[randomItem], "add")
		else
			TriggerClientEvent('HDCore:Notify', source, 'Inventory full, you can not carry more!', "error")  
		end
	    end
    end
end)

RegisterServerEvent('wood_weed:processweed2')
AddEventHandler('wood_weed:processweed2', function()
	local src = source
	local Player = HDCore.Functions.GetPlayer(src)

	if Player.Functions.GetItemByName('wood_cut') then
		local chance = math.random(1, 8)
		if chance == 1 or chance == 2 or chance == 3 or chance == 4 or chance == 5 or chance == 6 or chance == 7 or chance == 8 then
			Player.Functions.RemoveItem('wood_cut', 1)
			Player.Functions.AddItem('wood_proc', 1)
			TriggerClientEvent("HD-inventory:client:ItemBox", source, HDCore.Shared.Items['wood_cut'], "remove")
			TriggerClientEvent("HD-inventory:client:ItemBox", source, HDCore.Shared.Items['wood_proc'], "add")
			TriggerClientEvent('HDCore:Notify', src, 'Wood processed', "success")  
		else
			
		end 
	else
		TriggerClientEvent('HDCore:Notify', src, 'You do not have the right itemsm', "error") 
	end
end)


RegisterServerEvent('wood:sell')
AddEventHandler('wood:sell', function()

    local xPlayer = HDCore.Functions.GetPlayer(source)
	local Item = xPlayer.Functions.GetItemByName('wood_proc')
   
	
	if Item == nil then
       TriggerClientEvent('HDCore:Notify', source, 'wood_proc', "error")  
	else
	 for k, v in pairs(Config.Prices) do
        
		
		if Item.amount > 0 then
            local reward = 0
            for i = 1, Item.amount do
                --reward = reward + math.random(v[1], v[2])
                reward = reward + math.random(1, 2)
            end
			xPlayer.Functions.RemoveItem('wood_proc', 1)
			TriggerClientEvent("HD-inventory:client:ItemBox", source, HDCore.Shared.Items['wood_proc'], "remove")
			xPlayer.Functions.AddMoney("cash", reward, "sold-pawn-items")
			TriggerClientEvent('HDCore:Notify', source, '1x Sold', "success")  
			--end
        end
		
		
     end
	end
	
		
	
end)


local prezzo = 10
RegisterServerEvent('HD-jobwood:server:truck')
AddEventHandler('HD-jobwood:server:truck', function(boatModel, BerthId)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local plate = "WOOD"..math.random(1111, 9999)
    
	TriggerClientEvent('HD-jobwood:Auto', src, boatModel, plate)
end)
