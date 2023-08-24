extends Node
class_name VitalityCombat

var enabled: bool = true

var change_self_with_lust: bool = false

# A positive number means a boost. A negative number means a reduction. 100% = 1.0
# Nothing is gained from having over +100% in resistances(1.0). As this negates all damage received.
# Nothing is gained from having under -100% in afinities(-1.0). As this zeroes all damage dealt.
# resistances = Actor Properties.GameProperties.DamagePhysical/DamageElemental(String): Resistance(Float)
# affinities = GameProperties.AttackTypes(String): AffinityValue(float)
var resistances: Dictionary = {}
var affinities: Dictionary = {}

# A dictionary that holds all the types of damage that the actor will deal along with the values.
var attack_types: Dictionary = {} #Ex. "blunt": 10, "fire": 5 

var mod_damage_physical: int = 0 :
	set(value):
		if enabled:
			mod_damage_physical = value
var skill_damage_physical: int = 0
var mult_damage_physical: float = 1.0 :
	set(value):
		if enabled:
			mult_damage_physical = maxf(value, 0.0)

var mod_damage_magical: int = 0 :
	set(value):
		if enabled:
			mod_damage_magical = value
var skill_damage_magical: int = 0
var mult_damage_magical: float = 1.0 :
	set(value):
		if enabled:
			mult_damage_magical = maxf(value, 0.0)

## Reduces physical damage received
var base_defense_physical: int = 0 :
	set(value):
		if enabled:
			base_defense_physical = maxi(value, 0)
			defense_physical = ActorLibs.calculate_stati(base_defense_physical + skill_defense_physical, mod_defense_physical, mult_defense_physical)
var skill_defense_physical: int = 0
var mod_defense_physical: int = 0 :
	set(value):
		if enabled:
			mod_defense_physical = value
			defense_physical = ActorLibs.calculate_stati(base_defense_physical + skill_defense_physical, mod_defense_physical, mult_defense_physical)
var mult_defense_physical: float = 1.0 :
	set(value):
		if enabled:
			mult_defense_physical = maxf(value, 0.0)
			defense_physical = ActorLibs.calculate_stati(base_defense_physical + skill_defense_physical, mod_defense_physical, mult_defense_physical)
var defense_physical: int = 0 :
	set(value):
		if enabled:
			defense_physical = maxi(value, 0)

## Reduces magical damage received
var base_defense_magical: int = 0 :
	set(value):
		if enabled:
			base_defense_magical = maxi(value, 0)
			defense_magical = ActorLibs.calculate_stati(base_defense_magical + skill_defense_magical, mod_defense_magical, mult_defense_magical)
var skill_defense_magical: int = 0
var mod_defense_magical: int = 0 :
	set(value):
		if enabled:
			mod_defense_magical = value
			defense_magical = ActorLibs.calculate_stati(base_defense_magical + skill_defense_magical, mod_defense_magical, mult_defense_magical)
var mult_defense_magical: float = 1.0 :
	set(value):
		if enabled:
			mult_defense_magical = maxf(value, 0.0)
			defense_magical = ActorLibs.calculate_stati(base_defense_magical + skill_defense_magical, mod_defense_magical, mult_defense_magical)
var defense_magical: int = 0 :
	set(value):
		if enabled:
			defense_magical = maxi(value, 0)


func trigger_lust_stats_change(CurrentLust, PreviousLust) -> void:
	mod_damage_physical += SexLibs.get_stat_with_lusti("damage-physical", CurrentLust, PreviousLust)
	mult_damage_physical += SexLibs.get_stat_with_lustf("mult-damage-physical", CurrentLust, PreviousLust)
	
	mod_damage_magical += SexLibs.get_stat_with_lusti("damage-magical", CurrentLust, PreviousLust)
	mult_damage_magical += SexLibs.get_stat_with_lustf("mult-damage-magical", CurrentLust, PreviousLust)
	
	mod_defense_magical += SexLibs.get_stat_with_lusti("defense-magical", CurrentLust, PreviousLust)
	mult_defense_magical += SexLibs.get_stat_with_lustf("mult-defense-magical", CurrentLust, PreviousLust)
	
	mod_defense_physical += SexLibs.get_stat_with_lusti("defense-physical", CurrentLust, PreviousLust)
	mult_defense_physical += SexLibs.get_stat_with_lustf("mult-defense-physical", CurrentLust, PreviousLust)


func mod_resistance(ResistanceName: String, ModResistance: float) -> void:
	if ResistanceName not in resistances:
		resistances[ResistanceName] = 0.0
	
	resistances[ResistanceName] += ModResistance
	
	if resistances[ResistanceName] == 0.0:
		resistances.erase(ResistanceName)


func mod_affinity(AffinityName: String, ModAffinity: float) -> void:
	if AffinityName not in affinities:
		affinities[AffinityName] = 0.0
	
	affinities[AffinityName] += ModAffinity
	
	if affinities[AffinityName] == 0.0:
		affinities.erase(AffinityName)

