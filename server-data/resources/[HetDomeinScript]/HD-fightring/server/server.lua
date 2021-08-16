local bluePlayerReady = false
local redPlayerReady = false
local fight = {}

HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

RegisterServerEvent('HD-fight:join')
AddEventHandler('HD-fight:join', function(betAmount, side)
		local src = source
		local xPlayer = HDCore.Functions.GetPlayer(src)

		if side == 0 then
			bluePlayerReady = true
		else
			redPlayerReady = true
		end

        local fighter = {
            id = source,
            amount = betAmount
        }
        table.insert(fight, fighter)

		balance = xPlayer.PlayerData.money["cash"]
        if (balance > betAmount) or betAmount == 0 then
		xPlayer.Functions.RemoveMoney("cash", betAmount, "fightring")

            if side == 0 then
                TriggerClientEvent('HD-fight:playerJoined', -1, 1, source)
            else
                TriggerClientEvent('HD-fight:playerJoined', -1, 2, source)
            end

            if redPlayerReady and bluePlayerReady then 
                TriggerClientEvent('HD-fight:startFight', -1, fight)
            end

        else
        end
end)

local count = 240
local actualCount = 0
function countdown(copyFight)
    for i = count, 0, -1 do
        actualCount = i
        Citizen.Wait(1000)
    end

    if copyFight == fight then
        TriggerClientEvent('HD-fight:fightFinished', -1, -2)
        fight = {}
        bluePlayerReady = false
        redPlayerReady = false
    end
end

RegisterServerEvent('HD-fight:finishFight')
AddEventHandler('HD-fight:finishFight', function(looser)
       TriggerClientEvent('HD-fight:fightFinished', -1, looser)
       fight = {}
       bluePlayerReady = false
       redPlayerReady = false
end)

RegisterServerEvent('HD-fight:leaveFight')
AddEventHandler('HD-fight:leaveFight', function(id)
       if bluePlayerReady or redPlayerReady then
            bluePlayerReady = false
            redPlayerReady = false
            fight = {}
            TriggerClientEvent('HD-fight:playerLeaveFight', -1, id)
       end
end)

RegisterServerEvent('HD-fight:pay')
AddEventHandler('HD-fight:pay', function(amount)
	local src = source
    local xPlayer = HDCore.Functions.GetPlayer(src)
end)

RegisterServerEvent('HD-fight:raiseBet')
AddEventHandler('HD-fight:raiseBet', function(looser)
       TriggerClientEvent('HD-fight:raiseActualBet', -1)
end)

RegisterServerEvent('HD-fight:showWinner')
AddEventHandler('HD-fight:showWinner', function(id)
       TriggerClientEvent('HD-fight:winnerText', -1, id)
end)