# called with {particle:"..."} from apply_dummy_invincible_save.mcfunction -
# split into its own macro function since the caller isn't itself a macro
# function (see load.mcfunction's dummy_cheat_death_particle comment for
# the config this reads from).
$particle $(particle) ~ ~1 ~ 0.5 0.5 0.5 0.1 30 force
