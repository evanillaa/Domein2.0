HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Commands.Add("binds", "Open commandbinding menu", {}, false, function(source, args)
	TriggerClientEvent("HD-binds:client:openUI", source)
end)

RegisterServerEvent('HD-binds:server:setKeyMeta')
AddEventHandler('HD-binds:server:setKeyMeta', function(keyMeta)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("commandbinds", keyMeta)
end)