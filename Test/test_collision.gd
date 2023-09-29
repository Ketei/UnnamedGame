extends CollisionShape2D

@export var sprite: Sprite2D


func flip_with_sprite() -> void:
	if not sprite:
		return
	
	if sprite.flip_h:
		print("H is flipped")
		print(position.x)
		self.position.x *= -2.0
		print(position.x)
	if sprite.flip_v:
		self.position.y *= -2.0
