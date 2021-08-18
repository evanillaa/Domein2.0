HDCore = {}
HDCore.Config = Config
HDCore.Shared = Shared
HDCore.ServerCallbacks = {}
HDCore.UseableItems = {}

function GetCoreObject()
	return HDCore
end

RegisterServerEvent('HDCore:GetObject')
AddEventHandler('HDCore:GetObject', function(cb)
	cb(GetCoreObject())
end)