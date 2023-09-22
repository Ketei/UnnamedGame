extends Area2D

@onready var hp: ComponentStat = $"../ModuleManager/ModuleStats/Health"
@onready var hurtbox: CollisionShape2D = $CollisionShape2D
var timer: Timer

func _physics_process(delta):
	pass


func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.autostart = false
	timer.wait_time = 1.0
	timer.timeout.connect(_timer_timeout)
	self.add_child(timer)


func _on_area_entered(area):
	hp.change_current(-5)
	hurtbox.set_deferred("disabled", true)
	#hurtbox.disabled = true
	timer.start()


func _timer_timeout() -> void:
	hurtbox.set_deferred("disabled", false)
