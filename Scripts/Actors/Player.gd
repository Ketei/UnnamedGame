extends Actor
class_name Player

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

