extends Node
class_name VitalitySkill

var enabled: bool = true

var change_self_with_lust: int = false

## Affects physical damage
var base_strenght: int = 0 :
		set(value):
			if enabled:
				base_strenght = maxi(value, 0)
				strength = ActorLibs.calculate_stati(base_strenght, mod_strength, mult_strength)
var mod_strength: int = 0 :
	set(value):
		if enabled:
			mod_strength = value
			strength = ActorLibs.calculate_stati(base_strenght, mod_strength, mult_strength)
var mult_strength: float = 1.0 :
	set(value):
		if enabled:
			mult_strength = maxf(value, 0.0)
			strength = ActorLibs.calculate_stati(base_strenght, mod_strength, mult_strength)
var strength: int = 0:
	set(value):
		if enabled:
			strength = maxi(value, 0)

## Affects your damage reduction & tolerance to sexual attacks
var base_endurance: int = 0 :
	set(value):
		if enabled:
			base_endurance = maxi(value, 0)
			endurance = ActorLibs.calculate_stati(base_endurance, mod_endurance, mult_endurance)
var mod_endurance: int = 0 : 
	set(value):
		if enabled:
			mod_endurance = value
			endurance = ActorLibs.calculate_stati(base_endurance, mod_endurance, mult_endurance)
var mult_endurance: float = 1.0 :
	set(value):
		if enabled:
			mult_endurance = maxf(value, 0.0)
			endurance = ActorLibs.calculate_stati(base_endurance, mod_endurance, mult_endurance)
var endurance: int = 0 :
	set(value):
		if enabled:
			endurance = maxi(value, 0)

## Affects NPC interactions & Store prices.
var base_charisma: int = 0 :
	set(value):
		if enabled:
			base_charisma = maxi(value, 0)
			charisma = ActorLibs.calculate_stati(base_charisma, mod_charisma, mult_charisma)
var mod_charisma: int = 0 :
	set(value):
		if enabled:
			mod_charisma = value
			charisma = ActorLibs.calculate_stati(base_charisma, mod_charisma, mult_charisma)
var mult_charisma: float = 1.0 :
	set(value):
		if enabled:
			mult_charisma = maxf(value, 0.0)
			charisma = ActorLibs.calculate_stati(base_charisma, mod_charisma, mult_charisma)
var charisma: int = 0 :
	set(value):
		if enabled:
			charisma = maxi(value, 0)

## Affects magic damage
var base_intelligence: int = 0 :
	set(value):
		if enabled:
			base_intelligence = maxi(value, 0)
			intelligence = ActorLibs.calculate_stati(base_intelligence, mod_intelligence, mult_intelligence)
var mod_intelligence: int = 0 :
	set(value):
		if enabled:
			mod_intelligence = value
			intelligence = ActorLibs.calculate_stati(base_intelligence, mod_intelligence, mult_intelligence)
var mult_intelligence: float = 1.0 :
	set(value):
		if enabled:
			mult_intelligence = maxf(value, 0.0)
			intelligence = ActorLibs.calculate_stati(base_intelligence, mod_intelligence, mult_intelligence)
var intelligence: int = 0 :
	set(value):
		if enabled:
			intelligence = maxi(value, 0)

## Affects critical hits & Minigame odds
var base_luck: int = 0 :
	set(value):
		if enabled:
			base_luck = maxi(value, 0)
			luck = ActorLibs.calculate_stati(base_luck, mod_luck, mult_luck)
var mod_luck: int = 0 :
	set(value):
		if enabled:
			mod_luck = value
			luck = ActorLibs.calculate_stati(base_luck, mod_luck, mult_luck)
var mult_luck: float = 1.0 :
	set(value):
		mult_luck = maxf(value, 0.0)
		luck = ActorLibs.calculate_stati(base_luck, mod_luck, mult_luck)
var luck: int = 0 :
	set(value):
		if enabled:
			luck = maxi(value, 0)

## Reduces physical damage received
var base_defense_physical: int = 0 :
	set(value):
		if enabled:
			base_defense_physical = maxi(value, 0)
			defense_physical = ActorLibs.calculate_stati(base_defense_physical, mod_defense_physical, mult_defense_physical)
var mod_defense_physical: int = 0 :
	set(value):
		if enabled:
			mod_defense_physical = value
			defense_physical = ActorLibs.calculate_stati(base_defense_physical, mod_defense_physical, mult_defense_physical)
var mult_defense_physical: float = 1.0 :
	set(value):
		if enabled:
			mult_defense_physical = maxf(value, 0.0)
			defense_physical = ActorLibs.calculate_stati(base_defense_physical, mod_defense_physical, mult_defense_physical)
var defense_physical: int = 0 :
	set(value):
		if enabled:
			defense_physical = maxi(value, 0)

## Reduces magical damage received
var base_defense_magical: int = 0 :
	set(value):
		if enabled:
			base_defense_magical = maxi(value, 0)
			defense_magical = ActorLibs.calculate_stati(base_defense_magical, mod_defense_magical, mult_defense_magical)
var mod_defense_magical: int = 0 :
	set(value):
		if enabled:
			mod_defense_magical = value
			defense_magical = ActorLibs.calculate_stati(base_defense_magical, mod_defense_magical, mult_defense_magical)
var mult_defense_magical: float = 0.0 :
	set(value):
		if enabled:
			mult_defense_magical = maxf(value, 0.0)
			defense_magical = ActorLibs.calculate_stati(base_defense_magical, mod_defense_magical, mult_defense_magical)
var defense_magical: int = 0 :
	set(value):
		if enabled:
			defense_magical = maxi(value, 0)


func trigger_lust_stats_change(CurrentLust, PreviousLust) -> void:
	mod_strength += SexLibs.get_stat_with_lusti("strength", CurrentLust, PreviousLust)
	mod_endurance += SexLibs.get_stat_with_lusti("endurance", CurrentLust, PreviousLust)
	mod_charisma += SexLibs.get_stat_with_lusti("charisma", CurrentLust, PreviousLust)
	mod_intelligence += SexLibs.get_stat_with_lusti("intelligence", CurrentLust, PreviousLust)
	mod_luck += SexLibs.get_stat_with_lusti("luck", CurrentLust, PreviousLust)
	
	mod_defense_magical += SexLibs.get_stat_with_lusti("defense-magical", CurrentLust, PreviousLust)
	mod_defense_physical += SexLibs.get_stat_with_lusti("defense-physical", CurrentLust, PreviousLust)

