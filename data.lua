-- Description: Data inclusions

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
require('prototypes.entities.se-provider-chest')
require('prototypes.entities.se-requester-chest')
require('prototypes.entities.storage-chest-mk1')
require('prototypes.entities.storage-chest-mk2')

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



