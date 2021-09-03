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
local seStorageChestMk1I = {}

seStorageChestMk1I.type = "item"
seStorageChestMk1I.name = Constants.Names.Proto.StorageChestMk1.Item
seStorageChestMk1I.icon = Constants.DataPaths.EntityGFX .. "se-chest-mk1.png"
seStorageChestMk1I.icon_size = 32
seStorageChestMk1I.subgroup = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Buildings
seStorageChestMk1I.order = Constants.Names.Proto.StorageChestMk1.Item
seStorageChestMk1I.place_result = Constants.Names.Proto.StorageChestMk1.Entity
seStorageChestMk1I.stack_size = 50

--- RECIPE ---
local seStorageChestMk1R = {}

seStorageChestMk1R.type = "recipe"
seStorageChestMk1R.name = Constants.Names.Proto.StorageChestMk1.Recipe
seStorageChestMk1R.enabled = false
seStorageChestMk1R.energy_required = 2
seStorageChestMk1R.ingredients = ingredients
seStorageChestMk1R.result = Constants.Names.Proto.StorageChestMk1.Item

--- ENTITY ---
local seStorageChestMk1E = {}

seStorageChestMk1E.type = "container"
seStorageChestMk1E.name = Constants.Names.Proto.StorageChestMk1.Entity
seStorageChestMk1E.icon = Constants.DataPaths.EntityGFX .. "se-chest-mk1.png"
seStorageChestMk1E.icon_size = 32
seStorageChestMk1E.flags = { "placeable-neutral", "player-creation" }
seStorageChestMk1E.minable = { mining_time = 2, result = Constants.Names.Proto.StorageChestMk1.Item }
seStorageChestMk1E.max_health = 200
seStorageChestMk1E.corpse = "small-remnants"
seStorageChestMk1E.open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.65 }
seStorageChestMk1E.close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 }
seStorageChestMk1E.resistances = {
    {
        type = "fire",
        percent = 80
    },
    {
        type = "impact",
        percent = 30
    }
}
seStorageChestMk1E.collision_box = { { -0.32, -0.32 }, { 0.32, 0.32 } }
seStorageChestMk1E.selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
--collision_box = {{-2.7, -2.7}, {2.7, 2.7}}
--selection_box = {{-3.0, -3.0}, {3.0, 3.0}}
seStorageChestMk1E.fast_replaceable_group = "container"
seStorageChestMk1E.inventory_size = 32
seStorageChestMk1E.vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
seStorageChestMk1E.picture = {
    filename = Constants.DataPaths.EntityGFX .. "se-chest-mk1.png",
    priority = "extra-high",
    width = 32,
    height = 32,
    --width = 256,
    --height = 256,
    shift = { 0, 0 }
}
seStorageChestMk1E.circuit_wire_connection_point = {
    shadow = {
        red = { 0.734375, 0.453125 },
        green = { 0.609375, 0.515625 }
    },
    wire = {
        red = { 0.44625, 0.21875 },
        green = { 0.38625, 0.375 }
    }
}
seStorageChestMk1E.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
seStorageChestMk1E.circuit_wire_max_distance = 9

--- IMPORT se-storage-chest-mk-1 ---
data:extend { seStorageChestMk1I }
data:extend { seStorageChestMk1R }
data:extend { seStorageChestMk1E }