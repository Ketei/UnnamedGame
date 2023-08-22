extends Resource
class_name ResourceCombat

## Changes defense depending on lust values. Requires horny to be enabled.
@export var change_self_with_lust: bool = false

## Add resistances or weaknesses to the actor. Key is NameOfDamage, value is a float where 1.0 is 100%
## resist and -1.0 is -100% weakness. This is only when taking damage
@export var resistances: Dictionary = {}
## Add affinities or incompatibilities to the actor. Key is NameOfDamage, value is a float where 1.0 is 100%
## affinities and -1.0 is -100% incompatibilities. This only affects the damage you deal.
@export var affinities: Dictionary = {}

## Reduces physical damage received
@export var defense_physical: int = 0

## Reduces magical damage received
@export var defense_magical: int = 0
