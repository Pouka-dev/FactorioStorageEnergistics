-- Description: Storage Node
InterfaceNodeHandlerConstructor = newclass(BaseNodeHandlerConstructor, function(base, ...)
    BaseNodeHandler.init(base, ...)
    base.NeedsTicks = true
end)

-- CopyNodeFilters( Node, Node ) :: void
-- Copies the filters from the source to the node
local function CopyNodeFilters(node, sourceNode)
    -- Get the handler for the source node
    local sHandler = RSE.NodeHandlersRegistry:GetNodeHandler(sourceNode)
    if (sHandler == nil) then
        -- No handler
        return
    elseif (not sHandler.IsFiltered(sourceNode, "item")) then
        -- Node isn't filtered
        return
    end
    
    -- Clear node filters
    node.RequestFilters = {}
    
    -- Get source filters
    local sFilters = sHandler.GetFilters(sourceNode, "item")
    if (sFilters == nil) then
        -- No filters set on source node
        return
    end
    
    -- Copy the filters
    for _, filter in pairs(sFilters) do
        table.insert(node.RequestFilters, {Item = filter.Item, Amount = filter.Amount, AmountMinForCall = filter.AmountMinForCall})
    end
end

-- SetFiltersFromRecipe( Node, LuaRecipe ) :: void
-- Sets the filters for the node based on the given recipe
local function SetFiltersFromRecipe(node, recipe)
    -- Clear node filters
    node.RequestFilters = {}
    for _, ingredient in ipairs(recipe.ingredients) do
        -- Only copy items
        if (ingredient.type == "item") then
            -- Add the item
            table.insert(node.RequestFilters, {Item = ingredient.name, Amount = ingredient.amount, AmountMinForCall = 1})
        end
    end
end

-- IsFiltered( Self, string ) :: bool
function InterfaceNodeHandlerConstructor:IsFiltered(type)
    return type == "item"
end

-- GetFilters( Self, string ) :: Array( { Item :: string, Amount: int } )
function InterfaceNodeHandlerConstructor:GetFilters(type)
    if (type == "item") then
        return self.RequestFilters
    end
    return nil
end



-- @See BaseNode:OnNetworkTick
-- Fills interface with filtered items, removes anything else
function InterfaceNodeHandlerConstructor:OnNetworkTick(network)
    -- Get the nodes inventory
    local inv = self.Entity.get_inventory(defines.inventory.chest)
    -- No work to perform?
    if (inv.is_empty() and next(self.RequestFilters) == nil) then
        return
    end
    ManagementOverFlowItem(inv,network,self)
    ManagementObjectTransfer(inv,network,self)
    
end

-- @See BaseNode:OnGetGuiHandler
function InterfaceNodeHandlerConstructor:OnGetGuiHandler(playerIndex)
    return RSE.GuiManager.Guis.InterfaceNodeGUI
end

-- @See BaseNode:OnPasteSettings
function InterfaceNodeHandlerConstructor:OnPasteSettings(sourceEntity)
    local otherNode = RSE.NetworksManager.GetNodeForEntity(sourceEntity)
    if (otherNode) then
        -- Network node
        CopyNodeFilters(self, otherNode)
    elseif (sourceEntity.get_recipe() ~= nil) then
        -- Crafting machine
        SetFiltersFromRecipe(self, sourceEntity.get_recipe())
    end
end

-- @See BaseNode:OnPasteSettingsWithNode( Self,  Node ) :: void
function InterfaceNodeHandlerConstructor:OnPasteSettingsWithNode(sourceNode)
    local otherNode = sourceNode
    if (otherNode) then
        -- Network node
        CopyNodeFilters(self, otherNode)
    end
end



-- @See BaseNode.NewNode
function InterfaceNodeHandlerConstructor.NewNode(entity)
    return InterfaceNodeHandlerConstructor.EnsureStructure(InterfaceNodeHandlerConstructor._super.NewNode(entity))
end

-- @See BaseNode:EnsureStructure
function InterfaceNodeHandlerConstructor:EnsureStructure()
    InterfaceNodeHandlerConstructor._super.EnsureStructure(self)
    -- Name of the handler that implements functionality
    self.HandlerName = InterfaceNodeHandler.HandlerName
    -- Map( FilterIndex :: int -> { Item :: string, Amount :: int } )
    -- Used by the GUI to display selected items
    self.RequestFilters = self.RequestFilters or {}
    
    return self
end
