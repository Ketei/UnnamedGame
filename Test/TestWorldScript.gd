extends Node2D

var dict_test = {
	"0": 0,
	"1": 1,
	"2": 2
}

func _init():
	update_physics_rate()


# This is set-up to see if I can fix jitter on 60hz+ screens.
# Apparently this works good enough.
func update_physics_rate() -> void:
	if Settings._refresh_rate <= 0:
		Settings._refresh_rate = int(DisplayServer.screen_get_refresh_rate())

	if Settings._refresh_rate == -1:
		print_debug("Couldn't automatically detect the monitor refresh rate")
		return
	
	Engine.physics_ticks_per_second = Settings._refresh_rate
	Engine.max_fps = Settings._refresh_rate

