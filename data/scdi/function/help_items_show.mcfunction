# lists any admin-added custom items too (see /function scdi:menu/items) -
# read-only version of the same recursive walk the admin menu uses to display
# them, minus the [Remove] buttons.
execute unless data storage scdi:config disguise_targets[0] run return 0
scoreboard players set $help_idx scdi_const 0
function scdi:help_items_list_recursive
