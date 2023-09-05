extends Module
class_name ModuleTimersManager

signal timer_ended(TimerName)

var timers_dict : Dictionary = {}


func _ready():
	module_type = "timers-manager"
	module_priority = 0

## Returns a timer if it exist, if not returns null
func get_timer(TimerName: String) -> TimerForModule:
	return  timers_dict[TimerName]


func has_timer(TimerName: String) -> bool:
	if timers_dict.has(TimerName):
		return true
	else:
		return false


func create_timer(TimerName: String, TimerTime: float, TimerOneShot := true, IsPersistent := false) -> void:
	if not is_module_enabled or has_timer(TimerName):
		return
	
	var new_timer = TimerForModule.new()
	new_timer.wait_time = TimerTime
	new_timer.one_shot = TimerOneShot
	new_timer.is_persistent = IsPersistent
	new_timer.name = TimerName
	new_timer.reference_count += 1
	self.add_child(new_timer)
	timers_dict[new_timer.name] = new_timer
	new_timer.connect("timer_timeout", _on_timer_timeout)
	new_timer.start()


func timer_remove_reference(TimerName: String) -> void:
	if not has_timer(TimerName):
		return

	get_timer(TimerName).reference_count -= 1
	
	if get_timer(TimerName).reference_count == 0 and not get_timer(TimerName).is_persistent:
		delete_timer(TimerName)


func timer_add_reference(TimerName: String) -> void:
	if not has_timer(TimerName):
		return
	
	get_timer(TimerName).reference_count += 1


## Deletes timer regardless if they are set as persistent
func delete_timer(TimerName: String) -> void:
	if not has_timer(TimerName):
		return
	
	if 0 < get_timer(TimerName).reference_count:
		print_debug("Warning, this node is probably still being called by another node.")
	
	timers_dict.erase(TimerName)
	get_timer(TimerName).queue_free()


func start_timer(TimerName:String, TimerTime: float = -1.0):
	if not is_module_enabled or not has_timer(TimerName):
		return

	get_timer(TimerName).start(TimerTime)


func stop_timer(TimerName:String) -> void:
	if not is_module_enabled or not has_timer(TimerName):
		return

	get_timer(TimerName).stop()


func pause_timer(TimerName: String, IsPaused: bool) -> void:
	if not is_module_enabled or not has_timer(TimerName):
		return
	
	get_timer(TimerName).paused = IsPaused


func _on_timer_timeout(TimerName:String):
	timer_ended.emit(TimerName)
	if not get_timer(TimerName).is_persistent and get_timer(TimerName).reference_count == 0:
		delete_timer(TimerName)


func set_up_module():
	for timer_node in get_children():
		if timer_node is TimerForModule:
			timers_dict[timer_node.name.to_lower()] = timer_node
			timer_node.connect("timer_timeout", _on_timer_timeout)
	
	is_module_enabled = true


func _module_enabled_override(Value: bool) -> void:
	if is_module_enabled != Value:
		for timer in timers_dict.keys():
			timers_dict[timer].paused = Value
	is_module_enabled = Value
