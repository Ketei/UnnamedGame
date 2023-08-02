extends Area2D
class_name InteractableObject

var unique_id: String = ""
@export var interact_key: String = "null"


func _ready():
	if interact_key != "null" and interact_key != "":
		interact_key.to_lower()
	
	generate_new_unique_name()


func generate_new_unique_name() -> void:
	unique_id = self.name + "_" + interact_key + "_" + str(randi() % 8999 + 1000)
