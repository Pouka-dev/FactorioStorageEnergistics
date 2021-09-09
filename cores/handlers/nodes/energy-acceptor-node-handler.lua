-- Description: Energy Acceptor node

EnergyAcceptorNodeHandlerController = newclass(BaseNodeHandlerController,function(base,...)
  BaseNodeHandler.init(base,...)
  base.Type = SE.Constants.NodeTypes.PowerSource
  base.NeedsTicks = true
end)

  local CreateHiddenEntity = function(node)
    local entity = node.Entity
    return entity.surface.create_entity(
      {
        name = "hidden-" .. SE.Constants.Names.Proto.EnergyAcceptor.Entity,
        position = entity.position,
        force = entity.force
      }
    )
  end

  -- ExtractPower( Self, uint ) :: uint
  -- Called when the network needs power, and ProvidesPower is true.
  -- Return amount of power extracted.
  function EnergyAcceptorNodeHandlerController:ExtractPower(watts)
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
  function EnergyAcceptorNodeHandlerController:StoredPower()
    if (self.HiddenElectricEntity ~= nil and self.HiddenElectricEntity.valid) then
      return self.HiddenElectricEntity.energy
    else
      return 0
    end
  end

  -- @See BaseNode:GetCircuitNetwork
  function EnergyAcceptorNodeHandlerController:GetCircuitNetwork(wireType)
    if (EnergyAcceptorNodeHandlerController.Valid(self)) then
      return self.Entity.get_circuit_network(wireType, defines.circuit_connector_id.accumulator)
    end
    return nil
  end

  -- @See BaseNode:OnTick
  function EnergyAcceptorNodeHandlerController:OnTick(tick)
    -- Tick!
    self.TicksTillUpdate = self.TicksTillUpdate - 1

    -- Time to update?
    if (self.TicksTillUpdate < 1) then
      -- Ensure the hidden entity has been created
      if (self.HiddenElectricEntity == nil or (not self.HiddenElectricEntity.valid)) then
        self.HiddenElectricEntity = CreateHiddenEntity(self)
      else
        -- Get hidden energy
        local hEng = self.HiddenElectricEntity.energy
        if (hEng ~= self.Entity.energy) then
          -- Set actual energy
          self.Entity.energy = hEng
          -- Tick rate while energy amount changing
          self.TickRate = 10
        else
          -- Tick rate while idle
          self.TickRate = 40
        end
      end

      self.TicksTillUpdate = self.TickRate
    end
  end

  -- @See BaseNode:OnDestroy
  function EnergyAcceptorNodeHandlerController:OnDestroy()
    if (self.HiddenElectricEntity ~= nil) then
      self.HiddenElectricEntity.destroy()
    end
  end

  -- @See BaseNode.NewNode
  function EnergyAcceptorNodeHandlerController.NewNode(entity)
    local node = EnergyAcceptorNodeHandlerController._super.NewNode(entity)
    EnergyAcceptorNodeHandlerController.EnsureStructure(node)
    return node
  end

  -- @See BaseNode:EnsureStructure
  function EnergyAcceptorNodeHandlerController:EnsureStructure()
    EnergyAcceptorNodeHandlerController._super.EnsureStructure(self)
    
    self.TicksTillUpdate = 5
    self.TickRate = 30
    return self
  end

