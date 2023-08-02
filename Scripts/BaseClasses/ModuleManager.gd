extends Node
class_name ModuleManager

@export var parent_node: Node
# ModuleTypeName: ModuleID: ModuleNode
var _loaded_modules: Dictionary = {}


func _ready():
	for child in self.get_children():
		if child is Module or child is ModuleAnimationPlayer:
			if _loaded_modules.has(child.module_type.to_lower()):
				print_debug("This actor already has a " + child.module_type + " module.")
				print_debug(child.module_type + " will be set to be " + child.name)		
			_loaded_modules[child.module_type.to_lower()] = child
			child.module_manager = self
			child.set_up_module()


## Returns true if the module is present and loaded
func has_module(ModuleName: String) -> bool:
	return _loaded_modules.has(ModuleName.to_lower())


## Returns the reference to access the module from outside of the manager.
func get_module(ModuleName: String):
	var return_module = null
	if _loaded_modules.has(ModuleName.to_lower()):
		return_module = _loaded_modules[ModuleName.to_lower()]
	
	return return_module
