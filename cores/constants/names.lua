---- Names
local function GenNames(name, hasEntity, order)
    local names = {
        ID = name,
        Item = "item-" .. order .. name,
        Recipe = "recipe-" .. name
    }
    if (hasEntity) then
        names.Entity = "entity-" .. name
    end
    return names
end

-- What things are called
local Names = {}

-- Prototype names
Names.Proto = {}

Names.Proto.PetroQuartz = GenNames("se-petroleum-quartz", false, "")
Names.Proto.PhaseCoil = GenNames("se-phase-transition-coil", false, "")
Names.Proto.PatternBuffer = GenNames("se-pattern-buffer", false, "")

Names.Proto.Controller = GenNames("se-controller", true, "")
Names.Proto.EnergyAcceptor = GenNames("se-energy-acceptor", true, "")

Names.Proto.StorageChestMk1 = GenNames("se-chest-mk1", true,"1")
Names.Proto.StorageChestLargeMk1 = GenNames("se-chest-large-mk1", true, "2")
Names.Proto.StorageChestWarehousingMk1 = GenNames("se-chest-warehousing-mk1", true,"3")

Names.Proto.StorageChestMk2 = GenNames("se-chest-mk2", true,"4")
Names.Proto.StorageChestLargeMk2 = GenNames("se-chest-large-mk2", true,"5")
Names.Proto.StorageChestWarehousingMk2 = GenNames("se-chest-warehousing-mk2", true,"6")

Names.Proto.InterfaceChest = GenNames("se-interface-chest", true, "")
Names.Proto.InterfaceChestLarge = GenNames("se-interface-chest-large", true, "")
Names.Proto.InterfaceChestWarehousing = GenNames("se-interface-chest-warehousing", true, "")


Names.Proto.ProviderChest = GenNames("se-provider-chest", true, "")
Names.Proto.RequesterChest = GenNames("se-requester-chest", true, "")

-- Technology names
Names.Tech = {}
Names.Tech.StorageNetwork = "research-se-storage-network"
Names.Tech.HighCapacity = "research-se-high-capacity"
Names.Tech.Logistics = "research-se-storage-logistics"

-- Control Names
Names.Controls = {
    StorageNetworkGui = "toggle-storage-network-gui"
}

-- Handlers
Names.NodeHandlers = {
    Base = "BaseNodeHandler",
    Controller = "ControllerNodeHandler",
    EnergyAcceptor = "EnergyAcceptorNodeHandler",
    Storage = "StorageNodeHandler",
    Interface = "InterfaceNodeHandler"
}

---
Names.Styles = {}
Names.Styles.Frames = {
    SEFrameDefault = "se_frame_default"
}
Names.Styles.Labels = {
    SEItemTableItemLabel = "se_item_table_item_label",
    SEElecticUsageLabelTL = "se_electric_usage_label_tl",
    SEElecticUsageLabelBR = "se_electric_usage_label_br",
    SEElecticUsageLabelCount = "se_electric_usage_label_count"
}
Names.Styles.Progressbars = {
    SEProgressbarDefault = "se_progressbar_default",
    SEProgressbarHorizontalLine = "se_horizontal_line"
}
Names.Styles.Sliders = {
    SELogisticsSlider = "se_logistics_slider"
}
Names.Styles.Tables = {
    SETableDefault = "se_table_default",
    SETableNetworkOverviewHeader = "se_table_network_overview_header",
    SETableNetworkOverviewFooter = "se_table_network_overview_footer",
}
Names.Styles.Textfields = {
    SELogisticsTextfield = "se_logistics_textfield"
    
}
Names.Styles.Scrolls = {
    SEScrollDefault = "se_scroll_default"
    
}
Names.Styles.Flows = {
    SEFlowDefault = "se_flow_default",
    SEFlowItemCell = "se_flow_item_cell",
    SEFlowHorizontal = "se_flow_horizontal",
    SEFlowVertical = "se_flow_vertical",
    
}

-- Gui Names
Names.Gui = {
    GUIHelper = {
        TLShadow = "se_gui_network_count_tl_shadow",
        BRShadow = "se_gui_network_count_br_shadow",
        Count = "se_gui_network_count"
      },
    NetworkOverview = {
        FrameRoot = "center",
        Name = "se_gui_network_overview",
        Contents = "se_gui_network_overview_contents",
        Header = "se_gui_network_overview_header",
        Dropdown = "se_gui_network_overview_pick_network",
        ProgressBar = "se_gui_network_overview_progressbar",
        HeaderHorizontalLine = "se_gui_network_overview_header_horizontal_line",
        ScrollWrapper = "se_gui_network_overview_scroll_wrapper",
        ItemTable = "se_gui_network_overview_item_table",
        Footer = "se_gui_network_overview_footer",
        FooterHorizontalLine = "se_gui_network_overview_footer_horizontal_line",
        Close = "se_gui_network_overview_close",
        ItemCell = "se_gui_network_overview_item_cell",
        ItemCellTooltip =  "<Warning: Unused Item Cell>",
        ItemCellChooseElemButton = "se_gui_network_overview_item_cell_choose_elem_button",
        ItemCellItemLabel = "se_gui_network_overview_item_cell_item_label",

    },
    Interface = {
        Name = "se_gui_interface_frame",
        FrameRoot = "left",
        ItemSelectionElement = "se_pick_item:"
    },
    StorageChest = {
        Name = "se_gui_chest_frame",
        FrameRoot = "left",
        ReadOnlyCheckbox = "se_mode_readonly"
    }
}

return Names

