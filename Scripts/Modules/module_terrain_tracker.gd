class_name ModuleTerrainTracker
extends Module


signal terrain_changed(new_terrain)

@export_category("Terrain Raycast")
@export var raycast_left: RayCast2D = null
@export var raycast_center: RayCast2D = null
@export var raycast_right: RayCast2D = null

@export_category("Collision Boxes")
## Used to track and set movement modifiers
@export var ground_collision: Area2D = null
## Used to track if actor is swimming.
@export var middle_collision: Area2D = null

var effect_list: Array = []
var terrain_state: GameProperties.TerrainState = GameProperties.TerrainState.AIR:
	set(value):
		if value != terrain_state:
			terrain_state = value
			terrain_changed.emit(terrain_state)

var _array_off_timer: Timer


func _ready():
	module_type = "terrain-tracker"
	module_priority = 0
	_array_off_timer = Timer.new()
	_array_off_timer.one_shot = true
	_array_off_timer.timeout.connect(set_raycast_enabled.bind(true))
	self.add_child(_array_off_timer)
	__update_terrain_state()


func set_up_module() -> void:
	ground_collision.area_entered.connect(__ground_terrain_changed.bind(true))
	middle_collision.area_entered.connect(__mid_terrain_changed.bind(true))
	
	ground_collision.area_exited.connect(__ground_terrain_changed.bind(false))
	middle_collision.area_exited.connect(__mid_terrain_changed.bind(false))
	
	QuickConfig.set_object_collision_bit([2], ground_collision, false)
	QuickConfig.disable_object_collision_bits(ground_collision, true)
	
	QuickConfig.set_object_collision_bit([2], middle_collision, false)
	QuickConfig.disable_object_collision_bits(middle_collision, true)

	QuickConfig.set_raycast_collision_mask([1], raycast_left)
	QuickConfig.set_raycast_collision_mask([1], raycast_center)
	QuickConfig.set_raycast_collision_mask([1], raycast_right)


func module_physics_process(_delta: float) -> void:
	if not is_module_enabled:
		return
	
	__update_terrain_state()


## Disables the raycasts and re-enables them once the timer has run out.
func disable_raycast_on_timer(disabled_time: float) -> void:
	set_raycast_enabled(false)
	_array_off_timer.start(disabled_time)


func is_on_ground() -> bool:
	if raycast_left.is_colliding() or raycast_center.is_colliding() or raycast_right.is_colliding():
		return true
	else:
		return false


func set_raycast_enabled(is_enabled: bool) -> void:
	raycast_left.enabled = is_enabled
	raycast_center.enabled = is_enabled
	raycast_right.enabled = is_enabled
	__update_terrain_state()


func __ground_terrain_changed(area, IsEntering: bool):
	if IsEntering:
		__apply_terrain_effects(area)
	else:
		__remove_terrain_effects(area)


func __mid_terrain_changed(area, IsEntering: bool):
	module_manager.actor_submerged(IsEntering)
	
	if IsEntering:
		#is_submerged = true
		__apply_terrain_effects(area)
	else:
		#is_submerged = false
		__remove_terrain_effects(area)


func __apply_terrain_effects(area) -> void:
	if area is TerrainType:
		module_manager.apply_effect(area.terrain_effect)
		effect_list.append(area.terrain_effect.effect_id)


func __remove_terrain_effects(area) -> void:
	if area is TerrainType:
		QuickMath.erase_array_element(area.terrain_effect.effect_id, effect_list)
		
		if not effect_list.has(area.terrain_effect.effect_id):
			module_manager.remove_effect(area.terrain_effect.effect_id)


func __update_terrain_state() -> void:
	#if is_submerged:
		#terrain_state = GameProperties.TerrainState.LIQUID
	if is_on_ground():
		terrain_state = GameProperties.TerrainState.GROUND
	else:
		terrain_state = GameProperties.TerrainState.AIR

