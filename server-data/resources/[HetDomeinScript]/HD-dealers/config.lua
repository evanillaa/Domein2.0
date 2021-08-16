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



Config.Dealers = {
    [1] = {
        ['Name'] = 'Sally De Pil',
        ['Type'] = 'medic-dealer',
        ['Coords'] = {['X'] = -271.54, ['Y'] = 6320.75, ['Z'] = 32.43},
        ['Products'] = {
            [1] = {
                name = "painkillers",
                price = 450,
                amount = 50,
                resetamount = 50,
                info = {},
                type = "item",
                slot = 1,
            },
            [2] = {
                name = "health-pack",
                price = 4500,
                amount = 5,
                resetamount = 5,
                info = {},
                type = "item",
                slot = 2,
            },
        },
    },
    [2] = {
        ['Name'] = 'Robert Nesta', 
        ['Type'] = 'weed-dealer',
        ['Coords'] = {['X'] = 391.08, ['Y'] = -909.54, ['Z'] = 29.42},
        ['Products'] = {
            [1] = {
                name = "joint",
                price = 30,
                amount = 100,
                resetamount = 75,
                info = {},
                type = "item",
                slot = 1,
            },
            [2] = {
                name = "rolling-paper",
                price = 15,
                amount = 500,
                resetamount = 500,
                info = {},
                type = "item",
                slot = 2,
            },
            [3] = {
                name = "plastic-bag",
                price = 15,
                amount = 500,
                resetamount = 500,
                info = {},
                type = "item",
                slot = 3,
            },
            [4] = {
                name = "nutrition",
                price = 150,
                amount = 500,
                resetamount = 500,
                info = {},
                type = "item",
                slot = 4,
            },
        },
    },
    [3] = {
        ['Name'] = 'Peter Shank', 
        ['Type'] = 'weapon-dealer',
        ['Coords'] = {['X'] = -1202.32, ['Y'] = -2741.4, ['Z'] = 14.13},
        ['Products'] = {
            [1] = {
                name = "weapon_switchblade",
                price = 5500,
                amount = 10,
                resetamount = 10,
                info = {
                    quality = 100.0,
                },
                type = "weapon",
                slot = 1,
            },
        },
    },
    [4] = {
        ['Name'] = 'Tim de Klusser', 
        ['Type'] = 'weapon-dealer',
        ['Coords'] = {['X'] = 764.99, ['Y'] = -1359.1, ['Z'] = 27.88},
        ['Products'] = {
            [1] = {
                name = "weapon_wrench",
                price = 3500,
                amount = 10,
                resetamount = 10,
                info = {
                    quality = 100.0,
                },
                type = "weapon",
                slot = 1,
            },
            [2] = {
                name = "weapon_hammer",
                price = 3500,
                amount = 10,
                resetamount = 10,
                info = {
                    quality = 100.0,
                },
                type = "weapon",
                slot = 2,
            },
        },
    },
    -- [5] = {
    --     ['Name'] = 'Vladimir',
    --     ['Type'] = 'weapon-dealer',
    --     ['Coords'] = {['X'] = 844.57, ['Y'] = -2118.30, ['Z'] = 30.52},
    --     ['Products'] = {
    --         [1] = {
    --             name = "weapon_vintagepistol",
    --             price = 9500,
    --             amount = 2,
    --             resetamount = 2,
    --             info = {
    --                 serie = "",
    --                 quality = 100.0,
    --             },
    --             type = "weapon",
    --             slot = 1,
    --         },
    --         [2] = {
    --             name = "weapon_appistol",
    --             price = 17000,
    --             amount = 1,
    --             resetamount = 1,
    --             info = {
    --                 serie = "",
    --                 quality = 100.0,
    --             },
    --             type = "weapon",
    --             slot = 2,
    --         },
    --     },
    -- },
}

