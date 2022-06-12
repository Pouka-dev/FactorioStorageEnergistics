--- Description: Defines the event manager for game/script events

--- Constructs and returns the GameEventManager object
return function()
    local GameEventManager = {
        Setup = require ("cores.game-events.setup-handler"),
        Entity = require ("cores.game-events.entity-handler"),
        Control = require ("cores.game-events.control-handler")
    }

    --- RegisterHandlers() :: void
    --- Registers all game event handlers
    function GameEventManager.RegisterHandlers()
        GameEventManager.Setup.RegisterWithGame()
        GameEventManager.Entity.RegisterWithGame()
        GameEventManager.Control.RegisterWithGame()
        RSE.GuiManager.RegisterWithGame()
        script.on_event(defines.events.on_tick, GameEventManager.OnFirstTick)
        script.on_event(defines.events.on_runtime_mod_setting_changed, GameEventManager.OnRuntimeModSettingChanged)
    end

    function GameEventManager.OnRuntimeModSettingChanged(event)
        RSE.Settings:LoadSettings(event)
    end


    --- OnFirstTick( Event ) :: void
    --- Called when the game ticks for the first time for this load.
    function GameEventManager.OnFirstTick(event)
        RSE.CachePrototypes()

        local handlerNames = RSE.Constants.Names.NodeHandlers
        if (game.active_mods['Warehousing']) then
            RSE.NodeHandlersRegistry:AddEntityHandler("storehouse-basic", handlerNames.Storage)
            RSE.NodeHandlersRegistry:AddEntityHandler("warehouse-basic", handlerNames.Storage)

            RSE.NodeHandlersRegistry:AddEntityHandler("storehouse-buffer", handlerNames.Interface)
            RSE.NodeHandlersRegistry:AddEntityHandler("warehouse-buffer", handlerNames.Interface)
        end
        if (game.active_mods['pyindustry']) then
            RSE.NodeHandlersRegistry:AddEntityHandler("py-shed-basic", handlerNames.Storage)
            RSE.NodeHandlersRegistry:AddEntityHandler("py-deposit-basic", handlerNames.Storage)
            RSE.NodeHandlersRegistry:AddEntityHandler("py-storehouse-basic", handlerNames.Storage)
            RSE.NodeHandlersRegistry:AddEntityHandler("py-warehouse-basic", handlerNames.Storage)

            RSE.NodeHandlersRegistry:AddEntityHandler("py-shed-buffer", handlerNames.Interface)
            RSE.NodeHandlersRegistry:AddEntityHandler("py-deposit-buffer", handlerNames.Interface)
            RSE.NodeHandlersRegistry:AddEntityHandler("py-storehouse-buffer", handlerNames.Interface)
            RSE.NodeHandlersRegistry:AddEntityHandler("py-warehouse-buffer", handlerNames.Interface)
        end

        RSE.NetworksManager.FirstTick()

        -- Pass tick on to regular handler
        GameEventManager.OnTick(event)

        -- Change tick handler
        script.on_event(defines.events.on_tick, GameEventManager.OnTick)
    end

    -- OnTick( Event ) :: void
    -- Called every game tick.
    function GameEventManager.OnTick(event)
        RSE.NetworksManager.Tick(event)
        RSE.GuiManager.Tick(event)
        RSE.Logger.Tick()
    end

    return GameEventManager
end
