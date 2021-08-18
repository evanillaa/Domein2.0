Config = Config or {}

Config.NeededCops = 1

Config.Locale = "en"
Config.NeededCopsPacific = 0

Config.CardType = {
  'blue-card', 
  'red-card', 
  'purple-card', 
}

Config.Trollys = {
  [1] = {
    ['Type'] = 'Money',
    ['Open-State'] = false,
    ['Grab-Coords'] = {['X'] = 254.74, ['Y'] = 216.93, ['Z'] = 101.68},
    ['Coords'] = {
      ['X'] = 254.89,
      ['Y'] = 216.34,
      ['Z'] = 101.68,
      ['H'] = 3.51
    },
  },
  [2] = {
    ['Type'] = 'Money',
    ['Open-State'] = false,
    ['Grab-Coords'] = {['X'] = 263.03, ['Y'] = 215.28, ['Z'] = 101.68},
    ['Coords'] = {
      ['X'] = 262.96,
      ['Y'] = 215.92,
      ['Z'] = 101.68,
      ['H'] = 177.67
    },
  },
  [3] = {
    ['Type'] = 'Money',
    ['Open-State'] = false,
    ['Grab-Coords'] = {['X'] = 264.90, ['Y'] = 212.61, ['Z'] = 101.68},
    ['Coords'] = {
      ['X'] = 265.22,
      ['Y'] = 212.08,
      ['Z'] = 101.68,
      ['H'] = 19.91
    },
  },
  [4] = {
    ['Type'] = 'Money',
    ['Open-State'] = false,
    ['Grab-Coords'] = {['X'] = 258.71, ['Y'] = 216.97, ['Z'] = 101.68},
    ['Coords'] = {
      ['X'] = 259.12,
      ['Y'] = 217.37,
      ['Z'] = 101.68,
      ['H'] = 136.24
    },
  },
}

Config.BankLocations = {
 [1] = {
    ['BankName'] = 'Blokkenpark Bank',
    ['card-type'] = 'blue-card',
    ['IsOpened'] = false,
    ['Alarm'] = true,
    ['DoorId'] = {22},
    ['CamId'] = 1,
    ['Object'] = {
      ['Hash'] = GetHashKey("v_ilev_gb_vauldr"),
      ['Closed'] = 250.0,
      ['Opend'] = 160.0,
    },
    ['Coords'] = {
      ["X"] = 146.92,
      ["Y"] = -1046.11,
      ["Z"] = 29.36,
    },
    ['Lockers'] = {
      [1] = {
        ["X"] = 149.84, 
        ["Y"] = -1044.9, 
        ["Z"] = 29.34,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
    },
    [2] = {
        ["X"] = 151.16, 
        ["Y"] = -1046.64, 
        ["Z"] = 29.34,
        ['Type'] = 'drill',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
    },
    [3] = {
        ["X"] = 147.16, 
        ["Y"] = -1047.72, 
        ["Z"] = 29.34,
        ['Type'] = 'drill',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
    },
    [4] = {
        ["X"] = 146.54, 
        ["Y"] = -1049.28, 
        ["Z"] = 29.34,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
    },
    [5] = {
        ["X"] = 146.88, 
        ["Y"] = -1050.33, 
        ["Z"] = 29.34,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
    },
    [6] = {
        ["X"] = 150.0, 
        ["Y"] = -1050.67, 
        ["Z"] = 29.34,
        ['Type'] = 'drill',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
    },
    [7] = {
        ["X"] = 149.47, 
        ["Y"] = -1051.28, 
        ["Z"] = 29.34,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
    },
    [8] = {
        ["X"] = 150.58, 
        ["Y"] = -1049.09, 
        ["Z"] = 29.34,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
    },
  },
 },
 [2] = {
  ['BankName'] = 'Motel Bank',
  ['card-type'] = 'red-card',
  ['IsOpened'] = false,
  ['Alarm'] = true,
  ['DoorId'] = {23},
  ['CamId'] = 1,
  ['Object'] = {
    ['Hash'] = GetHashKey("v_ilev_gb_vauldr"),
    ['Closed'] = 250.0,
    ['Opend'] = 160.0,
  },
  ['Coords'] = {
    ["X"] = 311.15,
    ["Y"] = -284.49,
    ["Z"] = 54.16,
  },
  ['Lockers'] = {
    [1] = {
      ["X"] = 311.16, 
      ["Y"] = -287.71, 
      ["Z"] = 54.14, 
      ['Type'] = 'lockpick',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [2] = {
      ["X"] = 311.86, 
      ["Y"] = -286.21, 
      ["Z"] = 54.14, 
      ['Type'] = 'lockpick',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [3] = {
      ["X"] = 313.39, 
      ["Y"] = -289.15, 
      ["Z"] = 54.14, 
      ['Type'] = 'lockpick',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [4] = {
      ["X"] = 311.7, 
      ["Y"] = -288.45, 
      ["Z"] = 54.14, 
      ['Type'] = 'lockpick',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [5] = {
      ["X"] = 314.23, 
      ["Y"] = -288.77, 
      ["Z"] = 54.14, 
      ['Type'] = 'lockpick',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [6] = {
      ["X"] = 314.83, 
      ["Y"] = -287.33, 
      ["Z"] = 54.14, 
      ['Type'] = 'drill',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [7] = {
      ["X"] = 315.24, 
      ["Y"] = -284.85, 
      ["Z"] = 54.14, 
      ['Type'] = 'drill',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [8] = {
      ["X"] = 314.08, 
      ["Y"] = -283.38, 
      ["Z"] = 54.14, 
      ['Type'] = 'drill',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  },
 },
 [3] = {
  ['BankName'] = 'Los Santos Customs Bank',
  ['card-type'] = 'blue-card',
  ['IsOpened'] = false,
  ['Alarm'] = true,
  ['DoorId'] = {24},
  ['CamId'] = 1,
  ['Object'] = {
    ['Hash'] = GetHashKey("v_ilev_gb_vauldr"),
    ['Closed'] = 250.0,
    ['Opend'] = 160.0,
  },
  ['Coords'] = {
    ["X"] = -353.82,
    ["Y"] = -55.37,
    ["Z"] = 49.03,
  },
  ['Lockers'] = {
    [1] = {
      ["X"] = -350.99, 
      ["Y"] = -54.13, 
      ["Z"] = 49.01,
      ['Type'] = 'lockpick',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [2] = {
      ["X"] = -349.53, 
      ["Y"] = -55.77, 
      ["Z"] = 49.01,
      ['Type'] = 'lockpick',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [3] = {
      ["X"] = -353.54, 
      ["Y"] = -56.94, 
      ["Z"] = 49.01,
      ['Type'] = 'drill',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [4] = {
      ["X"] = -354.09, 
      ["Y"] = -58.55, 
      ["Z"] = 49.01,
      ['Type'] = 'lockpick',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [5] = {
      ["X"] = -353.81, 
      ["Y"] = -59.48, 
      ["Z"] = 49.01,
      ['Type'] = 'drill',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [6] = {
      ["X"] = -349.8, 
      ["Y"] = -58.3, 
      ["Z"] = 49.01,
      ['Type'] = 'lockpick',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [7] = {
      ["X"] = -351.14, 
      ["Y"] = -60.37, 
      ["Z"] = 49.01,
      ['Type'] = 'drill',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [8] = {
      ["X"] = -350.4, 
      ["Y"] = -59.92, 
      ["Z"] = 49.01,
      ['Type'] = 'lockpick',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
      },
    },
 },
 [4] = {
  ['BankName'] = 'Del Perro Blvd',
  ['card-type'] = 'blue-card',
  ['IsOpened'] = false,
  ['Alarm'] = true,
  ['DoorId'] = {27},
  ['CamId'] = 1,
  ['Object'] = {
    ['Hash'] = GetHashKey("v_ilev_gb_vauldr"),
    ['Closed'] = 296.863,
    ['Opend'] = 206.863,
  },
  ['Coords'] = {
    ["X"] = -1210.77,
    ["Y"] = -336.57,
    ["Z"] = 37.78,
  },
  ['Lockers'] = {
    [1] = {
      ["X"] = -1209.68, 
      ["Y"] = -333.65, 
      ["Z"] = 37.75,
      ['Type'] = 'lockpick',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [2] = {
      ["X"] = -1207.46, 
      ["Y"] = -333.77, 
      ["Z"] = 37.75,
      ['Type'] = 'lockpick',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [3] = {
      ["X"] = -1209.45, 
      ["Y"] = -337.47, 
      ["Z"] = 37.75,
      ['Type'] = 'drill',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [4] = {
      ["X"] = -1208.65, 
      ["Y"] = -339.06, 
      ["Z"] = 37.75,
      ['Type'] = 'lockpick',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [5] = {
      ["X"] = -1207.75, 
      ["Y"] = -339.42, 
      ["Z"] = 37.75,
      ['Type'] = 'lockpick',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [6] = {
      ["X"] = -1205.28,
      ["Y"] = -338.14, 
      ["Z"] = 37.75,
      ['Type'] = 'drill',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [7] = {
      ["X"] = -1205.08, 
      ["Y"] = -337.28, 
      ["Z"] = 37.75,
      ['Type'] = 'drill',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
  },
  [8] = {
      ["X"] = -1205.92, 
      ["Y"] = -335.75, 
      ["Z"] = 37.75,
      ['Type'] = 'lockpick',
      ['IsBusy'] = false,
      ['IsOpend'] = false,
      },
  },
 },
 [5] = {
  ['BankName'] = 'Snelweg Bank',
  ['card-type'] = 'purple-card',
  ['IsOpened'] = false,
  ['Alarm'] = true,
  ['DoorId'] = {26},
  ['CamId'] = 1,
  ['Object'] = {
    ['Hash'] = GetHashKey("hei_prop_heist_sec_door"),
    ['Closed'] = 357.542,
    ['Opend'] = 267.542,
  },
  ['Coords'] = {
    ["X"] = -2956.55,
    ["Y"] = 481.74,
    ["Z"] = 15.69,
  },
  ['Lockers'] = {
      [1] = {
       ["X"] = -2958.54,
       ["Y"] = 484.1,
       ["Z"] = 15.67,
       ['Type'] = 'lockpick',
       ['IsBusy'] = false,
       ['IsOpend'] = false,
      },
      [2] = {
        ["X"] = -2957.3,
        ["Y"] = 485.95,
        ["Z"] = 15.67,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [3] = {
        ["X"] = -2955.09,
        ["Y"] = 482.43,
        ["Z"] = 15.67,
        ['Type'] = 'drill',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [4] = {
        ["X"] = -2953.26,
        ["Y"] = 482.42,
        ["Z"] = 15.67,
        ['Type'] = 'drill',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [5] = {
        ["X"] = -2952.63,
        ["Y"] = 483.09, 
        ["Z"] = 15.67,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [6] = {
        ["X"] = -2952.45, 
        ["Y"] = 485.66, 
        ["Z"] = 15.67,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [7] = {
        ["X"] = -2953.13,
        ["Y"] = 486.26, 
        ["Z"] = 15.67,
        ['Type'] = 'drill',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [8] = {
        ["X"] = -2954.98, 
        ["Y"] = 486.37, 
        ["Z"] = 15.67,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
  },
 },
 [6] = {
  ['BankName'] = 'paleto Bank',
  ['card-type'] = 'purple-card',
  ['IsOpened'] = false,
  ['Alarm'] = true,
  ['DoorId'] = {33, 34},
  ['CamId'] = 1,
  ['Object'] = {
    ['Hash'] = GetHashKey("v_ilev_cbankvauldoor01"),
    ['Closed'] = 45.45,
    ['Opend'] = 140.95,
  },
  ['Coords'] = {
    ["X"] = -105.6448,
    ["Y"] = 6470.518,
    ["Z"] = 31.62672,
  },
  ['Lockers'] = {
      [1] = {
       ["X"] = -106.6564,
       ["Y"] = 6473.018,
       ["Z"] = 31.62671,
       ['Type'] = 'lockpick',
       ['IsBusy'] = false,
       ['IsOpend'] = false,
      },
      [2] = {
        ["X"] = -107.636,
        ["Y"] = 6473.998,
        ["Z"] = 31.62671,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [3] = {
        ["X"] = -107.5526,
        ["Y"] = 6475.685,
        ["Z"] = 31.62671,
        ['Type'] = 'drill',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [4] = {
        ["X"] = -106.5288,
        ["Y"] = 6478.05,
        ["Z"] = 31.62,
        ['Type'] = 'drill',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [5] = {
        ["X"] = -105.34,
        ["Y"] = 6479.021, 
        ["Z"] = 31.64,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [6] = {
        ["X"] = -103.79, 
        ["Y"] = 6478.81, 
        ["Z"] = 31.62,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [7] = {
        ["X"] = -102.49,
        ["Y"] = 6477.505, 
        ["Z"] = 31.67,
        ['Type'] = 'drill',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [8] = {
        ["X"] = -103.33, 
        ["Y"] = 6475.05, 
        ["Z"] = 31.66,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [9] = {
        ["X"] = -102.44, 
        ["Y"] = 6476.02, 
        ["Z"] = 31.62,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
      },
    },
}

Config.SpecialBanks = {
  [1] = {
    ['Name'] = 'Maze',
    ['Open'] = false,
    ['Hack-Door'] = {
      ["X"] = 253.23,
      ["Y"] = 228.46,
      ["Z"] = 101.68,
    },
    ['Bank-Door'] = {
      ['Object'] = 961976194,
      ['Opend'] = 20.0,
      ['Closed'] = 160.0,
      ["X"] = 253.25,
      ["Y"] = 228.44,
      ["Z"] = 101.68,
    },
    ['lockers'] = {
      [1] = {
       ["X"] = -106.6564,
       ["Y"] = 6473.018,
       ["Z"] = 31.62671,
       ['Type'] = 'lockpick',
       ['IsBusy'] = false,
       ['IsOpend'] = false,
      },
      [2] = {
        ["X"] = -107.636,
        ["Y"] = 6473.998,
        ["Z"] = 31.62671,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [3] = {
        ["X"] = -107.5526,
        ["Y"] = 6475.685,
        ["Z"] = 31.62671,
        ['Type'] = 'drill',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [4] = {
        ["X"] = -106.5288,
        ["Y"] = 6478.05,
        ["Z"] = 31.62,
        ['Type'] = 'drill',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [5] = {
        ["X"] = -105.34,
        ["Y"] = 6479.021, 
        ["Z"] = 31.64,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [6] = {
        ["X"] = -103.79, 
        ["Y"] = 6478.81, 
        ["Z"] = 31.62,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [7] = {
        ["X"] = -102.49,
        ["Y"] = 6477.505, 
        ["Z"] = 31.67,
        ['Type'] = 'drill',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [8] = {
        ["X"] = -103.33, 
        ["Y"] = 6475.05, 
        ["Z"] = 31.66,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
       [9] = {
        ["X"] = -102.44, 
        ["Y"] = 6476.02, 
        ["Z"] = 31.62,
        ['Type'] = 'lockpick',
        ['IsBusy'] = false,
        ['IsOpend'] = false,
       },
      },
  },
}