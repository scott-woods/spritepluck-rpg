extends EnemyAction


var speed : float = .1

func execute():
	enemy.melee.show()
	var dir_to_player = enemy.position.direction_to(enemy.player.position)
	enemy.melee_path.rotate(deg_to_rad(rad_to_deg(dir_to_player.angle())))
	await get_tree().create_timer(.5).timeout
	enemy.melee.collision.disabled = false
	var tween = create_tween()
	tween.tween_property(enemy.melee_path_follow, "progress_ratio", 1, speed)
	await tween.finished
	enemy.melee.hide()
	enemy.melee.collision.disabled = true
	enemy.melee_path.rotation_degrees = 0
	enemy.melee_path_follow.progress_ratio = 0
#	var init_angle = deg_to_rad(rad_to_deg(dir_to_player.angle()) - 75)
#	var end_angle = deg_to_rad(rad_to_deg(dir_to_player.angle()) + 75)
#	var init_pos = Vector2(reach * cos(init_angle), reach * sin(init_angle))
#	var end_pos = Vector2(reach * cos(end_angle), reach * sin(end_angle))
#	var center_angle = enemy.position.direction_to(enemy.player.position).angle()
#	enemy.melee.rotation_degrees = rad_to_deg(direction.angle()) + 90
#	enemy.melee.position += direction * reach
#	await get_tree().create_timer(5).timeout
