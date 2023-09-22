extends Node
class_name AnimationList

@export var animation_list: Array[String] = []
## Alternate animations. To use them instead of main list animation_override
## must be a valid key and not be empty.
@export var alternate_animations: Dictionary = {}
## Animation override can only be set to the keys of alternate_animations or empty("")
@export var animation_override: String = "":
	set(value):
		if alternate_animations.has(value) or value == "":
			animation_override = value


func add_animation(AnimationName: String, IsDefault: bool = false) -> void:
	if IsDefault:
		QuickMath.insert_in_array(0, AnimationName, animation_list)
	else:
		animation_list.append(AnimationName)


func add_animation_list(AnimationList: Array) -> void:
	animation_list.append_array(AnimationList)


func add_alternate_animation(SetName: String, AnimationName: String, IsDefault: bool = false) -> void:
	if not alternate_animations.has(SetName):
		alternate_animations[SetName] = []

	if IsDefault:
		QuickMath.insert_in_array(0, AnimationName, alternate_animations[SetName])
	else:
		alternate_animations[SetName].append(AnimationName)


func add_alternate_animation_list(SetName: String, AnimationList: Array) -> void:
	if not alternate_animations.has(SetName):
		alternate_animations[SetName] = []
	
	alternate_animations[SetName].append_array(AnimationList)


func remove_animation(AnimationName: String, PreserveOrder: bool = false):
	if PreserveOrder:
		animation_list.erase(AnimationName)
	else:
		QuickMath.erase_array_element(AnimationName, animation_list)


func get_animation(GetRandom: bool = false) -> String:
	var _animations_array: Array
	
	if animation_override != "":
		_animations_array = alternate_animations[animation_override]
	else:
		_animations_array = animation_list
	
	
	if GetRandom:
		return _animations_array.pick_random()
	else:
		return _animations_array.front()


func set_default_animation(AnimationKey: String) -> void:
	if AnimationKey in animation_list:
		QuickMath.array_bring_to_front(AnimationKey, animation_list)


func set_default_alternate_animation(AnimationSet: String, AnimationKey: String) -> void:
	if AnimationKey in alternate_animations[AnimationSet]:
		QuickMath.array_bring_to_front(AnimationKey, alternate_animations[AnimationSet])


func set_animation_override(NewAnimationOverride: String) -> bool:
	if alternate_animations.has(NewAnimationOverride) or NewAnimationOverride == "":
		if NewAnimationOverride != animation_override:
			animation_override = NewAnimationOverride
			return true
	return false

