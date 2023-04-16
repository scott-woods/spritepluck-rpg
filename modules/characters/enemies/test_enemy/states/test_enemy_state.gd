class_name TestEnemyState
extends State


var test_enemy : TestEnemy

func _ready():
	await owner.ready
	test_enemy = owner as TestEnemy
