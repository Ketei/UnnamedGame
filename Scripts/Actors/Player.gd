extends Actor
class_name Player

@export_category("Player Movement")
@export var max_jumps: int = 0

# TrackerName(str): InteractTracker
# Add proper keys once finished: up, down, left, etc.
var interact_tracker: Dictionary = {}


func add_interact_tracker(TrackerKey: String):
	interact_tracker[TrackerKey.to_lower()] = InteractTracker.new()


func remove_interact_tracker(TrackerKey: String):
	if interact_tracker.erase(TrackerKey.to_lower()):
		print_debug(TrackerKey + " removed")
	else:
		print_debug(TrackerKey + " doesn't exist.")


func update_player_direction(HorizontalStrenght: float) -> void:
	if HorizontalStrenght != 0.0:
		if HorizontalStrenght < 0.0 and not is_facing_left:
			is_facing_left = true
		elif 0 < HorizontalStrenght and is_facing_left:
			is_facing_left = false
