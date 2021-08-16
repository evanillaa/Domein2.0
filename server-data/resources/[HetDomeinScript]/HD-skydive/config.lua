Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DEL'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config = {}

Config.DrawDistance                = 10 
Config.MarkerType                  = 30
Config.showblips                   = true --set it true to show the blips.
Config.timetotakeoff               = 15 -- in seconed 
Config.priceforparachute           = 2000          -- price to buy the parachute .
Config.shareyourtrip               = true          --allow friends to jin your trip by pressing E next to heli.
Config.spawnedheli                 = "frogger"
Config.spawnedheli2                = 'frogger'
Config.pilot                       = "s_m_m_pilot_01"
Config.blipname                    = 'Sky diving'

Config.SkyDive = {
    [1] = {
       coords =  {x=-723.89276123047,y=-1468.3366699219,z=5.0005197525024},
       spawn =  {x=-717.34637451172,y=-1476.9886474609,z=6.7882299423218},
       target =  {x=-2910.3786621094,y=-2533.8823242188,z=1188.837890625},
    },
    [2] = {
       coords =  {x=-2328.2395019531,y=-652.14526367188,z=13.416131973267},
       spawn =  {x=-2321.1987304688,y=-658.28607177734,z=13.483915328979},
       target =  {x=-2910.3786621094,y=-2533.8823242188,z=1188.837890625},
    },
    [3] = {
       coords =  {x=-1152.2352294922,y=-2874.8564453125,z=13.945817947388},
       spawn =  {x=-1145.9265136719,y=-2864.7253417969,z=13.946012496948},
       target =  {x=-2910.3786621094,y=-2533.8823242188,z=1188.837890625},
    },
    
}
 

Config.Locations = {
    ["main"] = {
        label = "Los Santos International Airport",
        coords = {x = -1131.7, y = -2878.51, z = 13.95, h = 327.63},
    },
    ["vehicle"] = {
        label = "Vliegtuig Opslag",
        coords = {x = -1144.96, y = -2865.29, z = 13.95, h = 54.22},
    },    
}

Config.Vehicles = {
    ["frogger"] = "Helicopter",
}