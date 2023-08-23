extends Resource
class_name ResourceSkill

## Affects damage with fists and melee weapons
@export var max_strength: int = 0
@export var starting_strength: int = 0
## Affects your damage reduction. Each point of endurance reduces total damage by 1%
@export var max_endurance: int = 0
@export var starting_endurance: int = 0
## Affects NPC interactions, store prices and seduction.
@export var max_charisma: int = 0
@export var starting_charisma: int = 0
## Affects spells damage.
@export var max_intelligence: int = 0
@export var starting_intelligence: int = 0
## Affects critical hits & Minigame odds
@export var max_luck: int = 0
@export var starting_luck: int = 0

## Reduces physical damage received
@export var max_defense_physical: int = 0
@export var starting_defense_physical: int = 0
## Reduces magical damage received
@export var max_defense_magical: int = 0
@export var starting_defense_magical: int = 0

@export var change_self_with_lust: bool = false
