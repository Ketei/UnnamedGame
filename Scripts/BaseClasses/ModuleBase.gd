extends Node
class_name Module

# Required for the manager to track them.
var module_type: String = ""

var is_module_enabled: bool = false : set = _module_enabled_override
var module_manager : ModuleManager

## Called by the module manager when setting up.
func set_up_module() -> void:
	is_module_enabled = true


func _module_enabled_override(Value: bool) -> void:
	is_module_enabled = Value
