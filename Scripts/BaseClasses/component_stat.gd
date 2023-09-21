class_name ComponentStat
extends Node
## A component that holds a statistic information.

## Emitted when the current_value == min_value.
signal stat_depleted(node_ref)
## Emited when current_value is changed.
signal stat_changed(node_ref)
## Emited when current_value == max_value.
signal stat_maxed(node_ref)

## Emited when the max value is changed
signal max_updated(node_ref)
## Emited when the min value is changed
signal min_updated(node_ref)

@export var stat_name: String = ""
## How low the value will go
@export var _min_value: float = 0.0
## The current value. It's set to max_value on ready
@export var current_value: float = 0.0
## How high the value will go
@export var _max_value: float = 0.0

@export_group("Options")
## When changing values the decimal will be removed and the value rounded.
## Only works when changing via functions.
@export var cancel_decimals: bool = false
## This will round the value towards a direction when max is calculated and
## changes are made. Only works if cancel_decimals is enabled. Dynamic
## rounds down when < 0.5 and up when >= 0.5
@export_enum("Down", "Dynamic", "Up") var value_rounding = 0
## If this is set to true any reduction to current_state will be prevented.
## Additions are still possible.
@export var is_protected: bool = false
## If this is set to true any change to current_state will be prevented.
@export var is_unchanging: bool = false

## The total min value after rounding.
var min_value: float = 0.0 :
	set(new_min):
		previous_min_value = min_value
		min_value = new_min
## The total max value after rounding.
var max_value: float = 0.0 :
	set(new_max):
		previous_max_value = max_value
		max_value = new_max


## A value to change the max_value by
var mod_value: float = 0.0:
	set(new_mod):
		mod_value = new_mod
		__max_value_update()
## A percentage of max_stat to add.
var stat_overflow: float = 0.0:
	set(new_overflow):
		stat_overflow = max(new_overflow, -1.0)

# Previous values
var previous_current_value: float = 0.0
var previous_max_value: float = 0.0
var previous_min_value: float = 0.0


## Sets the current stat to the max value
func restore_stat() -> void:
	current_value = max_value


## Changes the current amount by a specified amount. 
## It respects the cancel_decimals setting
func change_current(amount_to_change: float) -> void:
	if amount_to_change == 0:
		return
	
	if (is_protected and amount_to_change < 0) or is_unchanging:
		return
	
	current_value += get_rounded(amount_to_change)
	__current_value_update()


## Adds the specified amount to the mod_value. The mod value adds to the
## max_value only. After adding it triggers an update
func change_mod(value_to_mod: float) -> void:
	mod_value = get_rounded(value_to_mod)


## Sets the max value to the value given
func set_max(max_change: float) -> void:
	if max_change == 0.0:
		return
	
	_max_value = max_change
	__max_value_update()

## Sets the min value to the value given
func set_min(min_change: float) -> void:
	if min_change == 0.0:
		return
	
	_min_value = min_change
	__min_value_update()


func set_overflow(new_overflow: float) -> void:
	stat_overflow = new_overflow
	__max_value_update()


## Returns a rounded value respecting the options set for the component
func get_rounded(value: float) -> float:
	if not cancel_decimals:
		return value

	if value_rounding == 0:
		return floorf(value)
	elif value_rounding == 1:
		return roundf(value)
	else:
		return ceilf(value)


## Returns a float (0.0 <-> 1.0) representing the percentage current_value
## is in between the range of min_value and max_value. Snap_step snaps the
## float to the multiple that is the closest to the value.
func get_current_percentage(snap_step: float = 0.01) -> float:
	return snappedf(
			absf(current_value) / (absf(min_value) + absf(max_value)),
			snap_step)


## Private function. No need to call or override
func __min_value_update() -> void:
	min_value = get_rounded(_min_value)
	
	if current_value < min_value:
		current_value = min_value
		__current_value_update()
	if max_value < min_value:
		max_value = min_value
		max_updated.emit(self)
	min_updated.emit(self)


## Private function. No need to call or override
func __current_value_update() -> void:
	stat_changed.emit(self)
	
	if current_value == min_value:
		stat_depleted.emit(self)
	elif current_value == max_value:
		stat_maxed.emit(self)


## Private function. No need to call or override
func __max_value_update() -> void:
	max_value = maxf(
			min_value, 
			(get_rounded(_max_value) + get_rounded(mod_value)) * stat_overflow)
	
	if max_value < current_value:
		current_value = max_value
		__current_value_update()
	max_updated.emit(self)

