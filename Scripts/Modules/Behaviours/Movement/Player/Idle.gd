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
		#return
	if terrain_tracker.terrain_state == GameProperties.TerrainState.AIR:
		if player.velocity.y < 0:
			change_behaviour.emit("movement", "jump")
		else:
			change_behaviour.emit("movement", "fall")
		return
	
	if player.air_jump_count != 0:
		player.air_jump_count = 0

	terrain_tracker.terrain_changed.connect(_change_terrain_state)
	
	if player.is_crouching:
		change_animation.emit("movement-ground", "idle-crouch", false)
	else:
		change_animation.emit("movement-ground", "idle", false)
	

func exit():
	if terrain_tracker.terrain_changed.is_connected(_change_terrain_state):
		terrain_tracker.terrain_changed.disconnect(_change_terrain_state)


func handle_key_input(event : InputEvent) -> void:
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
			change_animation.emit("movement-ground", "idle-crouch", false)
		else:
			change_animation.emit("movement-ground", "idle", false)
	elif event.is_action_pressed("gc_walk"):
		player.is_walking = not player.is_walking


func set_target_node(NewTargetNode) -> void:
	if NewTargetNode is Player:
		player = NewTargetNode


func handle_physics(delta : float) -> void:
	if not player:
		return
	
	player.update_input_axis(true, false)
	
	if player.axis_strenght.x != 0.0:
		if player.is_walking:
			change_behaviour.emit("movement", "walk")
		else:
			change_behaviour.emit("movement", "run")
		return
	
	player.change_actor_speed(0.0, delta)
	player.apply_gravity(delta)
	player.move_and_slide()


func _change_terrain_state(NewState: GameProperties.TerrainState) -> void:
	if NewState == GameProperties.TerrainState.AIR:
		if 0 < player.velocity.y:
			change_behaviour.emit("movement", "fall")
			behaviour_module.module_manager.get_module("timers-manager").get_timer("coyote-timer").start()
		else:
			change_behaviour.emit("movement", "jump")
	elif NewState == GameProperties.TerrainState.LIQUID:
		change_behaviour.emit("movement", "swim-idle")

