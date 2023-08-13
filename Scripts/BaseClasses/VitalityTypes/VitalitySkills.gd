extends Node
class_name VitalitySkill

var enabled: bool = true

## Affects physical damage
var base_strenght: int = 0 :
		set(value):
			if enabled:
				base_strenght = maxi(value, 1)
				update_max_strength()

## Affects your damage reduction & tolerance to sexual attacks
var base_endurance: int = 0 :
	set(value):
		if enabled:
			base_endurance = maxi(value, 0)
			update_max_endurance()

## Affects NPC interactions & Store prices.
var base_charisma: int = 0 :
	set(value):
		if enabled:
			base_charisma = maxi(value, 1)
			update_max_charisma()

## Affects magic damage
var base_intelligence: int = 0 :
	set(value):
		if enabled:
			base_intelligence = maxi(value, 1)
			update_max_intelligence()

## Affects critical hits & Minigame odds
var base_luck: int = 0 :
	set(value):
		if enabled:
			base_luck = maxi(value, 1)
			update_max_luck()

## Reduces physical damage received
var base_defense_physical: int = 0 :
	set(value):
		if enabled:
			base_defense_physical = maxi(value, 0)
			update_max_defense_physical()

## Reduces magical damage received
var base_defense_magical: int = 0 :
	set(value):
		if enabled:
			base_defense_magical = maxi(value, 0)
			update_max_defense_magical()

# Modifiers
# Modifiers are used to temporarely buff or nerf max values without overriding the original values.

var mod_strength: int = 0 :
	set(value):
		if enabled:
			mod_strength = value
			update_max_strength()

var mod_endurance: int = 0 : 
	set(value):
		if enabled:
			mod_endurance = value
			update_max_endurance()

var mod_charisma: int = 0 :
	set(value):
		if enabled:
			mod_charisma = value
			update_max_charisma()

var mod_intelligence: int = 0 :
	set(value):
		if enabled:
			mod_intelligence = value
			update_max_intelligence()

var mod_luck: int = 0 :
	set(value):
		if enabled:
			mod_luck = value
			update_max_luck()

var mod_defense_physical: int = 0 :
	set(value):
		if enabled:
			mod_defense_physical = value
			update_max_defense_physical()

var mod_defense_magical: int = 0 :
	set(value):
		if enabled:
			mod_defense_magical = value
			update_max_defense_magical()


# Multipliers
# Multipliers are used to reduce or buff stats by %.
# Ex. [1.0 * 0.5 * 0.2] = 10%
var mult_strength: Array = []
var mult_endurance: Array = []
var mult_charisma: Array = []
var mult_intelligence: Array = []
var mult_luck: Array = []

var mult_defense_physical: Array = []
var mult_defense_magical: Array = []

# Max stats values
var strength: int :
	set(value):
		if enabled:
			strength = maxi(value, 1)

var endurance: int :
	set(value):
		if enabled:
			endurance = maxi(value, 1)

var charisma: int :
	set(value):
		if enabled:
			charisma = maxi(value, 1)

var intelligence: int :
	set(value):
		if enabled:
			intelligence = maxi(value, 1)

var luck: int :
	set(value):
		if enabled:
			luck = maxi(value, 1)

var defense_physical: int :
	set(value):
		if enabled:
			defense_physical = maxi(value, 0)

var defense_magical: int :
	set(value):
		if enabled:
			defense_magical = maxi(value, 0)


func update_max_strength() -> void:
	strength = floori(float(base_strenght + mod_strength) * QuickMath.calculate_multiplier(mult_strength))


func update_max_endurance() -> void:
	endurance = floori(float(base_endurance + mod_endurance) * QuickMath.calculate_multiplier(mult_endurance))


func update_max_charisma() -> void:
	charisma = floori(float(base_charisma + mod_charisma) * QuickMath.calculate_multiplier(mult_charisma))


func update_max_intelligence() -> void:
	intelligence = floori(float(base_intelligence + mod_intelligence) * QuickMath.calculate_multiplier(mult_intelligence))


func update_max_luck() -> void:
	luck = floori(float(base_luck + mod_luck) * QuickMath.calculate_multiplier(mult_luck))


func update_max_defense_physical() -> void:
	defense_physical = floori(float(base_defense_physical + mod_defense_physical) * QuickMath.calculate_multiplier(mult_defense_physical))


func update_max_defense_magical() -> void:
	defense_magical = floori(float(base_defense_magical + mod_defense_magical) * QuickMath.calculate_multiplier(mult_defense_magical))
