extends Behaviour

var player: Player

func enter(_args:= {}):
	change_animation.emit("movement-air", "fall")


func handle_physics(delta : float) -> void:
	if not player:
		return
	
	#if behaviour_module.module_manager.is_on_ground():
	#	change_behaviour.emit("movement", "idle")
	
	player.apply_gravity(delta)
	player.change_actor_speed(Input.get_axis("gc_left", "gc_right"), delta)
	player.move_and_slide()


func setup_behaviour() -> void:
	behaviour_id = "fall"


func set_target_node(NewTargetNode) -> void:
	if NewTargetNode is Player:
		player = NewTargetNode
