extends Node
class_name Behaviour

# Behaviour Module
signal behaviour_changed(behaviour_path: String)

# Animation Nodes
signal fsm_animation_state(state_path: String, new_state: String)
signal fsm_animation_replay(play_random: bool)
signal use_alternate_animation_set(state_path: String, alternate_set: String)

# References
var behaviour_module: ModuleBehaviour

# Set to true if the behaviour is to be loaded as default. This is only relevant for packs that
# are loaded as default/initial.
var is_default: bool = false

# This is the type of behaviour this is, it's unique inside each ModuleBehaviour.
# Some common behaviours id's are: "movement", "action", "weapon"
var behaviour_id: String = ""

# When a behaviour is connected it can transition to other behaviours. Disconnecting the
# behaviour means that this behaviour will ignore all transition signals. Useful if you
# want to force a state no matter what.
var is_connected: bool = true

var _change_signal_sent: bool = false

func enter(_args:= {}):
	pass


func exit():
	pass


func handle_input(_event : InputEvent) -> void:
	pass


func handle_key_input(_event: InputEvent) -> void:
	pass


func handle_physics(_delta : float) -> void:
	pass


func setup_behaviour() -> void:
	pass


func set_target_node(_new_target_node) -> void:
	pass


func change_behaviour(behaviour_path: String) -> void:
	if _change_signal_sent:
		return
	behaviour_changed.emit(behaviour_path)
	
	
