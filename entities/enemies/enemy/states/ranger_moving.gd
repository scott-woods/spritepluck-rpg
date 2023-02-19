class_name RangerMoving
extends EnemyMoving


func _ready():
	super()
	navigation_timer.timeout.connect(_on_timer_timeout)

func begin(params := {}):
	await get_tree().physics_frame
	update_target()
	navigation_timer.start()

func update(delta):
	pass

func physics_update(delta):
	if enemy.navigation_agent.is_navigation_finished():
		return
	
	var current_pos = enemy.global_position
	var next_path_pos = enemy.navigation_agent.get_next_path_position()
	
	var new_velocity = next_path_pos - current_pos
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * enemy.stats.speed
	
	enemy.navigation_agent.set_velocity(new_velocity)
	var safe_velocity = await enemy.navigation_agent.velocity_computed
	enemy.velocity = safe_velocity
	
	enemy.move_and_slide()

func update_target():
	var direction = enemy.player.global_position.direction_to(enemy.global_position)
	var target = enemy.player.global_position + (direction * enemy.max_dist_from_player)
	enemy.navigation_agent.target_position = target


func _on_timer_timeout():
	update_target()
