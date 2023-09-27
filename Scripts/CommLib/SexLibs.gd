extends Node


# Aroused bottoms can return damage back to attacker
func get_bottom_sex_damage_return(SexDamage: int, Arousal: int, MaxArousal: float) -> int:
	return floori(SexDamage * (Arousal / MaxArousal))


func calculate_sex_damage(SkillAttacker: ActorProperties.SexSkillTypes, VitalityAttacker: VitalityHorny, SkillDefender: ActorProperties.SexSkillTypes, VitalityDefender: VitalityHorny):
	var attack_skill: int = ActorProperties.get_sex_skill(SkillAttacker, VitalityAttacker)
	var defense_skill: int = ActorProperties.get_sex_skill(SkillDefender, VitalityDefender)
	var return_damage: int
		
	return_damage = ceili(maxf(attack_skill - defense_skill, 1) * VitalityAttacker.sex_damage_dealt * VitalityDefender.sex_damage_received)

	return maxi(return_damage, 0)


## If a relevant lust level exist, it'll return the key, otherwise it'll return "-1"
func get_lust_effect_key(LustAmount: int) -> String:
	var _return_key: int = -1
	
	for lust_key in Game.lust_effects.keys():
		if lust_key != "per-level":
			if int(lust_key) <= LustAmount:
				_return_key = int(lust_key)

	return str(_return_key)


func get_lust_effect_steps(CurrentLust: int, PreviousLust: int) -> Dictionary:
	var _return_steps: Dictionary = {}
	var _prev_lust = PreviousLust
	var _step_add: int = 0
	var _horny_target: int = CurrentLust - PreviousLust
	
	if 0 < _horny_target:
		_step_add = 1
	elif _horny_target < 0:
		_step_add = -1
	
	for step in range(abs(_horny_target)):
		var _lust_key: String = get_lust_effect_key(_prev_lust)
		
		if _lust_key != "-1":
			if _lust_key not in _return_steps:
				_return_steps[_lust_key] = 0
			
			_return_steps[_lust_key] += _step_add
		_prev_lust = move_toward(_prev_lust, CurrentLust, 1)
	
	return _return_steps


func get_lust_stat_changef(StatType: String, CurrentLust: int, PrevLust: int) -> float:
	var _return_value: float = 0
	
	var _lust_effect_steps: Dictionary = get_lust_effect_steps(CurrentLust, PrevLust)
	
	for lust_number in _lust_effect_steps.keys():
		if StatType in Game.lust_effects[lust_number]:
			_return_value += Game.lust_effects[lust_number][StatType] * _lust_effect_steps[lust_number]
	
	if StatType in Game.lust_effects["per-level"]:
		_return_value += Game.lust_effects["per-level"][StatType] * (CurrentLust - PrevLust)

	return _return_value


func get_lust_stat_changei(StatType: String, CurrentLust: int, PrevLust: int) -> int:
	var _return_value: int = 0
	
	var _lust_effect_steps: Dictionary = get_lust_effect_steps(CurrentLust, PrevLust)
	
	for lust_number in _lust_effect_steps.keys():
		if StatType in Game.lust_effects[lust_number]:
			_return_value += Game.lust_effects[lust_number][StatType] * _lust_effect_steps[lust_number]
	
	if StatType in Game.lust_effects["per-level"]:
		_return_value += Game.lust_effects["per-level"][StatType] * (CurrentLust - PrevLust)

	return _return_value

