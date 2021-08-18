HDCore = {}
HDCore.PlayerData = {}
HDCore.Config = Config
HDCore.Shared = Shared
HDCore.ServerCallbacks = {}

isLoggedIn = false

function GetCoreObject()
	return HDCore
end

RegisterNetEvent('HDCore:GetObject')
AddEventHandler('HDCore:GetObject', function(cb)
	cb(GetCoreObject())
end)

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
	ShutdownLoadingScreenNui()
	exports.spawnmanager:setAutoSpawn(false)
	isLoggedIn = true
end)

RegisterNetEvent('HDCore:Client:OnPlayerUnload')
AddEventHandler('HDCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)