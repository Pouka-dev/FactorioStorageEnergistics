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
        script.on_event(defines.events.on_player_joined_game, RSE.GuiManager.OnPlayerJoinedGame)
        script.on_event(defines.events.on_runtime_mod_setting_changed, GameEventManager.OnRuntimeModSettingChanged)
    end

    function GameEventManager.OnRuntimeModSettingChanged(event)
        RSE.Settings:LoadSettings(event)
    end


    --- OnFirstTick( Event ) :: void
    --- Called when the game ticks for the first time for this load.
    function GameEventManager.OnFirstTick(event)
        RSE.CachePrototypes()
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
        RSE.GuiManager.Tick(event.tick)
        RSE.Logger.Tick()
    end


    

    -- -- OnPlayerJoined( Event ) :: void
    -- -- Called when a player joins the game
    -- -- Event fields:
    -- -- - player_index :: uint
    -- function GameEventManager.OnPlayerJoined(event)
    --   RSE.GuiManager.OnPlayerJoinedGame(event)
    -- end

    return GameEventManager
end
