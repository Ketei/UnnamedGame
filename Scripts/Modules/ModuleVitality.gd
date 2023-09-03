## Used to track all vitality, sexual and combat related data along with effects.
## When the module is disabled, most set()'s won't work and effects timers will pause,
## but get()'s will remain functional.
extends Module
class_name ModuleVitality

## If a resource is loaded, the respective object will be created and values set
## to those of the resource. An effect applier will ONLY be created if at least
## one resource exists
@export var _vitality_resource: ResourceHealth
@export var _skill_resource: ResourceSkill
@export var _combat_resource: ResourceCombat
@export var _lewd_resource: ResourceHorny

var effect_applier: ModuleEffectApplier

var health_module: VitalityHealth
var skill_module: VitalitySkill
var combat_module: VitalityCombat
var sex_module: VitalityHorny


func _ready():
	module_priority = 1
	module_type = "vitality"


func full_restore():
	if is_module_enabled:
		if health_module:
			health_module.full_restore()
		if sex_module:
			sex_module.full_restore()


func set_up_module():
	if _vitality_resource:
		health_module = VitalityHealth.new()
		health_module.base_health = _vitality_resource.health
		health_module.base_stamina = _vitality_resource.stamina
		health_module.base_mana = _vitality_resource.mana
		health_module.change_self_with_lust = _vitality_resource.change_self_with_lust
		health_module.changed_health.connect(changed_health)
		health_module.changed_stamina.connect(changed_stamina)
		health_module.changed_mana.connect(changed_mana)
	
	if _skill_resource:
		skill_module = VitalitySkill.new()
		skill_module.max_strength = _skill_resource.max_strength
		skill_module.base_strenght = _skill_resource.starting_strenght
		skill_module.max_endurance = _skill_resource.max_endurance
		skill_module.base_endurance = _skill_resource.starting_endurance
		skill_module.max_charisma = _skill_resource.max_charisma
		skill_module.base_charisma = _skill_resource.starting_charisma
		skill_module.max_intelligence = _skill_resource.max_intelligence
		skill_module.base_intelligence = _skill_resource.starting_intelligence
		skill_module.max_luck = _skill_resource.max_luck
		skill_module.base_luck = _skill_resource.starting_luck
		skill_module.change_self_with_lust = _skill_resource.change_self_with_lust
		for skill_name in _skill_resource.custom_skills.keys():
			skill_create_custom_skill(skill_name)
			skill_custom_skill_set_value(skill_name, "max-skill", _skill_resource.custom_skills[skill_name])
		skill_module.skill_updated.connect(_changed_skill)
	
	if _combat_resource:
		combat_module = VitalityCombat.new()
		combat_module.resistances = _combat_resource.resistances.duplicate()
		combat_module.affinities = _combat_resource.affinities.duplicate()
		combat_module.base_defense_physical = _combat_resource.defense_physical
		combat_module.base_defense_magical = _combat_resource.defense_magical
		combat_module.change_self_with_lust = _combat_resource.change_self_with_lust
	
	if _lewd_resource:
		sex_module = VitalityHorny.new()
		sex_module.max_sex_skill_anal = _lewd_resource.max_skill_anal
		sex_module.max_sex_skill_oral = _lewd_resource.max_skill_oral
		sex_module.max_sex_skill_penis = _lewd_resource.max_skill_penis
		sex_module.max_sex_skill_vaginal = _lewd_resource.max_skill_vaginal
		
		sex_module.base_sex_skill_anal = _lewd_resource.skill_anal
		sex_module.base_sex_skill_oral = _lewd_resource.skill_oral
		sex_module.base_sex_skill_penis = _lewd_resource.skill_penis
		sex_module.base_sex_skill_vaginal = _lewd_resource.skill_vaginal
		
		sex_module.max_lust = _lewd_resource.max_lust
		sex_module.lust = _lewd_resource.lust
		
		sex_module.can_orgasm = _lewd_resource.can_orgasm
		sex_module.max_arousal = _lewd_resource.max_arousal
		sex_module.max_sexual_endurance = _lewd_resource.sexual_endurance
		
		sex_module.actor_sex_role = _lewd_resource.actor_sex_role
		sex_module.change_self_with_lust = _lewd_resource.change_self_with_lust
		
		sex_module.base_sex_limit_break = _lewd_resource.sex_limit_break
		
		sex_module.changed_arousal.connect(changed_arousal)
		sex_module.changed_cum_meter.connect(changed_cum_meter)
		sex_module.changed_sex_limit_break.connect(changed_sex_limit_break)
		sex_module.changed_lust.connect(_changed_lust)

	full_restore()
	
	if module_manager.has_module("effect-applier"):
		effect_applier = module_manager.get_module("effect-applier")
	elif health_module or skill_module or combat_module or sex_module:
		effect_applier = ModuleEffectApplier.new()
		module_manager.register_module(effect_applier)
		self.add_child(effect_applier)
	
	is_module_enabled = true


func _module_enabled_override(Value: bool) -> void:
	effect_applier._timer_module_enabled(Value)
	if health_module:
		health_module.is_module_enabled = Value
	if skill_module:
		skill_module.is_module_enabled = Value
	if combat_module:
		combat_module.is_module_enabled = Value
	if sex_module:
		sex_module.is_module_enabled = Value
	is_module_enabled = Value


## Override this function to do custom stuff when signaled
## Function executed when health or max health changes
func changed_health(_CurrentValue: int, _MaxValue: int) -> void:
	pass


## Override this function to do custom stuff when signaled
## Function executed when mana or max mana changes
func changed_mana(_CurrentValue: int, _MaxValue: int) -> void:
	pass


## Override this function to do custom stuff when signaled
## Function executed when stamina or max stamina changes
func changed_stamina(_CurrentValue: int, _MaxValue: int) -> void:
	pass


func changed_arousal(_CurrentValue: int, _MaxValue: int) -> void:
	pass


## When cum_meter (current value == max value) an orgasm should be triggered.
## Don't forget to also run sex_module.cum() to update arousal values and orgasm counter
func changed_cum_meter(_CurrentValue: int, _MaxValue: int) -> void:
	pass


func changed_sex_limit_break(_CurrentValue: int, _MaxValue: int) -> void:
	pass


# Note that this doesn't get MaxLust value. Might change in the future
func chaged_lust(_CurrentValue: int, _PreviousValue: int) -> void:
	pass


# Do not override. Use the one without _ instead. If you do override be sure to run the appropiate
# functions.
func _changed_lust(CurrentValue: int, PreviousValue: int) -> void:
	if health_module:
		if health_module.change_self_with_lust:
			health_module.trigger_lust_stats_change(CurrentValue, PreviousValue)
	
	if skill_module:
		if skill_module.change_self_with_lust:
			skill_module.trigger_lust_stats_change(CurrentValue, PreviousValue)
	
	if combat_module:
		if combat_module.change_self_with_lust:
			combat_module.trigger_lust_stats_change(CurrentValue, PreviousValue)
	
	chaged_lust(CurrentValue, PreviousValue)


func _changed_skill(SkillName: String, SkillValue: int, PreviousSkillValue) -> void:
	var _skill_apply: Dictionary = GameProperties.get_skill_effects(SkillName, SkillValue, PreviousSkillValue)
	
	for skill_change in _skill_apply.keys():
		if health_module:
			if skill_change == "health":
				health_module.skill_health += _skill_apply[skill_change]
			elif skill_change == "stamina":
				health_module.skill_stamina += _skill_apply[skill_change]
			elif skill_change == "mana":
				health_module.skill_mana += _skill_apply[skill_change]
		
		if sex_module:
			if skill_change == "sex-skill-penis":
				sex_module.skill_sex_skill_penis += _skill_apply[skill_change]
			elif skill_change == "sex-skill-oral":
				sex_module.skill_sex_skill_oral += _skill_apply[skill_change]
			elif skill_change == "sex-skill-anal":
				sex_module.skill_sex_skill_anal += _skill_apply[skill_change]
			elif skill_change == "sex-skill-vaginal":
				sex_module.skill_sex_skill_vaginal += _skill_apply[skill_change]
			elif skill_change == "sex-damage-dealt": # float
				sex_module.skill_sex_damage_dealt += _skill_apply[skill_change]
			elif skill_change == "sex-damage-received": # float
				sex_module.skill_sex_damage_received += _skill_apply[skill_change]
			elif skill_change == "sex-endurance":
				sex_module.skill_sexual_endurance += _skill_apply[skill_change]
			elif skill_change == "sex-limit-break":
				sex_module.skill_sex_limit_break += _skill_apply[skill_change]
		
		if combat_module:
			if skill_change == "damage-physical":
				combat_module.skill_damage_physical += _skill_apply[skill_change]
			elif skill_change == "damage-magical":
				combat_module.skill_damage_magical += _skill_apply[skill_change]
			elif skill_change == "defense-physical":
				combat_module.skill_defense_physical += _skill_apply[skill_change]
			elif skill_change == "defense-magical":
				combat_module.skill_defense_magical += _skill_apply[skill_change]


## Valid ValueType are: base-skill, mod-skill, mult-skill & max-skill
func skill_custom_skill_set_value(SkillName: String, ValueType: String, ModValue: float) -> void:
	if is_module_enabled and skill_module:
		if skill_module.is_module_enabled:
			if skill_module.custom_skills.has(SkillName) and ValueType != "skill":
				if SkillName == "mult-skill":
					skill_module.custom_skills[SkillName][ValueType] = ModValue
				else:
					skill_module.custom_skills[SkillName][ValueType] = int(ModValue)
				skill_module.custom_skill_update(SkillName)
			else:
				print_debug("No custom skill with name " + SkillName + " exists. Please create it first")


func skill_create_custom_skill(SkillName:String) -> void:
	if is_module_enabled and skill_module:
		if skill_module.is_module_enabled:
			if not skill_module.custom_skills.has(SkillName):
				skill_module.custom_skills[SkillName] = {
					"base-skill" = 0,
					"mod-skill" = 0,
					"mult-skill" = 1.0,
					"max-skill" = 0,
					"skill" = 0
				}


func skill_custom_skill_get_value(SkillName: String) -> int:
	var _return_skill = null
	if skill_module:
		if skill_module.custom_skills.has(SkillName):
			_return_skill = skill_module.custom_skills[SkillName]["skill"]
		else:
			print_debug("Warning: Skill named " + SkillName + " doesn't exist in actor. Returning null")
	else:
		print_debug("Skill module not is_module_enabled. Returning null")

	return _return_skill

