## This mini-module is used by effects to alter change_base_value-related values.
extends MiniModuleEffect
class_name EffectStrength

## Change base value by this amount. Per second if apply_once is disabled.
var change_base_value: int = 0
var change_base_value_by_percentage: float = 0.0:
	set(value):
		change_max_value_by_percentage = clampf(value, -1.0, 1.0)

## Change max value by this amount. Per second if apply_once is disabled.
var change_max_value: int = 0
## Change max stat by percentage of max stat.
var change_max_value_by_percentage: float = 0.0:
	set(value):
		change_max_value_by_percentage = clampf(value, -1.0, 1.0)
## Change max stat by multiplying it by this amount.
var change_max_value_by_multiplier: float = 1.0 :
	set(value):
		change_max_value_by_multiplier = clampf(value, 0.0, 1.0)


var _tracker_base_value: int = 0
var _tracker_max_value: int = 0
var _tracker_value_multiplier: float = 1.0

# used to calculate values by delta. Prevents several multiplications.
var _calc_variable: float = 0.0


func _start_effect() -> void:
	if apply_custom_effect_first:
		on_start_effect()
	
	if apply_once and not apply_custom_effects_only:
		if change_base_value != 0:
				target_vitality.base_strenght += change_base_value
				if revert_on_end:
					_tracker_base_value += change_base_value
		
		if 0.0 < change_base_value_by_percentage:
			_calc_variable = change_max_value_by_percentage * float(target_vitality.base_strenght)
			target_vitality.base_strenght += floori(_calc_variable)
			
			if revert_on_end:
				_tracker_base_value += floori(_calc_variable)
		
		if change_max_value != 0:
			if apply_to == 0: # Apply to base
				target_vitality.max_strenght += change_max_value
			elif apply_to == 1: # Mod value
				target_vitality.mod_strength += change_max_value

			if revert_on_end:
				_tracker_max_value += change_max_value
		
		if 0 < change_max_value_by_percentage:
				_calc_variable = float(target_vitality.max_strenght) * change_max_value_by_percentage
				
				if apply_to == 0:
					target_vitality.max_strenght += floori(_calc_variable)
				elif apply_to == 1:
					target_vitality.mod_strength += floori(_calc_variable)
				
				if revert_on_end:
					_tracker_max_value += floori(_calc_variable)
	
	if not apply_custom_effects_only:
		if change_max_value_by_multiplier < 1.0:
			target_vitality.mult_strength.append(change_max_value_by_multiplier)
			target_vitality.update_max_strength()
			
			if revert_on_end:
				_tracker_value_multiplier = change_max_value_by_multiplier

	if not apply_custom_effect_first:
		on_start_effect()


func _apply_effect(Delta: float):
	if apply_custom_effect_first and not apply_once:
		on_apply_effect(Delta)
		
	if not apply_once and not apply_custom_effects_only:
		if change_base_value != 0:
			_calc_variable = float(change_base_value) * Delta
			target_vitality.base_strenght += floori(_calc_variable)
			if revert_on_end:
				_tracker_base_value += floori(_calc_variable)

		if 0 < change_base_value_by_percentage:
			_calc_variable = change_base_value_by_percentage * float(target_vitality.base_strenght) * Delta
			target_vitality.base_strenght += floori(_calc_variable)

			if revert_on_end:
				_tracker_base_value += floori(_calc_variable)

		if change_max_value != 0:
			_calc_variable = float(change_max_value) * Delta
			if apply_to == 0: # Apply to base
				target_vitality.max_strenght += floori(_calc_variable)
			elif apply_to == 1: # Mod value
				target_vitality.mod_strength += floori(_calc_variable)

			if revert_on_end:
				_tracker_max_value += floori(_calc_variable)
		
		if change_max_value_by_percentage != 0:
			_calc_variable = float(target_vitality.max_strenght) * change_max_value_by_percentage * Delta
			
			if apply_to == 0: # Apply to base
				target_vitality.max_strenght += floori(_calc_variable)
			elif apply_to == 1: # Mod value
				target_vitality.mod_strength += floori(_calc_variable)

			if revert_on_end:
				_tracker_max_value += floori(_calc_variable)
		
		if not apply_custom_effect_first:
			on_apply_effect(Delta)


func _end_effect():
	if apply_custom_effect_first:
		on_end_effect()
	
	if revert_on_end and not apply_custom_effects_only:
		if _tracker_base_value != 0:
			target_vitality.base_strenght -= _tracker_base_value
		
		if _tracker_max_value != 0:
			if apply_to == 0:
				target_vitality.max_strenght -= _tracker_max_value
			elif apply_to == 1:
				target_vitality.mod_strength -= _tracker_max_value
		
		if _tracker_value_multiplier != 1.0:
			target_vitality.mult_strength.erase(_tracker_value_multiplier)
			target_vitality.update_max_strength()

	if not apply_custom_effect_first:
		on_end_effect()

