HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

RegisterServerEvent('RoutePizza:Payment')
AddEventHandler('RoutePizza:Payment', function()
	local _source = source
	local Player = HDCore.Functions.GetPlayer(_source)
    local PizzaPayment = math.random(75,125)
    --Player.Functions.AddMoney("cash", PizzaPayment, "sold-pizza")
    Player.Functions.AddItem('paycheck', 1, false, {worth = PizzaPayment})
end)

RegisterServerEvent('RoutePizza:TakeDeposit')
AddEventHandler('RoutePizza:TakeDeposit', function()
	local _source = source
	local Player = HDCore.Functions.GetPlayer(_source)
    Player.Functions.RemoveMoney("bank", _source, "pizza-deposit")
    TriggerClientEvent("HDCore:Notify", _source, "€100 borg betaald", "error")
end)

RegisterServerEvent('RoutePizza:ReturnDeposit')
AddEventHandler('RoutePizza:ReturnDeposit', function(info)
	local _source = source
    local Player = HDCore.Functions.GetPlayer(_source)
    
    if info == 'cancel' then
        Player.Functions.AddMoney("cash", 50, "pizza-return-vehicle")
        TriggerClientEvent("HDCore:Notify", _source, "Je hebt je borg terug gekregen", "success")
    elseif info == 'end' then
        Player.Functions.AddMoney("cash", 150, "pizza-return-vehicle")
        TriggerClientEvent("HDCore:Notify", _source, "Je hebt je borg terug gekregen", "success")
    end
end)
