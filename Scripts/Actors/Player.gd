extends Actor
class_name Player

# TrackerName(str): InteractTracker
# Add proper keys once finished: up, down, left, etc.
var interact_tracker: Dictionary = {}
var axis_strength: Vector2 = Vector2(0, 0)

# Toggles

# This will give the option to switch between walk & run with hold or a press.
# This is to be moved to settings once it's fully implemented
var walk_hold: bool = false


func update_input_axis(UpdateAxisX: bool = true, UpdateAxisY: bool = true) -> void:
	if UpdateAxisX:
		axis_strength.x = Input.get_axis("gc_left","gc_right")
	if UpdateAxisY:
		axis_strength.y = Input.get_axis("gc_up", "gc_down")


func add_interact_tracker(TrackerKey: String):
	interact_tracker[TrackerKey.to_lower()] = InteractTracker.new()


func remove_interact_tracker(TrackerKey: String):
	if interact_tracker.erase(TrackerKey.to_lower()):
		print_debug(TrackerKey + " removed")
	else:
		print_debug(TrackerKey + " doesn't exist.")


func _unhandled_key_input(event):
	if event.is_action_pressed("ui_accept"):
		walk_hold = not walk_hold

