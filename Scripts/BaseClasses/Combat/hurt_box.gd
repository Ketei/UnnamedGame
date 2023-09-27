class_name HurtBox
extends Area2D
## A hurtbox is the area that RECEIVES damage. When a HITBOX enters
## it damage will be triggered.


signal hit_taken()

enum HurtboxType {
	PLAYER, ## The entity is a player
 	NPC, ## The entity is a neutral NPC
	ENEMY, ## The entity is a hostile NPC
	OBJECT ## The entity is an object
	}

@export var module_stats: ModuleStats
## What type of entity is this hurtbox attatched to.
@export var hurtbox_type: HurtboxType

@export_group("Invincibility")
@export var invincibility_time: float = 1.0

var invis_timer: Timer

## If this is true then the hurtbox won't register any hitboxes
## that enter it. Basically disabling on-hit effects.
var is_invincible: bool = false


func _ready():
	self.area_entered.connect(hit_triggered)
	self.monitorable = false
	QuickConfig.disable_object_collision_bits(self, true)
	QuickConfig.set_object_collision_bit([7], self, false)
	
	invis_timer = Timer.new()
	invis_timer.wait_time = invincibility_time
	invis_timer.autostart = false
	invis_timer.one_shot = true
	invis_timer.timeout.connect(__invincibility_timeout)
	self.add_child(invis_timer)

## Overridable function called when a hitbox enters the hurtbox.
## Can be used to apply visual effects.
func _hit() -> void:
	pass


## Function called when a hitbox enters the hurtbox. It also calls
## the hitbox hit_area method.
func hit_triggered(area: HitBox) -> void:
	if not can_be_hit(area) or not module_stats or is_invincible:
		return
	
	for stat_target in area.stat_changes.keys():
		if module_stats.has_stat(stat_target):
			module_stats.get_stat(stat_target).change_current(
					area.stat_changes[stat_target])
	
	_hit()
	area._hit_triggered()
	hit_taken.emit()

	is_invincible = true
	invis_timer.start()
	

func set_invincibility_frames(new_time: float) -> void:
	invincibility_time = maxf(new_time, 0.1)
	if invis_timer:
		invis_timer.wait_time = new_time


func can_be_hit(hit_box:HitBox) -> bool:
	if hurtbox_type == HurtboxType.PLAYER and hit_box.hit_players:
		return true
	elif hurtbox_type == HurtboxType.NPC and hit_box.hit_npcs:
		return true
	elif hurtbox_type == HurtboxType.ENEMY and hit_box.hit_enemies:
		return true
	elif hurtbox_type == HurtboxType.OBJECT and hit_box.hit_objects:
		return true
	else:
		return false


func __invincibility_timeout() -> void:
	is_invincible = false
	if has_overlapping_areas():
		hit_triggered(
				__pick_overlaping_area(
						get_overlapping_areas()))
		

func __pick_overlaping_area(area_array: Array) -> HitBox:
	var _prio: int = -1
	var _area: HitBox
	
	for hit_box in area_array:
		if _prio < hit_box.hit_type:
			_prio = hit_box.hit_type
			_area = hit_box
		elif _prio == hit_box.hit_type:
			if bool(randi_range(0,1)):
				_area = hit_box
	
	return _area

