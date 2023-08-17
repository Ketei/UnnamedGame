extends Node
class_name VitalityHealth

signal changed_health(CurrentHealth, MaxHealth)
signal changed_stamina(CurrentStamina, MaxStamina)
signal changed_mana(CurrentMana, MaxMana)

var enabled: bool = true

var change_self_with_lust: bool = false

## Max amount of damage an actor can take.
var base_health: int = 0 :
	set(value):
		if enabled:
			base_health = maxi(value, 1)
			max_health = ActorLibs.calculate_stati(base_health, mod_health, mult_health)
var mod_health: int = 0 :
	set(value):
		if enabled:
			mod_health = value
			max_health = ActorLibs.calculate_stati(base_health, mod_health, mult_health)
var mult_health: float = 1.0 :
	set(value):
		if enabled:
			mult_health = maxf(value, 0.0)
			max_health = ActorLibs.calculate_stati(base_health, mod_health, mult_health)
var max_health: int :
	set(value):
		if enabled:
			max_health = maxi(value, 1)
			changed_health.emit(health, max_health)

## Max amount of energy the actor has. Used for attacks, dodges and others.
var base_stamina: int = 0:
	set(value):
		if enabled:
			base_stamina = maxi(value, 1)
			max_stamina = ActorLibs.calculate_stati(base_stamina, mod_stamina, mult_stamina)
var mod_stamina: int = 0 :
	set(value):
		if enabled:
			mod_stamina = value
			max_stamina = ActorLibs.calculate_stati(base_stamina, mod_stamina, mult_stamina)
var mult_stamina: float = 1.0 :
	set(value):
		if enabled:
			mult_stamina = maxf(value, 0.0)
			max_stamina = ActorLibs.calculate_stati(base_stamina, mod_stamina, mult_stamina)
var max_stamina: int :
	set(value):
		if enabled:
			max_stamina = maxi(value, 1)
			changed_stamina.emit(stamina, max_stamina)

## Max amount of magic the actor has. Used to cast spells.
var base_mana: int = 0:
	set(value):
		if enabled:
			base_mana = maxi(value, 1)
			max_mana = ActorLibs.calculate_stati(base_mana, max_mana, mult_mana)
var mod_mana: int = 0 :
	set(value):
		if enabled:
			mod_mana = value
			max_mana = ActorLibs.calculate_stati(base_mana, max_mana, mult_mana)
var mult_mana: float = 1.0 :
	set(value):
		if enabled:
			mult_mana = maxf(value, 0.0)
			max_mana = ActorLibs.calculate_stati(base_mana, max_mana, mult_mana)
var max_mana: int :
	set(value):
		if enabled:
			max_mana = maxi(value, 1)
			changed_mana.emit(mana, max_mana)

# Dynamic values
var health: int :
	set(value):
		if enabled:
			health = clampi(value, 0, max_health)
			changed_health.emit(health, max_health)
var stamina: int :
	set(value):
		if enabled:
			stamina = clampi(value, 0, max_stamina)
			changed_stamina.emit(stamina, max_stamina)
var mana: int :
	set(value):
		if enabled:
			mana = clampi(value, 0, max_mana)
			changed_mana.emit(mana, max_mana)


func full_restore() -> void:
	health = max_health
	stamina = max_stamina
	mana = max_mana


func trigger_lust_stats_change(CurrentLust: int, PreviousLust: int) -> void:
	mod_health += SexLibs.get_stat_with_lusti("health", CurrentLust, PreviousLust)
	mod_stamina += SexLibs.get_stat_with_lusti("stamina", CurrentLust, PreviousLust)
	mod_mana += SexLibs.get_stat_with_lusti("mana", CurrentLust, PreviousLust)
