extends Behaviour
# Behaviour set up for actors

var player: Player

func setup_behaviour() -> void:
	behaviour_id = "idle"
	is_default = true


func enter(_args:= {}):
	if not player:
		return
	
	if player.is_crouching:
		change_animation.emit("movement-ground", "idle-crouch", false)
	else:
		change_animation.emit("movement-ground", "idle", false)


func handle_key_input(event : InputEvent) -> void:
	if not player:
		return
	
	if event.is_action_pressed("gc_jump"):
		if player.can_actor_jump():
			print("Let'sa jump")
			player.jump()
			change_behaviour.emit("movement", "jump")
	
	elif event.is_action_pressed("gc_crouch"):
		player.is_crouching = not player.is_crouching
		
		if player.is_crouching:
			change_animation.emit("movement-ground", "idle-crouch", false)
		else:
			change_animation.emit("movement-ground", "idle", false)
	
	elif event.is_action_pressed("gc_walk"):
		player.is_walking = not player.is_walking
	
	elif event.is_action_pressed("gc_left") or event.is_action_pressed("gc_right"):
		if Input.get_axis("gc_left", "gc_right") == 0:
			return
		
		if player.movement_status == player.MovementSpeed.RUN:
			change_behaviour.emit("movement", "run")
			print("GoToRun")
		else:
			change_behaviour.emit("movement", "walk")
			print("GoToWalk")


func set_target_node(NewTargetNode) -> void:
	if NewTargetNode is Player:
		player = NewTargetNode


func handle_physics(delta : float) -> void:
	if not player:
		return
	
	player.apply_gravity(delta)
	player.move_and_slide()
