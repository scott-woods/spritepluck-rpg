class_name PlayerExecutingActions
extends PlayerState


func begin(params := {}):
	player.collision.set_deferred("disabled", true)
	player.hurtbox.set_deferred("monitoring", false)

func end():
	player.collision.set_deferred("disabled", false)
	await get_tree().create_timer(1).timeout
	player.hurtbox.set_deferred("monitoring", true)
