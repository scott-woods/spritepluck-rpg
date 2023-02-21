class_name RangerMoving
extends EnemyMoving


func update_target():
	var direction = enemy.player.global_position.direction_to(enemy.global_position)
	var target = enemy.player.global_position + (direction * enemy.max_dist_from_player)
	enemy.navigation_agent.target_position = target
