# tests each piece of nullify_check's mainhand condition separately, so
# there's no ambiguity about which part is failing.
# usage: /function scdi:debug/check_predicates
tellraw @s {"text":"[check] testing mainhand predicates...","color":"yellow"}
execute if predicate scdi:firework_mainhand run tellraw @s {"text":"[check] firework_mainhand: TRUE (holding a firework)","color":"green"}
execute unless predicate scdi:firework_mainhand run tellraw @s {"text":"[check] firework_mainhand: FALSE (not detected as holding a firework)","color":"red"}
execute if predicate scdi:nulled_mainhand run tellraw @s {"text":"[check] nulled_mainhand: TRUE (already marked nulled)","color":"green"}
execute unless predicate scdi:nulled_mainhand run tellraw @s {"text":"[check] nulled_mainhand: FALSE (not marked nulled)","color":"green"}
execute if predicate scdi:firework_mainhand unless predicate scdi:nulled_mainhand run tellraw @s {"text":"[check] COMBINED CONDITION: TRUE - nullify_mainhand should run now","color":"aqua"}
execute unless predicate scdi:firework_mainhand run tellraw @s {"text":"[check] COMBINED CONDITION: FALSE - blocked by firework_mainhand not matching","color":"red"}
execute if predicate scdi:firework_mainhand if predicate scdi:nulled_mainhand run tellraw @s {"text":"[check] COMBINED CONDITION: FALSE - blocked by nulled_mainhand already matching","color":"red"}
tellraw @s {"text":"[check] done","color":"yellow"}
