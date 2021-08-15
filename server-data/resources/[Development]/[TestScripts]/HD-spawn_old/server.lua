HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)
Citizen.CreateThread(function()
	local HouseGarages = {}
	HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses`", function(result)
		if result[1] ~= nil then
			for k, v in pairs(result) do
				local owned = false
				if tonumber(v.owned) == 1 then
					owned = true
				end
				local garage = v.garage ~= nil and json.decode(v.garage) or {}
				Config.Houses[v.name] = {
					coords = json.decode(v.coords),
					owned = v.owned,
					price = v.price,
					locked = true,
					adress = v.label, 
					tier = v.tier,
					garage = garage,
					decorations = {},
				}
				HouseGarages[v.name] = {
					label = v.label,
					takeVehicle = garage,
				}
			end
		end
		TriggerClientEvent("HD-garages:client:houseGarageConfig", -1, HouseGarages)
		TriggerClientEvent("HD-houses:client:setHouseConfig", -1, Config.Houses)
	end)
end)

HDCore.Functions.CreateCallback('HD-spawn:server:getOwnedHouses', function(source, cb, cid)
	if cid ~= nil then
		HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_houses` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
			if houses[1] ~= nil then
				cb(houses)
			else
				cb(nil)
			end
		end)
	else
		cb(nil)
	end
end)