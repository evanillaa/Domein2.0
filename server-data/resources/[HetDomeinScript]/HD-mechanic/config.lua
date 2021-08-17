Config = {}

Config.AttachedVehicle = nil

Config.Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config.AuthorizedIds = {
    "JAN93432", -- Kmotion
    "ZDP10940", -- Lester
    "KPC55666", -- Simon
}

Config.MaxStatusValues = {
    ["engine"] = 1000.0,
    ["body"] = 1000.0,
    ["radiator"] = 100,
    ["axle"] = 100,
    ["brakes"] = 100,
    ["clutch"] = 100,
    ["fuel"] = 100,
}

Config.ValuesLabels = {
    ["engine"] = "Motor",
    ["body"] = "Carrosserie",
    ["radiator"] = "Radiator",
    ["axle"] = "Aandrijfas",
    ["brakes"] = "Remmen",
    ["clutch"] = "Schakelbak",
    ["fuel"] = "Brandstoftank",
}

Config.RepairCost = {
    ["body"] = "plastic",
    ["radiator"] = "plastic",
    ["axle"] = "steel",
    ["brakes"] = "iron",
    ["clutch"] = "aluminum",
    ["fuel"] = "plastic",
}

Config.RepairCostAmount = {
    ["engine"] = {
        item = "metalscrap",
        costs = 2,
    },
    ["body"] = {
        item = "plastic",
        costs = 3,
    },
    ["radiator"] = {
        item = "steel",
        costs = 5,
    },
    ["axle"] = {
        item = "aluminum",
        costs = 7,
    },
    ["brakes"] = {
        item = "copper",
        costs = 5,
    },
    ["clutch"] = {
        item = "copper",
        costs = 6,
    },
    ["fuel"] = {
        item = "plastic",
        costs = 5,
    },
}

Config.Businesses = {
    "cykarepairs",
}

Config.Plates = {
    [1] = {
        coords = {x = -1423.64, y = -449.92, z = 35.82, h = 35.82, r = 1.0},
        AttachedVehicle = nil,
    },
    [2] = {
        coords = {x = -1417.47, y = -445.67, z = 35.82, h = 32.97, r = 1.0}, 
        AttachedVehicle = nil,
    },
    [3] = {
        coords = {x = -1411.38, y = -442.37, z = 35.82, h = 32.96, r = 1.0}, 
        AttachedVehicle = nil,
    },
    [4] = {
        coords = {x = 61.1, y = -2578.41, z = 6.34, h = 179.26, r = 1.0}, 
        AttachedVehicle = nil,
    },
}

Config.Locations = {
    ["exit"] = {x = -1431.6, y = -450.24, z = 35.91, h = 36.67, r = 1.0},
    ["stash"] = {x = -1418.6, y = -454.52, z = 35.91, h = 221.36, r = 1.0},
    ["duty"] = {x = -1427.6, y = -458.47, z = 35.91, h = 276.2, r = 1.0},
    ["vehicle"] = {x = -1399.26, y = -457.27, z = 34.49, h = 287.74, r = 1.0},                              
    ["drift"] = {x = -134.73, y = -2454.4, z = 6.02, h = 151.66, r = 1.0},
    ["driftstash"] = {x = 55.85, y = -2583.19, z = 6.26, h = 181.59, r = 1.0},     
}

Config.Vehicles = {
    ["flatbed3"] = "Flatbed",
    ["fastsigna"] = "Mercedes signa",
    ["hiluxfast"] = "toyota 4x4",
    ["minivan"] = "Minivan - Leenauto",
    ["blista"] = "Blista - Leenauto",
}

Config.drift = {
    ["bmwe"] = "BMW E46",  
    ["tampa2"] = "Driftauto",
    ["e36prb"] = "BMW E36", 
    ["gtr"] = "Nissan GTR",  
}

Config.MinimalMetersForDamage = {
    [1] = {
        min = 8000,
        max = 12000,
        multiplier = {
            min = 1,
            max = 8,
        }
    },
    [2] = {
        min = 12000,
        max = 16000,
        multiplier = {
            min = 8,
            max = 16,
        }
    },
    [3] = {
        min = 12000,
        max = 16000,
        multiplier = {
            min = 16,
            max = 24,
        }
    },
}

Config.Damages = {
    ["radiator"] = "Radiator",
    ["axle"] = "Aandrijfas",
    ["brakes"] = "Remmen",
    ["clutch"] = "Schakelbak",
    ["fuel"] = "Brandstoftank",
}