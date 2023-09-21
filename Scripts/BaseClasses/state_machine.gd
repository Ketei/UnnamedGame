class_name StateMachine
extends Node
## Keeps track of a state. The topmost state machine must always have the
## name of "root". Name is not case sensitive.


## Emited when the current state changes.
signal state_changed(machine_ref)

## If the current state is a nested state machine and that machine changes
## this signal will be emited.
signal nested_machine_changed(machine_ref)

## The key for the initial state. This value must exist in the states_stack
## in ordet to be set correctly.
@export var initial_state_key: String = ""
## Conditions for a transition to occour.
## Key is the target state. Value(Dictionary) contains conditions required
## to transition. If all conditions are fullfilled set_state will be called.
@export var transition_conditions: Dictionary = {}
## If the state machine is locked, it'll prevent any transitions to new states.
@export var is_locked: bool = false

## Holds all the possible states the state machine can have
var states_stack: Dictionary = {}

## The value the current state machine is in.
var current_state = null

## The key of the current_state in states_stack.
var current_state_id: String = ""

## If this state machine is the top-level machine or is a nested one.
var _is_top_level: bool = true


## Function used to initialize the state machine and any nested machines
## it might have. If it isn't run the state machine might not function properly.
## This will also add direct node childs of the state machine to the possible
## states.
func ready_state_machine():
	for child in get_children():
		states_stack[child.name.to_lower()] = child
		if child is StateMachine:
			child.ready_state_machine()
			child._is_top_level = false
	
	if initial_state_key in states_stack.keys():
		#current_state = states_stack[initial_state_key]
		#current_state_id = initial_state_key
		set_state(initial_state_key)


func set_transition_conditions(target_state: String, conditions: Dictionary) -> void:
	if not states_stack.has(target_state) or conditions.is_empty():
		print_debug(
				"Target state doesn't exist or conditions provided are empty.\n
				Conditions for transition will not be added")
		return
	
	if transition_conditions.has(target_state):
		print_debug(
				"Conditions for target state already exist. 
				Tehy will be replaced with the provided ones.")
	
	transition_conditions[target_state] = conditions


## Iterates through conditions dictionary and transitions if all conditions
## are fullfilled. Transitions to the first fullfilled state
func send_conditions(Conditions: Dictionary) -> void:
	for target_state in transition_conditions.keys():
		if transition_conditions[target_state] == Conditions:
			set_state(target_state)
			break


## Adds a possible state to the state machine. It's reccomended that if creating
## it proggramatically to add states on the _ready function and then run
## ready_state_machine()
func add_state(state_name: String, state_to_add) -> void:
	states_stack[state_name] = state_to_add


## Removes a possible state
func remove_state(state_name: String) -> void:
	states_stack.erase(state_name)


## Returns the value of an element by it's given path.
func travel_down(path: String, _path_array: Array = [], _array_index: int = 0, _array_size: int = 0):
	if _path_array.is_empty():
		path.to_lower()
		_path_array = path.split("/", false)
		_array_size = _path_array.size()
	
	if _array_size == 0:
		return null
	
	if _array_index == _array_size -1 and _path_array[_array_index] == name.to_lower():
		return self
	
	if not states_stack.has(_path_array[_array_index + 1]):
		return null
		
	if _array_size - 1 == _array_index + 1:
		return states_stack[_path_array[_array_index + 1]]
	elif states_stack[_path_array[_array_index + 1]] is StateMachine:
		return states_stack[_path_array[_array_index + 1]].travel_down(path, _path_array, _array_index + 1, _array_size)
	else:
		return null


## Checks if a possible state is of a type. Check types enums in GlobalScope.
## If state_name is empty it'll check the loaded state
func is_state_type(state_type: int, state_name: String = "") -> bool:
	if state_name == "":
		return state_type == typeof(current_state)
	else:
		return state_type == typeof(states_stack[state_name])


## Returns true if the state name is a possible state in the machine.
func has_state(state_name: String) -> bool:
	return states_stack.has(state_name)


## Gets the state machine current state. If the current state is a state machine
## it'll give that state machine's current state.
func get_current_state():
	if current_state is StateMachine:
		return current_state.get_current_state()
	else:
		return current_state


## Returns the value of a state inside of states stack
func get_state(state_name: String):
	return states_stack[state_name]


## Returns the full path of the current state. If the current state is a state
## machine it'll include it in the path and return that machine's state.
func get_state_path(_path_building: String = "") -> String:
	var _path_build: String = _path_building + name.to_lower() + "/" 
	if current_state is StateMachine:
		return current_state.get_state_path(_path_build)
	else:
		return _path_build + current_state_id


## Returns a reference of the state machine setting the current state. This
## includes nested machines.
func get_current_state_machine() -> StateMachine:
	if current_state is StateMachine:
		return current_state.get_current_state_machine()
	else:
		return self


## Sets a new state if it's contained in the states stack. It'll also emit a
## changed signal if successfully transitioned.
func set_state(target_state: String) -> void:
	if not states_stack.has(target_state) or target_state == current_state_id or is_locked:
		return
	
	if _is_top_level and current_state is StateMachine: # Used to prevent signal bubbling
		__disconect_nested(get_current_state_machine())
	
	current_state_id = target_state
	current_state = states_stack[target_state]
	
	if _is_top_level and current_state is StateMachine: # Used to prevent signal bubbling
		__connect_nested(get_current_state_machine())
	
	state_changed.emit(self)


func __disconect_nested(machine_reference: StateMachine) -> void:
	if machine_reference.state_changed.is_connected(__nested_changed):
		machine_reference.state_changed.disconnect(__nested_changed)


func __connect_nested(machine_reference: StateMachine) -> void:
	if not machine_reference.state_changed.is_connected(__nested_changed):
		machine_reference.state_changed.connect(__nested_changed)


func __nested_changed(machine_ref: StateMachine) -> void:
	nested_machine_changed.emit(machine_ref)

