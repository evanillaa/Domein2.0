HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

local Casings = {}
local HairDrops = {}
local BloodDrops = {}
local SlimeDrops = {}
local FingerDrops = {}
local PlayerStatus = {}
local PlayerStatus = {}
local Objects = {}

RegisterServerEvent('HD-police:server:UpdateBlips')
AddEventHandler('HD-police:server:UpdateBlips', function()
    local src = source
    local dutyPlayers = {}
    for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if ((Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
                table.insert(dutyPlayers, {
                    source = Player.PlayerData.source,
                    label = Player.PlayerData.metadata["dienstnummer"]..' | '..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname,
                    job = Player.PlayerData.job.name,
                })
            end
        end
    end
    TriggerClientEvent("HD-police:client:UpdateBlips", -1, dutyPlayers)
end)

-- // Loops \\ --

Citizen.CreateThread(function()
  while true do 
    Citizen.Wait(0)
    local CurrentCops = GetCurrentCops()
    TriggerClientEvent("HD-police:SetCopCount", -1, CurrentCops)
    Citizen.Wait(1000 * 60 * 10)
  end
end)

-- // Functions \\ --

function IsVehicleOwned(plate)
    local val = false
	HDCore.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
		if (result[1] ~= nil) then
			val = true
		else
			val = false
		end
	end)
	return val
end
function GetCurrentCops()
    local amount = 0
    for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    return amount
end

-- // Evidence Events \\ --

HDCore.Functions.CreateCallback('HD-police:GetPlayerStatus', function(source, cb, playerId)
    local Player = HDCore.Functions.GetPlayer(playerId)
    local statList = {}
	if Player ~= nil then
        if PlayerStatus[Player.PlayerData.source] ~= nil and next(PlayerStatus[Player.PlayerData.source]) ~= nil then
            for k, v in pairs(PlayerStatus[Player.PlayerData.source]) do
                table.insert(statList, PlayerStatus[Player.PlayerData.source][k].text)
            end
        end
	end
    cb(statList)
end)

RegisterServerEvent('HD-police:server:CreateCasing')
AddEventHandler('HD-police:server:CreateCasing', function(weapon, coords)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local casingId = CreateIdType('casing')
    local weaponInfo = exports['HD-weapons']:GetWeaponList(weapon)
    local serieNumber = nil
    if weaponInfo ~= nil then 
        local weaponItem = Player.Functions.GetItemByName(weaponInfo["IdName"])
        if weaponItem ~= nil then
            if weaponItem.info ~= nil and weaponItem.info ~= "" then 
                serieNumber = weaponItem.info.serie
            end
        end
    end
    TriggerClientEvent("HD-police:client:AddCasing", -1, casingId, weapon, coords, serieNumber)
end)

RegisterServerEvent('HD-police:server:CreateBloodDrop')
AddEventHandler('HD-police:server:CreateBloodDrop', function(coords)
 local src = source
 local Player = HDCore.Functions.GetPlayer(src)
 local bloodId = CreateIdType('blood')
 BloodDrops[bloodId] = Player.PlayerData.metadata["bloodtype"]
 TriggerClientEvent("HD-police:client:AddBlooddrop", -1, bloodId, Player.PlayerData.metadata["bloodtype"], coords)
end)

RegisterServerEvent('HD-police:server:CreateFingerDrop')
AddEventHandler('HD-police:server:CreateFingerDrop', function(coords)
 local src = source
 local Player = HDCore.Functions.GetPlayer(src)
 local fingerId = CreateIdType('finger')
 FingerDrops[fingerId] = Player.PlayerData.metadata["fingerprint"]
 TriggerClientEvent("HD-police:client:AddFingerPrint", -1, fingerId, Player.PlayerData.metadata["fingerprint"], coords)
end)

RegisterServerEvent('HD-police:server:CreateHairDrop')
AddEventHandler('HD-police:server:CreateHairDrop', function(coords)
 local src = source
 local Player = HDCore.Functions.GetPlayer(src)
 local HairId = CreateIdType('hair')
 HairDrops[HairId] = Player.PlayerData.metadata["haircode"]
 TriggerClientEvent("HD-police:client:AddHair", -1, HairId, Player.PlayerData.metadata["haircode"], coords)
end)

RegisterServerEvent('HD-police:server:CreateSlimeDrop')
AddEventHandler('HD-police:server:CreateSlimeDrop', function(coords)
 local src = source
 local Player = HDCore.Functions.GetPlayer(src)
 local SlimeId = CreateIdType('slime')
 SlimeDrops[SlimeId] = Player.PlayerData.metadata["slimecode"]
 TriggerClientEvent("HD-police:client:AddSlime", -1, SlimeId, Player.PlayerData.metadata["slimecode"], coords)
end)

RegisterServerEvent('HD-police:server:AddEvidenceToInventory')
AddEventHandler('HD-police:server:AddEvidenceToInventory', function(EvidenceType, EvidenceId, EvidenceInfo)
 local src = source
 local Player = HDCore.Functions.GetPlayer(src)
 if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
    if Player.Functions.AddItem("filled_evidence_bag", 1, false, EvidenceInfo) then
        RemoveDna(EvidenceType, EvidenceId)
        TriggerClientEvent("HD-police:client:RemoveDnaId", -1, EvidenceType, EvidenceId)
        TriggerClientEvent("HD-inventory:client:ItemBox", src, HDCore.Shared.Items["filled_evidence_bag"], "add")
    
        Player.Functions.SetMetaData("craftingrep", Player.PlayerData.metadata["craftingrep"]+1)
    end
 else
    TriggerClientEvent('HDCore:Notify', src, "Je moet een leeg bewijszak bij je hebben...", "error")
 end
end)


RegisterServerEvent('HD-police:server:SyncSpikes')
AddEventHandler('HD-police:server:SyncSpikes', function(table)
    TriggerClientEvent('HD-police:client:SyncSpikes', -1, table)
end)

-- // Finger Scanner \\ --

RegisterServerEvent('HD-police:server:show:machine')
AddEventHandler('HD-police:server:show:machine', function(PlayerId)
    local Player = HDCore.Functions.GetPlayer(PlayerId)
    TriggerClientEvent('HD-police:client:show:machine', PlayerId, source)
    TriggerClientEvent('HD-police:client:show:machine', source, PlayerId)
end)

RegisterServerEvent('HD-police:server:showFingerId')
AddEventHandler('HD-police:server:showFingerId', function(FingerPrintSession)
 local Player = HDCore.Functions.GetPlayer(source)
 local FingerId = Player.PlayerData.metadata["fingerprint"] 
 if math.random(1,25)  <= 15 then
 TriggerClientEvent('HD-police:client:show:fingerprint:id', FingerPrintSession, FingerId)
 TriggerClientEvent('HD-police:client:show:fingerprint:id', source, FingerId)
 end
end)

RegisterServerEvent('HD-police:server:set:tracker')
AddEventHandler('HD-police:server:set:tracker', function(TargetId)
    local Target = HDCore.Functions.GetPlayer(TargetId)
    local TrackerMeta = Target.PlayerData.metadata["tracker"]
    if TrackerMeta then
        Target.Functions.SetMetaData("tracker", false)
        TriggerClientEvent('HDCore:Notify', TargetId, 'Je enkelband is afgedaan.', 'error', 5000)
        TriggerClientEvent('HDCore:Notify', source, 'Je hebt een enkelband afgedaan van '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('HD-police:client:set:tracker', TargetId, false)
    else
        Target.Functions.SetMetaData("tracker", true)
        TriggerClientEvent('HDCore:Notify', TargetId, 'Je hebt een enkelband omgekregen.', 'error', 5000)
        TriggerClientEvent('HDCore:Notify', source, 'Je hebt een enkelband omgedaan bij '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('HD-police:client:set:tracker', TargetId, true)
    end
end)

RegisterServerEvent('HD-police:server:send:tracker:location')
AddEventHandler('HD-police:server:send:tracker:location', function(Coords, RequestId)
    local Target = HDCore.Functions.GetPlayer(RequestId)
    local AlertData = {title = "Enkelband Locatie", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "De enkelband locatie van: "..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname}
    TriggerClientEvent("HD-phone:client:addPoliceAlert", -1, AlertData)
    TriggerClientEvent('HD-police:client:send:tracker:alert', -1, Coords, Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname)
end)

-- // Update Cops \\ --
RegisterServerEvent('HD-police:server:UpdateCurrentCops')
AddEventHandler('HD-police:server:UpdateCurrentCops', function()
    local amount = 0
    for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    TriggerClientEvent("HD-police:SetCopCount", -1, amount)
end)

RegisterServerEvent('HD-police:server:UpdateStatus')
AddEventHandler('HD-police:server:UpdateStatus', function(data)
    local src = source
    PlayerStatus[src] = data
end)

RegisterServerEvent('HD-police:server:ClearDrops')
AddEventHandler('HD-police:server:ClearDrops', function(Type, List)
    local src = source
    if Type == 'casing' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("HD-police:client:RemoveDnaId", -1, 'casing', v)
                Casings[v] = nil
            end
        end
    elseif Type == 'finger' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("HD-police:client:RemoveDnaId", -1, 'finger', v)
                FingerDrops[v] = nil
            end
        end
    elseif Type == 'blood' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("HD-police:client:RemoveDnaId", -1, 'blood', v)
                BloodDrops[v] = nil
            end
        end
    elseif Type == 'Hair' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("HD-police:client:RemoveDnaId", -1, 'hair', v)
                HairDrops[v] = nil
            end
        end
    elseif Type == 'Slime' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("HD-police:client:RemoveDnaId", -1, 'slime', v)
                HairDrops[v] = nil
            end
        end
    end
end)

function RemoveDna(EvidenceType, EvidenceId)
 if EvidenceType == 'hair' then
     HairDrops[EvidenceId] = nil
 elseif EvidenceType == 'blood' then
     BloodDrops[EvidenceId] = nil
 elseif EvidenceType == 'finger' then
     FingerDrops[EvidenceId] = nil
 elseif EvidenceType == 'slime' then
     SlimeDrops[EvidenceId] = nil
 elseif EvidenceType == 'casing' then
     Casings[EvidenceId] = nil
 end
end

-- // Functions \\ --

function CreateIdType(Type)
    if Type == 'casing' then
        if Casings ~= nil then
	    	local caseId = math.random(10000, 99999)
	    	while Casings[caseId] ~= nil do
	    		caseId = math.random(10000, 99999)
	    	end
	    	return caseId
	    else
	    	local caseId = math.random(10000, 99999)
	    	return caseId
        end
    elseif Type == 'finger' then
        if FingerDrops ~= nil then
            local fingerId = math.random(10000, 99999)
            while FingerDrops[fingerId] ~= nil do
                fingerId = math.random(10000, 99999)
            end
            return fingerId
        else
            local fingerId = math.random(10000, 99999)
            return fingerId
        end
    elseif Type == 'blood' then
        if BloodDrops ~= nil then
            local bloodId = math.random(10000, 99999)
            while BloodDrops[bloodId] ~= nil do
                bloodId = math.random(10000, 99999)
            end
            return bloodId
        else
            local bloodId = math.random(10000, 99999)
            return bloodId
        end
    elseif Type == 'hair' then
        if HairDrops ~= nil then
            local hairId = math.random(10000, 99999)
            while HairDrops[hairId] ~= nil do
                hairId = math.random(10000, 99999)
            end
            return hairId
        else
            local hairId = math.random(10000, 99999)
            return hairId
        end
    elseif Type == 'slime' then
        if SlimeDrops ~= nil then
            local slimeId = math.random(10000, 99999)
            while SlimeDrops[slimeId] ~= nil do
                slimeId = math.random(10000, 99999)
            end
            return slimeId
        else
            local slimeId = math.random(10000, 99999)
            return slimeId
        end
   end
end

HDCore.Functions.CreateCallback('HD-police:GetPoliceVehicles', function(source, cb)
    local vehicles = {}
    exports['ghmattimysql']:execute('SELECT * FROM characters_vehicles WHERE state = @state', {['@state'] = "impound"}, function(result)
        if result[1] ~= nil then
            vehicles = result
        end
        cb(vehicles)
    end)
end)
-- // Commands \\ --

HDCore.Commands.Add("boei", "Boei iemand (Admin.)", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    if args ~= nil then
     local TargetPlayer = HDCore.Functions.GetPlayer(tonumber(args[1]))
       if TargetPlayer ~= nil then
         TriggerClientEvent("HD-police:client:get:cuffed", TargetPlayer.PlayerData.source, Player.PlayerData.source)
       end
    end
end, "admin")

HDCore.Commands.Add("maakleiding", "Zet iemand zijn hoge commando status", {{name="id", help="Speler ID"}, {name="status", help="True / False"}}, true, function(source, args)
  if args ~= nil then
    local TargetPlayer = HDCore.Functions.GetPlayer(tonumber(args[1]))
    if TargetPlayer ~= nil then
      if args[2]:lower() == 'true' then
          TargetPlayer.Functions.SetMetaData("ishighcommand", true)
          TriggerClientEvent('HDCore:Notify', TargetPlayer.PlayerData.source, 'Je bent nu een leidinggevende!', 'success')
          TriggerClientEvent('HDCore:Notify', source, 'Speler is nu een leidinggevende!', 'success')
      else
          TargetPlayer.Functions.SetMetaData("ishighcommand", false)
          TriggerClientEvent('HDCore:Notify', TargetPlayer.PlayerData.source, 'Je bent geen leidinggevende meer!', 'error')
          TriggerClientEvent('HDCore:Notify', source, 'Speler is GEEN leidinggevende meer!', 'error')
      end
    end
  end
end, "admin")

HDCore.Commands.Add("zetpolitie", "Neem een agent aan", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    local TargetPlayer = HDCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('HDCore:Notify', TargetPlayer.PlayerData.source, 'Je bent aangenomen als agent!', 'success')
          TriggerClientEvent('HDCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' aangenomen als agent!', 'success')
          TargetPlayer.Functions.SetJob('police')
      end
    end
end)

HDCore.Functions.CreateUseableItem("spikestrip", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("HD-police:client:SpawnSpikeStrip", source)
    end
end)

HDCore.Commands.Add("ontslapolitie", "Ontsla een agent", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    local TargetPlayer = HDCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('HDCore:Notify', TargetPlayer.PlayerData.source, 'Je bent ontslagen!', 'error')
          TriggerClientEvent('HDCore:Notify', Player.PlayerData.source, 'Je hebt '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' ontslagen!', 'success')
          TargetPlayer.Functions.SetJob('unemployed')
      end
    end
end)

HDCore.Commands.Add("dienstnummer", "Verander je dienstnummer", {{name="Nummer", help="Dienstnummer"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    if args[1] ~= nil then
        if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty then
         Player.Functions.SetMetaData("dienstnummer", args[1])
         TriggerClientEvent('HDCore:Notify', source, 'Dienstnummer succesvol aangepast. U bent nu de: ' ..args[1], 'success')
        else
            TriggerClientEvent('HDCore:Notify', source, 'Dit is alleen voor hulp diensten..', 'error')
        end
    end
end)

--[[HDCore.Commands.Add("setplate", "Verander je dienst kenteken", {{name="Nummer", help="Dienstnummer"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    if args[1] ~= nil then
        if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty then
           if args[1]:len() == 8 then
             Player.Functions.SetDutyPlate(args[1])
             TriggerClientEvent('HDCore:Notify', source, 'Kenteken succesvol aangepast. U dienst kenteken is nu: ' ..args[1], 'success')
           else
               TriggerClientEvent('HDCore:Notify', source, 'Het moet exact 8 karakters lang zijn..', 'error')
           end
        else
            TriggerClientEvent('HDCore:Notify', source, 'Dit is alleen voor hulp diensten..', 'error')
        end
    end
end)]]

HDCore.Commands.Add("kluis", "Open bewijskluis", {{"bsn", "BSN Nummer"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    if args[1] ~= nil then 
    if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) then
        TriggerClientEvent("HD-police:client:open:evidence", source, args[1])
    else
        TriggerClientEvent('HDCore:Notify', source, "Dit commando is alleen voor hulpdiensten!", "error")
    end
  else
    TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Je moet alle argumenten invoeren.")
 end
end)

HDCore.Commands.Add("geefpolitievoertuig", "Geef permissie voor een voertuig categorie een werknemer", {{name="Id", help="Werknemer Server ID"}, {name="Vehicle", help="Lokaal / Federaal / Rago / Motor / Unmarked"}, {name="status", help="True / False"}}, true, function(source, args)
    local SelfPlayerData = HDCore.Functions.GetPlayer(source)
    local TargetPlayerData = HDCore.Functions.GetPlayer(tonumber(args[1]))
    if TargetPlayerData ~= nil then
    local TargetPlayerVehicleData = TargetPlayerData.PlayerData.metadata['duty-vehicles']
    if SelfPlayerData.PlayerData.metadata['ishighcommand'] then
       if args[2]:upper() == 'LOKAAL' then
           if args[3] == 'true' then
               VehicleList = {Standard = true, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, DSU = TargetPlayerVehicleData.DSU}
           else
               VehicleList = {Standard = false, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, DSU = TargetPlayerVehicleData.DSU}
           end
       elseif args[2]:upper() == 'FEDERAAL' then
           if args[3] == 'true' then
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = true, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, DSU = TargetPlayerVehicleData.DSU}
           else
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = false, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, DSU = TargetPlayerVehicleData.DSU}
           end
       elseif args[2]:upper() == 'UNMARKED' then
           if args[3] == 'true' then
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = true, DSU = TargetPlayerVehicleData.DSU}
           else
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = false, DSU = TargetPlayerVehicleData.DSU}
           end 
        elseif args[2]:upper() == 'MOTOR' then
            if args[3] == 'true' then
                VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = true, Unmarked = TargetPlayerVehicleData.Unmarked, DSU = TargetPlayerVehicleData.DSU}
            else
                VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = false, Unmarked = TargetPlayerVehicleData.Unmarked, DSU = TargetPlayerVehicleData.DSU}
            end 
       elseif args[2]:upper() == 'RAGO' then
           if args[3] == 'true' then
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = true, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, DSU = TargetPlayerVehicleData.DSU}
           else
               VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = false, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, DSU = TargetPlayerVehicleData.DSU}
           end 
        elseif args[2]:upper() == 'DSU' then
            if args[3] == 'true' then
                VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, DSU = true}
            else
                VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked, DSU = false}
            end 
       end
       local PlayerCredentials = TargetPlayerData.PlayerData.metadata['dienstnummer']..' | '..TargetPlayerData.PlayerData.charinfo.firstname..' '..TargetPlayerData.PlayerData.charinfo.lastname
       TargetPlayerData.Functions.SetMetaData("duty-vehicles", VehicleList)
       TriggerClientEvent('HD-radialmenu:client:update:duty:vehicles', TargetPlayerData.PlayerData.source)
       if args[3] == 'true' then
        TriggerClientEvent('HDCore:Notify', TargetPlayerData.PlayerData.source, 'Je hebt een voertuig specialisatie ontvangen ('..args[2]:upper()..')', 'success')
        TriggerClientEvent('HDCore:Notify', SelfPlayerData.PlayerData.source, 'Je hebt succesvol de voertuig specialisatie ('..args[2]:upper()..') gegeven aan '..PlayerCredentials, 'success')
    else
        TriggerClientEvent('HDCore:Notify', TargetPlayerData.PlayerData.source, 'Je ('..args[2]:upper()..') specialisatie is afgenomen..', 'error')
        TriggerClientEvent('HDCore:Notify', SelfPlayerData.PlayerData.source, 'Je hebt succesvol de voertuig specialisatie ('..args[2]:upper()..') afgenomen van '..PlayerCredentials, 'error')
    end
        end
    end
end)

HDCore.Commands.Add("factuur", "Factuur uitschrijven", {{name="id", help="Speler ID"},{name="geld", help="Hoeveelheid"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    local TargetPlayer = HDCore.Functions.GetPlayer(tonumber(args[1]))
    local Amount = tonumber(args[2])
    if TargetPlayer ~= nil then
       if (Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "mechanic") then
         if Amount > 0 then
          TriggerClientEvent("HD-police:client:bill:player", TargetPlayer.PlayerData.source, Amount)
	   	  TriggerEvent('HD-phone:server:add:invoice', TargetPlayer.PlayerData.citizenid, Amount, 'Politie', 'invoice')  
         else
             TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Het bedrag moet hoger zijn dan 0")
         end
       elseif Player.PlayerData.job.name == "realestate" then
        if Amount > 0 then
               TriggerEvent('HD-phone:server:add:invoice', TargetPlayer.PlayerData.citizenid, Amount, 'Makelaar', 'realestate')  
           else
               TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Het bedrag moet hoger zijn dan 0")
           end
       else
           TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is alleen voor hulpdiensten!")
       end
       
       Player.Functions.SetMetaData("lockpickrep", Player.PlayerData.metadata["lockpickrep"]+1)
    end
end)

HDCore.Commands.Add("paylaw", "Betaal een advocaat", {{name="id", help="Speler ID"}, {name="geld", help="Hoeveelheid"}}, true, function(source, args)
	local Player = HDCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "judge" then
        local playerId = tonumber(args[1])
        local Amount = tonumber(args[2])
        local OtherPlayer = HDCore.Functions.GetPlayer(playerId)
        if OtherPlayer ~= nil then
            if OtherPlayer.PlayerData.job.name == "lawyer" then
                OtherPlayer.Functions.AddMoney("bank", Amount, "police-lawyer-paid")
                TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "SYSTEEM", "warning", "Je hebt €"..Amount..",- ontvangen voor je gegeven diensten!")
                TriggerClientEvent('HDCore:Notify', source, 'Je hebt een advocaat betaald!')
            else
                TriggerClientEvent('HDCore:Notify', source, 'Persoon is geen advocaat...', "error")
            end
            
       Player.Functions.SetMetaData("lockpickrep", Player.PlayerData.metadata["lockpickrep"]+1)
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is alleen voor hulpdiensten!")
    end
end)

HDCore.Commands.Add("payvab", "Betaal een VAB Medewerker", {{name="id", help="ID van een speler"}, {name="amount", help="Hoeveel?"}}, true, function(source, args)
	local Player = HDCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "judge" then
        local playerId = tonumber(args[1])
        local Amount = tonumber(args[2])
        local OtherPlayer = HDCore.Functions.GetPlayer(playerId)
        if OtherPlayer ~= nil then
            if OtherPlayer.PlayerData.job.name == "mechanic1" or OtherPlayer.PlayerData.job.name == "mechanic2" then
                OtherPlayer.Functions.AddMoney("bank", Amount, "police-mechanic-paid")
                TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "SYSTEM", "warning", "Je hebt €"..Amount..",- ontvangen voor je gegeven diensten!")
                TriggerClientEvent('HDCore:Notify', source, 'Je betaalde de VAB medewerker')
            else
                TriggerClientEvent('HDCore:Notify', source, 'Persoon is geen medewerker van de VAB', "error")
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je hebt geen bevoegdheden tot dit commando.")
    end
end)

HDCore.Commands.Add("paytow", "Pay a tow", {{name="id", help="ID van een speler"}, {name="amount", help="Hoeveel?"}}, true, function(source, args)
	local Player = HDCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "judge" then
        local playerId = tonumber(args[1])
        local Amount = tonumber(args[2])
        local OtherPlayer = HDCore.Functions.GetPlayer(playerId)
        if OtherPlayer ~= nil then
            if OtherPlayer.PlayerData.job.name == "tow" then
                OtherPlayer.Functions.AddMoney("bank", Amount, "police-tow-paid")
                TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "SYSTEM", "warning", "Je hebt €"..Amount..",- ontvangen voor je gegeven diensten!")
                TriggerClientEvent('HDCore:Notify', source, 'Je betaalde de Takel medewerker')
            else
                TriggerClientEvent('HDCore:Notify', source, 'Persoon is geen medewerker van de takeldienst', "error")
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Je hebt geen bevoegdheden tot dit commando.")
    end
end)

HDCore.Commands.Add("camera", "Bekijk Camera", {{name="camid", help="Camera ID"}}, false, function(source, args)
	local Player = HDCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("HD-police:client:CameraCommand", source, tonumber(args[1]))
    else
        TriggerClientEvent('chat:addMessage', source, {
        template = '<div class="chat-message emergency">Dit commando is alleen voor hulpdiensten!  </div>',
        })
    end
end)

HDCore.Commands.Add("112", "Stuur een melding naar de hulpdiensten", {{name="melding", help="De melding die je wilt sturen"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent('HD-police:client:send:alert', source, Message, false)
    else
        TriggerClientEvent('HDCore:Notify', source, 'Je hebt geen telefoon...', 'error')
    end
end)

HDCore.Commands.Add("112r", "Stuur een bericht terug naar een melding", {{name="id", help="ID van de melding"}, {name="bericht", help="Bericht die je wilt sturen"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    local OtherPlayer = HDCore.Functions.GetPlayer(tonumber(args[1]))
    table.remove(args, 1)
    local message = table.concat(args, " ")
    if Player.PlayerData.job.name == "police" then
        if OtherPlayer ~= nil then
            TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "(POLITIE) " ..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname, "error", message)
            TriggerClientEvent("HD-police:client:call:anim", source)
        end
    elseif Player.PlayerData.job.name == "ambulance" then
        if OtherPlayer ~= nil then 
            TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "(AMBULANCE) " ..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname, "error", message)
            TriggerClientEvent("HD-police:client:call:anim", source)
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Dit command is voor hulpdiensten!")
    end
end)

HDCore.Commands.Add("112a", "Stuur een anonieme melding naar hulpdiensten (geeft geen locatie)", {{name="melding", help="De melding die je anoniem wilt sturen"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent("HD-police:client:call:anim", source)
        TriggerClientEvent('HD-police:client:send:alert', -1, Message, true)
    else
        TriggerClientEvent('HDCore:Notify', source, 'Je hebt geen telefoon...', 'error')
    end
end)

HDCore.Commands.Add("unjail", "Haal persoon uit het gevang.", {{name="id", help="Speler ID"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        local playerId = tonumber(args[1])
        TriggerClientEvent("HD-prison:client:leave:prison", playerId)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Alleen voor hulpdiensten.", "success")
    end
end)


HDCore.Commands.Add("beslag", "Neem een voertuig in beslag", {}, true, function(source, args)
	local Player = HDCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        TriggerClientEvent("HD-police:client:ImpoundVehicle", source, tonumber(args[1]))
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Alleen voor hulpdiensten.")
    end
end)

HDCore.Commands.Add("enkelbandlocatie", "Haal locatie van persoon met enkelband", {{name="bsn", help="BSN van de burger"}}, true, function(source, args)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        if args[1] ~= nil then
            local citizenid = args[1]
            local Target = HDCore.Functions.GetPlayerByCitizenId(citizenid)
            local Tracking = false
            if Target ~= nil then
                if Target.PlayerData.metadata["tracker"] and not Tracking then
                    Tracking = true
                    TriggerClientEvent("HD-police:client:send:tracker:location", Target.PlayerData.source, Target.PlayerData.source)
                else
                    TriggerClientEvent('HDCore:Notify', source, 'Dit persoon heeft geen enkelband...', 'error')
                end
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Dit commando is alleen voor hulpdiensten!")
    end
end)

HDCore.Functions.CreateUseableItem("handcuffs", function(source, item)
    local Player = HDCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("HD-police:client:cuff:closest", source)
    end
end)

-- // HandCuffs \\ --
RegisterServerEvent('HD-police:server:cuff:closest')
AddEventHandler('HD-police:server:cuff:closest', function(SeverId)
    local Player = HDCore.Functions.GetPlayer(source)
    local CuffedPlayer = HDCore.Functions.GetPlayer(SeverId)
    if CuffedPlayer ~= nil then
        TriggerClientEvent("HD-police:client:get:cuffed", CuffedPlayer.PlayerData.source, Player.PlayerData.source)
    end
end)

RegisterServerEvent('HD-police:server:set:handcuff:status')
AddEventHandler('HD-police:server:set:handcuff:status', function(Cuffed)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player ~= nil then
		Player.Functions.SetMetaData("ishandcuffed", Cuffed)
	end
end)

RegisterServerEvent('HD-police:server:escort:closest')
AddEventHandler('HD-police:server:escort:closest', function(SeverId)
    local Player = HDCore.Functions.GetPlayer(source)
    local EscortPlayer = HDCore.Functions.GetPlayer(SeverId)
    if EscortPlayer ~= nil then
        if (EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"]) then
            TriggerClientEvent("HD-police:client:get:escorted", EscortPlayer.PlayerData.source, Player.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

RegisterServerEvent('HD-police:server:set:out:veh')
AddEventHandler('HD-police:server:set:out:veh', function(ServerId)
    local Player = HDCore.Functions.GetPlayer(source)
    local EscortPlayer = HDCore.Functions.GetPlayer(ServerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("HD-police:client:set:out:veh", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

RegisterServerEvent('HD-police:server:set:in:veh')
AddEventHandler('HD-police:server:set:in:veh', function(ServerId)
    local Player = HDCore.Functions.GetPlayer(source)
    local EscortPlayer = HDCore.Functions.GetPlayer(ServerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("HD-police:client:set:in:veh", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEEM", "error", "Persoon is niet dood of geboeid!")
        end
    end
end)

HDCore.Functions.CreateCallback('HD-police:server:is:player:dead', function(source, cb, playerId)
    local Player = HDCore.Functions.GetPlayer(playerId)
    cb(Player.PlayerData.metadata["isdead"])
end)

RegisterServerEvent('HD-police:server:SearchPlayer')
AddEventHandler('HD-police:server:SearchPlayer', function(playerId)
    local src = source
    local SearchedPlayer = HDCore.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        TriggerClientEvent('chatMessage', source, "SYSTEEM", "warning", "Persoon heeft €"..SearchedPlayer.PlayerData.money["cash"]..",- op zak..")
        TriggerClientEvent('HDCore:Notify', SearchedPlayer.PlayerData.source, "Je wordt gefouilleerd..")
    end
end)

RegisterServerEvent('HD-police:server:rob:player')
AddEventHandler('HD-police:server:rob:player', function(playerId)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local SearchedPlayer = HDCore.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        local money = SearchedPlayer.PlayerData.money["cash"]
        Player.Functions.AddMoney("cash", money, "police-player-robbed")
        SearchedPlayer.Functions.RemoveMoney("cash", money, "police-player-robbed")
        TriggerClientEvent('HDCore:Notify', SearchedPlayer.PlayerData.source, "Je bent van €"..money.." beroofd")
    end
    
    Player.Functions.SetMetaData("lockpickrep", Player.PlayerData.metadata["lockpickrep"]+1)
end)

RegisterServerEvent('HD-police:server:send:call:alert')
AddEventHandler('HD-police:server:send:call:alert', function(Coords, Message)
 local Player = HDCore.Functions.GetPlayer(source)
 local Name = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
 local AlertData = {title = "112 Melding - "..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. " ("..source..")", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = Message}
 TriggerClientEvent("HD-phone:client:addPoliceAlert", -1, AlertData)
 TriggerClientEvent('HD-police:client:send:message', -1, Coords, Message, Name)
end)

RegisterServerEvent('HD-police:server:spawn:object')
AddEventHandler('HD-police:server:spawn:object', function(type)
    local src = source
    local objectId = CreateIdType('casing')
    Objects[objectId] = type
    TriggerClientEvent("HD-police:client:place:object", -1, objectId, type, src)
end)

RegisterServerEvent('HD-police:server:delete:object')
AddEventHandler('HD-police:server:delete:object', function(objectId)
    local src = source
    TriggerClientEvent('HD-police:client:remove:object', -1, objectId)
end)



RegisterServerEvent('HD-police:server:hardimpound')
AddEventHandler('HD-police:server:hardimpound', function(plate, price)
    local src = source
    local price = price ~= nil and price or 1000
    local state = "in"
    if IsVehicleOwned(plate) then
            exports['ghmattimysql']:execute('UPDATE characters_vehicles SET garage = "Police", state = @state, depotprice = @depotprice WHERE plate = @plate', {['@garage'] = "Police", ['@state'] = "in", ['@depotprice'] = price, ['@plate'] = plate})
            TriggerClientEvent('HDCore:Notify', src, "Voertuig opgenomen in depot voor €"..price.."!")
    end
end)


-- // Police Alerts Events \\ --

RegisterServerEvent('HD-police:server:send:alert:officer:down')
AddEventHandler('HD-police:server:send:alert:officer:down', function(Coords, StreetName, Info, Priority)
   TriggerClientEvent('HD-police:client:send:officer:down', -1, Coords, StreetName, Info, Priority)
end)

RegisterServerEvent('HD-police:server:send:alert:panic:button')
AddEventHandler('HD-police:server:send:alert:panic:button', function(Coords, StreetName, Info)
    local AlertData = {title = "Assistentie collega", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Noodknop ingedrukt door "..Info['dienstnummer'].." "..Info['Firstname']..' '..Info['Lastname'].." bij "..StreetName}
    TriggerClientEvent("HD-phone:client:addPoliceAlert", -1, AlertData)
    TriggerClientEvent('HD-police:client:send:alert:panic:button', -1, Coords, StreetName, Info)
end)

RegisterServerEvent('HD-police:server:send:alert:gunshots')
AddEventHandler('HD-police:server:send:alert:gunshots', function(Coords, GunType, StreetName, InVeh)
    local AlertData = {title = "Shots Fired",coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = 'Shots fired nearby ' ..StreetName}
    if InVeh then
      AlertData = {title = "Shots Fired",coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = 'Shots fired out of vehicle, near ' ..StreetName}
    end
   TriggerClientEvent("HD-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('HD-police:client:send:alert:gunshots', -1, Coords, GunType, StreetName, InVeh)
end)

RegisterServerEvent('HD-police:server:send:alert:dead')
AddEventHandler('HD-police:server:send:alert:dead', function(Coords, StreetName)
   local AlertData = {title = "Citizen down", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "A citizen was reported to have lose conscious near "..StreetName}
   TriggerClientEvent("HD-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('HD-police:client:send:alert:dead', -1, Coords, StreetName)
end)

RegisterServerEvent('HD-police:server:send:bank:alert')
AddEventHandler('HD-police:server:send:bank:alert', function(Coords, StreetName, CamId)
   local AlertData = {title = "Bank Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Fleeca bank robbery in progress at "..StreetName}
   TriggerClientEvent("HD-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('HD-police:client:send:bank:alert', -1, Coords, StreetName, CamId)
end)

RegisterServerEvent('HD-police:server:send:alert:meter')
AddEventHandler('HD-police:server:send:alert:meter', function(Coords, StreetName)
   local AlertData = {title = "Parkingmeter Robbery", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Parking meter is being robbed at "..StreetName}
   TriggerClientEvent("HD-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('HD-police:client:send:meter:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('HD-police:server:send:alert:jewellery')
AddEventHandler('HD-police:server:send:alert:jewellery', function(Coords, StreetName)
   local AlertData = {title = "Jewellery Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Jewellery robbery in progress at "..StreetName}
   TriggerClientEvent("HD-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('HD-police:client:send:alert:jewellery', -1, Coords, StreetName)
end)

RegisterServerEvent('HD-police:server:send:alert:store')
AddEventHandler('HD-police:server:send:alert:store', function(Coords, StreetName, StoreNumber)
   local AlertData = {title = "Store Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Store robbery: "..StoreNumber..' currently being robbed at '..StreetName}
   TriggerClientEvent("HD-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('HD-police:client:send:alert:store', -1, Coords, StreetName, StoreNumber)
end)

RegisterServerEvent('HD-police:server:send:house:alert')
AddEventHandler('HD-police:server:send:house:alert', function(Coords, StreetName)
   local AlertData = {title = "Huis Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "House alarm has been pressed at "..StreetName}
   TriggerClientEvent("HD-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('HD-police:client:send:house:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('HD-police:server:send:banktruck:alert')
AddEventHandler('HD-police:server:send:banktruck:alert', function(Coords, Plate, StreetName)
   local AlertData = {title = "Bankwagen Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Bank truck robbery started. Plate: "..Plate..'. near '..StreetName}
   TriggerClientEvent("HD-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('HD-police:client:send:banktruck:alert', -1, Coords, Plate, StreetName)
end)


RegisterServerEvent('HD-police:server:send:weaponrobbery:alert')
AddEventHandler('HD-police:server:send:weaponrobbery:alert', function(Coords, Plate, StreetName)
   local AlertData = {title = "Ammunation Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Ammunation is being robbed near "..StreetName}
   TriggerClientEvent("HD-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('HD-police:client:send:ammunation:alert', -1, Coords, StreetName)
end)
