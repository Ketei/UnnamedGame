class_name ActorSprite2D
extends Sprite2D


enum EffectType {BLINK}

const _EFFECT_NAMES: Dictionary = {
	"0": "blink"
}

@onready var _effect_player: AnimationPlayer = %SpriteEffects
@onready var _effect_timer: Timer = %EffectTimer


func play_effect(effect_type: EffectType, effect_time: float) -> void:
	_effect_timer.start(effect_time)
	_effect_player.play(_EFFECT_NAMES[str(effect_type)])


func _on_timer_timeout():
	_effect_player.stop()

