## Used to track all vitality, sexual and combat related data along with effects.
## When the module is disabled, most set()'s won't work and effects timers will pause,
## but get()'s will remain functional.
extends Module
class_name ModuleVitality

## If a resource is loaded, the respective object will be created and values set
## to those of the resource. An effect applier will ONLY be created if at least
## one resource exists
@export var _vitality_resource: ResourceVitality
@export var _skill_resource: ResourceSkill
@export var _lewd_resource: ResourceHorny

var effect_applier: EffectApplier

var health_module: VitalityHealth
var skill_module: VitalitySkill
var sex_module: VitalityHorny


func full_restore():
	if enabled:
		if health_module:
			health_module.full_restore()
		if sex_module:
			sex_module.full_restore()


func set_up_module():
	module_type = "vitality"
	if _vitality_resource:
		health_module = VitalityHealth.new()
		health_module.base_health = _vitality_resource.health
		health_module.base_stamina = _vitality_resource.stamina
		health_module.base_mana = _vitality_resource.mana
		health_module.connect("depleted_health", health_depleted)
		health_module.connect("depleted_stamina", stamina_depleted)
		health_module.connect("depleted_mana", mana_depleted)
	
	if _skill_resource:
		skill_module = VitalitySkill.new()
		skill_module.base_strenght = _skill_resource.strenght
		skill_module.base_endurance = _skill_resource.endurance
		skill_module.base_charisma = _skill_resource.charisma
		skill_module.base_intelligence = _skill_resource.intelligence
		skill_module.base_luck = _skill_resource.luck
	
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
		
		sex_module.connect("orgasm_signal", trigger_orgasm)
		
		sex_module.update_all_sex_stats()
	
	full_restore()
	
	if health_module or skill_module or sex_module:
		effect_applier = EffectApplier.new()
		effect_applier._vitality_module = self
		self.add_child(effect_applier)
	
	enabled = true


func _module_enabled_override(Value: bool) -> void:
	effect_applier._timer_module_enabled(Value)
	if health_module:
		health_module.enabled = Value
	if skill_module:
		skill_module.enabled = Value
	if sex_module:
		sex_module.enabled = Value
	enabled = Value


## Override this function to do custom stuff when signaled
## Function executed when health on health module reaches 0
func health_depleted() -> void:
	pass


## Override this function to do custom stuff when signaled
## Function executed when mana on health module reaches 0
func mana_depleted() -> void:
	pass


## Override this function to do custom stuff when signaled
## Function executed when stamina on health module reaches 0
func stamina_depleted() -> void:
	pass


## Override this function to do custom stuff when signaled
## Function executed when cum bar reaches 100. Don't forget to also run
## sex_module.cum() to update arousal values and orgasm counter
func trigger_orgasm() -> void:
	pass
