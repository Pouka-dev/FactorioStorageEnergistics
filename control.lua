-------------- include libs ---------------
require ("mod-gui")
require ("util")
require ("cores.lib.class")
require ("cores.lib.fpairs")
require ("cores.models.player")
require ("cores.lib.Object")
require ("cores.lib.energy-helper")
require ("cores.lib.transfert-helper")


-------------- include core --------------
require ("cores.se-settings")
require ("cores.se-data-store")
require ("cores.handlers.networks-manager")
require ("cores.handlers.base-network-handler")

-------------- include handlers registry --------------
require ("cores.handlers.handlers-registry")

-------------- include handlers node --------------
require ("cores.handlers.nodes.base-node-handler")
require ("cores.handlers.nodes.controller-node-handler")
require ("cores.handlers.nodes.energy-acceptor-node-handler")
require ("cores.handlers.nodes.storage-node-handler")
require ("cores.handlers.nodes.interface-node-handler")



--- Create the instance container
RSE = {
    -- Map<ItemName :: string -> MaxStackSize :: int>
    StackSizeCache = {}
}

function RSE.CachePrototypes()
    -- Get item stack sizes
    for name, proto in pairs(game.item_prototypes) do
        RSE.StackSizeCache[name] = proto.stack_size
    end
end




-- Create the logger
RSE.Logger = require ("cores.lib.logger")
-- Log trace messages
RSE.Logger.EnableTrace = false
RSE.Logger.EnableLogging = false


--- Create constants
RSE.Constants = require ("cores.constants.constants")

--- Get settings
RSE.Settings = SESettingsConstructor("RSESettings")
-- Load the settings upon creation
RSE.Settings:LoadSettings()
--- Create the data store
RSE.DataStore = SEStoreConstructor("RSEDataStore")

--- Create the storage networks manager
RSE.NetworksManager = NetworksManagerObjectConstructor("RSENetworksManager")

--- Create the storage network handler
RSE.NetworkHandler = BaseNetworkHandlerConstructor("RSEBaseNetworkHandler")

-------------- Create Node Handlers Registry--------------
RSE.NodeHandlersRegistry = NodeHandlersRegistryConstructor("RSENodeHandlersRegistry")

-------------- instances node Handlers --------------
BaseNodeHandler = BaseNodeHandlerConstructor(RSE.Constants.Names.NodeHandlers.Base)
ControllerNodeHandlers = ControllerNodeHandlersConstructor(RSE.Constants.Names.NodeHandlers.Controller)
EnergyAcceptorNodeHandler = EnergyAcceptorNodeHandlerConstructor(RSE.Constants.Names.NodeHandlers.EnergyAcceptor)
StorageNodeHandler = StorageNodeHandlerConstructor(RSE.Constants.Names.NodeHandlers.Storage)
InterfaceNodeHandler = InterfaceNodeHandlerConstructor(RSE.Constants.Names.NodeHandlers.Interface)

-------------- Registry node Handlers --------------
RSE.NodeHandlersRegistry:AddHandler(BaseNodeHandler)
RSE.NodeHandlersRegistry:AddHandler(ControllerNodeHandlers)
RSE.NodeHandlersRegistry:AddHandler(EnergyAcceptorNodeHandler)
RSE.NodeHandlersRegistry:AddHandler(StorageNodeHandler)
RSE.NodeHandlersRegistry:AddHandler(InterfaceNodeHandler)


--- Link node handlers with entities
local protoNames = RSE.Constants.Names.Proto
local handlerNames = RSE.Constants.Names.NodeHandlers
RSE.NodeHandlersRegistry:AddEntityHandler(protoNames.Controller.Entity, handlerNames.Controller)
RSE.NodeHandlersRegistry:AddEntityHandler(protoNames.EnergyAcceptor.Entity, handlerNames.EnergyAcceptor)

RSE.NodeHandlersRegistry:AddEntityHandler(protoNames.StorageChestMk1.Entity, handlerNames.Storage)
RSE.NodeHandlersRegistry:AddEntityHandler(protoNames.StorageChestLargeMk1.Entity, handlerNames.Storage)
RSE.NodeHandlersRegistry:AddEntityHandler(protoNames.StorageChestWarehousingMk1.Entity, handlerNames.Storage)

RSE.NodeHandlersRegistry:AddEntityHandler(protoNames.StorageChestMk2.Entity, handlerNames.Storage)
RSE.NodeHandlersRegistry:AddEntityHandler(protoNames.StorageChestLargeMk2.Entity, handlerNames.Storage)
RSE.NodeHandlersRegistry:AddEntityHandler(protoNames.StorageChestWarehousingMk2.Entity, handlerNames.Storage)

RSE.NodeHandlersRegistry:AddEntityHandler(protoNames.InterfaceChest.Entity, handlerNames.Interface)
RSE.NodeHandlersRegistry:AddEntityHandler(protoNames.InterfaceChestLarge.Entity, handlerNames.Interface)
RSE.NodeHandlersRegistry:AddEntityHandler(protoNames.InterfaceChestWarehousing.Entity, handlerNames.Interface)

RSE.NodeHandlersRegistry:AddEntityHandler(protoNames.RequesterChest.Entity, handlerNames.Storage)
RSE.NodeHandlersRegistry:AddEntityHandler(protoNames.ProviderChest.Entity, handlerNames.Interface)





--- Create the Gui manager

RSE.GuiManager = (require "cores.guis.gui-manager")()

--- Create the game event manager
RSE.GameEventManager = (require "cores.game-events.game-events-manager")()

require "cores.guis.guis"


--- Register for events
RSE.GameEventManager.RegisterHandlers()