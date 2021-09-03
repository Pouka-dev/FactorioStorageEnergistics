local isNormalMode = settings.startup["se-mod_difficulty"].value == "Normal"

local ingredients
if(isNormalMode) then
    ingredients = 
    {
        { Constants.Names.Proto.PhaseCoil.Item, 5 },
        { "logistic-chest-requester", 1}
        
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
local seRequesterChestI = {}

seRequesterChestI.type = "item"
seRequesterChestI.name = Constants.Names.Proto.RequesterChest.Item
seRequesterChestI.icon = Constants.DataPaths.EntityGFX .. "se-requester-chest.png"
seRequesterChestI.icon_size = 32
seRequesterChestI.subgroup = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Buildings
seRequesterChestI.order = Constants.Names.Proto.RequesterChest.Item
seRequesterChestI.place_result = Constants.Names.Proto.RequesterChest.Entity
seRequesterChestI.stack_size = 50

--- RECIPE ---
local seRequesterChestR = {}

seRequesterChestR.type = "recipe"
seRequesterChestR.name = Constants.Names.Proto.RequesterChest.Recipe
seRequesterChestR.enabled = false
seRequesterChestR.energy_required = 3
seRequesterChestR.ingredients = ingredients
seRequesterChestR.result = Constants.Names.Proto.RequesterChest.Item

--- ENTITY ---
local seRequesterChestE = {}

seRequesterChestE.type = "logistic-container"
seRequesterChestE.name = Constants.Names.Proto.RequesterChest.Entity
seRequesterChestE.icon = Constants.DataPaths.EntityGFX .. "se-requester-chest.png"
seRequesterChestE.icon_size = 32
seRequesterChestE.flags = { "placeable-player", "player-creation" }
seRequesterChestE.minable = { hardness = 0.2, mining_time = 0.5, result = Constants.Names.Proto.RequesterChest.Item }
seRequesterChestE.max_health = 350
seRequesterChestE.corpse = "small-remnants"
seRequesterChestE.collision_box = { { -0.32, -0.32 }, { 0.32, 0.32 } }
seRequesterChestE.selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
--collision_box = {{-2.7, -2.7}, {2.7, 2.7}},
--selection_box = {{-3.0, -3.0}, {3.0, 3.0}},
seRequesterChestE.resistances = {
    {
        type = "fire",
        percent = 90
    },
    {
        type = "impact",
        percent = 60
    }
}
seRequesterChestE.fast_replaceable_group = "container"
seRequesterChestE.inventory_size = 64
seRequesterChestE.logistic_slots_count = 24
seRequesterChestE.logistic_mode = "requester"
seRequesterChestE.open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.65 }
seRequesterChestE.close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 }
seRequesterChestE.vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
seRequesterChestE.picture = {
    filename = Constants.DataPaths.EntityGFX .. "se-requester-chest.png",
    priority = "extra-high",
    width = 32,
    height = 32,
    --width = 256,
    --height = 256,
    shift = { 0, 0 }
}
seRequesterChestE.circuit_wire_connection_point = {
    shadow = {
        red = { 0.734375, 0.453125 },
        green = { 0.609375, 0.515625 }
    },
    wire = {
        red = { 0.44625, 0.21875 },
        green = { 0.38625, 0.375 }
    }
}
seRequesterChestE.circuit_wire_max_distance = 9
seRequesterChestE.circuit_connector_sprites = circuit_connector_definitions["chest"].sprites

--- IMPORT se-requester-chest ---
data:extend { seRequesterChestI }
data:extend { seRequesterChestR }
data:extend { seRequesterChestE }