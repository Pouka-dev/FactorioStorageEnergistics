local isNormalMode = settings.startup["se-mod_difficulty"].value == "Normal"
local ingredients

for _, interfaceChest in pairs(Constants.Entities.InterfaceChests) do
    
    if (isNormalMode) then
        ingredients = interfaceChest.Recipe.ingredientsNormal
    else
        ingredients = interfaceChest.Recipe.ingredientsEasy
    end
    
    --- ITEM ---
    local seInterfaceChestI = {}
    
    seInterfaceChestI.type = "item"
    seInterfaceChestI.name = interfaceChest.Item.name
    seInterfaceChestI.icon = interfaceChest.Item.icon
    seInterfaceChestI.icon_size = interfaceChest.Item.icon_size
    seInterfaceChestI.subgroup = interfaceChest.Item.subgroup
    seInterfaceChestI.order = interfaceChest.Item.order
    seInterfaceChestI.place_result = interfaceChest.Item.place_result
    seInterfaceChestI.stack_size = 50
    
    
    --- RECIPE ---
    local seInterfaceChestR = {}
    
    seInterfaceChestR.type = "recipe"
    seInterfaceChestR.name = interfaceChest.Recipe.name
    seInterfaceChestR.enabled = false
    seInterfaceChestR.energy_required = 4
    seInterfaceChestR.ingredients = ingredients
    seInterfaceChestR.result = interfaceChest.Recipe.result
    
    
    
    --- ENTITY ---
    local seInterfaceChestE = {}
    
    seInterfaceChestE.type = "container"
    seInterfaceChestE.name = interfaceChest.Entity.name
    seInterfaceChestE.icon = interfaceChest.Entity.icon
    seInterfaceChestE.icon_size = interfaceChest.Entity.icon_size
    seInterfaceChestE.flags = {"placeable-neutral", "player-creation"}
    seInterfaceChestE.minable = interfaceChest.Entity.minable
    seInterfaceChestE.max_health = 200
    seInterfaceChestE.corpse = "small-remnants"
    seInterfaceChestE.open_sound = {filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.65}
    seInterfaceChestE.close_sound = {filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7}
    seInterfaceChestE.resistances = {{type = "fire", percent = 80}, {type = "impact", percent = 30}}
    seInterfaceChestE.collision_box = interfaceChest.Entity.collision_box
    seInterfaceChestE.selection_box = interfaceChest.Entity.selection_box
    seInterfaceChestE.landing_location_offset = interfaceChest.Entity.landing_location_offsetb
    seInterfaceChestE.fast_replaceable_group = "container"
    seInterfaceChestE.inventory_size = interfaceChest.Entity.inventory_size
    seInterfaceChestE.vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65}
    seInterfaceChestE.picture = interfaceChest.Entity.picture
    seInterfaceChestE.circuit_wire_connection_point = interfaceChest.Entity.circuit_connector.points
    seInterfaceChestE.circuit_connector_sprites = interfaceChest.Entity.circuit_connector.sprites
    seInterfaceChestE.circuit_wire_max_distance = 9
    
    --- IMPORT se-interface-chest ---
    data:extend{seInterfaceChestI}
    data:extend{seInterfaceChestR}
    data:extend{seInterfaceChestE}
end
