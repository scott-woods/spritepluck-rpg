class_name PlayerIdle
extends PlayerState


func begin(params := {}):
	player.velocity = Vector2.ZERO
	match player.last_direction:
		Vector2(1, 0), Vector2(1, 1), Vector2(1, -1):
			player.sprite.play("IDLE_RIGHT")
		Vector2(-1, 0), Vector2(-1, 1), Vector2(-1, -1):
			player.sprite.play("IDLE_LEFT")
		Vector2(0, 1):
			player.sprite.play("IDLE_DOWN")
		Vector2(0, -1):
			player.sprite.play("IDLE_UP")
