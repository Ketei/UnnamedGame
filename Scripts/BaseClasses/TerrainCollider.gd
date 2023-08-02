extends Area2D
class_name TerrainCollider

signal area_update

# TerrainName(str) : TerrainCount(int)
var colliding_terrains: Dictionary = {}

func _ready():
	for terrain in GameProperties.TerrainNames.values():
		if terrain != "Ground" or terrain != "Air":
			colliding_terrains[terrain] = 0
	
	self.set_collision_layer_value(1, false)
	self.set_collision_mask_value(1, false)
	self.set_collision_mask_value(2, true)
	self.connect("area_entered", _on_terrain_enter)
	self.connect("area_exited", _on_terrain_exit)


func get_terrains() -> Array:
	return colliding_terrains.keys()


func _on_terrain_enter(area):
	if area is TerrainArea:
		if GameProperties.get_terrain_name(area.TerrainType) in colliding_terrains:
			colliding_terrains[GameProperties.get_terrain_name(area.TerrainType)] += 1
		area_update.emit()

func _on_terrain_exit(area):
	if area is TerrainArea:
		if GameProperties.get_terrain_name(area.TerrainType) in colliding_terrains:
			colliding_terrains[GameProperties.get_terrain_name(area.TerrainType)] -= 1
		area_update.emit()
