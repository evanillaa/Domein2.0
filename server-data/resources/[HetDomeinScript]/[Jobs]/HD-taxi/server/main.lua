HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

RegisterServerEvent('HD-taxi:server:NpcPay')
AddEventHandler('HD-taxi:server:NpcPay', function(Payment)
    local fooikansasah = math.random(1, 5)
    local r1, r2 = math.random(1, 5), math.random(1, 5)

    if fooikansasah == r1 or fooikansasah == r2 then
        Payment = Payment + math.random(54, 290)
    end

    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    Player.Functions.AddMoney('cash', Payment)
end)