NetworksManagerObjectConstructor = newclass(Object, function(base, ...)
    Object.init(base, ...)
end)

local LastNodePos = 0
local LastNetworkPos = 0

---All Nodes
---Sequential array
---Serialized
local Nodes = nil
--
-- -- Map( CircuitNetworkID -> Network )
local Networks = {}
local NetworkIDs = {}

-- Adds a network ID to the store
local function AddNetworkID(id)
    for i = 1, #NetworkIDs do
        if (NetworkIDs[i] == id) then
            return
        end
    end

    table.insert(NetworkIDs, id)
end

-- Removes a network ID from the store
local function RemoveNetworkID(id)
    for i = 1, #NetworkIDs do
        if (NetworkIDs[i] == id) then
            table.remove(NetworkIDs, i)
            return
        end
    end
end

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
    local circuitNetwork = RSE.NodeHandlersRegistry:GetNodeHandler(node).GetCircuitNetwork(node, wireType)
    if (circuitNetwork == nil) then
        return nil
    end
    
    local netID = circuitNetwork.network_id
    local network = Networks[netID]
    if (network == nil) then
        network = RSE.NetworkHandler.NewNetwork(netID, wireType)
        Networks[netID] = network
        AddNetworkID(netID)
    ---RSE.Logger.Trace("Creating new network for " .. tostring(circuitNetwork.network_id))
    end
    
    return network
end

-- Checks if the node has changed circuit networks, and adjusts SE networks accordingly
local function ValidateConnection(node, wireType)
    local detectedNet = GetOrCreateNetworkHandlerForCircuitNetwork(node, wireType)
    
    -- Note that for loading purposes, GetNetworkForNode must come after GetOrCreateNetworkHandlerForCircuitNetwork
    local prevNetwork = NetworksManagerObjectConstructor.GetNetworkForNode(node, wireType)
    
    -- Has connection changed?
    if (detectedNet ~= prevNetwork) then
        -- Was on a network?
        if (prevNetwork ~= nil) then
            -- Leave old network
            RSE.NetworkHandler.RemoveNode(prevNetwork, node, true)
        ---RSE.Logger.Trace("Node leaving network " .. tostring(prevNetwork.NetworkID))
        end
        
        -- Joining a network?
        if (detectedNet ~= nil) then
            RSE.NetworkHandler.AddNode(detectedNet, node, true)
        ---RSE.Logger.Trace("Node joining network " .. tostring(detectedNet.NetworkID))
        end
    end
end

-- Removes a node by its index
local function RemoveNodeByIndex(idx)
    ---RSE.Logger.Trace("Networks: Removing node")
    local node = Nodes[idx]
    
    local nodeHandler = RSE.NodeHandlersRegistry:GetNodeHandler(node)
    
    -- Inform the node
    nodeHandler.OnDestroy(node)
    
    -- Remove from networks
    local network = NetworksManagerObjectConstructor.GetNetworkForNode(node, defines.wire_type.green)
    if (network ~= nil) then
        RSE.NetworkHandler.RemoveNode(network, node, true)
    end
    network = NetworksManagerObjectConstructor.GetNetworkForNode(node, defines.wire_type.red)
    if (network ~= nil) then
        RSE.NetworkHandler.RemoveNode(network, node, true)
    end
    
    -- Set node networks to nil
    node.Networks[defines.wire_type.red] = nil
    node.Networks[defines.wire_type.green] = nil
    
    -- Remove from nodes
    table.remove(Nodes, idx)
end

-- Returns an array containing all network ids
function NetworksManagerObjectConstructor.GetNetworkIDs()
    return NetworkIDs
end

-- Returns the network with the specified ID
function NetworksManagerObjectConstructor.GetNetwork(ID)
    return Networks[ID]
end

-- Returns the network the node is on, or nil
function NetworksManagerObjectConstructor.GetNetworkForNode(node, wireType)
    return Networks[node.Networks[wireType]]
end

-- Add a node, if it is not already present
function NetworksManagerObjectConstructor.AddNode(node)
    if (GetNodeIndex(node) == 0) then
        -- Add to nodes
        Nodes[#Nodes + 1] = node
    
    ---RSE.Logger.Trace("Networks: Added node")
    end
    return node
end

-- Removes a node from its network(s)
-- This will remove all references to the node, and should
-- only be called when the entity is being removed
function NetworksManagerObjectConstructor.RemoveNode(node)
    local idx = GetNodeIndex(node)
    if (idx > 0) then
        RemoveNodeByIndex(idx)
    end
end

-- Finds the node for the given entity and removes it.
function NetworksManagerObjectConstructor.RemoveNodeByEntity(entity)
    for idx = 1, #Nodes do
        if (Nodes[idx].Entity == entity) then
            RemoveNodeByIndex(idx)
            break
        end
    end
end

-- NetworkNode GetNodeForEntity(entity)
-- Returns the node for the given entity, or nil
function NetworksManagerObjectConstructor.GetNodeForEntity(entity)
    for idx = 1, #Nodes do
        if (Nodes[idx].Entity == entity) then
            return Nodes[idx]
        end
    end
    return nil
end

-- Tick( Event )
-- Ticks all nodes, and periodically ticks each network
function NetworksManagerObjectConstructor.Tick(event)
    
    local tick = event.tick
    
    -- Tick networks IDLE consumption
    if tick % 10 == 0 then
        for _, network in next, Networks do
            RSE.NetworkHandler.OnTick(network, event.tick)
        end
    end
    
    -- Check node connections
    if tick % 10 == 0 then
        --RSE.Logger.Info(LastNetworkTick .. " to " .. LastNetworkTick + 10)
        LastNodePos = LastNodePos + 1
        for idx = LastNodePos, LastNodePos + 10 do
            if (idx > #Nodes) then
                LastNodePos = 0
                break
            end

            local node = Nodes[idx]
            -- Is the node still valid?
            if (RSE.NodeHandlersRegistry:GetNodeHandler(node).Valid(node)) then
                -- Validate connections
                ValidateConnection(node, defines.wire_type.green)
                ValidateConnection(node, defines.wire_type.red)
            else
                -- Node is no longer valid, remove it, and do not increment loop varaiable
                ---RSE.Logger.Trace("Networks: Removing invalid node")
                RemoveNodeByIndex(idx)
            end

            LastNodePos = idx
        end
    end

    -- Validate and tick all networks
    --RSE.Logger.Info(LastNetworkPos .. " to " .. LastNetworkPos + 10)
    LastNetworkPos = LastNetworkPos + 1
    for i = LastNetworkPos, LastNetworkPos + RSE.Settings.NetworksPerTick do
        if (i > #NetworkIDs) then
            LastNetworkPos = 0
            break
        end

        local network = Networks[NetworkIDs[i]]
        local circuitNetworkID = NetworkIDs[i]

        if (RSE.NetworkHandler.Empty(network)) then
            ---RSE.Logger.Trace("Removing empty network " .. tostring(circuitNetworkID))
            Networks[circuitNetworkID] = nil
            RemoveNetworkID(circuitNetworkID)
        else
            ---RSE.Logger.Trace("Ticking Network " .. tostring(circuitNetworkID))
            RSE.NetworkHandler.NetworkTick(network, event)
        end

        LastNetworkPos = i
    end
end

-- Called during the mods OnInit phase
function NetworksManagerObjectConstructor.OnInit()
    Nodes = RSE.DataStore.Nodes
end

-- Called during the mods OnLoad phase
function NetworksManagerObjectConstructor.OnLoad()
    NetworksManagerObjectConstructor.OnInit()
end

-- Called when the first tick of a new/loaded game happens.
-- Re-establishes all networks
function NetworksManagerObjectConstructor.FirstTick()
    -- Recreate all networks
    local network = nil
    local node = nil
    for idx = 1, #Nodes do
        node = Nodes[idx]
        
        -- Get the handler
        local handler = RSE.NodeHandlersRegistry:GetNodeHandler(node)
        
        -- Ensure the nodes structure is valid
        handler.EnsureStructure(node, true)
        
        ValidateConnection(node, defines.wire_type.green)
        ValidateConnection(node, defines.wire_type.red)
        
        -- Is there a green network?
        network = NetworksManagerObjectConstructor.GetNetworkForNode(node, defines.wire_type.green)
        if (network ~= nil) then
            -- Add the node
            RSE.NetworkHandler.AddNode(network, node, false)
        end
        
        -- Is there a red network?
        network = NetworksManagerObjectConstructor.GetNetworkForNode(node, defines.wire_type.red)
        if (network ~= nil) then
            -- Add the node
            RSE.NetworkHandler.AddNode(network, node, false)
        end
    end
end
