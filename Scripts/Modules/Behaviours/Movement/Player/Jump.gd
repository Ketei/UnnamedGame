extends Behaviour

var player: Player
var terrain_tracker: ModuleTerrainTracker
var current_terrain: GameProperties.TerrainState
var jump_buffer: TimerForModule
var _jump_timer_restore: Timer


func enter(_args:= {}):
	if not player:
		return
	
	if not player.is_on_air:
		player.is_on_air = true
	
	current_terrain = terrain_tracker.terrain_state
	change_animation.emit("movement-air", "jump", false)
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
		player.velocity.y -= (player.jump_velocity * 0.5) * (_jump_timer_restore.time_left / player._time_to_peak)
		
		if player.gravity_mode == Actor.GravityMode.JUMP:
			player.gravity_mode = Actor.GravityMode.NORMAL
	
	elif event.is_action_pressed("gc_jump"):
		if player.can_actor_jump(false):
			player.jump(false)
			terrain_tracker.temp_disable_ground_raycast(0.2)
			change_animation.emit("movement-air", "jump", false)
		else:
			jump_buffer.start()
	elif event.is_action_pressed("gc_walk"):
		player.toggle_walk()
	elif event.is_action_released("gc_walk") and player.walk_hold:
		player.toggle_walk()
		
	elif event.is_action_pressed("gc_crouch"):
		player.toggle_walk()


func handle_physics(delta : float) -> void:
	if not player:
		return
	
	if current_terrain == GameProperties.TerrainState.GROUND:
		player.air_jump_count = 0
		if 0 < jump_buffer.time_left:
			jump_buffer.stop()
			if player.can_actor_jump(true):
				if Input.is_action_pressed("gc_jump"):
					player.jump(true)
				else:
					player.jump(true, player.jump_velocity / 2)
				change_animation.emit("movement-air", "jump", false)
	elif current_terrain == GameProperties.TerrainState.LIQUID:
		change_behaviour.emit("movement", "swim-idle")

	if 0 <= player.velocity.y:
		_go_to_fall()
	
	player.update_input_axis(true, false)
	
	if player.axis_strength.x != 0.0:
		player.set_facing_right(0 < player.axis_strength.x)
	
	player.apply_gravity(delta)
	player.change_actor_speed(player.axis_strength.x, delta)
	player.move_and_slide()


func setup_behaviour() -> void:
	behaviour_id = "jump"
	terrain_tracker = behaviour_module.module_manager.get_module("terrain-tracker")
	jump_buffer = behaviour_module.module_manager.get_module("timers-manager").get_timer("jump-buffer")
	_jump_timer_restore = Timer.new()
	_jump_timer_restore.wait_time = player._time_to_peak
	_jump_timer_restore.one_shot = true
	_jump_timer_restore.autostart = false
	_jump_timer_restore.timeout.connect(_restor_grav)
	self.add_child(_jump_timer_restore)


func set_target_node(NewTargetNode) -> void:
	if NewTargetNode is Player:
		player = NewTargetNode


func _go_to_fall() -> void:
	player.gravity_mode = player.GravityMode.NORMAL
	change_behaviour.emit("movement", "fall")


func _change_terrain_state(NewState: GameProperties.TerrainState) -> void:
	current_terrain = NewState


func _restor_grav() -> void:
	if player.gravity_mode != Actor.GravityMode.NORMAL:
		player.gravity_mode = Actor.GravityMode.NORMAL
