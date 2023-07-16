BaseNetworkHandlerConstructor = newclass(Object, function(base, ...)
    Object.init(base, ...)
end)



--local BaseNetworkHandlerConstructor = {}
-- local statTransferCount = 0
-- local statPowerUsed = 0
-- local statLastTick = 0
-- NewNetwork( Int, Int ) :: Network
-- Creates a new BaseNetworkHandlerConstructor with the given ID and wire type.
function BaseNetworkHandlerConstructor.NewNetwork(networkID, wireType)
    local network = {
        WireType = wireType,
        NetworkID = networkID,
        ControllerNodes = {},
        PowerSourceNodes = {},
        PowerSourceNodeCount = 0,
        PowerDrainNodeCount = 0,
        StorageNodes = {},
        DeviceNodes = {},
        TickingNodes = {},
        StorageCatalog = nil,
        HasPower = false,
        LastStorageTick = 0,
        CurrentIndex = 0
    }
    return network
end

-- void AddNode( Self, Node, bool ) :: void
-- Adds a node to the network
-- node: Node to add
-- fireNodeEvents: True to inform node that it is joining network
function BaseNetworkHandlerConstructor:AddNode(node, fireNodeEvents)
    -- Get the nodes handler
    local nodeHandler = RSE.NodeHandlersRegistry:GetNodeHandler(node)
    local nodeType = nodeHandler.Type
    
    ---RSE.Logger.Trace("Network: Adding node " .. nodeHandler.HandlerName)
    -- Add to the proper node table
    if (nodeType == RSE.Constants.NodeTypes.Storage and self.StorageNodes[node] == nil) then
        self.StorageNodes[node] = nodeHandler
        self.PowerDrainNodeCount = self.PowerDrainNodeCount + 1
    elseif (nodeType == RSE.Constants.NodeTypes.Device and self.DeviceNodes[node] == nil) then
        self.DeviceNodes[node] = nodeHandler
        self.PowerDrainNodeCount = self.PowerDrainNodeCount + 1
    elseif (nodeType == RSE.Constants.NodeTypes.PowerSource and self.PowerSourceNodes[node] == nil) then
        self.PowerSourceNodes[node] = nodeHandler
        self.PowerSourceNodeCount = self.PowerSourceNodeCount + 1
    elseif (nodeType == RSE.Constants.NodeTypes.Controller and self.ControllerNodes[node] == nil) then
        self.ControllerNodes[node] = nodeHandler
        self.PowerDrainNodeCount = self.PowerDrainNodeCount + 1
    else
        return
    end
    
    -- Does the node tick?
    if (nodeHandler.NeedsTicks == true) then
        ---RSE.Logger.Trace("Network: Added ticking node")
        --self.TickingNodes[node] = nodeHandler

        local ix = #self.TickingNodes + 1
        node.id = ix

        self.TickingNodes[ix] = {
            n = node,
            h = nodeHandler
        }
    end
    
    -- Set the nodes network ID
    node.Networks[self.WireType] = self.NetworkID
    
    -- Fire event?
    if (fireNodeEvents) then
        -- Inform the node it is joining
        return nodeHandler.OnJoinNetwork(node, self)
    end
end

-- RemoveNode( Self, Node, bool ) :: void
-- Removes a node from the network
-- node: Node to remove
-- fireNodeEvents: True to inform node that it is leaving network
function BaseNetworkHandlerConstructor:RemoveNode(node, fireNodeEvents)
    -- Get the nodes handler
    local nodeHandler = RSE.NodeHandlersRegistry:GetNodeHandler(node)
    local nodeType = nodeHandler.Type
    
    -- Get the node type
    if (self.StorageNodes[node] ~= nil) then
        self.StorageNodes[node] = nil
        self.PowerDrainNodeCount = self.PowerDrainNodeCount - 1
    elseif (self.DeviceNodes[node] ~= nil) then
        self.DeviceNodes[node] = nil
        self.PowerDrainNodeCount = self.PowerDrainNodeCount - 1
    elseif (self.PowerSourceNodes[node] ~= nil) then
        self.PowerSourceNodes[node] = nil
        self.PowerSourceNodeCount = self.PowerSourceNodeCount - 1
    elseif (self.ControllerNodes[node] ~= nil) then
        self.ControllerNodes[node] = nil
        self.PowerDrainNodeCount = self.PowerDrainNodeCount - 1
    else
        -- Node not found
        return
    end
    
    -- Does the node tick?
    if (nodeHandler.NeedsTicks == true) then
        --self.TickingNodes[node] = nil
        self.TickingNodes[node.id] = nil
    end
    
    -- Remove from node
    node.Networks[self.WireType] = nil
    
    if (fireNodeEvents) then
        -- Inform the node it is leaving
        return nodeHandler.OnLeaveNetwork(node, self)
    end
end

-- Tick( Self ) :: void
-- Called when the game ticks
function BaseNetworkHandlerConstructor:OnTick(tick)
    -- Draw idle power
    self.HasPower = (self.PowerDrainNodeCount == 0) or BaseNetworkHandlerConstructor.ExtractPower(self, self.PowerDrainNodeCount * RSE.Settings.NodeIdlePowerDrain)
end

-- NetworkTick( Self ) :: void
-- Called when the network ticks
function BaseNetworkHandlerConstructor:NetworkTick()
    if (not self.HasPower) then
        -- Not enough power to run network
        ---RSE.Logger.Trace("Not enough power for network " .. tostring(self.NetworkID))
        return
    end
    
    -- Network requires at least 1 controller to tick devices
    if (next(self.ControllerNodes) == nil) then
        ---RSE.Logger.Trace("Missing controller(s) on network " .. tostring(self.NetworkID))
        return
    end

    -- Tick nodes
    -- for node, handler in pairs(self.TickingNodes) do
    --     if (handler.Valid(node)) then
    --         ---RSE.Logger.Trace("Ticking Node")
    --         handler.OnNetworkTick(node, self)
    --     end
    -- end

    --RSE.Logger.Info(self.CurrentIndex .. " to " .. self.CurrentIndex + 10)
    self.CurrentIndex = self.CurrentIndex + 1
    for i = self.CurrentIndex, self.CurrentIndex + 10 do
        if (i > #self.TickingNodes) then
            self.CurrentIndex = 0
            break
        end

        local obj = self.TickingNodes[i]
        if obj ~= nil and obj.h.Valid(obj.n) then
            obj.h.OnNetworkTick(obj.n, self)
        end

        self.CurrentIndex = i
    end

end

-- CanExtractPower( Network, PowerRequest ) :: bool
-- request: PowerRequest
-- Returns true if the request can be fully satisfied, false if not
-- If the request can only be partially satisfied, you can check request.WattsRemaining
-- to get the amount of power that can not be provided.
local function CanExtractPower(network, request)
    
    
    local canExtract = false
    -- Mark that this network has been visitied
    request.VisititedNetworks[network.NetworkID] = true
    
    ---RSE.Logger.Trace("Starting Network Power Request For Network " .. tostring(network.NetworkID) .. ", Amount: " .. tostring(request.WattsRemaining))
    -- network have power source ?
    if (network.PowerSourceNodeCount > 0) then
        canExtract = CanExtractWithCurrentPower(network, request)
    end -- End network.PowerSourceNodeCount > 0
    
    ---RSE.Logger.Trace("End Network Power Request. Remaining watts " .. tostring(request.WattsRemaining))
    if (not canExtract) then
        -- Power request not fully satisfied.
        -- Get the other wire type
        local bridgedColor = nil
        if (network.WireType == defines.wire_type.red) then
            bridgedColor = defines.wire_type.green
        else
            bridgedColor = defines.wire_type.red
        end
        
        -- Check bridged network(s)
        local satisfied = false
        for controller, handler in pairs(network.ControllerNodes) do
            -- Get the bridged network
            local bridgedNetworkID = controller.Networks[bridgedColor]
            -- Is there a bridged network, and has it not been visited?
            if (bridgedNetworkID ~= nil and request.VisititedNetworks[bridgedNetworkID] == nil) then
                -- Can it satisfy the request?
                if (CanExtractPower(RSE.NetworksManager.GetNetwork(bridgedNetworkID), request) == true) then
                    -- Request fully satisfied
                    return true
                end
            end
        end
    end
    -- Checked every available power source, and was not able to satisfy request
    return canExtract
end

-- DoExtractPower( PowerRequest ) :: void
-- Extracts the requested amount of power from the nodes in the map.
-- request: PowerRequest
local function DoExtractPower(request)
    for node, source in pairs(request.VisitedNodes) do
        source.Handler.ExtractPower(node, source.Extract)
    end
end

-- NewPowerRequest( uint ) :: PowerRequest
-- Creates a new power request
-- watts: Amount of power to request
-- Returns: {
-- -- int WattsRemaining,
-- -- Map( int:NetworkID -> bool ) VisititedNetworks,
-- -- Map( Node::Node -> {Node::Node, Handler::Handler, Extract::int, Stored::int} ) VisitedNodes
-- }
local function NewPowerRequest(watts)
    return {RequestedWatts = watts, WattsRemaining = watts, VisititedNetworks = {}, VisitedNodes = {}}
end

-- ReducePowerRequest( PowerRequest, uint ) :: void
-- Reduces the amount of power requested
-- request: PowerRequest
-- watts: Amount to reduce by
local function ReducePowerRequest(request, watts)
    local amountRemaining = watts
    for node, info in pairs(request.VisitedNodes) do
        -- Does node provide enough power to reduce by?
        if (info.Amount >= amountRemaining) then
            -- Reduce the amount of power being drawn from the node
            info.Amount = info.Amount - amountRemaining
            -- Reduction complete
            return
        else
            -- Reduce amount remaining by how much power this node would have given.
            amountRemaining = amountRemaining - info.Amount
            -- Completely remove the node
            request.VisitedNodes[node] = nil
        end
    end
end

-- ExtractPower( Self, uint ) :: bool
-- Attempts to extract the requested amount of power.
-- Returns true if the power was extracted.
function BaseNetworkHandlerConstructor:ExtractPower(watts)
    ---RSE.Logger.Trace("Extract Power Request: " .. tostring(watts))
    if (watts <= 0) then
        return true
    end
    local request = NewPowerRequest(watts)
    if (CanExtractPower(self, request)) then
        DoExtractPower(request)
        return true
    end
    return false
end

local TransferReasonCodes = {
    Ok = 0,
    LowPower = 1,
    NotAllTransfered = 2
}

-- TransferItems( Network, SimpleItemStack, Function, Node ) :: {Amount,ReasonCode}
-- Transfers as many items as possible to/from the network.
-- network: The network to transfer to/from
-- stack: The items to transfer
-- transferFn: Function name to call on each nodes handler to transfer items.
-- requesterNode: Node that requested the transfer
-- filterFn: Function to filter storage nodes with
-- Returns: Amount transfered
local function TransferItems(network, stack, transferFn, requesterNode, filterFn)
    -- Is the amount valid?
    if (stack.count <= 0) then
        return {Amount = 0, ReasonCode = TransferReasonCodes.Ok}
    end
    
    -- Amount left to transfer
    local stackRemaining = {name = stack.name, count = stack.count}
    
    -- Amount attempting to be transfered
    local stackTransfering = {name = stack.name, count = 0}
    
    -- Assume not all can be transfered
    local reasoncode = TransferReasonCodes.NotAllTransfered
    
    local filter = {}
    
    --- sort the node with the lowest distance with requestNode but perf is not ok
    -----  local sorter = function(t, a, b, c) return util.distance(a.ChunkPosition, c.ChunkPosition) < util.distance(b.ChunkPosition, c.ChunkPosition) end
    -----for node, handler in spairsC(filter, sorter, requesterNode) do
    for node, handler in fpairs(network.StorageNodes, filterFn) do
        -- Simulate a transfer
        stackTransfering.count = handler[transferFn](node, stackRemaining, true)
        -- Can any be transfered?
        if (stackTransfering.count > 0) then
            -- Calculate Manhattan distance based on chunks
            -- Same chunk, and neighbor chunks(including diagonal), do not have increased cost
            local distX = math.abs(node.ChunkPosition.x - requesterNode.ChunkPosition.x)
            local distY = math.abs(node.ChunkPosition.y - requesterNode.ChunkPosition.y)
            local chunkPower = (distX > 1 or distY > 1) and ((distX + distY) * RSE.Settings.PowerPerChunk) or 0
            
            -- Transfer as many items as possible
            while (stackTransfering.count > 0) do
                -- Calculate power
                local itemPower = (stackTransfering.count * RSE.Settings.PowerPerItem)
                
                -- Attempt to extract the power
                if (BaseNetworkHandlerConstructor.ExtractPower(network, itemPower + chunkPower)) then
                    -- statPowerUsed = statPowerUsed + itemPower + chunkPower
                    -- statTransferCount = statTransferCount + stackTransfering.count
                    -- Power request successful
                    -- Transfer
                    handler[transferFn](node, stackTransfering, false)
                    
                    -- Adjust amount
                    stackRemaining.count = stackRemaining.count - stackTransfering.count
                    
                    -- Done with this node
                    break
                end
                -- Not enough power, half the request and try again
                reasoncode = TransferReasonCodes.LowPower
                stackTransfering.count = math.floor(stackTransfering.count / 2.0)
            end
            
            -- Could none be transfered or no more power?
            if (reasoncode == TransferReasonCodes.LowPower or stackTransfering.count == 0) then
                -- Exit for loop
                break
            end
            
            -- Have all items been transfered?
            if (stackRemaining.count == 0) then
                -- All done!
                reasoncode = TransferReasonCodes.Ok
                break
            end
        end
    end
    --
    return {Amount = stack.count - stackRemaining.count, ReasonCode = reasoncode}
end

local FilterStorage_RW = function(node, handler)
    return (not handler.IsReadOnly(node))
end

local FilterStorage_RO = function(node, handler)
    return handler.IsReadOnly(node)
end

-- InsertItems( Self, SimpleItemStack, Node ) :: uint
-- Attempts to insert the items.
-- If the network does not have enough power to insert all the items
-- as many will be inserted as possible.
-- Returns the amount inserted
function BaseNetworkHandlerConstructor:InsertItems(stack, requesterNode)
    local transfer = TransferItems(self, stack, "InsertItems", requesterNode, FilterStorage_RW)
    
    -- Is the network full?
    if (transfer.ReasonCode == TransferReasonCodes.NotAllTransfered) then
        for idx, player in pairs(game.players) do
            player.add_alert(requesterNode.Entity, defines.alert_type.no_storage)
        end
    end
    
    return transfer.Amount
end

-- ExtractItems( Self, SimpleItemStack, Node ) :: uint
-- Attempts to extract the items.
-- If the network does not have enough power to extract all the items
-- as many will be extracted as possible.
-- Returns the amount extracted.
function BaseNetworkHandlerConstructor:ExtractItems(stack, requesterNode)
    -- Attempt to extract all needed from Read/Write chests
    local transfer = TransferItems(self, stack, "ExtractItems", requesterNode, FilterStorage_RW)
    
    --If not all transfered extract from Read-Only chests
    if (transfer.ReasonCode == TransferReasonCodes.NotAllTransfered) then
        -- Temporarily adjust stack count
        local pCount = stack.count
        stack.count = stack.count - transfer.Amount
        
        -- Attempt to extract reminaing
        local t2 = TransferItems(self, stack, "ExtractItems", requesterNode, FilterStorage_RO)
        
        -- Updated amount transfered
        transfer.Amount = transfer.Amount + t2.Amount
        
        -- Restore stack count
        stack.count = pCount
    end
    
    return transfer.Amount
end

-- GetStorageContents( Self, uint ) :: Map( item name -> count)
-- Returns all items in the network
function BaseNetworkHandlerConstructor:GetStorageContents(tick)
    -- New tick?
    if (tick ~= self.LastStorageTick) then
        -- Mark tick
        self.LastStorageTick = tick
        self.StorageCatalog = {}
        for node, handler in pairs(self.StorageNodes) do
            handler.GetContents(node, self.StorageCatalog)
        end
    end
    return self.StorageCatalog
end

-- Empty( Self ) :: bool
-- Returns true if there are no nodes on the network
function BaseNetworkHandlerConstructor:Empty()
    return next(self.ControllerNodes) == nil and BaseNetworkHandlerConstructor.EmptyEmptyExceptControllers(self)
end

-- EmptyExceptControllers( Self ) :: bool
-- Returns true if there are no nodes, except controllers, on the network
function BaseNetworkHandlerConstructor:EmptyEmptyExceptControllers()
    return next(self.PowerSourceNodes) == nil
        and next(self.StorageNodes) == nil
        and next(self.DeviceNodes) == nil
end


function BaseNetworkHandlerConstructor:checkForDisplayNetworkOnNetworkGUI()
    local haventController = next(self.ControllerNodes) == nil
    local haventPowerSourceNodes = next(self.PowerSourceNodes) == nil
    local haventStorageNodes = next(self.StorageNodes) == nil
    --local haventDeviceNodes = (self.DeviceNodes == nil or self.DeviceNodes == {})
    return haventController or haventPowerSourceNodes or haventStorageNodes
end
