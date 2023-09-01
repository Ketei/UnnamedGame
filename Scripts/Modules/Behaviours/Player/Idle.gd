extends Behaviour
# Behaviour set up for actors

var actor: Player

func setup_behaviour() -> void:
	behaviour_id = "idle"
	is_default = true


func enter(_args:= {}):
	if not actor:
		return
	
	if actor.is_crouching:
		change_animation.emit("movement-ground", "idle-crouch", false)
	else:
		change_animation.emit("movement-ground", "idle", false)


func handle_key_input(event : InputEvent) -> void:
	if not actor:
		return
	
	if event.is_action_pressed("gc_crouch"):
		actor.is_crouching = not actor.is_crouching
		
		if actor.is_crouching:
			change_animation.emit("movement-ground", "idle-crouch", false)
		else:
			change_animation.emit("movement-ground", "idle", false)
	
	elif event.is_action_pressed("gc_walk"):
		actor.is_walking = not actor.is_walking
	
	elif event.is_action_pressed("gc_left") or event.is_action_pressed("gc_right"):
		if Input.get_axis("gc_left", "gc_right") == 0:
			return
		
		if actor.movement_status == actor.MovementSpeed.RUN:
			change_behaviour.emit("movement", "run")
		else:
			change_behaviour.emit("movement", "walk")


func set_target_node(NewTargetNode) -> void:
	if NewTargetNode is Player:
		actor = NewTargetNode

