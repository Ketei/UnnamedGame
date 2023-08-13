extends Node


func get_jump_velocity(JumpInTiles: float, JumpTimeToPeak: float) -> float:
	if JumpInTiles == 0 or JumpTimeToPeak == 0:
		print_debug("Warning: Missing values or 0.0 provided for actor jump height and time to peak on JumpVelocity")
		print_debug("Warning: get_jump_velocity() cannot be performed successfully. Returning 0.0 instead")
		return 0.0
	else:
		# The +1 comes from the single pixel that is eaten by the floor before jump
		return ((2.0 * ((JumpInTiles * GameProperties.grid_size) + 1)) / JumpTimeToPeak) * -1.0


func get_jump_gravity(JumpInTiles:float, JumpTimeToPeak:float) -> float:
	if JumpInTiles == 0 or JumpTimeToPeak == 0:
		print_debug("Missing values for actor jump height and time to peak on JumpGravity")
		print_debug("Warning: get_jump_gravity() cannot be performed successfully. Returning 0.0 instead")
		return 0.0
	else:
		return ((-2.0 * (JumpInTiles * GameProperties.grid_size)) / pow(JumpTimeToPeak, 2)) * -1.0


func get_normal_gravity(JumpInTiles:float, JumpTimeToFloor:float) -> float:
	if JumpInTiles == 0 or JumpTimeToFloor == 0:
		print_debug("Missing values for actor jump height and time to floor on NormalGravity")
		print_debug("Warning: get_normal_gravity() cannot be performed successfully. Returning 0.0 instead")
		return 0.0
	else:
		return ((-2.0 * (JumpInTiles * GameProperties.grid_size)) / pow(JumpTimeToFloor, 2)) * -1.0

## Checks if the first value is between the two values given. If it is returns true else returns false
func is_between(Value : float, From : float, To : float) -> bool:
	var high_number : float
	var low_number : float
	
	var is_value_between : bool

	if From < To:
		high_number = To
		low_number = From
	else:
		high_number = From
		low_number = To

	if low_number <= Value and Value <= high_number:
		is_value_between = true
	else:
		is_value_between = false
	
	return is_value_between


func calculate_multiplier(MagnitudeList: Array) -> float:
	var current_magnitude: float = 1.0
	
	if 0 < MagnitudeList.size():
		for multiplier in MagnitudeList:
			current_magnitude -= multiplier
	
	return clampf(current_magnitude, 0.0, 1.0)


func fstep_toward_zero(Value: float, Step: float) -> float:
	var direction: float
	
	if Value < 0:
		direction = absf(Step)
	elif 0 < Value:
		direction = -absf(Step)
	else:
		direction = 0.0
	
	return Value + direction
