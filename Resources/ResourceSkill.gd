extends Resource
class_name ResourceSkill

## Affects damage with fists and melee weapons
@export var strenght: int = 0
## Affects your damage reduction. Each point of endurance reduces total damage by 1%
@export var endurance: int = 0
## Affects NPC interactions, store prices and seduction.
@export var charisma: int = 0
## Affects spells damage.
@export var intelligence: int = 0
## Affects critical hits & Minigame odds
@export var luck: int = 0

## Reduces physical damage received
@export var defense_physical: int = 0
## Reduces magical damage received
@export var defense_magical: int = 0

@export var change_self_with_lust: bool = false
