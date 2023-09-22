class_name ModuleBehaviour
extends Module


signal behaviour_changed(OldPackAndBehaviour: String, NewPackAndBehaviour: String)

## This is the behaviour pack that will be loaded initially when the node enters the scene.
## The pack should have a default behaviour to be loaded successfully, otherwise an error
## will be printed on the debug console.
@export var default_pack: BehaviourPack
@export var print_changes_in_debug: bool = false

var loaded_packs: Dictionary = {}
var current_pack: String = ""

var loaded_behaviour: Behaviour = null

var target_node: Node = null # The node that this module will apply on

var _original_behaviours: Dictionary = {} # Used to store replaced behaviours. One per ID


func _ready():
	module_type = "behaviour"
	module_priority = 99


func set_up_module() -> void:
	target_node = module_manager.parent_node

	for child in self.get_children():
		if not child is BehaviourPack:
			continue
		
		loaded_packs[child.behaviour_pack_id] = child
		child.set_up_pack(target_node, self)
	
	if default_pack:
		current_pack = default_pack.behaviour_pack_id
		
		if default_pack.default_behaviour:
			loaded_behaviour = default_pack.default_behaviour
			connect_behaviour_signals()
			loaded_behaviour.enter()
		else:
			print_debug("Error: No default behaviour loaded on pack: " + str(default_pack.get_path()))
	else:
		print_debug("Error: No default behaviour pack loaded on module: " + str(self.get_path()))


func module_handle_input(event):
	if not is_module_enabled or not loaded_behaviour:
		return

	loaded_behaviour.handle_input(event)


func module_handle_key_input(event):
	if not is_module_enabled or not loaded_behaviour:
		return
		
	loaded_behaviour.handle_key_input(event)


func module_physics_process(delta):
	if not is_module_enabled or not loaded_behaviour:
		return
	
	loaded_behaviour.handle_physics(delta)


## Changes to a behaviour in a loaded pack. Path is "pack_name/behaviour_name".
## Pack_name can be ommited if behaviour is in the same pack "/behaviour_name"
func change_behaviour(behaviour_path: String) -> void:
	var _path_array: Array = behaviour_path.split("/")
	var _behaviour = _path_array.back()
	var _pack = current_pack if _path_array.front() == "" else _path_array.front()
	
	if not loaded_behaviour.is_connected or not has_element(_pack, _behaviour):
		return
	
	var _behaviour_preload: Behaviour = loaded_packs[_pack].available_behaviours[_behaviour]
	var _old_behaviour: String = current_pack + "/" + loaded_behaviour.behaviour_id
	
	if current_pack != _pack:
		current_pack = _pack
	
	loaded_behaviour.exit()
	disconnect_behaviour_signals()
	loaded_behaviour = _behaviour_preload
	connect_behaviour_signals()
	behaviour_changed.emit(_old_behaviour, _pack + "/" + _behaviour)
	loaded_behaviour._change_signal_sent = false
	loaded_behaviour.enter()

	if print_changes_in_debug:
		print_debug("Changed behaviour from " + _old_behaviour + " to " + _pack + "/" + _behaviour)


func connect_behaviour_signals() -> void:
	if not loaded_behaviour.behaviour_changed.is_connected(change_behaviour):
		loaded_behaviour.behaviour_changed.connect(change_behaviour)
	if not loaded_behaviour.fsm_animation_state.is_connected(__animation_fsm_set_state):
		loaded_behaviour.fsm_animation_state.connect(__animation_fsm_set_state)
	if not loaded_behaviour.fsm_animation_replay.is_connected(__animation_replay):
		loaded_behaviour.fsm_animation_replay.connect(__animation_replay)


func disconnect_behaviour_signals() -> void:
	if loaded_behaviour.behaviour_changed.is_connected(change_behaviour):
		loaded_behaviour.behaviour_changed.disconnect(change_behaviour)
	if loaded_behaviour.fsm_animation_state.is_connected(__animation_fsm_set_state):
		loaded_behaviour.fsm_animation_state.disconnect(__animation_fsm_set_state)
	if loaded_behaviour.fsm_animation_replay.is_connected(__animation_replay):
		loaded_behaviour.fsm_animation_replay.disconnect(__animation_replay)


# Replaces one of the original behaviour packs for a custom one. The original pack is saved and can
# be restored with the function restore_behaviour_pack. Only the original packs are saved and not
# the custom ones.
func replace_behaviour_pack(PackToReplace: String, NewBehaviourPack: BehaviourPack) -> void:
	if not loaded_packs.has(PackToReplace):
		return
	
	backup_pack(loaded_packs[PackToReplace])
	
	if PackToReplace == current_pack:
		loaded_behaviour.exit()
		loaded_packs[PackToReplace] = NewBehaviourPack
		loaded_behaviour = loaded_packs[PackToReplace].default_behaviour
		loaded_behaviour.enter()
	else:
		loaded_packs[PackToReplace] = NewBehaviourPack


func add_behaviour_pack(PackToAdd: BehaviourPack) -> void:
	if not loaded_packs.has(PackToAdd.behaviour_pack_id):
		loaded_packs[PackToAdd.behaviour_pack_id] = PackToAdd
	else:
		print_debug("A pack with the same ID is already loaded. Either use the replace function or change the pack ID")


func remove_behaviour_pack(PackToRemove: String) -> void:
	if PackToRemove == current_pack or not has_element(PackToRemove):
		print_debug("The pack you're trying to remove is currently loaded or doesn't exist so it can't be removed.")
		return
	
	loaded_packs.erase(PackToRemove)
	

func backup_pack(PackToBackup: BehaviourPack) -> void:
	if _original_behaviours.has(PackToBackup.behaviour_pack_id):
		return
	
	_original_behaviours[PackToBackup.behaviour_pack_id] = PackToBackup


# Restores a behaviour pack as long as it exists. To get a list of pack backups use get_replaced_pack_list
func restore_pack(PackToRestore: String) -> void:
	if not _original_behaviours.has(PackToRestore):
		return
		
	loaded_packs[PackToRestore] = _original_behaviours[PackToRestore]
	
	if PackToRestore == current_pack:
		loaded_behaviour.exit()
		loaded_behaviour = loaded_packs[PackToRestore].default_behaviour
		loaded_behaviour.enter()
		
	_original_behaviours.erase(PackToRestore)


func has_element(pack_name: String, behaviour_name: String = "") -> bool:
	var _return_bool: bool = loaded_packs.has(pack_name)
	
	if _return_bool and behaviour_name != "":
		_return_bool = loaded_packs[pack_name].available_behaviours.has(behaviour_name)

	return _return_bool


func get_backup_pack_list() -> Array:
	return _original_behaviours.keys()


func __animation_fsm_set_state(Path: String, TargetState: String) -> void:
	module_manager.change_animation_state(Path, TargetState)


func __animation_use_alt_set(Path: String, AlternateSet: String) -> void:
	module_manager.change_animation_set(Path, AlternateSet)


func __animation_replay(PlayRandom: bool) -> void:
	module_manager.replay_animation(PlayRandom)

