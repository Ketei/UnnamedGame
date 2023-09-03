extends Behaviour

var player: Player


func enter(_args:= {}):
	if not player:
		return
	
	change_animation.emit("movement-air", "jump")
	player.jump()
	
	if not Input.is_action_pressed("gc_jump"):
		if 0 < player.velocity.y:
			player.velocity.y /= 2
		_go_to_fall()


func handle_key_input(event: InputEvent) -> void:
	if not player:
		return
	
	if event.is_action_released("gc_jump"):
		if 0 < player.velocity.y:
			player.velocity.y /= 2.0
		_go_to_fall()


func handle_physics(delta : float) -> void:
	if not player:
		return
	
	if 0 <= player.velocity.y:
		_go_to_fall()
	
	player.apply_gravity(delta)
	player.change_actor_speed(Input.get_axis("gc_left", "gc_right"), delta)
	player.move_and_slide()

func setup_behaviour() -> void:
	behaviour_id = "jump"


func set_target_node(NewTargetNode) -> void:
	if NewTargetNode is Player:
		player = NewTargetNode


func _go_to_fall() -> void:
	player.gravity_mode = player.GravityMode.NORMAL
	change_behaviour.emit("movement-air", "fall")

