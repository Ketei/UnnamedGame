extends Node

func get_speed_tracker() -> SpeedManager:
	return SpeedManager.new()

## Useful to calculate damage considering resitances and endurance.
func calculate_damage(ActorAttack: float, ActorDefense: int, ActorEndurance: int) -> int:
	var _damage: float

	_damage = (ActorAttack * (ActorAttack/(ActorAttack + ActorDefense))) * (1.0 - (ActorEndurance/100.0))
	
	return maxi(ceili(_damage), 1)


func calculate_statf(BaseStat: float, ModStat: float, MultStat: float) -> float:
	return floorf((BaseStat + ModStat) * MultStat)


func calculate_stati(BaseStat: int, ModStat: int, MultStat: float) -> int:
	return floori(float(BaseStat + ModStat) * MultStat)
