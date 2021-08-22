Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config = Config or {}

local StringCharset = {}
local NumberCharset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

Config.RandomStr = function(length)
	if length > 0 then
		return Config.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Config.RandomInt = function(length)
	if length > 0 then
		return Config.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

Config.Products = {
    [1] = {
        name = "weed_white-widow_seed",
        price = 15,
        amount = 150,
        info = {},
        type = "item",
        slot = 1,
        minrep = 125,
    },
    [2] = {
        name = "weed_skunk_seed",
        price = 15,
        amount = 150,
        info = {},
        type = "item",
        slot = 2,
        minrep = 150,
    },
    [3] = {
        name = "weed_purple-haze_seed",
        price = 15,
        amount = 150,
        info = {},
        type = "item",
        slot = 3,
        minrep = 175,
    },
    [4] = {
        name = "weed_og-kush_seed",
        price = 15,
        amount = 150,
        info = {},
        type = "item",
        slot = 4,
        minrep = 200,
    },
    [5] = {
        name = "weed_amnesia_seed",
        price = 15,
        amount = 150,
        info = {},
        type = "item",
        slot = 5,
        minrep = 225,
    },
}

Config.Dealers = {}

Config.CornerSellingDrugsList = {
    "weed_white-widow",
    "weed_skunk",
    "weed_purple-haze",
    "weed_og-kush",
    "weed_amnesia",
    "weed_ak47",
    --"cokebaggy",
    --"crack_baggy",
    --"xtcbaggy",
}

Config.DrugsPrice = {
    ["weed_white-widow"] = {
        min = 35,
        max = 50,
    },
    ["weed_og-kush"] = {
        min = 35,
        max = 50,
    },
    ["weed_skunk"] = {
        min = 25,
        max = 70,
    },
    ["weed_amnesia"] = {
        min = 30,
        max = 80,
    },
    ["weed_purple-haze"] = {
        min = 30,
        max = 80,
    },
    ["weed_ak47"] = {
        min = 50,
        max = 100,
    },
    --[[ ["cokebaggy"] = {
        min = 35,
        max = 75,
    }, ]]
}

Config.DeliveryLocations = {
    [1] = {
        ["label"] = "Vinewood Hills",
        ["coords"] = {
            ["x"] = -232.62,
            ["y"] = 588.13,
            ["z"] = 190.53,
        }
    },
    [2] = {
        ["label"] = "Vespucci Canals",
        ["coords"] = {
            ["x"] = -1104.09,
            ["y"] =-1060.02,
            ["z"] = 2.73,
        }
    },
    [3] = {
        ["label"] = "Orchardville Ave",
        ["coords"] = {
            ["x"] = 919.46,
            ["y"] = -2430.19,
            ["z"] = 28.42,
        }
    },
    [4] = {
        ["label"] = "El Burro Blvd",
        ["coords"] = {
            ["x"] = 1744.17,
            ["y"] = -1623.10,
            ["z"] = 112.64,
        }
    },
    [5] = {
        ["label"] = "Nikola Pl",
        ["coords"] = {
            ["x"] = 1380.58,
            ["y"] = -542.45,
            ["z"] = 74.49,
        }
    },
}

Config.CornerSellingZones = {
    [1] = {
        ["coords"] = {
            ["x"] = -1415.53,
            ["y"] = -1041.51,
            ["z"] = 4.62,
        },
        ["time"] = {
            ["min"] = 1,
            ["max"] = 24,
        },
    },
}

Config.DeliveryItems = {
    [1] = {
        ["item"] = "weed_brick",
        ["minrep"] = 0,
    },
}