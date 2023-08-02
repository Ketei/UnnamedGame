extends Node
class_name MiniModuleEffect

@export_enum("Base", "Mod") var apply_to: int = 0
## Wheter to revert the values changed by this effect to their original ones
## when this effect ends. Enabling this will make the effect keep track of values changes.
@export var revert_on_end: bool = false
## If enabled, status effects will apply only once when the effect enters. And then
## immediatly the exit effects will triger. This skips runs of on_apply_effect()
@export var apply_once: bool = true
## Executes custom on_apply_effect(), on_start_effect() and on_end_effect before changing stats. If false
## they will be exectuted after stats changes.
@export var apply_custom_effect_first: bool = true
## If true  all pre-made vitality changes will only execture custom effects.
@export var apply_custom_effects_only: bool = false


var target_vitality: ModuleVitality

# It's safe to override these 3 functions on pre-made subclasses
## Overridable function called when the effect is initially applied
func on_start_effect():
	pass

## Overridable function called when the effect is initially applied
func on_apply_effect(Delta: float):
	pass

## Overridable function called when the effect is removed
func on_end_effect():
	pass


## Used when the effect is initially added. Don't override on pre-made subclasses
func _start_effect() -> void:
	pass

## Effect ran on every physics frame. Don't override on pre-made subclasses
func _apply_effect(Delta: float):
	pass

## Effect triggered when exiting. Don't override on pre-made subclasses
func _end_effect():
	pass
