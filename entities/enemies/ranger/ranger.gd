class_name Ranger
extends Enemy


@onready var action_timer : Timer = $ActionTimer

@export var min_dist_from_player : int
@export var max_dist_from_player : int
@export var action_delay : float

func _ready():
	super()
	action_timer.wait_time = action_delay

func enter_combat_state():
	super()
	action_timer.start()

func take_damage(amount):
	super(amount)
	stats.hp = clamp(stats.hp - amount, 0, stats.max_hp)
	emit_signal("health_changed", stats.hp)
	if stats.hp == 0:
		die()
	else:
		is_invincible = true
		await get_tree().create_timer(stats.invincible_time).timeout
		is_invincible = false

func _on_hurtbox_area_entered(area):
	if is_invincible == false:
		super(area)
		take_damage(area.damage)

func die():
	super()
	queue_free()

func _on_action_timer_timeout():
	state_machine.change_state("EnemyCombat/EnemyExecutingAction")
	var action = actions[randi_range(0, actions.size() - 1)]
	await action.execute()
	action_timer.start()
	state_machine.change_state("EnemyCombat/EnemyMoving")
