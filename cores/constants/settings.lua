

local Settings = {}
Settings = {
    se_settings_mod = {
        -- Main
        mod_difficulty = {
            type = "string-setting",
            setting_type = "startup",
            localised_name = {"se_startup_settings.se-mod_difficulty"},
            localised_description = {"se_startup_settings_descriptions.se-mod_difficulty"},
            default_value = "Normal",
            allowed_values = {"Normal","Easy"},
            order = "a-a"
        },
        -- Global
        power_drain_per_node_per_tick_in_watts = {
            type = "int-setting",
            setting_type = "runtime-global",
            localised_name = {"se_global_settings.se-power-drain-per-node-per-tick-in-watts"},
            default_value = 5,
            minimum_value = 1,
            allow_blank = false,
            order = "a-a"
        }, 
        transfer_power_drain_per_item_in_watts = {
            type = "int-setting",
            setting_type = "runtime-global",
            localised_name = {"se_global_settings.se-transfer-power-drain-per-item-in-watts"},
            default_value = 1000,
            minimum_value = 1,
            order = "a-b"
        },
        transfer_power_drain_per_chunk_in_watts = {
            type = "int-setting",
            setting_type = "runtime-global",
            localised_name = {"se_global_settings.se-transfer-power-drain-per-chunk-in-watts"},
            default_value = 50,
            minimum_value = 1,
            order = "a-c"
        },
        game_ticks_per_network_tick = {
            type = "int-setting",
            setting_type = "runtime-global",
            localised_name = {"se_global_settings.se-game-ticks-per-network-tick"},
            localised_description = {"se_global_settings_descriptions.se-game-ticks-per-network-tick"},
            default_value = 42,
            minimum_value = 25,
            order = "a-d"
        },
        -- Player
        read_only_storage = {
            type = "bool-setting",
            setting_type = "runtime-per-user",
            localised_name = {"se_user_settings.se-read-only-storage"},
            default_value = true,
            order = "a-a"
        }
    }
}


return Settings