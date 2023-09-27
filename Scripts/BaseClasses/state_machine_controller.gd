class_name StateMachineController
extends Node
## This script is to help change nested state machines in a single call.


@export var state_machine: StateMachine

# call(String):path(string):state_id(string)
@export var state_arguments: Dictionary = {}

## Changes the state of all state machines in the key "call_id" to the stored
## state
func change_state(call_id: String) -> void: 
	if not state_arguments.has(call_id):
		return
	
	for state_path in state_arguments[call_id].keys():
		state_machine.travel_down(state_path).set_state(
				state_arguments[call_id][state_path])


func register_state_group(call_id: String, fsm_path: String, target_state: String) -> void:
	if not state_arguments.has(call_id):
		state_arguments[call_id] = {}
	
	state_arguments[call_id][fsm_path] = target_state

