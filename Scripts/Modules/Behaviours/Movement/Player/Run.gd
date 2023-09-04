extends Behaviour
# Behaviour set up for Actors

var player : Player
var _axis_direction: float
var terrain_tracker: ModuleTerrainTracker

func setup_behaviour() -> void:
	behaviour_id = "run"
	terrain_tracker = behaviour_module.module_manager.get_module("terrain-tracker")


func enter(_args:= {}):
	if not player:
		return
	
	change_animation.emit("movement-ground", "run", false)
	terrain_tracker.terrain_changed.connect(_change_terrain_state)


func exit():
	if terrain_tracker.terrain_changed.is_connected(_change_terrain_state):
		terrain_tracker.terrain_changed.disconnect(_change_terrain_state)


func handle_key_input(event : InputEvent) -> void:
	if not player:
		return
	
	if event.is_action_pressed("gc_jump"):
		if player.jump(true):
			terrain_tracker.temp_disable_ground_raycast(0.2)
			change_behaviour.emit("movement", "jump")
	elif event.is_action_pressed("gc_crouch"):
		player.is_crouching = not player.is_crouching
		if player.is_crouching:
			change_behaviour.emit("movement", "walk")
	elif event.is_action_pressed("gc_walk"):
		player.is_walking = not player.is_walking
		if player.is_walking:
			change_behaviour.emit("movement", "walk")


func handle_physics(delta : float) -> void:
	if not player:
		return
	
	_axis_direction = Input.get_axis("gc_left", "gc_right")
	
	if player.velocity.x == 0 and _axis_direction == 0:
		change_behaviour.emit("movement", "idle")
		return
	
	player.apply_gravity(delta)
	set_facing_direction()
	player.change_actor_speed(_axis_direction, delta)
	player.move_and_slide()


func set_target_node(NewTargetNode) -> void:
	if NewTargetNode is Player:
		player = NewTargetNode


func set_facing_direction():
	if _axis_direction != 0:
		player.set_facing_right(0 < player.velocity.x)


func _change_terrain_state(NewState: GameProperties.TerrainState) -> void:
	if NewState == GameProperties.TerrainState.AIR:
		if 0 < player.velocity.y:
			change_behaviour.emit("movement", "fall")
		else:
			change_behaviour.emit("movement", "jump")
	elif NewState == GameProperties.TerrainState.LIQUID:
		change_behaviour.emit("movement", "swim-idle")
