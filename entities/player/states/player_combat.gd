class_name PlayerCombat
extends PlayerMove


func handle_input(event: InputEvent):
	if event.is_action_pressed("accept"):
		player.drop_utility()
	if event.is_action_pressed("utility"):
		player.toggle_utility()
	if event.is_action_pressed("ui_cancel"):
		player.state_machine.change_state("PlayerMove/PlayerCombat/PlayerReflecting")
