extends Node
class_name VitalityHealth

signal depleted_health
signal depleted_stamina
signal depleted_mana

var enabled: bool = true

## Max amount of damage an actor can take.
var base_health: int = 0 :
	set(value):
		if enabled:
			base_health = maxi(value, 1)
			update_max_health()
## Max amount of energy the actor has. Used for attacks, dodges and others.
var base_stamina: int = 0:
	set(value):
		if enabled:
			base_stamina = maxi(value, 1)
			update_max_stamina()
## Max amount of magic the actor has. Used to cast spells.
var base_mana: int = 0:
	set(value):
		if enabled:
			base_mana = maxi(value, 1)
			update_max_mana()

var mod_max_health: int = 0 :
	set(value):
		if enabled:
			mod_max_health = value
			update_max_health()

var mod_max_stamina: int = 0 :
	set(value):
		if enabled:
			mod_max_stamina = value
			update_max_stamina()

var mod_max_mana: int = 0 :
	set(value):
		if enabled:
			mod_max_mana = value
			update_max_stamina()

# Multipliers
# Multipliers are used to reduce or buff stats by %.
# Ex. [1.0 * 0.5 * 0.2] = 10%
var mult_health: Array = []
var mult_stamina: Array = []
var mult_mana: Array = []

# Max stats values
var max_health: int :
	set(value):
		if enabled:
			max_health = maxi(value, 1)

var max_stamina: int :
	set(value):
		if enabled:
			max_stamina = maxi(value, 1)

var max_mana: int :
	set(value):
		if enabled:
			max_mana = maxi(value, 1)

# Dynamic values
var health: int :
	set(value):
		if enabled:
			health = clampi(value, 0, max_health)
			if health == 0:
				depleted_health.emit()

var stamina: int :
	set(value):
		if enabled:
			stamina = clampi(value, 0, max_stamina)
			if stamina == 0:
				depleted_stamina.emit()

var mana: int :
	set(value):
		if enabled:
			mana = clampi(value, 0, max_mana)
			if mana == 0:
				depleted_mana.emit()


# Change so that increases additions multiply by difficulty.
func update_max_health() -> void:
	var _new_val = floori(float(base_health + mod_max_health) * QuickMath.calculate_multiplier(mult_health))
	var _diff = _new_val - max_health
	max_health = _new_val
	if max_health < health:
		health = max_health
	if 0 < _diff:
		health += _diff

# Change so that increases additions multiply by difficulty.
func update_max_stamina() -> void:
	var _new_val = floori(float(base_stamina + mod_max_stamina) * QuickMath.calculate_multiplier(mult_stamina))
	var _diff = _new_val - max_stamina
	max_stamina = _new_val
	if max_stamina < stamina:
		stamina = max_stamina
	if 0 < _diff:
		stamina += _diff

# Change so that increases additions multiply by difficulty.
func update_max_mana() -> void:
	var _new_val = floori(float(base_mana + mod_max_mana) * QuickMath.calculate_multiplier(mult_mana))
	var _diff = _new_val - max_mana
	max_mana = _new_val
	if max_mana < mana:
		mana = max_mana
	if 0 < _diff:
		mana += _diff


func full_restore() -> void:
	health = max_health
	stamina = max_stamina
	mana = max_mana

