HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Functions.CreateCallback('HD-tow:server:get:config', function(source, cb)
    cb(Config)
end)

HDCore.Functions.CreateCallback('HD-tow:server:do:bail', function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney('cash', Config.BailPrice, 'bail-voertuig') then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('HD-tow:server:add:towed')
AddEventHandler('HD-tow:server:add:towed', function(PaymentAmount)
    local Player = HDCore.Functions.GetPlayer(source)
    if Config.JobData[Player.PlayerData.citizenid] ~= nil then
        Config.JobData[Player.PlayerData.citizenid]['Payment'] = Config.JobData[Player.PlayerData.citizenid]['Payment'] + math.ceil(PaymentAmount)
    else
        Config.JobData[Player.PlayerData.citizenid]= {['Payment'] = 0 + math.ceil(PaymentAmount)}
    end
    TriggerClientEvent('HD-tow:client:add:towed', -1, Player.PlayerData.citizenid, math.ceil(PaymentAmount), 'Add')
end)

RegisterServerEvent('HD-tow:server:recieve:payment')
AddEventHandler('HD-tow:server:recieve:payment', function()
    local Player = HDCore.Functions.GetPlayer(source)
    --if Player.Functions.AddMoney('cash', Config.JobData[Player.PlayerData.citizenid]['Payment']) then
    if Player.Functions.AddItem('paycheck', 1, false, {worth = Config.JobData[Player.PlayerData.citizenid]['Payment']}) then
      local AmountNetto = Config.JobData[Player.PlayerData.citizenid]['Payment'] + math.random(125, 200)
      TriggerClientEvent('chatMessage', source, "Bergnet Leiding", "warning", "Je hebt je salaris ontvangen van: €"..AmountNetto..", bruto: €"..Config.JobData[Player.PlayerData.citizenid]['Payment'])
      Config.JobData[Player.PlayerData.citizenid]['Payment'] = 0
      TriggerClientEvent('HD-tow:client:add:towed', -1, Player.PlayerData.citizenid, 0, 'Set')
    end
end)

RegisterServerEvent('HD-tow:server:return:bail:fee')
AddEventHandler('HD-tow:server:return:bail:fee', function()
    local Player = HDCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', Config.BailPrice)
end)
