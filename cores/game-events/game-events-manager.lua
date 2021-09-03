--- Description: Defines the event manager for game/script events

--- Constructs and returns the GameEventManager object
return function()
    local GameEventManager = {
        Setup = (require "cores.game-events.setup-handler")(),
        Entity = (require "cores.game-events.entity-handler")(),
        Control = (require "cores.game-events.control-handler")()
    }

    --- RegisterHandlers() :: void
    --- Registers all game event handlers
    function GameEventManager.RegisterHandlers()
        GameEventManager.Setup.RegisterWithGame()
        GameEventManager.Entity.RegisterWithGame()
        GameEventManager.Control.RegisterWithGame()
        SE.GuiManager.RegisterWithGame()
        script.on_event(defines.events.on_tick, GameEventManager.OnFirstTick)
        script.on_event(defines.events.on_player_joined_game, SE.GuiManager.OnPlayerJoinedGame)
        script.on_event(defines.events.on_runtime_mod_setting_changed, SE.Settings.LoadSettings)
    end

    --- OnFirstTick( Event ) :: void
    --- Called when the game ticks for the first time for this load.
    function GameEventManager.OnFirstTick(event)
        SE.CachePrototypes()
        SE.NetworksManager.FirstTick()

        -- Pass tick on to regular handler
        GameEventManager.OnTick(event)

        -- Change tick handler
        script.on_event(defines.events.on_tick, GameEventManager.OnTick)
    end

    -- OnTick( Event ) :: void
    -- Called every game tick.
    function GameEventManager.OnTick(event)
        SE.NetworksManager.Tick(event)
        SE.GuiManager.Tick(event.tick)
        SE.Logger.Tick()
    end


    

    -- -- OnPlayerJoined( Event ) :: void
    -- -- Called when a player joins the game
    -- -- Event fields:
    -- -- - player_index :: uint
    -- function GameEventManager.OnPlayerJoined(event)
    --   SE.GuiManager.OnPlayerJoinedGame(event)
    -- end

    return GameEventManager
end
