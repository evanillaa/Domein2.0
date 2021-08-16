HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

local Bail = {}

HDCore.Functions.CreateCallback('HD-planejob:server:HasMoney', function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    if Player.PlayerData.money.cash >= Config.BailPrice then
        Bail[CitizenId] = "cash"
        Player.Functions.RemoveMoney('cash', Config.BailPrice)
        cb(true)
    elseif Player.PlayerData.money.bank >= Config.BailPrice then
        Bail[CitizenId] = "bank"
        Player.Functions.RemoveMoney('bank', Config.BailPrice)
        cb(true)
    else
        cb(false)
    end
end)

HDCore.Functions.CreateCallback('HD-planejob:server:CheckBail', function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    if Bail[CitizenId] ~= nil then
        Player.Functions.AddMoney(Bail[CitizenId], Config.BailPrice)
        Bail[CitizenId] = nil
        cb(true)
    else
        cb(false)
    end
end)

local Materials = {
    "gold-rolex",
    "gold-necklace",
}


HDCore.Functions.CreateCallback('HD-planejob:server:ShiftPayment', function(source, cb, amount, location)
	local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    if amount > 0 then
        --Player.Functions.AddMoney('bank', amount)
        Player.Functions.AddItem('paycheck', 1, false, {worth = amount})

        if location == #Config.Locations["cargoholders"] then
            for i = 1, math.random(3, 5), 1 do
                local item = Materials[math.random(1, #Materials)]
                Player.Functions.AddItem(item, math.random(2, 8))
                TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[item], 'add')
                Citizen.Wait(500)
            end
        end

        TriggerClientEvent('HDCore:Notify', src, "Je hebt €"..amount..",- uitbetaald gekregen op je bank!", "success")
    else
        TriggerClientEvent('HDCore:Notify', src, "Je hebt niks verdiend..", "error")
    end
end)

RegisterServerEvent('HD-planejob:server:PayShit')
AddEventHandler('HD-planejob:server:PayShit', function(amount, location)
    HDCore.Functions.BanInjection(source, 'HD-planejob (PayShit)')
end)