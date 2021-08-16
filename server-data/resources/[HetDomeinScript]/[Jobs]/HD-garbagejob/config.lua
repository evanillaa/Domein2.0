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
        label = "Vuilnisstortplaats",
        coords = {x = -350.08, y = -1569.95, z = 25.22, h = 292.42},
    },
    ["vehicle"] = {
        label = "Vuilniswagen Opslag",
        coords = {x = -340.74, y = -1561.82, z = 25.23, h = 58.0},
    },
    ["paycheck"] = {
        label = "Loonstrook",
        coords = {x = -349.88, y = -1569.84, z = 25.22, h = 111.34, r = 1.0}, 
    },
    ["vuilnisbakken"] ={
        [1] = {
            name = "forumdrive",
            coords = {x = -362.48, y = -958.94, z = 31.08, h = 280.13},
        },
        [2] = {
            name = "grovestreet",
            coords = {x = 121.5, y = -1087.66, z = 29.21, h = 356.04},
        },
        [3] = {
            name = "jamestownstreet",
            coords = {x = 339.37, y = -961.1, z = 29.43, h = 192.06},
        },
        [4] = {
            name = "roylowensteinblvd",
            coords = {x = 1099.31, y = -775.59, z = 58.35, h = 356.07},
        },
        [5] = {
            name = "littlebighornavenue",
            coords = {x = 1177.95, y = -304.92, z = 69.01, h = 355.58},
        },
        [6] = {
            name = "vespucciblvd",
            coords = {x = 351.5, y = -196.15, z = 57.23, h = 331.26},
        },
        [7] = {
            name = "elginavenue",
            coords = {x = -27.24, y = -77.92, z = 57.25, h = 160.35},
        },
        [8] = {
            name = "elginavenue2",
            coords = {x = -530.05, y = -45.99, z = 42.26, h = 357.5},
        },
        [9] = {
            name = "powerstreet",
            coords = {x = -1038.23, y = -240.99, z = 37.84, h = 199.27},
        },
        [10] = {
            name = "altastreet",
            coords = {x = -1256.28, y = -864.71, z = 12.32, h = 303.4},
        },
        [11] = {
            name = "didiondrive",
            coords = {x = -1094.58, y = -1254.65, z = 5.45, h = 13.08},
        },
        [12] = {
            name = "miltonroad",
            coords = {x = -1131.01, y = -1415.26, z = 5.15, h = 285.45},
        },
        [13] = {
            name = "eastbourneway",
            coords = {x = -1132.03, y = -1591.97, z = 4.37, h = 299.85},
        },
        [14] = {
            name = "eastbourneway2",
            coords = {x = -722.61, y = -1508.63, z = 5.0, h = 301.86},
        },
        [15] = {
            name = "industrypassage",
            coords = {x = -608.08, y = -1783.81, z = 23.64, h = 210.78},
        },       
    },
}

Config.Vehicles = {
    ["trash"] = "Vuilniswagen",
}