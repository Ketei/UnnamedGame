extends Module
## This module makes interaction between modules possible (and safe).
## It'll only include modules that have cross-module interaction by nature.
## This module only works properly if the other modules use the standard structure
class_name ModuleInteract

## Modules that can be interacted with
@export_group("Interacted Modules")
## These modules are interacted by: terrain_trackers
@export var animation_player: ModuleAnimationPlayer

## Modules that interact with other modules
@export_group("Interacting Modules")
@export var terrain_tracker: ModuleTerrainTracker


func _ready():
	module_priority = 0
	module_type = "module-interact"


func set_up_module() -> void:
	terrain_tracker.terrain_changed.connect(_terrain_tracker_changed)
	is_module_enabled = true

# Changes the animation terrain state depending on the terrain state of terrain module
func _terrain_tracker_changed(NewState: GameProperties.TerrainState) -> void:
	animation_player.set_anim_state("root", GameProperties.TerrainNames[NewState])
