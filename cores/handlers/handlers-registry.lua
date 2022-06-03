NodeHandlersRegistryConstructor = newclass(Object,function(base,...)
    Object.init(base,...)
    -- Map( EntityName - > HandlerName )
    base.EntityToHandlerMap = {}
    -- Map( HandlerName -> Handler )
    base.Handlers  = {}
  end)

    -- AddHandler( NodeHandler ) :: void
    -- Adds a node handler
    function NodeHandlersRegistryConstructor:AddHandler(handler)
        self.Handlers[handler.HandlerName] = handler
    end

    -- GetHandler( string ) :: NodeHandler
    -- Gets a node handler by name
    function NodeHandlersRegistryConstructor:GetHandler(name)
        return self.Handlers[name]
    end

    -- GetNodeHandler( Node ) :: NodeHandler
    -- Gets the handler for the given node
    function NodeHandlersRegistryConstructor:GetNodeHandler(node)
        if (node == nil) then
            error("GetNodeHandler: Expected node, got nil")
        end
        if (node.HandlerName == nil) then
            error("GetNodeHandler: Malformed node, missing HandlerName.\nNode:" .. serpent.block(node))
        end
        return self.Handlers[node.HandlerName]
    end

    -- GetEntityHandler( LuaEntity ) :: NodeHandler
    -- Get the handler for the given entity
    function NodeHandlersRegistryConstructor:GetEntityHandler(entity)
        local handlerName = self.EntityToHandlerMap[entity.name]
        if (handlerName == nil) then
            return nil
        end
        return self.Handlers[handlerName]
    end

    -- AddEntityHandler( string, string )
    -- Maps an entity(by name) to a node handler(also by name)
    -- Such that the handler for that name, will control the entity for its name
    function NodeHandlersRegistryConstructor:AddEntityHandler(entityName, handlerName)
        self.EntityToHandlerMap[entityName] = handlerName
    end

