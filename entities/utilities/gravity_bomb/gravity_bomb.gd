class_name GravityBomb
extends StaticBody2D


signal trigger_completed

const label = "Gravity Bomb"
const TIME : float = .5
const PULL_SPEED : float = 200

@onready var effect_area : Area2D = $EffectArea

@export var time : float
@export var max_pull_distance : float

var player : Player
var queued = false
var projected_player_position : Vector2
var moves_player : bool = false

func init(player : Player):
	self.player = player

func trigger():
	var timer = get_tree().create_timer(TIME)
	while timer.time_left > 0:
		var enemies = effect_area.get_overlapping_bodies()
		for enemy in enemies:
			var dir = enemy.position.direction_to(position)
			if enemy.position.distance_to(position) > 0:
				enemy.velocity += dir * PULL_SPEED
				enemy.move_and_slide()
		await get_tree().process_frame
	await get_tree().create_timer(time).timeout
	emit_signal("trigger_completed")
