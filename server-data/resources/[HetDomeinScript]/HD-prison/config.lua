Config = Config or {}

Config.Locale = "en"
Config.Locations = {
 ['Prison'] = {
   ['Coords'] = {['X'] = 1693.33, ['Y'] = 2569.51, ['Z'] = 45.55, ['H'] = nil},
 },
 ['Leave'] = {
    ['Coords'] = {['X'] = 1827.327, ['Y'] = 2589.771, ['Z'] = 45.89193, ['H'] = nil},
 },
 ['Shop'] = {
    ['Coords'] = {['X'] = 1781.072, ['Y'] = 2558.8918, ['Z'] = 45.673107, ['H'] = nil},
 },
 ['Inleveren'] = {
    ['Coords'] = {['X'] = 1786.1486, ['Y'] = 2564.238, ['Z'] = 45.673053, ['H'] = nil},
 },
 ["yard"] = {
    coords = {x = 1773.85, y = 2677.7, z = 45.61, h = 179.685},
},
["middle"] = {
    coords = {x = 1693.33, y = 2569.51, z = 45.55, h = 123.5},
},
['Jobs'] = {
   [1] = {
       ['Coords'] = {['X'] = 1689.1228, ['Y'] = 2554.2067, ['Z'] = 45.56, ['H'] = nil},
   },
   [2] = {
       ['Coords'] = {['X'] = 1688.8095, ['Y'] = 2550.3234, ['Z'] = 45.56, ['H'] = nil},
   },
},
 ['Search'] = {
    [1] = {
        ['Reward'] = 'shitlockpick',
        ['Chance'] = 10,
        ['Coords'] = {['X'] = 1671.597, ['Y'] = 2523.889, ['Z'] = 45.56491, ['H'] = nil},
    },
    [2] = {
        ['Reward'] = 'meth',
        ['Chance'] = 5,
        ['Coords'] = {['X'] = 1764.145, ['Y'] = 2572.728, ['Z'] = 49.73917, ['H'] = nil},
    },
    [3] = {
        ['Reward'] = 'slushy',
        ['Chance'] = 100,
        ['Coords'] = {['X'] = 1777.823, ['Y'] = 2559.632, ['Z'] = 45.79, ['H'] = nil},
    },
 },
 ['Spawns'] = {
     [1] = {
         ['Animation'] = "bumsleep",
         ['Coords'] = {['X'] = 1760.403, ['Y'] = 2498.699, ['Z'] = 45.80, ['H'] = 5.63},
     },
     [2] = {
         ['Animation'] = "lean",
         ['Coords'] = {['X'] = 1783.706, ['Y'] = 2553.636, ['Z'] = 45.72, ['H'] = 88.50},
     },
     [3] = {
         ['Animation'] = "lean",
         ['Coords'] = {['X'] = 1760.653, ['Y'] = 2541.365, ['Z'] = 45.73, ['H'] = 100},
     },
     [4] = {
         ['Animation'] = "chair4",
         ['Coords'] = {['X'] = 1715.19, ['Y'] = 2553.58, ['Z'] = 45.56, ['H'] = 179.84},
     },
  },
  ['Leave-Spawn'] = {
    [1] = {
        ['Animation'] = "chair",
        ['Coords'] = {['X'] = 1836.519, ['Y'] = 2582.729, ['Z'] = 46.01, ['H'] = 270.49},
    },
    [2] = {
        ['Animation'] = "chair",
        ['Coords'] = {['X'] = 1836.519, ['Y'] = 2581.205, ['Z'] = 46.01, ['H'] = 275.63},
    },
    [3] = {
        ['Animation'] = "chair",
        ['Coords'] = {['X'] = 1842.509, ['Y'] = 2591.147, ['Z'] = 46.01, ['H'] = 178.87},
    },
  }
}

Config.Items = {
  label = "Prison Winkel",
  slots = 5,
  items = {
   [1] = {
    name = "water",
    price = 10,
    amount = 50,
    info = {},
    type = "item",
    slot = 1,
   },
   [2] = {
    name = "sandwich",
    price = 4,
    amount = 50,
    info = {},
    type = "item",
    slot = 1,
   },
  }
}