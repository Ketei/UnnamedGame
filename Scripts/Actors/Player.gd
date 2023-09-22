class_name Player
extends Actor


var axis_strength: Vector2 = Vector2(0, 0)

# Toggles
@onready var hp: ComponentStat = $ModuleManager/ModuleStats/Health
# This will give the option to switch between walk & run with hold or a press.
# This is to be moved to settings once it's fully implemented
var walk_hold: bool = false


func update_input_axis(update_x_axis := true, update_y_axis := true) -> void:
	if update_x_axis:
		axis_strength.x = Input.get_axis("gc_left","gc_right")
	if update_y_axis:
		axis_strength.y = Input.get_axis("gc_up", "gc_down")


func _unhandled_key_input(event):
	if event.is_action_pressed("ui_text_backspace"):
		hp.change_current(25)
