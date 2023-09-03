extends Module
class_name ModuleTerrainTracker

@export_category("Terrain Raycast")
@export var raycast_left: RayCast2D = null
@export var raycast_center: RayCast2D = null
@export var raycast_right: RayCast2D = null

@export_category("Collision Boxes")
## Used to track and set movement modifiers
@export var ground_collision: Area2D = null

## Used to track if actor is swimming.
@export var middle_collision: Area2D = null

var is_submerged: bool = false


func _ready():
	module_type = "terrain-tracker"
	module_priority = 0


func set_up_module() -> void:
	ground_collision.area_entered.connect(ground_terrain_changed.bind(true))
	middle_collision.area_entered.connect(mid_terrain_changed.bind(true))
	
	ground_collision.area_exited.connect(ground_terrain_changed.bind(false))
	middle_collision.area_exited.connect(mid_terrain_changed.bind(false))
	
	is_module_enabled = true


func ground_terrain_changed(area, IsEntering: bool):
	pass


func mid_terrain_changed(area, IsEntering: bool):
	module_manager.actor_submerged(IsEntering)


func apply_terrain_effects(area) -> void:
	if area is TerrainType:
		pass


func is_on_ground() -> bool:
	if raycast_left.is_colliding() or raycast_center.is_colliding() or raycast_right.is_colliding():
		return true
	else:
		return false


func get_terrain_state():
	pass

