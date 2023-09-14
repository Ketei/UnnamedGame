extends Node

func get_speed_tracker() -> SpeedManager:
	return SpeedManager.new()


## Useful to calculate damage. The attacker MUST have a combat module.
func calculate_damage_with_combat(AttackerCombat: VitalityCombat, DefenderCombat: VitalityCombat = null) -> int:
	var _return_damage: int = 0
	
	var _damage : float = 0
	var _resistance: float = 0
	
	for attack_type in AttackerCombat.attack_types.keys():
		if GameProperties.AttackTypes[attack_type] == GameProperties.DamageTypes.PHYSICAL:
			_damage = ActorLibs.calculate_statf(AttackerCombat.attack_types[attack_type] + AttackerCombat.skill_damage_physical, AttackerCombat.mod_damage_physical, AttackerCombat.mult_damage_physical)
			if DefenderCombat:
				_resistance = DefenderCombat.defense_physical
		elif GameProperties.AttackTypes[attack_type] == GameProperties.DamageTypes.MAGICAL:
			_damage = ActorLibs.calculate_statf(AttackerCombat.attack_types[attack_type] + AttackerCombat.skill_change_damage_magical, AttackerCombat.mod_damage_magical, AttackerCombat.mult_damage_magical)
			if DefenderCombat:
				_resistance = DefenderCombat.defense_magical
		elif GameProperties.AttackTypes[attack_type] == GameProperties.DamageTypes.TRUE:
			_damage = AttackerCombat.attack_types[attack_type]
			_resistance = 0
		
		if attack_type in AttackerCombat.affinities:
			_damage += AttackerCombat.affinities[attack_type] * _damage
		
		if DefenderCombat:
			if attack_type in DefenderCombat.resistances:
				_damage -= DefenderCombat.resistances[attack_type] * _damage
		
		_return_damage += maxi(roundi(_damage - _resistance), 0)
	
	return _return_damage


func calculate_statf(BaseStat: float, ModStat: float, MultStat: float) -> float:
	return floorf((BaseStat + ModStat) * MultStat)


func calculate_stati(BaseStat: float, ModStat: float, MultStat: float) -> int:
	return floori(float(BaseStat + ModStat) * MultStat)
