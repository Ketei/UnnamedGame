extends Node

## Sets a CollisionObject2D to ONLY the layer/mask specified.
func set_object_collision_bit(BitsToSet: Array[int], ObjectToSet: CollisionObject2D, IsLayer := true) -> void:
	disable_object_collision_bits(ObjectToSet, IsLayer)
	for true_number in BitsToSet:
		if IsLayer:
			ObjectToSet.set_collision_layer_value(true_number, true)
		else:
			ObjectToSet.set_collision_mask_value(true_number, true)


func disable_object_collision_bits(ObjectToSet: CollisionObject2D, IsLayer := true) -> void:
	for number in range(32):
		if IsLayer:
			if ObjectToSet.get_collision_layer_value(number):
				ObjectToSet.set_collision_layer_value(number, false)
		else:
			if ObjectToSet.get_collision_mask_value(number):
				ObjectToSet.set_collision_mask_value(number, false)


func set_raycast_collision_mask(LayersToSet: Array[int], RaycastToSet: RayCast2D) -> void:
	disable_raycast_collision_mask(RaycastToSet)
	for true_layer in LayersToSet:
		RaycastToSet.set_collision_mask_value(true_layer, true)


func disable_raycast_collision_mask(RaycastToDisable: RayCast2D) -> void:
	for layer in range(32):
		if RaycastToDisable.get_collision_mask_value(layer):
			RaycastToDisable.set_collision_mask_value(layer, false)
