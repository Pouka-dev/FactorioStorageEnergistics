-- Description: GUI related events

-- Construct and return the SEGuiManager
return function()
    local SEGuiManager = {
        Guis = {}
    }

    -- Add GUI's
    SEGuiManager.Guis.BaseGui = (require "cores.guis.base-gui")()
    SEGuiManager.Guis.InterfaceNodeGUI = (require "cores.guis.interface-node-gui")(SEGuiManager.Guis.BaseGui)
    SEGuiManager.Guis.StorageNodeGUI = (require "cores.guis.storage-node-gui")(SEGuiManager.Guis.BaseGui)
    SEGuiManager.Guis.NetworkOverview = (require "cores.guis.network-overview-gui")(SEGuiManager.Guis.BaseGui)

    -- Map( PlayerIndex :: uint -> { GuiHandler :: SEGuiManager, GuiData :: Any } ) )
    -- Tracks which GUI players have open, and each Guis data
    -- Note: GUI data is not saved between game save/loads
    local OpenedGuis = {}

    -- OnOpenEntity( Event ) :: void
    -- Called when the player has just opened an entity
    -- Returns: The nodes info, or false
    local function OnOpenEntity(event)
        local entity = event.entity

        -- Does that entity have a node handler?
        local handler = RSE.NodeHandlersRegistry:GetEntityHandler(entity)
        if (handler == nil) then
            -- Not a network node
            return
        end

        -- Get the node for the entity
        local node = RSE.NetworksManager.GetNodeForEntity(entity)
        if (node == nil) then
            error("RE:Storage Energistics: Player Opened An Unregistered Entity")
        end

        -- Ask the handler for a GUI
        local guiHandler = handler.OnGetGuiHandler(node, event.player_index)
        if (guiHandler ~= nil) then
            -- Show the gui
            SEGuiManager.ShowGui(event, guiHandler, {Node = node})
        end
    end

    -- ShowGui( uint, GuiHandler, Table ) :: void
    -- Attempts to show the gui.
    function SEGuiManager.ShowGui(event, guiHandler, guiData)
        -- Ensure the gui data object
        guiData = guiData or {}

        -- Open the GUI
        if (guiHandler.OnShow(guiData, event)) then
            -- Save the data
            OpenedGuis[event.player_index] = {GuiHandler = guiHandler, GuiData = guiData}
        end
    end

    -- CloseGui( uint ) :: void
    -- Attempts to close the gui.
    function SEGuiManager.CloseGui(playerIndex)
        -- Get the data
        local openedGui = OpenedGuis[playerIndex]

        -- Close the GUI
        openedGui.GuiHandler.OnClose(openedGui.GuiData, playerIndex)

        -- Clear the entry
        OpenedGuis[playerIndex] = nil
    end

    -- IsGuiOpen( uint, GuiHandler ) :: void
    -- Returns true if the specified gui is open
    function SEGuiManager.IsGuiOpen(playerIndex, guiHandler)
        -- Get the gui
        local openedGui = OpenedGuis[playerIndex]
        if (openedGui == nil) then
            return false
        end

        -- Get the data
        return openedGui.GuiHandler == guiHandler
    end

    -- Tick() :: void
    -- Called every game tick
    -- If there are any GUIs open, and those GUIs accept ticks, they will be ticked.
    function SEGuiManager.Tick(tick)
        -- Tick guis
        for player_index, openedGui in pairs(OpenedGuis) do
            if (openedGui.GuiHandler.NeedsTicks) then
                -- Tick the gui
                if (not openedGui.GuiHandler.OnTick(openedGui.GuiData, player_index, tick)) then
                    -- Close the gui
                    -- (As we are not adding, so this should be safe)
                    SEGuiManager.CloseGui(player_index)
                end
            end
        end
    end

    -- OnPlayerOpenedGUI( Event )
    -- Called when the player opens a GUI.
    -- Event fields:
    -- - player_index :: uint: The player.
    -- - gui_type :: defines.gui_type: The GUI type that was opened.
    -- - entity :: LuaEntity (optional): The entity that was opened
    -- - item :: LuaItemStack (optional): The item that was opened
    -- - equipment :: LuaEquipment (optional): The equipment that was opened
    -- - other_player :: LuaPlayer (optional): The other player that was opened
    -- - element :: LuaGuiElement (optional): The custom GUI element that was opened
    -- Called when the player opens a GUI.
    function SEGuiManager.OnPlayerOpenedGUI(event)
        -- Opened entity?
        if (event.entity ~= nil) then
            OnOpenEntity(event)
        end
    end

    -- OnPlayerClosedGUI( Event )
    -- Called when the player closes the GUI they have open.
    -- Event fields:
    -- - player_index :: uint: The player.
    -- - gui_type :: defines.gui_type: The GUI type that was open.
    -- - entity :: LuaEntity (optional): The entity that was open
    -- - item :: LuaItemStack (optional): The item that was open
    -- - equipment :: LuaEquipment (optional): The equipment that was open
    -- - other_player :: LuaPlayer (optional): The other player that was open
    -- - element :: LuaGuiElement (optional): The custom GUI element that was open
    -- Note: This is only called if the player explicitly closed the GUI.
    -- Note: It's not advised to open any other GUI during this event because if this is run as a request to open a different GUI the game will force close the new opened GUI without notice to ensure the original requested GUI is opened.
    function SEGuiManager.OnPlayerClosedGUI(event)
        -- Does this player not have an SE gui open?
        local openedGui = OpenedGuis[event.player_index]
        if (openedGui == nil) then
            return
        end

        -- Close it
        SEGuiManager.CloseGui(event.player_index)
    end

    -- HandlerGeneralizedGuiEvent( Event, String ) :: void
    -- Calls the given event-handler function on the gui-handler
    local function HandlerGeneralizedGuiEvent(event, eventHandlerFunctionName)
        
        -- Get the gui
        local openedGui = OpenedGuis[event.player_index]
        if (openedGui == nil) then
            Player.load(event)
            local lua_gui_element = Player.getGui("center")
            for _,children_name in pairs(lua_gui_element.children_names) do
                if children_name == "se_gui_network_overview" then
                    lua_gui_element[children_name].destroy()
                end
          end
            return
        end

        -- Inform the GUI
        openedGui.GuiHandler[eventHandlerFunctionName](openedGui.GuiData, event)
    end

    -- OnElementChanged( Event ) :: void
    -- Called when a selection element has changed
    function SEGuiManager.OnElementChanged(event)
        HandlerGeneralizedGuiEvent(event, "OnPlayerChangedSelectionElement")
    end

    -- OnCheckboxChanged( Event ) :: void
    -- Called when a checkbox changes
    function SEGuiManager.OnCheckboxChanged(event)
        HandlerGeneralizedGuiEvent(event, "OnPlayerChangedCheckboxElement")
    end

    -- OnDropDownChanged( Event ) :: void
    -- Called when a dropdown changes
    function SEGuiManager.OnDropDownChanged(event)
        HandlerGeneralizedGuiEvent(event, "OnPlayerChangedDropDown")
    end

    -- OnTextChanged( Event ) :: void
    -- Event fields:
    -- element :: LuaGuiElement
    -- player_index :: uint
    function SEGuiManager.OnTextChanged(event)
        HandlerGeneralizedGuiEvent(event, "OnPlayerChangedText")
    end

    -- OnSliderChanged( Event ) :: void
    -- Event fields:
    -- element :: LuaGuiElement
    -- player_index :: uint
    function SEGuiManager.OnSliderChanged(event)
        HandlerGeneralizedGuiEvent(event, "OnPlayerChangedSlider")
    end

    -- OnElementClicked( Event ) :: void
    -- Event fields:
    -- element :: LuaGuiElement
    -- player_index :: uint
    -- button :: defines.mouse_button_type
    -- alt :: boolean
    -- control :: boolean
    -- shift :: boolean
    function SEGuiManager.OnElementClicked(event)
        HandlerGeneralizedGuiEvent(event, "OnPlayerClicked")
    end

    -- OnPlayerJoinedGame( Event ) :: void
    -- Called when a player joins the game
    -- Walk through all GUI's and ensure they are closed
    -- as their data is not saved
    function SEGuiManager.OnPlayerJoinedGame(event)
        for _, guiHandler in pairs(SEGuiManager.Guis) do
            guiHandler.OnClose(nil, event.player_index)
        end
    end

    -- RegisterWithGame() :: void
    -- Called to register the handler events
    function SEGuiManager.RegisterWithGame()
        script.on_event(defines.events.on_gui_closed, SEGuiManager.OnPlayerClosedGUI)
        script.on_event(defines.events.on_gui_opened, SEGuiManager.OnPlayerOpenedGUI)
        script.on_event(defines.events.on_gui_elem_changed, SEGuiManager.OnElementChanged)
        script.on_event(defines.events.on_gui_checked_state_changed, SEGuiManager.OnCheckboxChanged)
        script.on_event(defines.events.on_gui_selection_state_changed, SEGuiManager.OnDropDownChanged)
        script.on_event(defines.events.on_gui_click, SEGuiManager.OnElementClicked)
        script.on_event(defines.events.on_gui_text_changed, SEGuiManager.OnTextChanged)
        script.on_event(defines.events.on_gui_value_changed, SEGuiManager.OnSliderChanged)
    end

    return SEGuiManager
end
