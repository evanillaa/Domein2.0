HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)


HDCore.Commands.Add("cash", "Check cash", {}, false, function(source, args)
	TriggerClientEvent('hud:client:ShowMoney', source, "cash")
end)