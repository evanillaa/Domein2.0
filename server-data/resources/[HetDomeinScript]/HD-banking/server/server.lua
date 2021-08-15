HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

HDCore.Functions.CreateCallback("HD-banking:server:get:private:account", function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM player_accounts", function(result) 
        local AccountData = {}
        if result ~= nil then
            for k, v in pairs(result) do
                if v.type == 'private' then
                    if v.citizenid == Player.PlayerData.citizenid then
                        DatabaseData = {
                            Owner = v.citizenid,
                            Name = v.name,
                            BankId = v.bankid,
                            Balance = v.balance,
                          }
                          table.insert(AccountData, DatabaseData)
                    end
                end
            end
            cb(AccountData)
        end
    end)
end)

HDCore.Functions.CreateCallback("HD-banking:server:get:shared:account", function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    HDCore.Functions.ExecuteSql(true, "SELECT * FROM player_accounts", function(result) 
        local AccountData = {}
        if result ~= nil then
            for k, v in pairs(result) do
                if v.type == 'shared' then
                    local AuthData = json.decode(v.authorized)
                    for Auth, Authorized in pairs(AuthData) do
                        if Authorized == Player.PlayerData.citizenid then
                            DatabaseData = {
                                Owner = v.citizenid,
                                Name = v.name,
                                BankId = v.bankid,
                                Balance = v.balance,
                            }
                            table.insert(AccountData, DatabaseData)
                        end
                    end
                end
            end
            cb(AccountData)
        end
    end)
end)

HDCore.Functions.CreateCallback("HD-banking:server:get:account:users", function(source, cb, bankid)
    local Player = HDCore.Functions.GetPlayer(source)
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM player_accounts WHERE `bankid` = '"..bankid.."'", function(result) 
        local UserData = {}     
         if result ~= nil then
             for k, v in pairs(result) do 
                 local AuthorizedData = json.decode(v.authorized)
                 for Auth, Authorized in pairs(AuthorizedData) do
                     HDCore.Functions.ExecuteSql(true, "SELECT * FROM player_metadata WHERE `citizenid` = '"..Authorized.."'", function(CharResult) 
                         local DecodeCharInfo = json.decode(CharResult[1].charinfo)
                         AccountArrayData = {
                          Firstname = DecodeCharInfo.firstname,
                          Lastname = DecodeCharInfo.lastname,
                          CitizenId = Authorized,
                         }
                         table.insert(UserData, AccountArrayData)
                     end)
                 end
             end
             cb(UserData)
         end                 
    end)
end)

HDCore.Functions.CreateCallback("HD-banking:server:get:account:transactions", function(source, cb, bankid)
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM player_accounts WHERE `bankid` = '"..bankid.."'", function(result)
        local ReturnData = {}
        local TransactionData = json.decode(result[1].transactions)
         for k, v in pairs(TransactionData) do
             Transactions = {
                 Name = GetCharName(v.CitizenId),
                 Amount = v.Amount,
                 Type = v.Type,
                 CitizenId = v.CitizenId,
                 Date = v.Date,
                 Time = v.Time,
             }
             table.insert(ReturnData, Transactions)
         end
         cb(ReturnData)
    end)
end)

RegisterServerEvent('HD-banking:server:withdraw')
AddEventHandler('HD-banking:server:withdraw', function(RemoveAmount, BankId)
    local src = source
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.PlayerData.charinfo.account ~= BankId then
        local Balance = GetAccountBalance(BankId)
        local Amount = tonumber(RemoveAmount)
        local NewBalance = Balance - Amount
        if Balance >= Amount then
         Player.Functions.AddMoney('cash', Amount, 'Bank Opnemen')
         TriggerEvent('HD-banking:server:add:transaction', src, BankId, Amount, 'Remove')
         HDCore.Functions.ExecuteSql(false, "UPDATE player_accounts SET `balance` = '" .. NewBalance .. "' WHERE `bankid` = '" ..BankId.. "'")
        end
    else
        local CurrentBalance = Player.PlayerData.money['bank']
        local Amount = tonumber(RemoveAmount)
        if CurrentBalance >= Amount then
            Player.Functions.RemoveMoney('bank', Amount, 'Bank Opnemen')
            Player.Functions.AddMoney('cash', Amount, 'Bank Opnemen')
        else
            TriggerClientEvent('HD-banking:client:send:notify', source, 'Bank', 'error', 'Onvoldoende saldo..')
        end
    end
end)

RegisterServerEvent('HD-banking:server:deposit')
AddEventHandler('HD-banking:server:deposit', function(AddAmount, BankId)
    local src = source
    local Player = HDCore.Functions.GetPlayer(source)
    if Player.PlayerData.charinfo.account ~= BankId then
        local Balance = GetAccountBalance(BankId)
        local CurrentCash = Player.PlayerData.money['cash']
        local Amount = tonumber(AddAmount)
        local NewBalance = Balance + Amount
        if CurrentCash >= Amount then
         Player.Functions.RemoveMoney('cash', Amount, 'Bank Storting')  
         TriggerEvent('HD-banking:server:add:transaction', src, BankId, Amount, 'Add')
         HDCore.Functions.ExecuteSql(false, "UPDATE player_accounts SET `balance` = '" .. NewBalance .. "' WHERE `bankid` = '" ..BankId.. "'")
        end
    else
        local CurrentCash = Player.PlayerData.money['cash']
        local Amount = tonumber(AddAmount)
        if CurrentCash >= Amount then
            Player.Functions.RemoveMoney('cash', Amount, 'Bank Storting')
            Player.Functions.AddMoney('bank', Amount, 'Bank Storting')
        else
            TriggerClientEvent('HD-banking:client:send:notify', source, 'Bank', 'error', 'Onvoldoende cash..')
        end
    end
end)

RegisterServerEvent('HD-banking:server:claim:paycheck')
AddEventHandler('HD-banking:server:claim:paycheck', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.Paycheck) do
        local Item = Player.Functions.GetItemByName('paycheck')
        if Item ~= nil then
            if Item.amount > 0 then
                for i = 1, Item.amount do
                    Player.Functions.RemoveItem(Item.name, 1)
                    Player.Functions.AddMoney('bank', Item.info.worth, 'claimed-paycheck')
                    Citizen.Wait(500)
                end
            end
        end
    end
    TriggerClientEvent('HDCore:Notify', src, "Je loon staat nu op je bank....", 'success')
    TriggerClientEvent('HD-phone:client:paycheck', source)
end)

RegisterServerEvent('HD-banking:server:create:account')
AddEventHandler('HD-banking:server:create:account', function(AccountName, AccountType)
local Player = HDCore.Functions.GetPlayer(source)
local RandomAccountId = CreateRandomIban()
 HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_accounts` (`citizenid`, `type`, `name`, `bankid`, `authorized`) VALUES ('"..Player.PlayerData.citizenid.."', '"..AccountType.."', '"..AccountName.."', '"..RandomAccountId.."', '[\""..Player.PlayerData.citizenid.."\"]')")
 TriggerClientEvent('HD-banking:client:refresh:bank', source)
end)

RegisterServerEvent('HD-banking:server:add:user')
AddEventHandler('HD-banking:server:add:user', function(BankId, TargetBsn)
    local src = source
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM player_accounts WHERE `bankid` = '"..BankId.."'", function(result)
        if result ~= nil then
            local Count = 0
            local UserData = json.decode(result[1].authorized)
            local NewUsers = {}
            for k, v in pairs(UserData) do
                Count = Count + 1
                table.insert(NewUsers, v)
            end
            if Count < 5 then
             table.insert(NewUsers, TargetBsn)
             HDCore.Functions.ExecuteSql(false, "UPDATE player_accounts SET `authorized` = '" .. json.encode(NewUsers) .. "' WHERE `bankid` = '" ..BankId.. "'")
             TriggerClientEvent('HD-banking:client:refresh:bank', src)
            else
             TriggerClientEvent('HDCore:Notify', src, "Je kan maximaal 4 burgers toevoegen..", 'error', 6500)
            end
        end
    end)
end)

RegisterServerEvent('HD-banking:server:remove:user')
AddEventHandler('HD-banking:server:remove:user', function(BankId, TargetBsn)
    local src = source
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM player_accounts WHERE `bankid` = '"..BankId.."'", function(result)
        if result ~= nil then
            local UserData = json.decode(result[1].authorized)
            local NewUsers = {}
            for k, v in pairs(UserData) do
                if v ~= TargetBsn then
                 table.insert(NewUsers, v)
                end
            end
            HDCore.Functions.ExecuteSql(false, "UPDATE player_accounts SET `authorized` = '" .. json.encode(NewUsers) .. "' WHERE `bankid` = '" ..BankId.. "'")
            TriggerClientEvent('HD-banking:client:refresh:bank', src)
        end
    end)
end)

RegisterServerEvent('HD-banking:server:add:transaction')
AddEventHandler('HD-banking:server:add:transaction', function(Source, BankId, Amount, Type)
    local src = Source
    local Player = HDCore.Functions.GetPlayer(src)
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM player_accounts WHERE `bankid` = '"..BankId.."'", function(result)
        if result ~= nil then
            local NewTransactionData = {}
            local TransactionData = json.decode(result[1].transactions)
            local AddTransaction = {Type = Type, Amount = Amount, CitizenId = Player.PlayerData.citizenid, Date = os.date('%d-'..'%m-'..'%y'), Time = os.date('%H:'..'%M')}
            for k, v in pairs(TransactionData) do
                table.insert(NewTransactionData, v)
            end
            table.insert(NewTransactionData, AddTransaction)
            HDCore.Functions.ExecuteSql(false, "UPDATE player_accounts SET `transactions` = '" .. json.encode(NewTransactionData) .. "' WHERE `bankid` = '" ..BankId.. "'")
        end
    end)
end)

RegisterServerEvent('HD-banking:server:remove:account')
AddEventHandler('HD-banking:server:remove:account', function(BankId)
    HDCore.Functions.ExecuteSql(false, 'DELETE FROM `player_accounts` WHERE `bankid` = "'..BankId..'"')
end)

RegisterNetEvent('HD-banking:server:give:cash')
AddEventHandler('HD-banking:server:give:cash', function(TargetPlayer, Amount)
    local SelfPlayer = HDCore.Functions.GetPlayer(source)
    local TargetPlayer = HDCore.Functions.GetPlayer(TargetPlayer)
    SelfPlayer.Functions.RemoveMoney('cash', Amount, 'Contant Geven')
    TargetPlayer.Functions.AddMoney('cash', Amount, 'Contant Geven')
    TriggerClientEvent('HDCore:Notify', SelfPlayer.PlayerData.source, "Je hebt €"..Amount.. " gegeven", "success", 4500)
    TriggerClientEvent('HDCore:Notify', TargetPlayer.PlayerData.source, "Je ontving €"..Amount.. " van "..SelfPlayer.PlayerData.charinfo.firstname, "success", 4500)
end)

HDCore.Commands.Add("geefcontant", "Geef contant geld aan een persoon", {{name="id", help="Speler ID"},{name="bedrag", help="Hoeveel geld"}}, true, function(source, args)
    local SelfPlayer = HDCore.Functions.GetPlayer(source)
    local TargetPlayer = HDCore.Functions.GetPlayer(tonumber(args[1]))
    local Amount = tonumber(args[2])
    if TargetPlayer ~= nil then
        if TargetPlayer.PlayerData.source ~= SelfPlayer.PlayerData.source then
            if Amount ~= nil and Amount > 0 then
                if SelfPlayer.PlayerData.money['cash'] >= Amount then
                    TriggerClientEvent('HD-banking:client:check:players:near', SelfPlayer.PlayerData.source, TargetPlayer.PlayerData.source, Amount)
                else
                    TriggerClientEvent('HDCore:Notify', source, "Je hebt niet genoeg contant..", "error", 4500)
                end
            end
        else
            TriggerClientEvent('HDCore:Notify', source, "Hoe dan?", "error", 4500)
        end
    else
        TriggerClientEvent('HDCore:Notify', source, "Geen burger gevonden..", "error", 4500)
    end
end)

function GetCharName(CitizenId)
    local CharName = nil
    HDCore.Functions.ExecuteSql(true, "SELECT * FROM player_metadata WHERE `citizenid` = '"..CitizenId.."'", function(CharResult) 
        local DecodeCharInfo = json.decode(CharResult[1].charinfo)
        CharName = DecodeCharInfo.firstname..' '..DecodeCharInfo.lastname
    end)
    return CharName
end

function GetAccountBalance(BankId)
    local ReturnData = nil
    HDCore.Functions.ExecuteSql(true, "SELECT * FROM player_accounts WHERE `bankid` = '"..BankId.."'", function(result)
        ReturnData = result[1].balance
    end)
    return ReturnData
end

function CreateRandomIban()
    return "NL0"..math.random(1,9)..HDCore.Shared.RandomInt(3):upper()..math.random(1111,9999)..math.random(1111,9999)..math.random(11,99)
end