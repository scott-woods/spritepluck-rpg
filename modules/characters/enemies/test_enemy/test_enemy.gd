class_name TestEnemy
extends Enemy


@onready var action_timer : Timer = $ActionTimer

@export var action_delay : float

func enter_combat_state():
	super()
	action_timer.wait_time = action_delay + randf_range(-.5, .5)
	action_timer.start()


func _on_action_timer_timeout():
	state_machine.change_state("EnemyCombat/EnemyExecutingAction")
	var action = actions[randi_range(0, actions.size() -1)]
	await action.execute()
	action_timer.wait_time = action_delay + randf_range(-.5, .5)
	action_timer.start()
	state_machine.change_state("EnemyCombat")
