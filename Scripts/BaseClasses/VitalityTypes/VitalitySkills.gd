extends Node
class_name VitalitySkill

signal skill_updated(skill_name: String, From: int, To: int)

var _prev_skill_value: int = 0

var enabled: bool = true

var change_self_with_lust: int = false

var custom_skills: Dictionary = {}

## Affects physical damage
var base_strength: float = 0 :
		set(value):
			if enabled:
				base_strength = clampf(value, 0, max_strength)
				strength = ActorLibs.calculate_stati(base_strength, mod_strength, mult_strength)
var mod_strength: float = 0 :
	set(value):
		if enabled:
			mod_strength = value
			strength = ActorLibs.calculate_stati(base_strength, mod_strength, mult_strength)
var mult_strength: float = 1.0 :
	set(value):
		if enabled:
			mult_strength = maxf(value, 0.0)
			strength = ActorLibs.calculate_stati(base_strength, mod_strength, mult_strength)
var max_strength: int = 0 :
	set(value):
		if enabled:
			max_strength = maxi(value, 0)
			if max_strength < base_strength:
				base_strength = max_strength
var strength: int = 0:
	set(value):
		if enabled:
			_prev_skill_value = strength
			strength = maxi(value, 0)
			skill_updated.emit("strength", _prev_skill_value, strength)

## Affects your damage reduction & tolerance to sexual attacks
var base_endurance: float = 0 :
	set(value):
		if enabled:
			base_endurance = clampf(value, 0, max_endurance)
			endurance = ActorLibs.calculate_stati(base_endurance, mod_endurance, mult_endurance)
var mod_endurance: float = 0 : 
	set(value):
		if enabled:
			mod_endurance = value
			endurance = ActorLibs.calculate_stati(base_endurance, mod_endurance, mult_endurance)
var mult_endurance: float = 1.0 :
	set(value):
		if enabled:
			mult_endurance = maxf(value, 0.0)
			endurance = ActorLibs.calculate_stati(base_endurance, mod_endurance, mult_endurance)
var max_endurance: int = 0 :
	set(value):
		if enabled:
			max_endurance = maxi(value, 0)
			if max_endurance < base_endurance:
				base_endurance = max_endurance
var endurance: int = 0 :
	set(value):
		if enabled:
			_prev_skill_value = endurance
			endurance = maxi(value, 0)
			skill_updated.emit("endurance", _prev_skill_value, endurance)

## Affects NPC interactions & Store prices.
var base_charisma: float = 0 :
	set(value):
		if enabled:
			base_charisma = clampf(value, 0, max_charisma)
			charisma = ActorLibs.calculate_stati(base_charisma, mod_charisma, mult_charisma)
var mod_charisma: float = 0 :
	set(value):
		if enabled:
			mod_charisma = value
			charisma = ActorLibs.calculate_stati(base_charisma, mod_charisma, mult_charisma)
var mult_charisma: float = 1.0 :
	set(value):
		if enabled:
			mult_charisma = maxf(value, 0.0)
			charisma = ActorLibs.calculate_stati(base_charisma, mod_charisma, mult_charisma)
var max_charisma: int = 0 :
	set(value):
		if enabled:
			max_charisma = maxi(value, 0)
			if max_charisma < base_charisma:
				base_charisma = max_charisma
var charisma: int = 0 :
	set(value):
		if enabled:
			_prev_skill_value = charisma
			charisma = maxi(value, 0)
			skill_updated.emit("charisma", _prev_skill_value, charisma)

## Affects magic damage
var base_intelligence: float = 0 :
	set(value):
		if enabled:
			base_intelligence = clampf(value, 0, max_intelligence)
			intelligence = ActorLibs.calculate_stati(base_intelligence, mod_intelligence, mult_intelligence)
var mod_intelligence: float = 0 :
	set(value):
		if enabled:
			mod_intelligence = value
			intelligence = ActorLibs.calculate_stati(base_intelligence, mod_intelligence, mult_intelligence)
var mult_intelligence: float = 1.0 :
	set(value):
		if enabled:
			mult_intelligence = maxf(value, 0.0)
			intelligence = ActorLibs.calculate_stati(base_intelligence, mod_intelligence, mult_intelligence)
var max_intelligence: int = 0 :
	set(value):
		if enabled:
			max_intelligence = maxi(value, 0)
			if max_intelligence < base_intelligence:
				base_intelligence = max_intelligence
var intelligence: int = 0 :
	set(value):
		if enabled:
			_prev_skill_value = intelligence
			intelligence = maxi(value, 0)
			skill_updated.emit("intelligence", _prev_skill_value, intelligence)

## Affects critical hits & Minigame odds
var base_luck: float = 0 :
	set(value):
		if enabled:
			base_luck = clampf(value, 0, max_luck)
			luck = ActorLibs.calculate_stati(base_luck, mod_luck, mult_luck)
var mod_luck: float = 0 :
	set(value):
		if enabled:
			mod_luck = value
			luck = ActorLibs.calculate_stati(base_luck, mod_luck, mult_luck)
var mult_luck: float = 1.0 :
	set(value):
		mult_luck = maxf(value, 0.0)
		luck = ActorLibs.calculate_stati(base_luck, mod_luck, mult_luck)
var max_luck: int = 0 :
	set(value):
		if enabled:
			max_luck = maxi(value, 0)
			if max_luck < base_luck:
				base_luck = max_luck
var luck: int = 0 :
	set(value):
		if enabled:
			_prev_skill_value = luck
			luck = maxi(value, 0)
			skill_updated.emit("luck", _prev_skill_value, luck)


func trigger_lust_stats_change(CurrentLust, PreviousLust) -> void:
	if enabled:
		mod_strength += SexLibs.get_stat_with_lustf("strength", CurrentLust, PreviousLust)
		mod_endurance += SexLibs.get_stat_with_lustf("endurance", CurrentLust, PreviousLust)
		mod_charisma += SexLibs.get_stat_with_lustf("charisma", CurrentLust, PreviousLust)
		mod_intelligence += SexLibs.get_stat_with_lustf("intelligence", CurrentLust, PreviousLust)
		mod_luck += SexLibs.get_stat_with_lustf("luck", CurrentLust, PreviousLust)
		
		for skill in custom_skills.keys():
			custom_skills[skill] += SexLibs.get_stat_with_lustf(skill, CurrentLust, PreviousLust) 


func custom_skill_update(SkillName: String) -> void:
	if enabled:
		if SkillName in custom_skills:
			_prev_skill_value = custom_skills[SkillName]["skill"]
			if custom_skills[SkillName]["max-skill"] < custom_skills[SkillName]["base-skill"]:
				custom_skills[SkillName]["base-skill"] = custom_skills[SkillName]["max-skill"]
			custom_skills[SkillName]["skill"] = maxi(ActorLibs.calculate_stati(custom_skills[SkillName]["base-skill"], custom_skills[SkillName]["mod-skill"], custom_skills[SkillName]["mult-skill"]), 0)
			skill_updated.emit(SkillName, _prev_skill_value, custom_skills[SkillName]["skill"], )

