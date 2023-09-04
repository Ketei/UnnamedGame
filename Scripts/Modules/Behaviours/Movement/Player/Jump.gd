extends Behaviour

var player: Player
var terrain_tracker: ModuleTerrainTracker
var current_terrain: GameProperties.TerrainState

func enter(_args:= {}):
	if not player:
		return
	
	current_terrain = terrain_tracker.terrain_state
	change_animation.emit("movement-air", "jump")
	terrain_tracker.terrain_changed.connect(_change_terrain_state)
	
	if not Input.is_action_pressed("gc_jump"):
		if 0 < player.velocity.y:
			player.velocity.y /= 2
		_go_to_fall()


func exit():
		if terrain_tracker.terrain_changed.is_connected(_change_terrain_state):
			terrain_tracker.terrain_changed.disconnect(_change_terrain_state)


func handle_key_input(event: InputEvent) -> void:
	if not player:
		return
	
	
	if event.is_action_released("gc_jump") and player.velocity.y < 0:
		player.velocity.y /= 2.0
	
	if event.is_action_pressed("gc_jump"):
		if player.jump(false):
			terrain_tracker.temp_disable_ground_raycast(0.2)
			change_animation.emit("movement-air", "jump")


func handle_physics(delta : float) -> void:
	if not player:
		return
	
	if 0 <= player.velocity.y:
		if current_terrain == GameProperties.TerrainState.GROUND:
			change_behaviour.emit("movement", "idle")
		else:
			_go_to_fall()
	
	player.apply_gravity(delta)
	player.change_actor_speed(Input.get_axis("gc_left", "gc_right"), delta)
	player.move_and_slide()


func setup_behaviour() -> void:
	behaviour_id = "jump"
	terrain_tracker = behaviour_module.module_manager.get_module("terrain-tracker")


func set_target_node(NewTargetNode) -> void:
	if NewTargetNode is Player:
		player = NewTargetNode


func _go_to_fall() -> void:
	player.gravity_mode = player.GravityMode.NORMAL
	change_behaviour.emit("movement-air", "fall")


func _change_terrain_state(NewState: GameProperties.TerrainState) -> void:
	current_terrain = NewState

