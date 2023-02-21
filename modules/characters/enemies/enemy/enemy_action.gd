class_name EnemyAction
extends Node


var enemy : Enemy

func _ready():
	await owner.ready
	enemy = owner as Enemy

func execute():
	print("Missing override of execute method, idiot")
