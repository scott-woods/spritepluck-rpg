class_name Ranger
extends Enemy


@onready var action_timer : Timer = $ActionTimer

@export var min_dist_from_player : int
@export var max_dist_from_player : int

const BASE_ACTION_TIMER_WAIT_TIME : float = 3
const ACTION_TIMER_VARIANCE : float = 1

func enter_combat_state():
	super()
	randomize_action_timer()
	action_timer.start()

func randomize_action_timer():
	action_timer.wait_time = BASE_ACTION_TIMER_WAIT_TIME
	action_timer.wait_time += randf_range(-ACTION_TIMER_VARIANCE, ACTION_TIMER_VARIANCE)


func _on_action_timer_timeout():
	state_machine.change_state("EnemyCombat/EnemyExecutingAction")
	var action = actions[randi_range(0, actions.size() - 1)]
	await action.execute()
	randomize_action_timer()
	action_timer.start()
	state_machine.change_state("EnemyCombat/EnemyMoving")
