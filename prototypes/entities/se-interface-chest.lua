local isNormalMode = settings.startup["se-mod_difficulty"].value == "Normal"

local ingredients
if(isNormalMode) then
    ingredients = 
    {
        { Constants.Names.Proto.PhaseCoil.Item, 4 },
        { "steel-chest", 5},
        { "electronic-circuit", 10 }
    }
else
    ingredients = 
    {
        { Constants.Names.Proto.PhaseCoil.Item, 2 },
        { "iron-chest", 5},
        { "electronic-circuit", 2 }
    }
end

--- ITEM ---
local seInterfaceChestI = {}

seInterfaceChestI.type = "item"
seInterfaceChestI.name = Constants.Names.Proto.InterfaceChest.Item
seInterfaceChestI.icon = Constants.DataPaths.EntityGFX .. "se-interface-chest.png"
seInterfaceChestI.icon_size = 32
seInterfaceChestI.subgroup = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Buildings
seInterfaceChestI.order = Constants.Names.Proto.InterfaceChest.Item
seInterfaceChestI.place_result = Constants.Names.Proto.InterfaceChest.Entity
seInterfaceChestI.stack_size = 50


--- RECIPE ---
local seInterfaceChestR = {}

seInterfaceChestR.type = "recipe"
seInterfaceChestR.name = Constants.Names.Proto.InterfaceChest.Recipe
seInterfaceChestR.enabled = false
seInterfaceChestR.energy_required = 4
seInterfaceChestR.ingredients = ingredients
seInterfaceChestR.result = Constants.Names.Proto.InterfaceChest.Item



--- ENTITY ---
local seInterfaceChestE = {}

seInterfaceChestE.type = "container"
seInterfaceChestE.name = Constants.Names.Proto.InterfaceChest.Entity
seInterfaceChestE.icon = Constants.DataPaths.EntityGFX .. "se-interface-chest.png"
seInterfaceChestE.icon_size = 32
seInterfaceChestE.flags = { "placeable-neutral", "player-creation" }
seInterfaceChestE.minable = { mining_time = 1, result = Constants.Names.Proto.InterfaceChest.Item }
seInterfaceChestE.max_health = 200
seInterfaceChestE.corpse = "small-remnants"
seInterfaceChestE.open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.65 }
seInterfaceChestE.close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 }
seInterfaceChestE.resistances = {
    {
        type = "fire",
        percent = 80
    },
    {
        type = "impact",
        percent = 30
    }
}
seInterfaceChestE.collision_box = { { -0.32, -0.32 }, { 0.32, 0.32 } }
seInterfaceChestE.selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
seInterfaceChestE.fast_replaceable_group = "container"
seInterfaceChestE.inventory_size = 64
seInterfaceChestE.vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
seInterfaceChestE.picture = {
    filename = Constants.DataPaths.EntityGFX .. "se-interface-chest.png",
    priority = "extra-high",
    width = 32,
    height = 32,
    --width = 256,
    --height = 256,
    shift = { 0, 0 }
}
seInterfaceChestE.circuit_wire_connection_point = {
    shadow = {
        red = { 0.734375, 0.453125 },
        green = { 0.609375, 0.515625 }
    },
    wire = {
        red = { 0.44625, 0.21875 },
        green = { 0.38625, 0.375 }
    }
}
seInterfaceChestE.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
seInterfaceChestE.circuit_wire_max_distance = 9

--- IMPORT se-interface-chest ---
data:extend { seInterfaceChestI }
data:extend { seInterfaceChestR }
data:extend { seInterfaceChestE }
