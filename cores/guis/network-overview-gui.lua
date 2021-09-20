-- Description: Manages the global UI for storage networks.
require "cores.lib.string-utils"
require "cores.lib.gui-helper"

-- Constructs and returns the NetworkOverviewGUI
return function(BaseGUI)
    local NetworkOverviewGUI = {
        NeedsTicks = true,
        TicksBetweenUpdates = 60.0 * 5.0
    }
    setmetatable(NetworkOverviewGUI, {__index = BaseGUI})
    
    
    
    local ConstantsStringsLocal = RSE.Constants.Strings.Local
    local ConstantsStyles = RSE.Constants.Names.Styles
    local NetworkOverview = RSE.Constants.Names.Gui.NetworkOverview
    local VariablesNetworkOverview = RSE.Constants.Variables.NetworkOverview
    
    
    -- NewItemCell( LuaGuiElement ) :: ItemCell
    -- ItemCell :: { Cell, Slot, Label }
    local function NewItemCell(itemTable)
        
        -- Create the item cell
        local itemCell = GuiElement.add(itemTable, GuiFlow():style(ConstantsStyles.Flows.SEFlowItemCell):tooltip(NetworkOverview.ItemCellTooltip))
        
        
        -- Add the item slot
        local slot = GuiElement.add(itemCell, GuiButton(NetworkOverview.ItemCellChooseElemButton):choose("item", nil))
        
        -- Lock
        slot.locked = true
        
        -- Add count
        AddCountToSlot(slot)
        
        -- Add the label
        local itemLabel = GuiElement.add(itemCell, GuiLabel(NetworkOverview.ItemCellItemLabel):style(ConstantsStyles.Labels.SEItemTableItemLabel):caption(""))
        
        
        return {Cell = itemCell, Slot = slot} --- , Label = itemLabel
    end
    
    
    -- NewItemCell( LuaGuiElement, ItemInfo ) :: void
    -- Update the tooltip, count, and icon to match the given item
    local function UpdateItemCell(itemCell, item)
        -- Get the item prototype
        local itemPrototype = game.item_prototypes[item.ID]
        
        -- Update tooltip
        itemCell.Cell.tooltip = ConcatStringWithLocalized(NumberToStringWithThousands(item.Count) .. "x ", itemPrototype.localised_name)
        
        -- Update the slot
        itemCell.Slot.elem_value = itemPrototype.name
        
        -- Update counts
        UpdateSlotCount(itemCell.Slot, item.Count)
        
        -- Update label
        --- itemCell.Label.caption = itemPrototype.localised_name
    end
    
    
    
    
    
    -- DisplayItems( Table, ItemInfo ) :: void
    -- Shows the items in the table
    -- Where items = Map( itemName => count )
    local function DisplayItems(guiData, items)
        -- Create intermediate table for sorting
        local indexedItems = {}
        for itemID, count in pairs(items) do
            indexedItems[#indexedItems + 1] = {ID = itemID, Count = count}
        end
        
        -- Sort the items
        table.sort(
            indexedItems,
            function(a, b)
                return a.Count > b.Count
            end
        )
        -- Ensure item cells has been added
        guiData.ItemCells = guiData.ItemCells or {}
        
        -- Get new and old number of cells
        local newCellCount = #indexedItems
        local oldCellCount = #guiData.ItemCells
        
        -- Update existing cells
        local cellIndex = 1
        while cellIndex <= newCellCount do
            local itemCell = nil
            if cellIndex <= oldCellCount then
                -- Get the existing cell
                itemCell = guiData.ItemCells[cellIndex]
            else
                -- Create a new cell
                itemCell = NewItemCell(guiData.FrameData.ItemTable)
                guiData.ItemCells[#guiData.ItemCells + 1] = itemCell
            end
            
            -- Get the item
            local item = indexedItems[cellIndex]
            
            -- Update the item cell
            UpdateItemCell(itemCell, item)
            
            -- Move to next cell
            cellIndex = cellIndex + 1
        end
        
        -- Are there any unused cells?
        while cellIndex <= oldCellCount do
            -- Get the last cell
            local itemCell = guiData.ItemCells[#guiData.ItemCells]
            
            -- Destroy it
            itemCell.Cell.destroy()
            
            -- Remove from cells
            guiData.ItemCells[#guiData.ItemCells] = nil
            
            -- Increment index
            cellIndex = cellIndex + 1
        end
    end
    
    
    
    
    
    
    -- LoadNetworkContents( Table, uint ) :: void
    -- Adds the contents of the network to the frame
    local function LoadNetworkContents(guiData, tick)
        -- Get the network
        local network = RSE.NetworksManager.GetNetwork(guiData.NetworkIDs[guiData.FrameData.NetworkDropDown.selected_index])
        
        -- Query the network for the items
        local networkContents = RSE.NetworkHandler.GetStorageContents(network, tick)
        
        -- Extract capacity amounts
        local totalSlots = networkContents[RSE.Constants.Strings.TotalSlots]
        local freeSlots = networkContents[RSE.Constants.Strings.FreeSlots]
        
        -- Remove capacity amounts from item list
        networkContents[RSE.Constants.Strings.TotalSlots] = nil
        networkContents[RSE.Constants.Strings.FreeSlots] = nil
        
        -- Update capacity progress bar
        local capacityPercent = 0
        if (totalSlots ~= nil and totalSlots > 0 and freeSlots ~= nil) then
            capacityPercent = 1.0 - (freeSlots / totalSlots)
        end
        guiData.FrameData.Capacity.value = capacityPercent
        guiData.FrameData.Capacity.tooltip = ConcatStringWithLocalized(ConstantsStringsLocal.NetCap, tostring(math.floor(capacityPercent * 1000) / 10) .. "%")
        
        DisplayItems(guiData, networkContents)
    end
    
    -- UpdateDropdownNetworks( Table, uint ) :: void
    -- Sets the networks in the dropdown
    local function UpdateDropdownNetworks(guiData, tick)
        -- Get network ids
        guiData.NetworkIDs = RSE.NetworksManager.GetNetworkIDs()
        
        local ddList = {}
        if (#guiData.NetworkIDs > 0) then
            -- Build dropdown list
            local idx = #guiData.NetworkIDs
            while idx > 0 do
                -- Get the next network ID
                local networkID = guiData.NetworkIDs[idx]
                
                -- Get the network
                local network = RSE.NetworksManager.GetNetwork(networkID)
                
                -- Ensure there are non-controller devices on the network
                if RSE.NetworkHandler.checkForDisplayNetworkOnNetworkGUI(network) then
                    -- Remove the empty network
                    table.remove(guiData.NetworkIDs, idx)
                else
                    -- Add to the dropdown list
                    table.insert(ddList, 1, ConcatStringWithLocalized(ConstantsStringsLocal.NetworkID, "# " .. tostring(networkID)))
                end
                
                -- Decrement index
                idx = idx - 1
            end
            -- Assign dropdown list
            if next(ddList) then
                guiData.FrameData.NetworkDropDown.items = ddList
                guiData.FrameData.NetworkDropDown.selected_index = 1

                -- Load the first network
            LoadNetworkContents(guiData, tick)
            end
            

            
            
        end
    end
    
    
    
    -- NewFrame( LuaGuiElement ) :: FrameData
    -- FrameData
    -- - ItemTable :: LuaGuiElement
    -- - NetworkDropDown :: LuaGuiElement
    -- - Capacity :: LuaGuiElement
    local function NewFrame(root)
      local SEFrame = GuiElement.add(root, GuiFrame(NetworkOverview.Name)
          :caption(ConstantsStringsLocal.StorageNetwork))
      local contents = GuiElement.add(SEFrame, GuiTable(NetworkOverview.Contents)
          :column(1))
      local header = GuiElement.add(contents, GuiTable(NetworkOverview.Header)
          :style(ConstantsStyles.Tables.SETableNetworkOverviewHeader):column(1))
      local networkDropDown = GuiElement.add(header, GuiDropDown(NetworkOverview.Dropdown))
      local progBar = GuiElement.add(header, GuiProgressBar(NetworkOverview.ProgressBar)
          :value(0):size(VariablesNetworkOverview.Progressbar.Width))
      local h_hzline = GuiElement.add(header, GuiProgressBar(NetworkOverview.HeaderHorizontalLine)
          :style(ConstantsStyles.Progressbars.SEProgressbarHorizontalLine):value(1.0):size(VariablesNetworkOverview.Progressbar.Width))
      local scrollWrapper = GuiElement.add(contents, GuiScroll(NetworkOverview.ScrollWrapper)
          :policy("always"))
      local itemTable = GuiElement.add(scrollWrapper, GuiTable(NetworkOverview.ItemTable)
          :column(8))
      local footer = GuiElement.add(contents, GuiTable(NetworkOverview.Footer)
          :style(ConstantsStyles.Tables.SETableNetworkOverviewFooter):column(1))
      local f_hzline = GuiElement.add(footer, GuiProgressBar(NetworkOverview.Footer)
          :style(ConstantsStyles.Progressbars.SEProgressbarHorizontalLine):value(1.0):size(VariablesNetworkOverview.Progressbar.Width))
      GuiElement.add(footer, GuiButton(NetworkOverview.Close)
          :caption(ConstantsStringsLocal.Close))
      
      return {ItemTable = itemTable, NetworkDropDown = networkDropDown, Capacity = progBar}
  end
    
    
    
    
    -- @See BaseGui:OnShow
    function NetworkOverviewGUI:OnShow(event)
        
        local player = Player.load(event).get()
        
        -- Get root
        local root = Player.getGui(NetworkOverview.FrameRoot)
        
        -- Has frame?
        if (root[NetworkOverview.Name] ~= nil) then
            -- Already open, close first
            NetworkOverviewGUI.OnClose(self, player.index)
        end
        
        -- Build the frame
        self.FrameData = NewFrame(root)
        
        -- Build dropdown list
        UpdateDropdownNetworks(self, event.tick)
        -- Add tick info
        self.TickCount = 0
        
        --- Set as opened
        player.opened = root[NetworkOverview.Name]
        
        return true
    end
    
    -- @See BaseGui:OnClose
    function NetworkOverviewGUI:OnClose(playerIndex)
        local player = Player.setByIndex(playerIndex).get()
        local root = Player.getGui(NetworkOverview.FrameRoot)
        local frame = root[NetworkOverview.Name]
        
        if (frame ~= nil) then
            -- Remove frame from player opened?
            if (player.opened == frame) then
                player.opened = nil
            end
            
            frame.destroy()
        end
    end
    
    
    -- @See BaseGui:OnPlayerChangedDropDown
    function NetworkOverviewGUI:OnPlayerChangedDropDown(event)
        LoadNetworkContents(self, event.tick)
    end
    
    
    
    -- @See BaseGUI:OnPlayerClicked
    function NetworkOverviewGUI:OnPlayerClicked(event)
        local element = event.element
        
        if (element ~= nil and element.name == NetworkOverview.Close) then
            RSE.GuiManager.CloseGui(event.player_index)
        end
    end
    
    
    -- @See BaseGui:OnTick
    function NetworkOverviewGUI:OnTick(player_index, tick)
        if (self == nil or self.TickCount == nil) then
            -- Invalid data
            return false
        end
        
        -- Increment tick count
        self.TickCount = self.TickCount + 1
        
        -- Skip this tick?
        if (self.TickCount < NetworkOverviewGUI.TicksBetweenUpdates) then
            return true
        end
        self.TickCount = 0
        
        if (#self.NetworkIDs > 0) then
            LoadNetworkContents(self, tick)
        end
        return true
    end
    
    return NetworkOverviewGUI
end
