class_name TestEnemyAction
extends Node2D


var test_enemy : TestEnemy

func _ready():
	await owner.ready
	test_enemy = owner as TestEnemy

func execute():
	print("Missing override of execute method, idiot")
