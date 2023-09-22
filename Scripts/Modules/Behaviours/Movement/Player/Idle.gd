extends Behaviour
# Behaviour set up for actors

var player: Player
var terrain_tracker: ModuleTerrainTracker


func _ready():
	behaviour_id = "idle"
	is_default = true


func setup_behaviour() -> void:
	terrain_tracker = behaviour_module.module_manager.get_module("terrain-tracker")


func enter(_args:= {}):
	if not player:
		return

	if terrain_tracker.terrain_state == GameProperties.TerrainState.AIR:
		if player.velocity.y < 0:
			change_behaviour("/jump")
		else:
			change_behaviour("/fall")
		return
	
	player.update_input_axis(true, false)
	
	if player.axis_strength.x != 0:
		if player.is_walking:
			change_behaviour("/walk")
		else:
			change_behaviour("/run")
	
	if player.air_jump_count != 0:
		player.air_jump_count = 0
	
	if not terrain_tracker.terrain_changed.is_connected(__change_terrain_state):
		terrain_tracker.terrain_changed.connect(__change_terrain_state)
	
	fsm_animation_state.emit("root/ground/movement", "idle")


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
			change_behaviour("/jump")
	
	elif event.is_action_pressed("gc_crouch"):
		player.is_crouching = not player.is_crouching
	elif event.is_action_pressed("gc_walk"):
		player.is_walking = not player.is_walking
	elif event.is_action_released("gc_walk") and player.walk_hold:
		player.is_walking = false


func set_target_node(new_target_node) -> void:
	if new_target_node is Player:
		player = new_target_node


func handle_physics(delta : float) -> void:
	if not player:
		return
	
	player.update_input_axis(true, false)
	
	if player.axis_strength.x != 0.0:
		if player.is_walking:
			change_behaviour("/walk")
		else:
			change_behaviour("/run")
		return
	
	player.change_actor_speed(0.0, delta)


func __change_terrain_state(new_state: GameProperties.TerrainState) -> void:
	if new_state == GameProperties.TerrainState.AIR:
		if 0 <= player.velocity.y:
			change_behaviour("/fall")
			behaviour_module.module_manager.get_module("timers-manager").get_timer("coyote-timer").start()
		else:
			change_behaviour("/jump")
	elif new_state == GameProperties.TerrainState.LIQUID:
		change_behaviour("/swim-idle")

