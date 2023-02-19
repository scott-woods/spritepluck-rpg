class_name PlayerReflecting
extends PlayerCombat


func begin(params := {}):
	player.sprite.modulate = Color.PURPLE
	await get_tree().create_timer(player.stats.reflection_time).timeout
	player.sprite.modulate = Color.WHITE
	player.state_machine.change_state("PlayerMove/PlayerCombat")

func _unhandled_input(event):
	pass

func update(delta):
	pass
