extends Node
class_name Behaviour

signal change_behaviour(BehaviourPackTarget: String, BehaviourTarget: String)
signal change_animation(AnimPack: String, AnimAction: String, PlayRandom: bool)

# Set to true if the behaviour is to be loaded as default. This is only relevant for packs that
# are loaded as default/initial.
var is_default: bool = false

# This is the type of behaviour this is, it's unique inside each ModuleBehaviour.
# Some common behaviours id's are: "movement", "action", "weapon"
var behaviour_id: String = ""
var behaviour_module: ModuleBehaviour

# When a behaviour is connected it can transition to other behaviours. Disconnecting the
# behaviour means that this behaviour will ignore all transition signals. Useful if you
# want to force a state no matter what.
var behaviour_connected: bool = true

# Use a variable of a specific class to target all changes to an object and retain predictions. 
# Override the function set_target_node to set up your target node of the desired type.
# Example: If your object variable object is of type Player, then override with:
# if NewTargetNode is Player -> target_node = NewTargetNode.

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


func set_target_node(_NewTargetNode) -> void:
	pass
