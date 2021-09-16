

function ManagementOverFlowItem(nodeHandlerInventoryEntity, network, nodeHandler)
    local existing = nodeHandlerInventoryEntity.get_contents()

    local bb = function(_, filter)
        return (existing[filter.Item] ~= nil and existing[filter.Item] > filter.Amount)
    end
    ---- Get true amount
    ---- diff with current storage
    for _, filter in fpairs(nodeHandler.RequestFilters, bb) do
        -- Create a simple stack
        local stack = {name = filter.Item, count =  existing[filter.Item] - filter.Amount}
        local insertedAmount = RSE.NetworkHandler.InsertItems(network, stack, nodeHandler)
        if (insertedAmount > 0) then
            -- Remove inserted amount from inventory
            stack.count = insertedAmount
            nodeHandlerInventoryEntity.remove(stack)
        end
    end
end


function ManagementObjectTransfer(nodeHandlerInventoryEntity, network, nodeHandler)
    local existing = nodeHandlerInventoryEntity.get_contents()
    
    -- Get what is stored in the inventory
    local aa = function(_, filter)
        if (filter.AmountMinForCall == nil or filter.AmountMinForCall == 0) then filter.AmountMinForCall = math.ceil(math.abs(filter.Amount * 20 / 100)) end
        return (existing[filter.Item] == nil or (existing[filter.Item] ~= nil and existing[filter.Item] <= filter.AmountMinForCall))
    end
    -- Assume all filters are to be fully requested
    for _, filter in fpairs(nodeHandler.RequestFilters, aa) do
        if  (filter.Amount - (existing[filter.Item] or 0)) > 0 then 
            local stack = {name = filter.Item, count = filter.Amount - (existing[filter.Item] or 0)}
            -- Perform a fake insert to get how many can be inserted
            local canBeInserted = nodeHandlerInventoryEntity.insert(stack)
            if (canBeInserted > 0) then
                stack.count = canBeInserted
                -- Remove fake insert
                nodeHandlerInventoryEntity.remove(stack)
                -- Attempt network extraction
                local extractedAmount = RSE.NetworkHandler.ExtractItems(network, stack, nodeHandler)
                if (extractedAmount > 0) then
                    -- Add to inventory
                    stack.count = extractedAmount
                    nodeHandlerInventoryEntity.insert(stack)
                end
            --else
            end -- end canBeInserted
        end
    end --end
end