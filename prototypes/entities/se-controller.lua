local isNormalMode = settings.startup["se-mod_difficulty"].value == "Normal"

local ingredients
if(isNormalMode) then
    ingredients = 
    {
        { Constants.Names.Proto.PetroQuartz.Item, 10 },
        { "copper-cable", 50 },
        { "electronic-circuit", 20 }
    }
else
    ingredients = 
    {
        { Constants.Names.Proto.PetroQuartz.Item, 1 },
        { "copper-cable", 5 },
        { "electronic-circuit", 2 }
    }
end

--- ITEMS ---
local seControllerI = {}

seControllerI.type = "item"
seControllerI.name = Constants.Names.Proto.Controller.Item
seControllerI.icon = Constants.DataPaths.Icons .. "se-controller.png"
seControllerI.icon_size = 32
seControllerI.subgroup = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Buildings
seControllerI.order = Constants.Names.Proto.Controller.Item
seControllerI.place_result = Constants.Names.Proto.Controller.Entity
seControllerI.stack_size = 50


--- RECIPE ---
local seControllerR = {}

seControllerR.type = "recipe"
seControllerR.name = Constants.Names.Proto.Controller.Recipe
seControllerR.enabled = false
seControllerR.energy_required = 3
seControllerR.ingredients = ingredients
seControllerR.result = Constants.Names.Proto.Controller.Item


--- ENTITY --- {
local seControllerE = {}

seControllerE.type = "constant-combinator"
seControllerE.name = Constants.Names.Proto.Controller.Entity
seControllerE.icon = Constants.DataPaths.Icons .. "se-controller.png"
seControllerE.icon_size = 32
seControllerE.flags = { "placeable-neutral", "player-creation" }
seControllerE.minable = { hardness = 0.4, mining_time = 0.7, result = Constants.Names.Proto.Controller.Item }
seControllerE.max_health = 1000
seControllerE.corpse = "small-remnants"
seControllerE.collision_box = { { -0.32, -0.32 }, { 0.32, 0.32 } }
seControllerE.selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
seControllerE.item_slot_count = 2
seControllerE.sprites = {
    east = {
        filename = Constants.DataPaths.EntityGFX .. "se-controller.png",
        x = 0,
        y = 0,
        width = 79,
        height = 63,
        frame_count = 1,
        shift = { 0.42017, 0.14063 }
    },
    west = {
        filename = Constants.DataPaths.EntityGFX .. "se-controller.png",
        x = 79,
        y = 0,
        width = 79,
        height = 63,
        frame_count = 1,
        shift = { 0.42017, 0.14063 }
    },
    north = {
        filename = Constants.DataPaths.EntityGFX .. "se-controller.png",
        x = 158,
        y = 0,
        width = 79,
        height = 63,
        frame_count = 1,
        shift = { 0.42017, 0.14063 }
    },
    south = {
        filename = Constants.DataPaths.EntityGFX .. "se-controller.png",
        x = 0,
        y = 0,
        width = 79,
        height = 63,
        frame_count = 1,
        shift = { 0.42017, 0.14063 }
    }
}
seControllerE.activity_led_sprites = {
    north = {
        filename = "__base__/graphics/entity/combinator/activity-leds/arithmetic-combinator-LED-N.png",
        width = 32,
        height = 8,
        frame_count = 1,
        shift = { 0.296875, -0.40625 }
    },
    east = {
        filename = "__base__/graphics/entity/combinator/activity-leds/arithmetic-combinator-LED-E.png",
        width = 32,
        height = 8,
        frame_count = 1,
        shift = { 0.25, -0.03125 }
    },
    south = {
        filename = "__base__/graphics/entity/combinator/activity-leds/arithmetic-combinator-LED-S.png",
        width = 32,
        height = 8,
        frame_count = 1,
        shift = { -0.296875, -0.078125 }
    },
    west = {
        filename = "__base__/graphics/entity/combinator/activity-leds/arithmetic-combinator-LED-W.png",
        width = 32,
        height = 8,
        frame_count = 1,
        shift = { -0.21875, -0.46875 }
    }
}
seControllerE.activity_led_light = {
    intensity = 0.8,
    size = 1
}
seControllerE.activity_led_light_offsets = {
    { 0.296875, -0.40625 },
    { 0.25, -0.03125 },
    { -0.296875, -0.078125 },
    { -0.21875, -0.46875 }
}
seControllerE.circuit_wire_connection_points = {
    {
        shadow = {
            red = { 0.15625, -0.28125 },
            green = { 0.65625, -0.25 }
        },
        wire = {
            red = { -0.28125, -0.5625 },
            green = { 0.21875, -0.5625 }
        }
    },
    {
        shadow = {
            red = { 0.75, -0.15625 },
            green = { 0.75, 0.25 }
        },
        wire = {
            red = { 0.46875, -0.5 },
            green = { 0.46875, -0.09375 }
        }
    },
    {
        shadow = {
            red = { 0.75, 0.5625 },
            green = { 0.21875, 0.5625 }
        },
        wire = {
            red = { 0.28125, 0.15625 },
            green = { -0.21875, 0.15625 }
        }
    },
    {
        shadow = {
            red = { -0.03125, 0.28125 },
            green = { -0.03125, -0.125 }
        },
        wire = {
            red = { -0.46875, 0 },
            green = { -0.46875, -0.40625 }
        }
    }
}
seControllerE.circuit_wire_max_distance = 9

--- IMPORT se-controller ---
data:extend { seControllerI }
data:extend { seControllerR }
data:extend { seControllerE }
