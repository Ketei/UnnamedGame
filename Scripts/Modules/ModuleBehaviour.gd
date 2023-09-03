extends Module
class_name ModuleBehaviour

signal behaviour_changed(OldBehaviour: String, NewBehaviour: String)
signal change_animation(AnimPack: String, AnimAction: String, PlayRandom: bool)

## This is the behaviour pack that will be loaded initially when the node enters the scene.
## The pack should have a default behaviour to be loaded successfully, otherwise an error
## will be printed on the debug console.
@export var default_pack: BehaviourPack

var loaded_packs: Dictionary = {}

var _original_behaviours: Dictionary = {} # Used to store replaced behaviours. One per ID
var loaded_behaviour: Behaviour = null
var current_pack: String = ""

var target_node: Node = null # The node that this module will apply on


func change_behaviour(TargetPack: String, NewBehaviour: String) -> void:
	if not is_module_enabled or not loaded_behaviour.behaviour_connected or not check_for_pack_and_behaviour(TargetPack, NewBehaviour):
		return
	
	var _behaviour_preload: Behaviour = loaded_packs[TargetPack].available_behaviours[NewBehaviour]
	var _old_behaviour: String = loaded_behaviour.behaviour_id

	loaded_behaviour.exit()
	disconnect_behaviour_signals()
	loaded_behaviour = _behaviour_preload
	connect_behaviour_signals()
	current_pack = TargetPack
	loaded_behaviour.enter()
	behaviour_changed.emit(_old_behaviour, loaded_behaviour.behaviour_id)


func connect_behaviour_signals() -> void:
	if not loaded_behaviour.change_animation.is_connected(_change_anim_signal):
		loaded_behaviour.change_animation.connect(_change_anim_signal)
	if not loaded_behaviour.change_behaviour.is_connected(change_behaviour):
		loaded_behaviour.change_behaviour.connect(change_behaviour)


func disconnect_behaviour_signals() -> void:
	if loaded_behaviour.change_animation.is_connected(_change_anim_signal):
		loaded_behaviour.change_animation.disconnect(_change_anim_signal)
	if loaded_behaviour.change_behaviour.is_connected(change_behaviour):
		loaded_behaviour.change_behaviour.disconnect(change_behaviour)


func check_for_pack_and_behaviour(PackToCheck: String, BehaviourToCheck: String = "") -> bool:
	var _return_bool: bool = false
	
	if loaded_packs.has(PackToCheck):
		_return_bool = true
	
	if _return_bool and BehaviourToCheck != "":
		_return_bool = loaded_packs[PackToCheck].available_behaviours.has(BehaviourToCheck)
	
	return _return_bool


# (Dis)Connects the behaviour from the others. Preventing the exit of the behaviour if the actor is
# in it, or preventing it's entry if not. If no behaviour name is given, it'll change the currently loaded
# behaviour
func behaviour_connection(IsConnected: bool, BehaviourName: String = "", TargetPack: String = "") -> void:
	if not is_module_enabled:
		return

	if TargetPack == "":
		TargetPack = current_pack
	if BehaviourName == "":
		loaded_behaviour.behaviour_connected = IsConnected
	elif check_for_pack_and_behaviour(TargetPack, BehaviourName):
		loaded_packs[TargetPack].available_behaviours[BehaviourName].behaviour_connected = IsConnected


# Replaces one of the original behaviour packs for a custom one. The original pack is saved and can
# be restored with the function restore_behaviour_pack. Only the original packs are saved and not
# the custom ones.
func replace_behaviour_pack(PackToReplace: String, NewBehaviourPack: BehaviourPack) -> void:
	if not is_module_enabled or not loaded_packs.has(PackToReplace):
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
	if not is_module_enabled:
		return
	
	if not loaded_packs.has(PackToAdd.behaviour_pack_id):
		loaded_packs[PackToAdd.behaviour_pack_id] = PackToAdd
	else:
		print_debug("A pack with the same ID is already loaded. Either use the replace function or change the pack ID")


func remove_behaviour_pack(PackToRemove: String) -> void:
	if PackToRemove == current_pack or not check_for_pack_and_behaviour(PackToRemove):
		print_debug("The pack you're trying to remove is currently loaded or doesn't exist so it can't be removed.")
		return
	
	loaded_packs.erase(PackToRemove)
	

func backup_pack(PackToBackup: BehaviourPack) -> void:
	if _original_behaviours.has(PackToBackup.behaviour_pack_id):
		return
	
	_original_behaviours[PackToBackup.behaviour_pack_id] = PackToBackup


# Restores a behaviour pack as long as it exists. To get a list of pack backups use get_replaced_pack_list
func restore_pack(PackToRestore: String) -> void:
	if not is_module_enabled or not _original_behaviours.has(PackToRestore):
		return
		
	loaded_packs[PackToRestore] = _original_behaviours[PackToRestore]
	
	if PackToRestore == current_pack:
		loaded_behaviour.exit()
		loaded_behaviour = loaded_packs[PackToRestore].default_behaviour
		loaded_behaviour.enter()
		
	_original_behaviours.erase(PackToRestore)


func get_backup_pack_list() -> Array:
	return _original_behaviours.keys()


func load_pack(PackName: String) -> void:
	if not check_for_pack_and_behaviour(PackName):
		return
	
	if loaded_packs[PackName].default_behaviour:
		loaded_behaviour = loaded_packs[PackName].default_behaviour
		current_pack = PackName
		loaded_behaviour.enter()


func _input(event):
	if not is_module_enabled or not loaded_behaviour:
		return

	loaded_behaviour.handle_input(event)


func _unhandled_key_input(event):
	if not is_module_enabled or not loaded_behaviour:
		return
		
	loaded_behaviour.handle_key_input(event)


func _physics_process(delta):
	if not is_module_enabled or not loaded_behaviour:
		return
	
	loaded_behaviour.handle_physics(delta)


func set_up_module() -> void:
	module_type = "behaviour"
	target_node = module_manager.parent_node

	for child in self.get_children():
		if not child is BehaviourPack:
			continue
		
		loaded_packs[child.behaviour_pack_id] = child
		child.set_up_pack(target_node, self)
	
	if default_pack:
		if default_pack.default_behaviour:
			loaded_behaviour = default_pack.default_behaviour
			current_pack = default_pack.behaviour_pack_id
			connect_behaviour_signals()
			loaded_behaviour.enter()
			behaviour_changed.emit("null", loaded_behaviour.behaviour_id)
		else:
			print_debug("Error: No default behaviour loaded on pack: " + str(default_pack.get_path()))
	else:
		print_debug("Error: No default behaviour pack loaded on module: " + str(self.get_path()))
	
	is_module_enabled = true


func _change_anim_signal(Pack: String, Action: String, Random: bool) -> void:
	change_animation.emit(Pack, Action, Random)

