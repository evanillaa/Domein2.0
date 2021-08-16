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

Config.BailPrice = 1000

Config.Locations = {
    ["main"] = {
        label = "Los Santos International Airport",
        coords = {x = -1271.51, y = -3380.85, z = 13.94, h = 327.75},
    },
    ["vehicle"] = {
        label = "Vliegtuig Opslag",
        coords = {x = -1271.51, y = -3380.85, z = 13.94, h = 327.75},
    },
    ["paycheck"] = {
        label = "Loonstrook",
        coords = {x = -1299.83, y = -3407.81, z = 13.94, h = 152.64, r = 1.0}, 
    },
    ["cargoholders"] ={
        [1] = {
            name = "Ophaalpunt 1",
            coords = {x = 2146.12, y = 4781.99, z = 41.0, h = 294.67},
        },
        [2] = {
            name = "Ophaalpunt 2",
            coords = {x = -1174.22, y = -2576.32, z = 13.94, h = 246.06},
        },
        [3] = {
            name = "Ophaalpunt 3",
            coords = {x = 1721.1, y = 3320.29, z = 41.22, h = 15.28},
        },
        [4] = {
            name = "Ophaalpunt 4",
            coords = {x = -936.93, y = -3044.38, z = 13.95, h = 207.11},
        },
        [5] = {
            name = "Ophaalpunt 5",
            coords = {x = 2146.12, y = 4781.99, z = 41.0, h = 294.67},
        },
        [6] = {
            name = "Ophaalpunt 6",
            coords = {x = 1721.1, y = 3320.29, z = 41.22, h = 15.28},
        },
    },
}

Config.Vehicles = {
    ["velum"] = "Vliegtuig",
}