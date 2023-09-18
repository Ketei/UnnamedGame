extends Behaviour
# Behaviour set up for Actors

var player : Player
var terrain_tracker: ModuleTerrainTracker

func setup_behaviour() -> void:
	behaviour_id = "run"
	terrain_tracker = behaviour_module.module_manager.get_module("terrain-tracker")


func enter(_args:= {}):
	if not player:
		return
	terrain_tracker.terrain_changed.connect(_change_terrain_state)
	fsm_animation_state.emit("root/ground/movement", "run")


func exit():
	if terrain_tracker.terrain_changed.is_connected(_change_terrain_state):
		terrain_tracker.terrain_changed.disconnect(_change_terrain_state)


func handle_key_input(event : InputEvent) -> void:
	if not player:
		return
	
	if event.is_action_pressed("gc_jump"):
		if player.can_actor_jump(true):
			player.jump(true)
			terrain_tracker.temp_disable_ground_raycast(0.1)
			change_behaviour.emit("movement", "jump")
	elif event.is_action_pressed("gc_walk"):
		player.is_walking = true
		change_behaviour.emit("movement", "walk")


func handle_physics(delta : float) -> void:
	if not player:
		return
	
	player.update_input_axis(true, false)
	
	if player.velocity.x == 0 and player.axis_strength.x == 0:
		change_behaviour.emit("movement", "idle")
		return
	
	player.update_facing_right()
	player.change_actor_speed(player.axis_strength.x, delta)


func set_target_node(NewTargetNode) -> void:
	if NewTargetNode is Player:
		player = NewTargetNode


func _change_terrain_state(NewState: GameProperties.TerrainState) -> void:
	if NewState == GameProperties.TerrainState.AIR:
		if 0 < player.velocity.y:
			change_behaviour.emit("movement", "fall")
			behaviour_module.module_manager.get_module("timers-manager").get_timer("coyote-timer").start()
		else:
			change_behaviour.emit("movement", "jump")
	elif NewState == GameProperties.TerrainState.LIQUID:
		change_behaviour.emit("movement", "swim-idle")

