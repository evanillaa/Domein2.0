local DutyVehicles = {}
HasHandCuffs = false

Config = Config or {}

Config.Keys = {["F1"] = 288}
Config.Locale = "en"
Config.Menu = {
 [1] = {
    id = "citizen",
    displayName = "Citizen",
    icon = "#citizen-action",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            return true
        end
    end,
    subMenus = {"citizen:escort", 'citizen:steal', 'citizen:contact', 'citizen:vehicle:getout', 'citizen:vehicle:getin', 'citizen:corner:selling', 'favo:radio:one'}
 },
 [2] = {
    id = "animations",
    displayName = "Walkstyles",
    icon = "#walking",
    enableMenu = function()
       if not exports['HD-hospital']:GetDeathStatus() then
           return true
        end
    end,
    subMenus = { "animations:brave", "animations:hurry", "animations:business", "animations:tipsy", "animations:injured","animations:tough", "animations:default", "animations:hobo", "animations:money", "animations:swagger", "animations:shady", "animations:maneater", "animations:chichi", "animations:sassy", "animations:sad", "animations:posh", "animations:alien" }
 },
 [3] = {
     id = "expressions",
     displayName = "Expressions",
     icon = "#expressions",
     enableMenu = function()
         if not exports['HD-hospital']:GetDeathStatus() then
            return true
         end
     end,
     subMenus = { "expressions:normal", "expressions:drunk", "expressions:angry", "expressions:dumb", "expressions:electrocuted", "expressions:grumpy", "expressions:happy", "expressions:injured", "expressions:joyful", "expressions:mouthbreather", "expressions:oneeye", "expressions:shocked", "expressions:sleeping", "expressions:smug", "expressions:speculative", "expressions:stressed", "expressions:sulking", "expressions:weird", "expressions:weird2"}
 },
 [4] = {
    id = "police",
    displayName = "Police",
    icon = "#police-action",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() and HDCore.Functions.GetPlayerData().job.name == 'police' and HDCore.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"police:panic", "police:search", "police:tablet", "police:impound", "police:impoundhard", "police:resetdoor", "police:enkelband", "police:checkstatus"}
 },
 [5] = {
    id = "police",
    displayName = "Police Objects",
    icon = "#police-action",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() and HDCore.Functions.GetPlayerData().job.name == 'police' and HDCore.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"police:object:cone", "police:object:barrier", "police:object:tent", "police:object:light", "police:object:schot", "police:object:delete"}
 },
 [6] = {
    id = "police-down",
    displayName = "10-13A",
    icon = "#police-down",
    close = true,
    functiontype = "client",
    functionParameters = 'Urgent',
    functionName = "HD-radialmenu:client:send:down",
    enableMenu = function()
        if exports['HD-hospital']:GetDeathStatus() and HDCore.Functions.GetPlayerData().job.name == 'police' and HDCore.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
 },
 [7] = {
    id = "police-down",
    displayName = "10-13B",
    icon = "#police-down",
    close = true,
    functiontype = "client",
    functionParameters = 'Normal',
    functionName = "HD-radialmenu:client:send:down",
    enableMenu = function()
        if exports['HD-hospital']:GetDeathStatus() and HDCore.Functions.GetPlayerData().job.name == 'police' and HDCore.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
 },
 [8] = {
    id = "ambulance",
    displayName = "Ambulance",
    icon = "#ambulance-action",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() and HDCore.Functions.GetPlayerData().job.name == 'ambulance' and HDCore.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"ambulance:heal", "ambulance:revive", "police:panic", "ambulance:blood"}
 },
 [9] = {
    id = "vehicle",
    displayName = "Vehicle",
    icon = "#citizen-action-vehicle",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            local Vehicle, Distance = HDCore.Functions.GetClosestVehicle()
            if Vehicle ~= 0 and Distance < 2.3 then
                return true
            end
        end
    end,
    subMenus = {"vehicle:flip", "vehicle:key", "vehicle:extra", "vehicle:extra2", "vehicle:extra3", "vehicle:extra4"}
 },
 [10] = {
    id = "vehicle-doors",
    displayName = "Vehicle Doors",
    icon = "#citizen-action-vehicle",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if IsPedSittingInAnyVehicle(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) and not IsPedInAnyHeli(PlayerPedId()) and not IsPedOnAnyBike(PlayerPedId()) then
                return true
            end
        end
    end,
    subMenus = {"vehicle:door:motor", "vehicle:door:left:front", "vehicle:door:right:front", "vehicle:door:trunk", "vehicle:door:right:back", "vehicle:door:left:back"}
 },
 [11] = {
    id = "police-garage",
    displayName = "Police Garage",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if exports['HD-police']:GetGarageStatus() then
                return true
            end
        end
    end,
    subMenus = {}
 },
 [12] = {
    id = "garage",
    displayName = "Garage",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if exports['HD-garages']:IsNearGarage() then
                return true
            end
        end
    end,
    subMenus = {"garage:putin", "garage:getout"}
 },
 --[[13] = {
    id = "door",
    displayName = "Doorlock",
    icon = "#global-doors",
    close = true,
    functiontype = "client",
    functionName = "HD-doorlock:client:toggle:locks",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if exports['HD-doorlock']:CanOpenDoor() then
                return true
            end
        end
  end,
 },]]
 [14] = {
    id = "atm",
    displayName = "ATM",
    icon = "#global-card",
    close = true,
    functiontype = "client",
    functionName = "HD-banking:client:open:atm",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if exports['HD-banking']:IsNearAtm() then
                return true
            end
        end
  end,
 },
 [15] = {
    id = "atm",
    displayName = "Bank",
    icon = "#global-bank",
    close = true,
    functiontype = "client",
    functionName = "HD-banking:client:open:bank",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if exports['HD-banking']:IsNearAnyBank() then
                return true
            end
        end
  end,
 },
 [16] = {
    id = "shop",
    displayName = "Store",
    icon = "#global-store",
    close = true,
    functiontype = "client",
    functionName = "HD-stores:server:open:shop",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if exports['HD-stores']:IsNearShop() then
                return true
            end
        end
  end,
 },
 [17] = {
    id = "appartment",
    displayName = "Go Inside",
    icon = "#global-appartment",
    close = true,
    functiontype = "client",
    functionParameters = false,
    functionName = "HD-appartments:client:enter:appartment",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if exports['HD-appartments']:IsNearHouse() then
                return true
            end
        end
  end,
 },
 [18] = {
    id = "depot",
    displayName = "Depot",
    icon = "#global-depot",
    close = true,
    functiontype = "client",
    functionParameters = false,
    functionName = "HD-garages:client:open:depot",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if exports['HD-garages']:IsNearDepot() then
                return true
            end
        end
  end,
 },
 [19] = {
    id = "housing",
    displayName = "Go Inside",
    icon = "#global-appartment",
    close = true,
    functiontype = "client",
    functionParameters = false,
    functionName = "HD-housing:client:enter:house",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if exports['HD-housing']:EnterNearHouse() then
                return true
            end
        end
  end,
 },
 [20] = {
    id = "housing-options",
    displayName = "House Options",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if exports['HD-housing']:HasEnterdHouse() then
                return true
            end
        end
    end,
    subMenus = {"house:setstash", "house:setlogout", "house:setclothes", "house:givekey", "house:decorate" }
 },
 [21] = {
    id = "judge-actions",
    displayName = "Judge",
    icon = "#judge-actions",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() and HDCore.Functions.GetPlayerData().job.name == 'judge' then
            return true
        end
    end,
    subMenus = {"judge:tablet", "judge:job", "police:tablet"}
 },
 [22] = {
    id = "ambulance-garage",
    displayName = "Ambulance Garage",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() and HDCore.Functions.GetPlayerData().job.name == 'ambulance' and HDCore.Functions.GetPlayerData().job.onduty then
            if exports['HD-hospital']:NearGarage() then
                return true
            end
        end
    end,
    subMenus = {"ambulance:garage:sprinter", "ambulance:garage:touran", "ambulance:garage:heli", "vehicle:delete"}
 },
 [23] = {
    id = "scrapyard",
    displayName = "Scrap Vehicle",
    icon = "#police-action-vehicle-spawn",
    close = true,
    functiontype = "client",
    functionName = "HD-materials:client:scrap:vehicle",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
          if exports['HD-materials']:IsNearScrapYard() then
            return true
          end
        end
  end,
 },
 [24] = {
    id = "trash",
    displayName = "Trashbins",
    icon = "#global-trash",
    close = true,
    functiontype = "client",
    functionName = "HD-materials:client:search:trash",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
          if exports['HD-materials']:GetBinStatus() then
            return true
          end
        end
  end,
 },
  [25] = {
    id = "cityhall",
    displayName = "Cityhall",
    icon = "#global-cityhall",
    close = true,
    functiontype = "client",
    functionName = "HD-cityhall:client:open:nui",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if exports['HD-cityhall']:CanOpenCityHall() then
                return true
            end
        end
  end,
 },
 [26] = {
    id = "dealer",
    displayName = "Dealer",
    icon = "#global-dealer",
    close = true,
    functiontype = "client",
    functionName = "HD-dealers:client:open:dealer",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if exports['HD-dealers']:CanOpenDealerShop() then
                return true
            end
        end
  end,
 },
 [27] = {
    id = "traphouse",
    displayName = "Traphouse",
    icon = "#global-appartment",
    close = true,
    functiontype = "client",
    functionName = "HD-traphouse:client:enter",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if exports['HD-traphouse']:CanPlayerEnterTraphouse() then
                return true
            end
        end
  end,
 },
 [28] = {
    id = "tow-menu",
    displayName = "Tow",
    icon = "#citizen-action-garage",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() and HDCore.Functions.GetPlayerData().job.name == 'tow' then
            return true
        end
    end,
    subMenus = {"tow:hook", "tow:npc"}
--  },
--  [29] = {
--     id = "police-impound",
--     displayName = "Police Impound",
--     icon = "#citizen-action-garage",
--     enableMenu = function()
--         if not exports['HD-hospital']:GetDeathStatus() then
--             if exports['HD-police']:GetImpoundStatus() then
--                 return true
--             end
--         end
--     end,
--     subMenus = {}
 },
 [29] = {
    id = "taxi",
    displayName = "Taxi",
    icon = "#taxi-action",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() and HDCore.Functions.GetPlayerData().job.name == 'taxi' and HDCore.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"taxi:togglemeter", "taxi:start", "taxi:npcmission"}
 },
 [30] = {
    id = "cuff",
    displayName = "Cuff",
    icon = "#citizen-action-cuff",
    close = true,
    functiontype = "client",
    functionName = "HD-police:client:cuff:closest",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() and HasHandCuffs then
          return true
        end
  end,
 },
 [31] = {
    id = "recycle",
    displayName = "Recycle",
    icon = "#global-doors",
    close = true,
    functiontype = "client",
    functionName = "HD-recycle:openrecycle",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if exports['HD-recycle']:RecycleStatus() then
                return true
            end
        end
  end,
 },
 [32] = {
    id = "mechanic",
    displayName = "Mechanic",
    icon = "#citizen-action-vehicle",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() and HDCore.Functions.GetPlayerData().job.name == 'mechanic' and HDCore.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"mechanic:repair"}
 },
 [33] = {
    id = "police",
    displayName = "Radio",
    icon = "#police-radio-channel",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() and HDCore.Functions.GetPlayerData().job.name == 'police' and HDCore.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"police:radio:one", "police:radio:two", "police:radio:three", "police:radio:four", "police:radio:five"}
 },
 [34] = {
    id = "boat",
    displayName = "Depot",
    icon = "#global-boat",
    close = true,
    functiontype = "client",
    functionParameters = false,
    functionName = "HD-garages:client:open:depot",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            if exports['HD-garages']:IsNearBoatDepot() then
                return true
            end
        end
  end,
 },
 [35] = {
    id = "blips",
    displayName = "Blips",
    icon = "#global-blips",
    enableMenu = function()
        if not exports['HD-hospital']:GetDeathStatus() then
            return true
        end
    end,
    subMenus = {"blips:tattooshop", "blips:barbershop", "blips:clothing", "blips:deleteblips"}
 },
--  [36] = {
--     id = "police-camera",
--     displayName = "Camera",
--     icon = "#police-cameras",
--     close = true,
--     functiontype = "",
--     functionParameters = '',
--     functionName = "",
--     enableMenu = function()
--         if HDCore.Functions.GetPlayerData().job.name == 'police' and HDCore.Functions.GetPlayerData().job.onduty then
--             return true
--         end
--     end,
--     subMenus = {"camera:een", "camera:twee", "camera:drie", "camera:vier", "camera:vijf"}
--  },

[36] = {
    id = "police-cameraz",
    displayName = "Camera",
    icon = "#police-cameras",
    enableMenu = function()
        if HDCore.Functions.GetPlayerData().job.name == 'police' and HDCore.Functions.GetPlayerData().job.onduty then
            return true
        end
    end,
    subMenus = {"camera:een", "camera:twee", "camera:drie", "camera:vier", "camera:vijf", "camera:zes", "camera:zeven", "camera:acht", "camera:negen", "camera:tien", "camera:11", "camera:12", "camera:13", "camera:14", "camera:15", "camera:17", "camera:18", "camera:19", "camera:20", "camera:21", "camera:22", "camera:23", "camera:24", "camera:25", "camera:26", "camera:27", "camera:28", "camera:29", "camera:30"}
 },
 [37] = {
     id = "global-makelaar",
     displayName = "Makelaar",
     icon = "#global-makelaar",
     enableMenu = function()
         if HDCore.Functions.GetPlayerData().job.name == 'realestate' then
             return true
         end
     end,
     subMenus = {"makelaar:blips", "makelaar:duty"}
  },
}

Config.SubMenus = {
    ["makelaar:blips"] = {
        title = "Blips",
        icon = "makelaar-blips",
        close = true,
        functiontype = "client",
        functionName = "ToggleHouseBlips",
        -- functionParameters = true,
    },
    ["makelaar:duty"] = {
        title = "Dienstklokker",
        icon = "makelaar-duty",
        close = true,
        functiontype = "client",
        functionName = "HD-housing:client:duty:checker",
        -- functionParameters = true,
    },
    ["camera:een"] = {
        title = "Camera 1",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
        functionParameters = 1,
    },

    ["camera:twee"] = {
        title = "Camera 2",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",

        functionParameters = 2,
    },
    
    ["camera:drie"] = {
        title = "Camera 3",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",

        functionParameters = 3,
    },
  
    ["camera:vier"] = {
        title = "Camera 4",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",

        functionParameters = 4,
    },

    ["camera:vijf"] = {
        title = "Camera 5",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 5,
    },

    ["camera:zes"] = {
        title = "Camera 6",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 6,
    },
    
    ["camera:zeven"] = {
        title = "Camera 7",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 7,
    },
    
    ["camera:acht"] = {
        title = "Camera 8",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 8,
    },
    
    ["camera:negen"] = {
        title = "Camera 9",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 9,
    },
    
    ["camera:tien"] = {
        title = "Camera 10",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 10,
    },
    
    ["camera:11"] = {
        title = "Camera 11",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 11,
    },
    
    ["camera:12"] = {
        title = "Camera 12",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 12,
    },
    
    ["camera:13"] = {
        title = "Camera 13",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 13,
    },
    
    ["camera:14"] = {
        title = "Camera 14",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 14,
    },
    
    ["camera:15"] = {
        title = "Camera 15",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 15,
    },
    
    ["camera:16"] = {
        title = "Camera 16",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 16,
    },
    ["camera:17"] = {
        title = "Camera 17",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 17,
    },
    ["camera:18"] = {
        title = "Camera 18",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 18,
    },
    ["camera:19"] = {
        title = "Camera 19",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 19,
    },
    
    ["camera:20"] = {
        title = "Camera 20",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 20,
    },
    
    ["camera:21"] = {
        title = "Camera 21",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 21,
    },
    
    ["camera:22"] = {
        title = "Camera 22",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 22,
    },
    
    ["camera:23"] = {
        title = "Camera 23",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 23,
    },
    
    ["camera:24"] = {
        title = "Camera 24",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 24,
    },
    
    ["camera:25"] = {
        title = "Camera 25",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 25,
    },
    
    ["camera:26"] = {
        title = "Camera 26",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 26,
    },
    
    ["camera:27"] = {
        title = "Camera 27",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 27,
    },
    
    ["camera:28"] = {
        title = "Camera 28",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 28,
    },
    
    ["camera:29"] = {
        title = "Camera 29",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 29,
    },
    
    ["camera:30"] = {
        title = "Camera 30",
        icon = "police-camera",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:CameraCommand",
   
        functionParameters = 30,
    },

    --blips
    ["blips:tattooshop"] = {
        title = "Tattooshop",
        icon = "global-tattoo",
        close = true,
        functiontype = "client",
        functionName = "HD-radialmenu:client:tattooshop",
    },

    ["blips:barbershop"] = {
        title = "Barber",
        icon = "#global-kapper",
        close = true,
        functiontype = "client",
        functionName = "HD-radialmenu:client:barbershop",
    },
    ["blips:garage"] = {
        title = "Garage",
        icon = "global-garage",
        close = true,
        functiontype = "client",
        functionName = "HD-radialmenu:client:garage",
    },
    ["blips:gas"] = {
        title = "Gas Station",
        icon = "global-gas",
        close = true,
        functiontype = "client",
        functionName = "HD-radialmenu:client:benzine",
    },
    ["blips:clothing"] = {
        title = "Clothing Store",
        icon = "global-kleren",
        close = true,
        functiontype = "client",
        functionName = "HD-radialmenu:client:clothing",
    },
    
    ['favo:radio:one'] = {
        title = "Fav. Radio",
        icon = "#player-radio-channel",
        close = true,
        functiontype = "client",
        functionName = "HD-radialmenu:client:enter:playerradio"
       },
    ['police:radio:one'] = {
        title = "Radio #1",
        icon = "#police-radio",
        close = true,
        functionParameters = 1,
        functiontype = "client",
        functionName = "HD-radialmenu:client:enter:radio"
       },
       ['police:radio:two'] = {
        title = "Radio #2",
        icon = "#police-radio",
        close = true,
        functionParameters = 2,
        functiontype = "client",
        functionName = "HD-radialmenu:client:enter:radio"
       },
       ['police:radio:three'] = {
        title = "Radio #3",
        icon = "#police-radio",
        close = true,
        functionParameters = 3,
        functiontype = "client",
        functionName = "HD-radialmenu:client:enter:radio"
       },
       ['police:radio:four'] = {
        title = "Radio #4",
        icon = "#police-radio",
        close = true,
        functionParameters = 4,
        functiontype = "client",
        functionName = "HD-radialmenu:client:enter:radio"
       },
       ['police:radio:five'] = {
        title = "Radio #5",
        icon = "#police-radio",
        close = true,
        functionParameters = 5,
        functiontype = "client",
        functionName = "HD-radialmenu:client:enter:radio"
       },
    ["taxi:togglemeter"] = {
        title = "Show/Hide Meter",
        icon = "#taxi-meter",
        close = true,
        functiontype = "client",
        functionName = "HD-taxi:client:toggleMeter",
    },
    ["taxi:start"] = {
        title = "Start/Stop Meter",
        icon = "#taxi-start",
        close = true,
        functiontype = "client",
        functionName = "HD-taxi:client:enableMeter",
    },
    ["taxi:npcmission"] = {
        title = "Toggle NPC",
        icon = "#taxi-npc",
        close = true,
        functiontype = "client",
        functionName = "HD-taxi:client:DoTaxiNpc",
    },
    ['police:checkstatus'] = {
     title = "Check",
     icon = "#police-action-status",
     close = true,
     functiontype = "client",
     functionName = "HD-police:client:CheckStatus"
    },
    ['police:panic'] = {
     title = "Emergency",
     icon = "#police-action-panic",
     close = true,
     functiontype = "client",
     functionName = "HD-radialmenu:client:send:panic:button"
    },
    ['police:tablet'] = {
     title = "MEOS Tablet",
     icon = "#police-action-tablet",
     close = true,
     functiontype = "client",
     functionName = "HD-police:client:show:tablet"
    },
    ['police:impound'] = {
     title = "Delete Vehicle",
     icon = "#police-action-vehicle",
     close = true,
     functiontype = "client",
     functionName = "HD-police:client:impound:closest"
    },
    ['police:impoundhard'] = {
        title = "Impound",
        icon = "#police-action-vehicle",
        close = true,
        functiontype = "client",
        functionName = "HD-police:client:impound:hard:closest"
       },
    ['police:search'] = {
     title = "Frisk",
     icon = "#police-action-search",
     close = true,
     functiontype = "client",
     functionName = "HD-police:client:search:closest"
    },
    ['police:resetdoor'] = {
     title = "Reset Door",
     icon = "#global-appartment",
     close = true,
     functiontype = "client",
     functionName = "HD-housing:client:reset:house:door"
    },
    ['police:enkelband'] = {
     title = "Location",
     icon = "#police-action-enkelband",
     close = true,
     functiontype = "client",
     functionName = "HD-police:client:enkelband:closest"
    },
    -- ['police:vehicle:touran'] = {
    --     title = "Police Touran",
    --     icon = "#police-action-vehicle-spawn",
    --     close = true,
    --     functionParameters = 'PolitieTouran',
    --     functiontype = "client",
    --     functionName = "HD-police:client:spawn:vehicle"
    --    },
    --    ['police:vehicle:klasse'] = {
    --     title = "Police B-Klasse",
    --     icon = "#police-action-vehicle-spawn",
    --     close = true,
    --     functionParameters = 'PolitieKlasse',
    --     functiontype = "client",
    --     functionName = "HD-police:client:spawn:vehicle"
    --    },
    --    ['police:vehicle:vito'] = {
    --     title = "Police Vito",
    --     icon = "#police-action-vehicle-spawn-bus",
    --     close = true,
    --     functionParameters = 'PolitieVito',
    --     functiontype = "client",
    --     functionName = "HD-police:client:spawn:vehicle"
    --    },
    --    ['police:vehicle:audi'] = {
    --     title = "Police Audi",
    --     icon = "#police-action-vehicle-spawn",
    --     close = true,
    --     functionParameters = 'PolitieRS6',
    --     functiontype = "client",
    --     functionName = "HD-police:client:spawn:vehicle"
    --    },
    --    ['police:vehicle:velar'] = {
    --     title = "Police Unmarked Velar",
    --     icon = "#police-action-vehicle-spawn",
    --     close = true,
    --     functionParameters = 'PolitieVelar',
    --     functiontype = "client",
    --     functionName = "HD-police:client:spawn:vehicle"
    --    },
    --    ['police:vehicle:bmw'] = {
    --     title = "Police Unmarked M5",
    --     icon = "#police-action-vehicle-spawn",
    --     close = true,
    --     functionParameters = 'PolitieBmw',
    --     functiontype = "client",
    --     functionName = "HD-police:client:spawn:vehicle"
    --    },
    --    ['police:vehicle:unmaked:audi'] = {
    --     title = "Police Unmarked A6",
    --     icon = "#police-action-vehicle-spawn",
    --     close = true,
    --     functionParameters = 'PolitieAudiUnmarked',
    --     functiontype = "client",
    --     functionName = "HD-police:client:spawn:vehicle"
    --    },
    --    ['police:vehicle:heli'] = {
    --     title = "Police Zulu",
    --     icon = "#police-action-vehicle-spawn-heli",
    --     close = true,
    --     functionParameters = 'PolitieZulu',
    --     functiontype = "client",
    --     functionName = "HD-police:client:spawn:vehicle"
    --    },
    --    ['police:vehicle:motor'] = {
    --     title = "Police Motor",
    --     icon = "#police-action-vehicle-spawn-motor",
    --     close = true,
    --     functionParameters = 'PolitieMotor',
    --     functiontype = "client",
    --     functionName = "HD-police:client:spawn:vehicle"
    --    },
    ['police:vehicle:touran'] = {
     title = "Volkswagen Touran",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'ptouran',
     functiontype = "client",
     functionName = "HD-police:client:spawn:vehicle"
    },
    ['police:vehicle:klasse'] = {
     title = "Mercedes B-Klasse",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'pbklasse',
     functiontype = "client",
     functionName = "HD-police:client:spawn:vehicle"
    },
    ['police:vehicle:vito'] = {
     title = "Volkswagen Amarok",
     icon = "#police-action-vehicle-spawn-bus",
     close = true,
     functionParameters = 'pamarok',
     functiontype = "client",
     functionName = "HD-police:client:spawn:vehicle"
    },
    ['police:vehicle:phyun'] = {
     title = "Kia Niro",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'pniro',
     functiontype = "client",
     functionName = "HD-police:client:spawn:vehicle"
    },
    ['police:vehicle:audi'] = {
     title = "Audi A6",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'paudi',
     functiontype = "client",
     functionName = "HD-police:client:spawn:vehicle"
    },
    ['police:vehicle:velar'] = {
     title = "Oracle Unmarked",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'poracle',
     functiontype = "client",
     functionName = "HD-police:client:spawn:vehicle"
    },
    ['police:vehicle:bmw'] = {
     title = "Masertati Unmarked",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'pmas',
     functiontype = "client",
     functionName = "HD-police:client:spawn:vehicle"
    },
    ['police:vehicle:dsimerc'] = {
     title = "Mercedes (DSI)",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'dsimerc',
     functiontype = "client",
     functionName = "HD-police:client:spawn:vehicle"
    },
    ['police:vehicle:pyamahamotor'] = {
     title = "Yamaha Motor",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'pyamahamotor',
     functiontype = "client",
     functionName = "HD-police:client:spawn:vehicle"
    },
    ['police:vehicle:dsimerc'] = {
     title = "Mercedes (DSI)",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'dsimerc',
     functiontype = "client",
     functionName = "HD-police:client:spawn:vehicle"
    },
    ['police:vehicle:unmaked:audi'] = {
     title = "Unmarked Golf 7",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'pgolf7',
     functiontype = "client",
     functionName = "HD-police:client:spawn:vehicle"
    },
    ['police:vehicle:heli'] = {
     title = "Zulu",
     icon = "#police-action-vehicle-spawn-heli",
     close = true,
     functionParameters = 'pzulu',
     functiontype = "client",
     functionName = "HD-police:client:spawn:vehicle"
    },
    ['police:vehicle:motor'] = {
     title = "BMW Motor",
     icon = "#police-action-vehicle-spawn-motor",
     close = true,
     functionParameters = 'pbmwmotor2',
     functiontype = "client",
     functionName = "HD-police:client:spawn:vehicle"
    },
    ['police:object:cone'] = {
     title = "Pion",
     icon = "#global-box",
     close = true,
     functionParameters = 'cone',
     functiontype = "client",
     functionName = "HD-police:client:spawn:object"
    },
    ['police:object:barrier'] = {
     title = "Barrier",
     icon = "#global-box",
     close = true,
     functionParameters = 'barrier',
     functiontype = "client",
     functionName = "HD-police:client:spawn:object"
    },
    ['police:object:schot'] = {
     title = "Gate",
     icon = "#global-box",
     close = true,
     functionParameters = 'schot',
     functiontype = "client",
     functionName = "HD-police:client:spawn:object"
    },
    ['police:object:tent'] = {
     title = "Tent",
     icon = "#global-tent",
     close = true,
     functionParameters = 'tent',
     functiontype = "client",
     functionName = "HD-police:client:spawn:object"
    },
    ['police:object:light'] = {
     title = "Lamps",
     icon = "#global-box",
     close = true,
     functionParameters = 'light',
     functiontype = "client",
     functionName = "HD-police:client:spawn:object"
    },
    ['police:object:delete'] = {
     title = "Delete Object",
     icon = "#global-delete",
     close = false,
     functiontype = "client",
     functionName = "HD-police:client:delete:object"
    },
    ['ambulance:heal'] = {
      title = "Heal",
      icon = "#ambulance-action-heal",
      close = true,
      functiontype = "client",
      functionName = "HD-hospital:client:heal:closest"
    },
    ['ambulance:revive'] = {
      title = "Revive",
      icon = "#ambulance-action-heal",
      close = true,
      functiontype = "client",
      functionName = "HD-hospital:client:revive:closest"
    },
    ['ambulance:blood'] = {
      title = "Take Bloodsample",
      icon = "#ambulance-action-blood",
      close = true,
      functiontype = "client",
      functionName = "HD-hospital:client:take:blood:closest"
    },
    ['ambulance:garage:heli'] = {
      title = "Ambulance Heli",
      icon = "#police-action-vehicle-spawn",
      close = true,
      functionParameters = 'alifeliner',
      functiontype = "client",
      functionName = "HD-hospital:client:spawn:vehicle"
    },
    ['ambulance:garage:touran'] = {
     title = "Mercedes Klasse B",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'aeklasse',
     functiontype = "client",
     functionName = "HD-hospital:client:spawn:vehicle"
    },
    ['ambulance:garage:sprinter'] = {
     title = "Ambulance Sprinter",
     icon = "#police-action-vehicle-spawn",
     close = true,
     functionParameters = 'asprinter',
     functiontype = "client",
     functionName = "HD-hospital:client:spawn:vehicle"
    },
    ['vehicle:delete'] = {
     title = "Delete Vehicle",
     icon = "#police-action-vehicle-delete",
     close = true,
     functiontype = "client",
     functionName = "HDCore:Command:DeleteVehicle"
    },
    ['judge:tablet'] = {
     title = "Judge Tablet",
     icon = "#police-action-tablet",
     close = true,
     functiontype = "client",
     functionName = "HD-judge:client:toggle"
    },
    ['judge:job'] = {
     title = "Rent lawyer",
     icon = "#judge-actions",
     close = true,
     functiontype = "client",
     functionName = "HD-judge:client:lawyer:add:closest"
    },
    ['citizen:contact'] = {
     title = "Share Contact",
     icon = "#citizen-contact",
     close = true,
     functiontype = "client",
     functionName = "HD-phone:client:GiveContactDetails"
    },
    ['citizen:escort'] = {
     title = "Escort",
     icon = "#citizen-action-escort",
     close = true,
     functiontype = "client",
     functionName = "HD-police:client:escort:closest"
    },
    ['citizen:steal'] = {
     title = "Rob",
     icon = "#citizen-action-steal",
     close = true,
     functiontype = "client",
     functionName = "HD-police:client:steal:closest"
    },
    ['citizen:vehicle:getout'] = {
     title = "Out Vehicle",
     icon = "#citizen-put-out-veh",
     close = true,
     functiontype = "client",
     functionName = "HD-police:client:SetPlayerOutVehicle"
    },
    ['citizen:vehicle:getin'] = {
     title = "In Vehicle",
     icon = "#citizen-put-in-veh",
     close = true,
     functiontype = "client",
     functionName = "HD-police:client:PutPlayerInVehicle"
    },
    ['vehicle:flip'] = {
     title = "Flip Vehicle",
     icon = "#citizen-action-vehicle",
     close = true,
     functiontype = "client",
     functionName = "HD-radialmenu:client:flip:vehicle"
    },
    ['vehicle:key'] = {
     title = "Give Keys",
     icon = "#citizen-action-vehicle-key",
     close = true,
     functiontype = "client",
     functionName = "HD-vehiclekeys:client:give:key"
    },

    ['vehicle:door:left:front'] = {
     title = "Front Left",
     icon = "#global-arrow-left",
     close = true,
     functionParameters = 0,
     functiontype = "client",
     functionName = "HD-radialmenu:client:open:door"
    },
    ['vehicle:door:motor'] = {
     title = "Bonnet",
     icon = "#global-arrow-up",
     close = true,
     functionParameters = 4,
     functiontype = "client",
     functionName = "HD-radialmenu:client:open:door"
    },
    ['vehicle:door:right:front'] = {
     title = "Front Right",
     icon = "#global-arrow-right",
     close = true,
     functionParameters = 1,
     functiontype = "client",
     functionName = "HD-radialmenu:client:open:door"
    },
    ['vehicle:door:right:back'] = {
     title = "Rear Right",
     icon = "#global-arrow-right",
     close = true,
     functionParameters = 3,
     functiontype = "client",
     functionName = "HD-radialmenu:client:open:door"
    },
    ['vehicle:door:trunk'] = {
     title = "Trunk",
     icon = "#global-arrow-down",
     close = true,
     functionParameters = 5,
     functiontype = "client",
     functionName = "HD-radialmenu:client:open:door"
    },
    ['vehicle:door:left:back'] = {
     title = "Rear Left",
     icon = "#global-arrow-left",
     close = true,
     functionParameters = 2,
     functiontype = "client",
     functionName = "HD-radialmenu:client:open:door"
    },
    ["mechanic:repair"] = {
        title = "Repair",
        icon = "#citizen-action-vehicle",
        close = true,
        functiontype = "client",
        functionName = "HD-repair:client:triggerMenu",
    },
    ['tow:hook'] = {
     title = "Tow Vehicle",
     icon = "#citizen-action-vehicle",
     close = true,
     functiontype = "client",
     functionName = "HD-tow:client:hook:car"
    },
    ['tow:npc'] = {
     title = "Toggle NPC",
     icon = "#citizen-action",
     close = true,
     functiontype = "client",
     functionName = "HD-tow:client:toggle:npc"
    },
    ['citizen:corner:selling'] = {
        title = "Cornersell",
        icon = "#citizen-action-cornerselling",
        close = true,
        functiontype = "client",
        functionName = "HD-illegal:client:toggle:corner:selling"
       },
    ['garage:putin'] = {
     title = "In Garage",
     icon = "#citizen-put-in-veh",
     close = true,
     functiontype = "client",
     functionName = "HD-garages:client:check:owner"
    },
    ['garage:getout'] = {
     title = "Out Garage",
     icon = "#citizen-put-out-veh",
     close = true,
     functiontype = "client",
     functionName = "HD-garages:client:set:vehicle:out:garage"
    }, 
    ['house:setstash'] = {
     title = "Set Stash",
     icon = "#citizen-put-out-veh",
     close = true,
     functionParameters = 'stash',
     functiontype = "client",
     functionName = "HD-housing:client:set:location"
    },
    ['house:setlogout'] = {
     title = "Set Logout",
     icon = "#citizen-put-out-veh",
     close = true,
     functionParameters = 'logout',
     functiontype = "client",
     functionName = "HD-housing:client:set:location"
    },
    ['house:setclothes'] = {
     title = "Set Closet",
     icon = "#citizen-put-out-veh",
     close = true,
     functionParameters = 'clothes',
     functiontype = "client",
     functionName = "HD-housing:client:set:location"
    },
    ['house:givekey'] = {
     title = "Give Keys",
     icon = "#citizen-action-vehicle-key",
     close = true,
     functiontype = "client",
     functionName = "HD-housing:client:give:keys"
    },
    ['house:decorate'] = {
     title = "Decorate",
     icon = "#global-box",
     close = true,
     functiontype = "client",
     functionName = "HD-housing:client:decorate"
    },
    -- // Anims and Expression \\ --
    ['animations:brave'] = {
        title = "Brave",
        icon = "#animation-brave",
        close = true,
        functionName = "AnimSet:Brave",
        functiontype = "client",
    },
    ['animations:hurry'] = {
        title = "Hurry",
        icon = "#animation-hurry",
        close = true,
        functionName = "AnimSet:Hurry",
        functiontype = "client",
    },
    ['animations:business'] = {
        title = "Business",
        icon = "#animation-business",
        close = true,
        functionName = "AnimSet:Business",
        functiontype = "client",
    },
    ['animations:tipsy'] = {
        title = "Tipsy",
        icon = "#animation-tipsy",
        close = true,
        functionName = "AnimSet:Tipsy",
        functiontype = "client",
    },
    ['animations:injured'] = {
        title = "Injured",
        icon = "#animation-injured",
        close = true,
        functionName = "AnimSet:Injured",
        functiontype = "client",
    },
    ['animations:tough'] = {
        title = "Tough",
        icon = "#animation-tough",
        close = true,
        functionName = "AnimSet:ToughGuy",
        functiontype = "client",
    },
    ['animations:sassy'] = {
        title = "Sassy",
        icon = "#animation-sassy",
        close = true,
        functionName = "AnimSet:Sassy",
        functiontype = "client",
    },
    ['animations:sad'] = {
        title = "Sad",
        icon = "#animation-sad",
        close = true,
        functionName = "AnimSet:Sad",
        functiontype = "client",
    },
    ['animations:posh'] = {
        title = "Posh",
        icon = "#animation-posh",
        close = true,
        functionName = "AnimSet:Posh",
        functiontype = "client",
    },
    ['animations:alien'] = {
        title = "Alien",
        icon = "#animation-alien",
        close = true,
        functionName = "AnimSet:Alien",
        functiontype = "client",
    },
    ['animations:nonchalant'] =
    {
        title = "Nonchalant",
        icon = "#animation-nonchalant",
        close = true,
        functionName = "AnimSet:NonChalant",
        functiontype = "client",
    },
    ['animations:hobo'] = {
        title = "Hobo",
        icon = "#animation-hobo",
        close = true,
        functionName = "AnimSet:Hobo",
        functiontype = "client",
    },
    ['animations:money'] = {
        title = "Money",
        icon = "#animation-money",
        close = true,
        functionName = "AnimSet:Money",
        functiontype = "client",
    },
    ['animations:swagger'] = {
        title = "Swagger",
        icon = "#animation-swagger",
        close = true,
        functionName = "AnimSet:Swagger",
        functiontype = "client",
    },
    ['animations:shady'] = {
        title = "Shady",
        icon = "#animation-shady",
        close = true,
        functionName = "AnimSet:Shady",
        functiontype = "client",
    },
    ['animations:maneater'] = {
        title = "Man Eater",
        icon = "#animation-maneater",
        close = true,
        functionName = "AnimSet:ManEater",
        functiontype = "client",
    },
    ['animations:chichi'] = {
        title = "ChiChi",
        icon = "#animation-chichi",
        close = true,
        functionName = "AnimSet:ChiChi",
        functiontype = "client",
    },
    ['animations:default'] = {
        title = "Default",
        icon = "#animation-default",
        close = true,
        functionName = "AnimSet:default",
        functiontype = "client",
    },
    ["expressions:angry"] = {
        title="Angry",
        icon="#expressions-angry",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_angry_1" },
        functiontype = "client",
    },
    ["expressions:drunk"] = {
        title="Drunk",
        icon="#expressions-drunk",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_drunk_1" },
        functiontype = "client",
    },
    ["expressions:dumb"] = {
        title="Dumb",
        icon="#expressions-dumb",
        close = true,
        functionName = "expressions",
        functionParameters =  { "pose_injured_1" },
        functiontype = "client",
    },
    ["expressions:electrocuted"] = {
        title="Electrocuted",
        icon="#expressions-electrocuted",
        close = true,
        functionName = "expressions",
        functionParameters =  { "electrocuted_1" },
        functiontype = "client",
    },
    ["expressions:grumpy"] = {
        title="Grumpy",
        icon="#expressions-grumpy",
        close = true,
        functionName = "expressions", 
        functionParameters =  { "mood_drivefast_1" },
        functiontype = "client",
    },
    ["expressions:happy"] = {
        title="Happy",
        icon="#expressions-happy",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_happy_1" },
        functiontype = "client",
    },
    ["expressions:injured"] = {
        title="Injured",
        icon="#expressions-injured",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_injured_1" },
        functiontype = "client",
    },
    ["expressions:joyful"] = {
        title="Joyful",
        icon="#expressions-joyful",
        close = true,
        functionName = "expressions",
        functionParameters =  { "mood_dancing_low_1" },
        functiontype = "client",
    },
    ["expressions:mouthbreather"] = {
        title="Mouthbreather",
        icon="#expressions-mouthbreather",
        close = true,
        functionName = "expressions",
        functionParameters = { "smoking_hold_1" },
        functiontype = "client",
    },
    ["expressions:normal"]  = {
        title="Normal",
        icon="#expressions-normal",
        close = true,
        functionName = "expressions:clear",
        functiontype = "client",
    },
    ["expressions:oneeye"]  = {
        title="One Eye",
        icon="#expressions-oneeye",
        close = true,
        functionName = "expressions",
        functionParameters = { "pose_aiming_1" },
        functiontype = "client",
    },
    ["expressions:shocked"]  = {
        title="Shocked",
        icon="#expressions-shocked",
        close = true,
        functionName = "expressions",
        functionParameters = { "shocked_1" },
        functiontype = "client",
    },
    ["expressions:sleeping"]  = {
        title="Sleeping",
        icon="#expressions-sleeping",
        close = true,
        functionName = "expressions",
        functionParameters = { "dead_1" },
        functiontype = "client",
    },
    ["expressions:smug"]  = {
        title="Smug",
        icon="#expressions-smug",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_smug_1" },
        functiontype = "client",
    },
    ["expressions:speculative"]  = {
        title="Speculative",
        icon="#expressions-speculative",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_aiming_1" },
        functiontype = "client",
    },
    ["expressions:stressed"]  = {
        title="Stressed",
        icon="#expressions-stressed",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_stressed_1" },
        functiontype = "client",
    },
    ["expressions:sulking"]  = {
        title="Sulking",
        icon="#expressions-sulking",
        close = true,
        functionName = "expressions",
        functionParameters = { "mood_sulk_1" },
        functiontype = "client",
    },
    ["expressions:weird"]  = {
        title="Weird",
        icon="#expressions-weird",
        close = true,
        functionName = "expressions",
        functionParameters = { "effort_2" },
        functiontype = "client",
    },
    ["expressions:weird2"]  = {
        title="Weird 2",
        icon="#expressions-weird2",
        close = true,
        functionName = "expressions",
        functionParameters = { "effort_3" },
        functiontype = "client",
    },
    ['vehicle:extra'] = {
        title = "Extra1",
        icon = "#vehicle-plus",
        close = false,
        functionParameters = 1,
        functiontype = "client",
        functionName = "HD-radialmenu:client:setExtra"
    },
    ['vehicle:extra2'] = {
        title = "Extra2",
        icon = "#vehicle-plus",
        close = false,
        functionParameters = 2,
        functiontype = "client",
        functionName = "HD-radialmenu:client:setExtra"
    },   
    ['vehicle:extra3'] = {
        title = "Extra3",
        icon = "#vehicle-plus",
        close = false,
        functionParameters = 3,
        functiontype = "client",
        functionName = "HD-radialmenu:client:setExtra"
    },
    ['vehicle:extra4'] = {
        title = "Extra4",
        icon = "#vehicle-plus",
        close = false,
        functionParameters = 4,
        functiontype = "client",
        functionName = "HD-radialmenu:client:setExtra"
    },
}

RegisterNetEvent('HD-radialmenu:client:update:duty:vehicles')
AddEventHandler('HD-radialmenu:client:update:duty:vehicles', function()
    Config.Menu[11].subMenus = exports['HD-police']:GetVehicleList()
end)