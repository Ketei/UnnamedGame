class_name Actor
extends CharacterBody2D


# enums
enum GravityMode {NORMAL, JUMP, ZERO}

@export_category("Actor Properties")
@export var actor_name: String = ""
@export var actor_type: ActorProperties.ActorType
@export var actor_gender: ActorProperties.Gender
@export var actor_sprite: ActorSprite2D = null
@export var module_manager: ModuleManager

@export_category("Ground Movement")
## Any terrain change will be checked here first, then on Game.
@export var self_terrain_move_mod: Dictionary = {}
@export var run_speed: float = 0.0: 
	set(value) :
		run_speed = maxf(value, 0.0) * Game.GRID_SIZE
@export var walk_speed: float = 0.0 : 
	set(value) :
		walk_speed = maxf(value, 0.0) * Game.GRID_SIZE
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
		climb_base_speed = maxf(value, 0.0) * Game.GRID_SIZE
@export var crouch_speed: float = 0.0 :
	set(value):
		crouch_speed = maxf(value, 0.0)
@export var swim_speed: float = 0.0

@export_category("Air Movement")
## If this value is updated and have a gravity module, be sure to update it too.
@export var jump_height: float = 0.0:
	set(value):
		jump_height = value * Game.GRID_SIZE
		jump_velocity = QuickMath.get_jump_velocity(jump_height, time_to_peak)
		__update_gravity()
## How fast in seconds should you reach the floor after jumping. If this value
## is updated and have a gravity module, be sure to update it too.
@export var time_to_floor: float = 0.0:
	set(value):
		time_to_floor = maxf(value, 0.0)
		__update_gravity()
## How fast in seconds should you reach the peak of a jump. If this value
## is updated and have a gravity module, be sure to update it too.
@export var time_to_peak: float = 0.0:
	set(value):
		time_to_peak = maxf(value, 0.0)
		jump_velocity = QuickMath.get_jump_velocity(jump_height, time_to_peak)
		__update_gravity()
@export var air_jumps: int = 0 :
	set(value):
		air_jumps = maxi(value, 0)
@export var air_acceleration: float = 0.0:
	set(value):
		air_acceleration = maxf(value, 0.0)
@export var air_friction = 0.0:
	set(value):
		air_friction = maxf(value, 0.0)

@export_category("Hurtbox")
@export var hurt_box: HurtBox

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
var terrain_mod: float = 1.0:
	set(value):
		terrain_mod = maxf(value, 0.0)

# Tracker
var air_jump_count: int = 0

@onready var jump_velocity: float = QuickMath.get_jump_velocity(jump_height,
		time_to_peak)


func change_actor_speed(axis_direction: float, delta: float) -> void:
	if axis_direction == 0.0 and velocity.x == 0.0:
		return

	velocity.x = move_toward(velocity.x, get_speed() * axis_direction, get_acceleration(axis_direction, velocity.x, get_speed()) * delta )


func get_acceleration(axis_value: float, current_speed: float, max_speed: float) -> float:
	var __is_accelerating: bool = (axis_value != 0) and QuickMath.are_numbers_same_poles(axis_value, current_speed)
	var __speed_change: float = 0.0
	
	if not is_on_air:
		if __is_accelerating:
			__speed_change = acceleration
			if max_speed < abs(current_speed):
				__speed_change *= 1.5
		else:
			__speed_change = friction
	else:
		if axis_value == 0:
			__speed_change = air_friction
		else:
			__speed_change = air_acceleration
	
	return QuickMath.get_acceleration(__speed_change, max_speed)


func get_speed() -> float:
	var base_speed: float
	
	if is_swimming:
		base_speed = swim_speed
	elif  is_crouching:
		base_speed = crouch_speed
	elif is_walking:
		base_speed = walk_speed
	else:
		base_speed = run_speed
	
	return maxf(((base_speed + speed_mod) * speed_mult) * terrain_mod, 0.0)


func set_terrain_mult_by_name(terrain_name: String):
	if terrain_name in self_terrain_move_mod:
		terrain_mod = self_terrain_move_mod[terrain_name]
	elif terrain_name in Game.TerrainMoveMult:
		terrain_mod = Game.TerrainMoveMult[terrain_name]


func add_terrain_modifier(terrain_name: String, terrain_modifier: float) -> void:
	self_terrain_move_mod[terrain_name] = maxf(terrain_modifier, 0.0)


func update_facing_right() -> void:
	if not actor_sprite:
		return
	
	if velocity.x < 0 and not actor_sprite.flip_h:
		actor_sprite.flip_horizontal(true)
	elif 0 < velocity.x and actor_sprite.flip_h:
		actor_sprite.flip_horizontal(false)


func jump(jump_from_ground: bool, jump_force: float = jump_velocity) -> void:
	if not jump_from_ground:
		air_jump_count += 1
	
	if jump_force < velocity.y:
		velocity.y = jump_force


func can_actor_jump(is_on_ground := true) -> bool:
	if not can_jump:
		return false
	
	if is_on_ground:
		return true
	
	return (air_jump_count < air_jumps) # Does actor have remaining air jumps?


func __update_gravity() -> void:
	if not module_manager:
		return
	
	if not module_manager.has_module("gravity"):
		return
	
	module_manager.get_module("gravity").update_gravity_settings()

