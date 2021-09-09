-- Description: Storage Node
StorageNodeHandlerController = newclass(BaseNodeHandlerController,function(base,...)
  BaseNodeHandler.init(base,...)
  base.Type = SE.Constants.NodeTypes.Storage
end)

  -- ForceReadOnly( Node ) :: bool
  -- Returns true if read only should be forced, based on the entity
  local function ForceReadOnly(node)
    return node.Entity.name == SE.Constants.Names.Proto.RequesterChest.Entity
  end

  -- @See BaseNode:OnGetGuiHandler
  -- Show the gui
  function StorageNodeHandlerController:OnGetGuiHandler(playerIndex)
    if (not ForceReadOnly(self)) then
      return SE.GuiManager.Guis.StorageNodeGUI
    end
  end

  -- @See BaseNode:InsertItems
  function StorageNodeHandlerController:InsertItems(stack, simulate)
    if (self.ReadOnlyMode) then
      return 0
    end
    local inv = self.Entity.get_inventory(defines.inventory.chest)
    local inserted = inv.insert(stack)
    if (simulate and inserted > 0) then
      inv.remove({name = stack.name, count = inserted})
    end
    return inserted
  end

  -- @See BaseNode:ExtractItems
  function StorageNodeHandlerController:ExtractItems(stack, simulate)
    local inv = self.Entity.get_inventory(defines.inventory.chest)
    local removed = inv.remove(stack)
    if (simulate and removed > 0) then
      inv.insert({name = stack.name, count = removed})
    end
    return removed
  end

  -- @See BaseNode:GetItemCount
  function StorageNodeHandlerController:GetItemCount(itemName)
    local inv = self.Entity.get_inventory(defines.inventory.chest)
    return inv.get_item_count(itemName)
  end

  -- @See BaseNode:GetContents
  function StorageNodeHandlerController:GetContents(catalog)
    local inv = self.Entity.get_inventory(defines.inventory.chest)
    -- Get total slot count
    local totalSlots = #inv

    -- Add total to catalog
    catalog[SE.Constants.Strings.TotalSlots] = (catalog[SE.Constants.Strings.TotalSlots] or 0) + totalSlots

    -- Examine inventory
    local freeSlots = 0
    local item = nil
    for idx = 1, totalSlots do
      item = inv[idx]
      if (item.valid_for_read) then
        --SE.Logger.Trace("Index " .. tostring(idx) .. " has item " .. item.name .. " x" .. tostring(item.count))
        -- Add item to catalog
        catalog[item.name] = (catalog[item.name] or 0) + item.count
      else
        freeSlots = freeSlots + 1
      end
    end

    -- Add free to catalog
    catalog[SE.Constants.Strings.FreeSlots] = (catalog[SE.Constants.Strings.FreeSlots] or 0) + freeSlots
  end

  -- OnPasteSettings( Self,  LuaEntity ) :: void
  function StorageNodeHandlerController:OnPasteSettings(sourceEntity)
    -- Is this node forced read-only?
    if (ForceReadOnly(self)) then
      return
    end

    -- Other node is storage node?
    local node = SE.NetworksManager.GetNodeForEntity(sourceEntity)
    if (node ~= nil) then
      local handler = SE.NodeHandlersRegistry.GetNodeHandler(node)
      if (handler ~= nil and handler.Type == SE.Constants.NodeTypes.Storage) then
        -- Copy read only setting
        self.ReadOnlyMode = node.ReadOnlyMode
      end
    end
  end

 -- OnPasteSettingsWithNode( Self,  Node ) :: void
 function StorageNodeHandlerController:OnPasteSettingsWithNode(sourceNode)
  -- Is this node forced read-only?
  if (ForceReadOnly(self)) then
    return
  end

  -- Other node is storage node?
  if (sourceNode ~= nil) then
    local handler = SE.NodeHandlersRegistry.GetNodeHandler(sourceNode)
    if (handler ~= nil and handler.Type == SE.Constants.NodeTypes.Storage) then
      -- Copy read only setting
      self.ReadOnlyMode = sourceNode.ReadOnlyMode
    end
  end
end
  

  -- @See BaseNode.NewNode
  function StorageNodeHandlerController.NewNode(entity)
    return StorageNodeHandlerController.EnsureStructure(StorageNodeHandlerController._super.NewNode(entity))
  end

  -- Returns if the node is read only or not
  function StorageNodeHandlerController:IsReadOnly()
    return self.ReadOnlyMode
  end

  -- @See BaseNode:EnsureStructure
  function StorageNodeHandlerController:EnsureStructure()
    StorageNodeHandlerController._super.EnsureStructure(self)

    if (ForceReadOnly(self) or SE.Settings.ReadOnlyStorageChest) then
      self.ReadOnlyMode = true
    end

    return self
  end

