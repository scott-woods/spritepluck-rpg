extends Enemy


func _unhandled_input(event):
	if event.is_action_pressed("tab"):
		emit_signal("player_spotted")
