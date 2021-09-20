---- Entities
-- What things are called
local Entities = {}

local InterfaceChests = {
    Standard = {
        Item = {
            name = RSENames.Proto.InterfaceChest.Item,
            icon = RSEPaths.EntityGFX .. "se-interface-chest.png",
            icon_size = 32,
            subgroup = RSEStrings.ItemGroups.StorageEnergistics.SubGroups.Buildings,
            order = RSENames.Proto.InterfaceChest.Item,
            place_result = RSENames.Proto.InterfaceChest.Entity
        },
        Recipe = {
            
            name = RSENames.Proto.InterfaceChest.Recipe,
            ingredientsNormal = {
                {RSENames.Proto.PhaseCoil.Item, 4},
                {"steel-chest", 5},
                {"electronic-circuit", 10}
            },
            ingredientsEasy = {
                {RSENames.Proto.PhaseCoil.Item, 2},
                {"iron-chest", 5},
                {"electronic-circuit", 2}
            },
            result = RSENames.Proto.InterfaceChest.Item,
        },
        Entity = {
            
            name = RSENames.Proto.InterfaceChest.Entity,
            icon = RSEPaths.EntityGFX .. "se-interface-chest.png",
            icon_size = 32,
            minable = {mining_time = 1, result = RSENames.Proto.InterfaceChest.Item},
            collision_box = {{-0.32, -0.32}, {0.32, 0.32}},
            selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
            landing_location_offset = {0, 0},
            inventory_size = 32,
            picture = {
                filename = RSEPaths.EntityGFX .. "se-interface-chest.png",
                priority = "extra-high",
                width = 32,
                height = 32,
                shift = {0, 0}
            },
            circuit_connector = normalChest,
        }
    },
    Large = {
        Item = {
            name = RSENames.Proto.InterfaceChestLarge.Item,
            icon = RSEPaths.EntityGFX .. "se-interface-chest-large.png",
            icon_size = 96,
            subgroup = RSEStrings.ItemGroups.StorageEnergistics.SubGroups.Buildings,
            order = RSENames.Proto.InterfaceChestLarge.Item,
            place_result = RSENames.Proto.InterfaceChestLarge.Entity
        },
        Recipe = {
            
            name = RSENames.Proto.InterfaceChestLarge.Recipe,
            ingredientsNormal = {
                {RSENames.Proto.PhaseCoil.Item, 16},
                {"steel-chest", 10},
                {"electronic-circuit", 20}
            },
            ingredientsEasy = {
                {RSENames.Proto.PhaseCoil.Item, 8},
                {"iron-chest", 10},
                {"electronic-circuit", 8}
            },
            result = RSENames.Proto.InterfaceChestLarge.Item,
        },
        Entity = {
            
            name = RSENames.Proto.InterfaceChestLarge.Entity,
            icon = RSEPaths.EntityGFX .. "se-interface-chest-large.png",
            icon_size = 96,
            minable = {mining_time = 1, result = RSENames.Proto.InterfaceChestLarge.Item},
            collision_box = {{-1.35, -1.35}, {1.35, 1.35}},
            selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
            landing_location_offset = {0, 0},
            inventory_size = 64,
            picture = {
                filename = RSEPaths.EntityGFX .. "se-interface-chest-large.png",
                priority = "extra-high",
                width = 96,
                height = 96,
                shift = {0, 0}
            },
            circuit_connector = largeChest,
        }
    
    },
    Warehouse = {
        Item = {
            name = RSENames.Proto.InterfaceChestWarehousing.Item,
            icon = RSEPaths.EntityGFX .. "se-interface-chest-warehousing.png",
            icon_size = 192,
            subgroup = RSEStrings.ItemGroups.StorageEnergistics.SubGroups.Buildings,
            order = RSENames.Proto.InterfaceChestWarehousing.Item,
            place_result = RSENames.Proto.InterfaceChestWarehousing.Entity
        },
        Recipe = {
            
            name = RSENames.Proto.InterfaceChestWarehousing.Recipe,
            ingredientsNormal = {
                {RSENames.Proto.PhaseCoil.Item, 32},
                {"steel-chest", 15},
                {"electronic-circuit", 40}
            },
            ingredientsEasy = {
                {RSENames.Proto.PhaseCoil.Item, 12},
                {"iron-chest", 15},
                {"electronic-circuit", 12}
            },
            result = RSENames.Proto.InterfaceChestWarehousing.Item
        },
        Entity = {
            name = RSENames.Proto.InterfaceChestWarehousing.Entity,
            icon = RSEPaths.EntityGFX .. "se-interface-chest-warehousing.png",
            icon_size = 192,
            minable = {mining_time = 1, result = RSENames.Proto.InterfaceChestWarehousing.Item},
            collision_box = {{-2.7, -2.7}, {2.7, 2.7}},
            selection_box = {{-3.0, -3.0}, {3.0, 3.0}},
            landing_location_offset = {1.0, -1.0},
            inventory_size = 128,
            picture = {
                filename = RSEPaths.EntityGFX .. "se-interface-chest-warehousing.png",
                priority = "extra-high",
                width = 192,
                height = 192,
                shift = {0, 0}
            },
            circuit_connector = warehousingChest
        }
    }
}

local StorageChests = {
    Standard_MK1 = {
        Item = {
            name = RSENames.Proto.StorageChestMk1.Item,
            icon = RSEPaths.EntityGFX .. "se-chest-mk1.png",
            icon_size = 32,
            subgroup = RSEStrings.ItemGroups.StorageEnergistics.SubGroups.Buildings,
            order = RSENames.Proto.StorageChestMk1.Item,
            place_result = RSENames.Proto.StorageChestMk1.Entity
        },
        Recipe = {
            name = RSENames.Proto.StorageChestMk1.Recipe,
            energy_required = 2,
            ingredientsNormal = {
                {RSENames.Proto.PhaseCoil.Item, 4},
                {"steel-chest", 5},
                {"electronic-circuit", 10}
            },
            ingredientsEasy = {
                {RSENames.Proto.PhaseCoil.Item, 2},
                {"iron-chest", 5},
                {"electronic-circuit", 2}
            },
            result = RSENames.Proto.StorageChestMk1.Item
        },
        Entity = {
            name = RSENames.Proto.StorageChestMk1.Entity,
            icon = RSEPaths.EntityGFX .. "se-chest-mk1.png",
            icon_size = 32,
            minable = {mining_time = 1, result = RSENames.Proto.StorageChestMk1.Item},
            max_health = 200,
            collision_box = {{-0.32, -0.32}, {0.32, 0.32}},
            selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
            landing_location_offset = {0, 0},
            inventory_size = 32,
            picture = {
                filename = RSEPaths.EntityGFX .. "se-chest-mk1.png",
                priority = "extra-high",
                width = 32,
                height = 32,
                shift = {0, 0}
            },
            circuit_connector = normalChest
        }
    },
    Large_MK1 = {
        Item = {
            name = RSENames.Proto.StorageChestLargeMk1.Item,
            icon = RSEPaths.EntityGFX .. "se-chest-large-mk1.png",
            icon_size = 96,
            subgroup = RSEStrings.ItemGroups.StorageEnergistics.SubGroups.Buildings,
            order = RSENames.Proto.StorageChestLargeMk1.Item,
            place_result = RSENames.Proto.StorageChestLargeMk1.Entity
        },
        Recipe = {
            name = RSENames.Proto.StorageChestLargeMk1.Recipe,
            energy_required = 2,
            ingredientsNormal = {
                {RSENames.Proto.PhaseCoil.Item, 8},
                {"steel-chest", 10},
                {"electronic-circuit", 20}
            },
            ingredientsEasy = {
                {RSENames.Proto.PhaseCoil.Item, 4},
                {"iron-chest", 10},
                {"electronic-circuit", 4}
            },
            result = RSENames.Proto.StorageChestLargeMk1.Item
        },
        Entity = {
            name = RSENames.Proto.StorageChestLargeMk1.Entity,
            icon = RSEPaths.EntityGFX .. "se-chest-large-mk1.png",
            icon_size = 96,
            minable = {mining_time = 1, result = RSENames.Proto.StorageChestLargeMk1.Item},
            max_health = 400,
            collision_box = {{-1.35, -1.35}, {1.35, 1.35}},
            selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
            landing_location_offset = {0, 0},
            inventory_size = 48,
            picture = {
                filename = RSEPaths.EntityGFX .. "se-chest-large-mk1.png",
                priority = "extra-high",
                width = 96,
                height = 96,
                shift = {0, 0}
            },
            circuit_connector = largeChest
        }
    },
    Warehouse_MK1 = {
        Item = {
            name = RSENames.Proto.StorageChestWarehousingMk1.Item,
            icon = RSEPaths.EntityGFX .. "se-chest-warehousing-mk1.png",
            icon_size = 192,
            subgroup = RSEStrings.ItemGroups.StorageEnergistics.SubGroups.Buildings,
            order = RSENames.Proto.StorageChestWarehousingMk1.Item,
            place_result = RSENames.Proto.StorageChestWarehousingMk1.Entity
        },
        Recipe = {
            name = RSENames.Proto.StorageChestWarehousingMk1.Recipe,
            energy_required = 2,
            ingredientsNormal = {
                {RSENames.Proto.PhaseCoil.Item, 16},
                {"steel-chest", 20},
                {"electronic-circuit", 40}
            },
            ingredientsEasy = {
                {RSENames.Proto.PhaseCoil.Item, 8},
                {"iron-chest", 12},
                {"electronic-circuit", 8}
            },
            result = RSENames.Proto.StorageChestWarehousingMk1.Item
        },
        Entity = {
            name = RSENames.Proto.StorageChestWarehousingMk1.Entity,
            icon = RSEPaths.EntityGFX .. "se-chest-warehousing-mk1.png",
            icon_size = 192,
            minable = {mining_time = 1, result = RSENames.Proto.StorageChestWarehousingMk1.Item},
            max_health = 600,
            collision_box = {{-2.7, -2.7}, {2.7, 2.7}},
            selection_box = {{-3.0, -3.0}, {3.0, 3.0}},
            landing_location_offset = {1.0, -1.0},
            inventory_size = 64,
            picture = {
                filename = RSEPaths.EntityGFX .. "se-chest-warehousing-mk1.png",
                priority = "extra-high",
                width = 192,
                height = 192,
                shift = {0, 0}
            },
            circuit_connector = warehousingChest
        }
    },
    Standard_MK2 = {
        Item = {
            name = RSENames.Proto.StorageChestMk2.Item,
            icon = RSEPaths.EntityGFX .. "se-chest-mk2.png",
            icon_size = 32,
            subgroup = RSEStrings.ItemGroups.StorageEnergistics.SubGroups.Buildings,
            order = RSENames.Proto.StorageChestMk2.Item,
            place_result = RSENames.Proto.StorageChestMk2.Entity
        },
        Recipe = {
            name = RSENames.Proto.StorageChestMk2.Recipe,
            energy_required = 6,
            ingredientsNormal = {
                {RSENames.Proto.PhaseCoil.Item, 8},
                {RSENames.Proto.PatternBuffer.Item, 5},
                {"steel-chest", 5},
                {"electronic-circuit", 10}
            },
            ingredientsEasy = {
                {RSENames.Proto.PhaseCoil.Item, 4},
                {RSENames.Proto.PatternBuffer.Item, 2},
                {"iron-chest", 5},
                {"electronic-circuit", 2}
            },
            result = RSENames.Proto.StorageChestMk2.Item
        },
        Entity = {
            name = RSENames.Proto.StorageChestMk2.Entity,
            icon = RSEPaths.EntityGFX .. "se-chest-mk2.png",
            icon_size = 32,
            minable = {mining_time = 2, result = RSENames.Proto.StorageChestMk2.Item},
            max_health = 500,
            collision_box = {{-0.32, -0.32}, {0.32, 0.32}},
            selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
            landing_location_offset = {0, 0},
            inventory_size = 64,
            picture = {
                filename = RSEPaths.EntityGFX .. "se-chest-mk2.png",
                priority = "extra-high",
                width = 32,
                height = 32,
                shift = {0, 0}
            },
            circuit_connector = normalChest
        }
    },
    Large_MK2 = {
        Item = {
            name = RSENames.Proto.StorageChestLargeMk2.Item,
            icon = RSEPaths.EntityGFX .. "se-chest-large-mk2.png",
            icon_size = 96,
            subgroup = RSEStrings.ItemGroups.StorageEnergistics.SubGroups.Buildings,
            order = RSENames.Proto.StorageChestLargeMk2.Item,
            place_result = RSENames.Proto.StorageChestLargeMk2.Entity
        },
        Recipe = {
            name = RSENames.Proto.StorageChestLargeMk2.Recipe,
            energy_required = 12,
            ingredientsNormal = {
                {RSENames.Proto.PhaseCoil.Item, 16},
                {RSENames.Proto.PatternBuffer.Item, 10},
                {"steel-chest", 10},
                {"electronic-circuit", 20}
            },
            ingredientsEasy = {
                {RSENames.Proto.PhaseCoil.Item, 8},
                {RSENames.Proto.PatternBuffer.Item, 4},
                {"iron-chest", 10},
                {"electronic-circuit", 4}
            },
            result = RSENames.Proto.StorageChestLargeMk2.Item
        },
        Entity = {
            name = RSENames.Proto.StorageChestLargeMk2.Entity,
            icon = RSEPaths.EntityGFX .. "se-chest-large-mk2.png",
            icon_size = 96,
            minable = {mining_time = 2, result = RSENames.Proto.StorageChestLargeMk2.Item},
            max_health = 800,
            collision_box = {{-1.35, -1.35}, {1.35, 1.35}},
            selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
            landing_location_offset = {0, 0},
            inventory_size = 96,
            picture = {
                filename = RSEPaths.EntityGFX .. "se-chest-large-mk2.png",
                priority = "extra-high",
                width = 96,
                height = 96,
                shift = {0, 0}
            },
            circuit_connector = largeChest
        }
    },
    Warehouse_MK2 = {
        Item = {
            name = RSENames.Proto.StorageChestWarehousingMk2.Item,
            icon = RSEPaths.EntityGFX .. "se-chest-warehousing-mk2.png",
            icon_size = 192,
            subgroup = RSEStrings.ItemGroups.StorageEnergistics.SubGroups.Buildings,
            order = RSENames.Proto.StorageChestWarehousingMk2.Item,
            place_result = RSENames.Proto.StorageChestWarehousingMk2.Entity
        },
        Recipe = {
            name = RSENames.Proto.StorageChestWarehousingMk2.Recipe,
            energy_required = 18,
            ingredientsNormal = {
                {RSENames.Proto.PhaseCoil.Item, 16},
                {"steel-chest", 20},
                {"electronic-circuit", 40}
            },
            ingredientsEasy = {
                {RSENames.Proto.PhaseCoil.Item, 8},
                {"iron-chest", 12},
                {"electronic-circuit", 8}
            },
            result = RSENames.Proto.StorageChestWarehousingMk2.Item
        },
        Entity = {
            name = RSENames.Proto.StorageChestWarehousingMk2.Entity,
            icon = RSEPaths.EntityGFX .. "se-chest-warehousing-mk2.png",
            icon_size = 192,
            minable = {mining_time = 2, result = RSENames.Proto.StorageChestWarehousingMk2.Item},
            max_health = 600,
            collision_box = {{-2.7, -2.7}, {2.7, 2.7}},
            selection_box = {{-3.0, -3.0}, {3.0, 3.0}},
            landing_location_offset = {1.0, -1.0},
            inventory_size = 128,
            picture = {
                filename = RSEPaths.EntityGFX .. "se-chest-warehousing-mk2.png",
                priority = "extra-high",
                width = 192,
                height = 192,
                shift = {0, 0}
            },
            circuit_connector = warehousingChest
        }
    }
}
Entities = {
    InterfaceChests = InterfaceChests,
    StorageChests = StorageChests
}
return Entities
