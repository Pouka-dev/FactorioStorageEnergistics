SESettingsConstructor = newclass(Object, function(base, ...)
    Object.init(base, ...)
    base.NodeIdlePowerDrain = 5
    base.PowerPerItem = 1000
    base.PowerPerChunk = 50
    base.ReadOnlyStorageChest = true
    base.ModDifficulty = "Normal"
    base.EntitiesPerTickPerNetwork = 5
    base.NetworksPerTick = 10
end)


    -- Called to load or reload the mod settings
    function SESettingsConstructor:LoadSettings(event)
        -- Main
        local ModDifficulty = settings.startup["se-mod_difficulty"].value
        -- Global
        local NodeIdlePowerDrain = settings.global["se-power_drain_per_node_per_tick_in_watts"].value
        local PowerPerItem = settings.global["se-transfer_power_drain_per_item_in_watts"].value
        local PowerPerChunk = settings.global["se-transfer_power_drain_per_chunk_in_watts"].value
        local EntitiesPerTickPerNetwork = settings.global["se-entities_per_tick_per_network"].value
        local NetworksPerTick = settings.global["se-networks_per_tick"].value
        -- Player
        local ReadOnlyStorageChest = settings.player["se-read_only_storage"].value

        if event ~= nil then 
           local modSettings =  Player.load(event).getModSettings()

           if (event.setting_type == "runtime-per-user") then 
            for settings_name, settings in pairs(RSE.Constants.Settings.se_settings_mod) do
                if (settings.setting_type == "runtime-per-user" and "se-read_only_storage" == "se-"..settings_name) then 
                    ReadOnlyStorageChest =  modSettings["se-read_only_storage"].value
                end
            end
           end
        end
        -- Main
        self.ModDifficulty = ModDifficulty
        -- Global
        self.NodeIdlePowerDrain = NodeIdlePowerDrain
        self.PowerPerItem = PowerPerItem
        self.PowerPerChunk = PowerPerChunk
        self.EntitiesPerTickPerNetwork = EntitiesPerTickPerNetwork
        self.NetworksPerTick = NetworksPerTick
        -- Player
        self.ReadOnlyStorageChest = ReadOnlyStorageChest
    end

    


