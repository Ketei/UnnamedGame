extends Behaviour
# Behaviour set up for Actors

var player : Player
var terrain_tracker: ModuleTerrainTracker


func set_target_node(target_node) -> void:
	if target_node is Player:
		player = target_node


func setup_behaviour() -> void:
	behaviour_id = "run"
	terrain_tracker = behaviour_module.module_manager.get_module("terrain-tracker")


func enter(_args:= {}):
	if not player:
		return
	
	terrain_tracker.terrain_changed.connect(__change_terrain_state)
	fsm_animation_state.emit("root/ground/movement", "run")


func exit():
	if terrain_tracker.terrain_changed.is_connected(__change_terrain_state):
		terrain_tracker.terrain_changed.disconnect(__change_terrain_state)


func handle_key_input(event : InputEvent) -> void:
	if not player:
		return
	
	if event.is_action_pressed("gc_jump"):
		if player.can_actor_jump(true):
			player.jump(true)
			terrain_tracker.disable_raycast_on_timer(0.1)
			change_behaviour.emit("/jump")
	elif event.is_action_pressed("gc_walk"):
		player.is_walking = true
		change_behaviour.emit("/walk")


func handle_physics(delta : float) -> void:
	if not player:
		return
	
	player.update_input_axis(true, false)
	
	if player.velocity.x == 0 and player.axis_strength.x == 0:
		change_behaviour.emit("/idle")
		return
	
	player.update_facing_right()
	player.change_actor_speed(player.axis_strength.x, delta)


func __change_terrain_state(NewState: GameProperties.TerrainState) -> void:
	if NewState == GameProperties.TerrainState.AIR:
		if 0 < player.velocity.y:
			change_behaviour.emit("/fall")
			behaviour_module.module_manager.get_module("timers-manager").get_timer("coyote-timer").start()
		else:
			change_behaviour.emit("/jump")
	elif NewState == GameProperties.TerrainState.LIQUID:
		change_behaviour.emit("/swim-idle")

