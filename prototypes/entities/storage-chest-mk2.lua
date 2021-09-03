local isNormalMode = settings.startup["se-mod_difficulty"].value == "Normal"

local ingredients
if(isNormalMode) then
    ingredients = 
    {
        { Constants.Names.Proto.PhaseCoil.Item, 8 },
        { Constants.Names.Proto.PatternBuffer.Item, 5 },
        { "steel-chest", 5},
        { "electronic-circuit", 10 }
        
    }
else
    ingredients = 
    {
        { Constants.Names.Proto.PhaseCoil.Item, 4 },
        { Constants.Names.Proto.PatternBuffer.Item, 2 },
        { "iron-chest", 5},
        { "electronic-circuit", 2 }
    }
end

--- ITEM ---
local seStorageChestMk2I = {}

seStorageChestMk2I.type = "item"
seStorageChestMk2I.name = Constants.Names.Proto.StorageChestMk2.Item
seStorageChestMk2I.icon = Constants.DataPaths.EntityGFX .. "se-chest-mk2.png"
seStorageChestMk2I.icon_size = 32
seStorageChestMk2I.subgroup = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Buildings
seStorageChestMk2I.order = Constants.Names.Proto.StorageChestMk2.Item
seStorageChestMk2I.place_result = Constants.Names.Proto.StorageChestMk2.Entity
seStorageChestMk2I.stack_size = 50

--- RECIPE ---
local seStorageChestMk2R = {}

seStorageChestMk2R.type = "recipe"
seStorageChestMk2R.name = Constants.Names.Proto.StorageChestMk2.Recipe
seStorageChestMk2R.enabled = false
seStorageChestMk2R.energy_required = 6
seStorageChestMk2R.ingredients = ingredients
seStorageChestMk2R.result = Constants.Names.Proto.StorageChestMk2.Item

--- ENTITY ---
local seStorageChestMk2E = {}

seStorageChestMk2E.type = "container"
seStorageChestMk2E.name = Constants.Names.Proto.StorageChestMk2.Entity
seStorageChestMk2E.icon = Constants.DataPaths.EntityGFX .. "se-chest-mk2.png"
seStorageChestMk2E.icon_size = 32
seStorageChestMk2E.flags = { "placeable-neutral", "player-creation" }
seStorageChestMk2E.minable = { mining_time = 2, result = Constants.Names.Proto.StorageChestMk2.Item }
seStorageChestMk2E.max_health = 500
seStorageChestMk2E.corpse = "small-remnants"
seStorageChestMk2E.open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.65 }
seStorageChestMk2E.close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 }
seStorageChestMk2E.resistances = {
    {
        type = "fire",
        percent = 90
    },
    {
        type = "impact",
        percent = 10
    }
}
seStorageChestMk2E.collision_box = { { -0.32, -0.32 }, { 0.32, 0.32 } }
seStorageChestMk2E.selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
--collision_box = {{-2.7, -2.7}, {2.7, 2.7}}
--selection_box = {{-3.0, -3.0}, {3.0, 3.0}}
seStorageChestMk2E.fast_replaceable_group = "container"
seStorageChestMk2E.inventory_size = 128
seStorageChestMk2E.vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
seStorageChestMk2E.picture = {
    filename = Constants.DataPaths.EntityGFX .. "se-chest-mk2.png",
    priority = "extra-high",
    width = 32,
    height = 32,
    --width = 256,
    --height = 256,
    shift = { 0, 0 }
}
seStorageChestMk2E.circuit_wire_connection_point = {
    shadow = {
        red = { 0.734375, 0.453125 },
        green = { 0.609375, 0.515625 }
    },
    wire = {
        red = { 0.44625, 0.21875 },
        green = { 0.38625, 0.375 }
    }
}
seStorageChestMk2E.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
seStorageChestMk2E.circuit_wire_max_distance = 9

--- IMPORT se-storage-chest-mk-2 ---
data:extend { seStorageChestMk2I }
data:extend { seStorageChestMk2R }
data:extend { seStorageChestMk2E }