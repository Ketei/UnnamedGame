extends Node
class_name ModuleManager

signal change_animation(AnimPack: String, AnimAction: String)

@export var parent_node: Node
# ModuleTypeName: ModuleID: ModuleNode
var _loaded_modules: Dictionary = {}


func _ready():
	for child in self.get_children():
		if not _is_object_a_valid_module(child):
			continue
		
		warn_if_repeated_modules(child.module_type)
		
		_loaded_modules[child.module_type] = child
		child.module_manager = self
		child.set_up_module()
		
		if child is ModuleBehaviour:
			child.change_animation.connect(_change_animation)


func _is_object_a_valid_module(ObjectToCheck) -> bool:
	if ObjectToCheck is Module:
		return true
	elif ObjectToCheck is ModuleAnimationPlayer:
		return true
	else:
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


func warn_if_repeated_modules(ModuleType: String) -> void:
	if _loaded_modules.has(ModuleType):
		print_debug("This actor already has a " + ModuleType + " module.")
		print_debug(ModuleType + " will be replaced")		


func _change_animation(Pack: String, Action: String, PlayRandom: bool):
	if not has_module("animation-player"):
		return
	
	get_module("animation-player").custom_play(Pack, Action, PlayRandom)

