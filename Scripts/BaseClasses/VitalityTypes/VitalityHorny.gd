extends Node
class_name VitalityHorny

signal orgasm_signal

var enabled: bool = true

var parent_module: ModuleVitality

var _health_module: VitalityHealth = null
var _skill_module: VitalitySkill = null
var change_self_with_lust: bool = false

var actor_sex_role: ActorProperties.SexRole = ActorProperties.SexRole.TOP

# Sex Skills
var base_sex_skill_penis: int = 0 :
	set(value):
		if enabled:
			base_sex_skill_penis = clampi(value, 0, max_sex_skill_penis)
			max_sex_skill_penis = ActorLibs.calculate_skilli(base_sex_skill_penis, mod_sex_skill_penis, mult_sex_skill_penis)
var mod_sex_skill_penis: int = 0 :
	set(value):
		if enabled:
			mod_sex_skill_penis = value
			max_sex_skill_penis = ActorLibs.calculate_skilli(base_sex_skill_penis, mod_sex_skill_penis, mult_sex_skill_penis)
var mult_sex_skill_penis: float = 1.0 :
	set(value):
		if enabled:
			mult_sex_skill_penis = value
			max_sex_skill_penis = ActorLibs.calculate_skilli(base_sex_skill_penis, mod_sex_skill_penis, mult_sex_skill_penis)
var max_sex_skill_penis: int = 0 :
	set(value):
		if enabled:
			max_sex_skill_penis = maxi(value, 0)
var current_sex_skill_penis: int = 0 :
	set(value):
		if enabled:
			current_sex_skill_penis = clampi(value, 0, max_sex_skill_penis)

var base_sex_skill_oral: int = 0 :
	set(value):
		if enabled:
			base_sex_skill_oral = clampi(value, 0, max_sex_skill_oral)
			max_sex_skill_oral = ActorLibs.calculate_skilli(base_sex_skill_oral, mod_sex_skill_oral, mult_sex_skill_oral)
var mod_sex_skill_oral: int = 0 :
	set(value):
		if enabled:
			mod_sex_skill_oral = value
			max_sex_skill_oral = ActorLibs.calculate_skilli(base_sex_skill_oral, mod_sex_skill_oral, mult_sex_skill_oral)
var mult_sex_skill_oral: float = 1.0 :
	set(value):
		if enabled:
			mult_sex_skill_oral = value
			max_sex_skill_oral = ActorLibs.calculate_skilli(base_sex_skill_oral, mod_sex_skill_oral, mult_sex_skill_oral)
var max_sex_skill_oral: int = 0 :
	set(value):
		if enabled:
			max_sex_skill_oral = maxi(value, 0)
var current_sex_skill_oral: int = 0 :
	set(value):
		if enabled:
			current_sex_skill_oral = clampi(value, 0, max_sex_skill_oral)

var base_sex_skill_anal: int = 0 :
	set(value):
		if enabled:
			base_sex_skill_anal = clampi(value, 0, max_sex_skill_anal)
			max_sex_skill_anal = ActorLibs.calculate_skilli(base_sex_skill_anal, mod_sex_skill_anal, mult_sex_skill_anal)
var mod_sex_skill_anal: int = 0 :
	set(value):
		if enabled:
			mod_sex_skill_anal = value
			max_sex_skill_anal = ActorLibs.calculate_skilli(base_sex_skill_anal, mod_sex_skill_anal, mult_sex_skill_anal)
var mult_sex_skill_anal: float = 1.0 :
	set(value):
		if enabled:
			mult_sex_skill_anal = value
			max_sex_skill_anal = ActorLibs.calculate_skilli(base_sex_skill_anal, mod_sex_skill_anal, mult_sex_skill_anal)
var max_sex_skill_anal: int = 0 :
	set(value):
		if enabled:
			max_sex_skill_anal = maxi(value, 0)
var current_sex_skill_anal: int = 0 :
	set(value):
		if enabled:
			current_sex_skill_anal = clampi(value, 0, max_sex_skill_anal)

var base_sex_skill_vaginal: int = 0 :
	set(value):
		if enabled:
			base_sex_skill_vaginal = clampi(value, 0, max_sex_skill_vaginal)
			max_sex_skill_vaginal = ActorLibs.calculate_skilli(base_sex_skill_vaginal, mod_sex_skill_vaginal, mult_sex_skill_vaginal)
var mod_sex_skill_vaginal: int = 0 :
	set(value):
		if enabled:
			mod_sex_skill_vaginal = value
			max_sex_skill_vaginal = ActorLibs.calculate_skilli(base_sex_skill_vaginal, mod_sex_skill_vaginal, mult_sex_skill_vaginal)
var mult_sex_skill_vaginal: float = 1.0 :
	set(value):
		if enabled:
			mult_sex_skill_vaginal = value
			max_sex_skill_vaginal = ActorLibs.calculate_skilli(base_sex_skill_vaginal, mod_sex_skill_vaginal, mult_sex_skill_vaginal)
var max_sex_skill_vaginal: int = 0 :
	set(value):
		if enabled:
			max_sex_skill_vaginal = maxi(value, 0)
var current_sex_skill_vaginal: int = 0:
	set(value):
		if enabled:
			current_sex_skill_vaginal = clampi(value, 0, max_sex_skill_vaginal)

var base_sex_damage_dealt: float = 1.0 :
	set(value):
		if enabled:
			base_sex_damage_dealt = maxf(value, 0.0)
			sex_damage_dealt = ActorLibs.calculate_skilli(base_sex_damage_dealt, mod_sex_damage_dealt, mult_sex_damage_dealt)
var mod_sex_damage_dealt: float = 0.0 :
	set(value):
		if enabled:
			mod_sex_damage_dealt = value
			sex_damage_dealt = ActorLibs.calculate_skilli(base_sex_damage_dealt, mod_sex_damage_dealt, mult_sex_damage_dealt)
var mult_sex_damage_dealt: float = 1.0:
	set(value):
		if enabled:
			mult_sex_damage_dealt = value
			sex_damage_dealt = ActorLibs.calculate_skilli(base_sex_damage_dealt, mod_sex_damage_dealt, mult_sex_damage_dealt)
var sex_damage_dealt: float = 0:
	set(value):
		if enabled:
			sex_damage_dealt = maxf(value, 0.0)

var base_sex_damage_received: float = 1.0 :
	set(value):
		if enabled:
			base_sex_damage_received = maxf(value, 0.0)
			sex_damage_received = ActorLibs.calculate_skilli(base_sex_damage_received, mod_sex_damage_received, mult_sex_damage_received)
var mod_sex_damage_received: float = 0.0:
	set(value):
		if enabled:
			mod_sex_damage_received = value
			sex_damage_received = ActorLibs.calculate_skilli(base_sex_damage_received, mod_sex_damage_received, mult_sex_damage_received)
var mult_sex_damage_received: float = 1.0:
	set(value):
		if enabled:
			mult_sex_damage_received = value
			sex_damage_received = ActorLibs.calculate_skilli(base_sex_damage_received, mod_sex_damage_received, mult_sex_damage_received)
var sex_damage_received: float = 0:
	set(value):
		if enabled:
			sex_damage_received = maxf(value, 0.0)

# Goes from 0 to 100. When at 100 the orgasm signal will be sent. The vitality module should handle
# the cum effects & calculations and also run the cum() function in this object to calculate current_arousal change.
var orgasm_buildup: int = 0 :
	set(value):
		orgasm_buildup = clampi(value, 0, 100)
		if orgasm_buildup == 100 and can_cum:
			orgasm_signal.emit()

# Cum
var can_cum: bool = true
var orgasm_counter: int = 0
var orgasm_counter_effect: int = 0

# Sexual Endurance
var max_sexual_endurance: int = 100 :
	set(value):
		max_sexual_endurance = maxi(value, 0)
var current_sexual_endurance: int = 0:
	set(value):
		if enabled:
			current_sexual_endurance = clampi(value, 0, max_sexual_endurance) 

# Lust
var max_lust: int = 100 :
	set(value):
		max_lust = maxi(value, 1)
var previous_lust: int
var current_lust: int = 0:
	set(value):
		previous_lust = current_lust
		current_lust = clampi(value, 0, max_lust)
		if previous_lust != current_lust:
			if change_self_with_lust:
				SexLibs.change_stats_with_lust(_health_module, _skill_module, self)
			elif _health_module or _skill_module:
				SexLibs.change_stats_with_lust(_health_module, _skill_module, null)

# Arousal
var max_arousal: int = 100 :
	set(value):
		max_arousal = maxi(value, 1)
var current_arousal: int :
	set(value):
		current_arousal = clampi(value, 0, max_arousal)

# Used to exectue a highly damaging lewd skill
var base_sex_limit_break: int = 1:
	set(value):
		if enabled:
			base_sex_limit_break = maxi(value, 1)
			max_sex_limit_break = ActorLibs.calculate_skilli(base_sex_limit_break, mod_sex_limit_break, mult_sex_limit_break)
var mod_sex_limit_break: int = 0:
	set(value):
		if enabled:
			mod_sex_limit_break = value
			max_sex_limit_break = ActorLibs.calculate_skilli(base_sex_limit_break, mod_sex_limit_break, mult_sex_limit_break)
var mult_sex_limit_break: float = 1.0:
	set(value):
		if enabled:
			mult_sex_limit_break = value
			max_sex_limit_break = ActorLibs.calculate_skilli(base_sex_limit_break, mod_sex_limit_break, mult_sex_limit_break)
var max_sex_limit_break: int = 1 :
	set(value):
		max_sex_limit_break = maxi(value, 1)
		if max_sex_limit_break < current_sex_limit_break:
			current_sex_limit_break = max_sex_limit_break
var current_sex_limit_break: int = 0 :
	set(value):
		current_sex_limit_break = clampi(value, 0, max_sex_limit_break)


func cum() -> void:
	if actor_sex_role == ActorProperties.SexRole.BOTTOM:
		current_arousal += GameProperties.Arousal_Change_Bottoms[clampi(orgasm_counter_effect, 0, 9)]
	elif actor_sex_role == ActorProperties.SexRole.TOP:
		current_arousal += GameProperties.Arousal_Change_Tops[clampi(orgasm_counter_effect, 0, 9)]

	orgasm_counter_effect += 1
	orgasm_counter += 1


func full_restore() -> void:
	current_sexual_endurance = max_sexual_endurance
