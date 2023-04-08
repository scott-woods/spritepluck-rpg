class_name FastEnemy
extends Enemy


@onready var sprite : Sprite2D = $Sprite
@onready var hurtbox : Hurtbox = $Hurtbox
@onready var collision : CollisionShape2D = $Collision
@onready var melee_path : Path2D = $MeleePath
@onready var melee_path_follow : PathFollow2D = $MeleePath/MeleePathFollow
@onready var melee : Hitbox = $MeleePath/MeleePathFollow/Melee
@onready var melee_swipe : EnemyAction = $Actions/MeleeSwipe

@export var action_cooldown : float

func execute_action():
	state_machine.change_state("EnemyCombat/EnemyExecutingAction")
	await melee_swipe.execute()
	await get_tree().create_timer(action_cooldown).timeout
	state_machine.change_state("EnemyCombat/EnemyMoving")
