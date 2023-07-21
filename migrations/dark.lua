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

local Logger = require ("cores.lib.logger")
Logger.EnableTrace = true
Logger.EnableLogging = true

-- local function a(t, d)
--     for i,v in pairs(t) do
--         Logger.Info(string.rep("-", d) .. " " .. tostring(i) .. " -> " .. tostring(v))
--         if i ~= "__index" and i ~= "package" and i ~= "_G" and type(v) == "table" then
--             a(v, d + 1)
--         end
--     end
-- end
-- a(_G, 1)

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

local total = 0
local unable_to_set = 0
for _, node in pairs(RSE.DataStore.Nodes) do
    if node.HandlerName == "InterfaceNodeHandler" then
        local inv = node.Entity.get_inventory(defines.inventory.chest)
        total = total + 1
        if not inv.is_empty() then
            for item, count in pairs(inv.get_contents()) do
                table.insert(node.RequestFilters, {Item = item, Amount = 200, AmountMinForCall = 50})
            end
        else
            unable_to_set = unable_to_set + 1
        end
    end
end

game.print("DARK: Storage Energistics migration finished: " .. unable_to_set .. "/" .. total .. " filters were unable to be semi-recovered!", {r = 255, g = 255})
game.print("Please Note: I can only recover filters from non-empty chests.", {r = 255, g = 255})
