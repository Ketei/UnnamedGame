## AnimationPlayer set up for module manager with some custom functions.
extends AnimationPlayer
class_name ModuleAnimationPlayer

## If true custom_play will play random animations unless the argument is
## overriden in the function
@export var play_random: bool = false

var animation_state_machine: StateMachine
var current_anim_list: AnimationList

# Required for the manager to track them.
var module_type: String = "animation-player"
var module_priority = 0

var is_module_enabled: bool = true : set = _module_enabled_override
var module_manager : ModuleManager


## Registers a single animation to an ActionKey
func register_animation(AnimationPath: String, AnimationKey: String) -> void:
	if not is_module_enabled or not has_animation(AnimationKey):
		return
	
	var _target_fsm : AnimationList = animation_state_machine.travel_down(AnimationPath)
	if not _target_fsm:
		return
	
	_target_fsm.add_animation(AnimationKey)


## Registers a whole array of animations to an ActionKey
func register_animations(AnimationPath: String, ActionKey: String, AnimationKeys: Array[String]) -> void:
	if not is_module_enabled:
		return
		
	var _verified_animations: Array = []
	
	for anim_name in AnimationKeys:
		if not has_animation(anim_name):
			continue
		_verified_animations.append(anim_name)

	var _target_fsm: AnimationList = animation_state_machine.travel_down(AnimationPath)
	
	if not _target_fsm:
		return
	
	_target_fsm.add_animations(_verified_animations)


## Called by the module manager when setting up. Register animations here.
func set_up_module() -> void:
	is_module_enabled = true


func _module_enabled_override(Value: bool) -> void:
	is_module_enabled = Value


func set_default_animation(StatePath: String, AnimationKey: String) -> void:
	var _fsm: AnimationList = animation_state_machine.travel_down(StatePath)
	if not _fsm:
		return
	_fsm.set_default_animation(AnimationKey)
	if _fsm == current_anim_list:
		custom_play()


func set_anim_state(AnimationPath: String, NewState: String) -> void:
	var _fsm: StateMachine = animation_state_machine.travel_down(AnimationPath)
	if not _fsm:
		return
	_fsm.set_state(NewState)
	
	custom_play()


func set_alternate_animations(AnimationPath: String, AlternateSet: String) -> void:
	var _fsm: AnimationList = animation_state_machine.travel_down(AnimationPath)
	if not _fsm:
		return
	if _fsm == current_anim_list and _fsm.set_animation_override(AlternateSet):
		custom_play()


## Custom function for the module. Does exactly the same as play() but picks
## the animation from the state machine.
func custom_play(PlayRandom: bool = play_random, CustomBlend: float = -1, CustomSpeed: float = 1.0, FromEnd: bool = false) -> void:
	var _preload_list = animation_state_machine.get_state()
	if _preload_list != current_anim_list:
		current_anim_list = _preload_list
		play(current_anim_list.get_animation(PlayRandom), CustomBlend, CustomSpeed, FromEnd)


func replay_animation(PlayRandom: bool = play_random) -> void:
	play(current_anim_list.get_animation(PlayRandom))
