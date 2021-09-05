return function()
    local NetworksManagerObject = {}
    
    local NetworkTickRate = 30
    local LastNetworkTick = 0
    
    -- All Nodes
    -- Sequential array
    -- Serialized
    local Nodes = nil
    
    -- Map( CircuitNetworkID -> Network )
    local Networks = {}
    
    -- Map ( Node -> Handler )
    local TickingNodes = {}
    
    -- Returns the index of the given node
    local function GetNodeIndex(node)
        for idx = 1, #Nodes do
            if (node == Nodes[idx]) then
                return idx
            end
        end
        return 0
    end
    
    -- Gets the network for the given node and wire type, will create one if no network is found
    -- Will return nil if the node is not connected to a circuit network for the wire type.
    local function GetOrCreateNetworkHandlerForCircuitNetwork(node, wireType)
        local circuitNetwork = SE.NodeHandlersRegistry.GetNodeHandler(node).GetCircuitNetwork(node, wireType)
        if (circuitNetwork == nil) then
            return nil
        end
        
        local netID = circuitNetwork.network_id
        local network = Networks[netID]
        if (network == nil) then
            network = SE.NetworkHandler.NewNetwork(netID, wireType)
            Networks[netID] = network
            SE.Logger.Trace("Creating new network for " .. tostring(circuitNetwork.network_id))
        end
        
        return network
    end
    
    -- Checks if the node has changed circuit networks, and adjusts SE networks accordingly
    local function ValidateConnection(node, wireType)
        local detectedNet = GetOrCreateNetworkHandlerForCircuitNetwork(node, wireType)
        
        -- Note that for loading purposes, GetNetworkForNode must come after GetOrCreateNetworkHandlerForCircuitNetwork
        local prevNetwork = NetworksManagerObject.GetNetworkForNode(node, wireType)
        
        -- Has connection changed?
        if (detectedNet ~= prevNetwork) then
            -- Was on a network?
            if (prevNetwork ~= nil) then
                -- Leave old network
                SE.NetworkHandler.RemoveNode(prevNetwork, node, true)
                SE.Logger.Trace("Node leaving network " .. tostring(prevNetwork.NetworkID))
            end
            
            -- Joining a network?
            if (detectedNet ~= nil) then
                SE.NetworkHandler.AddNode(detectedNet, node, true)
                SE.Logger.Trace("Node joining network " .. tostring(detectedNet.NetworkID))
            end
        end
    end
    
    -- Removes a node by its index
    local function RemoveNodeByIndex(idx)
        SE.Logger.Trace("Networks: Removing node")
        local node = Nodes[idx]
        
        local nodeHandler = SE.NodeHandlersRegistry.GetNodeHandler(node)
        
        -- Inform the node
        nodeHandler.OnDestroy(node)
        
        -- Remove from networks
        local network = NetworksManagerObject.GetNetworkForNode(node, defines.wire_type.green)
        if (network ~= nil) then
            SE.NetworkHandler.RemoveNode(network, node, true)
        end
        network = NetworksManagerObject.GetNetworkForNode(node, defines.wire_type.red)
        if (network ~= nil) then
            SE.NetworkHandler.RemoveNode(network, node, true)
        end
        
        -- Set node networks to nil
        node.Networks[defines.wire_type.red] = nil
        node.Networks[defines.wire_type.green] = nil
        
        -- Remove from nodes
        table.remove(Nodes, idx)
        
        -- Does the node tick?
        if (nodeHandler.NeedsTicks) then
            -- Remove from ticking
            TickingNodes[node] = nil
        end
    end
    
    -- Returns an array containing all network ids
    function NetworksManagerObject.GetNetworkIDs()
        local ids = {}
        for circuitID, _ in pairs(Networks) do
            ids[#ids + 1] = circuitID
        end
        return ids
    end
    
    -- Returns the network with the specified ID
    function NetworksManagerObject.GetNetwork(ID)
        return Networks[ID]
    end
    
    -- Returns the network the node is on, or nil
    function NetworksManagerObject.GetNetworkForNode(node, wireType)
        return Networks[node.Networks[wireType]]
    end
    
    -- Add a node, if it is not already present
    function NetworksManagerObject.AddNode(node)
        if (GetNodeIndex(node) == 0) then
            -- Add to nodes
            Nodes[#Nodes + 1] = node
            
            -- Does the node tick?
            local handler = SE.NodeHandlersRegistry.GetNodeHandler(node)
            if (handler.NeedsTicks) then
                -- Add to ticking
                TickingNodes[node] = handler
            end
            
            SE.Logger.Trace("Networks: Added node")
        end
        return node
    end
    
    -- Removes a node from its network(s)
    -- This will remove all references to the node, and should
    -- only be called when the entity is being removed
    function NetworksManagerObject.RemoveNode(node)
        local idx = GetNodeIndex(node)
        if (idx > 0) then
            RemoveNodeByIndex(idx)
        end
    end
    
    -- Finds the node for the given entity and removes it.
    function NetworksManagerObject.RemoveNodeByEntity(entity)
        for idx = 1, #Nodes do
            if (Nodes[idx].Entity == entity) then
                RemoveNodeByIndex(idx)
                break
            end
        end
    end
    
    -- NetworkNode GetNodeForEntity(entity)
    -- Returns the node for the given entity, or nil
    function NetworksManagerObject.GetNodeForEntity(entity)
        for idx = 1, #Nodes do
            if (Nodes[idx].Entity == entity) then
                return Nodes[idx]
            end
        end
        return nil
    end
    
    -- Tick( Event )
    -- Ticks all nodes, and periodically ticks each network
    function NetworksManagerObject.Tick(event)
        -- Tick networks
        for _, network in next, Networks do
            SE.NetworkHandler.OnTick(network, event.tick)
        end
        
        -- Tick nodes
        for node, handler in next, TickingNodes do
            if (handler.Valid(node)) then
                handler.OnTick(node, event.tick)
            end
        end
        
        -- Network tick?
        if (math.fmod(event.tick, SE.Settings.TickRate) == 0) then
            -- Validate all nodes and connections
            local node = nil
            local idx = 1
            while (idx <= #Nodes) do
                node = Nodes[idx]
                -- Is the node still valid?
                if (SE.NodeHandlersRegistry.GetNodeHandler(node).Valid(node)) then
                    -- Validate connections
                    ValidateConnection(node, defines.wire_type.green)
                    ValidateConnection(node, defines.wire_type.red)
                    
                    -- Increment loop variable
                    idx = idx + 1
                else
                    -- Node is no longer valid, remove it, and do not increment loop varaiable
                    SE.Logger.Trace("Networks: Removing invalid node")
                    SE.Logger.Trace(serpent.block(node))
                    RemoveNodeByIndex(idx)
                end
            end
            
            -- Validate and tick all networks
            for circuitNetworkID, network in pairs(Networks) do
                if (SE.NetworkHandler.Empty(network)) then
                    SE.Logger.Trace("Removing empty network " .. tostring(circuitNetworkID))
                    Networks[circuitNetworkID] = nil
                else
                    SE.Logger.Trace("Ticking Network " .. tostring(circuitNetworkID))
                    SE.NetworkHandler.NetworkTick(network)
                end
            end
        end -- End network tick
    end
    
    -- Called during the mods OnInit phase
    function NetworksManagerObject.OnInit()
        Nodes = SE.DataStore.Nodes
    end
    
    -- Called during the mods OnLoad phase
    function NetworksManagerObject.OnLoad()
        NetworksManagerObject.OnInit()
    end
    
    -- Called when the first tick of a new/loaded game happens.
    -- Re-establishes all networks
    function NetworksManagerObject.FirstTick()
        -- Recreate all networks
        local network = nil
        local node = nil
        for idx = 1, #Nodes do
            node = Nodes[idx]
            
            -- Get the handler
            local handler = SE.NodeHandlersRegistry.GetNodeHandler(node)
            
            -- Ensure the nodes structure is valid
            handler.EnsureStructure(node)
            
            ValidateConnection(node, defines.wire_type.green)
            ValidateConnection(node, defines.wire_type.red)
            
            -- Is there a green network?
            network = NetworksManagerObject.GetNetworkForNode(node, defines.wire_type.green)
            if (network ~= nil) then
                -- Add the node
                SE.NetworkHandler.AddNode(network, node, false)
            end
            
            -- Is there a red network?
            network = NetworksManagerObject.GetNetworkForNode(node, defines.wire_type.red)
            if (network ~= nil) then
                -- Add the node
                SE.NetworkHandler.AddNode(network, node, false)
            end
            
            -- Does the node tick?
            if (handler.NeedsTicks) then
                -- Add to ticking
                TickingNodes[node] = handler
            end
        end
    end
    
    return NetworksManagerObject
end
