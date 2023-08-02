extends Node
class_name Effect

## Name to display on the UI
@export var effect_name: String = ""
## Description to display on the UI
@export_multiline var description: String = ""

## An array that contains all the stat changes this effect. To be filled
## with MiniModuleEffect objects only.
var effects_list: Array = []

var target_vitality_module: ModuleVitality

var effect_id: String


func start_effect(TargetModule: ModuleVitality, EffectId: String):
	for effect in effects_list:
		if effect is MiniModuleEffect:
			effect.target_vitality = TargetModule
			effect._start_effect()


func apply_effect(delta: float) -> void:
	for effect in effects_list:
		if effect is MiniModuleEffect:
			effect._apply_effect()
			


func _end_effect() -> void:
	for effect in effects_list:
		if effect is MiniModuleEffect:
			effect._end_effect()

