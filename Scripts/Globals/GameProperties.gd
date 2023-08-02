extends Node

# Info about the tileset resolution. This is used to calculate gravity, velocity, etc.
const grid_size: int = 16

# Possible difficulties for the game.
enum Difficulty {EASY, NORMAL, HARD}


# Relating to terrains
enum TerrainState {GROUND, AIR, WATER}
const TerrainNames : Dictionary = {
	"0": "Ground",
	"1": "Air",
	"2": "Water"
	}
# A movement mutiplier. If the key of this dict matches one of terrain names
# the actor movement will be multiplied by the amount stated.
const TerrainMoveMult : Dictionary = {
	"2": 0.85
}


func get_terrain_name(TerrainID: int) -> String:
	var return_string: String = ""
	if str(TerrainID) in TerrainNames:
		return_string = TerrainNames[TerrainID]
	
	return return_string


# Switch to control lib when it exists
func change_keybind(EventName: String, NewKeybindKeyCode: int):
	if InputMap.has_action(EventName):
		InputMap.action_erase_events(EventName)
		var _new_keybind = InputEventKey.new()
		_new_keybind.keycode = NewKeybindKeyCode
		InputMap.action_add_event(EventName, _new_keybind)
