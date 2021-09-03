--- RECIPE ---
local seChestMk1UpgradeR = {}

seChestMk1UpgradeR.type = "recipe"
seChestMk1UpgradeR.name = Constants.Names.Proto.StorageChestMk1.Recipe .. "-upgrade"
seChestMk1UpgradeR.enabled = false
seChestMk1UpgradeR.energy_required = 2
seChestMk1UpgradeR.ingredients = {
    { Constants.Names.Proto.StorageChestMk1.Item, 1 },
    { Constants.Names.Proto.PatternBuffer.Item, 1 }
}
seChestMk1UpgradeR.main_product = ""
seChestMk1UpgradeR.icon = Constants.DataPaths.Icons .. "se-chest-mk1-upgrade.png"
seChestMk1UpgradeR.icon_size = 32
seChestMk1UpgradeR.results = {
    { type = "item", name = Constants.Names.Proto.StorageChestMk2.Item, amount = 1 }
}
seChestMk1UpgradeR.subgroup = Constants.Strings.ItemGroups.StorageEnergistics.SubGroups.Items
seChestMk1UpgradeR.order = Constants.Names.Proto.StorageChestMk1.Recipe .. "-upgrade"

--- IMPORT se-chest-mk1-upgrade ---
data:extend { seChestMk1UpgradeR }



