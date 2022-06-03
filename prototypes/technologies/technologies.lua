local isNormalMode = settings.startup["se-mod_difficulty"].value == "Normal"

local SEStorageNetwork = {}
local SEHighCapacity = {}
local SEStorageLogistics = {}
if (isNormalMode) then
    
    --------------- Conditionnal storage network (base) ---------------
    SEStorageNetwork.prerequisites =
        {
            "logistic-science-pack",
            "chemical-science-pack",
            "production-science-pack",
            "utility-science-pack",
            "advanced-electronics-2",
            "battery"
        }
    
    SEStorageNetwork.ingredients =
        {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 1},
            {"utility-science-pack", 2}
        }
    
    --------------- Conditionnal technology high-capacity ---------------
    SEHighCapacity.prerequisites =
        {
            "logistic-science-pack",
            "chemical-science-pack",
            "utility-science-pack",
            Constants.Names.Tech.StorageNetwork
        }
    
    SEHighCapacity.ingredients =
        {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"utility-science-pack", 2}
        }

        --------------- Conditionnal technology storage logistics ---------------

        SEStorageLogistics.prerequisites = 
        {
            Constants.Names.Tech.StorageNetwork,
            "logistic-science-pack",
            "chemical-science-pack",
            "utility-science-pack",
            "logistic-system"
        }

        SEStorageLogistics.ingredients =
        {
            {"automation-science-pack", 4},
            {"logistic-science-pack", 4},
            {"chemical-science-pack", 4},
            {"utility-science-pack", 1}
        }

else
    --------------- Conditionnal storage network (base) ---------------
    SEStorageNetwork.prerequisites = {}
    SEStorageNetwork.ingredients =
        {
            {"automation-science-pack", 1}
        }
    
    --------------- Conditionnal technology high-capacity ---------------
    SEHighCapacity.prerequisites = {}
    
    SEHighCapacity.ingredients =
        {
            {"automation-science-pack", 1}
        }

        --------------- Conditionnal technology storage logistics ---------------

        SEStorageLogistics.prerequisites = 
        {
            Constants.Names.Tech.StorageNetwork,
            "logistic-science-pack",
            "logistic-robotics"
        }

        SEStorageLogistics.ingredients =
        {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1}
        }
end


--------------- technology storage network (base) ---------------
local researchSEStorageNetwork = {}

researchSEStorageNetwork.type = "technology"
researchSEStorageNetwork.name = Constants.Names.Tech.StorageNetwork
researchSEStorageNetwork.icon = Constants.DataPaths.TechGFX .. "storage-network.png"
researchSEStorageNetwork.icon_size = 128
researchSEStorageNetwork.order = "a-a"
researchSEStorageNetwork.prerequisites = SEStorageNetwork.prerequisites
researchSEStorageNetwork.effects = {
    {type = "unlock-recipe", recipe = Constants.Names.Proto.PetroQuartz.Recipe},
    {type = "unlock-recipe", recipe = Constants.Names.Proto.PhaseCoil.Recipe},
    {type = "unlock-recipe", recipe = Constants.Names.Proto.Controller.Recipe},
    {type = "unlock-recipe", recipe = Constants.Names.Proto.EnergyAcceptor.Recipe},

    {type = "unlock-recipe", recipe = Constants.Names.Proto.StorageChestMk1.Recipe},
    {type = "unlock-recipe", recipe = Constants.Names.Proto.StorageChestLargeMk1.Recipe},
    {type = "unlock-recipe", recipe = Constants.Names.Proto.StorageChestWarehousingMk1.Recipe},

    {type = "unlock-recipe", recipe = Constants.Names.Proto.InterfaceChest.Recipe},
    {type = "unlock-recipe", recipe = Constants.Names.Proto.InterfaceChestLarge.Recipe},
    {type = "unlock-recipe", recipe = Constants.Names.Proto.InterfaceChestWarehousing.Recipe}
}
researchSEStorageNetwork.unit = {
    count = 10,
    ingredients = SEStorageNetwork.ingredients,
    time = 30
}

data:extend{researchSEStorageNetwork}

--------------- technology high-capacity ---------------
local researchSEHighCapacity = {}

researchSEHighCapacity.type = "technology"
researchSEHighCapacity.name = Constants.Names.Tech.HighCapacity
researchSEHighCapacity.icon = Constants.DataPaths.TechGFX .. "high-capacity.png"
researchSEHighCapacity.icon_size = 128
researchSEHighCapacity.prerequisites = SEHighCapacity.prerequisites
researchSEHighCapacity.effects = {
    {type = "unlock-recipe", recipe = Constants.Names.Proto.PatternBuffer.Recipe},
    {type = "unlock-recipe", recipe = Constants.Names.Proto.StorageChestMk2.Recipe},
    {type = "unlock-recipe", recipe = Constants.Names.Proto.StorageChestMk1.Recipe .. "-upgrade"},

    {type = "unlock-recipe", recipe = Constants.Names.Proto.StorageChestLargeMk2.Recipe},
    {type = "unlock-recipe", recipe = Constants.Names.Proto.StorageChestWarehousingMk2.Recipe},
}
researchSEHighCapacity.unit = {
    count = 10,
    ingredients = SEHighCapacity.ingredients,
    time = 30
}
researchSEHighCapacity.order = "a-b"

data:extend{researchSEHighCapacity}

--------------- technology storage logistics ---------------
local researchSEStorageLogistics = {}

researchSEStorageLogistics.type = "technology"
researchSEStorageLogistics.name = Constants.Names.Tech.Logistics
researchSEStorageLogistics.icon = Constants.DataPaths.TechGFX .. "storage-logistics.png"
researchSEStorageLogistics.icon_size = 128
researchSEStorageLogistics.prerequisites = SEStorageLogistics.prerequisites
researchSEStorageLogistics.effects = {
    {type = "unlock-recipe", recipe = Constants.Names.Proto.ProviderChest.Recipe},
    {type = "unlock-recipe", recipe = Constants.Names.Proto.RequesterChest.Recipe}
}
researchSEStorageLogistics.unit = {
    count = 10,
    ingredients = SEStorageLogistics.ingredients,
    time = 30
}

data:extend{researchSEStorageLogistics}


--------------- technology storage network (upgrade) ---------------
local researchSEStorageNetworkUpgradeTier1 = {}

researchSEStorageNetworkUpgradeTier1.type = "technology"
researchSEStorageNetworkUpgradeTier1.name = Constants.Names.Tech.StorageNetwork .. "upgrade"
researchSEStorageNetworkUpgradeTier1.icon = Constants.DataPaths.TechGFX .. "storage-network.png"
researchSEStorageNetworkUpgradeTier1.icon_size = 128
researchSEStorageNetworkUpgradeTier1.order = "a-a"
researchSEStorageNetworkUpgradeTier1.prerequisites = SEStorageNetwork.prerequisites
researchSEStorageNetworkUpgradeTier1.effects = { 
    {type = "unlock-recipe", recipe = Constants.Names.Proto.StorageChestLargeMk1.Recipe},
    {type = "unlock-recipe", recipe = Constants.Names.Proto.InterfaceChestLarge.Recipe}
}
researchSEStorageNetworkUpgradeTier1.unit = {
    count = 10,
    ingredients = SEStorageNetwork.ingredients,
    time = 30
}

data:extend{researchSEStorageNetworkUpgradeTier1}
