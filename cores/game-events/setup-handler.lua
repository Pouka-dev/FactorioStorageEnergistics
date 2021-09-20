-- Description: Defines the event handlers for init, loading, and config changes
-- Singleton
-- Constructs and returns the SetupHandlers object
local SetupHandlers = {}

-- OnGameLoad( Event ) :: void
-- Register a function to be run on module load.
-- This is called every time a save file is loaded *except* for the instance when a mod is loaded into a save file that it previously wasn't part of.
-- Additionally this is called when connecting to any other game in a multiplayer session and should never change the game state.
--
-- This is meant for specific reasons:
-- * re-register conditional event handlers
-- * re-setup meta tables
--
-- Doing any other logic when loading a save file can break the replay and cause desync issues if the mod is used in multiplayer.
function SetupHandlers.OnGameLoad(event)
    ---RSE.Logger.Info("Loading Saved Data")
    RSE.DataStore:OnLoad()
    RSE.NetworksManager.OnLoad()
end

-- OnGameInit( Event ) :: void
-- Register a callback to be run on mod init.
-- This is called once when a new save game is created or once when a save file is loaded that previously didn't contain the mod.
-- This is always called before other event handlers and is meant for setting up initial values that a mod will use for its lifetime.
function SetupHandlers.OnGameInit(event)    
    --- local freeplay = remote.interfaces["freeplay"]
    --- if freeplay then
    ---     -- Disable freeplay popup-message
    ---     if freeplay["set_skip_intro"] then
    ---         remote.call("freeplay", "set_skip_intro", true)
    ---     end
    ---     if freeplay["set_disable_crashsite"] then
    ---         remote.call("freeplay", "set_disable_crashsite", true)
    ---     end
    --- end
    ---RSE.Logger.Info("Initializing New Data")
    RSE.DataStore:OnInit()
    RSE.NetworksManager.OnInit()
end

-- OnConfigChange() :: void
-- Register a function to be run when mod configuration changes.
-- This is called any time the game version changes, prototypes change, startup mod settings change, and any time mod versions change including adding or removing mods.
function SetupHandlers.OnConfigChange(data)
    -- TODO: Are there any actions this mod should take?
    ---RSE.Logger.Info("Configuration Changed")
end

-- RegisterWithGame() ::void
-- Registers the event listeners for the setup events.
function SetupHandlers.RegisterWithGame()
    
    script.on_init(SetupHandlers.OnGameInit)
    script.on_load(SetupHandlers.OnGameLoad)
    script.on_configuration_changed(SetupHandlers.OnConfigChange)
end

return SetupHandlers
