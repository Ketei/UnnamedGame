extends Node
## Keeps track of a state. The topmost state machine must always have the
## name of "root". Name is not case sensitive.
class_name StateMachine

## True means that this state machine has state machines for states.
@export var initial_state: Node = null
## Conditions for a transition to occour.
## Key is the target state. Value(Dictionary) contains conditions required
## to transition. If all conditions are fullfilled set_state will be called.
@export var transition_conditions: Dictionary = {}
var _possible_states: Dictionary = {}
# True if the current_state and _possible_states are state machines
var current_state = null # Holds the VALUE of a possible state
var current_state_id: String = ""


func load_state_machine():
	for child in get_children():
		_possible_states[child.name.to_lower()] = child
		if child is StateMachine:
			child.load_state_machine()
	
	if initial_state:
		var _value_index: int = _possible_states.values().find(initial_state)
		if 0 <= _value_index:
			current_state = initial_state
			current_state_id = _possible_states.keys()[_value_index]
	print(_possible_states)


## Gets the state machine current state. It also returns the path as string
func get_state():
	if current_state is StateMachine:
		return current_state.get_state()
	else:
		return current_state


## Returns the full path up to the state
func get_state_path(_pathBuilding: String = "") -> String:
	var _path_build: String = _pathBuilding + name.to_lower() + "/" 
	if current_state is StateMachine:
		return current_state.get_state_path(_path_build)
	else:
		return _path_build + current_state_id


func set_state(StateToChangeTo: String) -> void:
	if _possible_states.has(StateToChangeTo):
		current_state_id = StateToChangeTo
		current_state = _possible_states[StateToChangeTo]


## Iterates through conditions dictionary and transitions if all conditions
## are fullfilled. Transitions to the first fullfilled state
func send_conditions(Conditions: Dictionary) -> void:
	for target_state in transition_conditions.keys():
		if transition_conditions[target_state] == Conditions:
			set_state(target_state)
			break


func has_state(StateToCheck: String) -> bool:
	return _possible_states.has(StateToCheck)


func add_state(StateID: String, StateToAdd) -> void:
	_possible_states[StateID] = StateToAdd


func remove_state(StateID: String) -> void:
	_possible_states.erase(StateID)


## Returns the value of an element by it's given path.
func travel_down(Path: String, _pathArray: Array = [], _arrayIndex: int = 0, _arraySize: int = 0):
	if _pathArray.is_empty():
		Path.to_lower()
		_pathArray = Path.split("/", false)
		_arraySize = _pathArray.size()
	
	if _arraySize == 0:
		return null
	
	if _arrayIndex == _arraySize -1 and _pathArray[_arrayIndex] == name.to_lower():
		return self
	
	if not _possible_states.has(_pathArray[_arrayIndex + 1]):
		return null
		
	if _arraySize - 1 == _arrayIndex + 1:
		return _possible_states[_pathArray[_arrayIndex + 1]]
	elif _possible_states[_pathArray[_arrayIndex + 1]] is StateMachine:
		return _possible_states[_pathArray[_arrayIndex + 1]].travel_down(Path, _pathArray, _arrayIndex + 1, _arraySize)
	else:
		return null


func get_possible_state(StateID: String):
	return _possible_states[StateID]


## Checks if a possible state is of a type. Check types enums in GlobalScope.
## Variant.Type
func is_possible_state_type(StateID: String, StateType: int) -> bool:
	return StateType == typeof(_possible_states[StateID])


func is_state_type(StateType: int) -> bool:
	return typeof(current_state) == StateType

