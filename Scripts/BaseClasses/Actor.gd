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
@export var acceleration: float = 0.0 : 
	set(value) :
		acceleration = maxf(value, 0.0) * GameProperties.grid_size * GameProperties.target_framerate
@export var friction: float = 0.0 : 
	set(value) :
		friction = maxf(value, 0.0) * GameProperties.grid_size * GameProperties.target_framerate
@export var climb_base_speed: float = 0.0 : 
	set(value) :
		climb_base_speed = maxf(value, 0.0) * GameProperties.grid_size
@export var crouch_speed: float = 0.0 :
	set(value):
		crouch_speed = maxf(value, 0.0)
@export var swim_speed: float = 0.0

@export_category("Air Movement")
@export var air_jumps: int = 0 :
	set(value):
		air_jumps = maxi(value, 0)
@export var air_acceleration: float = 0.0:
	set(value):
		air_acceleration = maxf(value, 0.0) * GameProperties.grid_size * GameProperties.target_framerate
@export var air_friction = 0.0:
	set(value):
		air_friction = maxf(value, 0.0) * GameProperties.grid_size * GameProperties.target_framerate

@export_category("Water Movement")

@export_category("Gravity")
## How fast, in blocks (check grid size on GameProperties) is the actor allowed
## to fall.
@export var terminal_velocity: float = 0.0 : 
	set(value) :
		terminal_velocity = maxf(value, 0.0) * GameProperties.grid_size
## How fast in seconds should you reach the floor after a jump.
@export var _time_to_floor: float
## How fast in seconds should you reach the peak of a jump
@export var _time_to_peak: float
## How far in blocks (check grid size on GameProperties)
## should the actor be able to jump
@export var _jump_height: float

# Toggles
var is_gravity_enabled: bool = true
var is_walking: bool = false
var is_crouching: bool = false
var can_jump: bool = true
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

# Settings
var gravity_mode: GravityMode = GravityMode.NORMAL

# Tracker
var air_jump_count: int = 0

@onready var jump_velocity = QuickMath.get_jump_velocity(_jump_height, _time_to_peak)
@onready var jump_gravity = QuickMath.get_jump_gravity(_jump_height, _time_to_peak)
@onready var normal_gravity = QuickMath.get_normal_gravity(_jump_height, _time_to_floor)


func get_gravity() -> float:
	if gravity_mode == GravityMode.NORMAL:
		return normal_gravity
	elif gravity_mode == GravityMode.JUMP:
		return jump_gravity
	elif gravity_mode == GravityMode.ZERO:
		return 0
	else:
		return normal_gravity


func apply_gravity(delta: float) -> void:
	if not is_gravity_enabled:
		return

	if gravity_mode != GravityMode.ZERO:
		velocity.y = minf(velocity.y + (get_gravity() * delta), terminal_velocity)
	else:
		if velocity.y != 0:
			velocity.y = move_toward(velocity.y, 0, air_acceleration * 2.0)


func change_actor_speed(AxisDirection: float, Delta: float) -> void:
	if AxisDirection == 0.0 and velocity.x == 0.0:
		return

	if gravity_mode != GravityMode.ZERO:
		velocity.x = move_toward(velocity.x, _get_speed() * AxisDirection, _get_accel_change(AxisDirection, velocity.x, _get_speed()) * Delta)
	else:
		velocity.x = move_toward(velocity.x, _get_speed() * AxisDirection, swim_speed / 3.0)


func _get_accel_change(AxisValue: float, CurrentSpeed: float, MaxSpeed: float):
	if abs(CurrentSpeed) <= MaxSpeed * int(AxisValue != 0): # return acceleration values
		if is_on_air:
			return air_acceleration
		elif not QuickMath.are_numbers_same_poles(AxisValue, CurrentSpeed):
			return friction
		else:
			return acceleration
	else: # return friction values
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
	if not actor_sprite:
		return
	
	if FacingRight and actor_sprite.flip_h:
		actor_sprite.flip_h = false
	elif not FacingRight and not actor_sprite.flip_h:
		actor_sprite.flip_h = true


func jump(JumpFromGround: bool, JumpForce: float = jump_velocity) -> void:
	if JumpFromGround or JumpForce < velocity.y:
		velocity.y = JumpForce
	else:
		velocity.y += JumpForce
		air_jump_count += 1
	
	gravity_mode = GravityMode.JUMP
	
	# This part is experimental. It gives a boost on air jumps to give more air control
	# Might remain, might go. Who knows? Me not yet.
	if not JumpFromGround:
		if QuickMath.are_numbers_same_poles(Input.get_axis("gc_left", "gc_right"), velocity.x):
			velocity.x += (_get_speed() * Input.get_axis("gc_left", "gc_right")) * 0.6
		else:
			velocity.x += (_get_speed() * Input.get_axis("gc_left", "gc_right")) * 0.35


func can_actor_jump(IsOnGround := true) -> bool:
	if not can_jump:
		return false
	
	if IsOnGround:
		return true
	
	return (air_jump_count < air_jumps) # Does actor have remaining air jumps?


func toggle_walk() -> void:
	is_walking = not is_walking
