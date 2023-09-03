extends Node
class_name Module

# Required for the manager to track them.
var module_type: String = ""
var module_priority: int = 0

var is_module_enabled: bool = false : set = _module_enabled_override
var module_manager : ModuleManager

## Called by the module manager when setting up.
func set_up_module() -> void:
	is_module_enabled = true


func _module_enabled_override(Value: bool) -> void:
	is_module_enabled = Value


func module_physics_process(_delta: float) -> void:
	pass


func module_handle_key_input(_event) -> void:
	pass


func module_handle_input(_event) -> void:
	pass
