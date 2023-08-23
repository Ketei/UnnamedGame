extends Node

# Info about the tileset resolution. This is used to calculate gravity, velocity, etc.
const grid_size: int = 16

# Possible difficulties for the game.
enum Difficulty {EASY, NORMAL, HARD, NIGHTMARE}
enum DamageTypes {PHYSICAL, MAGICAL, TRUE}
# Types of damage in game
const AttackTypes: Dictionary = {
	"blunt": DamageTypes.PHYSICAL,
	"slashing": DamageTypes.PHYSICAL,
	"piercing": DamageTypes.PHYSICAL,
	"fire": DamageTypes.MAGICAL,
	"cold": DamageTypes.MAGICAL,
	"lightning": DamageTypes.MAGICAL,
	"sex": DamageTypes.TRUE,
	"true": DamageTypes.TRUE
}

# When cumming, arousal will be changed by -100 + (this value * cum_times).
# When an actor cums a lot, he becomes a addicted. Hence cumming doesn't clear
# arousal as well.
# Tops cum more, bottoms cum less. Balance these values considering that.
# Currently considering a player might get grabbed around 5 times.
const Arousal_Clearing_Penalty_Bottoms : int = 16
const Arousal_Clearing_Penalty_Tops : int = 8

# Applies effects to actor depending on it's lust value when the relevant value is updated.
# Per-level effects are only applied when the lust value of the actor changes.
# Effects need to be called by the relevant module in order to be applied. Methods to calculate
# how much can be found on SexLibs
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
