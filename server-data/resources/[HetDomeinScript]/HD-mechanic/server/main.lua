HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

local VehicleStatus = {}
local VehicleDrivingDistance = {}
local Pay = {}

HDCore.Functions.CreateCallback('HD-mechanic:server:GetDrivingDistances', function(source, cb)
    cb(VehicleDrivingDistance)
end)

HDCore.Functions.CreateCallback('vehiclemod:server:setupVehicleStatus', function(source, cb, plate, engineHealth, bodyHealth)
	local src = source
    local engineHealth = engineHealth ~= nil and engineHealth or 1000.0
    local bodyHealth = bodyHealth ~= nil and bodyHealth or 1000.0
    if VehicleStatus[plate] == nil then 
        if IsVehicleOwned(plate) then
            local statusInfo = GetVehicleStatus(plate)
            if statusInfo == nil then 
                statusInfo =  {
                    ["engine"] = engineHealth,
                    ["body"] = bodyHealth,
                    ["radiator"] = Config.MaxStatusValues["radiator"],
                    ["axle"] = Config.MaxStatusValues["axle"],
                    ["brakes"] = Config.MaxStatusValues["brakes"],
                    ["clutch"] = Config.MaxStatusValues["clutch"],
                    ["fuel"] = Config.MaxStatusValues["fuel"],
                }
            end
            VehicleStatus[plate] = statusInfo
            TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, statusInfo)
        else
            local statusInfo = {
                ["engine"] = engineHealth,
                ["body"] = bodyHealth,
                ["radiator"] = Config.MaxStatusValues["radiator"],
                ["axle"] = Config.MaxStatusValues["axle"],
                ["brakes"] = Config.MaxStatusValues["brakes"],
                ["clutch"] = Config.MaxStatusValues["clutch"],
                ["fuel"] = Config.MaxStatusValues["fuel"],
            }
            VehicleStatus[plate] = statusInfo
            TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, statusInfo)
        end
    else
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

HDCore.Functions.CreateCallback('HD-mechanic:server:UpdateDrivingDistance', function(source, cb, amount, plate)
	VehicleDrivingDistance[plate] = amount

    TriggerClientEvent('HD-mechanic:client:UpdateDrivingDistance', -1, VehicleDrivingDistance[plate], plate)

    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            HDCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `drivingdistance` = '"..amount.."' WHERE `plate` = '"..plate.."'")
        end
    end)
end)

RegisterServerEvent("vehiclemod:server:setupVehicleStatus")
AddEventHandler("vehiclemod:server:setupVehicleStatus", function(plate, engineHealth, bodyHealth)
    HDCore.Functions.BanInjection(source, 'HD-mechanic (setupVehicleStatus)')
end)

RegisterServerEvent('HD-mechanic:server:UpdateDrivingDistance')
AddEventHandler('HD-mechanic:server:UpdateDrivingDistance', function(amount, plate)
    HDCore.Functions.BanInjection(source, 'HD-mechanic (UpdateDrivingDistance)')
end)

HDCore.Functions.CreateCallback('HD-mechanic:server:IsVehicleOwned', function(source, cb, plate)
    local retval = false
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
        cb(retval)
    end)
end)


HDCore.Functions.CreateCallback('HD-mechanic:server:LoadStatus', function(source, cb, veh, plate)
	VehicleStatus[plate] = veh
    TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, veh)
end)

HDCore.Functions.CreateCallback('vehiclemod:server:updatePart', function(source, cb, plate, part, level)
	if VehicleStatus[plate] ~= nil then
        if part == "engine" or part == "body" then
            VehicleStatus[plate][part] = level
            if VehicleStatus[plate][part] < 0 then
                VehicleStatus[plate][part] = 0
            elseif VehicleStatus[plate][part] > 1000 then
                VehicleStatus[plate][part] = 1000.0
            end
        else
            VehicleStatus[plate][part] = level
            if VehicleStatus[plate][part] < 0 then
                VehicleStatus[plate][part] = 0
            elseif VehicleStatus[plate][part] > 100 then
                VehicleStatus[plate][part] = 100
            end
        end
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

HDCore.Functions.CreateCallback('HD-mechanic:server:SetPartLevel', function(source, cb, plate, part, level)
	if VehicleStatus[plate] ~= nil then
        VehicleStatus[plate][part] = level
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

HDCore.Functions.CreateCallback('vehiclemod:server:fixEverything', function(source, cb, plate)
	if VehicleStatus[plate] ~= nil then 
        for k, v in pairs(Config.MaxStatusValues) do
            VehicleStatus[plate][k] = v
        end
        TriggerClientEvent("vehiclemod:client:setVehicleStatus", -1, plate, VehicleStatus[plate])
    end
end)

HDCore.Functions.CreateCallback('vehiclemod:server:saveStatus', function(source, cb, plate)
	if VehicleStatus[plate] ~= nil then
        exports['ghmattimysql']:execute('UPDATE player_vehicles SET status = @status WHERE plate = @plate', {['@status'] = json.encode(VehicleStatus[plate]), ['@plate'] = plate})
    end
end)

RegisterServerEvent('HD-mechanic:server:LoadStatus')
AddEventHandler('HD-mechanic:server:LoadStatus', function(veh, plate)
    HDCore.Functions.BanInjection(source, 'HD-mechanic (LoadStatus)')
end)

RegisterServerEvent("vehiclemod:server:updatePart")
AddEventHandler("vehiclemod:server:updatePart", function(plate, part, level)
    HDCore.Functions.BanInjection(source, 'HD-mechanic (updatePart)')
end)

RegisterServerEvent('HD-mechanic:server:SetPartLevel')
AddEventHandler('HD-mechanic:server:SetPartLevel', function(plate, part, level)
    HDCore.Functions.BanInjection(source, 'HD-mechanic (SetPartLevel)')
end)

RegisterServerEvent("vehiclemod:server:fixEverything")
AddEventHandler("vehiclemod:server:fixEverything", function(plate)
    HDCore.Functions.BanInjection(source, 'HD-mechanic (fixEverything)')
end)

RegisterServerEvent("vehiclemod:server:saveStatus")
AddEventHandler("vehiclemod:server:saveStatus", function(plate)
    HDCore.Functions.BanInjection(source, 'HD-mechanic (saveStatus)')
end)

function IsVehicleOwned(plate)
    local retval = false
    HDCore.Functions.ExecuteSql(true, "SELECT * FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = true
        end
    end)
    return retval
end

function GetVehicleStatus(plate)
    local retval = nil
    HDCore.Functions.ExecuteSql(true, "SELECT `state` FROM `player_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            retval = result[1].status ~= nil and json.decode(result[1].status) or nil
        end
    end)
    return retval
end

HDCore.Commands.Add("setvehiclestatus", "Zet vehicle status", {{name="part", help="Type status dat je wilt bewerken"}, {name="amount", help="Level van de status"}}, true, function(source, args)
    local part = args[1]:lower()
    local level = tonumber(args[2])
    TriggerClientEvent("vehiclemod:client:setPartLevel", source, part, level)
end, "god")

HDCore.Functions.CreateCallback('HD-mechanic:server:GetAttachedVehicle', function(source, cb)
    cb(Config.Plates)
end)

HDCore.Functions.CreateCallback('HD-mechanic:server:IsMechanicAvailable', function(source, cb)
	local amount = 0
	for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    cb(amount)
end)

HDCore.Functions.CreateCallback('HD-mechanic:server:SetAttachedVehicle', function(source, cb, veh, k)
	if veh ~= false then
        Config.Plates[k].AttachedVehicle = veh
        TriggerClientEvent('HD-mechanic:client:SetAttachedVehicle', -1, veh, k)
    else
        Config.Plates[k].AttachedVehicle = nil
        TriggerClientEvent('HD-mechanic:client:SetAttachedVehicle', -1, false, k)
    end
end)

HDCore.Functions.CreateCallback('HD-mechanic:server:CheckForItems', function(source, cb, part)
	local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local RepairPart = Player.Functions.GetItemByName(Config.RepairCostAmount[part].item)

    if RepairPart ~= nil then
        if RepairPart.amount >= Config.RepairCostAmount[part].costs then
            TriggerClientEvent('HD-mechanic:client:RepaireeePart', src, part)
            Player.Functions.RemoveItem(Config.RepairCostAmount[part].item, Config.RepairCostAmount[part].costs)

            for i = 1, Config.RepairCostAmount[part].costs, 1 do
                TriggerClientEvent('inventory:client:ItemBox', src, HDCore.Shared.Items[Config.RepairCostAmount[part].item], "remove")
                Citizen.Wait(500)
            end
        else
            TriggerClientEvent('HDCore:Notify', src, "Je hebt niet genoeg "..HDCore.Shared.Items[Config.RepairCostAmount[part].item]["label"].." (min. "..Config.RepairCostAmount[part].costs.."x)", "error")
        end
    else
        TriggerClientEvent('HDCore:Notify', src, "Je hebt geen "..HDCore.Shared.Items[Config.RepairCostAmount[part].item]["label"].." bij je!", "error")
    end
end)

RegisterServerEvent('HD-mechanic:server:SetAttachedVehicle')
AddEventHandler('HD-mechanic:server:SetAttachedVehicle', function(veh, k)
    HDCore.Functions.BanInjection(source, 'HD-mechanic (SetAttachedVehicle)')
end)

RegisterServerEvent('HD-mechanic:server:CheckForItems')
AddEventHandler('HD-mechanic:server:CheckForItems', function(part)
    HDCore.Functions.BanInjection(source, 'HD-mechanic (CheckForItems)')
end)

function IsAuthorized(CitizenId)
    local retval = false
    for _, cid in pairs(Config.AuthorizedIds) do
        if cid == CitizenId then
            retval = true
            break
        end
    end
    return retval
end

HDCore.Commands.Add("setmechanic", "Geef iemand Mechanic baan", {{name="id", help="ID van de speler"}}, false, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)

    if IsAuthorized(Player.PlayerData.citizenid) then
        local TargetId = tonumber(args[1])
        if TargetId ~= nil then
            local TargetData = HDCore.Functions.GetPlayer(TargetId)
            if TargetData ~= nil then
                TargetData.Functions.SetJob("mechanic")
                TriggerClientEvent('HDCore:Notify', TargetData.PlayerData.source, "Je aangenomen als Autocare medewerker!")
                TriggerClientEvent('HDCore:Notify', source, "Je hebt ("..TargetData.PlayerData.charinfo.firstname..") aangenomen als Autocare medewerker!")
            end
        else
            TriggerClientEvent('HDCore:Notify', source, "Je moet wel een Speler ID meegeven!")
        end
    else
        TriggerClientEvent('HDCore:Notify', source, "Je kan dit niet doen!", "error") 
    end
end)

HDCore.Commands.Add("takemechanic", "Neem iemand zijn Mechanic baan af", {{name="id", help="ID van de speler"}}, false, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)

    if IsAuthorized(Player.PlayerData.citizenid) then
        local TargetId = tonumber(args[1])
        if TargetId ~= nil then
            local TargetData = HDCore.Functions.GetPlayer(TargetId)
            if TargetData ~= nil then
                if TargetData.PlayerData.job.name == "mechanic" then
                    TargetData.Functions.SetJob("unemployed")
                    TriggerClientEvent('HDCore:Notify', TargetData.PlayerData.source, "Je bent ontslagen als Autocare medewerker!")
                    TriggerClientEvent('HDCore:Notify', source, "Je hebt ("..TargetData.PlayerData.charinfo.firstname..") ontslagen als Autocare medewerker!")
                else
                    TriggerClientEvent('HDCore:Notify', source, "Dit is geen medewerker van Autocare!", "error")
                end
            end
        else
            TriggerClientEvent('HDCore:Notify', source, "Je moet wel een Speler ID meegeven!", "error")
        end
    else
        TriggerClientEvent('HDCore:Notify', source, "Je kan dit niet doen!", "error")
    end
end)

HDCore.Functions.CreateCallback('HD-mechanic:server:GetStatus', function(source, cb, plate)
    if VehicleStatus[plate] ~= nil and next(VehicleStatus[plate]) ~= nil then
        cb(VehicleStatus[plate])
    else
        cb(nil)
    end
end)

-- // Functie en loop voor aantal mechanics \\ --


RegisterServerEvent('HD-mechanic:server:UpdateCurrentMechanics')
AddEventHandler('HD-mechanic:server:UpdateCurrentMechanics', function()
    local aantalMechanic = GetCurrentMechanic()
    local aantalTuning = GetCurrentTuning()
    local amount = aantalMechanic + aantalTuning
    TriggerClientEvent("HD-mechanic:AantalMechanics", -1, amount)
end)

function GetCurrentMechanic()
    local TotaalMechanic = 0
    for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.onduty) then
                TotaalMechanic = TotaalMechanic + 1
            end
        end
    end
    return TotaalMechanic
end

function GetCurrentTuning()
    local TotaalTuning = 0
    for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "tuningshop" and Player.PlayerData.job.onduty) then
                TotaalTuning = TotaalTuning + 1
            end
        end
    end
    return TotaalTuning
end


HDCore.Functions.CreateCallback('HD-mechanic:server:HasMoney', function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    if Player.PlayerData.money.cash >= 750 then
        Pay[CitizenId] = "cash"
        Player.Functions.RemoveMoney('cash', 750)
        cb(true)
    elseif Player.PlayerData.money.bank >= 750 then
        Pay[CitizenId] = "bank"
        Player.Functions.RemoveMoney('bank', 750)
        cb(true)
    else
        cb(false)
    end
end)

