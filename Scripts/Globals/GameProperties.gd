extends Node

# Possible difficulties for the game.
enum Difficulty {EASY, NORMAL, HARD, NIGHTMARE}
enum DamageTypes {PHYSICAL, MAGICAL, TRUE}
enum TerrainState {GROUND, AIR, LIQUID}

# Info about the tileset resolution. This is used to calculate gravity, velocity, etc.
const grid_size: int = 128
const target_framerate: int = 60

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

# A movement mutiplier. If the key of this dict matches one of terrain names
# the actor movement will be multiplied by the amount stated.
const TerrainMoveMult : Dictionary = {
	"water": 0.85
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

# Used to change actor's values when it's skill changes.
# SkillName(str): {SkillEffect(str): SkillChange(float)}

# SkillName -> strength, endurance, charisma, intelligence, luck

# SkillEffect -> health, stamina, mana | sex-skill-penis, sex-skill-oral, sex-skill-anal, sex-skill-vaginal
# sex-damage-dealt, sex-damage-received, sex-endurance, sex-limit-break | damage-physical, damage-magical,
# defense-physical, defense-magical

var skill_effects: Dictionary = {
	"strength": {
		"damage-physical": 1
	},
	"intelligence": {
		"damage-magical": 1
	},
	"endurance": {
		"health": 2,
		"defense-physical": 1,
		"defense-magical": 0.5
	}
}


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
	if str(LustAmount) not in lust_effects:
		return
	
	lust_effects[str(LustAmount)].erase(StatChange)
		
	if lust_effects[str(LustAmount)].is_empty():
		lust_effects.erase(str(LustAmount))


func get_skill_effects(SkillName: String, PrevSkillLevel: int, SkillLevel: int) -> Dictionary:
	var _return_dict: Dictionary = {}
	
	if not skill_effects.has(SkillName):
		return _return_dict

	for skill_change in skill_effects[SkillName].keys():
		_return_dict[skill_change] = skill_effects[SkillName][skill_change] * (SkillLevel - PrevSkillLevel)
	
	return _return_dict
