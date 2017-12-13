-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/26/2017
-- Description: Defines functionality for network nodes

return function()
  local BaseNodeHandler = {
    HandlerName = SE.Constants.Names.NodeHandlers.Base,
    -- Type: Type of handled nodes.
    Type = SE.Constants.NodeTypes.Device,
    -- NeedsTicks: True if handled nodes will require ticks.
    NeedsTicks = false
  }

  -- bool Valid(self)
  -- Called to check if the node is still valid.
  function BaseNodeHandler:Valid()
    return (self.Entity ~= nil and self.Entity.valid)
  end

  -- int ExtractPower(self,watts)
  -- Called when the network needs power, and ProvidesPower is true.
  -- Return amount of power extracted.
  function BaseNodeHandler:ExtractPower(watts)
    return 0
  end

  -- int StoredPower(self)
  -- Called to determine amount of power stored in the node.
  -- Return amount of power stored.
  function BaseNodeHandler:StoredPower()
    return 0
  end

  -- int InsertItems(self,SimpleItemStack,bool)
  -- Attempts to insert the items.
  -- stack: Items to extract
  -- simulate: When true items will not be transfered, only the counts.
  -- Returns Count of items inserted.
  function BaseNodeHandler:InsertItems(stack, simulate)
  end

  -- int ExtractItems(self,SimpleItemStack,bool)
  -- Attempts to extract the items.
  -- stack: Items to extract
  -- simulate: When true items will not be transfered, only the counts.
  -- Returns Count of items extracted.
  function BaseNodeHandler:ExtractItems(stack, simulate)
    return 0
  end

  -- int GetItemCount(self,itemName)
  -- Returns how many of the item there is in the node
  function BaseNodeHandler:GetItemCount(itemName)
    return 0
  end

  -- Position{x,y} GetPosition(self)
  function BaseNodeHandler:GetPosition()
    local pos = self.Entity.position
    if (pos.x == nil) then
      pos = {x = pos[1], y = pos[2]}
    end
    return pos
  end

  -- void GetContents(self,catalog)
  -- catalog: Map( item name -> count)
  -- TODO: Is this needed?
  function BaseNodeHandler:GetContents(catalog)
  end

  -- LuaCircuitNetwork GetCircuitNetwork(self,wireType)
  -- Returns the circuit network or nil
  function BaseNodeHandler:GetCircuitNetwork(wireType)
    return self.Entity.get_circuit_network(wireType)
  end

  -- IsFiltered(self :: Node, type :: string) :: bool
  -- Returns true if the node CAN have SE network filters
  -- type: Filter type, item, fluid, etc
  function BaseNodeHandler:IsFiltered(type)
    return false
  end

  -- GetFilters(self :: Node, type :: string) :: Map( Name :: string -> RequestedAmount :: int )
  -- Returns this nodes filters, or nil
  -- type: Filter type, item, fluid, etc
  function BaseNodeHandler:GetFilters(type)
    return nil
  end

  -- void OnTick(self)
  -- Called when the game ticks, if NeedsTicks is true.
  function BaseNodeHandler:OnTick()
  end

  -- void OnNetworkTick(self,network,deltaTicks)
  -- Called when the network ticks, if NeedsTicks is true.
  -- network: The network that is ticking, this can be either network the node is attached to.
  function BaseNodeHandler:OnNetworkTick(network)
  end

  -- void OnJoinNetwork(self,network)
  -- Called just after node joins an active network.
  function BaseNodeHandler:OnJoinNetwork(network)
  end

  -- void OnLeaveNetwork(self,network)
  -- Called just before the node leaves an network.
  function BaseNodeHandler:OnLeaveNetwork(network)
  end

  -- void OnPlayerOpenedNode(self,player)
  -- Called when a player has opened this node
  -- This will only be called if the entity this node represents does something when it is clicked.
  function BaseNodeHandler:OnPlayerOpenedNode(player)
    --player.print("Node opened by " .. player.name)
  end

  -- void OnPlayerClosedNode(self,player)
  -- Called when this node was opened by a player, but the player has just closed it.
  function BaseNodeHandler:OnPlayerClosedNode(player)
    --player.print("Node closed by " .. player.name)
  end

  -- void OnPlayerChangedSelectionElement(self, player, LuaGuiElement)
  -- Called when the player has changed a selection element for this node.
  function BaseNodeHandler:OnPlayerChangedSelectionElement(player, element)
    player.print("Unhandled selection changed " .. element.name .. ", " .. (element.elem_value or "Cleared"))
  end

  -- void OnPlayerChangedCheckboxElement(self, player, LuaGuiElement)
  -- Called when the player clicks a checkbox in the nodes GUI.
  function BaseNodeHandler:OnPlayerChangedCheckboxElement(player, element)
    player.print("Unhandled checkbox changed! " .. element.name .. ", " .. tostring(element.state))
  end

  -- void OnPasteSettings(self,sourceEntity, player)
  -- Called when pasting the settings of another entity
  function BaseNodeHandler:OnPasteSettings(sourceEntity, player)
    --player.print("Would get settings from entity " .. sourceEntity.name)
  end

  -- Creates a new network node
  function BaseNodeHandler.NewNode(entity)
    --SE.Logger.Trace("Creating new node")
    return BaseNodeHandler.EnsureStructure(
      {
        -- Entity: The game entity this node represents.
        Entity = entity
      }
    )
  end

  -- Called to ensure the internal structure of the node is established
  function BaseNodeHandler:EnsureStructure()
    -- Networks: The network(s) the node is attached to.
    -- [defines.wire_type.red],
    -- [defines.wire_type.green]
    self.Networks = self.Networks or {}

    -- Name of the handler that implements functionality
    self.HandlerName = self.HandlerName or BaseNodeHandler.HandlerName

    -- Calculate chunk position
    if (self.ChunkPosition == nil) then
      self.ChunkPosition = BaseNodeHandler.GetPosition(self)
      self.ChunkPosition.x = self.ChunkPosition.x / 32
      self.ChunkPosition.y = self.ChunkPosition.y / 32
    end
    return self
  end

  return BaseNodeHandler
end