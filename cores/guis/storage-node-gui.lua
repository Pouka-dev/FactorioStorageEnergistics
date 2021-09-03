-- Description:


local ConstantsStringsLocal = SE.Constants.Strings.Local
local StorageChestGUI = SE.Constants.Names.Gui.StorageChest


-- Constructs and returns the StorageNodeGUI object
return function(BaseGUI)
  local StorageNodeGUI = {}
  setmetatable(StorageNodeGUI, {__index = BaseGUI})

  -- @See BaseGUI:OnShow
  function StorageNodeGUI:OnShow(event)
    local player = Player.load(event).get()
    -- Get root
    local root = player.gui[StorageChestGUI.FrameRoot]

    -- Has frame?
    local frame = root[StorageChestGUI.Name]
    if (frame ~= nil) then
      -- Already open
      return false
    end

    -- Add the frame
    frame = GuiElement.add(root, GuiFrame(StorageChestGUI.Name):caption(ConstantsStringsLocal.ChestSettings))
    -- Add read only checkbox
    GuiElement.add(frame, GuiCheckBox(StorageChestGUI.ReadOnlyCheckbox)
      :caption(ConstantsStringsLocal.ChestMode):tooltip(ConstantsStringsLocal.ChestMode_Tooltip):state((self.Node.ReadOnlyMode == true)))

    return true
  end

  -- @See BaseGUI:OnClose
  function StorageNodeGUI:OnClose(playerIndex)
    local player = Player.setByIndex(playerIndex).get()
    local root = player.gui[StorageChestGUI.FrameRoot]
    local frame = root[StorageChestGUI.Name]
    if (frame ~= nil) then
      frame.destroy()
    end
  end

  -- @See BaseGUI:OnPlayerChangedCheckboxElement
  function StorageNodeGUI:OnPlayerChangedCheckboxElement(event)
    local chkBox = event.element
    -- Ensure the frame is present, and the correct box was clicked
    if (chkBox.name == StorageChestGUI.ReadOnlyCheckbox) then
      if (chkBox.state) then
        self.Node.ReadOnlyMode = true
      else
        -- Why nil? Micro-optimization.
        -- Setting to false will cause the property to be serialized
        -- Since false is the default mode, removing the property has the same effect
        self.Node.ReadOnlyMode = nil
      end
    end
  end

  return StorageNodeGUI
end
