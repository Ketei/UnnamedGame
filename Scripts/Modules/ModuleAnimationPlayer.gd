## AnimationPlayer set up for module manager with some custom functions.
extends AnimationPlayer
class_name ModuleAnimationPlayer

# PackName(String):ActionName(String):AnimationName(Array[String]) <- AnimationName(String)
## A dictionary that stores the string names of the actions inside their respective
## packs. Naming pattern is all lowercase with _ instead of whitespace.
var animation_list = {}

# Required for the manager to track them.
var module_type: String = "AnimationPlayer"

var is_module_enabled: bool = true : set = _module_is_module_enabled_override
var module_manager : ModuleManager


## Called by the module manager when setting up. Register animations here.
func set_up_module() -> void:
	pass
				


func _module_is_module_enabled_override(Value: bool) -> void:
	is_module_enabled = Value


## Gets the first registered animation of the pack[action] unless play random is true,
## if so, it'll get a random animation in the array.
func get_anim_in_action_pack(PackName: String, ActionName: String, GetRandom := false) -> String:
	if not is_action_in_pack(PackName, ActionName) or animation_list[PackName][ActionName].is_empty():
		return ""
	
	if GetRandom:
		return animation_list[PackName][ActionName].pick_random()
	else:
		return animation_list[PackName][ActionName].front()


## Returns true if the action key exists inside a pack. Ignores if the action has any animations registered.
func is_action_in_pack(PackName: String, ActionName: String) -> bool:
	if not animation_list.has(PackName):
		return false
	
	if not animation_list[PackName].has(ActionName):
		return false
	
	return true


## Registers an animation in the action name of the specified animation pack. If you want the animation to be
## the default of the action in the pack then it'll be inserted at the start of the array. It's reccomended
## to NOT preserve the order if registering as default, since this means ALL registered animations
# will have to be reindexed.
func register_animation(TargetPack: String, ActionName: String, AnimationKey: String, RegisterAsDefault := false,  PreserveOrder := false) -> void:
	if not is_module_enabled or not has_animation(AnimationKey):
		return
	
	if not animation_list.has(TargetPack):
		animation_list[TargetPack] = {}
	
	if not animation_list[TargetPack].has(ActionName):
		animation_list[TargetPack][ActionName] = []
	
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
	if not is_action_in_pack(TargetPack, TargetAction) or not is_module_enabled:
		return
	
	if PreserveOrder:
		animation_list[TargetPack][TargetAction].erase(AnimationKey)
	else:
		QuickMath.erase_array_element(AnimationKey, animation_list[TargetPack][TargetAction])
	
	
