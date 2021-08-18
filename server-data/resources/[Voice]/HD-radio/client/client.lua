HDCore = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if HDCore == nil then
            TriggerEvent('HDCore:GetObject', function(obj) HDCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-- Code

local radioMenu = false
local isLoggedIn = false

function enableRadio(enable)
  if enable then
    SetNuiFocus(enable, enable)
    PhonePlayIn()
    SendNUIMessage({
      type = "open",
    })
    radioMenu = enable
  end
end

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
end)

RegisterNetEvent('HDCore:Client:OnPlayerUnload')
AddEventHandler('HDCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

Citizen.CreateThread(function()
  while true do
    if HDCore ~= nil then
      if isLoggedIn then
        HDCore.Functions.TriggerCallback('HD-radio:server:GetItem', function(hasItem)
          if not hasItem then
            if exports.tokovoip_script ~= nil and next(exports.tokovoip_script) ~= nil then
              local PlayerData = HDCore.Functions.GetPlayerData()
              local playerName = GetPlayerName(PlayerId())
              local getPlayerRadioChannel = exports["mumble-voip"]:GetPlayersInRadioChannel(playerName, "radio:channel")

              if getPlayerRadioChannel ~= "nil" then
                exports["mumble-voip"]:removePlayerFromRadio(getPlayerRadioChannel)
                exports["mumble-voip"]:SetRadioChannel(playerName, "radio:channel", "nil", true)
                exports["mumble-voip"]:SetMumbleProperty("radioEnabled", true)
                HDCore.Functions.Notify('You are removed from your current frequency!', 'error')
              end
            end
          end
        end, "radio")
      end
    end

    Citizen.Wait(10000)
  end
end)

RegisterNUICallback('joinRadio', function(data, cb)
  local _source = source
  local PlayerData = HDCore.Functions.GetPlayerData()
  local playerName = GetPlayerName(PlayerId())
  local getPlayerRadioChannel = exports["mumble-voip"]:GetPlayersInRadioChannel(playerName, "radio:channel")

  if tonumber(data.channel) <= Config.MaxFrequency then
    if tonumber(data.channel) ~= tonumber(getPlayerRadioChannel) then
      if tonumber(data.channel) <= Config.RestrictedChannels then
        if(PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'doctor') then
          exports["mumble-voip"]:removePlayerFromRadio(getPlayerRadioChannel)
          exports["mumble-voip"]:SetRadioChannel(playerName, "radio:channel", tonumber(data.channel), true);
          exports["mumble-voip"]:addPlayerToRadio(tonumber(data.channel), "Radio", "radio")
          exports["mumble-voip"]:SetMumbleProperty("radioEnabled", true)
          if SplitStr(data.channel, ".")[2] ~= nil and SplitStr(data.channel, ".")[2] ~= "" then 
            HDCore.Functions.Notify(Config.messages['joined_to_radio'] .. data.channel .. ' MHz </b>', 'success')
          else
            HDCore.Functions.Notify(Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>', 'success')
          end
        else
          HDCore.Functions.Notify(Config.messages['restricted_channel_error'], 'error')
        end
      end

      if tonumber(data.channel) > Config.RestrictedChannels then
        exports["mumble-voip"]:removePlayerFromRadio(getPlayerRadioChannel)
        exports["mumble-voip"]:SetRadioChannel(playerName, "radio:channel", tonumber(data.channel), true);
        exports["mumble-voip"]:addPlayerToRadio(tonumber(data.channel), "Radio", "radio")
        exports["mumble-voip"]:SetMumbleProperty("radioEnabled", true)
        if SplitStr(data.channel, ".")[2] ~= nil and SplitStr(data.channel, ".")[2] ~= "" then 
          HDCore.Functions.Notify(Config.messages['joined_to_radio'] .. data.channel .. ' MHz </b>', 'success')
        else
          HDCore.Functions.Notify(Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>', 'success')
        end
      end
    else
      if SplitStr(data.channel, ".")[2] ~= nil and SplitStr(data.channel, ".")[2] ~= "" then 
        HDCore.Functions.Notify(Config.messages['you_on_radio'] .. data.channel .. ' MHz </b>', 'error')
      else
        HDCore.Functions.Notify(Config.messages['you_on_radio'] .. data.channel .. '.00 MHz </b>', 'error')
      end
    end
  else
    HDCore.Functions.Notify('This frequency is not available.', 'error')
  end
  cb('ok')
end)

RegisterNUICallback('leaveRadio', function(data, cb)
  local playerName = GetPlayerName(PlayerId())
  local getPlayerRadioChannel = exports["mumble-voip"]:GetPlayersInRadioChannel(playerName, "radio:channel")
  if getPlayerRadioChannel == "nil" then
    HDCore.Functions.Notify(Config.messages['not_on_radio'], 'error')
  else
    exports["mumble-voip"]:removePlayerFromRadio(getPlayerRadioChannel)
    exports["mumble-voip"]:SetRadioChannel(playerName, "radio:channel", "nil", true)
    exports["mumble-voip"]:SetMumbleProperty("radioEnabled", false)
    if SplitStr(getPlayerRadioChannel, ".")[2] ~= nil and SplitStr(getPlayerRadioChannel, ".")[2] ~= "" then 
      HDCore.Functions.Notify(Config.messages['you_leave'] .. getPlayerRadioChannel .. ' MHz </b>', 'error')
    else
      HDCore.Functions.Notify(Config.messages['you_leave'] .. getPlayerRadioChannel .. '.00 MHz </b>', 'error')
    end
    
  end
  cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
  SetNuiFocus(false, false)
  radioMenu = false
  PhonePlayOut()
  cb('ok')
end)

RegisterNetEvent('HD-radio:use')
AddEventHandler('HD-radio:use', function()
  enableRadio(true)
end)

RegisterNetEvent('HD-radio:onRadioDrop')
AddEventHandler('HD-radio:onRadioDrop', function()
  local playerName = GetPlayerName(PlayerId())
  local getPlayerRadioChannel = exports["mumble-voip"]:GetPlayersInRadioChannel(playerName, "radio:channel")

  if getPlayerRadioChannel ~= "nil" then
    exports["mumble-voip"]:removePlayerFromRadio(getPlayerRadioChannel)
    exports["mumble-voip"]:SetRadioChannel(playerName, "radio:channel", "nil", true)
    exports["mumble-voip"]:SetMumbleProperty("radioEnabled", false)
    HDCore.Functions.Notify(Config.messages['you_leave'] .. getPlayerRadioChannel .. '.00 MHz </b>', 'error')
  end
end)

function SplitStr(inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end