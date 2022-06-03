local isNormalMode = settings.startup["se-mod_difficulty"].value == "Normal"

local ingredients

for _, storageChest in pairs(Constants.Entities.StorageChests) do
    
    if (isNormalMode) then
        ingredients = storageChest.Recipe.ingredientsNormal
    else
        ingredients = storageChest.Recipe.ingredientsEasy
    end
    
    
    --- ITEM ---
    local seStorageChestI = {}
    
    seStorageChestI.type = "item"
    seStorageChestI.name = storageChest.Item.name
    seStorageChestI.icon = storageChest.Item.icon
    seStorageChestI.icon_size = storageChest.Item.icon_size
    seStorageChestI.subgroup = storageChest.Item.subgroup
    seStorageChestI.order = storageChest.Item.order
    seStorageChestI.place_result = storageChest.Item.place_result
    seStorageChestI.stack_size = 50
    
    --- RECIPE ---
    local seStorageChestR = {}
    
    seStorageChestR.type = "recipe"
    seStorageChestR.name = storageChest.Recipe.name
    seStorageChestR.enabled = false
    seStorageChestR.energy_required = storageChest.Recipe.energy_required
    seStorageChestR.ingredients = ingredients
    seStorageChestR.result = storageChest.Recipe.result
    
    --- ENTITY ---
    local seStorageChestE = {}
    
    seStorageChestE.type = "container"
    seStorageChestE.name = storageChest.Entity.name
    seStorageChestE.icon = storageChest.Entity.icon
    seStorageChestE.icon_size = storageChest.Entity.icon_size
    seStorageChestE.flags = {"placeable-neutral", "player-creation"}
    seStorageChestE.minable = storageChest.Entity.minable
    seStorageChestE.max_health = storageChest.Entity.max_health
    seStorageChestE.corpse = "small-remnants"
    seStorageChestE.open_sound = {filename = "__base__/sound/metallic-chest-open.ogg", volume = 0.65}
    seStorageChestE.close_sound = {filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7}
    seStorageChestE.resistances = {
        {
            type = "fire",
            percent = 80
        },
        {
            type = "impact",
            percent = 30
        }
    }
    seStorageChestE.collision_box = storageChest.Entity.collision_box
    seStorageChestE.selection_box = storageChest.Entity.selection_box
    seStorageChestE.landing_location_offset = storageChest.Entity.landing_location_offset
    seStorageChestE.fast_replaceable_group = "container"
    seStorageChestE.inventory_size = storageChest.Entity.inventory_size
    seStorageChestE.vehicle_impact_sound = {filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65}
    seStorageChestE.picture = storageChest.Entity.picture
    seStorageChestE.circuit_wire_connection_point = storageChest.Entity.circuit_connector.points
    seStorageChestE.circuit_connector_sprites = storageChest.Entity.circuit_connector.sprites
    seStorageChestE.circuit_wire_max_distance = 9
    
    --- IMPORT se-storage-chest ---
    data:extend{seStorageChestI}
    data:extend{seStorageChestR}
    data:extend{seStorageChestE}

end
