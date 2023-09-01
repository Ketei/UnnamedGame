extends Behaviour
# Behaviour set up for Actors

var actor : Player
var _axis_direction: float

func setup_behaviour() -> void:
	behaviour_id = "run"


func enter(_args:= {}):
	if not actor:
		return

	change_animation.emit("movement-ground", "run", false)


func handle_key_input(event : InputEvent) -> void:
	if not actor:
		return
	
	if event.is_action_pressed("gc_jump"):
		change_behaviour.emit("movement", "jump")
	elif event.is_action_pressed("gc_crouch"):
		actor.is_crouching = not actor.is_crouching
		if actor.movement_status == actor.MovementSpeed.CROUCH:
			change_behaviour.emit("movement", "walk")
	elif event.is_action_pressed("gc_walk"):
		actor.is_walking = not actor.is_walking
		if actor.movement_status == actor.MovementSpeed.WALK:
			change_behaviour.emit("movement", "walk")


func handle_physics(delta : float) -> void:
	if not actor:
		return
	
	_axis_direction = Input.get_axis("gc_left", "gc_right")
	
	if actor.velocity.x == 0 and _axis_direction == 0:
		change_behaviour.emit("movement", "idle")
		return
	
	set_facing_direction()
	actor.change_actor_speed(_axis_direction, delta)


func set_target_node(NewTargetNode) -> void:
	if NewTargetNode is Player:
		actor = NewTargetNode


func set_facing_direction():
	if _axis_direction != 0:
		actor.set_facing_right(0 < actor.velocity.x)

