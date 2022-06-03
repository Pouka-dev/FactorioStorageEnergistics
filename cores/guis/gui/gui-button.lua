-------------------------------------------------------------------------------
-- Class to help to build GuiButton
--
-- @module GuiButton
--

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiButton] constructor
-- @param #arg name
-- @return #GuiButton
--
GuiButton = newclass(GuiElement,function(base,...)
  GuiElement.init(base,...)
  base.classname = "SEGuiButton"
  base.options.type = "button"
end)


GuiButtonChoose = newclass(GuiElement,function(base,...)
  GuiElement.init(base,...)
  base.classname = "SEGuiButton"
  base.options.type = "choose-elem-button"
end)

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiButton] option
-- @param #string name
-- @param #string value
-- @return #GuiButton
--
function GuiButton:option(name, value)
  self.options[name] = value
end

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiButton] index
-- @param #number index
-- @return #GuiButton
--
function GuiButton:index(index)
  self.m_index = index
  return self
end

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiButton] number
-- @param #number value
-- @return #GuiButton
--
function GuiButton:number(value)
  self.options.number = value
  return self
end

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiButton] choose
-- @param #string type
-- @param #string name
-- @return #GuiButton
--
function GuiButton:choose(type, name)
  self.options.type = "choose-elem-button"
  --self.options.style = "slot_button"
  if type ==  "recipe-burnt" then type = "recipe" end
  if type ==  "resource" then type = "entity" end
  if type ==  "rocket" then type = "item" end
  self.options.elem_type = type
  self.options[type] = name
  --- table.insert(self.name, name)
  return self
end

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiButton] onErrorOptions
-- @return #table
--
function GuiButton:onErrorOptions()
  local options = self:getOptions()
  --- options.style = "helmod_button_default"
  options.type = "button"
  if (type(options.caption) == "boolean") then
    RSE.Logger.Error(self.classname .. " : addGuiButton - caption is a boolean")
  elseif self.m_caption ~= nil then
    options.caption = self.m_caption
  else
    options.caption = options.key
  end
  return options
end