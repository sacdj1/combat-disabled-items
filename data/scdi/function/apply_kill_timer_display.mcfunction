# called with {id:N} from combat_end.mcfunction. kills the floating timer
# display whose scdi_owner_id exactly matches - id -1 (combat_end.mcfunction's
# fallback for "no scdi_id assigned") matches no real display, since ids
# start at 1, so this is a safe no-op in that case rather than an error.
$kill @e[type=minecraft:text_display,tag=scdi_timer_display,scores={scdi_owner_id=$(id)}]
