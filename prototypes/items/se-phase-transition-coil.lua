local isNormalMode = settings.startup["se-mod_difficulty"].value == "Normal"

local ingredients
if(isNormalMode) then
    ingredients = 
    {
        { Constants.Names.Proto.PetroQuartz.Item, 10 },
        { "iron-plate", 5 },
        { "copper-cable", 5 },
        { "electronic-circuit", 25 }
    }
else
    ingredients = 
    {
        { Constants.Names.Proto.PetroQuartz.Item, 1 },
        { "iron-plate", 4 },
        { "copper-cable", 4 },
        { "electronic-circuit", 5 }
    }
end

--- ITEM ---
local sePhaseTransitionCoilI = {}

sePhaseTransitionCoilI.type = "item"
sePhaseTransitionCoilI.name = Constants.Names.Proto.PhaseCoil.Item
sePhaseTransitionCoilI.icon = Constants.DataPaths.Icons .. "se-phase-transition-coil.png"
sePhaseTransitionCoilI.icon_size = 32
sePhaseTransitionCoilI.flags = {}
sePhaseTransitionCoilI.subgroup = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Items
sePhaseTransitionCoilI.order = "c"
sePhaseTransitionCoilI.stack_size = 50

--- RECIPE ---
local sePhaseTransitionCoilIR = {}

sePhaseTransitionCoilIR.type = "recipe"
sePhaseTransitionCoilIR.name = Constants.Names.Proto.PhaseCoil.Recipe
sePhaseTransitionCoilIR.enabled = false
sePhaseTransitionCoilIR.energy_required = 6
sePhaseTransitionCoilIR.ingredients = ingredients
sePhaseTransitionCoilIR.result = Constants.Names.Proto.PhaseCoil.Item
sePhaseTransitionCoilIR.subgroup = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Items
sePhaseTransitionCoilIR.order = Constants.Names.Proto.PhaseCoil.Recipe

--- IMPORT se-phase-transition-coil ---
data:extend { sePhaseTransitionCoilI }
data:extend { sePhaseTransitionCoilIR }

