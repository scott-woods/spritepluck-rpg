class_name Snipe
extends RangerAction


@export var RangerBullet : PackedScene

@onready var delay_timer : Timer = $DelayTimer

func execute():
	delay_timer.start()
	await delay_timer.timeout
	var bullet = RangerBullet.instantiate()
	add_child(bullet)
	var direction = ranger.global_position.direction_to(ranger.player.hurtbox.global_position).normalized()
	bullet.fire(direction)
