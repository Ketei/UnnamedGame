extends CharacterBody2D
class_name Actor

# enums
enum GravityMode {NORMAL, JUMP}
enum MovementSpeed {RUN, WALK, CROUCH}

# General
@export_category("Actor Properties")
@export var display_name: String = ""
@export var actor_type: ActorProperties.ActorType
@export var actor_gender: ActorProperties.Gender
@export var actor_sprite: Sprite2D = null

@export_category("Movement")
@export var self_terrain_move_mod: Dictionary = {}
@export var run_speed: float : 
	set(value) :
		run_speed = maxf(value, 0.0) * ActorProperties.world_grid
@export var walk_speed: float : 
	set(value) :
		walk_speed = maxf(value, 0.0) * ActorProperties.world_grid
@export var acceleration: float = 0.0 : 
	set(value) :
		acceleration = maxf(value, 0.0) * ActorProperties.world_grid
@export var friction: float = 0.0 : 
	set(value) :
		friction = maxf(value, 0.0) * ActorProperties.world_grid
@export var climb_base_speed: float : 
	set(value) :
		climb_base_speed = maxf(value, 0.0) * ActorProperties.world_grid
@export var crouch_speed: float :
	set(value):
		crouch_speed = maxf(value, 0.0)

@export_category("Gravity")
@export var max_gravity: float = 0.0 : 
	set(value) :
		max_gravity = maxf(value, 0.0) * ActorProperties.world_grid
@export var _jump_time_to_floor: float
@export var _jump_time_to_peak: float
@export var _jump_height: float

# Toggles
var is_gravity_enabled: bool = true
var is_walking: bool = false:
	set(value):
		is_walking = value
		_change_movement_status()
var is_crouching: bool = false:
	set(value):
		is_crouching = value
		_change_movement_status()
var movement_status: MovementSpeed = MovementSpeed.RUN

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

# Settings
var gravity: float = 0.0

@onready var jump_velocity = QuickMath.get_jump_velocity(_jump_height, _jump_time_to_peak)
@onready var jump_gravity = QuickMath.get_jump_gravity(_jump_height, _jump_time_to_peak)
@onready var normal_gravity = QuickMath.get_normal_gravity(_jump_height, _jump_time_to_floor)


func change_gravity_mode(NewGravityMode: GravityMode) -> void:
	if NewGravityMode == GravityMode.NORMAL:
		gravity = normal_gravity
	elif NewGravityMode == GravityMode.JUMP:
		gravity = jump_gravity


func apply_gravity(delta: float) -> void:
	if not is_gravity_enabled:
		return
	
	velocity.y = move_toward(velocity.y, max_gravity, velocity.y + (gravity * delta))


func change_actor_speed(AxisDirection: float, Delta: float) -> void:
	if AxisDirection == 0.0 and velocity.x == 0.0:
		return
	
	velocity.x = move_toward(velocity.x, _get_speed() * AxisDirection, _get_accel_change(AxisDirection, velocity.x) * Delta)


func _get_accel_change(AxisValue: float, SpeedValue: float):
	if SpeedValue == 0.0 or (0 < AxisValue) == (0 < SpeedValue): # If going from non-moving to moving or control direction == moving direction
		return acceleration
	elif AxisValue == 0.0: # If going from moving to non-moving
		return friction
	else: # If going from moving to 1 direction to the opposite
		return (acceleration / 3) + friction


func _get_speed() -> float:
	var base_speed: float
	
	if movement_status == MovementSpeed.RUN:
		base_speed = run_speed
	elif movement_status == MovementSpeed.WALK:
		base_speed = walk_speed
	elif movement_status == MovementSpeed.CROUCH:
		base_speed = crouch_speed

	return maxf(((base_speed + speed_mod) * speed_mult) * _terrain_mod, 0.0)


func _change_movement_status() -> void:
	if is_crouching:
		movement_status = MovementSpeed.CROUCH
	elif is_walking:
		movement_status = MovementSpeed.WALK
	else:
		movement_status = MovementSpeed.RUN


func set_terrain_mult_by_name(TerrainName: String):
	if TerrainName in self_terrain_move_mod:
		_terrain_mod = self_terrain_move_mod[TerrainName]
	elif TerrainName in GameProperties.TerrainMoveMult:
		_terrain_mod = GameProperties.TerrainMoveMult[TerrainName]


func add_terrain_modifier(TerrainName: String, TerrainModifier: float) -> void:
	self_terrain_move_mod[TerrainName] = maxf(TerrainModifier, 0.0)


func set_facing_right(FacingRight: bool = true) -> void:
	if not actor_sprite:
		return
	
	if FacingRight and actor_sprite.flip_h:
		actor_sprite.flip_h = false
	elif not FacingRight and not actor_sprite.flip_h:
		actor_sprite.flip_h = true
