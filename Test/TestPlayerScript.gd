extends CharacterBody2D

const move_speed = 2 * 64

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * move_speed
	move_and_slide()
