-- Description: Defines the event handlers for when event effects entities
-- Constructs and returns the EntityHandlers object
return function()
    local CreationHandlers = {}
    local DestructionHandlers = {}
    local EntityHandlers = {
        Creation = CreationHandlers,
        Destruction = DestructionHandlers
    }
    
    -- OnEntityBuilt( LuaEntity, Event ) :: void
    -- Called by when either a player or bot builds an entity
    function CreationHandlers.OnEntityBuilt(entity, event)
        local handler = SE.NodeHandlersRegistry.GetEntityHandler(entity)
        if (handler ~= nil) then
            SE.Logger.Trace("Entity Handler: Adding network node " .. handler.HandlerName)
            local newNode = SE.NetworksManager.AddNode(handler.NewNode(entity))
            EntityHandlers.OnPasteSettingsWithNode(entity, newNode, event)
        end
    end
    
    -- OnBuiltByPlayer( Event ) :: void
    -- Called when player builds something.
    -- Event fields:
    -- - created_entity :: LuaEntity
    -- - player_index :: uint
    -- - item :: string (optional)
    -- - tags :: dictionary string -> Any (optional)
    function CreationHandlers.OnBuiltByPlayer(event)
        CreationHandlers.OnEntityBuilt(event.created_entity, event)
    end
    
    -- OnBuiltByBot( Event ) :: void
    -- Called when a construction robot builds an entity.
    -- Event fields:
    -- - robot :: LuaEntity
    -- - created_entity :: LuaEntity
    -- - item :: string (optional)
    -- - tags :: dictionary string -> Any (optional)
    function CreationHandlers.OnBuiltByBot(event)
        CreationHandlers.OnEntityBuilt(event.created_entity, event)
    end
    
    -- OnUnMarked( Event ) :: void
    -- Called when the deconstruction of an entity is canceled.
    -- Event fields:
    -- - entity :: LuaEntity
    -- - player_index :: uint (optional)
    function CreationHandlers.OnUnMarked(event)
        CreationHandlers.OnEntityBuilt(event.entity, event)
    end
    
    -- OnEntityRemoved( LuaEntity ) :: void
    -- Called when an entity is, or will be, removed from the game
    function DestructionHandlers.OnEntityRemoved(entity)
        local handler = SE.NodeHandlersRegistry.GetEntityHandler(entity)
        if (handler ~= nil) then
            SE.NetworksManager.RemoveNodeByEntity(entity)
        end
    end
    
    -- OnMinedByPlayer( Event ) :: void
    -- Called after the results of an entity being mined are collected just before the entity is destroyed. After this event any items in the buffer will be transferred into the player as if they came from mining the entity.
    -- Event fields:
    -- - player_index :: uint
    -- - entity :: LuaEntity
    -- - buffer :: LuaInventory: The temporary inventory that holds the result of mining the entity.
    -- Note: The buffer inventory is special in that it's only valid during this event and has a dynamic size expanding as more items are transferred into it.
    function DestructionHandlers.OnMinedByPlayer(event)
        DestructionHandlers.OnEntityRemoved(event.entity)
    end
    
    -- OnMinedByBot( Event ) :: void
    -- Called after the results of an entity being mined are collected just before the entity is destroyed. After this event any items in the buffer will be transferred into the robot as if they came from mining the entity.
    -- Event fields:
    -- - robot :: LuaEntity
    -- - entity :: LuaEntity
    -- - buffer :: LuaInventory: The temporary inventory that holds the result of mining the entity.
    -- Note: The buffer inventory is special in that it's only valid during this event and has a dynamic size expanding as more items are transferred into it.
    function DestructionHandlers.OnMinedByBot(event)
        DestructionHandlers.OnEntityRemoved(event.entity)
    end
    
    -- OnKilled( Event )
    -- Called when an entity dies.
    -- Event fields:
    -- - entity :: LuaEntity
    -- - cause :: LuaEntity (optional)
    -- - force :: LuaForce (optional)
    function DestructionHandlers.OnKilled(event)
        DestructionHandlers.OnEntityRemoved(event.entity)
    end
    
    local thingy = function()
        end
    
    -- OnMarked( Event ) :: void
    -- Called when an entity is marked for deconstruction with the Deconstruction planner or via script.
    -- Event fields:
    -- - entity :: LuaEntity
    -- - player_index :: uint (optional)
    function DestructionHandlers.OnMarked(event)
        DestructionHandlers.OnEntityRemoved(event.entity)
    end
    
    -- OnPasteSettings( Event )
    -- Called after entity copy-paste is done.
    -- Event fields:
    -- - player_index :: uint
    -- - source :: LuaEntity: The source entity settings have been copied from.
    -- - destination :: LuaEntity: The destination entity settings have been copied to.
    function EntityHandlers.OnPasteSettings(event)
        local player = Player.load(event).get()
        local destEntity = event.destination
        local handler = SE.NodeHandlersRegistry.GetEntityHandler(destEntity)
        if (handler ~= nil) then
            local destNode = SE.NetworksManager.GetNodeForEntity(destEntity)
            if (destNode ~= nil) then
                handler.OnPasteSettings(destNode, event.source)
            end
        end
    end
    
    
    -- OnPasteSettingsWithNode( LuaEntity, Node, Event )
    -- Called after entity copy-paste is done.
    -- Event fields:
    -- - entity :: LuaEntity: The source entity settings have been copied from.
    -- - newNode :: Node: New node where the parameters will have to be pasted.
    -- - event :: Event: Event, containing the potential information of a tag in the blueprint.
    function EntityHandlers.OnPasteSettingsWithNode(entity, newNode, event)
        local handler = SE.NodeHandlersRegistry.GetEntityHandler(entity)
        if (handler ~= nil) then
            if (event.tags ~= nil) then
                handler.OnPasteSettingsWithNode(newNode, event.tags)
            end
        end
    end
    
    
    function EntityHandlers.OnPreEntitySettingsPasted(event)
        local player = Player.load(event).get()
    end
    function EntityHandlers.OnPlayerSetupBlueprint(event)
        local player = game.players[event.player_index]
        local mapping = event.mapping.get()
        local bp = player.blueprint_to_setup
        if bp.valid_for_read == false then
            local cursor = player.cursor_stack
            if cursor and cursor.valid_for_read and cursor.name == "blueprint" then
                bp = cursor
            --return
            end
        end
        if bp == nil or bp.valid_for_read == false then return end
        
        for index, ent in pairs(mapping) do
            local tags = EntityHandlers.EntityToBlueprintTags(ent)
            if tags ~= nil then
                for tag, value in pairs(tags) do
                    bp.set_blueprint_entity_tag(index, tag, value)
                end
            end
        end
    
    end
    function EntityHandlers.OnPlayerConfiguredBlueprint(event)
        local player = Player.load(event).get()
    end
    
    
    
    function EntityHandlers.EntityToBlueprintTags(copyEntity, fromTable)
        
        local tags = nil
        local handler = SE.NodeHandlersRegistry.GetEntityHandler(copyEntity)
        if (handler ~= nil) then
            tags = SE.NetworksManager.GetNodeForEntity(copyEntity)
        end
        return tags
    end
    
    
    
    
    
    -- RegisterWithGame() :: void
    -- Registers event listeners with the game.
    function EntityHandlers.RegisterWithGame()
        script.on_event(defines.events.on_entity_settings_pasted, EntityHandlers.OnPasteSettings)
        script.on_event(defines.events.on_pre_entity_settings_pasted, EntityHandlers.OnPreEntitySettingsPasted)
        script.on_event(defines.events.on_player_setup_blueprint, EntityHandlers.OnPlayerSetupBlueprint)
        script.on_event(defines.events.on_player_configured_blueprint, EntityHandlers.OnPlayerConfiguredBlueprint)
        
        
        
        
        -- Creation
        script.on_event(defines.events.on_built_entity, EntityHandlers.Creation.OnBuiltByPlayer)
        script.on_event(defines.events.on_robot_built_entity, EntityHandlers.Creation.OnBuiltByBot)
        script.on_event(defines.events.on_cancelled_deconstruction, EntityHandlers.Creation.OnUnMarked)
        -- Destruction
        script.on_event(defines.events.on_marked_for_deconstruction, EntityHandlers.Destruction.OnMarked)
        script.on_event(defines.events.on_player_mined_entity, EntityHandlers.Destruction.OnMinedByPlayer)
        script.on_event(defines.events.on_entity_died, EntityHandlers.Destruction.OnKilled)
    end
    
    return EntityHandlers
end
