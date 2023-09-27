extends Behaviour

var player: Player
var terrain_tracker: ModuleTerrainTracker


func enter(_args:= {}):
	if not player:
		return
	if not terrain_tracker.terrain_changed.is_connected(_change_terrain_state):
		terrain_tracker.terrain_changed.connect(_change_terrain_state)
	#fsm_animation_state.emit("root/ground/movement", "walk")
	behaviour_module.module_manager.get_module("animation-player").controller_set_state("walk")


func exit():
	if terrain_tracker.terrain_changed.is_connected(_change_terrain_state):
		terrain_tracker.terrain_changed.disconnect(_change_terrain_state)


func handle_key_input(event: InputEvent) -> void:
	if not player:
		return
	
	if event.is_action_pressed("gc_jump"):
		if player.can_actor_jump(true):
			player.jump(true)
			terrain_tracker.disable_raycast_on_timer(0.1)
			change_behaviour("/jump")

	elif event.is_action_pressed("gc_walk"):
		player.is_walking = not player.is_walking
		if not player.is_walking:
			change_behaviour("/run")
	
	elif event.is_action_released("gc_walk") and player.walk_hold:
		player.is_walking = false
		change_behaviour("/run")


func handle_physics(delta : float) -> void:
	if not player:
		return
	
	player.update_input_axis(true, false)
	
	if player.axis_strength.x == 0 and player.velocity.x == 0:
		change_behaviour("/idle")
		return
	
	if player.axis_strength.x != 0:
		player.update_facing_right()

	player.change_actor_speed(player.axis_strength.x, delta)


func setup_behaviour() -> void:
	behaviour_id = "walk"
	terrain_tracker = behaviour_module.module_manager.get_module("terrain-tracker")


func set_target_node(new_target_node) -> void:
	if new_target_node is Player:
		player = new_target_node


func _change_terrain_state(new_state: Game.TerrainState) -> void:
	if new_state == Game.TerrainState.AIR:
		if 0 <= player.velocity.y:
			change_behaviour("/fall")
			behaviour_module.module_manager.get_module("timers-manager").get_timer("coyote-timer").start()
		else:
			change_behaviour("/jump")
	elif new_state == Game.TerrainState.LIQUID:
		change_behaviour("/swim-idle")

