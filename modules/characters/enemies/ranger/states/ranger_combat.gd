class_name RangerCombat
extends RangerState
	

const MIN_DISTANCE_FROM_PLAYER : int = 150
const MAX_DISTANCE_FROM_PLAYER : int = 200

@onready var action_timer : Timer = $ActionTimer

func physics_update(delta):
	var target : Vector2
	var direction = ranger.player.global_position.direction_to(ranger.global_position)
	var dist_to_player = ranger.global_position.distance_to(ranger.player.global_position)
	if dist_to_player < MIN_DISTANCE_FROM_PLAYER:
		target = ranger.player.global_position + (direction * MIN_DISTANCE_FROM_PLAYER)
	elif dist_to_player > MAX_DISTANCE_FROM_PLAYER:
		target = ranger.player.global_position + (direction * MAX_DISTANCE_FROM_PLAYER)
	if target:
		ranger.pathfinding_component.set_target_position(target)
		ranger.pathfinding_component.follow_path()
		ranger.velocity_component.move(ranger)
		if !action_timer.is_stopped():
			action_timer.stop()
	elif action_timer.is_stopped():
		action_timer.start()


func _on_action_timer_timeout():
	ranger.state_machine.change_state("RangerExecutingAction")
	await ranger.snipe.execute()
	await get_tree().create_timer(ranger.ACTION_COOLDOWN).timeout
	ranger.state_machine.change_state("RangerCombat")
