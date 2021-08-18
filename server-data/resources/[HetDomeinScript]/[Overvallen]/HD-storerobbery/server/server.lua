HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Commands.Add("resetsafes", "Reset de winkel kloesoes", {}, false, function(source, args)
    for k, v in pairs(Config.Safes) do
        Config.Safes[k]['Busy'] = false
        TriggerClientEvent('HD-storerobbery:client:safe:busy', -1, k, false)
    end
end, "admin")

HDCore.Functions.CreateCallback('HD-storerobbery:server:get:config', function(source, cb)
    cb(Config)
end)

HDCore.Functions.CreateCallback('HD-storerobbery:server:safe:code', function(source, cb, SafeId)
    cb(Config.SafeCodes[SafeId])
end)

HDCore.Functions.CreateCallback('HD-storerobbery:server:HasItem', function(source, cb, itemName)
    local Player = HDCore.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName(itemName)
	if Player ~= nil then
        if Item ~= nil then
			cb(true)
        else
			cb(false)
        end
	end
end)

Citizen.CreateThread(function()
    while true do
        for k, v in pairs(Config.Registers) do
            if Config.Registers[k]['Time'] > 0 and (Config.Registers[k]['Time'] - Config.Inverval) >= 0 then
                Config.Registers[k]['Time'] = Config.Registers[k]['Time'] - Config.Inverval
            else
                Config.Registers[k]['Time'] = 0
                Config.Registers[k]['Robbed'] = false
                TriggerClientEvent('HD-storerobbery:client:set:register:robbed', -1, k, false)
            end
        end
        Citizen.Wait(Config.Inverval)
    end
end)

Citizen.CreateThread(function()
    while true do 
        Config.SafeCodes = {
          [1] = math.random(1000, 9999),
          [2] = math.random(1000, 9999),
          [3] = math.random(1000, 9999),
          [4] = math.random(1000, 9999),
          [5] = math.random(1000, 9999),
          [6] = math.random(1000, 9999),
          [7] = math.random(1000, 9999),
          [8] = math.random(1000, 9999),
          [9] = math.random(1000, 9999),
          [10] = math.random(1000, 9999),
          [11] = math.random(1000, 9999),
          [12] = math.random(1000, 9999),
          [13] = math.random(1000, 9999),
          [14] = math.random(1000, 9999),
          [15] = math.random(1000, 9999),
          [16] = math.random(1000, 9999),
          [17] = math.random(1000, 9999),
          [18] = math.random(1000, 9999),
          [19] = math.random(1000, 9999),
          [20] = math.random(1000, 9999),
          [21] = math.random(1000, 9999),
        }
        Citizen.Wait((1000 * 60) * 25)
    end
end)

RegisterServerEvent('HD-storerobbery:server:set:register:robbed')
AddEventHandler('HD-storerobbery:server:set:register:robbed', function(RegisterId, bool)
    Config.Registers[RegisterId]['Robbed'] = bool
    Config.Registers[RegisterId]['Time'] = Config.ResetTime
    TriggerClientEvent('HD-storerobbery:client:set:register:robbed', -1, RegisterId, bool)
end)

RegisterServerEvent('HD-storerobbery:server:set:register:busy')
AddEventHandler('HD-storerobbery:server:set:register:busy', function(RegisterId, bool)
    Config.Registers[RegisterId]['Busy'] = bool
    TriggerClientEvent('HD-storerobbery:client:set:register:busy', -1, RegisterId, bool)
end)

RegisterServerEvent('HD-storerobbery:server:safe:busy')
AddEventHandler('HD-storerobbery:server:safe:busy', function(SafeId, bool)
    Config.Safes[SafeId]['Busy'] = bool
    TriggerClientEvent('HD-storerobbery:client:safe:busy', -1, SafeId, bool)
end)

RegisterServerEvent('HD-storerobbery:server:safe:robbed')
AddEventHandler('HD-storerobbery:server:safe:robbed', function(SafeId, bool)
    Config.Safes[SafeId]['Robbed'] = bool
    TriggerClientEvent('HD-storerobbery:client:safe:robbed', -1, SafeId, bool)
    SetTimeout((1000 * 60) * 25, function()
        TriggerClientEvent('HD-storerobbery:client:safe:robbed', -1, SafeId, false)
        Config.Safes[SafeId]['Robbed'] = false
    end)
end)

RegisterServerEvent('HD-storerobbery:server:rob:register')
AddEventHandler('HD-storerobbery:server:rob:register', function(RegisterId, IsDone)
    local Player = HDCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', math.random(50, 112), "Store Robbery")
    if IsDone then
        local RandomItem = Config.SpecialItems[math.random(#Config.SpecialItems)]
        local RandomValue = math.random(1,100)
        if RandomValue >= 1 and RandomValue <= 40 then
            local SafeCode = Config.SafeCodes[Config.Registers[RegisterId]['SafeKey']]
            Player.Functions.AddItem("note", 1, false, {label = 'Kluis code: '..tonumber(SafeCode)})
            TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items["note"], "add")
        end
    end
end)

RegisterServerEvent('HD-storerobbery:server:safe:reward')
AddEventHandler('HD-storerobbery:server:safe:reward', function()
    local Player = HDCore.Functions.GetPlayer(source)
    local RandomItem = Config.SpecialItems[math.random(#Config.SpecialItems)]
    Player.Functions.AddMoney('cash', math.random(1000, 3000), "Safe Robbery")
    local RandomValue = math.random(1,100)
    if RandomValue <= 20 then
        Player.Functions.AddItem("gold-rolex", math.random(1,2))
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items["gold-rolex"], "add") 
    elseif RandomValue >= 30 and RandomValue <= 45 then
        Player.Functions.AddItem(RandomItem, 1)
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items[RandomItem], "add")
    elseif RandomValue >= 70 and RandomValue <= 75 then
        Player.Functions.AddItem("gold-bar", math.random(1))
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items["gold-bar"], "add") 
    end
end)