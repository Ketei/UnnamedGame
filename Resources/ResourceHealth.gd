extends Resource
class_name ResourceVitality

## Max amount of damage an actor can take.
@export var health: int = 0
## Max amount of energy the actor has. Used for attacks, dodges and others.
@export var stamina: int = 0
## Max amount of magic the actor has. Used to cast spells.
@export var mana: int = 0

## Used for physical damage calculations
@export var strength: int = 0
## Affects your defense & tolerance to sexual attacks
@export var endurance: int = 0
## Affects NPC interactions & Store prices.
@export var charisma: int = 0
## Affects magic damage
@export var intelligence: int = 0
## Affects critical hits & Minigame odds
@export var luck: int = 0

## Natural actor resistance to physical damage.
@export var defense_physical: int = 0
## Natural actor resistance to magical damage.
@export var defense_magical: int = 0

## Only relevant if used along with the horny module. Check ActorProperties
## to see what stats will be changed
@export var change_self_with_lust: bool = false
