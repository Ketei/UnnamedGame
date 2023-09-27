class_name BehaviourPack
extends Node


var default_behaviour: Behaviour
var behaviour_module: ModuleBehaviour # Reference
var available_behaviours: Dictionary = {}

@export var behaviour_pack_id: String = ""


func set_up_pack(target_node: Node, manager_node: ModuleBehaviour) -> void:
	_pre_set_up(target_node, manager_node)
	behaviour_module = manager_node
	for child in get_children():
		if not child is Behaviour:
			continue
		
		child.pack_id = behaviour_pack_id
		child.behaviour_module = manager_node
		child.set_target_node(target_node)
		child.setup_behaviour()
		
		__warn_if_duplicate_behaviour(child)
		
		available_behaviours[child.behaviour_id] = child
		if child.is_default:
			default_behaviour = child
	_post_set_up(target_node, manager_node)


func _pre_set_up(_TargetNode: Node, _BehaviourModule: ModuleBehaviour) -> void:
	pass


func _post_set_up(_TargetNode: Node, _BehaviourModule: ModuleBehaviour) -> void:
	pass


func __warn_if_duplicate_behaviour(BehaviourToCheck: Behaviour) -> void:
	if BehaviourToCheck.behaviour_id in available_behaviours.keys():
		print_debug("Duplicate behaviours encoutered. Duplicate ID: " + BehaviourToCheck.behaviour_id)
		print_debug("Bevahiour node: " + str(BehaviourToCheck.get_path()))
		print_debug("Previous behaviour will be replaced.")

