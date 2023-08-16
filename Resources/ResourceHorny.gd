extends Resource
class_name ResourceHorny

@export var actor_sex_role: ActorProperties.SexRole = ActorProperties.SexRole.TOP

@export_group("Properties")
@export var lust: int = 0
@export var max_lust: int = 1
@export var arousal: int = 0
@export var max_arousal: int = 1
@export var can_orgasm: bool = true
## If true then stats will change depending on the lust amounts. Check ActorProperties
## to see what stats will be changed
@export var change_self_with_lust: bool = true
@export var sexual_endurance: int = 0

@export_group("Sex Skills")
@export var skill_penis: int = 0
@export var max_skill_penis: int = 0
@export var skill_anal: int = 0
@export var max_skill_anal: int = 0
@export var skill_oral: int = 0
@export var max_skill_oral: int = 0
@export var skill_vaginal: int = 0
@export var max_skill_vaginal: int = 0

@export_group("Sex Abilities")
## Used to exectue a highly damaging lewd skill
var sex_limit_break: int = 1
