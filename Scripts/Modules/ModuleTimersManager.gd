extends Module
class_name ModuleTimersManager

signal timer_ended(TimerName)

var timers_dict : Dictionary = {}


func _ready():
	module_type = "timers-manager"
	module_priority = 0

## Returns a timer if it exist, if not returns null
func get_timer(TimerName: String) -> TimerForModule:
	var return_timer: TimerForModule = null
	
	if timers_dict.has(TimerName.to_lower()):
		return_timer = timers_dict[TimerName.to_lower()]
	
	return return_timer


func create_timer(TimerName: String, TimerTime: float, TimerOneShot := true, IsPersistent := false) -> void:
	if is_module_enabled:
		var new_timer = TimerForModule.new()
		new_timer.wait_time = TimerTime
		new_timer.one_shot = TimerOneShot
		new_timer.is_persistent = IsPersistent
		new_timer.name = TimerName
		self.add_child(new_timer)
		timers_dict[new_timer.name] = new_timer
		new_timer.connect("timer_timeout", _on_timer_timeout)
		new_timer.start()


func add_timer(TimerToAdd: TimerForModule):
	if is_module_enabled:
		var _new_timer = TimerToAdd
		self.add_child(_new_timer)
		timers_dict[TimerToAdd.name] = _new_timer
		_new_timer.connect("timer_timeout", _on_timer_timeout)
		_new_timer.start()


func start_timer(TimerName:String, TimerTime: float = 0.0):
	if is_module_enabled:
		var timer_time: float = TimerTime
		if TimerName.to_lower() in timers_dict:
			if timer_time == 0.0:
				timer_time = timers_dict[TimerName.to_lower()].wait_time
				
			timers_dict[TimerName.to_lower()].start(timer_time)
		else:
			print_debug("No such timer exists: " + TimerName)


func stop_timer(TimerName:String) -> void:
	if is_module_enabled:
		if timers_dict.has(TimerName.to_lower()):
			timers_dict[TimerName].stop()


func _on_timer_timeout(TimerName:String):
	var _timer: TimerForModule = timers_dict[TimerName]
	timer_ended.emit(TimerName)
	
	# Removes the timer node if it wasn't set-up to be persistent
	if _timer.one_shot:
		if not _timer.is_persistent:
			timers_dict.erase(TimerName)
			_timer.queue_free()


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
