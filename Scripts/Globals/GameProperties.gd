extends Node

# Info about the tileset resolution. This is used to calculate gravity, velocity, etc.
const grid_size: int = 16

# Possible difficulties for the game.
enum Difficulty {EASY, NORMAL, HARD, IMPOSSIBLE}

const Arousal_Change_Bottoms : Array = [-100, -75, -50, -25, -5, 5, 15, 25, 40, 60]
const Arousal_Change_Tops : Array = [-100, -85, -60, -35, -15, 5, 20, 35, 50, 60]

# Applies effects to actor depending on it's lust value. This is designed around player only but can work on NPC
# provided they have the proper variable enabled.
# per-level values will be added to the proper variable for each lust level increase/decrease.
# Numbered values will add the value to the proper variable starting from that value until the
# next higher value is reached. Ex. Starting from lust 20, it'll add 2 to arousal until reaching arousal 39
# on reachign 40 it'll start adding 3 until the next number is reached.
var lust_effects: Dictionary = {
	"per-level": {
		"sex-damage-dealt": -0.75,
		"sex-damage-received": 0.02
	},
	"20": {
		"arousal": 2
	},
	"40": {
		"arousal": 3
	},
	"60": {
		"arousal": 5
	},
	"80": {
		"arousal": 10
	},
	"100": {
		"arousal": 25
	}
}
# ---------------------------

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


func add_lust_effect(LustAmount: int, StatChange: String, ValueChange: float) -> void:
	if str(LustAmount) not in lust_effects:
		lust_effects[str(LustAmount)] = {}
	
	if StatChange not in lust_effects[str(LustAmount)]:
		lust_effects[str(LustAmount)][StatChange] = 0
	
	lust_effects[str(LustAmount)][StatChange] += ValueChange


func remove_lust_effect(LustAmount: int, StatChange: String):
	if str(LustAmount) in lust_effects:
		lust_effects[str(LustAmount)].erase(StatChange)
		
		if lust_effects[str(LustAmount)].is_empty():
			lust_effects.erase(str(LustAmount))
