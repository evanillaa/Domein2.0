HDCore = nil
TriggerEvent(Config.CoreName..':GetObject', function(obj) HDCore = obj end)



RegisterServerEvent('HD-parkingrobbery:server:1I1i01I1')
AddEventHandler('HD-parkingrobbery:server:1I1i01I1', function(count)
    local src = source
    local Player = HDCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', math.random(50, 150), "Parkeermeter")
    if math.random(1,100) <= 10 then
        Player.Functions.AddItem('coin', 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items['coin'], "add")
    end
end)