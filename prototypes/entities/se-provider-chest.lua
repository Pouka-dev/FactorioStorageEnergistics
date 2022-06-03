local isNormalMode = settings.startup["se-mod_difficulty"].value == "Normal"

local ingredients
if(isNormalMode) then
    ingredients = 
    {
        { Constants.Names.Proto.PhaseCoil.Item, 5 },
        {"logistic-chest-passive-provider", 1}
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
local seProviderChestI = {}

seProviderChestI.type = "item"
seProviderChestI.name = Constants.Names.Proto.ProviderChest.Item
seProviderChestI.icon = Constants.DataPaths.EntityGFX .. "se-provider-chest.png"
seProviderChestI.icon_size = 32
seProviderChestI.subgroup = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Buildings
seProviderChestI.order = Constants.Names.Proto.ProviderChest.Item
seProviderChestI.place_result = Constants.Names.Proto.ProviderChest.Entity
seProviderChestI.stack_size = 50

--- RECIPE ---
local seProviderChestR = {}

seProviderChestR.type = "recipe"
seProviderChestR.name = Constants.Names.Proto.ProviderChest.Recipe
seProviderChestR.enabled = false
seProviderChestR.energy_required = 3
seProviderChestR.ingredients = ingredients
seProviderChestR.result = Constants.Names.Proto.ProviderChest.Item

--- ENTITY ---
local seProviderChestE = {}

seProviderChestE.type = "logistic-container"
seProviderChestE.name = Constants.Names.Proto.ProviderChest.Entity
seProviderChestE.icon = Constants.DataPaths.EntityGFX .. "se-provider-chest.png"
seProviderChestE.icon_size = 32
seProviderChestE.flags = { "placeable-player", "player-creation" }
seProviderChestE.minable = { hardness = 0.2, mining_time = 0.5, result = Constants.Names.Proto.ProviderChest.Item }
seProviderChestE.max_health = 350
seProviderChestE.corpse = "small-remnants"
seProviderChestE.collision_box = { { -0.32, -0.32 }, { 0.32, 0.32 } }
seProviderChestE.selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
seProviderChestE.resistances = {
    {
        type = "fire",
        percent = 90
    },
    {
        type = "impact",
        percent = 60
    }
}
seProviderChestE.fast_replaceable_group = "container"
seProviderChestE.inventory_size = 64
seProviderChestE.logistic_mode = "passive-provider"
seProviderChestE.open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.65 }
seProviderChestE.close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 }
seProviderChestE.vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
seProviderChestE.picture = {
    filename = Constants.DataPaths.EntityGFX .. "se-provider-chest.png",
    priority = "extra-high",
    width = 32,
    height = 32,
    shift = { 0, 0 }
}
seProviderChestE.circuit_wire_connection_point = circuit_connector_definitions["chest"].points
seProviderChestE.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites
seProviderChestE.circuit_wire_max_distance = 9

--- IMPORT se-provider-chest ---
data:extend { seProviderChestI }
data:extend { seProviderChestR }
data:extend { seProviderChestE }