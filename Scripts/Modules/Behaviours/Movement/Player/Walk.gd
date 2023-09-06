extends Behaviour

var player: Player
var terrain_tracker: ModuleTerrainTracker


func enter(_args:= {}):
	if not player:
		return
	
	if player.is_crouching:
		change_animation.emit("movement-ground", "walk-crouch", false)
	else:
		change_animation.emit("movement-ground", "walk", false)
	
	terrain_tracker.terrain_changed.connect(_change_terrain_state)


func exit():
	if terrain_tracker.terrain_changed.is_connected(_change_terrain_state):
		terrain_tracker.terrain_changed.disconnect(_change_terrain_state)


func handle_key_input(event: InputEvent) -> void:
	if not player:
		return
	
	if event.is_action_pressed("gc_jump"):
		if player.can_actor_jump(true):
			player.jump(true)
			terrain_tracker.temp_disable_ground_raycast(0.2)
			change_behaviour.emit("movement", "jump")
	
	elif event.is_action_pressed("gc_crouch"):
		player.is_crouching = not player.is_crouching

		if player.is_crouching:
			change_animation.emit("movement-ground", "crouch")
		elif player.is_walking:
			change_animation.emit("movement-ground", "walk")
		else:
			change_behaviour.emit("movement", "run")
	
	elif event.is_action_pressed("gc_walk"):
		player.is_walking = not player.is_walking
		
		if not player.is_walking:
			change_behaviour.emit("movement", "run")


func handle_physics(delta : float) -> void:
	if not player:
		return
	
	player.update_input_axis(true, false)
	
	if player.axis_strenght.x == 0 and player.velocity.x == 0:
		change_behaviour.emit("movement", "idle")
		return
	
	if player.axis_strenght.x != 0:
		player.set_facing_right(0 < player.axis_strenght.x)
	
	player.apply_gravity(delta)
	player.change_actor_speed(player.axis_strenght.x, delta)
	player.move_and_slide()


func setup_behaviour() -> void:
	behaviour_id = "walk"
	terrain_tracker = behaviour_module.module_manager.get_module("terrain-tracker")


func set_target_node(NewTargetNode) -> void:
	if NewTargetNode is Player:
		player = NewTargetNode


func _change_terrain_state(NewState: GameProperties.TerrainState) -> void:
	if NewState == GameProperties.TerrainState.AIR:
		if 0 < player.velocity.y:
			change_behaviour.emit("movement", "fall")
		else:
			change_behaviour.emit("movement", "jump")
	elif NewState == GameProperties.TerrainState.LIQUID:
		change_behaviour.emit("movement", "swim-idle")

