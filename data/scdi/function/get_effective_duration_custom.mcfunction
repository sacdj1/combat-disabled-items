# scdi_item_dur already defaults to the global $duration (set by the caller,
# get_effective_duration.mcfunction) - this just walks disguise_targets
# looking for a matching item with its own duration override to replace it
# with. uses a dedicated $dur_idx counter/scdi:tmp5 index, separate from the
# $custom_idx/scdi:tmp2 used by the nullify-side walk, since this can run
# mid-tick alongside that one without colliding.
scoreboard players set $dur_idx scdi_const 0
function scdi:get_effective_duration_custom_recursive
