Config = Config or {}

Config.TrunkData = {}

Config.ObjectOptions = {
    [GetHashKey('prop_atm_01')] = {
        [1] = {
            ['Name'] = 'ATM',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="far fa-credit-card"></i>',
            ['EventName'] = 'HD-banking:client:open:atm',
        },
    },
    [GetHashKey('prop_parknmeter_02')] = {
        [1] = {
            ['Name'] = 'Openbreken',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="far fa-credit-card"></i>',
            ['EventName'] = 'HD-items:client:use:lockpick',
        },
    },
    [GetHashKey('prop_parknmeter_01')] = {
        [1] = {
            ['Name'] = 'Openbreken',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="far fa-credit-card"></i>',
            ['EventName'] = 'HD-items:client:use:lockpick',
        },
    },
    [GetHashKey('prop_atm_02')] = {
        [1] = {
            ['Name'] = 'ATM',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="far fa-credit-card"></i>',
            ['EventName'] = 'HD-banking:client:open:atm',
        },
    },
    [GetHashKey('prop_atm_03')] = {
        [1] = {
            ['Name'] = 'ATM',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="far fa-credit-card"></i>',
            ['EventName'] = 'HD-banking:client:open:atm',
        },
    },
    [GetHashKey('prop_fleeca_atm')] = {
        [1] = {
            ['Name'] = 'ATM',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="far fa-credit-card"></i>',
            ['EventName'] = 'HD-banking:client:open:atm',
        },
    },
    [GetHashKey('P_Notepad_01_S')] = {
        ['Job'] = 'police',
        [1] = {
            ['Name'] = 'In / Out Duty',
            ['EventType'] = 'Server',
            ['Logo'] = '<i class="fas fa-user-clock"></i>',
            ['EventName'] = 'HDCore:ToggleDuty',
        },
    },
    [GetHashKey('p_amb_clipboard_01')] = {
        ['Job'] = 'ambulance',
        [1] = {
            ['Name'] = 'In / Out Duty',
            ['EventType'] = 'Server',
            ['Logo'] = '<i class="fas fa-bell"></i>',
            ['EventName'] = 'HDCore:ToggleDuty',
        },
    },
    [GetHashKey('prop_till_01')] = {
        [1] = {
            ['Name'] = 'Store',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-shopping-basket"></i>',
            ['EventName'] = 'HD-stores:server:open:shop',
        },
    },
    [GetHashKey('prop_till_02')] = {
        [1] = {
            ['Name'] = 'Store',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-shopping-basket"></i>',
            ['EventName'] = 'HD-stores:server:open:shop',
        },
    },
    [1746653202] = {
        [1] = {
            ['Name'] = 'Talk to person',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-comments"></i>',
            ['EventName'] = 'HD-illegal:client:talk:to:npc',
        },
    },
    [2023152276] = {
        [1] = {
            ['Name'] = 'Talk to person',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-comments"></i>',
            ['EventName'] = 'HD-illegal:client:talk:to:npc',
        },
    },
    [-306958529] = {
        [1] = {
            ['Name'] = 'Talk to person',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-comments"></i>',
            ['EventName'] = 'HD-illegal:client:talk:to:npc',
        },
    },
    [GetHashKey('cs_old_man1a')] = {
        [1] = {
            ['Name'] = 'Locksmith',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-key"></i>',
            ['EventName'] = 'HD-illegal:client:talk:to:npc',
        },
    },
    [GetHashKey('s_m_m_gardener_01')] = {
        [1] = {
            ['Name'] = 'Tool Shop',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-tools"></i>',
            ['EventName'] = 'HD-illegal:client:talk:to:npc',
        },
    },
    [GetHashKey('a_f_m_prolhost_01')] = {
        [1] = {
            ['Name'] = 'Fishing Shop',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-fish"></i>',
            ['EventName'] = 'HD-illegal:client:talk:to:npc',
        },
    },
    [GetHashKey('s_m_y_ammucity_01')] = {
        [1] = {
            ['Name'] = 'Start Hunting',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-play-circle"></i>',
            ['EventName'] = 'HD-hunting:client:sync:start',
        },
        [2] = {
            ['Name'] = 'Stop Hunting',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-stop-circle"></i>',
            ['EventName'] = 'HD-hunting:client:sync:stop',
        },
        [3] = {
            ['Name'] = 'Sell Goods',
            ['EventType'] = 'Server',
            ['Logo'] = '<i class="fas fa-wallet"></i>',
            ['EventName'] = 'HD-hunt:sell',
        },
    },
    -- [GetHashKey('a_m_m_og_boss_01')] = {
    --     [1] = {
    --         ['Name'] = 'Inschrijven',
    --         ['EventType'] = 'Client',
    --         ['Logo'] = '<i class="fas fa-play-circle"></i>',
    --         ['EventName'] = 'HD-secretjob:inschrijven',
    --     },
    --     -- [2] = {
    --     --     ['Name'] = 'Stop Hunten',
    --     --     ['EventType'] = 'Client',
    --     --     ['Logo'] = '<i class="fas fa-stop-circle"></i>',
    --     --     ['EventName'] = 'HD-hunting:client:sync:stop',
    --     -- },
    --     -- [3] = {
    --     --     ['Name'] = 'Verkoop Goederen',
    --     --     ['EventType'] = 'Server',
    --     --     ['Logo'] = '<i class="fas fa-wallet"></i>',
    --     --     ['EventName'] = 'HD-hunt:sell',
    --     -- },
    -- },
    [GetHashKey('cs_beverly')] = {
        [1] = {
            ['Name'] = 'Talk to person',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-comments"></i>',
            ['EventName'] = 'HD-illegal:client:talk:to:npc',
        },
    },
    -- Koffie
    [GetHashKey('prop_vend_coffe_01')] = {
        [1] = {
            ['Name'] = 'Koffie Machine',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-coffee"></i>',
            ['EventName'] = 'HD-stores:client:open:custom:store',
            ['EventParameter'] = 'Coffee',
        },
    },
    -- Vending
    [GetHashKey('prop_vend_snak_01')] = {
        [1] = {
            ['Name'] = 'Snoep Automaat',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-candy-cane"></i>',
            ['EventName'] = 'HD-stores:client:open:custom:store',
            ['EventParameter'] = 'Vending',
        },
    },
    -- Watermachine
    [GetHashKey('prop_watercooler')] = {
        [1] = {
            ['Name'] = 'Watermachine',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-candy-cane"></i>',
            ['EventName'] = 'HD-stores:client:open:custom:store',
            ['EventParameter'] = 'Watertje',
        },
    },
    -- Watermachine
    [GetHashKey('prop_watercooler_dark')] = {
        [1] = {
            ['Name'] = 'Watermachine',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-candy-cane"></i>',
            ['EventName'] = 'HD-stores:client:open:custom:store',
            ['EventParameter'] = 'Watertje',
        },
    },
    -- Colamachine1
    [GetHashKey('prop_vend_soda_01')] = {
        [1] = {
            ['Name'] = 'Drankautomaat',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-candy-cane"></i>',
            ['EventName'] = 'HD-stores:client:open:custom:store',
            ['EventParameter'] = 'Drankautomaat',
        },
    },
    -- Colamachine2
    [GetHashKey('prop_vend_soda_02')] = {
        [1] = {
            ['Name'] = 'Drankautomaat',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-candy-cane"></i>',
            ['EventName'] = 'HD-stores:client:open:custom:store',
            ['EventParameter'] = 'Drankautomaat',
        },
    },
    -- -- Store
    -- [GetHashKey('prop_till_03')] = {
    --     [1] = {
    --         ['Name'] = 'Shop',
    --         ['EventType'] = 'Client',
    --         ['Logo'] = '<i class="fas fa-shopping-basket"></i>',
    --         ['EventName'] = 'HD-stores:server:open:shop',
    --     },
    -- },
    -- Dumpsters
    [GetHashKey('prop_cs_dumpster_01a')] = {
        [1] = {
            ['Name'] = 'Search container',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-dumpster"></i>',
            ['EventName'] = 'HD-materials:client:search:trash',
        },
    },
    [GetHashKey('prop_dumpster_02a')] = {
        [1] = {
            ['Name'] = 'Search container',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-dumpster"></i>',
            ['EventName'] = 'HD-materials:client:search:trash',
        },
    },
    [GetHashKey('prop_dumpster_01a')] = {
        [1] = {
            ['Name'] = 'Search container',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-dumpster"></i>',
            ['EventName'] = 'HD-materials:client:search:trash',
        },
    },
    [GetHashKey('prop_dumpster_02b')] = {
        [1] = {
            ['Name'] = 'Search container',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-dumpster"></i>',
            ['EventName'] = 'HD-materials:client:search:trash',
        },
    },
    [GetHashKey('prop_dumpster_4b')] = {
        [1] = {
            ['Name'] = 'Search container',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-dumpster"></i>',
            ['EventName'] = 'HD-materials:client:search:trash',
        },
    },
    [GetHashKey('prop_dumpster_3a')] = {
        [1] = {
            ['Name'] = 'Search container',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-dumpster"></i>',
            ['EventName'] = 'HD-materials:client:search:trash',
        },
    },
    [GetHashKey('prop_bin_05a')] = {
        [1] = {
            ['Name'] = 'Search container',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-dumpster"></i>',
            ['EventName'] = 'HD-materials:client:search:trash',
        },
   },
    -- BurgerShot
    [GetHashKey('v_ind_bin_01')] = {
        [1] = {
            ['Job'] = 'burger',
            ['UseDuty'] = true,
            ['Name'] = 'Register',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-coins"></i>',
            ['EventName'] = 'HD-burgershot:client:open:register',
        },
        [2] = {
            ['Name'] = 'Pay',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-coins"></i>',
            ['EventName'] = 'HD-burgershot:client:open:payment',
        },
    },
    [GetHashKey('prop_food_bs_tray_01')] = {
        [1] = {
            ['Name'] = 'Dinnerplate',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-utensils"></i>',
            ['EventName'] = 'HD-burgershot:client:open:tray',
            ['EventParameter'] = 1,
        },
    },
    [GetHashKey('prop_food_bs_tray_02')] = {
        [1] = {
            ['Name'] = 'Dinnerplate',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-utensils"></i>',
            ['EventName'] = 'HD-burgershot:client:open:tray',
            ['EventParameter'] = 2,
        },
    },
    [GetHashKey('v_ind_cf_chickfeed')] = {
        ['Job'] = 'burger',
        ['UseDuty'] = true,
        [1] = {
            ['Name'] = 'Warmhold',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-hamburger"></i>',
            ['EventName'] = 'HD-burgershot:client:open:hot:storage',
        },
    },
    [GetHashKey('v_ret_gc_bag01')] = {
        ['Job'] = 'burger',
        ['UseDuty'] = true,
        [1] = {
            ['Name'] = 'Bake Meat',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-drumstick-bite"></i>',
            ['EventName'] = 'HD-burgershot:client:bake:meat',
        },
    },
    [GetHashKey('v_ret_gc_bag02')] = {
        ['Job'] = 'burger',
        ['UseDuty'] = true,
        [1] = {
            ['Name'] = 'Bake Fries',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-drumstick-bite"></i>',
            ['EventName'] = 'HD-burgershot:client:bake:fries',
        },
    },
    [GetHashKey('v_ilev_fib_frame03')] = {
        ['Job'] = 'burger',
        ['UseDuty'] = true,
        [1] = {
            ['Name'] = 'Fridge',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-boxes"></i>',
            ['EventName'] = 'HD-burgershot:client:open:cold:storage',
        },
    },
    [GetHashKey('v_ilev_fib_frame02')] = {
        ['Job'] = 'burger',
        ['UseDuty'] = true,
        [1] = {
            ['Name'] = 'Make Soda',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-wine-bottle"></i>',
            ['EventName'] = 'HD-burgershot:client:create:drink',
            ['EventParameter'] = 'burger-softdrink',
        },
        [2] = {
            ['Name'] = 'Make Coffee',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-wine-bottle"></i>',
            ['EventName'] = 'HD-burgershot:client:create:drink',
            ['EventParameter'] = 'burger-coffee',
        },
    },
    [GetHashKey('v_ilev_m_sofacushion')] = {
        ['Job'] = 'burger',
        [1] = {
            ['Name'] = 'In / Out Duty',
            ['EventType'] = 'Server',
            ['Logo'] = '<i class="fas fa-user-clock"></i>',
            ['EventName'] = 'HDCore:ToggleDuty',
        },
    },
    [GetHashKey('v_ret_fh_pot01')] = {
        ['Job'] = 'burger',
        ['UseDuty'] = true,
        [1] = {
            ['Name'] = 'Create Bleeder',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-hamburger"></i>',
            ['EventName'] = 'HD-burgershot:client:create:burger',
            ['EventParameter'] = 'burger-bleeder',
        },
        [2] = {
            ['Name'] = 'Create Heartstopper',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-hamburger"></i>',
            ['EventName'] = 'HD-burgershot:client:create:burger',
            ['EventParameter'] = 'burger-heartstopper',
        },
        [3] = {
            ['Name'] = 'Create Moneyshot',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-hamburger"></i>',
            ['EventName'] = 'HD-burgershot:client:create:burger',
            ['EventParameter'] = 'burger-moneyshot',
        },
        [4] = {
            ['Name'] = 'Create Torpedo',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-hamburger"></i>',
            ['EventName'] = 'HD-burgershot:client:create:burger',
            ['EventParameter'] = 'burger-torpedo',
        },
    },
    [GetHashKey('v_ilev_m_sofacushion')] = {
        ['Job'] = 'burger',
        [1] = {
            ['Name'] = 'In / Out Duty',
            ['EventType'] = 'Server',
            ['Logo'] = '<i class="fas fa-user-clock"></i>',
            ['EventName'] = 'HDCore:ToggleDuty',
        },
    },
    [GetHashKey('s_m_m_highsec_02')] = {
        ['Job'] = 'burger',
        [1] = {
            ['Name'] = 'Hand In Receipt',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-receipt"></i>',
            ['EventName'] = 'HD-illegal:client:talk:to:npc',
        },
    },
    -- Bobcatheist
    [GetHashKey('cs_drfriedlander')] = {
        [1] = {
            ['Name'] = 'Kaboem',
            ['EventType'] = 'Client',
            ['Logo'] = '<i class="fas fa-bomb"></i>',
            ['EventName'] = 'fuze:pedwalk',
        },
    },
}

Config.VehicleMenu = {
    [1] = {
        ['Name'] = 'Kofferbak openen',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-truck-loading"></i>',
        ['EventName'] = 'HD-eye:client:open:trunk',
    },
    [2] = {
        ['Name'] = 'In kofferbak',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-couch"></i>',
        ['EventName'] = 'HD-eye:client:getin:trunk',
    },
    [3] = {
        ['Name'] = 'Uit kofferbak',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-couch"></i>',
        ['EventName'] = 'HD-eye:client:getout:trunk',
    },    
}

Config.CarDealerVehicleMenu = {
    [1] = {
        ['Name'] = 'Trunk',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-truck-loading"></i>',
        ['EventName'] = 'HD-eye:client:open:trunk',
    },
    -- [2] = {
    --     ['Name'] = 'Get in the trunk',
    --     ['EventType'] = 'Client',
    --     ['Logo'] = '<i class="fas fa-couch"></i>',
    --     ['EventName'] = 'HD-eye:client:getin:trunk',
    -- },
    [2] = {
        ['Name'] = 'Sell vehicle',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-file-signature"></i>',
        ['EventName'] = 'HD-cardealer:client:sell:closest:vehicle',
    },
}

Config.PedMenu = {
    [1] = {
        ['Name'] = 'Sell',
        ['EventType'] = 'Client',
        ['Logo'] = '<i class="fas fa-handshake"></i>',
        ['EventName'] = 'HD-illegal:client:sell:to:ped',
    }, 
}

Config.VehicleOFfsets = {
    [0]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.5, ['Z-Offset'] = 0.0},
    [1]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -2.0, ['Z-Offset'] = 0.0},
    [2]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [3]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.5, ['Z-Offset'] = 0.0},
    [4]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -2.0, ['Z-Offset'] = 0.0},
    [5]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -2.0, ['Z-Offset'] = 0.0},
    [6]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -2.0, ['Z-Offset'] = 0.0},
    [7]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -2.0, ['Z-Offset'] = 0.0},
    [8]  = {['CanEnter'] = false, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.5, ['Z-Offset'] = 0.0},
    [9]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [10]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [11]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [12]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [13]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [14]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [15]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [16]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [17]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [18]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [19]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [20]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25},
    [21]  = {['CanEnter'] = true, ['X-Offset'] = 0.0, ['Y-Offset'] = -1.0, ['Z-Offset'] = 0.25}
}