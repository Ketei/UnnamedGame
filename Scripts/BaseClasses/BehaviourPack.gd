extends Node
class_name BehaviourPack

var default_behaviour: Behaviour
var available_behaviours: Dictionary = {}

@export var behaviour_pack_id: String = ""


func set_up_pack(TargetNode: Node, ManagerNode: Node) -> void:

	for child in get_children():
		if not child is Behaviour:
			continue
		
		child.behaviour_module = ManagerNode
		child.set_target_node(TargetNode)
		child.setup_behaviour()
		
		warn_if_duplicate_behaviour(child)
		
		available_behaviours[child.behaviour_id] = child
		if child.is_default:
			default_behaviour = child


func warn_if_duplicate_behaviour(BehaviourToCheck: Behaviour) -> void:
	if BehaviourToCheck.behaviour_id in available_behaviours.keys():
		print_debug("Duplicate behaviours encoutered. Duplicate ID: " + BehaviourToCheck.behaviour_id)
		print_debug("Bevahiour node: " + str(BehaviourToCheck.get_path()))
		print_debug("Previous behaviour will be replaced.")

