extends Node
class_name SpeedManager

@export var self_terrain_move_mod: Dictionary = {}

@export var max_speed: float = 0.0 :
	set(value): 
		max_speed = maxf(value, 0.0)
		_update_total_speed()

var speed_mod: float = 0.0:
	set(value):
		speed_mod = value
		_update_total_speed()
var speed_mult: float = 1.0 :
		set(value):
			speed_mult = maxf(value, 0.0)
			_update_total_speed()
var _terrain_mod: float = 1.0:
	set(value):
		_terrain_mod = maxf(value, 0.0)
		_update_total_speed()
var _total_speed = 0.0

@export var acceleration_rate: float = 1.0
@export var friction_rate: float = 1.0

var node_owner: Actor


func change_actor_speed(AxisDirection: float, Delta: float) -> void:
	if AxisDirection == 0.0 and node_owner.velocity.x == 0.0:
		return
	
	node_owner.velocity.x = move_toward(node_owner.velocity.x, _total_speed * AxisDirection, get_accel_change(AxisDirection, node_owner.velocity.x) * Delta)


func get_accel_change(AxisValue: float, SpeedValue: float):
	if SpeedValue == 0.0 or (0 < AxisValue) == (0 < SpeedValue): # If going from non-moving to moving or control direction == moving direction
		return acceleration_rate
	elif AxisValue == 0.0: # If going from moving to non-moving
		return friction_rate
	else: # If going from moving to 1 direction to the opposite
		return (acceleration_rate / 3) + friction_rate
	

func _update_total_speed() -> void:
	_total_speed = maxf(((max_speed + speed_mod) * speed_mult) * _terrain_mod, 0.0)


func set_terrain_mult_by_name(TerrainName: String):
	if TerrainName in self_terrain_move_mod:
		_terrain_mod = self_terrain_move_mod[TerrainName]
	elif TerrainName in GameProperties.TerrainMoveMult:
		_terrain_mod = GameProperties.TerrainMoveMult[TerrainName]


func add_terrain_modifier(TerrainName: String, TerrainModifier: float) -> void:
	self_terrain_move_mod[TerrainName] = maxf(TerrainModifier, 0.0)

