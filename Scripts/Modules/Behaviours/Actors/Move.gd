extends Behaviour
# Behaviour set up for Actors

var player : Actor


func setup_behaviour() -> void:
	if behaviour_module.module_manager.parent_actor is Actor:
		player = behaviour_module.module_manager.parent_actor
	else:
		print_debug("Warning: This behaviour is inteded for Actors.\nUse of this behaviour on anything else could lead to crashes.")


func enter(_args:= {}):
	pass


func exit():
	pass


func handle_input(_event : InputEvent) -> void:
	pass
		

func handle_physics(delta : float) -> void:
	var action_strenght = Input.get_axis("gc_left", "gc_right")
	player.move_actor(action_strenght, delta)

