## AnimationPlayer set up for module manager. An autoplay animation or playing
## an animation is required or enabling/disabling the module COULD cause issues.
extends AnimationPlayer
class_name ModuleAnimationPlayer

## A dictionary that stores the string names of the animations along with their
## terrain state. 
@export var animation_categories = {
	"Ground": {
		"Idle": [],
		"Move": [],
		"Sprint": [],
		"Dash": [],
		"Attack": [],
		"KnockDown": [],
		"Stun": [],
		"Damage": []
	},
	"Air": {
		"Jump": [],
		"Fall": [],
		"KnockDown": [],
		"Damage": []
	},
	"Water": {
		"Idle": [],
		"Move": [],
		"Dash": [],
		"KnockDown": [],
		"Stun": [],
		"Damage": []
	}
}
# Required for the manager to track them.
var module_type: String = "AnimationPlayer"

var enabled: bool = false : set = _module_enabled_override
var module_manager : ModuleManager


## Called by the module manager when setting up.
func set_up_module() -> void:
	enabled = true


func _module_enabled_override(Value: bool) -> void:
	enabled = Value
	if enabled:
		play()
	else:
		pause()


## Registers an animation to the internal dictionary so it can be grabbed via class functions.
func register_animation(AnimationTerrain: String, AnimationState: String, AnimationName: String) -> void:
	if self.has_animation(AnimationName):
		if AnimationTerrain not in animation_categories:
			animation_categories[AnimationTerrain] = {}
		
		if AnimationState not in animation_categories[AnimationTerrain]:
			animation_categories[AnimationTerrain][AnimationState] = []
		
		animation_categories[AnimationTerrain][AnimationState].append(AnimationName)
	else:
		print_debug("Warning: AnimationPlayer doesn't have an animation with the name: " + AnimationName)
	

## Removes the animation name from the internal dictionary. This only affects play_terrain_animation()
## This doesn't delete the animation and can be registered again with register_animation()
func unregister_animation(AnimationTerrain: String, AnimationState: String, AnimationName: String):
	if AnimationTerrain in animation_categories:
		if AnimationState in animation_categories[AnimationTerrain]:
			if AnimationName in animation_categories[AnimationTerrain][AnimationState]:
				animation_categories[AnimationTerrain][AnimationState].erase(AnimationName)
			else:
				print_debug(AnimationName + " doesn't exist in animation array.")
		else:
			print_debug(AnimationState + " doesn't exist in terrain dictionary")
	else:
		print_debug(AnimationTerrain + " is not a registered terrain")


## Plays the first registered animation of the terrain and status unless play random is true,
## if so, it'll get a random animation in the array specified.
func play_terrain_animation(Terrain: String, AnimationState: String, PlayRandom := false):
	if Terrain in animation_categories:
		if AnimationState in animation_categories[Terrain]:
			if 0 < animation_categories[Terrain][AnimationState].size():
				# If random play but the array size is 1 there is no need to randomize.
				if PlayRandom and 1 < animation_categories[Terrain][AnimationState].size():
					play(animation_categories[Terrain][AnimationState][randi() % animation_categories[Terrain][AnimationState].size() - 1])
				else:
					play(animation_categories[Terrain][AnimationState].front())
			else:
				print_debug("Warning: No registered animations in array")
		else:
			print_debug(AnimationState + " doesn't exist in terrain dictionary")
	else:
		print_debug(Terrain + " is not a registered terrain.")

