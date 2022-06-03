function CanExtractWithCurrentPower(network, request)
    
    local canExtract = false
    
    -- Phase 1, Calculate power sum and visit nodes
    local networkSources = {}
    
    local totalPowerInNetwork = FindNecessaryEnergyInPowerSources(network, request, networkSources)
    
    -- Is there less power in the network than in the request?
    if (request.WattsRemaining >= totalPowerInNetwork) then
        ---RSE.Logger.Trace("Extracting all power from network. " .. tostring(totalPowerInNetwork))
        -- Drain this entire network of power
        request.WattsRemaining = request.WattsRemaining - totalPowerInNetwork
    else
        -- Phase 2, Calculate extract amounts
        CalculateExtractAmounts(request, networkSources, totalPowerInNetwork)
        
        -- Was anything left over? (rounding errors)
        if (request.WattsRemaining > 0) then
            ---RSE.Logger.Trace("Locating the last " .. tostring(request.WattsRemaining))
            -- Phase 3, find any node with power left to take
            PowerLeftTake(request, networkSources)
        end
        
        -- Sanity check
        if (request.WattsRemaining > 0) then
            RSE.Logger.Flush()
            error("Unfinished power request when network had enough power: (" .. tostring(totalPowerInNetwork) .. ", " .. tostring(request.RequestedWatts) .. ")")
        end
        
        -- Request fully satisfied
        ---RSE.Logger.Trace("End Network Power Request. Fully satisfied.\n")
        return true
    end -- End request.WattsRemaining >= totalPowerInNetwork
    return canExtract
end


-- Phase 1, Calculate power sum and visit nodes
function FindNecessaryEnergyInPowerSources(network, request, networkSources)
    local wattsRemaining = request.WattsRemaining
    local totalPowerInNetwork = 0
    -- sort powerSourceNode with the highest power energy in top of list
    --local sorter = function(t, a, b) return t[a].StoredPower(a) > t[b].StoredPower(b) end
    for node, handler in pairs(network.PowerSourceNodes) do
        -- Is the node valid, and unvisitied?
        if (handler.Valid(node) and request.VisitedNodes[node] == nil) then
            -- Get stored power amount
            local nodeStored = handler.StoredPower(node)
            
            -- Add to total
            totalPowerInNetwork = totalPowerInNetwork + nodeStored
            
            -- Add to maps
            local source = {
                Node = node,
                Handler = handler,
                Stored = nodeStored,
                Extract = nodeStored -- Note: This assume worst case that request amount >= total network amount
            }
            if (nodeStored > 0) then
                -- Don't bother doing phase 2+ with fully drained nodes
                networkSources[#networkSources + 1] = source
            end
            request.VisitedNodes[node] = source
        end
        if totalPowerInNetwork >= wattsRemaining then break end
    end
    return totalPowerInNetwork
end

-- Phase 2, Calculate extract amounts
function CalculateExtractAmounts(request, networkSources, totalPowerInNetwork)
    local totalExtractionAmount = 0
    local nodeWeight = 0
    for idx, source in ipairs(networkSources) do
        -- Calculate the nodes contribution weight
        nodeWeight = source.Stored / totalPowerInNetwork
        
        -- Calculate extraction amount with rounding
        source.Extract = math.min(source.Stored, math.floor(0.5 + (nodeWeight * request.WattsRemaining)))
        
        -- Add to sum
        totalExtractionAmount = totalExtractionAmount + source.Extract
    
    ---RSE.Logger.Trace("-- Source Node Found. Stored: " .. tostring(source.Stored) .. ", Weight: " .. tostring(nodeWeight) .. ", Extract: " .. tostring(source.Extract))
    end
    
    -- Adjust remaining watts
    request.WattsRemaining = request.WattsRemaining - totalExtractionAmount
end

-- Phase 3, find any node with power left to take
function PowerLeftTake(request, networkSources)
    for idx, source in ipairs(networkSources) do
        if (source.Extract < source.Stored) then
            local extraExtract = math.min(request.WattsRemaining, source.Stored - source.Extract)
            source.Extract = source.Extract + extraExtract
            request.WattsRemaining = request.WattsRemaining - extraExtract
            
            -- Done?
            if (request.WattsRemaining == 0) then
                -- Stop phase 3
                break
            end
        end
    end
end
