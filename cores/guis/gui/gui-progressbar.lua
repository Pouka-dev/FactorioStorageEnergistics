-------------------------------------------------------------------------------
-- Class to help to build GuiProgressBar
--
-- @module GuiProgressBar
--

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiProgressBar] constructor
-- @param #arg name
-- @return #GuiProgressBar
--
GuiProgressBar = newclass(GuiElement,function(base,...)
  GuiElement.init(base,...)
  base.classname = "SEGuiProgressBar"
  base.options.type = "progressbar"
  base.options.style = RSE.Constants.Names.Styles.Progressbars.SEProgressbarDefault
  base.options.tooltip = ""
end)

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiProgressBar] wordWrap
-- @param #boolean wrap
-- @return #GuiProgressBar
--
function GuiProgressBar:size(size)
  self.options.size = size
  return self
end

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiProgressBar] wordWrap
-- @param #boolean wrap
-- @return #GuiProgressBar
--
function GuiProgressBar:value(value)
  self.options.value = value
  return self
end