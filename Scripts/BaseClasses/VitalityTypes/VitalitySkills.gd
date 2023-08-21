extends Node
class_name VitalitySkill

var enabled: bool = true

var change_self_with_lust: int = false

## Affects physical damage
var base_strength: int = 0 :
		set(value):
			if enabled:
				base_strength = maxi(value, 0)
				strength = ActorLibs.calculate_stati(base_strength, mod_strength, mult_strength)
var mod_strength: int = 0 :
	set(value):
		if enabled:
			mod_strength = value
			strength = ActorLibs.calculate_stati(base_strength, mod_strength, mult_strength)
var mult_strength: float = 1.0 :
	set(value):
		if enabled:
			mult_strength = maxf(value, 0.0)
			strength = ActorLibs.calculate_stati(base_strength, mod_strength, mult_strength)
var max_strength: int = 0 :
	set(value):
		if enabled:
			max_strength = maxi(value, 0)
var strength: int = 0:
	set(value):
		if enabled:
			strength = clampi(value, 0, max_strength)

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
var max_endurance: int = 0 :
	set(value):
		if enabled:
			max_endurance = maxi(value, 0)
var endurance: int = 0 :
	set(value):
		if enabled:
			endurance = clampi(value, 0, max_endurance)

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
var max_charisma: int = 0 :
	set(value):
		if enabled:
			max_charisma = maxi(value, 0)
var charisma: int = 0 :
	set(value):
		if enabled:
			charisma = clampi(value, 0, max_charisma)

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
var max_intelligence: int = 0 :
	set(value):
		if enabled:
			max_intelligence = maxi(value, 0)
var intelligence: int = 0 :
	set(value):
		if enabled:
			intelligence = clampi(value, 0, max_intelligence)

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
var max_luck: int = 0 :
	set(value):
		if enabled:
			max_luck = maxi(value, 0)
var luck: int = 0 :
	set(value):
		if enabled:
			luck = clampi(value, 0, max_luck)


func trigger_lust_stats_change(CurrentLust, PreviousLust) -> void:
	mod_strength += SexLibs.get_stat_with_lusti("strength", CurrentLust, PreviousLust)
	mod_endurance += SexLibs.get_stat_with_lusti("endurance", CurrentLust, PreviousLust)
	mod_charisma += SexLibs.get_stat_with_lusti("charisma", CurrentLust, PreviousLust)
	mod_intelligence += SexLibs.get_stat_with_lusti("intelligence", CurrentLust, PreviousLust)
	mod_luck += SexLibs.get_stat_with_lusti("luck", CurrentLust, PreviousLust)

