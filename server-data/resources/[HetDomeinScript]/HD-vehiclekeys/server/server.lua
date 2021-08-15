HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Functions.CreateCallback("HD-vehiclekeys:server:get:key:config", function(source, cb)
  cb(Config)
end)

HDCore.Functions.CreateCallback("HD-vehiclekeys:server:has:keys", function(source, cb, plate)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    if Config.VehicleKeys[plate] ~= nil then
        if Config.VehicleKeys[plate]['CitizenId'] == Player.PlayerData.citizenid and Config.VehicleKeys[plate]['HasKey'] then
            HasKey = true
        else
            HasKey = false
        end
    else
        HasKey = false
    end
    cb(HasKey)
end)

-- // Events \\ --

RegisterServerEvent('HD-vehiclekeys:server:set:keys')
AddEventHandler('HD-vehiclekeys:server:set:keys', function(Plate, bool)
  local Player = HDCore.Functions.GetPlayer(source)
  Config.VehicleKeys[Plate] = {['CitizenId'] = Player.PlayerData.citizenid, ['HasKey'] = bool}
  TriggerClientEvent('HD-vehiclekeys:client:set:keys', -1, Plate, Player.PlayerData.citizenid, bool)
end)

RegisterServerEvent('HD-vehiclekeys:server:give:keys')
AddEventHandler('HD-vehiclekeys:server:give:keys', function(Target, Plate, bool)
  local Player = HDCore.Functions.GetPlayer(Target)
  if Player ~= nil then
    TriggerClientEvent('HDCore:Notify', Player.PlayerData.source, "Je ontving sleutels van een voertuig met het kenteken: "..Plate, 'success')
    Config.VehicleKeys[Plate] = {['CitizenId'] = Player.PlayerData.citizenid, ['HasKey'] = bool}
    TriggerClientEvent('HD-vehiclekeys:client:set:keys', -1, Plate, Player.PlayerData.citizenid, bool)
  end
end)

-- // Commands \\ -- 

HDCore.Commands.Add("motor", "Toggle motor aan/uit van het voertuig", {}, false, function(source, args)
  TriggerClientEvent('HD-vehiclekeys:client:toggle:engine', source)
end)