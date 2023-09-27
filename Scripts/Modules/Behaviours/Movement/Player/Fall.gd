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
	if terrain_tracker.terrain_state == Game.TerrainState.GROUND:
		change_behaviour(__get_target_ground_state())
		if player.is_on_air:
			player.is_on_air = false
		return
	
	if not player.is_on_air:
		player.is_on_air = true
	#fsm_animation_state.emit("root/air/movement", "fall")
	behaviour_module.module_manager.get_module("animation-player").controller_set_state("fall")
	if not terrain_tracker.terrain_changed.is_connected(_change_terrain_state):
		terrain_tracker.terrain_changed.connect(_change_terrain_state)


func exit():
	if terrain_tracker.terrain_changed.is_connected(_change_terrain_state):
		terrain_tracker.terrain_changed.disconnect(_change_terrain_state)


func handle_key_input(event : InputEvent) -> void:
	if event.is_action_pressed("gc_jump"):
		if coyote_timer.time_left != 0 and player.can_actor_jump(true):
			coyote_timer.stop()
			player.jump(true)
			terrain_tracker.disable_raycast_on_timer(0.2)
			change_behaviour("/jump")
		elif player.can_actor_jump(false):
			player.jump(false)
			terrain_tracker.disable_raycast_on_timer(0.2)
			change_behaviour("/jump")
		else:
			jump_buffer.start()
	elif event.is_action_pressed("gc_walk"):
		player.is_walking = not player.is_walking
	elif event.is_action_released("gc_walk") and player.walk_hold:
		player.is_walking = false


func handle_physics(delta : float) -> void:
	if not player:
		return
	
	player.update_input_axis(true, false)
	
	player.update_facing_right()
	player.change_actor_speed(player.axis_strength.x, delta)


func set_target_node(NewTargetNode) -> void:
	if NewTargetNode is Player:
		player = NewTargetNode


func _change_terrain_state(new_state: Game.TerrainState) -> void:
	if new_state == Game.TerrainState.GROUND:
		player.air_jump_count = 0
		player.is_on_air = false
		if 0 < jump_buffer.time_left and player.can_actor_jump(true):
			player.jump(true, player.jump_velocity / (2 - int(Input.is_action_pressed("gc_jump"))))
			change_behaviour("/jump")
		else:
			change_behaviour(__get_target_ground_state())
		
		if not jump_buffer.is_stopped():
			jump_buffer.stop()

	elif new_state == Game.TerrainState.LIQUID:
		player.is_on_air = false
		change_behaviour("/swim-idle")


func __get_target_ground_state() -> String:
	if player.axis_strength.x == 0.0:
		return "/idle"
	elif player.is_walking:
		return "/walk"
	else:
		return "/run"
