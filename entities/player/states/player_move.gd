class_name PlayerMove
extends PlayerState


func begin(params := {}):
	pass

func update(delta):
	var x_direction = Input.get_axis("ui_left", "ui_right")
	var y_direction = Input.get_axis("ui_up", "ui_down")
	player.velocity = Vector2(x_direction, y_direction) * player.stats.speed
		
	player.move_and_slide()
