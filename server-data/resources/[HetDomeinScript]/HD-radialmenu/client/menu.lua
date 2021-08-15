local showMenu = false
local MAX_MENU_ITEMS = 7

local isLoggedIn = false

RegisterNetEvent('HDCore:Client:OnPlayerLoaded')
AddEventHandler('HDCore:Client:OnPlayerLoaded', function()
  Citizen.SetTimeout(1250, function()
      TriggerEvent("HDCore:GetObject", function(obj) HDCore = obj end)    
      Citizen.Wait(100)
      isLoggedIn = true
  end)
end)

RegisterNetEvent('HDCore:Client:OnPlayerUnload')
AddEventHandler('HDCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
           if IsControlPressed(1, Config.Keys['F1']) and GetLastInputMethod(2) and showMenu then
               showMenu = false
               SetNuiFocus(false, false)
           end
           if IsControlPressed(1, Config.Keys['F1']) and GetLastInputMethod(2) then
               showMenu = true
             if showMenu == true then
               DisableControlAction(0, 289, true)  
               DisableControlAction(0, 288, true)  
             end
            local enabledMenus = {}
               for _, menuConfig in ipairs(Config.Menu) do
                   if menuConfig:enableMenu() then
                       local dataElements = {}
                       local hasSubMenus = false
                       if menuConfig.subMenus ~= nil and #menuConfig.subMenus > 0 then
                           hasSubMenus = true
                           local previousMenu = dataElements
                           local currentElement = {}
                           for i = 1, #menuConfig.subMenus do
                               currentElement[#currentElement+1] = Config.SubMenus[menuConfig.subMenus[i]]
                               currentElement[#currentElement].id = menuConfig.subMenus[i]
                               currentElement[#currentElement].enableMenu = nil
   
                               if i % MAX_MENU_ITEMS == 0 and i < (#menuConfig.subMenus - 1) then
                                   previousMenu[MAX_MENU_ITEMS + 1] = {
                                       id = "_more",
                                       title = "More",
                                       icon = "#more",
                                       items = currentElement
                                   }
                                   previousMenu = currentElement
                                   currentElement = {}
                               end
                           end
                           if #currentElement > 0 then
                               previousMenu[MAX_MENU_ITEMS + 1] = {
                                   id = "_more",
                                   title = "More",
                                   icon = "#more",
                                   items = currentElement
                               }
                           end
                           dataElements = dataElements[MAX_MENU_ITEMS + 1].items
   
                       end
                       enabledMenus[#enabledMenus+1] = {
                           id = menuConfig.id,
                           title = menuConfig.displayName,
                           close = menuConfig.close,
                           functiontype = menuConfig.functiontype,
                           functionParameters = menuConfig.functionParameters,
                           functionName = menuConfig.functionName,
                           icon = menuConfig.icon,
                       }
                       if hasSubMenus then
                           enabledMenus[#enabledMenus].items = dataElements
                       end
                   end
               end
               SendNUIMessage({
                   state = "show",
                   data = enabledMenus,
                   menuKeyBind = 'F1'
               })
               SetCursorLocation(0.5, 0.5)
               SetNuiFocus(true, true)
               PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
               while showMenu == true do Citizen.Wait(100) end
               Citizen.Wait(100)
               while IsControlPressed(1, Config.Keys['F1']) and GetLastInputMethod(2) do Citizen.Wait(100) end
           end
         else
            Citizen.Wait(150)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if isLoggedIn then
            HDCore.Functions.TriggerCallback('HD-radialmenu:server:HasItem', function(HasItem)
                if HasItem then
                    HasHandCuffs = true
                else
                    HasHandCuffs = false
                end
            end, 'handcuffs')
            Citizen.Wait(250)
        else
            Citizen.Wait(250)
        end
    end
end)

RegisterNetEvent('HD-radialmenu:client:force:close')
AddEventHandler('HD-radialmenu:client:force:close', function()
  showMenu = false
  SetNuiFocus(false, false)
  SendNUIMessage({
      state = 'destroy'
  })
end)


RegisterNetEvent('HD-radialmenu:client:refresh')
AddEventHandler('HD-radialmenu:client:refresh', function()
    HDCore.Functions.Progressbar("reset-f1", "F1 wordt gereset..", 1200, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        showMenu = false
        SetNuiFocus(false, false)
        SendNUIMessage({
            state = 'destroy'
        })
    end, function() -- Cancel
    end)
end)


RegisterNUICallback('closemenu', function(data, cb)
 showMenu = false
 SetNuiFocus(false, false)
 SendNUIMessage({
     state = 'destroy'
 })
 PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
 cb('ok')
end)

RegisterNUICallback('triggerAction', function(data, cb)
 PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
 if data.type == 'client' then
     TriggerEvent(data.action, data.parameters)
 elseif data.type == 'server' then 
     TriggerServerEvent(data.action, data.parameters)
 end
 cb('ok')
end)