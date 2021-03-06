HDCore.Players = {}
HDCore.Player = {}

HDCore.Player.Login = function(Source, IsCharNew, CitizenId, newData)
	if Source ~= nil then
		if IsCharNew then
			local PlayerData = {}
			PlayerData.cid = newData.cid
			PlayerData.charinfo = {
			  firstname = newData.firstname,
			  lastname = newData.lastname,
			  birthdate = newData.birthdate,
			  gender = newData.gender,
			  nationality = newData.nationality,
			}
		  HDCore.Player.CheckPlayerData(Source, PlayerData)
		  return true
		else
		 HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_metadata` WHERE `citizenid` = '"..CitizenId.."'", function(result)
		 	local PlayerData = result[1]
		 	if PlayerData ~= nil then
		 		PlayerData.money = json.decode(PlayerData.money)
				PlayerData.position = json.decode(PlayerData.position)
				PlayerData.job = json.decode(PlayerData.job)
				if PlayerData.gang ~= nil then
					PlayerData.gang = json.decode(PlayerData.gang)
				else
					PlayerData.gang = {}
				end
		 		PlayerData.metadata = json.decode(PlayerData.globals)
		 		PlayerData.charinfo = json.decode(PlayerData.charinfo)
		 		-- PlayerData.levels = json.decode(PlayerData.levels)
			 end	
			 HDCore.Player.CheckPlayerData(Source, PlayerData)		
		 end)
		 return true
		end
	end
end


HDCore.Player.CheckPlayerData = function(source, PlayerData)
	PlayerData = PlayerData ~= nil and PlayerData or {}
	PlayerData.source = source
	PlayerData.citizenid = PlayerData.citizenid ~= nil and PlayerData.citizenid or HDCore.Player.CreateCitizenId()
	PlayerData.steam = PlayerData.steam ~= nil and PlayerData.steam or HDCore.Functions.GetIdentifier(source, "steam")
	PlayerData.license = PlayerData.license ~= nil and PlayerData.license or HDCore.Functions.GetIdentifier(source, "license")
	PlayerData.name = GetPlayerName(source)
	PlayerData.cid = PlayerData.cid ~= nil and PlayerData.cid or 1

	PlayerData.money = PlayerData.money ~= nil and PlayerData.money or {}
	for moneytype, startamount in pairs(HDCore.Config.Money.MoneyTypes) do
		PlayerData.money[moneytype] = PlayerData.money[moneytype] ~= nil and PlayerData.money[moneytype] or startamount
	end

	PlayerData.charinfo = PlayerData.charinfo ~= nil and PlayerData.charinfo or {}
	PlayerData.charinfo.firstname = PlayerData.charinfo.firstname ~= nil and PlayerData.charinfo.firstname or "Firstname"
	PlayerData.charinfo.lastname = PlayerData.charinfo.lastname ~= nil and PlayerData.charinfo.lastname or "Lastname"
	PlayerData.charinfo.birthdate = PlayerData.charinfo.birthdate ~= nil and PlayerData.charinfo.birthdate or "00-00-0000"
	PlayerData.charinfo.gender = PlayerData.charinfo.gender ~= nil and PlayerData.charinfo.gender or 0
	PlayerData.charinfo.nationality = PlayerData.charinfo.nationality ~= nil and PlayerData.charinfo.nationality or "Nederlands"
	PlayerData.charinfo.phone = PlayerData.charinfo.phone ~= nil and PlayerData.charinfo.phone or "04"..math.random(11111111, 99999999)
	PlayerData.charinfo.account = PlayerData.charinfo.account ~= nil and PlayerData.charinfo.account or "BE0"..math.random(1,9)..HDCore.Shared.RandomInt(3):upper()..math.random(1111,9999)..math.random(1111,9999)..math.random(11,99)
    PlayerData.metadata = PlayerData.metadata ~= nil and PlayerData.metadata or {}
    --Health Shit
    PlayerData.metadata["health"]  = PlayerData.metadata["health"]  ~= nil and PlayerData.metadata["health"] or 100
    PlayerData.metadata["armor"]  = PlayerData.metadata["armor"]  ~= nil and PlayerData.metadata["armor"] or 0
	PlayerData.metadata["hunger"] = PlayerData.metadata["hunger"] ~= nil and PlayerData.metadata["hunger"] or 100
	PlayerData.metadata["thirst"] = PlayerData.metadata["thirst"] ~= nil and PlayerData.metadata["thirst"] or 100
    PlayerData.metadata["stamina"] = PlayerData.metadata["stamina"] ~= nil and PlayerData.metadata["stamina"] or 100
    PlayerData.metadata["stress"] = PlayerData.metadata["stress"] ~= nil and PlayerData.metadata["stress"] or 0
    PlayerData.metadata["alcohol"] = PlayerData.metadata["alcohol"] ~= nil and PlayerData.metadata["alcohol"] or 0
	PlayerData.metadata["adrenaline"] = PlayerData.metadata["adrenaline"] ~= nil and PlayerData.metadata["adrenaline"] or 0
	PlayerData.metadata["isdead"] = PlayerData.metadata["isdead"] ~= nil and PlayerData.metadata["isdead"] or false
	PlayerData.metadata["medicalstate"] = PlayerData.metadata["medicalstate"] ~= nil and PlayerData.metadata["medicalstate"] or false
    --DNA
	PlayerData.metadata["bloodtype"] = PlayerData.metadata["bloodtype"] ~= nil and PlayerData.metadata["bloodtype"] or HDCore.Config.Player.Bloodtypes[math.random(1, #HDCore.Config.Player.Bloodtypes)]
	PlayerData.metadata["fingerprint"] = PlayerData.metadata["fingerprint"] ~= nil and PlayerData.metadata["fingerprint"] or HDCore.Player.CreateDnaId('finger')
	PlayerData.metadata["slimecode"] = PlayerData.metadata["slimecode"] ~= nil and PlayerData.metadata["slimecode"] or HDCore.Player.CreateDnaId('slime')
    PlayerData.metadata["haircode"] = PlayerData.metadata["haircode"] ~= nil and PlayerData.metadata["haircode"] or HDCore.Player.CreateDnaId('hair')
    --Reputations
    PlayerData.metadata["dealerrep"] = PlayerData.metadata["dealerrep"] ~= nil and PlayerData.metadata["dealerrep"] or 0
	PlayerData.metadata["craftingrep"] = PlayerData.metadata["craftingrep"] ~= nil and PlayerData.metadata["craftingrep"] or 0
	PlayerData.metadata["attachmentcraftingrep"] = PlayerData.metadata["attachmentcraftingrep"] ~= nil and PlayerData.metadata["attachmentcraftingrep"] or 0
	--Work Shizzle
	PlayerData.metadata["jailitems"] = PlayerData.metadata["jailitems"] ~= nil and PlayerData.metadata["jailitems"] or {}
	PlayerData.metadata["dienstnummer"] = PlayerData.metadata["dienstnummer"] ~= nil and PlayerData.metadata["dienstnummer"] or "Geen dienstnummer"
	PlayerData.metadata["duty-vehicles"] = PlayerData.metadata["duty-vehicles"] ~= nil and PlayerData.metadata["duty-vehicles"] or {Standard = false, Audi = false, Unmarked = false, Motor = false, Heli = false, DSU = false}
	PlayerData.metadata["leidinggevende"] = PlayerData.metadata["leidinggevende"] ~= nil and PlayerData.metadata["leidinggevende"] or false
	--Appartment \\ 
	PlayerData.metadata["appartment-tier"] = PlayerData.metadata["appartment-tier"] ~= nil and PlayerData.metadata["appartment-tier"] or math.random(1,2)
	PlayerData.metadata["appartment-data"] = PlayerData.metadata["appartment-data"] ~= nil and PlayerData.metadata["appartment-data"] or {Id = HDCore.Player.CreateAppartmentId(), Name = nil}
	PlayerData.metadata["phone"] = PlayerData.metadata["phone"] ~= nil and PlayerData.metadata["phone"] or {}
	-- rep
	PlayerData.metadata["lockpickrep"] = PlayerData.metadata["lockpickrep"] ~= nil and PlayerData.metadata["lockpickrep"] or 0
	PlayerData.metadata["hackrep"] = PlayerData.metadata["hackrep"] ~= nil and PlayerData.metadata["hackrep"] or 0
	PlayerData.metadata["geduldrep"] = PlayerData.metadata["geduldrep"] ~= nil and PlayerData.metadata["geduldrep"] or 0
	PlayerData.metadata["scraprep"] = PlayerData.metadata["scraprep"] ~= nil and PlayerData.metadata["scraprep"] or 0
	PlayerData.metadata["ovrep"] = PlayerData.metadata["ovrep"] ~= nil and PlayerData.metadata["ovrep"] or 0
	PlayerData.metadata["plantagerep"] = PlayerData.metadata["plantagerep"] ~= nil and PlayerData.metadata["plantagerep"] or 0
	PlayerData.metadata["visrep"] = PlayerData.metadata["visrep"] ~= nil and PlayerData.metadata["visrep"] or 0

	-- PlayerData.metadata["levels"] = PlayerData.metadata["levels"] ~= nil and PlayerData.metadata["levels"] or {
	-- 	["ovrep"] = 0,
	-- 	["hackrep"] = 0,
	-- 	["scraprep"] = 0,
	-- 	["geduldrep"] = 0,
	-- }
	PlayerData.job = PlayerData.job ~= nil and PlayerData.job or {}
	PlayerData.job.name = PlayerData.job.name ~= nil and PlayerData.job.name or "unemployed"
	PlayerData.job.label = PlayerData.job.label ~= nil and PlayerData.job.label or "Unemployed"
	PlayerData.job.payment = PlayerData.job.payment ~= nil and PlayerData.job.payment or 10
	PlayerData.job.grade = PlayerData.job.grade ~= nil and PlayerData.job.grade or {}
	PlayerData.job.grade.name = PlayerData.job.grade.name ~= nil and PlayerData.job.grade.name or nil
	PlayerData.job.grade.level = PlayerData.job.grade.level ~= nil and PlayerData.job.grade.level or 0
	PlayerData.job.plate = PlayerData.job.plate ~= nil and PlayerData.job.plate or 'none'
	PlayerData.job.serial = PlayerData.job.serial ~= nil and PlayerData.job.serial or HDCore.Player.CreateWeaponSerial()
	PlayerData.job.isboss = PlayerData.job.isboss ~= nil and PlayerData.job.isboss or false
	

    PlayerData.metadata["gang"] = PlayerData.metadata["gang"] ~= nil and PlayerData.metadata["gang"] or 'none'
	--Miscs
	PlayerData.metadata["tracker"] = PlayerData.metadata["tracker"] ~= nil and PlayerData.metadata["tracker"] or false
    PlayerData.metadata["ishandcuffed"] = PlayerData.metadata["ishandcuffed"] ~= nil and PlayerData.metadata["ishandcuffed"] or false
    --PlayerData.metadata["jail"] = PlayerData.metadata["jail"] ~= nil and PlayerData.metadata["jail"] or {Injail = false, Time = 0}
	PlayerData.metadata["jailtime"] = PlayerData.metadata["jailtime"] ~= nil and PlayerData.metadata["jailtime"] or 0
	PlayerData.metadata["favofrequentie"] = PlayerData.metadata["favofrequentie"] ~= nil and PlayerData.metadata["favofrequentie"] or 0
    PlayerData.metadata["commandbinds"] = PlayerData.metadata["commandbinds"] ~= nil and PlayerData.metadata["commandbinds"] or {}
    PlayerData.metadata["licences"] = PlayerData.metadata["licences"] ~= nil and PlayerData.metadata["licences"] or {["driver"] = true}
    --Position
	PlayerData.position = PlayerData.position ~= nil and PlayerData.position or {}
	PlayerData = HDCore.Player.LoadInventory(PlayerData)
	HDCore.Player.CreatePlayer(PlayerData)
end

HDCore.Player.CreatePlayer = function(PlayerData)
	local self = {}
	self.Functions = {}
	self.PlayerData = PlayerData

	self.Functions.UpdatePlayerData = function()
		TriggerClientEvent("HDCore:Player:SetPlayerData", self.PlayerData.source, self.PlayerData)
		HDCore.Commands.Refresh(self.PlayerData.source)
	end

	--self.Functions.SetJob = function(job)
	self.Functions.SetJob = function(job, grade)
		local job = job:lower()
		local grade = tostring(grade)
		--if HDCore.Shared.Jobs[job] ~= nil then
		if HDCore.Shared.Jobs[job] ~= nil and HDCore.Shared.Jobs[job].grades[grade] then
			self.PlayerData.job.name = job
			self.PlayerData.job.label = HDCore.Shared.Jobs[job].label
			self.PlayerData.job.payment = HDCore.Shared.Jobs[job].payment
			self.PlayerData.job.onduty = HDCore.Shared.Jobs[job].defaultDuty

			
			local jobgrade = HDCore.Shared.Jobs[job].grades[grade]
			self.PlayerData.job.grade = {}
			self.PlayerData.job.grade.name = jobgrade.name
			self.PlayerData.job.grade.level = tonumber(grade)
			self.PlayerData.job.payment = jobgrade.payment ~= nil and jobgrade.payment or 30
			self.PlayerData.job.isboss = jobgrade.isboss ~= nil and jobgrade.isboss or false

			self.Functions.UpdatePlayerData()
			TriggerClientEvent("HDCore:Client:OnJobUpdate", self.PlayerData.source, self.PlayerData.job)
			return true
		end
	end
	
	self.Functions.SetBoss = function(boo)
		self.PlayerData.job.isboss = boo
        self.Functions.UpdatePlayerData()
        TriggerClientEvent("HDCore:Client:OnJobUpdate", self.PlayerData.source, self.PlayerData.job)
	end

	self.Functions.SetJobDuty = function(onDuty)
		self.PlayerData.job.onduty = onDuty
		self.Functions.UpdatePlayerData()
	end

	self.Functions.SetDutyPlate = function(Plate)
		self.PlayerData.job.plate = Plate
		self.Functions.UpdatePlayerData()
	end

	self.Functions.SetMetaData = function(meta, val)
		local meta = meta:lower()
		if val ~= nil then
			self.PlayerData.metadata[meta] = val
			self.Functions.UpdatePlayerData()
		end
	end

	self.Functions.AddMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unknown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if self.PlayerData.money[moneytype] ~= nil then
			self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype]+amount
			self.Functions.UpdatePlayerData()
			if amount > 50000 then
				TriggerEvent("HD-logs:server:SendLog", "playermoney", "AddMoney", "lightgreen", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** ???"..amount .. " ("..moneytype..") added, new "..moneytype.." balans: "..self.PlayerData.money[moneytype], true)
			else
				TriggerEvent("HD-logs:server:SendLog", "playermoney", "AddMoney", "lightgreen", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** ???"..amount .. " ("..moneytype..") added, new "..moneytype.." balans: "..self.PlayerData.money[moneytype])
			end
			TriggerClientEvent("HD-hud:client:money:change", self.PlayerData.source, moneytype, amount, false)
			return true
		end
		return false
	end

	self.Functions.RemoveMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unknown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if self.PlayerData.money[moneytype] ~= nil then
			for _, mtype in pairs(HDCore.Config.Money.DontAllowMinus) do
				if mtype == moneytype then
					if self.PlayerData.money[moneytype] - amount < 0 then return false end
				end
			end
			self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount
			self.Functions.UpdatePlayerData()
			if amount > 100000 then
				TriggerEvent("HD-logs:server:SendLog", "playermoney", "RemoveMoney", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** ???"..amount .. " ("..moneytype..") eraf, new "..moneytype.." balans: "..self.PlayerData.money[moneytype], true)
			else
				TriggerEvent("HD-logs:server:SendLog", "playermoney", "RemoveMoney", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** ???"..amount .. " ("..moneytype..") eraf, new "..moneytype.." balans: "..self.PlayerData.money[moneytype])
			end
			TriggerClientEvent("HD-hud:client:money:change", self.PlayerData.source, moneytype, amount, true)
			return true
		end
		return false
	end

	self.Functions.SetMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unknown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if self.PlayerData.money[moneytype] ~= nil then
			self.PlayerData.money[moneytype] = amount
			self.Functions.UpdatePlayerData()
			TriggerEvent("HD-logs:server:SendLog", "playermoney", "SetMoney", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** ???"..amount .. " ("..moneytype..") gezet, new "..moneytype.." balans: "..self.PlayerData.money[moneytype])
			return true
		end
		return false
	end

	self.Functions.AddItem = function(item, amount, slot, info)
		local totalWeight = HDCore.Player.GetTotalWeight(self.PlayerData.items)
		local itemInfo = HDCore.Shared.Items[item:lower()]
		if itemInfo == nil then TriggerClientEvent('chatMessage', -1, "SYSTEM",  "warning", "Geen artikel gevonden?? Controleer de Core! Ontbrekend item: " .. itemInfo .."") return end
		local amount = tonumber(amount)
		local slot = tonumber(slot) ~= nil and tonumber(slot) or HDCore.Player.GetFirstSlotByItem(self.PlayerData.items, item)
		if itemInfo["type"] == "weapon" and info == nil then
			info = {
				serie = tostring(HDCore.Shared.RandomInt(2) .. HDCore.Shared.RandomStr(3) .. HDCore.Shared.RandomInt(1) .. HDCore.Shared.RandomStr(2) .. HDCore.Shared.RandomInt(3) .. HDCore.Shared.RandomStr(4)),
			}
		end
		if (totalWeight + (itemInfo["weight"] * amount)) <= HDCore.Config.Player.MaxWeight then
			if (slot ~= nil and self.PlayerData.items[slot] ~= nil) and (self.PlayerData.items[slot].name:lower() == item:lower()) and (itemInfo["type"] == "item" and not itemInfo["unique"]) then
				self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount + amount
				self.Functions.UpdatePlayerData()
				TriggerEvent("HD-logs:server:SendLog", "playerinventory", "AddItem", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** recieved item: [slot:" ..slot.."], itemname: " .. self.PlayerData.items[slot].name .. ", added amount: " .. amount ..", new total amount: ".. self.PlayerData.items[slot].amount)
				return true
			elseif (not itemInfo["unique"] and slot or slot ~= nil and self.PlayerData.items[slot] == nil) then
				self.PlayerData.items[slot] = {name = itemInfo["name"], amount = amount, info = info ~= nil and info or "", label = itemInfo["label"], description = itemInfo["description"] ~= nil and itemInfo["description"] or "", weight = itemInfo["weight"], type = itemInfo["type"], unique = itemInfo["unique"], useable = itemInfo["useable"], image = itemInfo["image"], shouldClose = itemInfo["shouldClose"], slot = slot, combinable = itemInfo["combinable"]}
				self.Functions.UpdatePlayerData()
				TriggerEvent("HD-logs:server:SendLog", "playerinventory", "AddItem", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** recieved item: [slot:" ..slot.."], itemname: " .. self.PlayerData.items[slot].name .. ", added amount: " .. amount ..", new total amount: ".. self.PlayerData.items[slot].amount)
				return true
			elseif (itemInfo["unique"]) or (not slot or slot == nil) or (itemInfo["type"] == "weapon") then
				for i = 1, Config.Player.MaxInvSlots , 1 do
					if self.PlayerData.items[i] == nil then
						self.PlayerData.items[i] = {name = itemInfo["name"], amount = amount, info = info ~= nil and info or "", label = itemInfo["label"], description = itemInfo["description"] ~= nil and itemInfo["description"] or "", weight = itemInfo["weight"], type = itemInfo["type"], unique = itemInfo["unique"], useable = itemInfo["useable"], image = itemInfo["image"], shouldClose = itemInfo["shouldClose"], slot = i, combinable = itemInfo["combinable"]}
						self.Functions.UpdatePlayerData()
						TriggerEvent("HD-logs:server:SendLog", "playerinventory", "AddItem", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** recieved item: [slot:" ..i.."], itemname: " .. self.PlayerData.items[i].name .. ", added amount: " .. amount ..", new total amount: ".. self.PlayerData.items[i].amount)
						return true
					end
				end
			end
		end
		return false
	end

	self.Functions.RemoveItem = function(item, amount, slot)
		local itemInfo = HDCore.Shared.Items[item:lower()]
		local amount = tonumber(amount)
		local slot = tonumber(slot)
		if slot ~= nil then
			if self.PlayerData.items[slot].amount > amount then
				self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount - amount
				self.Functions.UpdatePlayerData()
				TriggerEvent("HD-logs:server:SendLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** loses item: [slot:" ..slot.."], itemname: " .. self.PlayerData.items[slot].name .. ", removed amount: " .. amount ..", new total amount: ".. self.PlayerData.items[slot].amount)
				return true
			else
				self.PlayerData.items[slot] = nil
				self.Functions.UpdatePlayerData()
				TriggerEvent("HD-logs:server:SendLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** loses item: [slot:" ..slot.."], itemname: " .. item .. ", removed amount: " .. amount ..", item removed")
				return true
			end
		else
			local slots = HDCore.Player.GetSlotsByItem(self.PlayerData.items, item)
			local amountToRemove = amount
			if slots ~= nil then
				for _, slot in pairs(slots) do
					if self.PlayerData.items[slot].amount > amountToRemove then
						self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount - amountToRemove
						self.Functions.UpdatePlayerData()
						TriggerEvent("HD-logs:server:SendLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** loses item: [slot:" ..slot.."], itemname: " .. self.PlayerData.items[slot].name .. ", removed amount: " .. amount ..", new total amount: ".. self.PlayerData.items[slot].amount)
						return true
					elseif self.PlayerData.items[slot].amount == amountToRemove then
						self.PlayerData.items[slot] = nil
						self.Functions.UpdatePlayerData()
						TriggerEvent("HD-logs:server:SendLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** loses item: [slot:" ..slot.."], itemname: " .. item .. ", removed amount: " .. amount ..", item removed")
						return true
					end
				end
			end
		end
		return false
	end

	self.Functions.SetInventory = function(items)
		self.PlayerData.items = items
		self.Functions.UpdatePlayerData()
		TriggerEvent("HD-logs:server:SendLog", "playerinventory", "SetInventory", "blue", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** items set: " .. json.encode(items))
	end

	self.Functions.ClearInventory = function()
		self.PlayerData.items = {}
		self.Functions.UpdatePlayerData()
		TriggerEvent("HD-logs:server:SendLog", "playerinventory", "ClearInventory", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** inventory cleared")
	end

	self.Functions.GetItemByName = function(item)
		local item = tostring(item):lower()
		local slot = HDCore.Player.GetFirstSlotByItem(self.PlayerData.items, item)
		if slot ~= nil then
			return self.PlayerData.items[slot]
		end
		return nil
	end

	self.Functions.GetItemBySlot = function(slot)
		local slot = tonumber(slot)
		if self.PlayerData.items[slot] ~= nil then
			return self.PlayerData.items[slot]
		end
		return nil
	end

	self.Functions.Save = function()
		HDCore.Player.Save(self.PlayerData.source)
	end
	
	HDCore.Players[self.PlayerData.source] = self
	HDCore.Player.Save(self.PlayerData.source)
	self.Functions.UpdatePlayerData()
end

HDCore.Player.Save = function(source)
	local PlayerData = HDCore.Players[source].PlayerData
	if PlayerData ~= nil then
		HDCore.Functions.ExecuteSql(true, "SELECT * FROM `player_metadata` WHERE `citizenid` = '"..PlayerData.citizenid.."'", function(result)
			if result[1] == nil then
				HDCore.Functions.ExecuteSql(true, "INSERT INTO `player_metadata` (`citizenid`, `cid`, `steam`, `license`, `name`, `money`, `charinfo`, `position`, `job`, `gang`, `globals`) VALUES ('"..PlayerData.citizenid.."', '"..tonumber(PlayerData.cid).."', '"..PlayerData.steam.."', '"..PlayerData.license.."', '"..PlayerData.name.."', '"..json.encode(PlayerData.money).."', '"..HDCore.EscapeSqli(json.encode(PlayerData.charinfo)).."', '"..json.encode(PlayerData.position).."', '"..json.encode(PlayerData.job).."', '"..json.encode(PlayerData.gang).."' ,'"..json.encode(PlayerData.metadata).."')")
			else
				HDCore.Functions.ExecuteSql(true, "UPDATE `player_metadata` SET steam='"..PlayerData.steam.."', name='"..HDCore.EscapeSqli(PlayerData.name).."', money='"..HDCore.EscapeSqli(json.encode(PlayerData.money)).."',charinfo='"..HDCore.EscapeSqli(json.encode(PlayerData.charinfo)).."',position='"..HDCore.EscapeSqli(json.encode(PlayerData.position)).."',job='"..HDCore.EscapeSqli(json.encode(PlayerData.job)).."' ,globals='"..HDCore.EscapeSqli(json.encode(PlayerData.metadata)).."' WHERE `citizenid` = '"..PlayerData.citizenid.."'")
			end
			HDCore.Player.SaveInventory(source)
		end)
		HDCore.ShowSuccess(GetCurrentResourceName(), PlayerData.name .." PLAYER SAVED!")
	else
		print('SAVE DATA ERROR - NILL')
	end
end

HDCore.Player.Logout = function(source)
	local Player = HDCore.Functions.GetPlayer(source)
	TriggerClientEvent('HDCore:Client:OnPlayerUnload', source)
	TriggerClientEvent("HDCore:Player:UpdatePlayerData", source)
	Player.Functions.Save()
	Citizen.Wait(200)
	HDCore.Players[source] = nil
end

HDCore.Player.DeleteCharacter = function(source, citizenid)
	HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_metadata` WHERE `citizenid` = '"..HDCore.EscapeSqli(citizenid).."'", function(result)
	  if result[1] ~= nil then
		  if result[1].steam == GetPlayerIdentifiers(source)[1] then
			 HDCore.Functions.ExecuteSql(true, "DELETE FROM `player_metadata` WHERE `citizenid` = '"..citizenid.."'")
			 TriggerClientEvent('HD-multicharacter:client:chooseChar', source)
			 TriggerEvent("HD-logs:server:SendLog", "joinleave", "Character Deleted", "red", "**".. GetPlayerName(source) .. "** ("..GetPlayerIdentifiers(source)[1]..") deleted **"..citizenid.."**..")
		  else
			  TriggerClientEvent('HD-multicharacter:client:chooseChar', source)
			  TriggerEvent("HD-logs:server:SendLog", "joinleave", "Character Cheats", "red", GetPlayerName(source) .." tries to remove char "..citizenid.." which is not his..", true)
		  end
	  else
		  TriggerClientEvent('HD-multicharacter:client:chooseChar', source)
		  TriggerEvent("HD-logs:server:SendLog", "joinleave", "Character Cheats", "red", GetPlayerName(source) .." tries to remove char "..citizenid.." which is not his..", true)
	  end
	end)
  end
HDCore.Player.LoadInventory = function(PlayerData)
	PlayerData.items = {}
		HDCore.Functions.ExecuteSql(true, "SELECT * FROM `player_metadata` WHERE `citizenid` = '"..PlayerData.citizenid.."'", function(result)
			if result[1] ~= nil then 
				if result[1].inventory ~= nil then
					plyInventory = json.decode(result[1].inventory)
					if next(plyInventory) ~= nil then 
						for _, item in pairs(plyInventory) do
							if item ~= nil then
								local itemInfo = HDCore.Shared.Items[item.name:lower()]
								PlayerData.items[item.slot] = {
									name = itemInfo["name"], 
									amount = item.amount, 
									info = item.info ~= nil and item.info or "", 
									label = itemInfo["label"], 
									description = itemInfo["description"] ~= nil and itemInfo["description"] or "", 
									weight = itemInfo["weight"], 
									type = itemInfo["type"], 
									unique = itemInfo["unique"], 
									useable = itemInfo["useable"], 
									image = itemInfo["image"], 
									shouldClose = itemInfo["shouldClose"], 
									slot = item.slot, 
									combinable = itemInfo["combinable"]
								}
							end
						end
					end
				end
			end
		end)
	return PlayerData
end

HDCore.Player.SaveInventory = function(source)
	if HDCore.Players[source] ~= nil then 
		local PlayerData = HDCore.Players[source].PlayerData
		local items = PlayerData.items
		local ItemsJson = {}
		if items ~= nil and next(items) ~= nil then
			for slot, item in pairs(items) do
				if items[slot] ~= nil then
					table.insert(ItemsJson, {
						name = item.name,
						amount = item.amount,
						info = item.info,
						type = item.type,
						slot = slot,
					})
				end
			end
			HDCore.Functions.ExecuteSql(true, "UPDATE `player_metadata` SET `inventory` = '"..HDCore.EscapeSqli(json.encode(ItemsJson)).."' WHERE `citizenid` = '"..PlayerData.citizenid.."'")
		end
	end
end

HDCore.Player.GetTotalWeight = function(items)
	local weight = 0
	if items ~= nil then
		for slot, item in pairs(items) do
			weight = weight + (item.weight * item.amount)
		end
	end
	return tonumber(weight)
end

HDCore.Player.GetSlotsByItem = function(items, itemName)
	local slotsFound = {}
	if items ~= nil then
		for slot, item in pairs(items) do
			if item.name:lower() == itemName:lower() then
				table.insert(slotsFound, slot)
			end
		end
	end
	return slotsFound
end

HDCore.Player.GetFirstSlotByItem = function(items, itemName)
	if items ~= nil then
		for slot, item in pairs(items) do
			if item.name:lower() == itemName:lower() then
				return tonumber(slot)
			end
		end
	end
	return nil
end

HDCore.Player.CreateCitizenId = function()
	local UniqueFound = false
	local CitizenId = nil
	while not UniqueFound do
		CitizenId = tostring(HDCore.Shared.RandomStr(3) .. HDCore.Shared.RandomInt(5)):upper()
		HDCore.Functions.ExecuteSql(true, "SELECT COUNT(*) as count FROM `player_metadata` WHERE `citizenid` = '"..CitizenId.."'", function(result)
            if result[1].count == 0 then
				UniqueFound = true
			end
		end)
	end
	return CitizenId
end

HDCore.Player.CreateDnaId = function(Type)
    local DnaId = {}
    if Type == 'finger' then
        DnaId = tostring('F'..HDCore.Shared.RandomStr(3) .. HDCore.Shared.RandomInt(3):upper() .. HDCore.Shared.RandomStr(1) .. HDCore.Shared.RandomInt(2) .. HDCore.Shared.RandomStr(3) .. HDCore.Shared.RandomInt(4):upper())
    elseif Type == 'slime' then
        DnaId = tostring('S'..HDCore.Shared.RandomStr(2) .. HDCore.Shared.RandomInt(3) .. HDCore.Shared.RandomStr(2) .. HDCore.Shared.RandomInt(2):upper() .. HDCore.Shared.RandomStr(3) .. HDCore.Shared.RandomInt(4))
    elseif Type == 'hair' then
        DnaId = tostring('H'..HDCore.Shared.RandomStr(2) .. HDCore.Shared.RandomInt(3) .. HDCore.Shared.RandomStr(3) .. HDCore.Shared.RandomInt(2) .. HDCore.Shared.RandomStr(3) .. HDCore.Shared.RandomInt(4):upper())
    end 
    return DnaId
end

HDCore.Player.CreateWeaponSerial = function()
	local Serial =  HDCore.Shared.RandomStr(2)..HDCore.Shared.RandomInt(3):upper()..HDCore.Shared.RandomStr(3)..HDCore.Shared.RandomInt(3):upper()..HDCore.Shared.RandomStr(2)..HDCore.Shared.RandomInt(3):upper()
	return Serial
end

HDCore.Player.CreateAppartmentId = function()
	local AppartmentId =  HDCore.Shared.RandomStr(2)..HDCore.Shared.RandomInt(2):upper()..'Appartment'..HDCore.Shared.RandomStr(2)..HDCore.Shared.RandomInt(2):lower()
	return AppartmentId
end

HDCore.EscapeSqli = function(str)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return str:gsub( "['\"]", replacements)
end