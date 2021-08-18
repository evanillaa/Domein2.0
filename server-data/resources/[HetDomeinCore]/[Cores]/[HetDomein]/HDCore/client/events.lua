-- // Register Player Data in client \\ --
RegisterNetEvent('HDCore:Player:SetPlayerData')
AddEventHandler('HDCore:Player:SetPlayerData', function(val)
	HDCore.PlayerData = val
end)

RegisterNetEvent('HDCore:Player:UpdatePlayerData')
AddEventHandler('HDCore:Player:UpdatePlayerData', function()
	local data = {}
	data.position = HDCore.Functions.GetCoords(PlayerPedId())
	TriggerServerEvent('HDCore:UpdatePlayer', data)
end)

RegisterNetEvent('HDCore:Player:Salary')
AddEventHandler('HDCore:Player:Salary', function()
	TriggerServerEvent('HDCore:Salary')
end)

-- // HDCore Command Events \\ --

RegisterNetEvent('HDCore:Command:TeleportToPlayer')
AddEventHandler('HDCore:Command:TeleportToPlayer', function(othersource)
	local coords = HDCore.Functions.GetCoords(GetPlayerPed(GetPlayerFromServerId(othersource)))
	local entity = PlayerPedId()
	if IsPedInAnyVehicle(entity, false) then
		entity = GetVehiclePedIsUsing(entity)
	end
	SetEntityCoords(entity, coords.x, coords.y, coords.z)
	SetEntityHeading(entity, coords.a)
end)

RegisterNetEvent('HDCore:Command:TeleportToCoords')
AddEventHandler('HDCore:Command:TeleportToCoords', function(x, y, z)
	local entity = PlayerPedId()
	if IsPedInAnyVehicle(entity, false) then
		entity = GetVehiclePedIsUsing(entity)
	end
	SetEntityCoords(entity, x, y, z)
end)

RegisterNetEvent('HDCore:Command:SpawnVehicle')
AddEventHandler('HDCore:Command:SpawnVehicle', function(model)
	HDCore.Functions.SpawnVehicle(model, function(vehicle)
	 TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
	 exports['HD-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(vehicle), true)
	 Citizen.Wait(100)
	 exports['HD-fuel']:SetFuelLevel(vehicle, GetVehicleNumberPlateText(vehicle), 100, true)
	 HDCore.Functions.Notify('Succesvol voertuig ingespawned!', 'success')
	end, nil, true, true)
end)

RegisterNetEvent('HDCore:Command:DeleteVehicle')
AddEventHandler('HDCore:Command:DeleteVehicle', function()
	if IsPedInAnyVehicle(PlayerPedId()) then
		HDCore.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
	else
		local vehicle = HDCore.Functions.GetClosestVehicle()
		HDCore.Functions.DeleteVehicle(vehicle)
	end
	HDCore.Functions.Notify('Succesvol voertuig verwijderd!', 'error')
end)

RegisterNetEvent('HDCore:Command:Revive')
AddEventHandler('HDCore:Command:Revive', function()
	local coords = HDCore.Functions.GetCoords(PlayerPedId())
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z+0.2, coords.a, true, false)
	SetPlayerInvincible(PlayerPedId(), false)
	ClearPedBloodDamage(PlayerPedId())
end)

RegisterNetEvent('HDCore:Command:GoToMarker')
AddEventHandler('HDCore:Command:GoToMarker', function()
	Citizen.CreateThread(function()
		local entity = PlayerPedId()
		if IsPedInAnyVehicle(entity, false) then
			entity = GetVehiclePedIsUsing(entity)
		end
		local success = false
		local blipFound = false
		local blipIterator = GetBlipInfoIdIterator()
		local blip = GetFirstBlipInfoId(8)

		while DoesBlipExist(blip) do
			if GetBlipInfoIdType(blip) == 4 then
				cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector())) --GetBlipInfoIdCoord(blip)
				blipFound = true
				break
			end
			blip = GetNextBlipInfoId(blipIterator)
		end

		if blipFound then
			DoScreenFadeOut(250)
			while IsScreenFadedOut() do
				Citizen.Wait(250)
			end
			local groundFound = false
			local yaw = GetEntityHeading(entity)
			
			for i = 0, 1000, 1 do
				SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
				SetEntityRotation(entity, 0, 0, 0, 0 ,0)
				SetEntityHeading(entity, yaw)
				SetGameplayCamRelativeHeading(0)
				Citizen.Wait(0)
				--groundFound = true
				if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then --GetGroundZFor3dCoord(cx, cy, i, 0, 0) GetGroundZFor_3dCoord(cx, cy, i)
					cz = ToFloat(i)
					groundFound = true
					break
				end
			end
			if not groundFound then
				cz = -300.0
			end
			success = true
		end

		if success then
			SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
			SetGameplayCamRelativeHeading(0)
			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
					SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
				end
			end
			DoScreenFadeIn(250)
		end
	end)
end)

-- Other stuff
RegisterNetEvent('HDCore:Client:LocalOutOfCharacter')
AddEventHandler('HDCore:Client:LocalOutOfCharacter', function(playerId, playerName, message)
	local sourcePos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerId)), false)
    local pos = GetEntityCoords(PlayerPedId(), false)
    if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < 20.0) then
	--if #(pos - sourcePos) < 5
		TriggerEvent("chatMessage", "OOC | " .. playerName, "normal", message)
    end
end)

RegisterNetEvent('HDCore:Notify')
AddEventHandler('HDCore:Notify', function(text, type, length)
	HDCore.Functions.Notify(text, type, length)
end)

RegisterNetEvent('HDCore:client:closenui')
AddEventHandler('HDCore:client:closenui', function()
	SetNuiFocus(false, false)
end)

RegisterNetEvent('HDCore:client:opennui')
AddEventHandler('HDCore:client:opennui', function()
	SetNuiFocus(true, true)
end)
RegisterNUICallback("devtoolOpening", function()
    TriggerServerEvent("DevMode")
end)

RegisterNetEvent('HDCore:Client:TriggerCallback')
AddEventHandler('HDCore:Client:TriggerCallback', function(name, ...)
	if HDCore.ServerCallbacks[name] ~= nil then
		HDCore.ServerCallbacks[name](...)
		HDCore.ServerCallbacks[name] = nil
	end
end)

RegisterNetEvent("HDCore:Client:UseItem")
AddEventHandler('HDCore:Client:UseItem', function(item)
	TriggerServerEvent("HDCore:Server:UseItem", item)
end)