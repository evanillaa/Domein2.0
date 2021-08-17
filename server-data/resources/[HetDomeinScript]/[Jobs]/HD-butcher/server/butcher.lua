HDCore= nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore= obj end)

RegisterServerEvent('HD-pig:getNewPig')
AddEventHandler('HD-pig:getNewPig', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local pick = ''

      if TriggerClientEvent('DoShortHudText', src, "You Received 3 Alive pig!") then
          Player.Functions.AddItem('alivepig', 3)
          TriggerClientEvent("inventory:client:ItemBox", source, HDCore.Shared.Items['alivepig'], "add")
      end
end)

RegisterServerEvent('HD-pig:getcutPig')
AddEventHandler('HD-pig:getcutPig', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local pick = ''

      if TriggerClientEvent('DoShortHudText', src, "Well! You slaughtered pig.") then
          Player.Functions.RemoveItem('alivepig', 1)
          Player.Functions.AddItem('slaughteredpig', 1)
          TriggerClientEvent("inventory:client:ItemBox", source, HDCore.Shared.Items['alivepig'], "remove")
          TriggerClientEvent("inventory:client:ItemBox", source, HDCore.Shared.Items['slaughteredpig'], "add")
      end
end)

RegisterServerEvent('HD-pig:getpackedPig')
AddEventHandler('HD-pig:getpackedPig', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local pick = ''

      if TriggerClientEvent('DoShortHudText', src, "You Packed Slaughtered pig .") then
          Player.Functions.RemoveItem('slaughteredpig', 1)
          Player.Functions.AddItem('packedpig', 1)
          TriggerClientEvent("inventory:client:ItemBox", source, HDCore.Shared.Items['slaughteredpig'], "remove")
          TriggerClientEvent("inventory:client:ItemBox", source, HDCore.Shared.Items['packagedpig'], "add")
      end
end)

RegisterServerEvent('HD-pig:getNewBeef')
AddEventHandler('HD-pig:getNewBeef', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local pick = ''

      if TriggerClientEvent('DoShortHudText', src, "You Received 3 Alive cow!") then
          Player.Functions.AddItem('alivecow', 3)
          TriggerClientEvent("inventory:client:ItemBox", source, HDCore.Shared.Items['alivecow'], "add")
      end
end)

RegisterServerEvent('HD-pig:getcutBeef')
AddEventHandler('HD-pig:getcutBeef', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local pick = ''

      if TriggerClientEvent('DoShortHudText', src, "Well! You slaughtered beef.") then
          Player.Functions.RemoveItem('alivecow', 1)
          Player.Functions.AddItem('slaughteredbeef', 1)
          TriggerClientEvent("inventory:client:ItemBox", source, HDCore.Shared.Items['alivecow'], "remove")
          TriggerClientEvent("inventory:client:ItemBox", source, HDCore.Shared.Items['slaughteredbeef'], "add")
      end
end)

RegisterServerEvent('HD-pig:getpackedBeef')
AddEventHandler('HD-pig:getpackedBeef', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local pick = ''

      if TriggerClientEvent('DoShortHudText', src, "You Packed Slaughtered beef .") then
          Player.Functions.RemoveItem('slaughteredbeef', 1)
          Player.Functions.AddItem('packedbeef', 1)
          TriggerClientEvent("inventory:client:ItemBox", source, HDCore.Shared.Items['slaughteredbeef'], "remove")
          TriggerClientEvent("inventory:client:ItemBox", source, HDCore.Shared.Items['packagedbeef'], "add")
      end
end)
