extends Behaviour

var player: Player
var terrain_tracker: ModuleTerrainTracker
var jump_buffer: TimerForModule
var _jump_timer_restore: Timer


func enter(_args:= {}):
	if not player:
		return
	
	if not player.is_on_air:
		player.is_on_air = true
	
	fsm_animation_state.emit("root/air/movement", "jump")
	if not terrain_tracker.terrain_changed.is_connected(_change_terrain_state):
		terrain_tracker.terrain_changed.connect(_change_terrain_state)
	
	_jump_timer_restore.start()


func exit():
	if terrain_tracker.terrain_changed.is_connected(_change_terrain_state):
		terrain_tracker.terrain_changed.disconnect(_change_terrain_state)
	if not _jump_timer_restore.is_stopped():
		_jump_timer_restore.stop()


func handle_key_input(event: InputEvent) -> void:
	if not player:
		return
	
	if event.is_action_released("gc_jump") and player.velocity.y < 0:
		# In this line it's handled the "minimum jump height". 
		# 1.0 - the number(the one multiplying jump_velocity) = % of the 
		# minimum jump height (arpox).
		player.velocity.y -= (player.jump_velocity * 0.5) * (_jump_timer_restore.time_left / player.time_to_peak)

	elif event.is_action_pressed("gc_jump"):
		if player.can_actor_jump(false):
			player.jump(false)
			terrain_tracker.disable_raycast_on_timer(0.1)
			fsm_animation_replay.emit(false)
		else:
			jump_buffer.start()
	elif event.is_action_pressed("gc_walk"):
		toggle_walk(!player.is_walking)
	elif event.is_action_released("gc_walk") and player.walk_hold:
		toggle_walk(false)
		
	elif event.is_action_pressed("gc_crouch"):
		player.toggle_walk()


func handle_physics(delta : float) -> void:
	if not player:
		return

	if 0 <= player.velocity.y:
		change_behaviour("/fall")
	
	player.update_input_axis(true, false)

	player.update_facing_right()

	player.change_actor_speed(player.axis_strength.x, delta)


func setup_behaviour() -> void:
	behaviour_id = "jump"
	terrain_tracker = behaviour_module.module_manager.get_module("terrain-tracker")
	jump_buffer = behaviour_module.module_manager.get_module("timers-manager").get_timer("jump-buffer")
	_jump_timer_restore = Timer.new()
	_jump_timer_restore.wait_time = player.time_to_peak
	_jump_timer_restore.one_shot = true
	_jump_timer_restore.autostart = false
	self.add_child(_jump_timer_restore)


func set_target_node(new_target_node) -> void:
	if new_target_node is Player:
		player = new_target_node


func _change_terrain_state(new_state: GameProperties.TerrainState) -> void:
	if new_state == GameProperties.TerrainState.GROUND:
		player.air_jump_count = 0
		if 0 < jump_buffer.time_left and player.can_actor_jump(true):
			player.jump(true, player.jump_velocity / (2 - int(Input.is_action_pressed("gc_jump"))))
			fsm_animation_replay.emit(false)
		else:
			change_behaviour(__get_target_ground_state())
		
		if not jump_buffer.is_stopped():
			jump_buffer.stop()


func toggle_walk(is_walking: bool) -> void:
	player.is_walking = is_walking
	if player.is_walking:
		fsm_animation_state.emit("root/ground/movement", "walk")
	else:
		fsm_animation_state.emit("root/ground/movement", "run")


func __get_target_ground_state() -> String:
	if player.axis_strength.x == 0.0:
		return "/idle"
	elif player.is_walking:
		return "/walk"
	else:
		return "/run"
