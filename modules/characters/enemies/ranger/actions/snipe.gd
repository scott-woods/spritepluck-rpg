class_name Snipe
extends EnemyAction


@export var RangerBullet : PackedScene

@onready var delay_timer : Timer = $DelayTimer

func execute():
	delay_timer.start()
	await delay_timer.timeout
	var bullet = RangerBullet.instantiate()
	bullet.position = enemy.position
	add_child(bullet)
	var direction = enemy.position.direction_to(enemy.player.hurtbox.global_position).normalized()
	bullet.fire(direction)
