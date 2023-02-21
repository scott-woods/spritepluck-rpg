class_name Ranger
extends Enemy


@onready var action_timer : Timer = $ActionTimer

@export var min_dist_from_player : int
@export var max_dist_from_player : int

func enter_combat_state():
	super()
	action_timer.start()


func _on_action_timer_timeout():
	state_machine.change_state("EnemyCombat/EnemyExecutingAction")
	var action = actions[randi_range(0, actions.size() - 1)]
	await action.execute()
	action_timer.start()
	state_machine.change_state("EnemyCombat/EnemyMoving")
