class_name ModuleStats
extends Module
## This module handles statistics. These can be health, stamina, strenght,
## lust, etc. Each element has a max, min and current value
## (along with their previous_* counterpart). These statistics are components
## ComponentStat.

enum StatType {GENERIC, SKILL, LUST}

# References
## These components will trigger a lust update when changed
## For this to happen stat_name must exist in GameProperties.lust_effects
@export var lust_components: Array[ComponentStat]
## These components will trigger a skill update when changed.
## For this to happen stat_name must exist in GameProperties.skill_effects
@export var skill_components: Array[ComponentStat]


var _available_statistics: Dictionary = {}


func _ready():
	module_type = "status"
	module_priority = 0

	for child in get_children():
		if child is ComponentStat:
			_available_statistics[child.stat_name] = child
	
	for lust in lust_components:
		lust.stat_changed.connect(lust_update)
	
	for skill in skill_components:
		skill.stat_changed.connect(skill_update)


func add_component(component_to_add: ComponentStat, stat_type := StatType.GENERIC) -> void:
	_available_statistics[component_to_add.stat_name] = component_to_add
	
	if stat_type == StatType.SKILL:
		skill_components.append(component_to_add)
		component_to_add.stat_changed.connect(skill_update)
	elif stat_type == StatType.LUST:
		lust_components.append(component_to_add)
		component_to_add.stat_changed.connect(lust_update)


func has_stat(stat_name: String) -> void:
	return _available_statistics.has(stat_name)


func get_stat(stat_name: String) -> ComponentStat:
	return _available_statistics[stat_name]


## Triggered on component signal
func lust_update(component: ComponentStat) -> void:
	for stat_changed in GameProperties.lust_effects.keys():
		if not _available_statistics.has(stat_changed):
			continue
		_available_statistics[stat_changed].change_mod(
				GameProperties.get_lust_effects(
						stat_changed, 
						component.current_value, 
						component.previous_current_value))


## Triggered on component signal
func skill_update(component: ComponentStat) -> void:
	if not GameProperties.skill_effects.has(component.stat_name):
		return
	
	var _skill_changes: Dictionary = GameProperties.get_skill_effects(component.stat_name, component.current_value, component.previous_value)
	
	if _skill_changes.is_empty():
		return
	
	for skill_name in _skill_changes.keys():
		if _available_statistics.has(skill_name):
			_available_statistics[skill_name].change_mod(_skill_changes[skill_name])

