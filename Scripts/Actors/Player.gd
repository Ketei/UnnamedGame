extends Actor
class_name Player

# TrackerName(str): InteractTracker
# Add proper keys once finished: up, down, left, etc.
var interact_tracker: Dictionary = {}
var axis_strenght: Vector2 = Vector2(0, 0)


func update_input_axis(UpdateAxisX: bool = true, UpdateAxisY: bool = true) -> void:
	if UpdateAxisX:
		axis_strenght.x = Input.get_axis("gc_left","gc_right")
	if UpdateAxisY:
		axis_strenght.y = Input.get_axis("gc_up", "gc_down")


func add_interact_tracker(TrackerKey: String):
	interact_tracker[TrackerKey.to_lower()] = InteractTracker.new()


func remove_interact_tracker(TrackerKey: String):
	if interact_tracker.erase(TrackerKey.to_lower()):
		print_debug(TrackerKey + " removed")
	else:
		print_debug(TrackerKey + " doesn't exist.")

