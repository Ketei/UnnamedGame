extends Node
class_name EffectComponent

@export_enum("MOD", "BASE") var apply_to: int = 0
## Wheter to revert the values changed by this effect to their original ones
## when this effect ends. Enabling this will make the effect keep track of values changes.
@export var revert_on_end: bool = false
## If enabled, status effects will apply only once when the effect enters.
@export var apply_once: bool = true
## If enabled, effect will be removed immediatly after applying the effect. This triggers _end_effect()
## It'll be ignored if apply_once is set to false.
@export var end_after_apply: bool = false

var module_manager: ModuleManager


## Used when the effect is initially added. Don't override on pre-made subclasses
func start_effect() -> void:
	pass

## Effect ran on every physics frame. Don't override on pre-made subclasses
func apply_effect(_delta: float):
	pass

## Effect triggered when exiting. Don't override on pre-made subclasses
func end_effect():
	pass
