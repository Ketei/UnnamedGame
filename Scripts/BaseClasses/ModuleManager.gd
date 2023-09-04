extends Node
class_name ModuleManager

signal change_animation(AnimPack: String, AnimAction: String)

@export var parent_node: Node
# ModuleTypeName: ModuleID: ModuleNode
var _loaded_modules: Dictionary = {}
var _loaded_modules_array: Array = []
var _module_init: Dictionary = {}

func _ready():
	for child in self.get_children():
		if not _is_object_a_valid_module(child):
			continue
		
		if not _module_init.has(str(child.module_priority)):
			_module_init[str(child.module_priority)] = []
		
		_module_init[str(child.module_priority)].append(child)
	
	for prio in range(_module_init.size()):
		var loading_prio: int = QuickMath.array_get_lowest_numberi(_module_init.keys())
		
		for module in _module_init[str(loading_prio)]:
			module.module_manager = self
			module.set_up_module()
		
			warn_if_repeated_modules(module.module_type)
		
			_loaded_modules[module.module_type] = module

			if module is ModuleBehaviour:
				module.change_animation.connect(_change_animation)
		_module_init.erase(str(loading_prio))
	
	_loaded_modules_array = _loaded_modules.keys()


func _is_object_a_valid_module(ObjectToCheck) -> bool:
	if ObjectToCheck is Module or ObjectToCheck is ModuleAnimationPlayer:
		return true
	else:
		print_debug(str(ObjectToCheck) + " is not a valid module")
		return false


## Returns true if the module is present and loaded
func has_module(ModuleName: String) -> bool:
	return _loaded_modules.has(ModuleName)


## Returns the reference to access the module from outside of the manager.
func get_module(ModuleName: String):
	if _loaded_modules.has(ModuleName):
		return _loaded_modules[ModuleName]
	else:
		return null


func register_module(NewModule: Module) -> void:
	if has_module(NewModule.module_type):
		print_debug("The module you're trying to register already exist")
		return
	NewModule.module_manager = self
	NewModule.set_up_module()
	_loaded_modules[NewModule.module_type] = NewModule
	_loaded_modules_array.append(NewModule.module_type)


func warn_if_repeated_modules(ModuleType: String) -> void:
	if _loaded_modules.has(ModuleType):
		print_debug("This actor already has a " + ModuleType + " module.")
		print_debug(ModuleType + " will be replaced")		


func _change_animation(Pack: String, Action: String, PlayRandom: bool) -> void:
	if not has_module("animation-player"):
		return
	
	get_module("animation-player").custom_play(Pack, Action, PlayRandom)


func actor_submerged(IsActorSubmerged: bool) -> void:
	if not parent_node is Actor:
		return
	
	if parent_node.is_swimming != IsActorSubmerged:
		parent_node.is_swimming = IsActorSubmerged


func apply_effect(EffectToApply: Effect) -> void:
	if has_module("effect-applier"):
		get_module("effect-applier").add_effect(EffectToApply)


func remove_effect(EffectID: String) -> void:
	if has_module("effect-applier"):
		get_module("effect-applier").remove_effect(EffectID)


func get_terrain_state() -> GameProperties.TerrainState:
	if not has_module("terrain-tracker"):
		return GameProperties.TerrainState.GROUND
	
	return get_module("terrain-tracker").terrain_state
	

func _physics_process(delta):
	for module in _loaded_modules_array:
		_loaded_modules[module].module_physics_process(delta)


func _unhandled_input(event):
	for module in _loaded_modules_array:
		_loaded_modules[module].module_handle_input(event)


func _unhandled_key_input(event):
	for module in _loaded_modules_array:
		_loaded_modules[module].module_handle_key_input(event)

