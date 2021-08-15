HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

local Phone = {}
local Tweets = {}
local AppAlerts = {}
local MentionedTweets = {}
local Hashtags = {}
local Calls = {}
local Adverts = {}
local GeneratedPlates = {}

RegisterServerEvent('HD-phone:server:AddAdvert')
AddEventHandler('HD-phone:server:AddAdvert', function(msg)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid

    if Adverts[CitizenId] ~= nil then
        Adverts[CitizenId].message = msg
        Adverts[CitizenId].name = "@"..Player.PlayerData.charinfo.firstname..""..Player.PlayerData.charinfo.lastname
        Adverts[CitizenId].number = Player.PlayerData.charinfo.phone
    else
        Adverts[CitizenId] = {
            message = msg,
            name = "@"..Player.PlayerData.charinfo.firstname..""..Player.PlayerData.charinfo.lastname,
            number = Player.PlayerData.charinfo.phone,
        }
    end

    TriggerClientEvent('HD-phone:client:UpdateAdverts', -1, Adverts, "@"..Player.PlayerData.charinfo.firstname..""..Player.PlayerData.charinfo.lastname)
end)

function GetOnlineStatus(number)
    local Target = HDCore.Functions.GetPlayerByPhone(number)
    local retval = false
    if Target ~= nil then retval = true end
    return retval
end

HDCore.Functions.CreateCallback('HD-phone:server:GetPhoneData', function(source, cb)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    if Player ~= nil then
        local PhoneData = {
            Applications = {},
            PlayerContacts = {},
            MentionedTweets = {},
            Chats = {},
            Hashtags = {},
            Invoices = {},
            Garage = {},
            Mails = {},
            Cars = {},
            Adverts = {},
            CryptoTransactions = {},
            Tweets = {}
        }

        PhoneData.Adverts = Adverts

        HDCore.Functions.ExecuteSql(false, "SELECT * FROM player_contacts WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' ORDER BY `name` ASC", function(result)
            local Contacts = {}
            if result[1] ~= nil then
                for k, v in pairs(result) do
                    v.status = GetOnlineStatus(v.number)
                end
                
                PhoneData.PlayerContacts = result
            end

            HDCore.Functions.ExecuteSql(false, "SELECT * FROM player_bills WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(invoices)
                if invoices[1] ~= nil then
                    for k, v in pairs(invoices) do
                        local Ply = HDCore.Functions.GetPlayerByCitizenId(v.sender)
                        if Ply ~= nil then
                            v.number = Ply.PlayerData.charinfo.phone
                        else
                            HDCore.Functions.ExecuteSql(true, "SELECT * FROM `player_metadata` WHERE `citizenid` = '"..v.sender.."'", function(res)
                                if res[1] ~= nil then
                                    res[1].charinfo = json.decode(res[1].charinfo)
                                    v.number = res[1].charinfo.phone
                                else
                                    v.number = nil
                                end
                            end)
                        end
                    end
                    PhoneData.Invoices = invoices
                end

                HDCore.Functions.ExecuteSql(false, "SELECT * FROM player_vehicles WHERE forSale = '1'", function(cars)
                    if cars ~= nil then
                        local CarsData = {}
                        for k,v in pairs(cars) do
                            cars = {
                                citizenid = v.citizenid,
                                vehicle = HDCore.Shared.Vehicles[v.vehicle]['Name'],
                                plate = v.plate,
                                salePrice = v.salePrice,
                            }
                            table.insert(CarsData, cars)
                        end
                        PhoneData.Cars = CarsData
                    end

                    HDCore.Functions.ExecuteSql(false, "SELECT * FROM player_vehicles WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(garageresult)
                        if garageresult[1] ~= nil then
                            PhoneData.Garage = garageresult
                        end
                    
                            HDCore.Functions.ExecuteSql(false, "SELECT * FROM player_messages WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(messages)
                                if messages ~= nil and next(messages) ~= nil then 
                                    PhoneData.Chats = messages
                                end

                                if AppAlerts[Player.PlayerData.citizenid] ~= nil then 
                                    PhoneData.Applications = AppAlerts[Player.PlayerData.citizenid]
                                end

                                if MentionedTweets[Player.PlayerData.citizenid] ~= nil then 
                                    PhoneData.MentionedTweets = MentionedTweets[Player.PlayerData.citizenid]
                                end

                                if Hashtags ~= nil and next(Hashtags) ~= nil then
                                    PhoneData.Hashtags = Hashtags
                                end

                                if Tweets ~= nil and next(Tweets) ~= nil then
                                    PhoneData.Tweets = Tweets
                                end

                                HDCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` ASC', function(mails)
                                    if mails[1] ~= nil then
                                        for k, v in pairs(mails) do
                                            if mails[k].button ~= nil then
                                                mails[k].button = json.decode(mails[k].button)
                                            end
                                        end
                                        PhoneData.Mails = mails
                                    end

                                cb(PhoneData)
                            end)
                        end)
                    end)
                end)
            end)
        end)
    end
end)

HDCore.Functions.CreateCallback('HD-phone:server:GetCallState', function(source, cb, ContactData)
    local Target = HDCore.Functions.GetPlayerByPhone(ContactData.number)

    if Target ~= nil then
        if Calls[Target.PlayerData.citizenid] ~= nil then
            if Calls[Target.PlayerData.citizenid].inCall then
                cb(false, true)
            else
                cb(true, true)
            end
        else
            cb(true, true)
        end
    else
        cb(false, false)
    end
end)

RegisterServerEvent('HD-phone:server:SetCallState')
AddEventHandler('HD-phone:server:SetCallState', function(bool)
    local src = source
    local Ply = HDCore.Functions.GetPlayer(src)

    if Calls[Ply.PlayerData.citizenid] ~= nil then
        Calls[Ply.PlayerData.citizenid].inCall = bool
    else
        Calls[Ply.PlayerData.citizenid] = {}
        Calls[Ply.PlayerData.citizenid].inCall = bool
    end
end)

RegisterServerEvent('HD-phone:server:RemoveMail')
AddEventHandler('HD-phone:server:RemoveMail', function(MailId)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    HDCore.Functions.ExecuteSql(false, 'DELETE FROM `player_mails` WHERE `mailid` = "'..MailId..'" AND `citizenid` = "'..Player.PlayerData.citizenid..'"')
    SetTimeout(100, function()
        HDCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` ASC', function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
    
            TriggerClientEvent('HD-phone:client:UpdateMails', src, mails)
        end)
    end)
end)

function GenerateMailId()
    return math.random(111111, 999999)
end

RegisterServerEvent('HD-phone:server:sendNewMail')
AddEventHandler('HD-phone:server:sendNewMail', function(mailData)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    if mailData.button == nil then
        HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
    else
        HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
    end
    TriggerClientEvent('HD-phone:client:NewMailNotify', src, mailData)
    SetTimeout(200, function()
        HDCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` DESC', function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
    
            TriggerClientEvent('HD-phone:client:UpdateMails', src, mails)
        end)
    end)
end)

RegisterServerEvent('HD-phone:server:sendNewMailToOffline')
AddEventHandler('HD-phone:server:sendNewMailToOffline', function(citizenid, mailData)
    local Player = HDCore.Functions.GetPlayerByCitizenId(citizenid)

    if Player ~= nil then
        local src = Player.PlayerData.source

        if mailData.button == nil then
            HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
            TriggerClientEvent('HD-phone:client:NewMailNotify', src, mailData)
        else
            HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
            TriggerClientEvent('HD-phone:client:NewMailNotify', src, mailData)
        end

        SetTimeout(200, function()
            HDCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` DESC', function(mails)
                if mails[1] ~= nil then
                    for k, v in pairs(mails) do
                        if mails[k].button ~= nil then
                            mails[k].button = json.decode(mails[k].button)
                        end
                    end
                end
        
                TriggerClientEvent('HD-phone:client:UpdateMails', src, mails)
            end)
        end)
    else
        if mailData.button == nil then
            HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
        else
            HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
        end
    end
end)

RegisterServerEvent('HD-phone:server:sendNewEventMail')
AddEventHandler('HD-phone:server:sendNewEventMail', function(citizenid, mailData)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local MailedPlayer = HDCore.Functions.GetPlayerByCitizenId(citizenid)
    if mailData.button == nil then
        HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
    else
        HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
    end
    if MailedPlayer ~= nil then
    SetTimeout(200, function()
        HDCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` DESC', function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
    
            TriggerClientEvent('HD-phone:client:UpdateMails', src, mails)
        end)
    end)
    end
end)

RegisterServerEvent('HD-phone:server:sellVehicle')
AddEventHandler('HD-phone:server:sellVehicle', function(plate, price)
    local Player = HDCore.Functions.GetPlayer(source)
    HDCore.Functions.ExecuteSql(false, "UPDATE player_vehicles SET `forSale` = '1', `salePrice` = '" .. price .. "' WHERE  `plate` = '" .. plate .. "' AND `citizenid` = '" .. Player.PlayerData.citizenid .. "'")
end)

--[[RegisterServerEvent('HD-phone:server:buy:chosen:vehicle')
AddEventHandler('HD-phone:server:buy:chosen:vehicle', function(VehiclePlate, CitizenId, SellPrice)
    local src = source
    local GarageData = 'Blokken Parking'
    local Player = HDCore.Functions.GetPlayer(src)
    if Player.PlayerData.money['bank'] >= SellPrice then
        local TargetPlayer = HDCore.Functions.GetPlayerByCitizenId(CitizenId)
        if TargetPlayer ~= nil then
           Player.Functions.RemoveMoney('bank', SellPrice, "bought-vehicle")
           TargetPlayer.Functions.AddMoney('bank', SellPrice, "sold-vehicle")
           HDCore.Functions.ExecuteSql(false, "UPDATE player_vehicles SET `citizenid` = '" .. Player.PlayerData.citizenid .. "', `garage` = '"..GarageData.."', `state` = 'in', `forSale` = '0', `salePrice` = '0' WHERE `plate` = '" ..VehiclePlate.. "'")
           TriggerClientEvent('HD-phone:client:send:email:bought:vehicle', src, VehiclePlate) 
           TriggerClientEvent('HD-phone:client:send:email:sold:vehicle', TargetPlayer.PlayerData.source, SellPrice, VehiclePlate) 
           TriggerClientEvent('HDCore:Notify', src, "Voertuig met nummerplaat '" .. VehiclePlate .. "' gekocht voor €'" .. SellPrice .. "'", "success")
        else
            HDCore.Functions.ExecuteSql(false, 'SELECT `money` FROM player_metadata WHERE citizenid ="'..CitizenId..'"',function(result)
                if result ~= nil then
                 local NewMoneyTable = {}
                 local NewBankBalance = nil
                 local MoneyTable = json.decode(result[1].money)
                 for k,v in pairs(MoneyTable) do 
                     if k == 'bank' then
                        NewBankBalance = v + SellPrice
                     end
                  NewMoneyTable = {['bank'] = NewBankBalance, ['cash'] = MoneyTable['cash'], ['crypto'] = MoneyTable['crypto']}                  
                 end
                 local MailData = {
                    sender = "Autoscout24",
                    subject = "Uw Advertentie",
                    message = "Beste lezer,<br/><br/>Hierbij ontvangt u een e-mail van uw recente advertentie.<br><br>Kenteken: <strong>" ..VehiclePlate.. "</strong> <br>Verkoop Prijs: <strong>€"..SellPrice.. '</strong><br><br>Uw voertuig is succesvol verkocht en het bedrag is op uw bank bij geschreven.<br><br>Met vriendelijke groet,<br>Autoscout24',
                    button = {}
                 }
                 TriggerEvent("HD-phone:server:sendNewEventMail", CitizenId, MailData)
                 Player.Functions.RemoveMoney('bank', SellPrice, "bought-vehicle")
                 HDCore.Functions.ExecuteSql(false, "UPDATE player_vehicles SET `citizenid` = '" .. Player.PlayerData.citizenid .. "', `garage` = '"..GarageData.."', `state` = 'in', `forSale` = '0', `salePrice` = '0' WHERE `plate` = '" ..VehiclePlate.. "'")
                 HDCore.Functions.ExecuteSql(false, "UPDATE player_metadata SET `money` = '" ..json.encode(NewMoneyTable).. "' WHERE `citizenid` = '" ..CitizenId.. "'")
                 TriggerClientEvent('HD-phone:client:send:email:bought:vehicle', src, VehiclePlate)
                 TriggerClientEvent('HDCore:Notify', src, "Voertuig met nummerplaat '" .. VehiclePlate .. "' gekocht voor €'" .. SellPrice .. "'", "success")
                end
            end)
        end
    else
        TriggerClientEvent('HDCore:Notify', src, "Je hebt niet genoeg geld op je betaalrekening...", "error")
    end
end)]]

RegisterServerEvent('HD-phone:server:buy:chosen:vehicle')      --- test pepe HDCore ---
AddEventHandler('HD-phone:server:buy:chosen:vehicle', function(VehiclePlate, CitizenId, SellPrice)
    local src = source
    local GarageData = {garagename = 'Blokken Parking', garagenumber = 1}
    local Player = HDCore.Functions.GetPlayer(src)
    if Player.PlayerData.money['bank'] >= SellPrice then
        local TargetPlayer = HDCore.Functions.GetPlayerByCitizenId(CitizenId)
        if TargetPlayer ~= nil then
           Player.Functions.RemoveMoney('bank', SellPrice, "bought-vehicle")
           TargetPlayer.Functions.AddMoney('bank', SellPrice, "sold-vehicle")
           HDCore.Functions.ExecuteSql(false, "UPDATE player_vehicles SET `citizenid` = '" .. Player.PlayerData.citizenid .. "', `garage` = '"..json.encode(GarageData).."', `state` = 'in', `forSale` = '0', `salePrice` = '0' WHERE `plate` = '" ..VehiclePlate.. "'")
           TriggerClientEvent('HD-phone:client:send:email:bought:vehicle', src, VehiclePlate) 
           TriggerClientEvent('HD-phone:client:send:email:sold:vehicle', TargetPlayer.PlayerData.source, SellPrice, VehiclePlate) 
           TriggerClientEvent('HDCore:Notify', src, "Vehicle with licenseplate '" .. VehiclePlate .. "' has been purchased for €'" .. SellPrice .. "'", "success")
        else
            HDCore.Functions.ExecuteSql(false, 'SELECT `money` FROM player_metadata WHERE citizenid ="'..CitizenId..'"',function(result)
                if result ~= nil then
                 local NewMoneyTable = {}
                 local NewBankBalance = nil
                 local MoneyTable = json.decode(result[1].money)
                 for k,v in pairs(MoneyTable) do 
                     if k == 'bank' then
                        NewBankBalance = v + SellPrice
                     end
                  NewMoneyTable = {['bank'] = NewBankBalance, ['cash'] = MoneyTable['cash'], ['crypto'] = MoneyTable['crypto']}                  
                 end
                 local MailData = {
                    sender = "Autoscout24",
                    subject = "Uw Advertentie",
                    message = "Beste lezer,<br/><br/>Hierbij ontvangt u een e-mail van uw recente advertentie.<br><br>Kenteken: <strong>" ..VehiclePlate.. "</strong> <br>Verkoop Prijs: <strong>€"..SellPrice.. '</strong><br><br>Uw voertuig is succesvol verkocht en het bedrag is op uw bank bij geschreven.<br><br>Met vriendelijke groet,<br>Autoscout24',
                    button = {}
                 }
                 TriggerEvent("HD-phone:server:sendNewEventMail", CitizenId, MailData)
                 Player.Functions.RemoveMoney('bank', SellPrice, "bought-vehicle")
                 HDCore.Functions.ExecuteSql(false, "UPDATE player_vehicles SET `citizenid` = '" .. Player.PlayerData.citizenid .. "', `garage` = '"..json.encode(GarageData).."', `state` = 'in', `forSale` = '0', `salePrice` = '0' WHERE `plate` = '" ..VehiclePlate.. "'")
                 HDCore.Functions.ExecuteSql(false, "UPDATE player_metadata SET `money` = '" ..json.encode(NewMoneyTable).. "' WHERE `citizenid` = '" ..CitizenId.. "'")
                 TriggerClientEvent('HD-phone:client:send:email:bought:vehicle', src, VehiclePlate)
                 TriggerClientEvent('HDCore:Notify', src, "Voertuig met nummerplaat '" .. VehiclePlate .. "' gekocht voor €'" .. SellPrice .. "'", "success")
                end
            end)
        end
    else
        TriggerClientEvent('HDCore:Notify', src, "Je hebt niet genoeg geld op je betaalrekening...", "error")
    end
end)

--[[HDCore.Functions.CreateCallback('HD-phone:server:load:autoscout', function(source, cb)
 HDCore.Functions.ExecuteSql(false, "SELECT * FROM player_vehicles WHERE forSale = '1'", function(cars)
     if cars ~= nil then
         local CarsData = {}
         for k,v in pairs(cars) do
             cars = {
                 citizenid = v.citizenid,
                 vehicle = HDCore.Shared.Vehicles[v.vehicle]['Name'],
                 plate = v.plate,
                 salePrice = v.salePrice,
             }
             table.insert(CarsData, cars)
         end
          cb(CarsData)
     end
    end)
end)]]

HDCore.Functions.CreateCallback('HD-phone:server:load:autoscout', function(source, cb)               --- test pepe HDCore ---
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM player_vehicles WHERE forSale = '1'", function(cars)
        if cars ~= nil then
            local CarsData = {}
            for k,v in pairs(cars) do
               
               local VehicleData = HDCore.Shared.Vehicles[v.vehicle]
                cars = {
                    citizenid = v.citizenid,
                    --vehicle = exports['pepe-garages']:GetVehicleName(v.vehicle),
                    vehicle = VehicleData["brand"] .. " " .. VehicleData["name"],
                    plate = v.plate,
                    salePrice = v.salePrice,
                }
                table.insert(CarsData, cars)
            end
             cb(CarsData)
        end
       end)
   end)

RegisterServerEvent('HD-phone:server:ClearButtonData')
AddEventHandler('HD-phone:server:ClearButtonData', function(mailId)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    HDCore.Functions.ExecuteSql(false, 'UPDATE `player_mails` SET `button` = "" WHERE `mailid` = "'..mailId..'" AND `citizenid` = "'..Player.PlayerData.citizenid..'"')
    SetTimeout(200, function()
        HDCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` DESC', function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
    
            TriggerClientEvent('HD-phone:client:UpdateMails', src, mails)
        end)
    end)
end)

RegisterServerEvent('HD-phone:server:MentionedPlayer')
AddEventHandler('HD-phone:server:MentionedPlayer', function(firstName, lastName, TweetMessage)
    for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.charinfo.firstname == firstName and Player.PlayerData.charinfo.lastname == lastName) then
                Phone.SetPhoneAlerts(Player.PlayerData.citizenid, "twitter")
                Phone.AddMentionedTweet(Player.PlayerData.citizenid, TweetMessage)
                TriggerClientEvent('HD-phone:client:GetMentioned', Player.PlayerData.source, TweetMessage, AppAlerts[Player.PlayerData.citizenid]["twitter"])
            else
                HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_metadata` WHERE `charinfo` LIKE '%"..firstName.."%' AND `charinfo` LIKE '%"..lastName.."%'", function(result)
                    if result[1] ~= nil then
                        local MentionedTarget = result[1].citizenid
                        Phone.SetPhoneAlerts(MentionedTarget, "twitter")
                        Phone.AddMentionedTweet(MentionedTarget, TweetMessage)
                    end
                end)
            end
        end
	end
end)

RegisterServerEvent('HD-phone:server:CallContact')
AddEventHandler('HD-phone:server:CallContact', function(TargetData, CallId, AnonymousCall)
    local src = source
    local Ply = HDCore.Functions.GetPlayer(src)
    local Target = HDCore.Functions.GetPlayerByPhone(TargetData.number)

    if Target ~= nil then
        TriggerClientEvent('HD-phone:client:GetCalled', Target.PlayerData.source, Ply.PlayerData.charinfo.phone, CallId, AnonymousCall)
    end
end)

HDCore.Functions.CreateCallback('HD-phone:server:PayInvoice', function(source, cb, sender, amount, invoiceId)
    local src = source
    local Ply = HDCore.Functions.GetPlayer(src)
        if Ply.PlayerData.money.bank >= amount then
            Ply.Functions.RemoveMoney('bank', amount, "paid-invoice")
            HDCore.Functions.ExecuteSql(true, "DELETE FROM `player_bills` WHERE `invoiceid` = '"..invoiceId.."'")
            cb(true)
        else
            cb(false)
        end
end)

HDCore.Functions.CreateCallback('HD-phone:server:DeclineInvoice', function(source, cb, sender, amount, invoiceId)
    local src = source
    local Ply = HDCore.Functions.GetPlayer(src)
    local Trgt = HDCore.Functions.GetPlayerByCitizenId(sender)
    local Invoices = {}

    HDCore.Functions.ExecuteSql(true, "DELETE FROM `player_bills` WHERE `invoiceid` = '"..invoiceId.."'")
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_bills` WHERE `citizenid` = '"..Ply.PlayerData.citizenid.."'", function(invoices)
        if invoices[1] ~= nil then
            for k, v in pairs(invoices) do
                local Target = HDCore.Functions.GetPlayerByCitizenId(v.sender)
                if Target ~= nil then
                    v.number = Target.PlayerData.charinfo.phone
                else
                    HDCore.Functions.ExecuteSql(true, "SELECT * FROM `players` WHERE `citizenid` = '"..v.sender.."'", function(res)
                        if res[1] ~= nil then
                            res[1].charinfo = json.decode(res[1].charinfo)
                            v.number = res[1].charinfo.phone
                        else
                            v.number = nil
                        end
                    end)
                end
            end
            Invoices = invoices
        end
        cb(true, invoices)
    end)
end)

RegisterServerEvent('HD-phone:server:UpdateHashtags')
AddEventHandler('HD-phone:server:UpdateHashtags', function(Handle, messageData)
    if Hashtags[Handle] ~= nil and next(Hashtags[Handle]) ~= nil then
        table.insert(Hashtags[Handle].messages, messageData)
    else
        Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(Hashtags[Handle].messages, messageData)
    end
    TriggerClientEvent('HD-phone:client:UpdateHashtags', -1, Handle, messageData)
end)

Phone.AddMentionedTweet = function(citizenid, TweetData)
    if MentionedTweets[citizenid] == nil then MentionedTweets[citizenid] = {} end
    table.insert(MentionedTweets[citizenid], TweetData)
end

Phone.SetPhoneAlerts = function(citizenid, app, alerts)
    if citizenid ~= nil and app ~= nil then
        if AppAlerts[citizenid] == nil then
            AppAlerts[citizenid] = {}
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = alerts
                end
            end
        else
            if AppAlerts[citizenid][app] == nil then
                if alerts == nil then
                    AppAlerts[citizenid][app] = 1
                else
                    AppAlerts[citizenid][app] = 0
                end
            else
                if alerts == nil then
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 1
                else
                    AppAlerts[citizenid][app] = AppAlerts[citizenid][app] + 0
                end
            end
        end
    end
end

HDCore.Functions.CreateCallback('HD-phone:server:GetContactPictures', function(source, cb, Chats)
    for k, v in pairs(Chats) do
        local Player = HDCore.Functions.GetPlayerByPhone(v.number)
        
        HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_metadata` WHERE `charinfo` LIKE '%"..v.number.."%'", function(result)
            if result[1] ~= nil then
                local MetaData = json.decode(result[1].globals)

                if MetaData.phone.profilepicture ~= nil then
                    v.picture = MetaData.phone.profilepicture
                else
                    v.picture = "default"
                end
            end
        end)
    end
    SetTimeout(100, function()
        cb(Chats)
    end)
end)

HDCore.Functions.CreateCallback('HD-phone:server:GetContactPicture', function(source, cb, Chat)
    local Player = HDCore.Functions.GetPlayerByPhone(Chat.number)

    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_metadata` WHERE `charinfo` LIKE '%"..Chat.number.."%'", function(result)
        local MetaData = json.decode(result[1].globals)

        if MetaData.phone.profilepicture ~= nil then
            Chat.picture = MetaData.phone.profilepicture
        else
            Chat.picture = "default"
        end
    end)
    SetTimeout(100, function()
        cb(Chat)
    end)
end)

HDCore.Functions.CreateCallback('HD-phone:server:GetPicture', function(source, cb, number)
    local Player = HDCore.Functions.GetPlayerByPhone(number)
    local Picture = nil

    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_metadata` WHERE `charinfo` LIKE '%"..number.."%'", function(result)
        if result[1] ~= nil then
            local MetaData = json.decode(result[1].globals)

            if MetaData.phone.profilepicture ~= nil then
                Picture = MetaData.phone.profilepicture
            else
                Picture = "default"
            end
            cb(Picture)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('HD-phone:server:SetPhoneAlerts')
AddEventHandler('HD-phone:server:SetPhoneAlerts', function(app, alerts)
    local src = source
    local CitizenId = HDCore.Functions.GetPlayer(src).citizenid
    Phone.SetPhoneAlerts(CitizenId, app, alerts)
end)

RegisterServerEvent('HD-phone:server:UpdateTweets')
AddEventHandler('HD-phone:server:UpdateTweets', function(NewTweets, TweetData, Type)
    Tweets = NewTweets
    local TwtData = TweetData
    local src = source
    TriggerClientEvent('HD-phone:client:UpdateTweets', -1, src, Tweets, TwtData, Type)
end)

RegisterServerEvent('HD-phone:server:TransferMoney')
AddEventHandler('HD-phone:server:TransferMoney', function(iban, amount)
    local src = source
    local sender = HDCore.Functions.GetPlayer(src)

    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_metadata` WHERE `charinfo` LIKE '%"..iban.."%'", function(result)
        if result[1] ~= nil then
            local recieverSteam = HDCore.Functions.GetPlayerByCitizenId(result[1].citizenid)

            if recieverSteam ~= nil then
                local PhoneItem = recieverSteam.Functions.GetItemByName("phone")
                recieverSteam.Functions.AddMoney('bank', amount, "phone-transfered-from-"..sender.PlayerData.citizenid)
                sender.Functions.RemoveMoney('bank', amount, "phone-transfered-to-"..recieverSteam.PlayerData.citizenid)

                if PhoneItem ~= nil then
                    TriggerClientEvent('HD-phone:client:TransferMoney', recieverSteam.PlayerData.source, amount, recieverSteam.PlayerData.money.bank)
                end
            else
                local moneyInfo = json.decode(result[1].money)
                moneyInfo.bank = round((moneyInfo.bank + amount))
                HDCore.Functions.ExecuteSql(false, "UPDATE `player_metadata` SET `money` = '"..json.encode(moneyInfo).."' WHERE `citizenid` = '"..result[1].citizenid.."'")
                sender.Functions.RemoveMoney('bank', amount, "phone-transfered")
            end
        else
            TriggerClientEvent('HDCore:Notify', src, "Dit rekeningnummer bestaat niet!", "error")
        end
    end)
end)

RegisterServerEvent('HD-phone:server:EditContact')
AddEventHandler('HD-phone:server:EditContact', function(newName, newNumber, newIban, oldName, oldNumber, oldIban)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    HDCore.Functions.ExecuteSql(false, "UPDATE `player_contacts` SET `name` = '"..newName.."', `number` = '"..newNumber.."', `iban` = '"..newIban.."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `name` = '"..oldName.."' AND `number` = '"..oldNumber.."'")
end)

RegisterServerEvent('HD-phone:server:RemoveContact')
AddEventHandler('HD-phone:server:RemoveContact', function(Name, Number)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    
    HDCore.Functions.ExecuteSql(false, "DELETE FROM `player_contacts` WHERE `name` = '"..Name.."' AND `number` = '"..Number.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
end)

RegisterServerEvent('HD-phone:server:AddNewContact')
AddEventHandler('HD-phone:server:AddNewContact', function(name, number, iban)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_contacts` (`citizenid`, `name`, `number`, `iban`) VALUES ('"..Player.PlayerData.citizenid.."', '"..tostring(name).."', '"..tostring(number).."', '"..tostring(iban).."')")
end)

RegisterServerEvent('HD-phone:server:UpdateMessages')
AddEventHandler('HD-phone:server:UpdateMessages', function(ChatMessages, ChatNumber, New)
    local src = source
    local SenderData = HDCore.Functions.GetPlayer(src)

    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_metadata` WHERE `charinfo` LIKE '%"..ChatNumber.."%'", function(Player)
        if Player[1] ~= nil then
            local TargetData = HDCore.Functions.GetPlayerByCitizenId(Player[1].citizenid)

            if TargetData ~= nil then
                HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_messages` WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..ChatNumber.."'", function(Chat)
                    if Chat[1] ~= nil then
                        -- Update for target
                        HDCore.Functions.ExecuteSql(false, "UPDATE `player_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..TargetData.PlayerData.citizenid.."' AND `number` = '"..SenderData.PlayerData.charinfo.phone.."'")
                                
                        -- Update for sender
                        HDCore.Functions.ExecuteSql(false, "UPDATE `player_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..TargetData.PlayerData.charinfo.phone.."'")
                    
                        -- Send notification & Update messages for target
                        TriggerClientEvent('HD-phone:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, false)
                    else
                        -- Insert for target
                        HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_messages` (`citizenid`, `number`, `messages`) VALUES ('"..TargetData.PlayerData.citizenid.."', '"..SenderData.PlayerData.charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                                            
                        -- Insert for sender
                        HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_messages` (`citizenid`, `number`, `messages`) VALUES ('"..SenderData.PlayerData.citizenid.."', '"..TargetData.PlayerData.charinfo.phone.."', '"..json.encode(ChatMessages).."')")

                        -- Send notification & Update messages for target
                        TriggerClientEvent('HD-phone:client:UpdateMessages', TargetData.PlayerData.source, ChatMessages, SenderData.PlayerData.charinfo.phone, true)
                    end
                end)
            else
                HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_messages` WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..ChatNumber.."'", function(Chat)
                    if Chat[1] ~= nil then
                        -- Update for target
                        HDCore.Functions.ExecuteSql(false, "UPDATE `player_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..Player[1].citizenid.."' AND `number` = '"..SenderData.PlayerData.charinfo.phone.."'")
                                
                        -- Update for sender
                        Player[1].charinfo = json.decode(Player[1].charinfo)
                        HDCore.Functions.ExecuteSql(false, "UPDATE `player_messages` SET `messages` = '"..json.encode(ChatMessages).."' WHERE `citizenid` = '"..SenderData.PlayerData.citizenid.."' AND `number` = '"..Player[1].charinfo.phone.."'")
                    else
                        -- Insert for target
                        HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_messages` (`citizenid`, `number`, `messages`) VALUES ('"..Player[1].citizenid.."', '"..SenderData.PlayerData.charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                        
                        -- Insert for sender
                        Player[1].charinfo = json.decode(Player[1].charinfo)
                        HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_messages` (`citizenid`, `number`, `messages`) VALUES ('"..SenderData.PlayerData.citizenid.."', '"..Player[1].charinfo.phone.."', '"..json.encode(ChatMessages).."')")
                    end
                end)
            end
        end
    end)
end)

RegisterServerEvent('HD-phone:server:AddRecentCall')
AddEventHandler('HD-phone:server:AddRecentCall', function(type, data)
    local src = source
    local Ply = HDCore.Functions.GetPlayer(src)

    local Hour = os.date("%H")
    local Minute = os.date("%M")
    local label = Hour..":"..Minute

    TriggerClientEvent('HD-phone:client:AddRecentCall', src, data, label, type)

    local Trgt = HDCore.Functions.GetPlayerByPhone(data.number)
    if Trgt ~= nil then
        TriggerClientEvent('HD-phone:client:AddRecentCall', Trgt.PlayerData.source, {
            name = Ply.PlayerData.charinfo.firstname .. " " ..Ply.PlayerData.charinfo.lastname,
            number = Ply.PlayerData.charinfo.phone,
            anonymous = anonymous
        }, label, "outgoing")
    end
end)

RegisterServerEvent('HD-phone:server:CancelCall')
AddEventHandler('HD-phone:server:CancelCall', function(ContactData)
    local Ply = HDCore.Functions.GetPlayerByPhone(ContactData.TargetData.number)

    if Ply ~= nil then
        TriggerClientEvent('HD-phone:client:CancelCall', Ply.PlayerData.source)
    end
end)

RegisterServerEvent('HD-phone:server:AnswerCall')
AddEventHandler('HD-phone:server:AnswerCall', function(CallData)
    local Ply = HDCore.Functions.GetPlayerByPhone(CallData.TargetData.number)

    if Ply ~= nil then
        TriggerClientEvent('HD-phone:client:AnswerCall', Ply.PlayerData.source)
    end
end)

RegisterServerEvent('HD-phone:server:SaveMetaData')
AddEventHandler('HD-phone:server:SaveMetaData', function(MData)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("phone", MData)
end)

function escape_sqli(source)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return source:gsub( "['\"]", replacements )
end

HDCore.Functions.CreateCallback('HD-phone:server:FetchResult', function(source, cb, search)
    local src = source
    local search = escape_sqli(search)
    local searchData = {}
    local ApaData = {}
    HDCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_metadata` WHERE `citizenid` = "'..search..'" OR `charinfo` LIKE "%'..search..'%"', function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                local charinfo = json.decode(v.charinfo)
                local globals = json.decode(v.globals)
                if charinfo ~= nil then
                table.insert(searchData, {
                    citizenid = v.citizenid,
                    firstname = charinfo.firstname,
                    lastname = charinfo.lastname,
                    birthdate = charinfo.birthdate,
                    phone = charinfo.phone,
                    nationality = charinfo.nationality,
                    gender = charinfo.gender,
                    appartmentid = globals["appartment-data"].Id,
                    appartmentname = exports['HD-appartments']:GetAppartmentName(globals["appartment-data"].Name),
                    driverlicense = globals["licences"]["driver"],
                })
              end
            end
            cb(searchData)
        else
            cb(nil)
        end
    end)
end)

HDCore.Functions.CreateCallback('HD-phone:server:GetVehicleSearchResults', function(source, cb, search)
    local src = source
    local search = escape_sqli(search)
    local searchData = {}
    HDCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_vehicles` WHERE `plate` LIKE "%'..search..'%" OR `citizenid` = "'..search..'"', function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                HDCore.Functions.ExecuteSql(true, 'SELECT * FROM `player_metadata` WHERE `citizenid` = "'..result[k].citizenid..'"', function(player)
                    if player[1] ~= nil then 
                        local charinfo = json.decode(player[1].charinfo)
                            table.insert(searchData, {
                                plate = result[k].plate,
                                status = true,
                                owner = charinfo.firstname .. " " .. charinfo.lastname,
                                citizenid = result[k].citizenid,
                                label = result[k].vehicle
                            })
                    end
                end)
            end
        else
            if GeneratedPlates[search] ~= nil then
                table.insert(searchData, {
                    plate = GeneratedPlates[search].plate,
                    status = GeneratedPlates[search].status,
                    owner = GeneratedPlates[search].owner,
                    citizenid = GeneratedPlates[search].citizenid,
                    label = "Merk niet bekend.."
                })
            else
                local ownerInfo = GenerateOwnerName()
                GeneratedPlates[search] = {
                    plate = search,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                }
                table.insert(searchData, {
                    plate = search,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                    label = "Merk niet bekend.."
                })
            end
        end
        cb(searchData)
    end)
end)

HDCore.Functions.CreateCallback('HD-phone:server:ScanPlate', function(source, cb, plate)
    local src = source
    local vehicleData = {}
    if plate ~= nil then 
        HDCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_vehicles` WHERE `plate` = "'..plate..'"', function(result)
            if result[1] ~= nil then
                HDCore.Functions.ExecuteSql(true, 'SELECT * FROM `player_metadata` WHERE `citizenid` = "'..result[1].citizenid..'"', function(player)
                    local charinfo = json.decode(player[1].charinfo)
                    vehicleData = {
                        plate = plate,
                        status = true,
                        owner = charinfo.firstname .. " " .. charinfo.lastname,
                        citizenid = result[1].citizenid,
                    }
                end)
            elseif GeneratedPlates ~= nil and GeneratedPlates[plate] ~= nil then 
                vehicleData = GeneratedPlates[plate]
            else
                local ownerInfo = GenerateOwnerName()
                GeneratedPlates[plate] = {
                    plate = plate,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                }
                vehicleData = {
                    plate = plate,
                    status = true,
                    owner = ownerInfo.name,
                    citizenid = ownerInfo.citizenid,
                }
            end
            cb(vehicleData)
        end)
    else
        TriggerClientEvent('HDCore:Notify', src, "Geen voertuig in de buurt..", "error")
        cb(nil)
    end
end)

function GenerateOwnerName()
    local names = {
        [1] = { name = "Jan Bloksteen", citizenid = "DSH091G93" },
        [2] = { name = "Jan Bakker", citizenid = "AVH09M193" },
        [3] = { name = "Ben Klaariskees", citizenid = "DVH091T93" },
        [4] = { name = "Karel Bakker", citizenid = "GZP091G93" },
        [5] = { name = "Klaas Adriaan", citizenid = "DRH09Z193" },
        [6] = { name = "Nico Wolters", citizenid = "KGV091J93" },
        [7] = { name = "Mark Hendrickx", citizenid = "ODF09S193" },
        [8] = { name = "Bert Johannes", citizenid = "KSD0919H3" },
        [9] = { name = "Karel de Grote", citizenid = "NDX091D93" },
        [10] = { name = "Jan Pieter", citizenid = "ZAL0919X3" },
        [11] = { name = "Huig Roelink", citizenid = "ZAK09D193" },
        [12] = { name = "Corneel Boerselman", citizenid = "POL09F193" },
        [13] = { name = "Hermen Klein Overmeen", citizenid = "TEW0J9193" },
        [14] = { name = "Bart Rielink", citizenid = "YOO09H193" },
        [15] = { name = "Antoon Henselijn", citizenid = "QBC091H93" },
        [16] = { name = "Aad Keizer", citizenid = "YDN091H93" },
        [17] = { name = "Thijn Kiel", citizenid = "PJD09D193" },
        [18] = { name = "Henkie Krikhaar", citizenid = "RND091D93" },
        [19] = { name = "Teun Blaauwkamp", citizenid = "QWE091A93" },
        [20] = { name = "Dries Stielstra", citizenid = "KJH0919M3" },
        [21] = { name = "Karlijn Hensbergen", citizenid = "ZXC09D193" },
        [22] = { name = "Aafke van Daalen", citizenid = "XYZ0919C3" },
        [23] = { name = "Door Leeferds", citizenid = "ZYX0919F3" },
        [24] = { name = "Nelleke Broedersen", citizenid = "IOP091O93" },
        [25] = { name = "Renske de Raaf", citizenid = "PIO091R93" },
        [26] = { name = "Krisje Moltman", citizenid = "LEK091X93" },
        [27] = { name = "Mirre Steevens", citizenid = "ALG091Y93" },
        [28] = { name = "Joosje Kalvenhaar", citizenid = "YUR09E193" },
        [29] = { name = "Mirte Ellenbroek", citizenid = "SOM091W93" },
        [30] = { name = "Marlieke Meilink", citizenid = "KAS09193" },
    }
    return names[math.random(1, #names)]
end

--[[HDCore.Functions.CreateCallback('HD-phone:server:GetGarageVehicles', function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    local Vehicles = {}

    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                --local VehicleData = HDCore.Shared.Vehicles[v.vehicle]

                local VehicleMeta = {}
                if v.metadata ~= nil then
                    VehicleMeta = json.decode(v.metadata)
                end

                local VehicleState = "In"
                if v.state == 'out' then
                    VehicleState = "Uit"
                elseif v.state == 'impound' then
                    VehicleState = "In Beslag"
                end

                local vehdata = {}
                if v.vehicle ~= nil then
                    vehdata = {
                        fullname = HDCore.Shared.Vehicles[v.vehicle]['Name'],
                        model = HDCore.Shared.Vehicles[v.vehicle]['Name'],
                        plate = v.plate,
                        garage = v.garage,
                        state = VehicleState,
                        fuel = VehicleMeta.Fuel,
                        engine = VehicleMeta.Engine,
                        body =  VehicleMeta.Body,
                    }
                else
                    vehdata = {
                        fullname = HDCore.Shared.Vehicles[v.vehicle]['Name'],
                        model = HDCore.Shared.Vehicles[v.vehicle]['Name'],
                        plate = v.plate,
                        garage = v.garage,
                        state = VehicleState,
                        fuel = VehicleMeta.Fuel,
                        engine = VehicleMeta.Engine,
                        body =  VehicleMeta.Body,
                    }
                end

                table.insert(Vehicles, vehdata)
            end
            cb(Vehicles)
        else
            cb(nil)
        end
    end)
end)]]

HDCore.Functions.CreateCallback('HD-phone:server:GetGarageVehicles', function(source, cb)          --- test pepe HDCore ---
    local Player = HDCore.Functions.GetPlayer(source)
    local Vehicles = {}

    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                local VehicleData = HDCore.Shared.Vehicles[v.vehicle]

                local GarageData = {}
                if v.garage ~= nil then
                    GarageData = json.decode(v.garage)
                else
                    GarageData = "None"
                end

                local VehicleMeta = {}
                if v.metadata ~= nil then
                    VehicleMeta = json.decode(v.metadata)
                end


                local VehicleState = "In"
                if v.state == 'out' then
                    VehicleState = "Outside"
                elseif v.state == 'impound' then
                    VehicleState = "Impound"
                end

                local vehdata = {}

                if v.vehicle ~= nil then
                    vehdata = {
                        --fullname = exports['pepe-garages']:GetVehicleName(v.vehicle),
                       -- model = exports['pepe-garages']:GetVehicleName(v.vehicle),
                       fullname = VehicleData["brand"] .. " " .. VehicleData["name"],
                       model = VehicleData["name"],
                        plate = v.plate,
                        garage = v.garage,
                        state = VehicleState,
                        fuel = VehicleMeta.Fuel,
                        engine = VehicleMeta.Engine,
                        body =  VehicleMeta.Body,
                    }
                else
                    vehdata = {
                       -- fullname = exports['pepe-garages']:GetVehicleName(v.vehicle),
                        --model = exports['pepe-garages']:GetVehicleName(v.vehicle),
                        fullname = VehicleData["brand"] .. " " .. VehicleData["name"],
                        model = VehicleData["name"],
                        plate = v.plate,
                        garage = v.garage,
                        state = VehicleState,
                        fuel = VehicleMeta.Fuel,
                        engine = VehicleMeta.Engine,
                        body =  VehicleMeta.Body,
                    }
                end

                table.insert(Vehicles, vehdata)
            end
            cb(Vehicles)
        else
            cb(nil)
        end
    end)
end)

HDCore.Functions.CreateCallback('HD-phone:server:GetInvoiceData', function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    local InvoiceData = {}
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM player_bills WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(invoices)
        if invoices[1] ~= nil then
            for k, v in pairs(invoices) do
                local Ply = HDCore.Functions.GetPlayerByCitizenId(v.sender)
                if Ply ~= nil then
                    v.number = Ply.PlayerData.charinfo.phone
                else
                    HDCore.Functions.ExecuteSql(true, "SELECT * FROM `player_metadata` WHERE `citizenid` = '"..v.sender.."'", function(res)
                        if res[1] ~= nil then
                            res[1].charinfo = json.decode(res[1].charinfo)
                            v.number = res[1].charinfo.phone
                        else
                            v.number = nil
                        end
                    end)
                end
            end
            InvoiceData = invoices
        end
        cb(InvoiceData)
    end)
end)


RegisterServerEvent('HD-phone:server:add:invoice')
AddEventHandler('HD-phone:server:add:invoice', function(TargetPlayer, Amount, Sender, Type)
    local PhoneData = {}
    local invoiceserie = math.random(111,999)..'-MIL-'..math.random(111,999)
    HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_bills` (`citizenid`, `amount`, `invoiceid`, `sender`, `type`) VALUES ('"..TargetPlayer.."', '"..Amount.."', '"..invoiceserie.."', '"..Sender.."', '"..Type.."')")
end)

HDCore.Functions.CreateCallback('HD-phone:server:HasPhone', function(source, cb)
    local Player = HDCore.Functions.GetPlayer(source)
    if Player ~= nil then
        local HasPhone = Player.Functions.GetItemByName("phone")
        local retval = false
        if HasPhone ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent('HD-phone:server:GiveContactDetails')
AddEventHandler('HD-phone:server:GiveContactDetails', function(PlayerId)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    local SuggestionData = {
        name = {
            [1] = Player.PlayerData.charinfo.firstname,
            [2] = Player.PlayerData.charinfo.lastname
        },
        number = Player.PlayerData.charinfo.phone,
        bank = Player.PlayerData.charinfo.account
    }
    TriggerClientEvent('HD-phone:client:AddNewSuggestion', PlayerId, SuggestionData)
end)

HDCore.Functions.CreateCallback('HD-phone:server:GetCurrentLawyers', function(source, cb)
    local Lawyers = {}
    for k, v in pairs(HDCore.Functions.GetPlayers()) do
        local Player = HDCore.Functions.GetPlayer(v)
        if Player ~= nil then
            --if Player.PlayerData.job.name == "lawyer" or Player.PlayerData.job.name == "realestate" or Player.PlayerData.job.name == "cardealer" and Player.PlayerData.job.onduty then
            if Player.PlayerData.job.name == "lawyer" or Player.PlayerData.job.name == "realestate" or Player.PlayerData.job.name == "tuningshop" or Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.onduty then
                table.insert(Lawyers, {
                    name = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
                    phone = Player.PlayerData.charinfo.phone,
                    typejob = Player.PlayerData.job.name,
                })
            end
        end
    end
    cb(Lawyers)
end)

HDCore.Commands.Add("testuh", "Factuur uitschrijven", function(source, args)
    TriggerClientEvent('HD-phone:client:salaris', source)
end)