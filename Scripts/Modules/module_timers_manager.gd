extends Module
class_name ModuleTimersManager


signal timer_ended(timer_name)

var timers_dict : Dictionary = {}


func _ready():
	module_type = "timers-manager"
	module_priority = 0


func set_up_module():
	for timer_node in get_children():
		if timer_node is TimerForModule:
			timers_dict[timer_node.name.to_lower()] = timer_node
			timer_node.connect("timer_timeout", __on_timer_timeout)


func _module_enabled_override(Value: bool) -> void:
	if is_module_enabled != Value:
		for timer in timers_dict.keys():
			timers_dict[timer].paused = Value
		is_module_enabled = Value


func create_timer(timer_name: String, timer_time: float, auto_start: bool = false, one_shot := true, is_persistent := false) -> void:
	if has_timer(timer_name):
		return

	var new_timer = TimerForModule.new()
	new_timer.wait_time = timer_time
	new_timer.one_shot = one_shot
	new_timer.is_persistent = is_persistent
	new_timer.name = timer_name
	new_timer.reference_count += 1
	new_timer.autostart = auto_start
	if not is_module_enabled:
		new_timer.paused = true
	self.add_child(new_timer)
	timers_dict[new_timer.name] = new_timer
	new_timer.connect("timer_timeout", __on_timer_timeout)


func start_timer(timer_name:String, timer_time: float = -1.0):
	if not is_module_enabled or not has_timer(timer_name):
		return

	get_timer(timer_name).start(timer_time)


func pause_timer(timer_name: String, IsPaused: bool) -> void:
	if not is_module_enabled or not has_timer(timer_name):
		return
	
	get_timer(timer_name).paused = IsPaused


func stop_timer(timer_name:String) -> void:
	if not has_timer(timer_name):
		return

	get_timer(timer_name).stop()


## Deletes timer regardless if they are set as persistent
func delete_timer(timer_ref: TimerForModule) -> void:
	if 0 < timer_ref.reference_count:
		print_debug("Warning, this node is probably still being called by another node.")
	
	timers_dict.erase(timer_ref.name)
	timer_ref.queue_free()


func timer_add_reference(timer_name: String) -> void:
	if not has_timer(timer_name):
		return
	
	get_timer(timer_name).reference_count += 1


func timer_remove_reference(timer_name: String) -> void:
	if not has_timer(timer_name):
		return
	
	var _target_timer: TimerForModule = get_timer(timer_name)
	_target_timer.reference_count -= 1
	
	if _target_timer.reference_count == 0 and not _target_timer.is_persistent:
		delete_timer(_target_timer)


func has_timer(timer_name: String) -> bool:
	return timers_dict.has(timer_name)


## Returns a timer's reference
func get_timer(timer_name: String) -> TimerForModule:
	return  timers_dict[timer_name]


func __on_timer_timeout(timer_ref:TimerForModule):
	timer_ended.emit(timer_ref.name)
	if not timer_ref.is_persistent and timer_ref.reference_count == 0:
		delete_timer(timer_ref)

