-------------------------------------------------------------------------------
-- Class to help to build GuiScroll
--
-- @module GuiScroll
--

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiScroll] constructor
-- @param #arg name
-- @return #GuiScroll
--
GuiScroll = newclass(GuiElement,function(base,...)
  GuiElement.init(base,...)
  base.classname = "SEGuiScroll"
  base.options.type = "scroll-pane"
  base.options.style = RSE.Constants.Names.Styles.Scrolls.SEScrollDefault
end)

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiScroll] policy
-- @param #string policy scroll horizontally
-- @return #GuiScroll
--
function GuiScroll:policy(policy)
  self.options.horizontal_scroll_policy = policy
  return self
end