extends TextureProgressBar


@export var measured_stat: ComponentStat
@export var show_numbers: bool = false
@export_enum("Left", "Right") var number_position = 0

@export_group("Tweening")
@export var enable_tweening: bool = false
@export var tween_time: float = 1.0
@export var tween_transition: Tween.TransitionType
@export var tween_ease: Tween.EaseType

@onready var label: Label = $Label

func _ready():
	label.visible = show_numbers
	if number_position == 0:
		label.position = Vector2(-24, -8)
		label.pivot_offset.x = -1
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	else:
		label.position = Vector2(80, -8)
		label.pivot_offset.x = 1
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	if not measured_stat:
		return
	max_value = measured_stat.max_value
	min_value = measured_stat.min_value
	value = measured_stat.current_value
	
	self.value_changed.connect(__update_val)
	
	measured_stat.stat_changed.connect(__update_value)


func __update_value(_measured_reference: ComponentStat) -> void:
	if enable_tweening:
		var _tween: Tween = create_tween()
		_tween.set_trans(tween_transition)
		_tween.set_ease(tween_ease)
		_tween.tween_property(self, "value", measured_stat.current_value, tween_time)
		#var _tweeen = create_tween()
		#_tweeen.tween_property(self, "value", measured_stat.current_value, tween_time)
	else:
		self.value = measured_stat.current_value


func __update_max(_measured_reference: ComponentStat) -> void:
	max_value = measured_stat.max_value


func __update_min(_measured_reference: ComponentStat) -> void:
	min_value = measured_stat.min_value
	
	
func __update_val(_value_change: float):
	label.text = str(value)
