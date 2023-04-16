class_name TestEnemyCombat
extends TestEnemyState


@onready var action_timer : Timer = $ActionTimer

func begin(params := {}):
	action_timer.wait_time = randf_range(2, 4)
	action_timer.start()


func _on_action_timer_timeout():
	test_enemy.state_machine.change_state("TestEnemyExecutingAction")
	await test_enemy.radial_shot.execute()
	await get_tree().create_timer(test_enemy.ACTION_COOLDOWN).timeout
	test_enemy.state_machine.change_state("TestEnemyCombat")
