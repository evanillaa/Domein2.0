HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

RegisterServerEvent('HD-hunt:reward')
AddEventHandler('HD-hunt:reward', function(Weight)
    local _source = source
    local xPlayer = HDCore.Functions.GetPlayer(_source)

    if Weight >= 1 then
       xPlayer.Functions.AddItem('meath', 1)
       TriggerClientEvent('HD-inventory:client:ItemBox', _source, HDCore.Shared.Items['meath'], "add")
    elseif Weight >= 9 then
        xPlayer.Functions.AddItem('meath', 2)
       TriggerClientEvent('HD-inventory:client:ItemBox', _source, HDCore.Shared.Items['meath'], "add")
    elseif Weight >= 15 then
        xPlayer.Functions.AddItem('meath', 3)
       TriggerClientEvent('HD-inventory:client:ItemBox', _source, HDCore.Shared.Items['meath'], "add")
    end

    
	xPlayer.Functions.AddItem('meath', math.random(1, 4))
       TriggerClientEvent('HD-inventory:client:ItemBox', _source, HDCore.Shared.Items['meath'], "add")
        
end)

RegisterServerEvent('HD-hunt:sell')
AddEventHandler('HD-hunt:sell', function()
   local _source = source
   local xPlayer  = HDCore.Functions.GetPlayer(_source)

    local MeatPrice = math.random(50,350)
    local LeatherPrice = 300

    --if item == "meath" then
					local MeatP = xPlayer.Functions.GetItemByName('meath')
						if MeatP == nil then
               			TriggerClientEvent('HDCore:Notify', _source, "You have no meat!", "error")	
					else   
					TriggerClientEvent('HD-inventory:client:ItemBox', _source, HDCore.Shared.Items['meath'], "remove")	
						xPlayer.Functions.RemoveItem("meath", 1)
						xPlayer.Functions.AddMoney('cash', MeatPrice)
						TriggerClientEvent('HDCore:Notify', _source, "You have sold wild meat", "success")

			end
			--end
        
end)

RegisterServerEvent('HD-hunting:server:recieve:knife')
AddEventHandler('HD-hunting:server:recieve:knife', function()
    local Player = HDCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("weapon_knife", 1)
    TriggerClientEvent("HD-inventory:client:ItemBox", source, HDCore.Shared.Items["weapon-knife"], "add")
end)


RegisterServerEvent('HD-hunting:server:remove:knife')
AddEventHandler('HD-hunting:server:remove:knife', function()
    local Player = HDCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem("weapon_knife", 1)
    TriggerClientEvent("HD-inventory:client:ItemBox", source, HDCore.Shared.Items["weapon-knife"], "remove")
end)