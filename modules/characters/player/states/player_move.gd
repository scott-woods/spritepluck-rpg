class_name PlayerMove
extends PlayerState


func begin(params := {}):
	pass

func physics_update(delta):
	var x_direction = Input.get_axis("ui_left", "ui_right")
	var y_direction = Input.get_axis("ui_up", "ui_down")
	var direction = Vector2(x_direction, y_direction)
	if direction != Vector2.ZERO:
		player.interact_ray.rotation = direction.angle()
		player.last_direction = direction
	player.direction = direction
	var target_velocity = player.direction * player.stats.speed
	if x_direction != 0 and y_direction != 0:
		target_velocity = target_velocity / sqrt(2)
	player.velocity += (target_velocity - player.velocity) * player.FRICTION
	#player.velocity = player.direction * player.stats.speed
		
	player.move_and_slide()

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
