extends Behaviour


var player: Player
var anim_player: ModuleAnimationPlayer


func _ready():
	behaviour_id = "hurt"


func setup_behaviour() -> void:
	anim_player = behaviour_module.module_manager.get_module("animation-player")


func enter(_args:= {}):
	if not player:
		return

	if not anim_player.animation_finished.is_connected(__hurt_finished):
		anim_player.animation_finished.connect(__hurt_finished)
	
	anim_player.state_machine.set_override("damage")


func set_target_node(_new_target_node) -> void:
	if _new_target_node is Player:
		player = _new_target_node


func __hurt_finished(_anim_name: StringName) -> void:
	anim_player.state_machine.set_override("")
	anim_player.animation_finished.disconnect(__hurt_finished)
	change_behaviour("/idle")

