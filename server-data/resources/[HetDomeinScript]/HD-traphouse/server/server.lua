HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

Citizen.CreateThread(function()
    Config.TrapHouse['Coords']['Enter'] = {['X'] = -1533.35, ['Y'] = -275.44, ['Z'] = 49.73, ['H'] = 52.30}
    Config.TrapHouse['Coords']['Interact'] = {['X'] = -1532.42, ['Y'] = -269.79, ['Z'] = 16.88}
end)

HDCore.Functions.CreateCallback("HD-traphouse:server:get:config", function(source, cb)
    cb(Config)
end)

HDCore.Functions.CreateCallback("HD-traphouse:server:pin:code", function(source, cb)
    cb(Config.TrapHouse['Code'])
end)

HDCore.Functions.CreateCallback("HD-traphouse:server:is:current:owner", function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.PlayerData.citizenid == Config.TrapHouse['Owner'] then
            cb(true)
        else
            cb(false)
        end
    end
end)

HDCore.Functions.CreateCallback("HD-traphouse:server:has:sell:item", function(source, cb)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
     local BlueDiamondItem = Player.Functions.GetItemByName('diamond-blue')
     local RedDiamondItem = Player.Functions.GetItemByName('iamond-red')
     local BillsItem = Player.Functions.GetItemByName('markedbills')
     if BlueDiamondItem ~= nil or RedDiamondItem ~= nil or BillsItem ~= nil then
        cb(true)
     else
        cb(false)
     end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        Config.TrapHouse['Code'] = math.random(1111,9999)
        print('Traphouse Code Reset..', Config.TrapHouse['Code'])
        Citizen.Wait((1000 * 60) * 60)
    end
end)

RegisterServerEvent('HD-traphouse:server:sell:item')
AddEventHandler('HD-traphouse:server:sell:item', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.SellItems) do
        local Item = Player.Functions.GetItemByName(k)
        if Item ~= nil then
          if Item.amount > 0 then
              for i = 1, Item.amount do
                  Player.Functions.RemoveItem(Item.name, 1)
                  TriggerClientEvent('HD-inventory:client:ItemBox', src, HDCore.Shared.Items[Item.name], "remove")
                  if v['Type'] == 'info' then
                      Player.Functions.AddMoney('cash', Item.info.worth, 'sold-traphouse')
                  else
                      Player.Functions.AddMoney('cash', v['Amount'], 'sold-traphouse')
                  end
                  Citizen.Wait(500)
              end
          end
        end
    end
end)

RegisterServerEvent('HD-traphouse:server:set:selling:state')
AddEventHandler('HD-traphouse:server:set:selling:state', function(bool)
    Config.IsSelling = bool
    TriggerClientEvent('HD-traphouse:client:set:selling:state', -1, bool)
end)

RegisterServerEvent('HD-traphouse:set:owner')
AddEventHandler('HD-traphouse:set:owner', function()
    local Player = HDCore.Functions.GetPlayer(source)
    Config.TrapHouse['Owner'] = Player.PlayerData.citizenid
end)

RegisterServerEvent('HD-traphouse:server:rob:npc')
AddEventHandler('HD-traphouse:server:rob:npc', function()
    local Player = HDCore.Functions.GetPlayer(source)
    local RandomValue = math.random(1, 100)
    if RandomValue <= 25 then
        Player.Functions.AddItem("note", 1, false, {label = 'Traphouse code: '..tonumber(Config.TrapHouse['Code'])})
        TriggerClientEvent('HD-inventory:client:ItemBox', source, HDCore.Shared.Items["note"], "add")
    end
end)