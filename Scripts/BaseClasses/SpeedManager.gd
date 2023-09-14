extends Node
class_name SpeedManager

## When a new terrain move mult is set, it first checks this, if found it sets it, if not
## it checks on the global on GameProperties, if not there either it doesn't sets it.
var TerrainMoveMult: Dictionary = {}

# If set other than 0 then when getting acceleration it'll limit the value
# to the one set
var max_speed: float = 0.0 :
	set(value): 
		max_speed = absf(value)

# Modifiers
## Speed modifier. This value will be directly added to the actor speed.
var speed_mod: float = 0.0
## Speed modifier. Actor speed will be multiplied by this amount after all other operations
var speed_mult: float = 1.0 :
		set(value):
			speed_mult = absf(value)
var _terrain_mod: float = 1.0


func add_speed_mod(AddSpeed: float) -> void:
	speed_mod += AddSpeed


func add_speed_mult(AddSpeedMult: float) -> void:
	speed_mult += AddSpeedMult


func reset_speed(ResetModifier: bool = true, ResetMultiplier: bool = true) -> void:
	if ResetModifier:
		speed_mod = 0.0
	if ResetMultiplier:
		speed_mult = 1.0


func get_new_velocity(CurrentSpeed: float, MaxSpeed: float, AccelPerSec: float, Friction: float, Delta: float):# -> float:
	var _max_speed: float
	var _accel_rate: float

	_max_speed = ((MaxSpeed + speed_mod) * speed_mult) * _terrain_mod
	
	if max_speed != 0.0:
		_max_speed = clampf(_max_speed, 0.0, max_speed)
	
	if CurrentSpeed != _max_speed:
		
		if _max_speed < CurrentSpeed:
			_accel_rate = Friction * Delta
		else:
			_accel_rate = AccelPerSec * Delta
			
		return move_toward(CurrentSpeed, _max_speed, _accel_rate)
	else:
		return _max_speed


func set_terrain(TerrainID: GameProperties.TerrainState):
	if str(TerrainID) in TerrainMoveMult:
		_terrain_mod = TerrainMoveMult[str(TerrainID)]
	elif str(TerrainID) in GameProperties.TerrainMoveMult:
		_terrain_mod = GameProperties.TerrainMoveMult[str(TerrainID)]


func set_override_terrain_mult(TerrainOverride: float) -> void:
	_terrain_mod = TerrainOverride

