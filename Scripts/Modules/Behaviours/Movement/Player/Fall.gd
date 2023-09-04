extends Behaviour

var player: Player
var terrain_tracker: ModuleTerrainTracker


func setup_behaviour() -> void:
	behaviour_id = "fall"
	terrain_tracker = behaviour_module.module_manager.get_module("terrain-tracker")


func enter(_args:= {}):
	change_animation.emit("movement-air", "fall")
	terrain_tracker.terrain_changed.connect(_change_terrain_state)


func exit():
	if terrain_tracker.terrain_changed.is_connected(_change_terrain_state):
		terrain_tracker.terrain_changed.disconnect(_change_terrain_state)


func handle_key_input(event : InputEvent) -> void:
	if event.is_action_pressed("gc_jump"):
		if player.jump(false):
			change_behaviour.emit("movement", "jump")


func handle_physics(delta : float) -> void:
	if not player:
		return
	
	player.apply_gravity(delta)
	player.change_actor_speed(Input.get_axis("gc_left", "gc_right"), delta)
	player.move_and_slide()


func set_target_node(NewTargetNode) -> void:
	if NewTargetNode is Player:
		player = NewTargetNode


func _change_terrain_state(NewState: GameProperties.TerrainState) -> void:
	if NewState == GameProperties.TerrainState.GROUND:
		change_behaviour.emit("movement", "idle")
	elif NewState == GameProperties.TerrainState.LIQUID:
		change_behaviour.emit("movement", "swim-idle")

