class_name StatProgressBar
extends TextureProgressBar


@export var measured_stat: ComponentStat
@export var show_numbers: bool = false
@export_enum("Left", "Right") var number_position = 0

@export_group("Tweening")
@export var enable_tweening: bool = false
@export var tween_time: float = 1.0
@export var tween_transition: Tween.TransitionType
@export var tween_ease: Tween.EaseType

var label: Label


func _ready():
	if show_numbers:
		label = Label.new()
		add_child(label)
		label.visible = show_numbers
		label.size = Vector2(48, 48)
		label.scale = Vector2(0.5, 0.5)
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
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
	
	if show_numbers:
		label.text = str(value)
	
	self.value_changed.connect(__update_label)
	
	measured_stat.stat_changed.connect(__update_value)
	measured_stat.max_updated.connect(__update_max)
	measured_stat.min_updated.connect(__update_min)


func __update_value(_measured_reference: ComponentStat) -> void:
	if enable_tweening:
		var _tween: Tween = create_tween()
		_tween.set_trans(tween_transition)
		_tween.set_ease(tween_ease)
		_tween.tween_property(self, "value", measured_stat.current_value, tween_time)
	else:
		self.value = measured_stat.current_value


func __update_max(_measured_reference: ComponentStat) -> void:
	max_value = measured_stat.max_value


func __update_min(_measured_reference: ComponentStat) -> void:
	min_value = measured_stat.min_value
	
	
func __update_label(_value_change: float):
	if show_numbers:
		label.text = str(value)


func label_visible(is_label_visible: bool) -> void:
	if not label:
		label = Label.new()
		label.visible = is_label_visible
		label.size = Vector2(48, 48)
		label.scale = Vector2(0.5, 0.5)
		if number_position == 0:
			label.position = Vector2(-24, -8)
			label.pivot_offset.x = -1
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		else:
			label.position = Vector2(80, -8)
			label.pivot_offset.x = 1
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		add_child(label)
		if measured_stat:
			label.text = str(measured_stat.current_value)
	else:
		label.text = str(measured_stat.current_value)
		label.visible = is_label_visible
	

func set_tracked_stat(stat_to_track:ComponentStat) -> void:
	if measured_stat.stat_changed.is_connected(__update_value):
		measured_stat.stat_changed.disconnect(__update_value)
	if measured_stat.max_updated.is_connected(__update_max):
		measured_stat.max_updated.disconnect(__update_max)
	if measured_stat.min_updated.is_connected(__update_min):
		measured_stat.min_updated.disconnect(__update_min)
	
	measured_stat = stat_to_track
	max_value = stat_to_track.max_value
	min_value = stat_to_track.min_value
	value = stat_to_track.current_value
	
	measured_stat.stat_changed.connect(__update_value)
	measured_stat.max_updated.connect(__update_max)
	measured_stat.min_updated.connect(__update_min)

