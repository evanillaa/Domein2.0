HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)
local Bail = {}

RegisterServerEvent('HD-skydive:server:spawned')
AddEventHandler('HD-skydive:server:spawned', function(value, plate)
  TriggerClientEvent('HD-skydive:client:spawned', -1, value, plate)
  print(value)
end)


HDCore.Functions.CreateCallback('HD-skydive:server:HasMoney', function(source, cb)
  local Player = HDCore.Functions.GetPlayer(source)
  local CitizenId = Player.PlayerData.citizenid

  if Player.PlayerData.money.cash >= Config.priceforparachute then
      Bail[CitizenId] = "cash"
      Player.Functions.RemoveMoney('cash', Config.priceforparachute)
      cb(true)
  elseif Player.PlayerData.money.bank >= Config.priceforparachute then
      Bail[CitizenId] = "bank"
      Player.Functions.RemoveMoney('bank', Config.priceforparachute)
      cb(true)
  else
      cb(false)
  end
end)

