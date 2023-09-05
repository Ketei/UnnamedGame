## AnimationPlayer set up for module manager with some custom functions.
extends AnimationPlayer
class_name ModuleAnimationPlayer

# PackName(String):ActionName(String):AnimationName(Array[String]) <- AnimationName(String)
## A dictionary that stores the string names of the actions inside their respective
## packs. Naming pattern is all lowercase with _ instead of whitespace.
var animation_list = {}

# Required for the manager to track them.
var module_type: String = "animation-player"
var module_priority = 0

var is_module_enabled: bool = true : set = _module_enabled_override
var module_manager : ModuleManager

var current_pack: String = ""


## Called by the module manager when setting up. Register animations here.
func set_up_module() -> void:
	pass


func _module_enabled_override(Value: bool) -> void:
	is_module_enabled = Value


## Gets the first registered animation of the pack[action] unless play random is true,
## if so, it'll get a random animation in the array.
func get_anim_in_action_pack(PackName: String, ActionName: String, GetRandom := false) -> String:
	if not anims_available(PackName, ActionName):
		return ""
	
	if GetRandom:
		return animation_list[PackName][ActionName].pick_random()
	else:
		return animation_list[PackName][ActionName].front()


func anims_available(PackName: String, ActionName: String) -> bool:
	if not is_anim_in_list(PackName, ActionName):
		return false
	
	return !animation_list[PackName][ActionName].is_empty()


func is_anim_in_list(PackName: String, ActionName: String = "", AnimationName: String = "") -> bool:
	var _return_bool: bool = false
	
	if animation_list.has(PackName):
		_return_bool = true
	
	if ActionName == "" or not _return_bool:
		return _return_bool
	
	if not animation_list[PackName].has(ActionName):
		_return_bool = false
	
	if AnimationName == "" or not _return_bool:
		return _return_bool

	if not animation_list[PackName][ActionName].has(AnimationName):
		_return_bool = false
	
	return _return_bool


## Registers an animation in the action name of the specified animation pack. If you want the animation to be
## the default of the action in the pack then it'll be inserted at the start of the array. It's reccomended
## to NOT preserve the order if registering as default, since this means ALL registered animations
# will have to be reindexed.
func register_animation(TargetPack: String, ActionName: String, AnimationKey: String, RegisterAsDefault := false,  PreserveOrder := false) -> void:
	if not is_module_enabled or not has_animation(AnimationKey):
		return
		
	anim_data_validation(TargetPack, ActionName)
	
	if RegisterAsDefault:
		if PreserveOrder:
			animation_list[TargetPack][ActionName].insert(0, AnimationKey)
		else:
			QuickMath.insert_in_array(0, AnimationKey, animation_list[TargetPack][ActionName])
	else:
		animation_list[TargetPack][ActionName].append(AnimationKey)


## Unregisters an animation in the action name of the specified animation pack. It's reccomended
## NOT to preserve the order since this means all registered animations to the right will have to be reindexed.
func unregister_animation(TargetPack: String, TargetAction: String, AnimationKey: String, PreserveOrder := false) -> void:
	if is_anim_in_list(TargetPack, TargetAction, AnimationKey) or not is_module_enabled:
		return
	
	if PreserveOrder:
		animation_list[TargetPack][TargetAction].erase(AnimationKey)
	else:
		QuickMath.erase_array_element(AnimationKey, animation_list[TargetPack][TargetAction])


func set_default_animation(TargetPack: String, ActionName: String, AnimationKey: String) -> void:
	if not is_anim_in_list(TargetPack, ActionName, AnimationKey):
		return
	
	QuickMath.array_bring_to_front(AnimationKey, animation_list[TargetPack][ActionName])


func anim_data_validation(PackName: String, ActionName: String) -> void:
	if not animation_list.has(PackName):
		animation_list[PackName] = {}
	
	if not animation_list[PackName].has(ActionName):
		animation_list[PackName][ActionName] = []


## Custom function for the module. Does exactly the same as play() but picks the animation by giving it
## a pack and action.
func custom_play(PackName: String, ActionName: String, RandomAnim: bool = false, CustomBlend: float = -1, CustomSpeed: float = 1.0, FromEnd: bool = false) -> void:
	var _anim_to_play: String = get_anim_in_action_pack(PackName, ActionName, RandomAnim)

	if _anim_to_play != "":
		play(_anim_to_play, CustomBlend, CustomSpeed, FromEnd)

