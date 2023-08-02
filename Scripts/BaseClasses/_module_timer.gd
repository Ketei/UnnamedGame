extends Timer
class_name TimerForModule

signal timer_timeout(timer_name)

## If true the timer node won't be freed by the Timers Manager once this timer reaches timeout.
@export var is_persistent: bool = false


func _ready():
	timeout.connect(_on_timer_timeout)


func _on_timer_timeout():
	timer_timeout.emit(self.name)
