class_name RangerCombat
extends RangerState
	

const MIN_DISTANCE_FROM_PLAYER : int = 150
const MAX_DISTANCE_FROM_PLAYER : int = 225

@onready var action_timer : Timer = $ActionTimer

var original_speed : int

func _ready():
	super()
	await owner.ready
	original_speed = ranger.velocity_component.speed

func physics_update(delta):
	var target : Vector2
	var direction = ranger.player.global_position.direction_to(ranger.global_position)
	var dist_to_player = ranger.global_position.distance_to(ranger.player.global_position)
	if dist_to_player < MIN_DISTANCE_FROM_PLAYER:
		target = ranger.player.global_position + (direction * MIN_DISTANCE_FROM_PLAYER)
	elif dist_to_player > MAX_DISTANCE_FROM_PLAYER:
		target = ranger.player.global_position + (direction * MAX_DISTANCE_FROM_PLAYER)
	if target:
		ranger.velocity_component.speed = original_speed
		if !action_timer.is_stopped():
			action_timer.stop()
	else:
		var valid_target : bool = false
		while valid_target == false:
			var rand_dir = Vector2.from_angle(deg_to_rad(randi_range(0, 360)))
			target = ranger.global_position + (rand_dir * 25)
			if target.distance_to(Game.player.global_position) > MAX_DISTANCE_FROM_PLAYER:
				valid_target = false
			elif target.distance_to(Game.player.global_position) < MIN_DISTANCE_FROM_PLAYER:
				valid_target = false
			else:
				valid_target = true
		ranger.velocity_component.speed = original_speed / 2
		if action_timer.is_stopped():
			action_timer.start()
	ranger.pathfinding_component.set_target_position(target)
	ranger.pathfinding_component.follow_path()
	ranger.velocity_component.move(ranger)


func _on_action_timer_timeout():
	ranger.state_machine.change_state("RangerExecutingAction")
	await ranger.snipe.execute()
	await get_tree().create_timer(ranger.ACTION_COOLDOWN).timeout
	ranger.state_machine.change_state("RangerCombat")
