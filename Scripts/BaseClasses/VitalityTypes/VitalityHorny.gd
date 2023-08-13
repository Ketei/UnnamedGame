extends Node
class_name VitalityHorny

signal orgasm_signal

var enabled: bool = true

var _health_module: VitalityHealth = null
var _skill_module: VitalitySkill = null
var change_self_with_lust: bool = false


var parent_module: ModuleVitality

var actor_sex_role: ActorProperties.SexRole = ActorProperties.SexRole.TOP

# Max Sex Skills
var max_sex_skill_penis: int = 0 :
	set(value):
		if enabled:
			max_sex_skill_penis = maxi(value, 0)

var max_sex_skill_anal: int = 0 :
	set(value):
		if enabled:
			max_sex_skill_anal = maxi(value, 0)

var max_sex_skill_oral: int = 0 :
	set(value):
		if enabled:
			max_sex_skill_oral = maxi(value, 0)

var max_sex_skill_vaginal: int = 0 :
	set(value):
		if enabled:
			max_sex_skill_vaginal = maxi(value, 0)

var max_lust: int = 100 :
	set(value):
		max_lust = maxi(value, 0)

var max_arousal: int = 100 :
	set(value):
		max_arousal = maxi(value, 0)

var max_sexual_endurance: int = 100 :
	set(value):
		max_sexual_endurance = maxi(value, 0)

# Base Sex Skills
## Used for sexual damage/defense calculations.
var base_sex_skill_penis: int = 0:
	set(value):
		if enabled:
			base_sex_skill_penis = clampi(value, 0, max_sex_skill_penis)
			update_max_sex_skill_penis()

var base_sex_skill_anal: int = 0:
	set(value):
		if enabled:
			base_sex_skill_anal = clampi(value, 0, max_sex_skill_anal)
			update_max_sex_skill_anal()

var base_sex_skill_oral: int = 0:
	set(value):
		if enabled:
			base_sex_skill_oral = clampi(value, 0, max_sex_skill_oral)
			update_max_sex_skill_oral()

var base_sex_skill_vaginal: int = 0:
	set(value):
		if enabled:
			base_sex_skill_vaginal = clampi(value, 0, max_sex_skill_vaginal)
			update_max_sex_skill_vaginal()

var sex_skill_penis: int :
	set(value):
		if enabled:
			sex_skill_penis = maxi(value, 0)
var sex_skill_anal: int:
	set(value):
		if enabled:
			sex_skill_anal = maxi(value, 0)
var sex_skill_oral: int:
	set(value):
		if enabled:
			sex_skill_oral = maxi(value, 0)
var sex_skill_vaginal: int:
	set(value):
		if enabled:
			sex_skill_vaginal = maxi(value, 0)

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

var mod_sex_limit_break: int = 0:
	set(value):
		if enabled:
			mod_sex_limit_break = value
			update_max_sex_limit_break()

var mult_sex_skill_penis: float = 1.0:
	set(value):
		if enabled:
			mult_sex_skill_penis = value
			update_max_sex_skill_penis()
var mult_sex_skill_anal: float = 1.0:
	set(value):
		if enabled:
			mult_sex_skill_anal = value
			update_max_sex_skill_anal()
var mult_sex_skill_oral: float = 1.0:
	set(value):
		if enabled:
			mult_sex_skill_oral = value
			update_max_sex_skill_oral()
var mult_sex_skill_vaginal: float = 1.0:
	set(value):
		if enabled:
			mult_sex_skill_vaginal = value
			update_max_sex_skill_vaginal()
var mult_sex_limit_break: float = 1.0:
	set(value):
		if enabled:
			mult_sex_limit_break = value
			update_max_sex_limit_break()

var base_sex_damage_dealt: float = 1.0 :
	set(value):
		if enabled:
			base_sex_damage_dealt = maxf(value, 0.0)
			update_max_damage_dealt()
var mod_sex_damage_dealt: float = 0.0 :
	set(value):
		if enabled:
			mod_sex_damage_dealt = value
			update_max_damage_dealt()
var mult_sex_damage_dealt: float = 1.0:
	set(value):
		if enabled:
			mult_sex_damage_dealt = value
			update_max_damage_dealt()
var sex_damage_dealt: float

var base_sex_damage_received: float = 1.0 :
	set(value):
		if enabled:
			base_sex_damage_received = maxf(value, 0.0)
			update_max_damage_received()
var mod_sex_damage_received: float = 0.0:
	set(value):
		if enabled:
			mod_sex_damage_received = value
			update_max_damage_received()
var mult_sex_damage_received: float = 1.0:
	set(value):
		if enabled:
			mult_sex_damage_received = value
			update_max_damage_received()
var sex_damage_received: float

# Goes from 0 to 100. When at 100 the orgasm signal will be sent. The vitality module should handle
# the cum effects & calculations and also run the cum() function in this object to calculate current_arousal change.
var orgasm_buildup: int = 0 :
	set(value):
		orgasm_buildup = clampi(value, 0, 100)
		if orgasm_buildup == 100:
			orgasm_signal.emit()

var orgasm_counter: int = 0
# Dry cum?
var can_cum: bool = true

var current_sexual_endurance: int = 0:
	set(value):
		if enabled:
			current_sexual_endurance = clampi(value, 0, max_sexual_endurance) 

# Used for current_lust calculations
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

var current_arousal: int :
	set(value):
		current_arousal = clampi(value, 0, max_arousal)

# Used to exectue a highly damaging lewd skill
var base_sex_limit_break: int = 1:
	set(value):
		if enabled:
			base_sex_limit_break = maxi(value, 1)
			update_max_sex_limit_break()

var max_sex_limit_break: int = 1 :
	set(value):
		max_sex_limit_break = maxi(value, 1)
		if max_sex_limit_break < current_sex_limit_break:
			current_sex_limit_break = max_sex_limit_break

var current_sex_limit_break: int :
	set(value):
		current_sex_limit_break = clampi(value, 0, max_sex_limit_break)


func cum(IsBottom: bool):
	var _arousal_increase: int
	if IsBottom:
		_arousal_increase = GameProperties.Arousal_Change_Bottoms[clampi(orgasm_counter, 0, 9)]
	else:
		_arousal_increase = GameProperties.Arousal_Change_Tops[clampi(orgasm_counter, 0, 9)]
	
	
	current_arousal += _arousal_increase
	
	orgasm_counter += 1


func update_max_sex_skill_anal() -> void:
	sex_skill_anal = floori(float(base_sex_skill_anal + mod_sex_skill_anal) * mult_sex_skill_anal)


func update_max_sex_skill_oral() -> void:
	sex_skill_oral = floori(float(base_sex_skill_oral + mod_sex_skill_oral) * mult_sex_skill_oral)


func update_max_sex_skill_penis() -> void:
	sex_skill_penis = floori(float(base_sex_skill_penis + mod_sex_skill_penis) * mult_sex_skill_penis)


func update_max_sex_skill_vaginal() -> void:
	sex_skill_vaginal = floori(float(base_sex_skill_vaginal + mod_sex_skill_vaginal) * mult_sex_skill_vaginal)


func update_max_sex_limit_break() -> void:
	max_sex_limit_break = floori(float(base_sex_limit_break + mod_sex_limit_break) * mult_sex_limit_break)


func update_max_damage_dealt() -> void:
	pass


func update_max_damage_received() -> void:
	pass


func update_all_sex_stats() -> void:
	update_max_sex_skill_anal()
	update_max_sex_skill_oral()
	update_max_sex_skill_penis()
	update_max_sex_skill_vaginal()


func full_restore() -> void:
	current_sexual_endurance = max_sexual_endurance
