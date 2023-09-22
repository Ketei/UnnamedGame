class_name ModuleGravity
extends Module


enum GravityMode {NORMAL, ZERO}

@export var target_actor: Actor
@export var gravity_mode: GravityMode = GravityMode.NORMAL

@export_group("Gravity Values")
## How fast, in blocks (check grid size on GameProperties) is the actor allowed
## to fall by itself. Reducing this will give a low-gravity feel.
@export var terminal_velocity: float = 0.0 : 
	set(value) :
		terminal_velocity = maxf(value, 0.0) * GameProperties.GRID_SIZE
## If on zero gravity, this is how much you'll slow down per second.
@export var low_grav_slowdown: float = 0.0 :
	set(value):
		low_grav_slowdown = maxf(value, 0.0) * GameProperties.GRID_SIZE

var jump_gravity: float = 0.0
var normal_gravity: float = 0.0


func _ready():
	module_type = "gravity"
	module_priority = 100


func set_up_module() -> void:
	update_gravity_settings()


func module_physics_process(delta: float) -> void:
	if not target_actor or not is_module_enabled:
		return
	
	target_actor.velocity.y = move_toward(target_actor.velocity.y, terminal_velocity, get_gravity() * delta)


func update_gravity_settings() -> void:
	jump_gravity = QuickMath.get_jump_gravity(target_actor.jump_height, target_actor.time_to_peak)
	normal_gravity = QuickMath.get_normal_gravity(target_actor.jump_height, target_actor.time_to_floor)


func get_gravity() -> float:
	if gravity_mode == GravityMode.ZERO:
		return low_grav_slowdown

	if 0 < target_actor.velocity.y:
		return normal_gravity
	else:
		return jump_gravity

