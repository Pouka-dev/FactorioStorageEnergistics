--- Description: Defines the event manager for custom-input/control events
--- Constructs and returns the ControlHandler object

    local ControlHandler = {}
    
    -- OnShowStorageNetworkGUI( Event ) :: void
    -- Called when the key bound to show network overview is pressed
    function ControlHandler.OnShowStorageNetworkGUI(event)
        local playerIndex = event.player_index

        -- Toggle show/close
        if (RSE.GuiManager.IsGuiOpen(playerIndex, RSE.GuiManager.Guis.NetworkOverview)) then
            RSE.GuiManager.CloseGui(playerIndex)
            RSE.GuiManager.CloseBuggyGui(event)
            
        else
            RSE.GuiManager.ShowGui(event, RSE.GuiManager.Guis.NetworkOverview)
        end
    end
    
    -- RegisterWithGame() :: void
    -- Registers a listener for custom inputs
    function ControlHandler.RegisterWithGame()
        script.on_event(RSE.Constants.Names.Controls.StorageNetworkGui, ControlHandler.OnShowStorageNetworkGUI)
    end
    
    return ControlHandler

