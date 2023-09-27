extends Node

# I'll eventually convert all of this to a json

#var game_difficulty = Game.Difficulty.NORMAL
var refresh_rate: int = 0


# This belongs in GameProperties
var min_sex_damage_percent: float = 0.01 :
	set(value):
		min_sex_damage_percent = clampf(value, 0.0, 1.0)
		if max_sex_damage_percent < min_sex_damage_percent:
			max_sex_damage_percent = min_sex_damage_percent

var max_sex_damage_percent: float = 1.0 :
	set(value):
		max_sex_damage_percent = clampf(value, min_sex_damage_percent, 1.0)
