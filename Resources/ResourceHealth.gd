extends Resource
class_name ResourceHealth

## Max amount of damage an actor can take.
@export var health: int = 0
## Max amount of energy the actor has. Used for attacks, dodges and others.
@export var stamina: int = 0
## Max amount of magic the actor has. Used to cast spells.
@export var mana: int = 0

## Only relevant if used along with the horny module. Check ActorProperties
## to see what stats will be changed
@export var change_self_with_lust: bool = false
