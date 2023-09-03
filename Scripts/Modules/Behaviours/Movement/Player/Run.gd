extends Behaviour
# Behaviour set up for Actors

var player : Player
var _axis_direction: float

func setup_behaviour() -> void:
	behaviour_id = "run"


func enter(_args:= {}):
	if not player:
		return
	
	change_animation.emit("movement-ground", "run", false)


func handle_key_input(event : InputEvent) -> void:
	if not player:
		return
	
	if event.is_action_pressed("gc_jump"):
		if player.can_actor_jump():
			print("Let's jump")
			change_behaviour.emit("movement", "jump")
	elif event.is_action_pressed("gc_crouch"):
		player.is_crouching = not player.is_crouching
		if player.movement_status == player.MovementSpeed.CROUCH:
			change_behaviour.emit("movement", "walk")
	elif event.is_action_pressed("gc_walk"):
		player.is_walking = not player.is_walking
		if player.movement_status == player.MovementSpeed.WALK:
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

