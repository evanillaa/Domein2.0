Config = {}

Config.JobStart = {
	{ ["x"] = 5.35, ["y"] = -1605.19, ["z"] = -10.0, ["h"] = 0 },
}

Config.JobStartGreen = {
	{ ["x"] = 11.24, ["y"] = -1605.64, ["z"] = 29.39, ["h"] = 0 },
}

Config.PickUpStuff = {
	{ ["x"] = -48.86, ["y"] = -1750.29, ["z"] = 29.42, ["h"] = 0 },
}

Config.Stashes = {
    ["drinks"] = {x = 17.17, y = -1599.47, z = 29.38, h = 48.71, r = 1.0},
	["koelkast"] = {x = 13.47, y = -1596.17, z = 29.38, h = 48.71, r = 1.0},
	["tacos"] = {x = 11.49, y = -1598.84, z = 29.38, h = 48.71, r = 1.0},
    ["toonbank"] = {x = 12.92, y = -1600.3, z = 29.38, h = 62.96, r = 1.0},
}

Config.PaymentTaco = math.random(225, 275)

Config.LaundryChance = 500 -- Percentage chance of getting laundry money on the run. Multiplied by 100. 10% = 100, 20% = 200, 50% = 500, etc. Default 55%.
Config.PaymentLaundry = math.random(275, 325)

Config.JobBusy = false

Config.JobData = {
 ['tacos'] = 0,
 ['register'] = 0,
 ['stock-lettuce'] = 0,
 ['stock-meat'] = 0,
 ['green-tacos'] = 110,
 ['locations'] = {
    [1] = {
	  ['name'] = 'Lettuce', 
	  x = 13.47,
	  y = -1596.17,
	  z = -10.0,
	},
	[2] = {
	  ['name'] = 'Meat', 
	  x = 14.86,
	  y = -1596.73,
	  z = 29.38,
	},
	[3] = {
	  ['name'] = 'Shell', 
	  x = 16.11,
	  y = -1597.93,
	  z = 29.38,
	},
	[4] = {
		['name'] = 'Register', 
		x = 14.26,
		y = -1601.29,
		z = -10.0,
	  },
	[5] = {
		['name'] = 'GiveTaco', 
		x = 12.92,
		y = -1600.3,
		z = -10.00,
	  },
	  [6] = {
		['name'] = 'Stock', 
		x = 15.51,
		y = -1601.47,
		z = -10.0,
	  },
  },
}