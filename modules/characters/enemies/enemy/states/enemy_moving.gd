class_name EnemyMoving
extends EnemyCombat


@onready var navigation_timer : Timer = $NavigationTimer

var steering_options = [-.1, .1]

func begin(params := {}):
	await get_tree().physics_frame
	update_target()
	navigation_timer.start()

func physics_update(delta):
	if enemy.navigation_agent.is_navigation_finished():
		return
	
	var next_path_pos = enemy.navigation_agent.get_next_path_position()
	var current_pos = enemy.global_position
	
	var direction = current_pos.direction_to(next_path_pos)
	var desired_velocity = direction * enemy.stats.speed

	enemy.navigation_agent.set_velocity(desired_velocity)

func end():
	navigation_timer.stop()

func update_target():
	push_error("Missing override of update_target method in EnemyMoving state.")


func _on_navigation_timer_timeout():
	update_target()


func _on_navigation_agent_velocity_computed(safe_velocity):
	if safe_velocity.x == 0:
		safe_velocity.x += steering_options.pick_random()
	if safe_velocity.y == 0:
		safe_velocity.y += steering_options.pick_random()
	enemy.velocity = safe_velocity
	enemy.move_and_slide()
