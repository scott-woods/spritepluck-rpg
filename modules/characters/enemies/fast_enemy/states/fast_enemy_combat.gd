class_name FastEnemyCombat
extends FastEnemyState


func physics_update(delta):
	try_to_attack()
	var target = fast_enemy.player.global_position
	fast_enemy.pathfinding_component.set_target_position(target)
	fast_enemy.pathfinding_component.follow_path()
	fast_enemy.velocity_component.move(fast_enemy)

func try_to_attack() -> void:
	var dist_from_player = fast_enemy.global_position.distance_to(fast_enemy.player.global_position)
	if dist_from_player <= 32:
		fast_enemy.state_machine.change_state("FastEnemyExecutingAction")
		await fast_enemy.melee_swipe.execute()
		await get_tree().create_timer(fast_enemy.ACTION_COOLDOWN).timeout
		fast_enemy.state_machine.change_state("FastEnemyCombat")

#func update(delta):
#	var dist_from_player = enemy.global_position.distance_to(enemy.player.global_position)
#	if dist_from_player <= 32:
#		enemy.execute_action()
#		return

#func update_target():
#	var target = enemy.player.global_position
#	if target == Vector2.ZERO:
#		target = Vector2.ONE
#	enemy.navigation_agent.target_position = target
