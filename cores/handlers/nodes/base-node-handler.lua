return function()
    local BaseNodeHandler = {
        HandlerName = SE.Constants.Names.NodeHandlers.Base,
        -- Type: Type of handled nodes.
        Type = SE.Constants.NodeTypes.Device,
        -- NeedsTicks: True if handled nodes will require ticks.
        NeedsTicks = false
    }
    
    -- Valid( Self ) :: bool
    -- Called to check if the node is still valid.
    function BaseNodeHandler:Valid()
        return (self.Entity ~= nil and self.Entity.valid)
    end
    
    -- ExtractPower( Self, Watts) :: int
    -- Called when the network needs power, and ProvidesPower is true.
    -- Return amount of power extracted.
    function BaseNodeHandler:ExtractPower(watts)
        return 0
    end
    
    -- StoredPower( Self ) :: int
    -- Called to determine amount of power stored in the node.
    -- Return amount of power stored.
    function BaseNodeHandler:StoredPower()
        return 0
    end
    
    -- InsertItems( Self, SimpleItemStack, bool ) :: int
    -- Attempts to insert the items.
    -- stack: Items to extract
    -- simulate: When true items will not be transfered, only the counts.
    -- Returns Count of items inserted.
    function BaseNodeHandler:InsertItems(stack, simulate)
    end
    
    -- ExtractItems( Self, SimpleItemStack, bool ) :: int
    -- Attempts to extract the items.
    -- stack: Items to extract
    -- simulate: When true items will not be transfered, only the counts.
    -- Returns Count of items extracted.
    function BaseNodeHandler:ExtractItems(stack, simulate)
        return 0
    end
    
    -- GetItemCount( Self, ItemName ) :: int
    -- Returns how many of the item there is in the node
    function BaseNodeHandler:GetItemCount(itemName)
        return 0
    end
    
    -- GetPosition( Self ) :: Position{x,y}
    function BaseNodeHandler:GetPosition()
        local pos = self.Entity.position
        if (pos.x == nil) then
            pos = {x = pos[1], y = pos[2]}
        end
        return pos
    end
    
    -- GetContents( Self, Map( ItemID :: string => Amount :: uint ) ) :: void
    function BaseNodeHandler:GetContents(catalog)
    end
    
    -- GetCircuitNetwork( Self, WireType ) :: LuaCircuitNetwork
    -- Returns the circuit network or nil
    function BaseNodeHandler:GetCircuitNetwork(wireType)
        if (BaseNodeHandler.Valid(self)) then
            return self.Entity.get_circuit_network(wireType)
        end
        return nil
    end
    
    -- IsFiltered(self :: Node, type :: string) :: bool
    -- Returns true if the node CAN have SE network filters
    -- type: Filter type, item, fluid, etc
    function BaseNodeHandler:IsFiltered(type)
        return false
    end
    
    -- GetFilters(self :: Node, type :: string) :: Array( { Item :: string, Amount :: int } )
    -- Returns this nodes filters, or nil
    -- type: Filter type, item, fluid, etc
    function BaseNodeHandler:GetFilters(type)
        return nil
    end
    
    -- void OnTick(self)
    -- Called when the game ticks, if NeedsTicks is true.
    function BaseNodeHandler:OnTick(tick)
    end
    
    -- OnNetworkTick( Self, Network ) :: void
    -- Called when the network ticks, if NeedsTicks is true.
    -- network: The network that is ticking, this can be either network the node is attached to.
    function BaseNodeHandler:OnNetworkTick(network)
    end
    
    -- OnJoinNetwork( Self, Network ) :: void
    -- Called just after node joins an active network.
    function BaseNodeHandler:OnJoinNetwork(network)
    end
    
    -- OnLeaveNetwork( Self, Network ) :: void
    -- Called just before the node leaves an network.
    function BaseNodeHandler:OnLeaveNetwork(network)
    end
    
    -- OnGetGuiHandler( Self, uint) :: GuiHandler
    -- Called when a player has opened this node
    -- This will only be called if the entity this node represents does something when it is clicked.
    -- Return a GUI handler to show that GUI
    function BaseNodeHandler:OnGetGuiHandler(playerIndex)
        return nil
    end
    
    -- OnPasteSettings( Self, LuaEntity ) :: void
    -- Called when pasting the settings of another entity
    function BaseNodeHandler:OnPasteSettings(sourceEntity)
    --player.print("Would get settings from entity " .. sourceEntity.name)
    end
    
    -- OnPasteSettings( Self, Node ) :: void
    -- Called when pasting the settings of another entity
    function BaseNodeHandler:OnPasteSettingsWithNode(sourceNode)
    --player.print("Would get settings from entity " .. sourceNode.name)
    end
    
    -- OnDestroy( Self ) :: void
    -- The entity is going away
    function BaseNodeHandler:OnDestroy()
    end
    
    -- NewNode( LuaEntity ) :: Node
    -- Creates a new network node
    function BaseNodeHandler.NewNode(entity)
        SE.Logger.Trace("Creating new node")
        return BaseNodeHandler.EnsureStructure(
            {
                -- Entity: The game entity this node represents.
                Entity = entity
            }
    )
    end
    
    -- EnsureStructure( Self ) :: Self
    -- Called to ensure the internal structure of the node is established
    function BaseNodeHandler:EnsureStructure()
        -- Networks: The network(s) the node is attached to.
        -- [defines.wire_type.red],
        -- [defines.wire_type.green]
        self.Networks = self.Networks or {}
        
        -- Name of the handler that implements functionality
        self.HandlerName = self.HandlerName or BaseNodeHandler.HandlerName
        
        -- Calculate chunk position
        self.ChunkPosition = BaseNodeHandler.GetPosition(self)
        self.ChunkPosition.x = math.floor(self.ChunkPosition.x / 32)
        self.ChunkPosition.y = math.floor(self.ChunkPosition.y / 32)
        
        return self
    end
    
    return BaseNodeHandler
end
