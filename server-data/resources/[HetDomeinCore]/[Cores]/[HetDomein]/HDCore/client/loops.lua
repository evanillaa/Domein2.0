Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if NetworkIsSessionStarted() then
			Citizen.Wait(10)
			TriggerServerEvent('HDCore:PlayerJoined')
			return
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if isLoggedIn then
			Citizen.Wait((1000 * 20) * 7)
			TriggerEvent("HDCore:Player:UpdatePlayerData")
		else
			Citizen.Wait(5000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if isLoggedIn then
			Citizen.Wait((1000 * 90) * 10)
			TriggerEvent("HDCore:Player:Salary")
		else
			Citizen.Wait(5000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(7)
		if isLoggedIn then
			Citizen.Wait(30000)
			local position = HDCore.Functions.GetCoords(PlayerPedId())
			TriggerServerEvent('HDCore:UpdatePlayerPosition', position)
		else
			Citizen.Wait(5000)
		end
	end
end)

-- // Food Enz \\ --
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(math.random(3000, 5000))
		if isLoggedIn then
			if HDCore.Functions.GetPlayerData().metadata["hunger"] <= 1 or HDCore.Functions.GetPlayerData().metadata["thirst"] <= 1 then
				if not HDCore.Functions.GetPlayerData().metadata["isdead"] then
				 local CurrentHealth = GetEntityHealth(PlayerPedId())
				 SetEntityHealth(PlayerPedId(), CurrentHealth - math.random(5, 10))
				end
			end
		end
	end
end)