HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Functions.CreateCallback("HD-housing:server:get:config", function(source, cb)
    cb(Config)
end)

Citizen.CreateThread(function()
    Citizen.SetTimeout(450, function()
        HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses`", function(result)
            if result[1] ~= nil then
                for k, v in pairs(result) do
                    if v.owned == 'true' then
                        Owned = true
                    else
                        Owned = false
                    end
                    Config.Houses[v.name] = {
                        ['Coords'] = json.decode(v.coords),
                        ['Owned'] = Owned,
                        ['Owner'] = v.citizenid,
                        ['Tier'] = v.tier,
                        ['Price'] = v.price,
                        ['Door-Lock'] = true,
                        ['Adres'] = v.label,
                        ['Garage'] = json.decode(v.garage),
                        ['Key-Holders'] = json.decode(v.keyholders),
                        ['Decorations'] = {}
                    }
                    Citizen.Wait(150)
                    TriggerClientEvent("HD-housing:client:add:to:config", -1, v.name, v.citizenid, json.decode(v.coords), Owned, v.tier, v.price, true, json.decode(v.keyholders), v.label, json.decode(v.garage))
                end
            end
        end)
    end)
end)

HDCore.Functions.CreateCallback('HD-housing:server:has:house:key', function(source, cb, HouseId)
	local src = source
	local Player = HDCore.Functions.GetPlayer(src)
	local retval = false
	if Player ~= nil then 
        for key, housekey in pairs(Config.Houses[HouseId]['Key-Holders']) do
            if housekey == Player.PlayerData.citizenid then
                cb(true)
            end
        end
    end
	cb(false)
end)

HDCore.Functions.CreateCallback('HD-housing:server:get:decorations', function(source, cb, house)
	local retval = nil
	HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE `name` = '"..house.."'", function(result)
		if result[1] ~= nil then
			if result[1].decorations ~= nil then
				retval = json.decode(result[1].decorations)
			end
		end
		cb(retval)
	end)
end)

HDCore.Functions.CreateCallback('HD-housing:server:get:locations', function(source, cb, HouseId)
	local retval = nil
	HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE `name` = '"..HouseId.."'", function(result)
		if result[1] ~= nil then
			retval = result[1]
		end
		cb(retval)
	end)
end)

HDCore.Functions.CreateCallback('HD-phone:server:GetPlayerHouses', function(source, cb)
	local src = source
	local Player = HDCore.Functions.GetPlayer(src)
    local MyHouses = {}
	HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
      if result ~= nil then
          for k, v in pairs(result) do
            table.insert(MyHouses, {
                name = v.name,
                keyholders = {},
                owner = Player.PlayerData.citizenid,
                price = Config.Houses[v.name]['Price'],
                label = Config.Houses[v.name]['Adres'],
                tier = Config.Houses[v.name]['Tier'],
                garage = v.hasgarage,
            })
            if v.keyholders ~= nil then
             local KeyHolders = json.decode(v.keyholders)
             for key, keyholder in pairs(KeyHolders) do
	           HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_metadata` WHERE `citizenid` = '"..keyholder.."'", function(result)   
                    if result ~= nil then
                        result[1].charinfo = json.decode(result[1].charinfo )
                        table.insert(MyHouses[k].keyholders, result[1])
                    end
               end)
             end
            end
          end
        else
        table.insert(MyHouses, {})
      end
      SetTimeout(100, function()
        cb(MyHouses)
    end)
    end)
end)

HDCore.Functions.CreateCallback('HD-phone:server:GetHouseKeys', function(source, cb)
	local src = source
	local Player = HDCore.Functions.GetPlayer(src)
	local MyKeys = {}
	HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses`", function(result)
		for k, v in pairs(result) do
			if v.keyholders ~= "null" then
				v.keyholders = json.decode(v.keyholders)
				for s, p in pairs(v.keyholders) do
					if p == Player.PlayerData.citizenid and (v.citizenid ~= Player.PlayerData.citizenid) then
						table.insert(MyKeys, {
							HouseData = Config.Houses[v.name]
						})
					end
				end
			end

			if v.citizenid == Player.PlayerData.citizenid then
				table.insert(MyKeys, {
					HouseData = Config.Houses[v.name]
				})
			end
		end
		cb(MyKeys)
	end)
end)

HDCore.Functions.CreateCallback('HD-phone:server:TransferCid', function(source, cb, NewCid, house)
	HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_metadata` WHERE `citizenid` = '"..NewCid.."'", function(result)
        if result[1] ~= nil then
            local src = source
            local HouseName = house.name
            local Player = HDCore.Functions.GetPlayer(src)
            Config.Houses[HouseName]['Owner'] = NewCid
            Config.Houses[HouseName]['Key-Holders'] = {
                [1] = NewCid
            }
			HDCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET citizenid='"..NewCid.."', keyholders = '[\""..NewCid.."\"]' WHERE `name` = '"..HouseName.."'")
			cb(true)
		else
			cb(false)
		end
	end)
end)

RegisterServerEvent('HD-housing:server:view:house')
AddEventHandler('HD-housing:server:view:house', function(HouseId)
 local src = source
 local Player = HDCore.Functions.GetPlayer(src) 
 local houseprice = Config.Houses[HouseId]['Price']
 local brokerfee = (houseprice / 100 * 5)
 local bankfee = (houseprice / 100 * 10) 
 local taxes = (houseprice / 100 * 6) 
 TriggerClientEvent('HD-housing:client:view:house', src, houseprice, brokerfee, bankfee, taxes, Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
end)

RegisterServerEvent('HD-housing:server:buy:house')
AddEventHandler('HD-housing:server:buy:house', function(HouseId)
  local src = source
  local Player = HDCore.Functions.GetPlayer(src)
  local HousePrice = math.ceil(Config.Houses[HouseId]['Price'] * 1.21)
  if Player.PlayerData.money['bank'] >= HousePrice then
    HDCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET citizenid='"..Player.PlayerData.citizenid.."', owned='true', keyholders = '[\""..Player.PlayerData.citizenid.."\"]' WHERE `name` = '"..HouseId.."'")
    Player.Functions.RemoveMoney('bank', HousePrice, "Bought House")
    Config.Houses[HouseId]['Key-Holders'] = {
        [1] = Player.PlayerData.citizenid
    }
    Config.Houses[HouseId]['Owned'] = true
    Config.Houses[HouseId]['Owner'] = Player.PlayerData.citizenid
    TriggerClientEvent('HDCore:Notify', src, "Je hebt een huis gekocht: "..Config.Houses[HouseId]['Adres'], 'success', 8500)
    TriggerClientEvent('HD-housing:client:set:owned', -1, HouseId, true, Player.PlayerData.citizenid)
  end
end)

RegisterServerEvent('HD-housing:server:add:new:house')
AddEventHandler('HD-housing:server:add:new:house', function(StreetName, CoordsTable, Price, Tier)
    local src = source
    local Price, Tier = tonumber(Price), tonumber(Tier)
    local Street = StreetName:gsub("%'", "")
    local HouseNumber = GetFreeHouseNumber(Street)
    local Name, Label = Street:lower()..tostring(HouseNumber), Street..' '..tostring(HouseNumber)
    HDCore.Functions.ExecuteSql(true, "INSERT INTO `player_houses` (`name`, `label`, `price`, `tier`, `owned`, `coords`, `keyholders`) VALUES ('"..Name.."', '"..Label.."', "..Price..", "..Tier..", 'false', '"..json.encode(CoordsTable).."', '{}')")
    Config.Houses[Name] = {
        ['Coords'] = CoordsTable,
        ['Owned'] = false,
        ['Owner'] = nil,
        ['Tier'] = Tier,
        ['Price'] = Price,
        ['Door-Lock'] = true,
        ['Adres'] = Label,
        ['Garage'] = {},
        ['Key-Holders'] = {},
        ['Decorations'] = {}
    }
    TriggerClientEvent('HD-housing:client:add:to:config', -1, Name, nil, CoordsTable, false, Tier, Price, true, {}, Label)
    TriggerClientEvent('HDCore:Notify', src, "Je hebt een huis toegevoegd: "..Label, 'info', 8500)
end)

RegisterServerEvent('HD-housing:server:add:garage')
AddEventHandler('HD-housing:server:add:garage', function(HouseId, HouseName, Coords)
	local src = source
	HDCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET `garage` = '"..json.encode(Coords).."', `hasgarage` = 'true' WHERE `name` = '"..HouseId.."'")
    Config.Houses[HouseId]['Garage'] = Coords
    TriggerClientEvent('HD-housing:client:set:garage', -1, HouseId, Coords)
	TriggerClientEvent('HDCore:Notify', src, "Je hebt een garage toegevoegd bij: "..HouseName)
end)

RegisterServerEvent('HD-housing:server:save:decorations')
AddEventHandler('HD-housing:server:save:decorations', function(house, decorations)
 HDCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET `decorations` = '"..json.encode(decorations).."' WHERE `name` = '"..house.."'")
 TriggerClientEvent("HD-housing:server:sethousedecorations", -1, house, decorations)
end)

RegisterServerEvent('HD-housing:server:give:keys')
AddEventHandler('HD-housing:server:give:keys', function(HouseId, Target)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local TargetPlayer = HDCore.Functions.GetPlayer(Target)
    if TargetPlayer ~= nil then
        TriggerClientEvent('HDCore:Notify', TargetPlayer.PlayerData.source, "Je hebt huis sleutels ontvangen: "..Config.Houses[HouseId]['Adres'], 'success', 8500)
        table.insert(Config.Houses[HouseId]['Key-Holders'], TargetPlayer.PlayerData.citizenid)
        HDCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET `keyholders` = '"..json.encode(Config.Houses[HouseId]['Key-Holders']).."' WHERE `name` = '"..HouseId.."'")
    end
end)

RegisterServerEvent('HD-housing:server:logout')
AddEventHandler('HD-housing:server:logout', function()
 local src = source
 local Player = HDCore.Functions.GetPlayer(src)
 local PlayerItems = Player.PlayerData.items
 TriggerClientEvent('HD-radio:onRadioDrop', src)
 if PlayerItems ~= nil then
    HDCore.Functions.ExecuteSql(true, "UPDATE `player_metadata` SET `inventory` = '"..HDCore.EscapeSqli(json.encode(MyItems)).."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
 else
    HDCore.Functions.ExecuteSql(true, "UPDATE `player_metadata` SET `inventory` = '{}' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
 end
 HDCore.Player.Logout(src)
 Citizen.Wait(450)
 TriggerClientEvent('HD-multichar:client:open:select', src)
end)

RegisterServerEvent('HD-housing:server:set:location')
AddEventHandler('HD-housing:server:set:location', function(HouseId, CoordsTable, Type)
    local src = source
	local Player = HDCore.Functions.GetPlayer(src)
	if Type == 'stash' then
		HDCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `stash` = '"..json.encode(CoordsTable).."' WHERE `name` = '"..HouseId.."'")
	elseif Type == 'clothes' then
		HDCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `outfit` = '"..json.encode(CoordsTable).."' WHERE `name` = '"..HouseId.."'")
	elseif Type == 'logout' then
		HDCore.Functions.ExecuteSql(true, "UPDATE `player_houses` SET `logout` = '"..json.encode(CoordsTable).."' WHERE `name` = '"..HouseId.."'")
	end
	TriggerClientEvent('HD-housing:client:refresh:location', -1, HouseId, CoordsTable, Type)
end)

RegisterServerEvent('HD-housing:server:ring:door')
AddEventHandler('HD-housing:server:ring:door', function(HouseId)
    local src = source
    TriggerClientEvent('HD-housing:client:ringdoor', -1, src, HouseId)
end)

RegisterServerEvent('HD-housing:server:open:door')
AddEventHandler('HD-housing:server:open:door', function(Taget, HouseId)
    local OtherPlayer = HDCore.Functions.GetPlayer(Taget)
    if OtherPlayer ~= nil then
        TriggerClientEvent('HD-housing:client:set:in:house', OtherPlayer.PlayerData.source, HouseId)
    end
end)

RegisterServerEvent('HD-housing:server:remove:house:key')
AddEventHandler('HD-housing:server:remove:house:key', function(HouseId, CitizenId)
	local src = source
    local NewKeyHolders = {}
    if Config.Houses[HouseId]['Key-Holders'] ~= nil then
        for k, v in pairs(Config.Houses[HouseId]['Key-Holders']) do
            if Config.Houses[HouseId]['Key-Holders'][k] ~= CitizenId then
                table.insert(NewKeyHolders, Config.Houses[HouseId]['Key-Holders'][k])
            end
        end
    end
    Config.Houses[HouseId]['Key-Holders'] = NewKeyHolders
	TriggerClientEvent('HD-housing:client:set:new:key:holders', -1, HouseId, NewKeyHolders)
	TriggerClientEvent('HDCore:Notify', src, "sleutels zijn verwijderd..", 'error', 3500)
	HDCore.Functions.ExecuteSql(false, "UPDATE `player_houses` SET `keyholders` = '"..json.encode(NewKeyHolders).."' WHERE `name` = '"..HouseId.."'")
end)

RegisterServerEvent('HD-housing:server:set:house:door')
AddEventHandler('HD-housing:server:set:house:door', function(HouseId, bool)
    Config.Houses[HouseId]['Door-Lock'] = bool
    TriggerClientEvent('HD-housing:client:set:house:door', -1, HouseId, bool)
end)

RegisterServerEvent('HD-housing:server:detlete:house')
AddEventHandler('HD-housing:server:detlete:house', function(HouseId)
    Config.Houses[HouseId] = {}
    HDCore.Functions.ExecuteSql(false, "DELETE FROM `player_houses` WHERE `name` = '"..HouseId.."'")
    TriggerClientEvent('HDCore:Notify', source, '['..HouseId.."] Huis is verwijderd.", 'error', 3500)
    TriggerClientEvent('HD-housing:client:delete:successful', -1, HouseId)
end)

HDCore.Commands.Add("createhouse", "Maak een huis aan als makelaar", {{name="price", help="Prijs van het huis"}, {name="tier", help="Huizen: [1 / 2 / 3 / 4 / 5 / 6 / 7 / 8 / 9 / 10] Garages: [11 / 12]"}}, true, function(source, args)
	local Player = HDCore.Functions.GetPlayer(source)
	local price = tonumber(args[1])
	local tier = tonumber(args[2])
	if Player.PlayerData.job.name == "realestate" then
        if tier <= 12 then
		    TriggerClientEvent("HD-housing:client:create:house", source, price, tier)
        else
            TriggerClientEvent('HDCore:Notify', source, "Deze tier bestaat niet..", "error")
        end
	end
end)

HDCore.Commands.Add("deletehouse", "Verwijder het huis waar je nu staat", {}, false, function(source, args)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "realestate" then
		TriggerClientEvent("HD-housing:client:delete:house", source)
    else
        TriggerClientEvent('HDCore:Notify', source, "Deze tier bestaat niet..", "error")
	end
end)

HDCore.Commands.Add("addgarage", "Garage toevoegen bij het huis waar ", {}, false, function(source, args)
	local Player = HDCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == "realestate" then
		TriggerClientEvent("HD-housing:client:add:garage", source)
	end
end)

HDCore.Commands.Add("ring", "Aanbellen bij huis", {}, false, function(source, args)
    TriggerClientEvent('HD-housing:client:ring:door', source)
end)

HDCore.Functions.CreateUseableItem("police_stormram", function(source, item)
	local Player = HDCore.Functions.GetPlayer(source)
	if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
		TriggerClientEvent("HD-housing:client:breaking:door", source)
	else
		TriggerClientEvent('HDCore:Notify', source, "Dit is alleen mogelijk voor hulpdiensten!", "error")
	end
end)

-- Functions \\ --

function GetFreeHouseNumber(StreetName)
    local count = 1
	HDCore.Functions.ExecuteSql(true, "SELECT * FROM `player_houses` WHERE `name` LIKE '%"..StreetName.."%'", function(result)
		if result[1] ~= nil then
			for i = 1, #result, 1 do
				count = count + 1
			end
		end
		return count
	end)
	return count
end


