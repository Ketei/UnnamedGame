extends Node
class_name InteractTracker

# Priority(str): ObjectNameUnique(str): Object(Node)
var _tracked_objects: Dictionary = {}
var can_interact: bool = false


func _update_interact() -> void:
	if 0 < _tracked_objects.size():
		if not can_interact:
			can_interact = true
	else:
		if can_interact:
			can_interact = false


func get_interact_object(ObjectPriority: int, ObjectName: String):
	var variable_return = null
	if _tracked_objects.has(str(ObjectPriority)):
		if _tracked_objects[str(ObjectPriority)].has(ObjectName):
			variable_return = _tracked_objects[str(ObjectPriority)][ObjectName]
	
	return variable_return


func get_rand_interact_object(HighPrio: bool = true):
	var variable_return = null
	var high_prio = get_priority_level(HighPrio)
	if -1 < high_prio:
		var keylist = _tracked_objects[str(high_prio)].keys()
		variable_return = _tracked_objects[str(high_prio)][keylist[0]]
	return variable_return


func get_object_list_of_prio(PrioSearch: int) -> Array:
	var item_array: Array = []
	if _tracked_objects.has(str(PrioSearch)):
		item_array = _tracked_objects[str(PrioSearch)].keys()
	return item_array


func get_priority_level(GetHighPrio: bool = true) -> int:
	var prio_key: int = -1
	if not _tracked_objects.is_empty():
		var number_array: Array = []
		
		for priority in _tracked_objects.keys():
			number_array.append(int(priority))
		
		if GetHighPrio:
			prio_key = number_array.min()
		else:
			prio_key = number_array.max()
		
	return prio_key


func add_node(Priority: int, NewNode: InteractableObject) -> void:
	Priority = abs(Priority)
	if not _tracked_objects.has(str(Priority)):
		_tracked_objects[str(Priority)] = {}
	
	if _tracked_objects[str(Priority)].has(NewNode.unique_id):
		while _tracked_objects[str(Priority)].has(NewNode.unique_id):
			NewNode.unique_id = ObjectInteractions.generate_unique_name([NewNode.name, NewNode.interact_key])
	
	_tracked_objects[str(Priority)][NewNode.unique_id] = NewNode
	
	_update_interact()


func remove_node(NodePriority: int, NodeKey: String) -> void:
	if _tracked_objects.has(str(NodePriority)):
		if _tracked_objects[str(NodePriority)].has(NodeKey):
			_tracked_objects[str(NodePriority)].erase(NodeKey)

		if _tracked_objects[str(NodePriority)].size() < 1:
			_tracked_objects.erase(str(NodePriority))
			_update_interact()
