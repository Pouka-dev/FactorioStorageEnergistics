local entities = {
    "entity-se-controller",
    "entity-se-energy-acceptor",
    "hidden-entity-se-energy-acceptor",
    "entity-se-chest-mk1",
    "entity-se-chest-large-mk1",
    "entity-se-chest-warehousing-mk1",
    "entity-se-chest-mk2",
    "entity-se-chest-large-mk2",
    "entity-se-chest-warehousing-mk2",
    "entity-se-interface-chest",
    "entity-se-interface-chest-large",
    "entity-se-interface-chest-warehousing",
    "entity-se-provider-chest",
    "entity-se-requester-chest",
    "entity-se-requester-chest-large",
    "entity-se-requester-chest-warehousing"
}

--global.Nodes = {}
-- local initial = #global.Nodes

-- local Logger = require ("cores.lib.logger")
-- Logger.EnableTrace = true
-- Logger.EnableLogging = true

for _, surface in pairs(game.surfaces) do
    for i = 1, #entities do
        for _, entity in pairs(surface.find_entities_filtered({name = entities[i]})) do
            --table.insert(global.Nodes, entity)

            local handler = RSE.NodeHandlersRegistry:GetEntityHandler(entity)
            if (handler ~= nil) then
                ---RSE.Logger.Trace("Entity Handler: Adding network node " .. handler.HandlerName)
                local newNode = RSE.NetworksManager.AddNode(handler.NewNode(entity))
                --EntityHandlers.OnPasteSettingsWithNode(entity, newNode, event)
            end
        end
    end
end

-- Logger.Info("Initial: " .. initial)
-- Logger.Info("Finished: " .. #global.Nodes)

--RSE.DataStore = SEStoreConstructor("RSEDataStore")
--RSE.DataStore.Nodes = global.Nodes

--RSE.NetworksManager.FirstTick()