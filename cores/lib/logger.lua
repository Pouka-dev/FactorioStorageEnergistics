-- Description: Provides logging for the mod
-- Singleton

-- Define the logger function
-- This will append the message to the log file
-- Use: `serpent.block(table_name)` to log a table.
    local RSELogger = {
        classname = "RSELogger",
        EnableTrace = false,
        EnableLogging = false
    }

    -- Queue is used to hold logged data prior to the game object being available
    -- Each new invocation of the logger will start a new section in the log
    local queued = {
        [1] = ":: Starting Log ::\n"
    }

    -- Creates a new log each time a game starts.
    local appendLog = false

    local function log(level, message)
        if RSELogger.EnableLogging == false then
            return
        end

        local tick = -1
        if game ~= nil then
            tick = game.tick
        end

        -- Queue the message
        queued[#queued + 1] = "[" .. tick .. "]" .. "[DARK:Storage Energistics]" .. "[" .. level .. "] " .. message .. "\n"
        RSELogger.Flush()
    end

    function RSELogger.Trace(msg)
        if RSELogger.EnableTrace then
            log("TRCE", msg)
        end
    end

    function RSELogger.Info(msg)
        log("INFO", msg)
    end

    function RSELogger.Warning(msg)
        log("WARN", msg)
    end

    function RSELogger.Error(msg)
        log("EROR", msg)
    end

    local FlushRate = 180
    local TickCounter = FlushRate

    -- Flushes the log to disk ASAP
    function RSELogger.Flush()
        if (#queued == 0 or RSELogger.EnableLogging == false) then
            return
        end
        if (game == nil) then
            TickCounter = 0
            return
        end
        -- Log file can be found in the script-output folder
        -- Windows: %appdata%\Factorio\script-output
        game.write_file("logs/storage-energistics.log",
                table.concat(queued),
                appendLog
        )
        queued = {}
        -- Append from now on
        appendLog = true
    end

    function RSELogger.Tick()
        if TickCounter > 0 then
            TickCounter = TickCounter - 1
            return
        end
        TickCounter = FlushRate
        RSELogger.Flush()
    end

    return RSELogger

