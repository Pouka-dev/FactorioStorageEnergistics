
-- Kinds of nodes
local NodeTypes = {}

-- Node types
-- Device: Devices that utilize network functionality but does not fall into other categories.
NodeTypes.Device = 0
-- Controller: Directs network traffic. Minimum 1 required for every network for nodes to communicate.
NodeTypes.Controller = 1
-- PowerSource: Provides power to the network
NodeTypes.PowerSource = 2
-- Storage: Stores items
NodeTypes.Storage = 4

return NodeTypes