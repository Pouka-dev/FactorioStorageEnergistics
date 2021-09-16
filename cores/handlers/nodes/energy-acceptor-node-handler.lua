-- Description: Energy Acceptor node
EnergyAcceptorNodeHandlerConstructor = newclass(BaseNodeHandlerConstructor, function(base, ...)
    BaseNodeHandler.init(base, ...)
    base.Type = RSE.Constants.NodeTypes.PowerSource
    base.NeedsTicks = true
end)

local CreateHiddenEntity = function(node)
    local entity = node.Entity
    return entity.surface.create_entity(
        {
            name = "hidden-" .. RSE.Constants.Names.Proto.EnergyAcceptor.Entity,
            position = entity.position,
            force = entity.force
        }
)
end

-- ExtractPower( Self, uint ) :: uint
-- Called when the network needs power, and ProvidesPower is true.
-- Return amount of power extracted.
function EnergyAcceptorNodeHandlerConstructor:ExtractPower(watts)
    if (self.HiddenElectricEntity ~= nil and self.HiddenElectricEntity.valid) then
        local stored = self.HiddenElectricEntity.energy
        
        -- Optimistically assume there is enough
        local extracted = watts
        
        -- If there is not enough
        if (stored < watts) then
            -- Take everything available
            extracted = stored
        end
        
        -- Remove from buffer
        self.HiddenElectricEntity.energy = stored - extracted
        
        return extracted
    end
    return 0
end

-- StoredPower( Self ) : uint
-- Called to determine amount of power stored in the node.
-- Return amount of power stored.
function EnergyAcceptorNodeHandlerConstructor:StoredPower()
    if (self.HiddenElectricEntity ~= nil and self.HiddenElectricEntity.valid) then
        return self.HiddenElectricEntity.energy
    else
        return 0
    end
end

-- @See BaseNode:GetCircuitNetwork
function EnergyAcceptorNodeHandlerConstructor:GetCircuitNetwork(wireType)
    if (EnergyAcceptorNodeHandlerConstructor.Valid(self)) then
        return self.Entity.get_circuit_network(wireType, defines.circuit_connector_id.accumulator)
    end
    return nil
end

-- @See BaseNode:OnTick
function EnergyAcceptorNodeHandlerConstructor:OnTick(tick)
    -- Time to update?
    -- Ensure the hidden entity has been created
    if (self.HiddenElectricEntity == nil or (not self.HiddenElectricEntity.valid)) then
        self.HiddenElectricEntity = CreateHiddenEntity(self)
    else
        -- Get hidden energy
        local hEng = self.HiddenElectricEntity.energy
        if (hEng ~= self.Entity.energy) then
            -- Set actual energy
            self.Entity.energy = hEng
        end
    end
end --end

-- @See BaseNode:OnDestroy
function EnergyAcceptorNodeHandlerConstructor:OnDestroy()
    if (self.HiddenElectricEntity ~= nil) then
        self.HiddenElectricEntity.destroy()
    end
end

-- @See BaseNode.NewNode
function EnergyAcceptorNodeHandlerConstructor.NewNode(entity)
    local node = EnergyAcceptorNodeHandlerConstructor._super.NewNode(entity)
    EnergyAcceptorNodeHandlerConstructor.EnsureStructure(node)
    return node
end

-- @See BaseNode:EnsureStructure
function EnergyAcceptorNodeHandlerConstructor:EnsureStructure()
    EnergyAcceptorNodeHandlerConstructor._super.EnsureStructure(self)
    -- Name of the handler that implements functionality
    self.HandlerName = EnergyAcceptorNodeHandler.HandlerName
    --self.TicksTillUpdate = 5
    --self.TickRate = 30
    return self
end
