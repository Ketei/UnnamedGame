class_name ActorSprite2D
extends Sprite2D


signal sprite_flipped(axis_char: String, is_flipped: bool)

enum EffectType {BLINK}

const _EFFECT_NAMES: Dictionary = {
	"0": "blink"
}


@onready var _effect_player: AnimationPlayer = %SpriteEffects
@onready var _effect_timer: Timer = %EffectTimer


func flip_vertical(flip_vertical: bool) -> void:
	if flip_vertical != flip_v:
		flip_v = flip_vertical
		sprite_flipped.emit("v", flip_v)


func flip_horizontal(flip_horizontal: bool) -> void:
	if flip_horizontal != flip_h:
		flip_h = flip_horizontal
		sprite_flipped.emit("h", flip_h)


func play_effect(effect_type: EffectType, effect_time: float) -> void:
	_effect_timer.start(effect_time)
	_effect_player.play(_EFFECT_NAMES[str(effect_type)])


func _on_timer_timeout():
	_effect_player.stop()


