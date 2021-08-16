HDCore = nil

TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)

-- Code

HDCore.Functions.CreateCallback("HD-wapenkluis:server:get:config", function(source, cb)
    cb(Config)
end)

HDCore.Functions.CreateCallback("HD-wapenkluis:server:pin:code", function(source, cb)
    cb(Config.ArmoryCode['Code'])
end)