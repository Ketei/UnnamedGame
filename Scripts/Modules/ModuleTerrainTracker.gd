extends Module
class_name ModuleTarrainTracker

var current_terrain: GameProperties.TerrainState

var _is_floored: bool = false

@export_category("Terrain Raycast")
@export var raycast_left: RayCast2D = null
@export var raycast_center: RayCast2D = null
@export var raycast_right: RayCast2D = null

@export_category("Collision Boxes")
## Used to track and set movement modyfiers
@export var ground_collision: TerrainCollider = null

## Used to track if actor is swimming.
@export var middle_collision: TerrainCollider = null


func set_up_module() -> void:
	module_type = "terrain_tracker"
	middle_collision.area_update.connect(update_terrain)
	enabled = true


func is_on_ground() -> bool:
	if raycast_left.is_colliding() or raycast_center.is_colliding() or raycast_right.is_colliding():
		return true
	else:
		return false


func is_submerged() -> bool:
	if "Water" in middle_collision.get_terrains():
		return true
	else:
		return false


func update_terrain() -> void:
	if is_submerged():
		current_terrain = GameProperties.TerrainState.WATER
	elif  _is_floored:
		current_terrain = GameProperties.TerrainState.GROUND
	else:
		current_terrain = GameProperties.TerrainState.AIR


func get_terrain_state() -> String:
	return GameProperties.get_terrain_name(current_terrain)


# Priorities: Water > Air > Ground
func _physics_process(delta):
	if enabled:
	# Handles switches between Ground <-> Air
	# Compares used to prevent redundant assings
		if _is_floored != is_on_ground():
			_is_floored = is_on_ground()
			update_terrain()
