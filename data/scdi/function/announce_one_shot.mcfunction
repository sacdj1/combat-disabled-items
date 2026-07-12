# called once a one-shot is confirmed (either path - with or without the
# cooldown tightening, see check_one_shot.mcfunction/
# check_one_shot_cooldown.mcfunction) - the actual chat announcement,
# extracted out so both paths share one copy.
tellraw @a ["",{"text":"⚔ ","color":"red"},{"selector":"@s"},{"text":" was ","color":"gray"},{"text":"ONE-SHOT","color":"red","bold":true},{"text":"!","color":"gray"}]
