extends Behaviour


func _ready():
	behaviour_id = "attack"


func enter(_args:= {}):
	if not behaviour_module.module_manager.get_module("animation-player").animation_finished.is_connected(__hit_finished):
		behaviour_module.module_manager.get_module("animation-player").animation_finished.connect(__hit_finished)
	fsm_animation_state.emit("root/ground/movement", "attack")
	
	
func __hit_finished(_anim_name: StringName) -> void:
	change_behaviour("movement/idle")
	if behaviour_module.module_manager.get_module("animation-player").animation_finished.is_connected(__hit_finished):
			behaviour_module.module_manager.get_module("animation-player").animation_finished.disconnect(__hit_finished)
	
