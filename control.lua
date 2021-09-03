
-------------- include libs ---------------
require ("mod-gui")
require ("cores.lib.class")
require ("cores.models.player")



--- Create the instance container
SE = {
    -- Map<ItemName :: string -> MaxStackSize :: int>
    StackSizeCache = {}
}

function SE.CachePrototypes()
    -- Get item stack sizes
    for name, proto in pairs(game.item_prototypes) do
        SE.StackSizeCache[name] = proto.stack_size
    end
end

-- Create the logger
SE.Logger = (require "cores.lib.logger")()
-- Log trace messages
SE.Logger.EnableTrace = false
SE.Logger.EnableLogging = true


--- Create constants
SE.Constants = (require 'cores.constants.constants')()

--- Get settings
SE.Settings = (require "cores.se-settings")()

--- Create the data store
SE.DataStore = (require "cores.se-data-store")()

--- Create the storage networks manager
SE.NetworksManager = (require "cores.handlers.networks-manager")()

--- Create the storage network handler
SE.NetworkHandler = (require "cores.handlers.network-handler")()

--- Create node handlers
SE.NodeHandlersRegistry = (require "cores.handlers.handlers-registry")()
local BaseHandler = (require "cores.handlers.nodes.base-node-handler")()
SE.NodeHandlersRegistry.AddHandler(BaseHandler)
SE.NodeHandlersRegistry.AddHandler((require "cores.handlers.nodes.controller-node-handler")(BaseHandler))
SE.NodeHandlersRegistry.AddHandler((require "cores.handlers.nodes.energy-acceptor-node-handler")(BaseHandler))
SE.NodeHandlersRegistry.AddHandler((require "cores.handlers.nodes.storage-node-handler")(BaseHandler))
SE.NodeHandlersRegistry.AddHandler((require "cores.handlers.nodes.interface-node-handler")(BaseHandler))


--- Link node handlers with entities
local protoNames = SE.Constants.Names.Proto
local handlerNames = SE.Constants.Names.NodeHandlers
SE.NodeHandlersRegistry.AddEntityHandler(protoNames.Controller.Entity, handlerNames.Controller)
SE.NodeHandlersRegistry.AddEntityHandler(protoNames.EnergyAcceptor.Entity, handlerNames.EnergyAcceptor)
SE.NodeHandlersRegistry.AddEntityHandler(protoNames.StorageChestMk1.Entity, handlerNames.Storage)
SE.NodeHandlersRegistry.AddEntityHandler(protoNames.StorageChestMk2.Entity, handlerNames.Storage)
SE.NodeHandlersRegistry.AddEntityHandler(protoNames.RequesterChest.Entity, handlerNames.Storage)
SE.NodeHandlersRegistry.AddEntityHandler(protoNames.InterfaceChest.Entity, handlerNames.Interface)
SE.NodeHandlersRegistry.AddEntityHandler(protoNames.ProviderChest.Entity, handlerNames.Interface)

--- Create the Gui manager
SE.GuiManager = (require "cores.guis.gui-manager")()

--- Create the game event manager
SE.GameEventManager = (require "cores.game-events.game-events-manager")()

require "cores.guis.guis"


--- Register for events
SE.GameEventManager.RegisterHandlers()