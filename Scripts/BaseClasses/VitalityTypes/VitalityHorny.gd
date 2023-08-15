extends Node
class_name VitalityHorny

signal orgasm_signal

# Signal for elements that are to be displayed in-game
signal arousal_change(NewCurrentAmount, MaxAmount)
signal cum_meter_change(NewAmount, MaxAmount)
signal sex_limit_break_change(NewCurrentAmount, MaxAmount)

var enabled: bool = true

var parent_module: ModuleVitality

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
			sex_damage_dealt = ActorLibs.calculate_skillf(base_sex_damage_dealt, mod_sex_damage_dealt, mult_sex_damage_dealt)
var mod_sex_damage_dealt: float = 0.0 :
	set(value):
		if enabled:
			mod_sex_damage_dealt = value
			sex_damage_dealt = ActorLibs.calculate_skillf(base_sex_damage_dealt, mod_sex_damage_dealt, mult_sex_damage_dealt)
var mult_sex_damage_dealt: float = 1.0:
	set(value):
		if enabled:
			mult_sex_damage_dealt = value
			sex_damage_dealt = ActorLibs.calculate_skillf(base_sex_damage_dealt, mod_sex_damage_dealt, mult_sex_damage_dealt)
var sex_damage_dealt: float = 0:
	set(value):
		if enabled:
			sex_damage_dealt = maxf(value, 0.0)

var base_sex_damage_received: float = 1.0 :
	set(value):
		if enabled:
			base_sex_damage_received = maxf(value, 0.0)
			sex_damage_received = ActorLibs.calculate_skillf(base_sex_damage_received, mod_sex_damage_received, mult_sex_damage_received)
var mod_sex_damage_received: float = 0.0:
	set(value):
		if enabled:
			mod_sex_damage_received = value
			sex_damage_received = ActorLibs.calculate_skillf(base_sex_damage_received, mod_sex_damage_received, mult_sex_damage_received)
var mult_sex_damage_received: float = 1.0:
	set(value):
		if enabled:
			mult_sex_damage_received = value
			sex_damage_received = ActorLibs.calculate_skillf(base_sex_damage_received, mod_sex_damage_received, mult_sex_damage_received)
var sex_damage_received: float = 0:
	set(value):
		if enabled:
			sex_damage_received = maxf(value, 0.0)

# Goes from 0 to 100. When at 100 the orgasm signal will be sent. The vitality module should handle
# the cum effects & calculations and also run the cum() function in this object to calculate current_arousal change.
var cum_threshold: int = 100:
	set(value):
		if enabled:
			cum_threshold = maxi(value, 1)
			cum_meter_change.emit(cum_meter, cum_threshold)
var cum_meter: int = 0 :
	set(value):
		if enabled:
			cum_meter = maxi(value, 0)
			cum_meter_change.emit(cum_meter, cum_threshold)

# Value to add to cum progress is multiplied by cum_gain_mult. 
var cum_gain_mult: float = 1.0 :
	set(value):
		if enabled:
			cum_gain_mult = value
# This value gets added to cum_gain_mult every-time a cum event is triggered. Making it easier or harder
# to reach climax next time.
# For tops a 0.25 is planned. For bottoms a -0.1 is planned
var cum_gain_mult_change: float = 0.0 :
	set(value):
		if enabled:
			cum_gain_mult_change = value

# Cum
var can_cum: bool = true :
	set(value):
		if enabled:
			can_cum = value
var orgasm_counter: int = 0 :
	set(value):
		if enabled:
			orgasm_counter = value
var orgasm_counter_effect: int = 0 :
	set(value):
		if enabled:
			orgasm_counter_effect = value

# Sexual Endurance
var base_sexual_endurance: int = 0 :
	set(value):
		if enabled:
			base_sexual_endurance = value
			max_sexual_endurance = base_sexual_endurance + mod_sexual_endurance
var max_sexual_endurance: int = 0 :
	set(value):
		if enabled:
			max_sexual_endurance = maxi(value, 0)
var mod_sexual_endurance: int = 0 :
	set(value):
		if enabled:
			mod_sexual_endurance = value
			max_sexual_endurance = base_sexual_endurance + mod_sexual_endurance
var current_sexual_endurance: int = 0:
	set(value):
		if enabled:
			current_sexual_endurance = clampi(value, 0, max_sexual_endurance) 

# Lust
var max_lust: int = 100 :
	set(value):
		if enabled:
			max_lust = maxi(value, 1)
var previous_lust: int :
	set(value):
		if enabled:
			previous_lust = value
var current_lust: int = 0:
	set(value):
		if enabled:
			previous_lust = current_lust
			current_lust = clampi(value, 0, max_lust)
			if change_self_with_lust:
				trigger_lust_stats_change()

# Arousal
var max_arousal: int = 100 : # Has no lust integration
	set(value):
		if enabled:
			max_arousal = maxi(value, 1)
			arousal_change.emit(current_arousal, max_arousal)
var current_arousal: int :
	set(value):
		if enabled:
			current_arousal = clampi(value, 0, max_arousal)
			arousal_change.emit(current_arousal, max_arousal)

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
		if enabled:
			max_sex_limit_break = maxi(value, 1)
			if max_sex_limit_break < current_sex_limit_break:
				current_sex_limit_break = max_sex_limit_break
			sex_limit_break_change.emit(current_sex_limit_break, max_sex_limit_break)
var current_sex_limit_break: int = 0 :
	set(value):
		if enabled:
			current_sex_limit_break = clampi(value, 0, max_sex_limit_break)
			sex_limit_break_change.emit(current_sex_limit_break, max_sex_limit_break)


func progress_cum_meter(ProgressAmount: int) -> void:
	cum_meter += floori(ProgressAmount * cum_gain_mult)


func cum() -> void:
	if actor_sex_role == ActorProperties.SexRole.BOTTOM:
		current_arousal += (GameProperties.Arousal_Clearing_Penalty_Bottoms * orgasm_counter_effect) - 100
	elif actor_sex_role == ActorProperties.SexRole.TOP:
		current_arousal += (GameProperties.Arousal_Clearing_Penalty_Tops * orgasm_counter_effect) - 100
	
	cum_meter = 0
	
	var cum_times: int = cum_meter / cum_threshold
	
	orgasm_counter_effect += cum_times
	orgasm_counter += cum_times
	cum_gain_mult += cum_gain_mult_change * cum_times


func full_restore() -> void:
	current_sexual_endurance = max_sexual_endurance


# This method holds all the stats that have changes with lust implemented. To implement new, add then here
# and adjust the variable set() method. a mod_X variable is reccomended so that the original value isn't lost.
func trigger_lust_stats_change() -> void:
	mod_sex_skill_anal += SexLibs.get_stat_with_lusti("sex-skill-anal", current_lust, previous_lust)
	mod_sex_skill_oral += SexLibs.get_stat_with_lusti("sex-skill-penis", current_lust, previous_lust)
	mod_sex_skill_penis += SexLibs.get_stat_with_lusti("sex-skill-penis", current_lust, previous_lust)
	mod_sex_skill_vaginal += SexLibs.get_stat_with_lusti("sex-skill-vaginal", current_lust, previous_lust)
	
	mod_sex_damage_dealt += SexLibs.get_stat_with_lustf("sex-damage-dealt", current_lust, previous_lust)
	mod_sex_damage_received += SexLibs.get_stat_with_lustf("sex-damage-dealt", current_lust, previous_lust)
	
	mod_sexual_endurance += SexLibs.get_stat_with_lusti("sexual-endurance", current_lust, previous_lust)
	
	mod_sex_limit_break += SexLibs.get_stat_with_lusti("sex-limit-break", current_lust, previous_lust)

