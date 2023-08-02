extends CharacterBody2D
class_name Actor

# enums
enum GravityMode {NORMAL, JUMP}

# General
@export_category("Actor Properties")
@export var display_name: String = ""
@export var actor_type: ActorProperties.ActorType
@export var actor_gender: ActorProperties.Gender
@export var actor_sprite: Sprite2D = null

@export_category("Movement")
@export var max_speed: float : set = _set_move_base_speed
@export var acceleration: float = 0.0
@export var friction: float = 0.0 : set = _set_friction
@export var climb_base_speed: float : set = _set_max_climb_speed

@export_category("Gravity")
@export var max_gravity: float = 0.0
@export var _jump_time_to_floor: float
@export var _jump_time_to_peak: float
@export var _jump_height: float

# Toggles
var is_gravity_enabled: bool = true
var is_control_enabled: bool = true # Player: Input controls | NPC: AI processing control
## When it turns true, if the actor sprite is set in the actor node it'll also flip the sprite horizontally
var is_facing_left: bool = false

# Settings
var gravity: float = 0.0

# Trackers
## The speed tracker is used to change speed with smooth acceleration
# if I need to free _init move the function to library and call it on_ready
#AccelSteps: int, Speed: float, Increase: float
@onready var speed_manager: SpeedManager = SpeedManager.new()

@onready var jump_velocity = QuickMath.get_jump_velocity(_jump_height, _jump_time_to_peak)
@onready var jump_gravity = QuickMath.get_jump_gravity(_jump_height, _jump_time_to_peak)
@onready var normal_gravity = QuickMath.get_normal_gravity(_jump_height, _jump_time_to_floor)


# setgets
func _set_move_base_speed(NewMaxSpeed: float) -> void:
	max_speed = absf(NewMaxSpeed) * ActorProperties.world_grid


func _set_max_climb_speed(NewMaxSpeed: float) -> void:
	climb_base_speed = absf(NewMaxSpeed) * ActorProperties.world_grid
	

func _set_friction(NewFriction: float) -> void:
	friction = absf(NewFriction)


func _set_is_facing_left(IsFacingLeft: bool) -> void:
	is_facing_left = IsFacingLeft
	if actor_sprite:
		actor_sprite.flip_h = true
# -------------------------------------------------------------------------------------------------


func change_gravity_mode(NewGravityMode: GravityMode) -> void:
	if NewGravityMode == GravityMode.NORMAL:
		gravity = normal_gravity
	elif NewGravityMode == GravityMode.JUMP:
		gravity = jump_gravity


func apply_gravity(delta: float) -> void:
	if is_gravity_enabled:
		velocity.y = move_toward(velocity.y, max_gravity, velocity.y + (gravity * delta))

## Sets a new velocity.x for the actor. DirectionStrength uses positive values between 0.0 and 1.0
## DirectionStrength is used to calculate the % of max_speed that is max_speed. Mostly useful for controller input.
## Direction of the movement is defined by is_facing_left
func move_actor(MovementStrenght: float, Delta: float):
	var _new_velocity: float
	
	if MovementStrenght == 0.0 and velocity.x == 0.0:
		# Avoids unnecessary sets on velocity or calcs on a new velocity.
		pass
	else:
		_new_velocity = speed_manager.get_new_velocity(velocity.x, max_speed * absf(MovementStrenght), acceleration, friction, Delta)
		
		if is_facing_left:
			_new_velocity *= -1

		if _new_velocity != velocity.x:
			velocity.x = _new_velocity
