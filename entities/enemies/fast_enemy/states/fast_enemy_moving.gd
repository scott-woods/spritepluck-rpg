class_name FastEnemyMoving
extends EnemyMoving


func update(delta):
	var dist_from_player = enemy.global_position.distance_to(enemy.player.global_position)
	if dist_from_player <= 32:
		enemy.execute_action()
		return

func update_target():
	var target = enemy.player.global_position
	if target == Vector2.ZERO:
		target = Vector2.ONE
	enemy.navigation_agent.target_position = target
