-- Description: Data inclusions
normalChest = circuit_connector_definitions["chest"]
largeChest = circuit_connector_definitions.create
(
  universal_connector_template,
  {
    
    { variation = 26, main_offset = util.by_pixel(30, 30), shadow_offset = util.by_pixel(22.5, 30), show_shadow = true }
  }
)

warehousingChest = circuit_connector_definitions.create
(
  universal_connector_template,
  {
    
    { variation = 26, main_offset = util.by_pixel(80, 80), shadow_offset = util.by_pixel(67.5, 90), show_shadow = true }
  }
)

--- Constants
Constants = require ('cores.constants.constants')
--- Groups
require('prototypes.item-groups')
--- Items
require('prototypes.items.se-pattern-buffer')
require('prototypes.items.se-phase-transition-coil')
require('prototypes.items.se-pretoleum-quartz')
require('prototypes.items.se-storage-chest-mk1-upgrade')
--- Technologies
require('prototypes.technologies.technologies')
--- Entities
require('prototypes.entities.se-controller')
require('prototypes.entities.se-energy-acceptor')

require('prototypes.entities.se-interface-chest')
require('prototypes.entities.storage-chest')

require('prototypes.entities.se-provider-chest')
require('prototypes.entities.se-requester-chest')

--- Styles
require("prototypes.styles")

--- Custom-Input ---
data:extend {
    {
        type = "custom-input",
        name = Constants.Names.Controls.StorageNetworkGui,
        key_sequence = "N",
        consuming = "none"
    }
}



