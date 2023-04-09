class_name MeleeSwipe
extends EnemyAction


const DELAY_TIME : float = .5
const SWING_SPEED : float = .1
var speed : float = .1

@onready var melee_path : Path2D = $MeleePath
@onready var melee_path_follow : PathFollow2D = $MeleePath/MeleePathFollow
@onready var melee : Hitbox = $MeleePath/MeleePathFollow/Melee

func execute():
	melee.show()
	var dir_to_player = enemy.global_position.direction_to(enemy.player.global_position)
	melee_path.rotate(deg_to_rad(rad_to_deg(dir_to_player.angle())))
	await get_tree().create_timer(DELAY_TIME).timeout
	melee.enable()
	var tween = create_tween()
	tween.tween_property(melee_path_follow, "progress_ratio", 1, SWING_SPEED)
	await tween.finished
	await reset()

func reset():
	melee.hide()
	melee.disable()
	melee_path.rotation_degrees = 0
	melee_path_follow.progress_ratio = 0
