class_name FastEnemy
extends Enemy


@onready var melee_path : Path2D = $MeleePath
@onready var melee_path_follow : PathFollow2D = $MeleePath/MeleePathFollow
@onready var melee : Hitbox = $MeleePath/MeleePathFollow/Melee
@onready var melee_swipe : EnemyAction = $Actions/MeleeSwipe

@export var action_cooldown : float
	
func enter_combat_state():
	super()

func take_damage(amount):
	super(amount)
	stats.hp -= amount
	if stats.hp <= 0:
		stats.hp = 0
	emit_signal("health_changed", stats.hp)
	if stats.hp == 0:
		die()
	else:
		is_invincible = true
		await get_tree().create_timer(stats.invincible_time).timeout
		is_invincible = false
		
func die():
	super()
	queue_free()

func execute_action():
	state_machine.change_state("EnemyCombat/EnemyExecutingAction")
	await melee_swipe.execute()
	await get_tree().create_timer(action_cooldown).timeout
	state_machine.change_state("EnemyCombat/EnemyMoving")

func _on_hurtbox_area_entered(area):
	if is_invincible == false:
		super(area)
		take_damage(area.damage)
