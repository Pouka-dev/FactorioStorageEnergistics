--- Description: Defines the event manager for custom-input/control events
--- Constructs and returns the ControlHandler object
return function()
    local ControlHandler = {}
    
    -- OnShowStorageNetworkGUI( Event ) :: void
    -- Called when the key bound to show network overview is pressed
    function ControlHandler.OnShowStorageNetworkGUI(event)
        local playerIndex = event.player_index
        
        -- Toggle show/close
        if (SE.GuiManager.IsGuiOpen(playerIndex, SE.GuiManager.Guis.NetworkOverview)) then
            SE.GuiManager.CloseGui(playerIndex)
        else
            SE.GuiManager.ShowGui(event, SE.GuiManager.Guis.NetworkOverview)
        end
    end
    
    -- RegisterWithGame() :: void
    -- Registers a listener for custom inputs
    function ControlHandler.RegisterWithGame()
        script.on_event(SE.Constants.Names.Controls.StorageNetworkGui, ControlHandler.OnShowStorageNetworkGUI)
    end
    
    return ControlHandler
end
