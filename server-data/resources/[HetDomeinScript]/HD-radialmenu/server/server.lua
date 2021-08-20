HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Functions.CreateCallback('HD-radialmenu:server:HasItem', function(source, cb, itemName)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player ~= nil then
      local Item = Player.Functions.GetItemByName(itemName)
        if Item ~= nil then
			cb(true)
        else
			cb(false)
        end
	end
end)