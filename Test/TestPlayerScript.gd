extends Area2D


var invis_frames: float = 2.0

@onready var hp: ComponentStat = $"../ModuleManager/ModuleStats/Health"
@onready var hurtbox: CollisionShape2D = $CollisionShape2D
@onready var player_sprite : ActorSprite2D = $"../ActorSprite"
@onready var behaviour_module: ModuleBehaviour = $"../ModuleManager/ModuleBehaviour"
@onready var player: Player = $".."

var timer: Timer


func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = invis_frames
	timer.timeout.connect(_timer_timeout)
	self.add_child(timer)


func _on_area_entered(_area):
	behaviour_module.change_behaviour("movement/hurt")
	player.velocity.x = 0.0
	hp.change_current(-5)
	hurtbox.set_deferred("disabled", true)
	player_sprite.play_effect(ActorSprite2D.EffectType.BLINK, invis_frames)
	timer.start()


func _timer_timeout() -> void:
	hurtbox.set_deferred("disabled", false)
