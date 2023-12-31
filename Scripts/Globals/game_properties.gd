extends Node

# Possible difficulties for the game.
enum Difficulty {EASY, NORMAL, HARD, NIGHTMARE}
enum DamageTypes {PHYSICAL, MAGICAL, TRUE}
enum TerrainState {GROUND, AIR, LIQUID}

const TerrainNames: Array = ["ground", "air", "liquid"]

# Info about the tileset resolution. This is used to calculate gravity, velocity, etc.
const GRID_SIZE: int = 16

# Types of damage in game
const ATTACK_TYPES: Dictionary = {
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
const TERRAIN_MOVEMENT_MOD : Dictionary = {
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
	"sex-damage-dealt": -0.75,
	"sex-damage-received": 0.02
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


# Switch to control lib when/id it exists
func change_keybind(event_name: String, new_keybind_key_code: int):
	if InputMap.has_action(event_name):
		InputMap.action_erase_events(event_name)
		var _new_keybind = InputEventKey.new()
		_new_keybind.keycode = new_keybind_key_code
		InputMap.action_add_event(event_name, _new_keybind)


func add_lust_effect(lust_amount: int, stat_change: String, value_change: float) -> void:
	if str(lust_amount) not in lust_effects:
		lust_effects[str(lust_amount)] = {}
	
	if stat_change not in lust_effects[str(lust_amount)]:
		lust_effects[str(lust_amount)][stat_change] = 0
	
	lust_effects[str(lust_amount)][stat_change] += value_change


func remove_lust_effect(lust_amount: int, stat_change: String):
	if str(lust_amount) not in lust_effects:
		return
	
	lust_effects[str(lust_amount)].erase(stat_change)
		
	if lust_effects[str(lust_amount)].is_empty():
		lust_effects.erase(str(lust_amount))


func get_skill_effects(skill_name: String, current_level: float, previous_level: float) -> Dictionary:
	var _return_dict := {}
	
	if not skill_effects.has(skill_name):
		return _return_dict

	for skill_change in skill_effects[skill_name].keys():
		_return_dict[skill_change] = skill_effects[skill_name][skill_change] * (current_level - previous_level)
	
	return _return_dict


func get_lust_effects(stat_name: String, current_level: float, previous_level: float) -> float:
	
	if not lust_effects.has(stat_name):
		return 0.0
	
	return lust_effects[stat_name] * (current_level - previous_level)

