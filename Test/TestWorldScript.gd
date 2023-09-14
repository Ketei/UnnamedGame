extends CharacterBody2D
@onready var raycast : RayCast2D = $RayCast2D
func _ready():
	pass


func _physics_process(delta):
	print(raycast.is_colliding())
	if raycast.is_colliding():
		raycast.enabled = false
