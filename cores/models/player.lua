---
-- Description of the module.
-- @module Player
--
Player = {
  -- single-line comment
  classname = "SEPlayer"
}

local cur_player = nil;
local cur_tick = 0

-------------------------------------------------------------------------------
-- Load factorio player
--
-- @function [parent=#Player] load
--
-- @param #LuaEvent event
--
-- @return #Player
--
function Player.load(event)
  cur_player = game.players[event.player_index]
  cur_tick = event.tick
  return Player
end

-------------------------------------------------------------------------------
-- Return factorio player
--
-- @function [parent=#Player] get current player
--
-- @return #Lua_player
--
function Player.get()
  return cur_player
end


-------------------------------------------------------------------------------
-- Return factorio player
--
-- @function [parent=#Player] get mod settings
--
-- @return #Lua_player
--
function Player.getModSettings()
  return cur_player.mod_settings
end

-------------------------------------------------------------------------------
-- Return factorio tick
--
-- @function [parent=#Player] get current tick
--
-- @return tick
--
function Player.get_tick()
  return cur_tick
end

-------------------------------------------------------------------------------
-- Print message
--
-- @function [parent=#Player] print
--
-- @param #arg message
--
function Player.print(...)
  if cur_player ~= nil then
    cur_player.print(table.concat({...}," "))
  end
end




-------------------------------------------------------------------------------
-- Set factorio player
--
-- @function [parent=#Player] set
--
-- @param #LuaPlayer player
--
-- @return #Player
--
function Player.set(player)
  cur_player = player
  return Player
end

-------------------------------------------------------------------------------
-- Set factorio player
--
-- @function [parent=#Player] setByIndex
--
-- @param #LuaPlayer number
--
-- @return #Player
--
function Player.setByIndex(index)
  cur_player = game.players[index]
  return Player
end


-------------------------------------------------------------------------------
-- Return admin player
--
-- @function [parent=#Player] isAdmin
--
-- @return #boolean
--
function Player.isAdmin()
  if cur_player == nil then
    SE.Logger.Error("Error in function Player.isAdmin: Lua_player == nil")
    return false
  end
  return cur_player.admin
end

-------------------------------------------------------------------------------
-- Get gui
--
-- @function [parent=#Player] getGui
--
-- @param location
--
-- @return #LuaGuiElement
--
function Player.getGui(location)
  return cur_player.gui[location]
end

-------------------------------------------------------------------------------
-- Return force's player
--
-- @function [parent=#Player] getForce
--
--
-- @return #table force
--
function Player.getForce()
  return cur_player.force
end



-------------------------------------------------------------------------------
-- Get game day
--
-- @function [parent=#Player] getGameDay
--
function Player.getGameDay()
  local surface = game.surfaces[1]
  local day = surface.ticks_per_day
  local dusk = surface.evening-surface.dusk
  local night = surface.morning-surface.evening
  local dawn = surface.dawn-surface.morning
  return day, day*dusk, day*night, day*dawn
end


