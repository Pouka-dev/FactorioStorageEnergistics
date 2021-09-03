return function()
    SESettings = {
        NodeIdlePowerDrain = 5,
        PowerPerItem = 1000,
        PowerPerChunk = 50,
        TickRate = 30,
        ReadOnlyStorageChest = true,
    }

    -- Called to load or reload the mod settings
    function SESettings.LoadSettings(event)

        local NodeIdlePowerDrain = settings.global["se-power_drain_per_node_per_tick_in_watts"].value
        local PowerPerItem = settings.global["se-transfer_power_drain_per_item_in_watts"].value
        local PowerPerChunk = settings.global["se-transfer_power_drain_per_chunk_in_watts"].value
        local TickRate = settings.global["se-game_ticks_per_network_tick"].value
        local ReadOnlyStorageChest = settings.player["se-read_only_storage"].value

        if event ~= nil then 
           local modSettings =  Player.load(event).getModSettings()

           if (event.setting_type == "runtime-per-user") then 
            for settings_name, settings in pairs(Constants.Settings.se_settings_mod) do
                if (settings.setting_type == "runtime-per-user" and "se-read_only_storage" == "se-"..settings_name) then 
                    ReadOnlyStorageChest =  modSettings["se-read_only_storage"].value
                end
            end
           end
        end

        SESettings.NodeIdlePowerDrain = NodeIdlePowerDrain
        SESettings.PowerPerItem = PowerPerItem
        SESettings.PowerPerChunk = PowerPerChunk
        SESettings.TickRate = TickRate
        SESettings.ReadOnlyStorageChest = ReadOnlyStorageChest
    end

    -- Load the settings upon creation
    SESettings.LoadSettings()

    return SESettings
end
