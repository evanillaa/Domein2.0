HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

local PaymentTax = 15

local Bail = {}

RegisterServerEvent('HD-postscript:server:DoBail')
AddEventHandler('HD-postscript:server:DoBail', function(bool, vehInfo)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    if bool then
        if Player.PlayerData.money.cash >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('cash', Config.BailPrice, "tow-received-bail")
            TriggerClientEvent('HDCore:Notify', src, 'Je hebt de borg van 500,- betaald (Cash)', 'success')
            TriggerClientEvent('HD-postscript:client:SpawnVehicle', src, vehInfo)
        elseif Player.PlayerData.money.bank >= Config.BailPrice then
            Bail[Player.PlayerData.citizenid] = Config.BailPrice
            Player.Functions.RemoveMoney('bank', Config.BailPrice, "tow-received-bail")
            TriggerClientEvent('HDCore:Notify', src, 'Je hebt de borg van 500,- betaald (Bank)', 'success')
            TriggerClientEvent('HD-postscript:client:SpawnVehicle', src, vehInfo)
        else
            TriggerClientEvent('HDCore:Notify', src, 'Je hebt niet genoeg contant, de borg is 500,-', 'error')
        end
    else
        if Bail[Player.PlayerData.citizenid] ~= nil then
            Player.Functions.AddMoney('cash', Bail[Player.PlayerData.citizenid], "postman-bail-paid")
            Bail[Player.PlayerData.citizenid] = nil
            TriggerClientEvent('HDCore:Notify', src, 'Je hebt de borg van 500,- terug gekregen', 'success')
        end
    end
end)

RegisterNetEvent('HD-postscript:server:01101110')
AddEventHandler('HD-postscript:server:01101110', function()
    HDCore.Functions.BanInjection(source, 'HD-postscript (01101110)')
end)

HDCore.Functions.CreateCallback('HD-postscript:server:01101110', function(source, cb, drops)
    local src = source 
    local Player = HDCore.Functions.GetPlayer(src)
    local drops = tonumber(drops)
    local bonus = 0
    local DropPrice = math.random(300, 500)
    if drops > 5 then 
        bonus = math.ceil((DropPrice / 100) * 5) + 100
    elseif drops > 10 then
        bonus = math.ceil((DropPrice / 100) * 7) + 300
    elseif drops > 15 then
        bonus = math.ceil((DropPrice / 100) * 10) + 400
    elseif drops > 20 then
        bonus = math.ceil((DropPrice / 100) * 12) + 500
    end
    local price = (DropPrice * drops) + bonus
    local taxAmount = math.ceil((price / 100) * PaymentTax)
    local payment = price - taxAmount
    --Player.Functions.AddJobReputation(1)
    --Player.Functions.AddMoney("bank", payment, "trucker-salary")
    Player.Functions.AddItem('paycheck', 1, false, {worth = payment})
    TriggerClientEvent('HDCore:Notify', source, "Je hebt je salaris ontvangen van: €"..payment..", bruto: €"..price.." (waarvan €"..bonus.." bonus) en €"..taxAmount.." belasting ("..PaymentTax.."%)","success")
end)

