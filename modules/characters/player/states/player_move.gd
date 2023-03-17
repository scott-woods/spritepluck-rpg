class_name PlayerMove
extends PlayerState


func begin(params := {}):
	pass

func physics_update(delta):
#	var input_direction = Vector2(
#		Input.get_axis("left", "right"),
#		Input.get_axis("up", "down")
#	)
#
#	if input_direction != Vector2.ZERO:
#		player.interact_ray.rotation = input_direction.angle()
#		player.last_direction = input_direction
#	player.direction = input_direction
#	var target_velocity = player.direction * player.stats.speed
#	if player.direction.x != 0 and player.direction.y != 0:
#		target_velocity = target_velocity / sqrt(2)
#	player.velocity = target_velocity
#
#	player.move_and_slide()
	
	player.direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	if player.direction != Vector2.ZERO:
		player.interact_ray.rotation = player.direction.angle()
		player.last_direction = player.direction
		if player.direction.x != 0 and player.direction.y != 0:
			player.velocity = player.direction.normalized() * player.stats.speed
		else:
			player.velocity = player.direction * player.stats.speed
	else:
		player.velocity = Vector2.ZERO
#		player.velocity.x = move_toward(player.velocity.x, 0, player.stats.speed)
#		player.velocity.y = move_toward(player.velocity.y, 0, player.stats.speed)
		pass	
	
	
	player.move_and_slide()
	
#	if player.direction.x != 0 and player.direction.y != 0:
#		if player.direction.x > 0:
#			player.global_position.x = ceilf(player.global_position.x)
#		elif player.direction.x < 0:
#			player.global_position.x = floorf(player.global_position.x)
#		if player.direction.y > 0:
#			player.global_position.y = ceilf(player.global_position.y)
#		elif player.direction.y < 0:
#			player.global_position.y = floorf(player.global_position.y)
#	else:
#		player.global_position = player.global_position.round()
	
#	if direction.length() > 1:
#		direction = direction.normalized()
#
#	player.animation_tree.set("parameters/Walk/blend_position", direction)
#
#	if direction != Vector2.ZERO:
#		player.velocity = direction * player.stats.speed
#	else:
#		player.velocity.x = move_toward(player.velocity.x, 0, player.stats.speed)
#		player.velocity.y = move_toward(player.velocity.y, 0, player.stats.speed)
#
#	player.move_and_slide()
	
#	var x_direction = Input.get_axis("ui_left", "ui_right")
#	var y_direction = Input.get_axis("ui_up", "ui_down")
#	var direction = Vector2(x_direction, y_direction).normalized()
#	if direction != Vector2.ZERO:
#		player.interact_ray.rotation = direction.angle()
#		player.last_direction = direction
#	player.direction = direction
#	var target_velocity = player.direction * player.stats.speed
#	if x_direction != 0 and y_direction != 0:
#		target_velocity = target_velocity / sqrt(2)
##	player.velocity += (target_velocity - player.velocity) * player.FRICTION
#	player.velocity = target_velocity
#
#	player.move_and_slide()

func handle_input(event: InputEvent):
	#interact with NPCs or environment
	if event.is_action_pressed("accept") and player.interact_ray.is_colliding():
		state_machine.change_state("PlayerIdle")
		var interactable = player.interact_ray.get_collider() as Interactable
		interactable.interact()
		await interactable.interaction_finished
		state_machine.change_state("PlayerMove")

func end():
	player.velocity = Vector2.ZERO
