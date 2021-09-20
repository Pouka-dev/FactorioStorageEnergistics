local isNormalMode = settings.startup["se-mod_difficulty"].value == "Normal"

local ingredients
if(isNormalMode) then
    ingredients = 
    {
        { Constants.Names.Proto.PetroQuartz.Item, 20 },
        { "iron-plate", 10 },
        { "copper-plate", 10 },
        { "battery", 10 }
    }
else
    ingredients = 
    {
        { Constants.Names.Proto.PetroQuartz.Item, 2 },
        { "iron-plate", 4 },
        { "copper-plate", 4 },
        { "electronic-circuit", 5 }
    }
end

--- ITEM ---
local seEnergyAcceptorI = {}

seEnergyAcceptorI.type = "item"
seEnergyAcceptorI.name = Constants.Names.Proto.EnergyAcceptor.Item
seEnergyAcceptorI.icon = Constants.DataPaths.Icons .. "se-energy-acceptor.png"
seEnergyAcceptorI.icon_size = 32
seEnergyAcceptorI.subgroup = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Buildings
seEnergyAcceptorI.order = Constants.Names.Proto.EnergyAcceptor.Item
seEnergyAcceptorI.place_result = Constants.Names.Proto.EnergyAcceptor.Entity
seEnergyAcceptorI.stack_size = 50

--- RECIPE ---
local seEnergyAcceptorR = {}

seEnergyAcceptorR.type = "recipe"
seEnergyAcceptorR.name = Constants.Names.Proto.EnergyAcceptor.Recipe
seEnergyAcceptorR.enabled = false
seEnergyAcceptorR.energy_required = 5
seEnergyAcceptorR.result = Constants.Names.Proto.EnergyAcceptor.Item
seEnergyAcceptorR.ingredients = ingredients

--- ENTITY ---
local seEnergyAcceptorE = {}

seEnergyAcceptorE.type = "accumulator"
seEnergyAcceptorE.name = Constants.Names.Proto.EnergyAcceptor.Entity
seEnergyAcceptorE.icon = Constants.DataPaths.Icons .. "se-energy-acceptor.png"
seEnergyAcceptorE.icon_size = 32
seEnergyAcceptorE.flags = { "placeable-neutral", "player-creation" }
seEnergyAcceptorE.minable = { hardness = 0.2, mining_time = 0.4, result = Constants.Names.Proto.EnergyAcceptor.Item }
seEnergyAcceptorE.max_health = 100
seEnergyAcceptorE.corpse = "small-remnants"
seEnergyAcceptorE.collision_box = { { -0.9, -0.9 }, { 0.9, 0.9 } }
seEnergyAcceptorE.selection_box = { { -1, -1 }, { 1, 1 } }
seEnergyAcceptorE.energy_source = {
    type = "electric",
    usage_priority = "tertiary",
    input_flow_limit = "0W",
    output_flow_limit = "0W",
    buffer_capacity = "10MJ"
}
seEnergyAcceptorE.picture = {
    filename = Constants.DataPaths.EntityGFX .. "se-energy-acceptor.png",
    priority = "high",
    width = 124,
    height = 103,
    shift = { 0.6875, -0.203125 }
}
seEnergyAcceptorE.charge_animation = {
    filename = Constants.DataPaths.EntityGFX .. "se-energy-acceptor.png",
    width = 124,
    height = 103,
    line_length = 1,
    frame_count = 1,
    shift = { 0.6875, -0.203125 },
    animation_speed = 1
}
seEnergyAcceptorE.charge_cooldown = 30
seEnergyAcceptorE.charge_light = { intensity = 0.3, size = 7 }
seEnergyAcceptorE.discharge_animation = {
    filename = Constants.DataPaths.EntityGFX .. "se-energy-acceptor.png",
    width = 124,
    height = 103,
    line_length = 1,
    frame_count = 1,
    shift = { 0.6875, -0.203125 },
    animation_speed = 1
}
seEnergyAcceptorE.discharge_cooldown = 30
seEnergyAcceptorE.discharge_light = { intensity = 0.0, size = 1 }
seEnergyAcceptorE.circuit_wire_connection_point = circuit_connector_definitions["accumulator"].points
seEnergyAcceptorE.circuit_connector_sprites = circuit_connector_definitions["accumulator"].sprites
seEnergyAcceptorE.circuit_wire_max_distance = 9
seEnergyAcceptorE.vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.7 }
seEnergyAcceptorE.map_color = { r = 0.61, g = 0.23, b = 0.64 }

--- ENTITY ---
local seEnergyAcceptorInterfaceE = {}

seEnergyAcceptorInterfaceE.type = "electric-energy-interface"
seEnergyAcceptorInterfaceE.name = "hidden-" .. Constants.Names.Proto.EnergyAcceptor.Entity
seEnergyAcceptorInterfaceE.icon = Constants.DataPaths.Icons .. "se-energy-acceptor.png"
seEnergyAcceptorInterfaceE.icon_size = 32
seEnergyAcceptorInterfaceE.flags = {}
seEnergyAcceptorInterfaceE.max_health = 150
seEnergyAcceptorInterfaceE.indestructible = true
seEnergyAcceptorInterfaceE.collision_box = { { -0.9, -0.9 }, { 0.9, 0.9 } }
seEnergyAcceptorInterfaceE.selection_box = { { -1, -1 }, { 1, 1 } }
seEnergyAcceptorInterfaceE.selectable_in_game = false
seEnergyAcceptorInterfaceE.energy_source = {
    type = "electric",
    buffer_capacity = "10MJ",
    usage_priority = "secondary-input",
    input_flow_limit = "500kW",
    output_flow_limit = "0kW"
}
seEnergyAcceptorInterfaceE.energy_production = "0kW"
seEnergyAcceptorInterfaceE.energy_usage = "0kW"
seEnergyAcceptorInterfaceE.picture = {
    filename = Constants.DataPaths.EntityGFX .. "se-energy-acceptor.png",
    priority = "low",
    width = 124,
    height = 103,
    shift = { 0.6875, -0.203125 }
}
seEnergyAcceptorInterfaceE.order = "h-e-e-i"

--- IMPORT se-energy-acceptor ---
data:extend { seEnergyAcceptorI }
data:extend { seEnergyAcceptorR }
data:extend { seEnergyAcceptorE }
data:extend { seEnergyAcceptorInterfaceE }