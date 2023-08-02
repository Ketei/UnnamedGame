extends Node
class_name EffectApplier

var _vitality_module: ModuleVitality

var previous_availabe_ids: Array = []
var max_effect_id: int = 0

# effectID(String): effect(Effect)
var current_effects: Dictionary = {}
# Contains strings only. Has the key values of current_effects
var _effect_keys: Array = []

var timer_manager: ModuleTimersManager


func _ready():
	timer_manager = ModuleTimersManager.new()
	self.add_child(timer_manager)
	timer_manager.connect("timer_ended", _effect_timer_end)


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


func add_effect(NewEffect: Effect, HasTimer := false, EffectTime := 1.0):
	var effect_id: String = _get_next_id()
	current_effects[effect_id] = NewEffect
	NewEffect.start_effect(_vitality_module, effect_id)
	
	_effect_keys = current_effects.keys()
	
	if HasTimer:
		timer_manager.create_timer(effect_id, EffectTime)


func remove_effect(EffectId: String) -> void:
	if EffectId in current_effects:
		previous_availabe_ids.append(EffectId)
		current_effects[EffectId]._end_effect()
		current_effects.erase(EffectId)
		_effect_keys = current_effects.keys()


func _effect_timer_end(EffectId: String) -> void:
	remove_effect(EffectId)


func _physics_process(delta):
	for effect in _effect_keys:
		current_effects[effect]._apply_effect(delta)

