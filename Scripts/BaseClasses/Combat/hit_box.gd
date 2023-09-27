class_name HitBox
extends Area2D
## A hurtbox is the area that DEALS damage. When a HITBOX enters
## a HURTBOX damage will be triggered.

enum HitType {
	WEAPON = 2, ## Melee weapons
	PROJECTILE = 0, ## Projectiles
	HAZZARD = 3, ## Dangerous terrain/traps
	TERRAIN = 1, ## Non-dangerous terrain/traps 
	ONE_SHOT = 4, ## Insta-killing hits
	}

## The hit type this hitbox will use.
@export var hit_type: HitType = HitType.WEAPON


## The stats that this hitbox will affect and by how much.
@export var stat_changes: Dictionary = {}

## Choose what types of entities will this hitbox affect
@export_group("Targets")
@export var hit_players: bool = false
@export var hit_npcs: bool = false
@export var hit_enemies: bool = false
@export var hit_objects: bool = false


func _ready():
	# Hitboxes don't need to check if something entered them. 
	# That's hurtboxes
	self.monitoring = false
	QuickConfig.set_object_collision_bit([7], self)
	QuickConfig.disable_object_collision_bits(self, false)

#{PLAYER, NPC, ENEMY, OBJECT}

## Function that triggers when the projectile hits a hurtbox.
func _hit_triggered() -> void:
	pass
