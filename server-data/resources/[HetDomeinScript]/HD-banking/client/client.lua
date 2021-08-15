local CanOpenBank = false
local LoggedIn = true

HDCore = nil

TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(500, function()
     TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
      Citizen.Wait(150)
      LoggedIn = true
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
         IsNearBank = false
          for k, v in pairs(Config.Banks) do
            local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
            if Distance < 2.5 then
                if v['IsOpen'] then
                    CanOpenBank = true
                    --DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 48, 255, 58, 255, false, false, false, 1, false, false, false)
                else
                    CanOpenBank = false
                    --DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 72, 48, 255, false, false, false, 1, false, false, false)
                end
                IsNearBank = true
            end
          end
          if not IsNearBank then
            CanOpenBank = false
            Citizen.Wait(1500)
          end
        end
    end
end)

RegisterNetEvent('HD-banking:client:open:bank')
AddEventHandler('HD-banking:client:open:bank', function()
    Citizen.SetTimeout(450, function()
        OpenBank(true)
    end)
end)

RegisterNetEvent('HD-banking:client:open:atm')
AddEventHandler('HD-banking:client:open:atm', function()
    Citizen.SetTimeout(450, function()
        OpenBank(false)
    end)
end)

RegisterNetEvent('HD-banking:client:claim:paycheck')
AddEventHandler('HD-banking:client:claim:paycheck', function()
    HDCore.Functions.TriggerCallback('HDCore:HasItem', function(HasItem)
        if HasItem then
            ClaimPaycheck()
        else
            HDCore.Functions.Notify('Je hebt geen loonstrook..', 'error')
        end
    end, "paycheck")
end)

RegisterNUICallback('ClickSound', function(data)
    if data.success == 'bank-error' then
     PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
    elseif data.success == 'click' then
     PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
    else
     TriggerEvent("HD-sound:client:play", data.success, 0.25)
    end
end)

RegisterNUICallback('Withdraw', function(data)
    if IsNearAnyBank() or IsNearAtm() then
      TriggerServerEvent('HD-banking:server:withdraw', data.RemoveAmount, data.BankId) 
    end
end)

RegisterNUICallback('Deposit', function(data)
    if IsNearAnyBank() then
      TriggerServerEvent('HD-banking:server:deposit', data.AddAmount, data.BankId) 
    end
end)

RegisterNUICallback('CreateAccount', function(data)
     if IsNearAnyBank() or IsNearAtm() then
       TriggerServerEvent('HD-banking:server:create:account', data.Name, data.Type)
    end
end)

RegisterNUICallback('AddUserToAccount', function(data)
     if IsNearAnyBank() or IsNearAtm() then
       TriggerServerEvent('HD-banking:server:add:user', data.BankId, data.TargetBsn)
    end
end)

RegisterNUICallback('DeleteFromAccount', function(data)
     if IsNearAnyBank() or IsNearAtm() then
       TriggerServerEvent('HD-banking:server:remove:user', data.BankId, data.TargetBsn)
     end
end)

RegisterNUICallback('DeleteAccount', function(data)
    if IsNearAnyBank() or IsNearAtm() then
        TriggerServerEvent('HD-banking:server:remove:account', data.BankId)
      end
end)

RegisterNUICallback('GetTransactions', function(data)
    if IsNearAnyBank() or IsNearAtm() then
        HDCore.Functions.TriggerCallback('HD-banking:server:get:account:transactions', function(Transactions)
         SendNUIMessage({
           action = 'SetupTransaction',
           transaction = Transactions,
         })    
        end, data.BankId)
    end
end)

RegisterNUICallback('GetPersonalBalance', function(data, cb)
    local Player = HDCore.Functions.GetPlayerData()
    local Data = {
        Balance = Player.money['bank'],
        BankId = Player.charinfo.account,
        CitizenId = Player.citizenid,
        Name = Player.charinfo.firstname..' '.. Player.charinfo.lastname,
    }
    cb(Data)
end)

RegisterNUICallback('GetSharedAccounts', function(data, cb)
    HDCore.Functions.TriggerCallback('HD-banking:server:get:shared:account', function(Accounts)
        cb(Accounts)
    end)  
end)

RegisterNUICallback('GetPrivateAcounts', function(data, cb)
    HDCore.Functions.TriggerCallback('HD-banking:server:get:private:account', function(Accounts)
        cb(Accounts)
    end)  
end)

RegisterNUICallback('CloseApp', function()
    SetNuiFocus(false, false)
    TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_atm@male@exit", "exit", 1.0, 1.0, -1, 49, 0, 0, 0, 0 )
    HDCore.Functions.Progressbar("bank", "Bankkaart Uitnemen..", 5000, false, false, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        ClearPedTasks(PlayerPedId())
    end, function()
        HDCore.Functions.Notify("Geannuleerd..", "error")
    end)
end)

RegisterNUICallback('GetAccountUsers', function(data)
    HDCore.Functions.TriggerCallback('HD-banking:server:get:account:users', function(Accounts)
        SendNUIMessage({
          action = 'SetupUsers',
          accounts = Accounts,
          citizenid = HDCore.Functions.GetPlayerData().citizenid,
        })    
    end, data.BankId)
end)

RegisterNetEvent('HD-banking:client:check:players:near')
AddEventHandler('HD-banking:client:check:players:near', function(TargetPlayer, Amount)
    local Player, Distance = HDCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 3.0 then
        if GetPlayerServerId(Player) == TargetPlayer then
            exports['HD-assets']:RequestAnimationDict('friends@laf@ig_5')
            TaskPlayAnim(PlayerPedId(), 'friends@laf@ig_5', 'nephew', 5.0, 1.0, 5.0,48, 0.0, 0, 0, 0)
            TriggerServerEvent('HD-banking:server:give:cash', TargetPlayer, Amount) 
        else
            HDCore.Functions.Notify("Dit is niet de juiste burger..", "error")
        end
    else
        HDCore.Functions.Notify("Geen burger gevonden..", "error")
    end
end)

function OpenBank(CanDeposit, UseAnim)
    exports['HD-assets']:RequestAnimationDict('amb@prop_human_atm@male@idle_a')
    exports['HD-assets']:RequestAnimationDict('amb@prop_human_atm@male@exit')
    TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_atm@male@idle_a", "idle_b", 1.0, 1.0, -1, 49, 0, 0, 0, 0 )
    HDCore.Functions.Progressbar("bank", "Bankkaart Invoeren..", 4500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'openbank',
            candeposit = CanDeposit,
            chardata = HDCore.Functions.GetPlayerData(),
        })
    end, function()
        HDCore.Functions.Notify("Geannuleerd..", "error")
    end)
end

function ClaimPaycheck(UseAnim)
    exports['HD-assets']:RequestAnimationDict('amb@prop_human_atm@male@idle_a')
    exports['HD-assets']:RequestAnimationDict('amb@prop_human_atm@male@exit')
    TaskPlayAnim(GetPlayerPed(-1), "amb@prop_human_atm@male@idle_a", "idle_b", 1.0, 1.0, -1, 49, 0, 0, 0, 0 )
    HDCore.Functions.Progressbar("claim-paycheck", "Loonstrook innen..", 4500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('HD-banking:server:claim:paycheck')
    end, function()
        HDCore.Functions.Notify("Geannuleerd..", "error")
    end)
end

function IsNearAtm()
    local PlayerCoords = GetEntityCoords(GetPlayerPed(-1))
    for k, v in pairs(Config.AtmObject) do
        local AtmObject = GetClosestObjectOfType(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 3.0, v, false, 0, 0)
        local ObjectCoords = GetEntityCoords(AtmObject)
        local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, ObjectCoords.x, ObjectCoords.y, ObjectCoords.z, true)
        if Distance < 2.0 then
            return true
        end
    end
end

function IsNearAnyBank()
    return CanOpenBank
end