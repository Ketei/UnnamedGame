## Used to track all vitality and combat related data along with effects.
## When the module is disabled, most set()'s won't work and effects timers will pause,
## but get()'s will remain functional.
extends Module
class_name ModuleVitality

signal depleted_health
signal depleted_stamina
signal depleted_mana

## If a vitality resource is loaded, it'll overwrite all stats that are 0. Useful
## if you want to create different variants of a same type of actor.
@export var vitality_resource : ResourceVitality

## Base stats
@export_group("Vitality")
## Max amount of damage an actor can take.
@export var base_health: int = 0 :
	set(value):
		if enabled:
			base_health = maxi(value, 1)
			update_max_health()
## Max amount of energy the actor has. Used for attacks, dodges and others.
@export var base_stamina: int = 0:
	set(value):
		if enabled:
			base_stamina = maxi(value, 1)
			update_max_stamina()
## Max amount of magic the actor has. Used to cast spells.
@export var base_mana: int = 0:
	set(value):
		if enabled:
			base_mana = maxi(value, 1)
			update_max_mana()

@export_group("Attributes")
## Affects physical damage
@export var base_strenght: int = 0 :
		set(value):
			if enabled:
				base_strenght = maxi(value, 1)
				update_max_strength()

## Affects your damage reduction & tolerance to sexual attacks
@export var base_endurance: int = 0 :
	set(value):
		if enabled:
			base_endurance = maxi(value, 0)
			update_max_endurance()

## Affects NPC interactions & Store prices.
@export var base_charisma: int = 0 :
	set(value):
		if enabled:
			base_charisma = maxi(value, 1)
			update_max_charisma()

## Affects magic damage
@export var base_intelligence: int = 0 :
	set(value):
		if enabled:
			base_intelligence = maxi(value, 1)
			update_max_intelligence()

## Affects critical hits & Minigame odds
@export var base_luck: int = 0 :
	set(value):
		if enabled:
			base_luck = maxi(value, 1)
			update_max_luck()

@export_group("Natural Defenses")
## Reduces physical damage received
@export var base_defense_physical: int = 0 :
	set(value):
		if enabled:
			base_defense_physical = maxi(value, 0)
			update_max_defense_physical()

## Reduces magical damage received
@export var base_defense_magical: int = 0 :
	set(value):
		if enabled:
			base_defense_magical = maxi(value, 0)
			update_max_defense_magical()

@export_group("Sex Attributes")
## Used for sexual damage/defense calculations.
@export var base_sex_skill_penis: int = 0:
	set(value):
		if enabled:
			base_sex_skill_penis = maxi(value, 0)
			update_max_sex_skill_penis()

@export var base_sex_skill_anal: int = 0:
	set(value):
		if enabled:
			base_sex_skill_anal = maxi(value, 0)
			update_max_sex_skill_anal()

@export var base_sex_skill_oral: int = 0:
	set(value):
		if enabled:
			base_sex_skill_oral = maxi(value, 0)
			update_max_sex_skill_oral()

@export var base_sex_skill_vaginal: int = 0:
	set(value):
		if enabled:
			base_sex_skill_vaginal = maxi(value, 0)
			update_max_sex_skill_vaginal()

# Modifiers
# Modifiers are used to temporarely buff or nerf max values without overriding the original values.
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

var mod_sex_skill_penis: int = 0:
	set(value):
		if enabled:
			mod_sex_skill_penis = value
			update_max_sex_skill_penis()

var mod_sex_skill_anal: int = 0:
	set(value):
		if enabled:
			mod_sex_skill_anal = value
			update_max_sex_skill_anal()

var mod_sex_skill_oral: int = 0:
	set(value):
		if enabled:
			mod_sex_skill_oral = value
			update_max_sex_skill_oral()

var mod_sex_skill_vaginal: int = 0:
	set(value):
		if enabled:
			mod_sex_skill_vaginal = value
			update_max_sex_skill_vaginal()

# Multipliers
# Multipliers are used to reduce or buff stats by %.
# Ex. [1.0 * 0.5 * 0.2] = 10%
var mult_health: Array = []
var mult_stamina: Array = []
var mult_mana: Array = []

var mult_strength: Array = []
var mult_endurance: Array = []
var mult_charisma: Array = []
var mult_intelligence: Array = []
var mult_luck: Array = []
var mult_sex_skill_penis: Array = []
var mult_sex_skill_anal: Array = []
var mult_sex_skill_oral: Array = []
var mult_sex_skill_vaginal: Array = []

var mult_defense_physical: Array = []
var mult_defense_magical: Array = []

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

var max_strenght: int :
	set(value):
		if enabled:
			max_strenght = maxi(value, 1)

var max_endurance: int :
	set(value):
		if enabled:
			max_endurance = maxi(value, 1)

var max_charisma: int :
	set(value):
		if enabled:
			max_charisma = maxi(value, 1)

var max_intgelligence: int :
	set(value):
		if enabled:
			max_intgelligence = maxi(value, 1)

var max_luck: int :
	set(value):
		if enabled:
			max_luck = maxi(value, 1)

var max_defense_physical: int :
	set(value):
		if enabled:
			max_defense_physical = maxi(value, 0)

var max_defense_magical: int :
	set(value):
		if enabled:
			max_defense_magical = maxi(value, 0)

var max_sex_skill_penis: int :
	set(value):
		if enabled:
			max_sex_skill_penis = maxi(value, 0)

var max_sex_skill_anal: int :
	set(value):
		if enabled:
			max_sex_skill_anal = maxi(value, 0)

var max_sex_skill_oral: int :
	set(value):
		if enabled:
			max_sex_skill_oral = maxi(value, 0)

var max_sex_skill_vaginal: int :
	set(value):
		if enabled:
			max_sex_skill_vaginal = maxi(value, 0)


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

# How much damage can you mitigate before you damage your health.
#Damage to base_endurance = Oponent sex skill - self target sex skill. With a min of 1
# When it gets to negatives it deals %max_hp damage and resets to 0
var sexual_endurance: int :
	set(value):
		if enabled:
			sexual_endurance = clampi(value, 0, max_endurance) 

var effect_applier: EffectApplier


func _calculate_multiplier(MagnitudeList: Array) -> float:
	var current_magnitude: float = 1.0
	
	if 0 < MagnitudeList.size():
		for multiplier in MagnitudeList:
			current_magnitude -= multiplier
	
	return clampf(current_magnitude, 0.0, 1.0)

# Change so that increases additions multiply by difficulty.
func update_max_health() -> void:
	var _new_val = floori(float(base_health + mod_max_health) * _calculate_multiplier(mult_health))
	var _diff = _new_val - max_health
	max_health = _new_val
	if max_health < health:
		health = max_health
	if 0 < _diff:
		health += _diff

# Change so that increases additions multiply by difficulty.
func update_max_stamina() -> void:
	var _new_val = floori(float(base_stamina + mod_max_stamina) * _calculate_multiplier(mult_stamina))
	var _diff = _new_val - max_stamina
	max_stamina = _new_val
	if max_stamina < stamina:
		stamina = max_stamina
	if 0 < _diff:
		stamina += _diff

# Change so that increases additions multiply by difficulty.
func update_max_mana() -> void:
	var _new_val = floori(float(base_mana + mod_max_mana) * _calculate_multiplier(mult_mana))
	var _diff = _new_val - max_mana
	max_mana = _new_val
	if max_mana < mana:
		mana = max_mana
	if 0 < _diff:
		mana += _diff


func update_max_strength() -> void:
	max_strenght = floori(float(base_strenght + mod_strength) * _calculate_multiplier(mult_strength))


func update_max_endurance() -> void:
	max_endurance = floori(float(base_endurance + mod_endurance) * _calculate_multiplier(mult_endurance))
	if max_endurance < sexual_endurance:
		sexual_endurance = max_endurance


func update_max_charisma() -> void:
	max_charisma = floori(float(base_charisma + mod_charisma) * _calculate_multiplier(mult_charisma))


func update_max_intelligence() -> void:
	max_intgelligence = floori(float(base_intelligence + mod_intelligence) * _calculate_multiplier(mult_intelligence))


func update_max_luck() -> void:
	max_luck = floori(float(base_luck + mod_luck) * _calculate_multiplier(mult_luck))


func update_max_defense_physical() -> void:
	max_defense_physical = floori(float(base_defense_physical + mod_defense_physical) * _calculate_multiplier(mult_defense_physical))


func update_max_defense_magical() -> void:
	max_defense_magical = floori(float(base_defense_magical + mod_defense_magical) * _calculate_multiplier(mult_defense_magical))


func update_max_sex_skill_anal() -> void:
	max_sex_skill_anal = floori(float(base_sex_skill_anal + mod_sex_skill_anal) * _calculate_multiplier(mult_sex_skill_anal))


func update_max_sex_skill_oral() -> void:
	max_sex_skill_oral = floori(float(base_sex_skill_oral + mod_sex_skill_oral) * _calculate_multiplier(mult_sex_skill_oral))


func update_max_sex_skill_penis() -> void:
	max_sex_skill_penis = floori(float(base_sex_skill_penis + mod_sex_skill_penis) * _calculate_multiplier(mult_sex_skill_penis))


func update_max_sex_skill_vaginal() -> void:
	max_sex_skill_vaginal = floori(float(base_sex_skill_vaginal + mod_sex_skill_vaginal) * _calculate_multiplier(mult_sex_skill_vaginal))


func full_restore(RestoreHP := true, RestoreSP := true, RestoreMP := true, RestoreSexEnd := true):
	if enabled:
		if RestoreHP:
			health = max_health
		if RestoreMP:
			mana = max_mana
		if RestoreSP:
			stamina = max_stamina
		if RestoreSexEnd:
			sexual_endurance = max_endurance

## Useful to calculate damage considering resitances and endurance.
func calculate_damage(AttackDamage: float, IsPhysical := true) -> int:
	var _defense: float
	var _damage: float
	
	if IsPhysical:
		_defense = float(base_defense_physical + mod_defense_physical)
	else:
		_defense = float(base_defense_magical + mod_defense_magical)
	
	_damage = (AttackDamage * (AttackDamage/(AttackDamage + _defense)))
	
	_damage *= (1.0 - (float(max_endurance) / 100.0))
	
	return maxi(ceili(_damage), 1)


func calculate_sex_damage(SexSkillDefVAlue: int, SexSkillAtkValue: int) -> int:
	var sex_damage_done: float = 0.0
	var calculated_damage = sexual_endurance - maxi(SexSkillAtkValue - SexSkillDefVAlue, 1)
	sexual_endurance = calculated_damage
	
	# Take damage and reset base_endurance to 0
	if calculated_damage < 0:
		sex_damage_done = (clampf( absf(sexual_endurance)/100.0, Settings.min_sex_damage_percent, Settings.max_sex_damage_percent)) * max_health
		
	return ceili(sex_damage_done)


func set_up_module():
	module_type = "vitality"
	if vitality_resource:
		if base_health <= 0:
			base_health = vitality_resource.health
		if base_stamina <= 0:
			base_stamina = vitality_resource.stamina
		if base_mana <= 0:
			base_mana = vitality_resource.mana
		
		if base_strenght <= 0:
			base_strenght = vitality_resource.base_strenght
		if base_endurance <= 0:
			base_endurance = vitality_resource.base_endurance
		if base_charisma <= 0:
			base_charisma = vitality_resource.base_charisma
		if base_intelligence <= 0:
			base_intelligence = vitality_resource.base_intelligence
		if base_luck <= 0:
			base_luck = vitality_resource.base_luck
		
		if base_defense_physical <= 0:
			base_defense_physical = vitality_resource.base_defense_physical
		if base_defense_magical <= 0:
			base_defense_magical = vitality_resource.base_defense_magical
		
		if base_sex_skill_anal <= 0:
			base_sex_skill_anal = vitality_resource.sex_skill_anal
		if base_sex_skill_oral <= 0:
			base_sex_skill_oral = vitality_resource.sex_skill_oral
		if base_sex_skill_penis <= 0:
			base_sex_skill_penis = vitality_resource.sex_skill_penis
		if base_sex_skill_vaginal <= 0:
			base_sex_skill_vaginal = vitality_resource.sex_skill_vaginal
	
	# Oopsie-proofing
	# Sets up minimal allowed values to variables.
	
	if base_health <= 0:
		base_health = 1
	if base_stamina <= 0:
		base_stamina = 1
	if base_mana <= 0:
		base_mana = 1
	
	if base_strenght <= 0:
		base_strenght = 1
	if base_endurance <= 0:
		base_endurance = 1
	if base_charisma <= 0:
		base_charisma = 1
	if base_intelligence <= 0:
		base_intelligence = 1
	if base_luck <= 0:
		base_luck = 1
		
	if base_defense_physical < 0:
		base_defense_physical = 0
	if base_defense_magical < 0:
		base_defense_magical = 0

	if base_sex_skill_anal < 0:
		base_sex_skill_anal = 0
	if base_sex_skill_oral < 0:
		base_sex_skill_oral = 0
	if base_sex_skill_penis < 0:
		base_sex_skill_penis = 0
	if base_sex_skill_vaginal < 0:
		base_sex_skill_vaginal = 0
	
	max_health = base_health
	max_stamina = base_stamina
	max_mana = base_mana
	max_strenght = base_strenght
	max_endurance = base_endurance
	max_charisma = base_charisma
	max_intgelligence = base_intelligence
	max_luck = base_luck
	max_defense_physical = base_defense_physical
	max_defense_magical = base_defense_magical
	max_sex_skill_anal = base_sex_skill_anal
	max_sex_skill_oral = base_sex_skill_oral
	max_sex_skill_penis = base_sex_skill_penis
	max_sex_skill_vaginal = base_sex_skill_vaginal
	
	full_restore()
	
	effect_applier = EffectApplier.new()
	effect_applier._vitality_module = self
	self.add_child(effect_applier)
	
	enabled = true


func _module_enabled_override(Value: bool) -> void:
	effect_applier._timer_module_enabled(Value)
	enabled = Value
