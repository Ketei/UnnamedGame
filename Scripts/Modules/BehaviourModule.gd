extends Module
class_name ModuleBehaviour

signal behaviour_changed(OldBehaviour: String, NewBehaviour: String)

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
	if is_module_enabled:
		var _behaviour_preload: Behaviour
		var _old_behaviour: String
		if loaded_behaviour.behaviour_connected and is_module_enabled:
			if loaded_packs.has(TargetPack):
				if loaded_packs[TargetPack].available_behaviours.has(NewBehaviour):
					_behaviour_preload = loaded_packs[TargetPack].available_behaviours[NewBehaviour]
					_old_behaviour = loaded_behaviour.behaviour_id
					loaded_behaviour.exit()
					loaded_behaviour = _behaviour_preload
					current_pack = TargetPack
					loaded_behaviour.enter()
					behaviour_changed.emit(_old_behaviour, loaded_behaviour.behaviour_id)


# (Dis)Connects the behaviour from the others. Preventing the exit of the behaviour if the actor is
# in it, or preventing it's entry if not. If no behaviour name is given, it'll change the currently loaded
# behaviour
func behaviour_connection(IsConnected: bool, BehaviourName: String = "", TargetPack: String = "") -> void:
	if is_module_enabled:
		if TargetPack == "":
			TargetPack = current_pack
		
		if BehaviourName == "":
			loaded_behaviour.behaviour_connected = IsConnected
		else:
			if loaded_packs.has(TargetPack):
				if loaded_packs[TargetPack].available_behaviours.has(BehaviourName):
					loaded_packs[TargetPack].available_behaviours[BehaviourName].behaviour_connected = IsConnected


# Replaces one of the original behaviour packs for a custom one. The original pack is saved and can
# be restored with the function restore_behaviour_pack. Only the original packs are saved and not
# the custom ones.
func replace_behaviour_pack(PackToReplace: String, NewBehaviourPack: BehaviourPack) -> void:
	if is_module_enabled:
		if loaded_packs.has(PackToReplace):
			if not _original_behaviours.has(PackToReplace):
				_original_behaviours[PackToReplace] = loaded_packs[PackToReplace]
			loaded_packs[PackToReplace] = NewBehaviourPack


func add_behaviour_pack(PackToAdd: BehaviourPack) -> void:
	if is_module_enabled:
		if not loaded_packs.has(PackToAdd.behaviour_pack_id):
			loaded_packs[PackToAdd.behaviour_pack_id] = PackToAdd
		else:
			print_debug("A pack with the same ID is already loaded. Either use the replace function or change the pack ID")


# Restores a behaviour pack as long as it exists. To get a list of pack backups use get_replaced_pack_list
func restore_behaviour_pack(PackToRestore: String) -> void:
	if is_module_enabled:
		if _original_behaviours.has(PackToRestore):
			loaded_packs[PackToRestore] = _original_behaviours[PackToRestore]
			_original_behaviours.erase(PackToRestore)


func get_replaced_pack_list() -> Array:
	return _original_behaviours.keys()


func _input(event):
	if is_module_enabled:
		if loaded_behaviour:
			loaded_behaviour.handle_input(event)


func _physics_process(delta):
	if is_module_enabled:
		if loaded_behaviour:
			loaded_behaviour.handle_physics(delta)


func set_up_module() -> void:
	module_type = "behaviour"
	target_node = module_manager.parent_node

	for child in self.get_children():
		if child is BehaviourPack:
			loaded_packs[child.behaviour_pack_id] = child
			child.set_up_pack(target_node)
	
	if default_pack:
		if default_pack.default_behaviour:
			loaded_behaviour = default_pack.default_behaviour
			current_pack = default_pack.behaviour_pack_id
			loaded_behaviour.enter()
			behaviour_changed.emit("null", loaded_behaviour.behaviour_id)
		else:
			print_debug("Error: No default behaviour loaded on pack: " + str(default_pack.get_path()))
	else:
		print_debug("Error: No default behaviour pack loaded on module: " + str(self.get_path()))
	
	is_module_enabled = true

