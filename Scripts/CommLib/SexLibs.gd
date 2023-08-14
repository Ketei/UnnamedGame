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
	
	for lust_key in GameProperties.lust_effects.keys():
		if lust_key != "per-level":
			if int(lust_key) <= LustAmount:
				_return_key = int(lust_key)

	return str(_return_key)


func get_lust_effect_steps(HornyStats: VitalityHorny) -> Dictionary:
	var _return_steps: Dictionary = {}
	var _prev_lust = HornyStats.previous_lust
	var _step_add: int = 0
	var _horny_target: int = HornyStats.lust - HornyStats.previous_lust
	
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
		_prev_lust = move_toward(_prev_lust, HornyStats.lust, 1)
	
	return _return_steps


# Use arousal - previous arousal to handle per-level increases/decreases
func change_stats_with_lust(VitalityStats: VitalityHealth, SkillStats: VitalitySkill, HornyStats: VitalityHorny) -> void:
	var _lust_steps: int = HornyStats.lust - HornyStats.previous_lust
	var _lust_steps_dict: Dictionary = {}
	var _lust_val_keys: Array = GameProperties.lust_effects.keys()
	var _stat_change: int
	
	_lust_val_keys.erase("per-level")
	
	if HornyStats:
		_lust_steps_dict = get_lust_effect_steps(HornyStats)
	
	if _lust_steps != 0:
		for stat in GameProperties.lust_effects["per-level"].keys():
			_stat_change = _lust_steps * GameProperties.lust_effects["per-level"][stat]
			
			if HornyStats:
				if stat == "arousal":
					HornyStats.arousal += _stat_change
				elif stat == "sex-damage-received":
					HornyStats.sex_damage_received += _lust_steps * GameProperties.lust_effects["per-level"][stat]
				elif stat == "sex-damage-dealt":
					HornyStats.sex_damage_dealt += _lust_steps * GameProperties.lust_effects["per-level"][stat]
				elif stat == "sex-skill":
					for sex_skill in GameProperties.lust_effects["per-level"][stat].keys():
						if sex_skill == "anal":
							HornyStats.mod_sex_skill_anal += _stat_change
						elif sex_skill == "oral":
							HornyStats.mod_sex_skill_oral += _stat_change
						elif sex_skill == "penis":
							HornyStats.mod_sex_skill_penis += _stat_change
						elif sex_skill == "vaginal":
							HornyStats.mod_sex_skill_penis += _stat_change
				elif stat == "sex-endurance":
					HornyStats.max_sexual_endurance += _stat_change
				elif stat == "sex-limit-break":
					HornyStats.max_sex_limit_break += _stat_change

			if SkillStats:
				if stat == "strength":
					SkillStats.mod_strength += _stat_change
				elif stat == "endurance":
					SkillStats.mod_endurance += _stat_change
				elif stat == "charisma":
					SkillStats.mod_charisma += _stat_change
				elif stat == "intelligence":
					SkillStats.mod_intelligence += _stat_change
				elif stat == "luck":
					SkillStats.mod_luck += _stat_change
				elif stat == "defense-physical":
					SkillStats.mod_defense_physical += _stat_change
				elif stat == "defense-magical":
					SkillStats.mod_defense_magical += _stat_change

			if VitalityStats:
				if stat == "health":
					VitalityStats.mod_max_health += _stat_change
				elif stat == "stamina":
					VitalityStats.mod_max_stamina += _stat_change
				elif stat == "mana":
					VitalityStats.mod_max_mana += _stat_change

		for key_effect in _lust_steps_dict.keys():
			for effect_apply in GameProperties.lust_effects[key_effect]:
				_stat_change = GameProperties.lust_effects[key_effect][effect_apply] * _lust_steps_dict[key_effect]
				
				if HornyStats:
					if effect_apply == "arousal":
						HornyStats.arousal += _stat_change
					elif effect_apply == "sex-damage-received":
						HornyStats.sex_damage_received += GameProperties.lust_effects[key_effect][effect_apply] * _lust_steps_dict[key_effect]
					elif effect_apply == "sex-damage-dealt":
						HornyStats.sex_damage_dealt += GameProperties.lust_effects[key_effect][effect_apply] * _lust_steps_dict[key_effect]
					elif effect_apply == "sex-skill":
						for sex_skill in GameProperties.lust_effects["per-level"][effect_apply].keys():
							if sex_skill == "anal":
								HornyStats.mod_sex_skill_anal += _stat_change
							elif sex_skill == "oral":
								HornyStats.mod_sex_skill_oral += _stat_change
							elif sex_skill == "penis":
								HornyStats.mod_sex_skill_penis += _stat_change
							elif sex_skill == "vaginal":
								HornyStats.mod_sex_skill_penis += _stat_change
					elif effect_apply == "sex-endurance":
						HornyStats.max_sexual_endurance += _stat_change
					elif effect_apply == "sex-limit-break":
						HornyStats.max_sex_limit_break += _stat_change

				if SkillStats:
					if effect_apply == "strength":
						SkillStats.mod_strength += _stat_change
					elif effect_apply == "endurance":
						SkillStats.mod_endurance += _stat_change
					elif effect_apply == "charisma":
						SkillStats.mod_charisma += _stat_change
					elif effect_apply == "intelligence":
						SkillStats.mod_intelligence += _stat_change
					elif effect_apply == "luck":
						SkillStats.mod_luck += _stat_change
					elif effect_apply == "defense-physical":
						SkillStats.mod_defense_physical += _stat_change
					elif effect_apply == "defense-magical":
						SkillStats.mod_defense_magical += _stat_change

				if VitalityStats:
					if effect_apply == "health":
						VitalityStats.mod_max_health += _stat_change
					elif effect_apply == "stamina":
						VitalityStats.mod_max_stamina += _stat_change
					elif effect_apply == "mana":
						VitalityStats.mod_max_mana += _stat_change


func get_stat_with_lustf(StatType: String, CurrentLust: int) -> float:
	var _index: String = get_lust_effect_key(CurrentLust)
	var _return_value: float = 0.0

	if _index != "-1":
		if StatType in GameProperties.lust_effects[_index]:
			_return_value += GameProperties.lust_effects[_index]
	
	if StatType in GameProperties.lust_effects["per-level"]:
		_return_value += GameProperties.lust_effects["per-level"][StatType]

	return _return_value


func get_stat_with_lusti(StatType: String, CurrentLust: int) -> int:
	var _index: String = get_lust_effect_key(CurrentLust)
	var _return_value: int = 0

	if _index != "-1":
		if StatType in GameProperties.lust_effects[_index]:
			_return_value += GameProperties.lust_effects[_index]
	
	if StatType in GameProperties.lust_effects["per-level"]:
		_return_value += GameProperties.lust_effects["per-level"][StatType]

	return _return_value
