extends Node2D


func _init():
	update_physics_rate()


# This is set-up to see if I can fix jitter on 60hz+ screens.
# Apparently this works good enough.
func update_physics_rate() -> void:
	if Settings.refresh_rate <= 0:
		Settings.refresh_rate = int(DisplayServer.screen_get_refresh_rate())

	if Settings.refresh_rate == -1:
		print_debug("Couldn't automatically detect the monitor refresh rate")
		return
	
	Engine.physics_ticks_per_second = Settings.refresh_rate
	Engine.max_fps = Settings.refresh_rate


func _unhandled_key_input(event):
	if event.is_action_pressed("ui_accept"):
		#$Camera2D/CanvasLayer/Label.visible = not $Camera2D/CanvasLayer/Label.visible
		$CanvasLayer/Label.visible = not $CanvasLayer/Label.visible
