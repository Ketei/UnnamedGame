extends Node
class_name Effect

## Name to display on the UI
@export var effect_name: String = ""
## Description to display on the UI
@export_multiline var description: String = ""

## An array that contains all the stat changes this effect. To be filled
## with EffectComponent objects only. When the effects start they will be moved
## to active effect list.
var effects_list: Array = []

## Active effects, don't set manually
var _active_effect_list: Array[EffectComponent] = []

var effect_id: String

var target_manager: ModuleManager


func start_effect() -> void:
	for effect in effects_list:
		if not effect is EffectComponent:
			continue

		effect.module_manager = target_manager
		effect.start_effect()
		
		if effect.apply_once:
			effect.end_effect()
		else:
			_active_effect_list.append(effect)

	effects_list.clear()


func apply_effect(delta: float) -> void:
	for effect in _active_effect_list:
		effect.apply_effect(delta)


func end_effect() -> void:
	for effect in _active_effect_list:
		effect.end_effect()

