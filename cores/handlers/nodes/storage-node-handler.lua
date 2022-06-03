-- Description: Storage Node
StorageNodeHandlerConstructor = newclass(BaseNodeHandlerConstructor,function(base,...)
  BaseNodeHandler.init(base,...)
  base.Type = RSE.Constants.NodeTypes.Storage
end)

  -- ForceReadOnly( Node ) :: bool
  -- Returns true if read only should be forced, based on the entity
  local function ForceReadOnly(node)
    return node.Entity.name == RSE.Constants.Names.Proto.RequesterChest.Entity
  end

  -- DefaultValueForSEReadOnlyStorage( Event ) :: bool
  -- Returns a value of se-read_only_storage settings by Player or default value of save
  local function DefaultValueForSEReadOnlyStorage(event)
    local isEnable = RSE.Settings.ReadOnlyStorageChest
    if event ~= nil and event['player_index'] ~= nil then
      local playerModSettings = Player.load(event).getModSettings()
      isEnable = playerModSettings["se-read_only_storage"].value
    end
    return isEnable
  end

  -- @See BaseNode:OnGetGuiHandler
  -- Show the gui
  function StorageNodeHandlerConstructor:OnGetGuiHandler(playerIndex)
    if (not ForceReadOnly(self)) then
      return RSE.GuiManager.Guis.StorageNodeGUI
    end
  end

  -- @See BaseNode:InsertItems
  function StorageNodeHandlerConstructor:InsertItems(stack, simulate)
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
  function StorageNodeHandlerConstructor:ExtractItems(stack, simulate)
    local inv = self.Entity.get_inventory(defines.inventory.chest)
    local removed = inv.remove(stack)
    if (simulate and removed > 0) then
      inv.insert({name = stack.name, count = removed})
    end
    return removed
  end

  -- @See BaseNode:GetItemCount
  function StorageNodeHandlerConstructor:GetItemCount(itemName)
    local inv = self.Entity.get_inventory(defines.inventory.chest)
    return inv.get_item_count(itemName)
  end

  -- @See BaseNode:GetContents
  function StorageNodeHandlerConstructor:GetContents(catalog)
    local inv = self.Entity.get_inventory(defines.inventory.chest)
    -- Get total slot count
    local totalSlots = #inv

    -- Add total to catalog
    catalog[RSE.Constants.Strings.TotalSlots] = (catalog[RSE.Constants.Strings.TotalSlots] or 0) + totalSlots

    -- Examine inventory
    local freeSlots = 0
    local item = nil
    for idx = 1, totalSlots do
      item = inv[idx]
      if (item.valid_for_read) then
        -----RSE.Logger.Trace("Index " .. tostring(idx) .. " has item " .. item.name .. " x" .. tostring(item.count))
        -- Add item to catalog
        catalog[item.name] = (catalog[item.name] or 0) + item.count
      else
        freeSlots = freeSlots + 1
      end
    end

    -- Add free to catalog
    catalog[RSE.Constants.Strings.FreeSlots] = (catalog[RSE.Constants.Strings.FreeSlots] or 0) + freeSlots
  end

  -- OnPasteSettings( Self,  LuaEntity ) :: void
  function StorageNodeHandlerConstructor:OnPasteSettings(sourceEntity)
    -- Is this node forced read-only?
    if (ForceReadOnly(self)) then
      return
    end

    -- Other node is storage node?
    local node = RSE.NetworksManager.GetNodeForEntity(sourceEntity)
    if (node ~= nil) then
      local handler = RSE.NodeHandlersRegistry:GetNodeHandler(node)
      if (handler ~= nil and handler.Type == RSE.Constants.NodeTypes.Storage) then
        -- Copy read only setting
        self.ReadOnlyMode = node.ReadOnlyMode
      end
    end
  end

 -- OnPasteSettingsWithNode( Self,  Node ) :: void
 function StorageNodeHandlerConstructor:OnPasteSettingsWithNode(sourceNode)
  -- Is this node forced read-only?
  if (ForceReadOnly(self)) then
    return
  end

  -- Other node is storage node?
  if (sourceNode ~= nil) then
    local handler = RSE.NodeHandlersRegistry:GetNodeHandler(sourceNode)
    if (handler ~= nil and handler.Type == RSE.Constants.NodeTypes.Storage) then
      -- Copy read only setting
      self.ReadOnlyMode = sourceNode.ReadOnlyMode
    end
  end
end
  

  -- @See BaseNode.NewNode
  function StorageNodeHandlerConstructor.NewNode(entity,event)
    return StorageNodeHandlerConstructor.EnsureStructure(StorageNodeHandlerConstructor._super.NewNode(entity), nil,event)
  end

  -- Returns if the node is read only or not
  function StorageNodeHandlerConstructor:IsReadOnly()
    return self.ReadOnlyMode
  end

  -- @See BaseNode:EnsureStructure TODO SETTINGS
  function StorageNodeHandlerConstructor:EnsureStructure(isFirstTick, event)
    StorageNodeHandlerConstructor._super.EnsureStructure(self)
    -- Name of the handler that implements functionality
    self.HandlerName = StorageNodeHandler.HandlerName

    if (not isFirstTick and (ForceReadOnly(self) or DefaultValueForSEReadOnlyStorage(event))) then
      self.ReadOnlyMode = true
    end

    return self
  end

