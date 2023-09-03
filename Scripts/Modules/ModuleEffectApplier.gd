extends Module
class_name ModuleEffectApplier

var previous_availabe_ids: Array = []
var max_effect_id: int = 0

# effectID(String): effect(Effect)
var current_effects: Dictionary = {}
# Contains strings only. Has the key values of current_effects
var _effect_keys: Array[String] = []

var timer_manager: ModuleTimersManager

# module_manager


func _ready():
	module_type = "effect-applier"
	module_priority = 0


func set_up_module():
	timer_manager = ModuleTimersManager.new()
	self.add_child(timer_manager)
	timer_manager.connect("timer_ended", _effect_timer_end)
	is_module_enabled = true


func _get_next_id() -> String:
	var return_id: String = ""
	
	if 0 < previous_availabe_ids.size():
		return_id = previous_availabe_ids.pop_back()
	else:
		return_id = str(max_effect_id)
		max_effect_id += 1
		
	return return_id


func _timer_module_enabled(IsEnabled: bool) -> void:
	timer_manager.enabled = IsEnabled


func add_effect(NewEffect: Effect, EffectTime : float = 0.0):
	NewEffect.target_manager = module_manager
	
	if not NewEffect.one_shot:
		var effect_id: String = _get_next_id()
		current_effects[effect_id] = NewEffect
		_effect_keys.append(effect_id)
		NewEffect.start_effect()

		if 0 < EffectTime:
			timer_manager.create_timer(effect_id, EffectTime)
	else:
		NewEffect.start_effect()
		NewEffect.end_effect()


func remove_effect(EffectId: String) -> void:
	if current_effects.has(EffectId):
		previous_availabe_ids.append(EffectId)
		current_effects[EffectId].end_effect()
		current_effects.erase(EffectId)
		
		QuickMath.erase_array_element(EffectId, _effect_keys)


func _effect_timer_end(EffectId: String) -> void:
	remove_effect(EffectId)


func module_physics_process(delta):
	for effect in _effect_keys:
		current_effects[effect].apply_effect(delta)

