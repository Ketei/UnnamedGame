extends Behaviour

var player: Player
var terrain_tracker: ModuleTerrainTracker
var jump_buffer: TimerForModule
var coyote_timer: TimerForModule

func setup_behaviour() -> void:
	behaviour_id = "fall"
	terrain_tracker = behaviour_module.module_manager.get_module("terrain-tracker")
	coyote_timer = behaviour_module.module_manager.get_module("timers-manager").get_timer("coyote-timer")
	jump_buffer = behaviour_module.module_manager.get_module("timers-manager").get_timer("jump-buffer")


func enter(_args:= {}):
	if terrain_tracker.terrain_state == GameProperties.TerrainState.GROUND:
		change_behaviour.emit("movement", "idle")
		if player.is_on_air:
			player.is_on_air = false
		return
	
	if not player.is_on_air:
		player.is_on_air = true
	change_animation.emit("movement-air", "fall", false)
	terrain_tracker.terrain_changed.connect(_change_terrain_state)


func exit():
	if terrain_tracker.terrain_changed.is_connected(_change_terrain_state):
		terrain_tracker.terrain_changed.disconnect(_change_terrain_state)


func handle_key_input(event : InputEvent) -> void:
	if event.is_action_pressed("gc_jump"):
		if coyote_timer.time_left != 0 and player.can_actor_jump(true):
			coyote_timer.stop()
			player.jump(true)
			terrain_tracker.temp_disable_ground_raycast(0.2)
			change_behaviour.emit("movement", "jump")
		elif player.can_actor_jump(false):
			player.jump(false)
			terrain_tracker.temp_disable_ground_raycast(0.2)
			change_behaviour.emit("movement", "jump")
		else:
			jump_buffer.start()
	elif event.is_action_pressed("gc_walk"):
		player.is_walking = not player.is_walking


func handle_physics(delta : float) -> void:
	if not player:
		return
	
	player.update_input_axis(true, false)
	
	if player.axis_strength.x != 0:
		player.set_facing_right(0 < player.axis_strength.x)
	player.apply_gravity(delta)
	player.change_actor_speed(player.axis_strength.x, delta)
	player.move_and_slide()


func set_target_node(NewTargetNode) -> void:
	if NewTargetNode is Player:
		player = NewTargetNode


func _change_terrain_state(NewState: GameProperties.TerrainState) -> void:
	if NewState == GameProperties.TerrainState.GROUND:
		player.air_jump_count = 0
		player.is_on_air = false
		if jump_buffer.time_left <= 0 or not player.can_actor_jump(true):
			change_behaviour.emit("movement", "idle")
			return
		
		jump_buffer.stop()
		
		player.jump(true, player.jump_velocity / (2 - int(Input.is_action_pressed("gc_jump"))))
		change_behaviour.emit("movement", "jump")

	elif NewState == GameProperties.TerrainState.LIQUID:
		player.is_on_air = false
		change_behaviour.emit("movement", "swim-idle")

