extends Node2D


var modify_physics: bool = false

func _ready():
	update_physics_rate()


# This is set-up to see if I can fix jitter on 60hz+ screens.
func update_physics_rate() -> void:
	if not modify_physics:
		return
	
	var refresh_rate: int = int(DisplayServer.screen_get_refresh_rate())
	print_debug("Your screen refresh rate is: " + str(refresh_rate))
	print_debug("Max fps & physics ticks will be set to this number.")
	if refresh_rate == -1:
		pass
	
	Engine.physics_ticks_per_second = refresh_rate
	Engine.max_fps = refresh_rate


func _unhandled_key_input(event):
	if event.is_action_pressed("ui_end"):
		if not modify_physics:
			return
		
		print_debug("Updating refresh rate.")
		update_physics_rate()
