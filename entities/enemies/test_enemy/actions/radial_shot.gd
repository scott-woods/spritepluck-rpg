extends EnemyAction


const TestEnemyBullet = preload("res://entities/enemies/test_enemy/test_enemy_bullet.tscn")

var radius = 48

func execute():
	for i in 12:
		var angle = deg_to_rad(30 * i)
		var pos_offset = Vector2(radius * cos(angle), radius * sin(angle))
		var bullet = TestEnemyBullet.instantiate()
		bullet.global_position = enemy.global_position + pos_offset
		bullet.fire(Vector2.from_angle(angle).normalized())
		add_child(bullet)
