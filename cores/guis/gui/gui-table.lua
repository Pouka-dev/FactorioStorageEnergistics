-------------------------------------------------------------------------------
-- Class to help to build GuiTable
--
-- @module GuiTable
--

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiTable] constructor
-- @param #arg name
-- @return #GuiTable
--
GuiTable = newclass(GuiElement,function(base,...)
    GuiElement.init(base,...)
    base.classname = "SEGuiTable"
    base.options.type = "table"
    base.options.style = RSE.Constants.Names.Styles.Tables.SETableDefault
  end)
  
  -------------------------------------------------------------------------------
  --
  -- @function [parent=#GuiTable] column
  -- @param #number column_count
  -- @return #GuiTable
  --
  function GuiTable:column(column_count)
    self.options.column_count = column_count
    return self
  end


