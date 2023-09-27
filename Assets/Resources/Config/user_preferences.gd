class_name UserPreferences
extends Resource


@export var refresh_rate: int = 0


static func load_or_create() -> UserPreferences:
	var _res: UserPreferences
	if not ResourceLoader.exists("user://settings/user_prefs.tres"):
		_res = UserPreferences.new()
		_res.refresh_rate = int(DisplayServer.screen_get_refresh_rate())
		_res.save()
	else:
		_res = ResourceLoader.load("user://settings/user_prefs.tres")
	
	return _res


func save() -> void:
	ResourceSaver.save(self, "user://settings/user_prefs.tres")

