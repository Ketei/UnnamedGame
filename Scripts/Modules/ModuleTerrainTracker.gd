extends Module
class_name ModuleTerrainTracker

signal terrain_changed(NewState)

@export_category("Terrain Raycast")
@export var raycast_left: RayCast2D = null
@export var raycast_center: RayCast2D = null
@export var raycast_right: RayCast2D = null

@export_category("Collision Boxes")
## Used to track and set movement modifiers
@export var ground_collision: Area2D = null

## Used to track if actor is swimming.
@export var middle_collision: Area2D = null

var is_on_ground: bool = true
var is_submerged: bool = false

var terrain_state: GameProperties.TerrainState = GameProperties.TerrainState.AIR:
	set(value):
		if value != terrain_state:
			terrain_state = value
			terrain_changed.emit(terrain_state)

var effect_list: Array = []


func _ready():
	module_type = "terrain-tracker"
	module_priority = 0


func _ground_terrain_changed(area, IsEntering: bool):
	if IsEntering:
		_apply_terrain_effects(area)
	else:
		_remove_terrain_effects(area)


func _mid_terrain_changed(area, IsEntering: bool):
	module_manager.actor_submerged(IsEntering)
	
	if IsEntering:
		is_submerged = true
		_apply_terrain_effects(area)
	else:
		is_submerged = false
		_remove_terrain_effects(area)


func _apply_terrain_effects(area) -> void:
	if area is TerrainType:
		module_manager.apply_effect(area.terrain_effect)
		effect_list.append(area.terrain_effect.effect_id)


func _remove_terrain_effects(area) -> void:
	if area is TerrainType:
		QuickMath.erase_array_element(area.terrain_effect.effect_id, effect_list)
		
		if not effect_list.has(area.terrain_effect.effect_id):
			module_manager.remove_effect(area.terrain_effect.effect_id)


func _is_on_ground() -> bool:
	if raycast_left.is_colliding() or raycast_center.is_colliding() or raycast_right.is_colliding():
		return true
	else:
		return false


func _update_terrain_state() -> void:
	if is_submerged:
		terrain_state = GameProperties.TerrainState.LIQUID
	elif _is_on_ground():
		terrain_state = GameProperties.TerrainState.GROUND
	else:
		terrain_state = GameProperties.TerrainState.AIR


func set_up_module() -> void:
	ground_collision.area_entered.connect(_ground_terrain_changed.bind(true))
	middle_collision.area_entered.connect(_mid_terrain_changed.bind(true))
	
	ground_collision.area_exited.connect(_ground_terrain_changed.bind(false))
	middle_collision.area_exited.connect(_mid_terrain_changed.bind(false))
	
	QuickConfig.set_object_collision_bit([1], ground_collision, true)
	
	QuickConfig.set_object_collision_bit([1], middle_collision, true)
	
	QuickConfig.set_raycast_collision_mask([0], raycast_left)
	QuickConfig.set_raycast_collision_mask([0], raycast_center)
	QuickConfig.set_raycast_collision_mask([0], raycast_right)

	is_module_enabled = true


func module_physics_process(_delta: float) -> void:
	if not is_module_enabled:
		return
	
	_update_terrain_state()


