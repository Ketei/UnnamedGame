extends Node
class_name BehaviourPack

signal transition_to(TargetPack: String, TargetBehaviour: String)

# It is reccoemended that all packs have a default behaviour. This is the behaviour
# that will be loaded initially by the behaviour module if it's in the default
# behaviour pack. It won't be loaded initially if it's not the default behaviour
# pack and instead a call will need to be made.
@export var default_behaviour: Behaviour

var available_behaviours: Dictionary = {}

var behaviour_pack_id: String = ""
var loaded_behaviour: Behaviour = null


func _emit_change_signal(PackTarget: String, BehaviourTarget: String):
	transition_to.emit(PackTarget, BehaviourTarget)


func set_up_pack(TargetNode: Node) -> void:
	for child in get_children():
		if child is Behaviour:
			if child.behaviour_id in available_behaviours.keys():
				print_debug("Duplicate behaviours encoutered. Duplicate ID: " + child.behaviour_id)
				print_debug("Previous behaviour will be replaced.")
			available_behaviours[child.behaviour_id] = child
			child.set_target_node(TargetNode)
			child.setup_behaviour()
			if child.is_default:
				default_behaviour = child

	for behaviour in available_behaviours.keys():
		available_behaviours[behaviour].change_behaviour.connect(_emit_change_signal)
