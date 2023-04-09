class_name RadialShot
extends TestEnemyAction


@export var TestEnemyBullet : PackedScene

var radius = 48

func execute():
	for i in 12:
		var angle = deg_to_rad(30 * i)
		var pos_offset = Vector2(radius * cos(angle), radius * sin(angle))
		var bullet = TestEnemyBullet.instantiate()
		add_child(bullet)
		bullet.global_position += pos_offset
		bullet.fire(Vector2.from_angle(angle).normalized())
