extends Module
class_name ModuleBehaviour

signal behaviour_change

@export var initial_behaviour: Behaviour

var available_behaviours: Dictionary = {}
var loaded_behaviour: Behaviour = null
var target_node: Node = null


func _ready():
	pass


func load_behaviour(NewBehaviour: String) -> void:
	if available_behaviours.has(NewBehaviour):
		var behaviour_preload: Behaviour = available_behaviours[NewBehaviour]
		loaded_behaviour.exit()
		loaded_behaviour = behaviour_preload
		behaviour_change.emit()
		loaded_behaviour.enter()
	else:
		print_debug("Error: No such behaviour on module: " + NewBehaviour)


func _input(event):
	if enabled:
		if loaded_behaviour:
			loaded_behaviour.handle_input(event)


func _physics_process(delta):
	if enabled:
		if loaded_behaviour:
			loaded_behaviour.handle_physics(delta)


func set_up_module() -> void:
	module_type = "behaviour"
	target_node = module_manager.parent_node
	
	for child in self.get_children():
		if child is Behaviour:
			available_behaviours[child.name.to_lower()] = child
			child.behaviour_module = self
			child.setup_behaviour()
	
	if initial_behaviour:
		loaded_behaviour.enter()
	
	enabled = true

