extends CharacterBody2D
class_name Actor

# Double # comments are for the UI tooltip OR the documentation. That's how godot
# builds documentation on CUSTOM CLASSES. This explanation is because
# SOMEONE keeps nagging me that comments in code should be avoided.

# enums
enum GravityMode {NORMAL, JUMP, ZERO}

@export_category("Actor Properties")
@export var actor_name: String = ""
@export var actor_type: ActorProperties.ActorType
@export var actor_gender: ActorProperties.Gender
@export var actor_sprite: Sprite2D = null

@export_category("Ground Movement")
## Any terrain change will be checked here first, then on GameProperties.
@export var self_terrain_move_mod: Dictionary = {}
@export var run_speed: float = 0.0: 
	set(value) :
		run_speed = maxf(value, 0.0) * GameProperties.grid_size
@export var walk_speed: float = 0.0 : 
	set(value) :
		walk_speed = maxf(value, 0.0) * GameProperties.grid_size
## How much time in seconds will it take the actor to reach max speed
@export var acceleration: float = 0.0 : 
	set(value) :
		acceleration = maxf(value, 0.0)
## How much time in seconds will it take the actor to come to a stop
@export var friction: float = 0.0 : 
	set(value) :
		friction = maxf(value, 0.0)
@export var climb_base_speed: float = 0.0 : 
	set(value) :
		climb_base_speed = maxf(value, 0.0) * GameProperties.grid_size
@export var crouch_speed: float = 0.0 :
	set(value):
		crouch_speed = maxf(value, 0.0)
@export var swim_speed: float = 0.0

@export_category("Air Movement")
## If this value is updated and have a gravity module, be sure to update it too.
@export var jump_height: float = 0.0:
	set(value):
		jump_height = value * GameProperties.grid_size
		jump_velocity = QuickMath.get_jump_velocity(jump_height, time_to_peak)
		_update_gravity()
## How fast in seconds should you reach the floor after jumping. If this value
## is updated and have a gravity module, be sure to update it too.
@export var time_to_floor: float = 0.0:
	set(value):
		time_to_floor = maxf(value, 0.0)
		_update_gravity()
## How fast in seconds should you reach the peak of a jump. If this value
## is updated and have a gravity module, be sure to update it too.
@export var time_to_peak: float = 0.0:
	set(value):
		time_to_peak = maxf(value, 0.0)
		jump_velocity = QuickMath.get_jump_velocity(jump_height, time_to_peak)
		_update_gravity()
@export var air_jumps: int = 0 :
	set(value):
		air_jumps = maxi(value, 0)
@export var air_acceleration: float = 0.0:
	set(value):
		air_acceleration = maxf(value, 0.0)
@export var air_friction = 0.0:
	set(value):
		air_friction = maxf(value, 0.0)

# Toggles
var is_gravity_enabled: bool = true
var can_jump: bool = true
var is_walking: bool = false
var is_crouching: bool = false
var is_swimming: bool = false
var is_on_air: bool = false

# Horizontal Movement
var speed_mod: float = 0.0:
	set(value):
		speed_mod = value
var speed_mult: float = 1.0 :
		set(value):
			speed_mult = maxf(value, 0.0)
var _terrain_mod: float = 1.0:
	set(value):
		_terrain_mod = maxf(value, 0.0)

# Tracker
var air_jump_count: int = 0

# References
var module_manager: ModuleManager

@onready var jump_velocity: float = QuickMath.get_jump_velocity(jump_height, time_to_peak)


func change_actor_speed(AxisDirection: float, Delta: float) -> void:
	if AxisDirection == 0.0 and velocity.x == 0.0:
		return

	velocity.x = move_toward(velocity.x, _get_speed() * AxisDirection, _get_accel_change(AxisDirection, velocity.x, _get_speed()) * Delta )


## I need to do something for air control
func _get_accel_change(AxisValue: float, CurrentSpeed: float, MaxSpeed: float) -> float:
	var _is_accelerating: bool = (AxisValue != 0) and (QuickMath.are_numbers_same_poles(AxisValue, CurrentSpeed))
	var _speed_change: float = 0.0
	
	if not is_on_air:
		if _is_accelerating:
			_speed_change = acceleration
			if MaxSpeed < abs(CurrentSpeed):
				_speed_change *= 1.5
		else:
			_speed_change = friction
	else:
		if AxisValue == 0:
			_speed_change = air_friction
		else:
			_speed_change = air_acceleration
	
	return QuickMath.get_acceleration(_speed_change, MaxSpeed)


func get_acceleration() -> float:
	if is_on_air:
		return air_acceleration
	else:
		return acceleration


func get_friction() -> float:
	if is_on_air:
		return air_friction
	else:
		return friction


func _get_speed() -> float:
	var base_speed: float
	
	if is_swimming:
		base_speed = swim_speed
	elif  is_crouching:
		base_speed = crouch_speed
	elif is_walking:
		base_speed = walk_speed
	else:
		base_speed = run_speed
	
	return maxf(((base_speed + speed_mod) * speed_mult) * _terrain_mod, 0.0)


func set_terrain_mult_by_name(TerrainName: String):
	if TerrainName in self_terrain_move_mod:
		_terrain_mod = self_terrain_move_mod[TerrainName]
	elif TerrainName in GameProperties.TerrainMoveMult:
		_terrain_mod = GameProperties.TerrainMoveMult[TerrainName]


func add_terrain_modifier(TerrainName: String, TerrainModifier: float) -> void:
	self_terrain_move_mod[TerrainName] = maxf(TerrainModifier, 0.0)


func set_facing_right(FacingRight: bool = true) -> void:
	if FacingRight and actor_sprite.flip_h:
		actor_sprite.flip_h = false
	elif not FacingRight and not actor_sprite.flip_h:
		actor_sprite.flip_h = true


func update_facing_right() -> void:
	if not actor_sprite:
		return
	
	if velocity.x < 0 and not actor_sprite.flip_h:
		actor_sprite.flip_h = true
	elif 0 < velocity.x and actor_sprite.flip_h:
		actor_sprite.flip_h = false


func jump(JumpFromGround: bool, JumpForce: float = jump_velocity) -> void:
	if not JumpFromGround:
		air_jump_count += 1
	
	if JumpForce < velocity.y:
		velocity.y = JumpForce
	
	# This part is experimental. It gives a boost on air jumps to give more air control
	# Might remain, might go. Who knows? Me not yet.


func can_actor_jump(IsOnGround := true) -> bool:
	if not can_jump:
		return false
	
	if IsOnGround:
		return true
	
	return (air_jump_count < air_jumps) # Does actor have remaining air jumps?


func toggle_walk() -> void:
	is_walking = not is_walking


func _update_gravity() -> void:
	if not module_manager:
		return
	
	if not module_manager.has_module("gravity-manager"):
		return
	
	module_manager.get_module("gravity-manager").update_gravity_settings()

