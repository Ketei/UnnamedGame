class_name ModuleAnimationPlayer
extends AnimationPlayer
## AnimationPlayer set up for module manager with some custom functions.


@export var is_module_enabled: bool = true : set = _module_enabled_override
## If true custom_play will play random animations unless the argument is
## overriden in the function
@export var play_random_animation: bool = false
@export var state_machine: StateMachine

# Required for the manager to track them.
var module_type: String = "animation-player"
var module_priority: int = 0

# References
var module_manager: ModuleManager = null
var animations_list: AnimationList


## Called by the module manager when setting up.
func set_up_module() -> void:
	if state_machine:
		state_machine.ready_state_machine()
		_register_animations()
		custom_play()
		state_machine.state_changed.connect(__anim_updated)
		state_machine.nested_machine_changed.connect(__anim_updated)


## Overridable function. Use it to call register_animation/s if needed.
func _register_animations() -> void:
	pass


func _module_enabled_override(is_enabled: bool) -> void:
	if is_module_enabled != is_enabled:
		is_module_enabled = is_enabled
		if is_enabled:
			play()
		else:
			pause()


## Custom function for the module. Does exactly the same as play() but picks
## the animation from the state machine.
func custom_play(play_random: bool = play_random_animation, custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false) -> void:
	var _preload_list = state_machine.get_current_state()
	if _preload_list != animations_list:
		animations_list = _preload_list
		play(animations_list.get_animation(play_random), custom_blend, custom_speed, from_end)
	if not is_module_enabled:
		pause()


func replay_animation(PlayRandom: bool = play_random_animation) -> void:
	if is_module_enabled:
		play(animations_list.get_animation(PlayRandom))


## Registers a single animation to an ActionKey
func register_animation(animation_path: String, animation_key: String) -> void:
	if not has_animation(animation_key):
		return
	
	var __target_fsm : AnimationList = state_machine.travel_down(animation_path)
	if not __target_fsm:
		return
	
	__target_fsm.add_animation(animation_key)


## Registers a whole array of animations to an ActionKey
func register_animations(animation_path: String, animation_keys: Array[String]) -> void:
	var __verified_animations: Array = []
	
	for anim_name in animation_keys:
		if not has_animation(anim_name):
			continue
		__verified_animations.append(anim_name)

	var __target_fsm: AnimationList = state_machine.travel_down(animation_path)
	
	if not __target_fsm:
		return
	
	__target_fsm.add_animations(__verified_animations)


func set_default_animation(state_path: String, animation_key: String) -> void:
	var _anim_list: AnimationList = state_machine.travel_down(state_path)
	if not _anim_list:
		return
	_anim_list.set_default_animation(animation_key)
	if _anim_list == animations_list:
		custom_play()


func set_anim_state(animation_path: String, new_state: String) -> void:
	var _fsm: StateMachine = state_machine.travel_down(animation_path)
	if not _fsm:
		return
	_fsm.set_state(new_state)
	
	#custom_play()


func set_alternate_animations(animation_path: String, alternate_set: String) -> void:
	var _anim_list: AnimationList = state_machine.travel_down(animation_path)
	if not _anim_list:
		return
	if _anim_list == animations_list and _anim_list.set_animation_override(alternate_set):
		custom_play()


func __anim_updated(_state_machine: StateMachine) -> void:
	custom_play()

