class_name ModuleManager
extends Node


@export var parent_node: Node
@export var move_and_slide: bool = false

var loaded_modules: Dictionary = {}
var module_references: Array = []


func _ready():
	if parent_node:
		parent_node.module_manager = self
		
	var _module_init: Dictionary = {}
	
	for child in self.get_children():
		if not __is_valid_module(child):
			continue
		
		if not _module_init.has(str(child.module_priority)):
			_module_init[str(child.module_priority)] = []
		
		_module_init[str(child.module_priority)].append(child)
	
	for prio in range(_module_init.size()):
		var loading_prio: int = QuickMath.array_get_lowest_numberi(_module_init.keys())
		
		for module in _module_init[str(loading_prio)]:
			
			module.module_manager = self
			module.set_up_module()
		
			__warn_if_repeated_modules(module.module_type)
		
			loaded_modules[module.module_type] = module

		_module_init.erase(str(loading_prio))
	
	for reference in loaded_modules:
		module_references.append(loaded_modules[reference])
	#module_references.make_read_only() # Should I make the reference array read only?


func _physics_process(delta):
	for module in module_references:
		if module is ModuleAnimationPlayer:
			continue
		module.module_physics_process(delta)
	
	if move_and_slide and parent_node is CharacterBody2D:
		parent_node.move_and_slide()
		

func _unhandled_input(event):	
	for module in module_references:
		if module is ModuleAnimationPlayer:
			continue
		module.module_handle_input(event)


func _unhandled_key_input(event):
	for module in module_references:
		if module is ModuleAnimationPlayer:
			continue
		module.module_handle_key_input(event)


## Returns true if the module is present and loaded
func has_module(module_name: String) -> bool:
	return loaded_modules.has(module_name)


## Returns the reference to access the module from outside of the manager.
func get_module(module_name: String):
	if loaded_modules.has(module_name):
		return loaded_modules[module_name]
	else:
		return null


# --- ModuleAnimation Functions ----
## Changes a state of the animation state machine inside the animation module.
func change_animation_state(path: String, new_state: String) -> void:
	if not has_module("animation-player"):
		return
	
	get_module("animation-player").set_anim_state(path, new_state)


## Uses an alternate animation set. 
func change_animation_set(path: String, alt_set: String) -> void:
	if not has_module("animation-player"):
		return
	
	get_module("animation-player").use_alternate_animations(path, alt_set)
	

func replay_animation(play_random: bool) -> void:
	if not has_module("animation-player"):
		return
	
	get_module("animation-player").replay_animation(play_random)
#-----------------------------------


# --- Module EffectApplier ---
func apply_effect(EffectToApply: Effect) -> void:
	if has_module("effect-applier"):
		get_module("effect-applier").add_effect(EffectToApply)


func remove_effect(EffectID: String) -> void:
	if has_module("effect-applier"):
		get_module("effect-applier").remove_effect(EffectID)
# ----------------------------


# --- Module Terrain Tracker ---
func get_terrain_state() -> Game.TerrainState:
	if not has_module("terrain-tracker"):
		return Game.TerrainState.GROUND
	
	return get_module("terrain-tracker").terrain_state
# ------------------------------


# Private functions
func __warn_if_repeated_modules(ModuleType: String) -> void:
	if loaded_modules.has(ModuleType):
		print_debug("This actor already has a " + ModuleType + " module.")
		print_debug(ModuleType + " will be replaced")		


func __is_valid_module(ObjectToCheck) -> bool:
	if ObjectToCheck is Module or ObjectToCheck is ModuleAnimationPlayer:
		return true
	else:
		print_debug(str(ObjectToCheck) + " is not a valid module")
		return false

