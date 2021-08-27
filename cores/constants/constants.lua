

return function()
    -- What things are called
    local Names = require("cores.constants.names")

    -- Where things are at
    local Paths = require("cores.constants.paths")

    -- Misc strings
    local Strings = require("cores.constants.strings")

    -- Kinds of nodes
    local NodeTypes = require("cores.constants.node-types")

    -- Variables
    local Variables = require("cores.constants.variables")

    Constants = {
        Names = Names,
        Strings = Strings,
        DataPaths = Paths,
        NodeTypes = NodeTypes,
        Variables = Variables
    }
    return Constants
end