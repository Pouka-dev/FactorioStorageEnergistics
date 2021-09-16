-- Description: Provides helper function for interacting with a GUI

require "cores.lib.string-utils"

-- AddCountToSlot( LuaGuiElement ) :: void
-- Alright, this sucks, but I have yet to find a better way
-- to add the shadow to the count
function AddCountToSlot(slot, count)
  local countStr = (count and NumberToStringWithSuffix(count)) or ""

  -- Top-left shadow
  local tlShadow = GuiElement.add(slot, GuiLabel(RSE.Constants.Names.Gui.GUIHelper.TLShadow)
    :style(RSE.Constants.Names.Styles.Labels.SEElecticUsageLabelTL):ignored_by_interaction(true):caption(countStr))
    
  -- Bottom-right shadow
  local brShadow = GuiElement.add(slot, GuiLabel(RSE.Constants.Names.Gui.GUIHelper.BRShadow)
    :style(RSE.Constants.Names.Styles.Labels.SEElecticUsageLabelBR):ignored_by_interaction(true):caption(countStr))

  -- Foreground
  local numLabel = GuiElement.add(slot, GuiLabel(RSE.Constants.Names.Gui.GUIHelper.Count)
    :style(RSE.Constants.Names.Styles.Labels.SEElecticUsageLabelCount):ignored_by_interaction(true):caption(countStr))

  return {TLS = tlShadow, BRS = brShadow, Label = numLabel}
end

function UpdateSlotCount(slot, count)
  local countStr = (count and NumberToStringWithSuffix(count)) or ""
  slot[RSE.Constants.Names.Gui.GUIHelper.Count].caption = countStr
  slot[RSE.Constants.Names.Gui.GUIHelper.BRShadow].caption = countStr
  slot[RSE.Constants.Names.Gui.GUIHelper.TLShadow].caption = countStr
end
