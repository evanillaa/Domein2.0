Config = Config or {}

Config.Locations = {
 ['Prison'] = {
   ['Coords'] = {['X'] = 1693.33, ['Y'] = 2569.51, ['Z'] = 45.55, ['H'] = nil},
 },
 ['Leave'] = {
    ['Coords'] = {['X'] = 1827.327, ['Y'] = 2589.771, ['Z'] = 45.89193, ['H'] = nil},
 },
 ['Shop'] = {
    ['Coords'] = {['X'] = 1642.85, ['Y'] = 2522.28, ['Z'] = 45.56, ['H'] = nil},
 },
 ['Search'] = {
    -- [1] = {
    --     ['Reward'] = 'shitlockpick',
    --     ['Chance'] = 10,
    --     ['Coords'] = {['X'] = 1671.597, ['Y'] = 2523.889, ['Z'] = 45.56491, ['H'] = nil},
    -- },
    -- [2] = {
    --     ['Reward'] = 'meth',
    --     ['Chance'] = 5,
    --     ['Coords'] = {['X'] = 1764.145, ['Y'] = 2572.728, ['Z'] = 49.73917, ['H'] = nil},
    -- },
    [1] = {
        ['Reward'] = 'slushy',
        ['Chance'] = 100,
        ['Coords'] = {['X'] = 1775.753, ['Y'] = 2593.752, ['Z'] = 45.72357, ['H'] = nil},
    },
 },
 ['Spawns'] = {
     [1] = {
         ['Animation'] = "bumsleep",
         ['Coords'] = {['X'] = 1661.046, ['Y'] = 2524.681, ['Z'] = 45.564, ['H'] = 260.545},
     },
     [2] = {
         ['Animation'] = "lean",
         ['Coords'] = {['X'] = 1650.812, ['Y'] = 2540.582, ['Z'] = 45.564, ['H'] = 230.436},
     },
     [3] = {
         ['Animation'] = "lean",
         ['Coords'] = {['X'] = 1654.959, ['Y'] = 2545.535, ['Z'] = 45.564, ['H'] = 230.436},
     },
     [4] = {
         ['Animation'] = "lean",
         ['Coords'] = {['X'] = 1697.106, ['Y'] = 2525.558, ['Z'] = 45.564, ['H'] = 187.208},
     },
     [5] = {
         ['Animation'] = "chair4",
         ['Coords'] = {['X'] = 1673.084, ['Y'] = 2519.823, ['Z'] = 45.564, ['H'] = 229.542},
     },
     [6] = {
         ['Animation'] = "chair",
         ['Coords'] = {['X'] = 1666.029, ['Y'] = 2511.367, ['Z'] = 45.564, ['H'] = 233.888},
     },
     [7] = {
         ['Animation'] = "chair4",
         ['Coords'] = {['X'] = 1691.229, ['Y'] = 2509.635, ['Z'] = 45.564, ['H'] = 52.432},
     },
     [8] = {
         ['Animation'] = "finger2",
         ['Coords'] = {['X'] = 1770.59, ['Y'] = 2536.064, ['Z'] = 45.564, ['H'] = 258.113},
     },
     [9] = {
         ['Animation'] = "smoke",
         ['Coords'] = {['X'] = 1751.05, ['Y'] = 2564.37, ['Z'] = 45.56, ['H'] = 225.14},
     },
  },
  ['Leave-Spawn'] = {
    [1] = {
        ['Animation'] = "chair",
        ['Coords'] = {['X'] = 1843.636, ['Y'] = 2575.805, ['Z'] = 45.8975, ['H'] = 0.0},
    },
    [2] = {
        ['Animation'] = "chair",
        ['Coords'] = {['X'] = 1843.643, ['Y'] = 2573.816, ['Z'] = 45.89194, ['H'] = 174.142},
    },
    [3] = {
        ['Animation'] = "chair",
        ['Coords'] = {['X'] = 1843.842, ['Y'] = 2572.31, ['Z'] = 45.89188, ['H'] = 0.0},
    },
  }
}

Config.Items = {
  label = "Prison Winkel",
  slots = 5,
  items = {
   [1] = {
    name = "coke-bag",
    price = 1000,
    amount = 50,
    info = {},
    type = "item",
    slot = 1,
   },
   [2] = {
    name = "weapon_molotov",
    price = 7500,
    amount = 1,
    info = {
        quality = 100.0
    },
    type = "item",
    slot = 2,
   },
  }
}