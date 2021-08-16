HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

local PaymentTax = 15

local Bail = {}

RegisterServerEvent('HD-trucker:server:DoBail')
AddEventHandler('HD-trucker:server:DoBail', function(bool, vehInfo)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    if bool then
        if Player.PlayerData.money.cash >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('cash', Config.BailPrice, "tow-received-bail")
            TriggerClientEvent('HDCore:Notify', src, 'You have paid the deposit of 500, - (cash)', 'success')
            TriggerClientEvent('HD-trucker:client:SpawnVehicle', src, vehInfo)
        elseif Player.PlayerData.money.bank >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('bank', Config.BailPrice, "tow-received-bail")
            TriggerClientEvent('HDCore:Notify', src, 'You have paid the deposit of 500, - (bank)', 'success')
            TriggerClientEvent('HD-trucker:client:SpawnVehicle', src, vehInfo)
        else
            TriggerClientEvent('HDCore:Notify', src, 'You dont have enough in cash, the deposit is 500,-', 'error')
        end
    else
        if Bail[Player.PlayerData.citizenid] ~= nil then
            Player.Functions.AddMoney('cash', Bail[Player.PlayerData.citizenid], "trucker-bail-paid")
            Bail[Player.PlayerData.citizenid] = nil
            TriggerClientEvent('HDCore:Notify', src, 'You have received the 500 deposit back', 'success')
        end
    end
end)

RegisterNetEvent('HD-trucker:server:01101110')
AddEventHandler('HD-trucker:server:01101110', function()
    HDCore.Functions.BanInjection(source, 'HD-trucker (01101110)')
end)

HDCore.Functions.CreateCallback('HD-trucker:01101110', function(source, cb, drops)
    local src = source 
    local Player = HDCore.Functions.GetPlayer(src)
    local drops = tonumber(drops)
    local bonus = 0
    local DropPrice = math.random(30, 80)
    if drops > 5 then 
        bonus = math.ceil((DropPrice / 100) * 5) + 110
    elseif drops > 10 then
        bonus = math.ceil((DropPrice / 100) * 7) + 230
    elseif drops > 15 then
        bonus = math.ceil((DropPrice / 100) * 10) + 540
    elseif drops > 20 then
        bonus = math.ceil((DropPrice / 100) * 12) + 550
    end
    local price = (DropPrice * drops) + bonus
    local taxAmount = math.ceil((price / 100) * PaymentTax)
    local payment = price - taxAmount
    Player.Functions.AddMoney("cash", payment, "trucker-salary")
    TriggerClientEvent('chatMessage', source, "JOB", "warning", "You have received your salary: €"..payment..", bruto: €"..price.." (from what €"..bonus.." bonus) and €"..taxAmount.." taxes ("..PaymentTax.."%)")
end)

