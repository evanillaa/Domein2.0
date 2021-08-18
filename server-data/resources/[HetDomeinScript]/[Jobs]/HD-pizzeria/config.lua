Config = {}

Config.AllowedVehicles = {
   [1] = {model = "pizzascoot", label = "Pizza scooter"}
}

Config.Locations = {
    ["vehicle"] = {
        ["x"] = 285.59,
        ["y"] = -962.37,
        ["z"] = 29.42,
        ["h"] = 89.41,
    },
	['Stash'] = { ['x'] = 296.99, ['y'] = -989.57, ['z'] = 29.43, ['h'] = 265.32 },
    ['Boss'] = {  ['x'] = 289.29, ['y'] = -989.45, ['z'] = 29.43, ['h'] = 95 },
    ['Duty'] = { ['x'] = 292.04, ['y'] = -980.98, ['z'] = 29.43, ['h'] = 358.81 }
}

Config.JobStart = {
	{ ["x"] = 290.06, ["y"] = -976.33, ["z"] = 29.43, ["h"] = 0 },
}

Config.JobStartGreen = {
	{ ["x"] = 288.53, ["y"] = -976.39, ["z"] = 29.43, ["h"] = 0 },
}

Config.PickUpStuff = {
	{ ["x"] = 929.48, ["y"] = -2308.08, ["z"] = 30.65, ["h"] = 0 },
}

Config.Paymentpizza = math.random(100, 140)

Config.JobBusy = false

Config.JobData = {
 ['pizzas'] = 0,
 ['register'] = 0,
 ['stock-lettuce'] = 0,
 ['stock-meat'] = 0,
 ['green-pizzas'] = 110,
 ['locations'] = {
    [1] = {
	  ['name'] = 'Lettuce',  --ijskast
	  x = 282.51,
	  y = -986.15,
	  z = 29.43,
	},
	[2] = {
	  ['name'] = 'Meat',  ---vleesbakken
	  x = 293.93,
	  y = -983.38,
	  z = 29.43,
	},
	[3] = {
	  ['name'] = 'Shell',   --oven
	  x = 282.85,
	  y = -974.9,
	  z = 29.43,
	},
	[4] = {
		['name'] = 'Register',  ---kassa
		x = 287.38,
		y = -977.99,
		z = 29.43,
	  },
	[5] = {
		['name'] = 'Givepizza',
		x = 290.09,
		y = -977.91,
		z = 29.43,
	  },
	  [6] = {
		['name'] = 'Stock',  --vooraad
		x = 292.13,
		y = -984.85,
		z = 29.43,
	  },
  },
}