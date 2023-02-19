class_name FastEnemyMoving
extends EnemyMoving


func _ready():
	super()
	navigation_timer.timeout.connect(_on_timer_timeout)

func begin(params := {}):
	await get_tree().physics_frame
	update_target()
	navigation_timer.start()

func update(delta):
	var dist_from_player = enemy.global_position.distance_to(enemy.player.global_position)
	if dist_from_player <= 32:
		enemy.execute_action()
		return

func physics_update(delta):
	if enemy.navigation_agent.is_navigation_finished():
		return

	
	var next_path_pos = enemy.navigation_agent.get_next_path_position()
	var current_pos = enemy.global_position
	
	var new_velocity = (next_path_pos - current_pos).normalized() * enemy.stats.speed
	enemy.navigation_agent.set_velocity(new_velocity)
	var safe_velocity = await enemy.navigation_agent.velocity_computed
	enemy.velocity = safe_velocity
	enemy.move_and_slide()
	
#	var current_agent_position : Vector2 = enemy.global_position
#	var next_path_position : Vector2 = enemy.navigation_agent.get_next_path_position()
#
#	var new_velocity : Vector2 = next_path_position - current_agent_position
#	new_velocity = new_velocity.normalized()
#	new_velocity = new_velocity * enemy.stats.speed
#
#	enemy.navigation_agent.set_velocity(new_velocity)
#	var computed_velocity = await enemy.navigation_agent.velocity_computed
#	enemy.velocity = computed_velocity
#
#	enemy.move_and_slide()
		
#	var dir = enemy.navigation_agent.get_next_path_position().direction_to(enemy.position)
#	enemy.velocity = dir * enemy.stats.speed
#	if enemy.position.distance_to(enemy.player.position) <= 32:
#		enemy.execute_action()
#	enemy.move_and_slide()
	
#	var direction = (enemy.player.global_position - enemy.global_position).normalized()
#	enemy.velocity = direction * enemy.stats.speed
#	var dist_from_player = enemy.position.distance_to(enemy.player.position)
#	if dist_from_player <= 32:
#		enemy.execute_action()
#	super(delta)

func end():
	navigation_timer.stop()

func update_target():
	var target = enemy.player.global_position
	if target == Vector2.ZERO:
		target = Vector2.ONE
	enemy.navigation_agent.target_position = target

func _on_timer_timeout():
	update_target()
