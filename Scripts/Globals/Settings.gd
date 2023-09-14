extends Node

var game_difficulty = GameProperties.Difficulty.NORMAL

#(((Settings.max_arousal_amp - (Settings.arousal_curve * 3))) / 3) * Settings.game_difficulty

# ---- Move to RACE resource -----
# SkillName(String): Multiplier(float(0.0, 1.0)).

enum player_addiction_status {} # Cum addiction

# 1.0, 0.90, 0.80, 0.60, 0.20
enum player_lust_status {NORMAL, AROUSED, NEEDY, ADDICTED, BROKEN}


var exp_multipliers: Dictionary = {}


var max_base_skills: Dictionary = {}


## --------------------------------


var min_sex_damage_percent: float = 0.01 :
	set(value):
		min_sex_damage_percent = clampf(value, 0.0, 1.0)
		if max_sex_damage_percent < min_sex_damage_percent:
			max_sex_damage_percent = min_sex_damage_percent

var max_sex_damage_percent: float = 1.0 :
	set(value):
		max_sex_damage_percent = clampf(value, min_sex_damage_percent, 1.0)

