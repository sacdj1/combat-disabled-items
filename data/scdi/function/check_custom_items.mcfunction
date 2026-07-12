# entry point - walks the disguise_targets list (genuinely unlimited length,
# managed via /function scdi:menu/items) using recursion, since there's no
# real loop construct over an arbitrary-length list in a datapack. an empty
# list just recurses once, hits the out-of-bounds check, and returns
# immediately - cheap.
scoreboard players set $custom_idx scdi_const 0
function scdi:check_custom_item_recursive
