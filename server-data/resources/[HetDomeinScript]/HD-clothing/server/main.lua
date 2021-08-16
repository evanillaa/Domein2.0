HDCore = nil
TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Commands.Add("skin", "Ooohja toch", {}, false, function(source, args)
	TriggerClientEvent("HD-clothing:client:openMenu", source)
end, "admin")

RegisterServerEvent("HD-clothing:saveSkin")
AddEventHandler('HD-clothing:saveSkin', function(model, skin)
    local Player = HDCore.Functions.GetPlayer(source)
    if model ~= nil and skin ~= nil then 
        HDCore.Functions.ExecuteSql(false, "DELETE FROM `player_skins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function()
          HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_skins` (`citizenid`, `model`, `skin`) VALUES ('"..Player.PlayerData.citizenid.."', '"..model.."', '"..skin.."')")
        end)
    end
end)

RegisterServerEvent("HD-clothing:loadPlayerSkin")
AddEventHandler('HD-clothing:loadPlayerSkin', function()
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_skins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            TriggerClientEvent("HD-clothing:loadSkin", src, false, result[1].model, result[1].skin)
        else
            TriggerClientEvent("HD-clothing:loadSkin", src, true)
        end
    end)
end)

RegisterServerEvent("HD-clothing:saveOutfit")
AddEventHandler("HD-clothing:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        HDCore.Functions.ExecuteSql(false, "INSERT INTO `player_outfits` (`citizenid`, `outfitname`, `model`, `skin`, `outfitId`) VALUES ('"..Player.PlayerData.citizenid.."', '"..outfitName.."', '"..model.."', '"..json.encode(skinData).."', '"..outfitId.."')", function()
            HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
                if result[1] ~= nil then
                    TriggerClientEvent('HD-clothing:client:reloadOutfits', src, result)
                else
                    TriggerClientEvent('HD-clothing:client:reloadOutfits', src, nil)
                end
            end)
        end)
    end
end)

RegisterServerEvent("HD-clothing:server:removeOutfit")
AddEventHandler("HD-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)

    HDCore.Functions.ExecuteSql(false, "DELETE FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `outfitname` = '"..outfitName.."' AND `outfitId` = '"..outfitId.."'", function()
        HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
            if result[1] ~= nil then
                TriggerClientEvent('HD-clothing:client:reloadOutfits', src, result)
            else
                TriggerClientEvent('HD-clothing:client:reloadOutfits', src, nil)
            end
        end)
    end)
end)

HDCore.Functions.CreateCallback('HD-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = HDCore.Functions.GetPlayer(src)
    local anusVal = {}

    HDCore.Functions.ExecuteSql(false, "SELECT * FROM `player_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                result[k].skin = json.decode(result[k].skin)
                anusVal[k] = v
            end
            cb(anusVal)
        end
        cb(anusVal)
    end)
end)

HDCore.Commands.Add("helm", "Zet je helm/pet/hoed op of af..", {}, false, function(source, args)
    TriggerClientEvent("HD-clothing:client:adjustfacewear", source, 1) -- Hat
end)

HDCore.Commands.Add("bril", "Zet je bril op of af..", {}, false, function(source, args)
	TriggerClientEvent("HD-clothing:client:adjustfacewear", source, 2)
end)

HDCore.Commands.Add("masker", "Zet je masker op of af..", {}, false, function(source, args)
	TriggerClientEvent("HD-clothing:client:adjustfacewear", source, 4)
end)